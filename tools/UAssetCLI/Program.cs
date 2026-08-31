// UAssetCLI: 通用 uasset 解析器(基于 UAssetAPI)。
// 读取 UE4.27 的 .uasset/.uexp，支持两类导出：
//  A) 字节码调用解析：解析各 FunctionExport 的 ScriptBytecode(Kismet 表达式树)，
//     提取其中所有函数调用(EX_FinalFunction / EX_CallMath)的函数名与参数常量。
//  B) FModel 式整体 JSON：用 SerializeJson 导出整个资产(imports/exports/属性/函数体)，
//     与 FModel 的 JSON 导出同构，可直接用于比对/查看游戏数据。
//
// 两种运行模式：
//  1) server 模式(供 step3 流水线调用，stdio JSON 行协议)：
//     从 stdin 读一行一个 JSON 命令，向 stdout 写一行 JSON 响应：
//       {"cmd":"parse","path":"<文件>"}         -> {"ok":true,"result":{函数: [调用...]}}
//       {"cmd":"parse_dir","path":"<目录>"}      -> {"ok":true,"result":{"Files":{文件名: {...}}}}
//       {"cmd":"export","path":"<文件>"}         -> {"ok":true,"result":<FModel 式整体 JSON>}
//       {"cmd":"export_dir","path":"<目录>"[, "out":"<输出目录>"]}
//         - 带 out：把每个资产的 JSON 写入 <out>/<文件名>.json，返回统计(建议大目录用)
//         - 不带 out：内联返回 {"Files":{文件名: 整体 JSON}}
//       {"cmd":"fmodel","path":"<文件>","package":"<包路径>"[, "mount":"EM/Content"]}
//         -> {"ok":true,"result":[FModel Output/Exports 数组格式...]}（地图导出用）
//       {"cmd":"fmodel_dir","path":"<目录>","root":"<Exports根>"[, "mount":"EM/Content"]}
//         -> {"ok":true,"result":{"Files":{包路径: [数组...]}}}（递归）
//       {"cmd":"shutdown"}                       -> {"ok":true,"closed":true} 后退出
//  2) 一次性模式：UAssetCLI <文件|目录>  直接打印解析结果(字节码)后退出。
//     UAssetCLI export <文件|目录> 直接打印 FModel 式整体 JSON 后退出。
//
// 字节码调用汇总结构(通用，不做游戏语义过滤)：
//   { "Function": "<函数名>", "IntParams": [int...], "AllParams": [参数摘要...] }
// "IntParams" 是参数里的整数常量(可能含 buff id / 枚举 / 层数等)，由调用方按需解释。
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using Newtonsoft.Json.Linq;
using UAssetAPI;
using UAssetAPI.ExportTypes;
using UAssetAPI.Kismet;
using UAssetAPI.Kismet.Bytecode;
using UAssetAPI.Kismet.Bytecode.Expressions;
using UAssetAPI.PropertyTypes.Objects;
using UAssetAPI.PropertyTypes.Structs;
using UAssetAPI.UnrealTypes;
using UAssetAPI.Unversioned;

class Program
{
    private static Usmap? mappings;
    private static bool mappingsLoaded;

    static Usmap? GetMappings()
    {
        if (mappingsLoaded) return mappings;
        mappingsLoaded = true;
        var unpackDir = Environment.GetEnvironmentVariable("DNA_UNPACK_DIR");
        if (string.IsNullOrWhiteSpace(unpackDir) || !Directory.Exists(unpackDir)) return null;
        var path = Directory.EnumerateFiles(unpackDir, "*.usmap", SearchOption.TopDirectoryOnly).OrderBy(x => x).FirstOrDefault();
        if (path == null) return null;
        mappings = new Usmap(path);
        return mappings;
    }

    static UAsset ReadAsset(string path)
    {
        return new UAsset(path, EngineVersion.VER_UE4_27, GetMappings());
    }

    static int Main(string[] args)
    {
        if (args.Length > 0 && args[0] == "server")
            return RunServer();
        if (args.Length > 1 && args[0] == "export")
        {
            // 一次性 FModel 式整体 JSON 导出
            if (File.Exists(args[1]))
            {
                var r = ExportFile(args[1]);
                if (r.ok) Console.WriteLine(r.json.ToString(Newtonsoft.Json.Formatting.Indented));
                else { Console.Error.WriteLine("导出失败: " + r.error); return 1; }
            }
            else if (Directory.Exists(args[1]))
            {
                Console.WriteLine(ExportDirectory(args[1]).ToString(Newtonsoft.Json.Formatting.Indented));
            }
            else
            {
                Console.Error.WriteLine("路径不存在: " + args[1]);
                return 1;
            }
            return 0;
        }
        if (args.Length > 0)
        {
            var root = new JObject();
            if (Directory.Exists(args[0]))
                root["Files"] = ParseDirectory(args[0]);
            else if (File.Exists(args[0]))
                root["File"] = ParseFile(args[0]);
            else
            {
                Console.Error.WriteLine("路径不存在: " + args[0]);
                return 1;
            }
            Console.WriteLine(root.ToString(Newtonsoft.Json.Formatting.Indented));
            return 0;
        }
        Console.Error.WriteLine("用法: UAssetCLI server | export <文件|目录> | <uasset文件|目录>");
        return 1;
    }

    // ---------- server 模式 ----------
    static int RunServer()
    {
        Console.InputEncoding = Encoding.UTF8;
        Console.OutputEncoding = Encoding.UTF8;
        string line;
        while ((line = Console.ReadLine()) != null)
        {
            if (string.IsNullOrWhiteSpace(line)) continue;
            JObject reply;
            try
            {
                var req = JObject.Parse(line);
                var cmd = (string)req["cmd"];
                switch (cmd)
                {
                    case "shutdown":
                        reply = new JObject { ["ok"] = true, ["closed"] = true };
                        WriteLine(reply);
                        return 0;
                    case "parse_dir":
                        reply = new JObject
                        {
                            ["ok"] = true,
                            ["result"] = new JObject { ["Files"] = ParseDirectory((string)req["path"]) },
                        };
                        break;
                    case "parse":
                        reply = new JObject
                        {
                            ["ok"] = true,
                            ["result"] = new JObject { ["File"] = ParseFile((string)req["path"]) },
                        };
                        break;
                    case "export":
                        // FModel 式整体 JSON(单文件)
                        var er = ExportFile((string)req["path"]);
                        if (er.ok)
                            reply = new JObject { ["ok"] = true, ["result"] = er.json };
                        else
                            reply = new JObject { ["ok"] = false, ["error"] = er.error };
                        break;
                    case "export_dir":
                        // FModel 式整体 JSON(目录)；带 out 时写文件而非内联返回
                        var outDir = (string)req["out"];
                        if (!string.IsNullOrWhiteSpace(outDir))
                            reply = new JObject
                            {
                                ["ok"] = true,
                                ["result"] = ExportDirectoryToFiles((string)req["path"], outDir),
                            };
                        else
                            reply = new JObject
                            {
                                ["ok"] = true,
                                ["result"] = new JObject { ["Files"] = ExportDirectory((string)req["path"]) },
                            };
                        break;
                    case "fmodel":
                        // FModel Output/Exports 数组格式(地图导出用，package 由调用方给出)
                        try
                        {
                            var pkg = (string)req["package"];
                            if (string.IsNullOrWhiteSpace(pkg))
                                pkg = Path.GetFileNameWithoutExtension((string)req["path"]);
                            var mount = (string)req["mount"];
                            if (string.IsNullOrWhiteSpace(mount))
                                mount = "EM/Content";
                            reply = new JObject
                            {
                                ["ok"] = true,
                                ["result"] = ExportFileFModel((string)req["path"], pkg, mount),
                            };
                        }
                        catch (Exception e)
                        {
                            reply = new JObject { ["ok"] = false, ["error"] = e.Message };
                        }
                        break;
                    case "fmodel_dir":
                        // 递归导出目录下所有 uasset 为 FModel 数组格式，key 为相对 root 的包路径
                        try
                        {
                            var rootDir = (string)req["root"] ?? "";
                            var mountD = (string)req["mount"];
                            if (string.IsNullOrWhiteSpace(mountD))
                                mountD = "EM/Content";
                            reply = new JObject
                            {
                                ["ok"] = true,
                                ["result"] = new JObject { ["Files"] = ExportDirectoryFModel((string)req["path"], rootDir, mountD) },
                            };
                        }
                        catch (Exception e)
                        {
                            reply = new JObject { ["ok"] = false, ["error"] = e.Message };
                        }
                        break;
                    default:
                        reply = new JObject { ["ok"] = false, ["error"] = "未知命令: " + cmd };
                        break;
                }
            }
            catch (Exception e)
            {
                reply = new JObject { ["ok"] = false, ["error"] = e.Message };
            }
            WriteLine(reply);
        }
        return 0;
    }

    static void WriteLine(JObject obj)
    {
        Console.WriteLine(obj.ToString(Newtonsoft.Json.Formatting.None));
        Console.Out.Flush();
    }

    // ---------- 解析 ----------
    static JObject ParseDirectory(string dir)
    {
        var files = Directory.GetFiles(dir, "*.uasset");
        Array.Sort(files);
        var outObj = new JObject();
        foreach (var file in files)
            outObj[Path.GetFileName(file)] = ParseFile(file);
        return outObj;
    }

    static JObject ParseFile(string path)
    {
        var asset = ReadAsset(path);
        var calls = new JObject(); // 函数名 -> [调用汇总...]
        foreach (var ex in asset.Exports)
        {
            if (!(ex is FunctionExport fe)) continue;
            string funcName;
            try { funcName = fe.ObjectName.ToString(); }
            catch { continue; }

            var summary = new JArray();
            if (fe.ScriptBytecode != null && fe.ScriptBytecode.Length > 0)
            {
                foreach (var e in fe.ScriptBytecode)
                    WalkOne(e, asset, summary);
            }
            calls[funcName] = summary;
        }
        return calls;
    }

    // 通用递归：收集所有函数调用(EX_FinalFunction / EX_CallMath)
    static void WalkOne(KismetExpression e, UAsset asset, JArray outCalls)
    {
        if (e == null) return;

        if (e is EX_FinalFunction ff)
        {
            outCalls.Add(BuildCallJson(ResolveStackNode(ff.StackNode, asset), ff.Parameters, asset));
            foreach (var p in ff.Parameters ?? Array.Empty<KismetExpression>())
                WalkOne(p, asset, outCalls);
            return;
        }
        if (e is EX_CallMath cm)
        {
            outCalls.Add(BuildCallJson(ResolveStackNode(cm.StackNode, asset), cm.Parameters, asset));
            foreach (var p in cm.Parameters ?? Array.Empty<KismetExpression>())
                WalkOne(p, asset, outCalls);
            return;
        }

        foreach (var sub in ChildExpressions(e))
            WalkOne(sub, asset, outCalls);
    }

    static JObject BuildCallJson(string fname, KismetExpression[] parameters, UAsset asset)
    {
        var jo = new JObject();
        jo["Function"] = fname;
        var ints = new JArray();
        var all = new JArray();
        foreach (var p in parameters ?? Array.Empty<KismetExpression>())
        {
            var desc = DescribeParam(p, asset);
            all.Add(desc);
            if (TryGetIntValue(p, out var v))
                ints.Add(v);
        }
        jo["IntParams"] = ints;
        jo["AllParams"] = all;
        return jo;
    }

    static object DescribeParam(KismetExpression e, UAsset asset)
    {
        if (e == null) return "null";
        if (TryGetIntValue(e, out var v)) return v;
        if (e is EX_InstanceVariable iv) return "InstanceVariable:" + ResolvePropertyName(iv.Variable, asset);
        if (e is EX_LocalVariable lv) return "LocalVariable:" + ResolvePropertyName(lv.Variable, asset);
        if (e is EX_ObjectConst oc) return "ObjectConst:" + ResolveObjectConst(oc, asset);
        if (e is EX_NameConst nc) return "NameConst:" + SafeStr(nc.GetObject<FName>());
        if (e is EX_Self) return "Self";
        if (e is EX_StringConst sc) return "String:" + SafeStr(sc.GetObject<string>());
        if (e is EX_NoObject) return "NoObject";
        if (e is EX_Context ctx) return "Context(" + DescribeParam(ctx.ObjectExpression, asset) + ")";
        return e.Inst;
    }

    static bool TryGetIntValue(KismetExpression e, out int v)
    {
        v = 0;
        try
        {
            if (e is EX_IntConst ic) { v = ic.GetObject<int>(); return true; }
            if (e is EX_IntConstByte icb) { v = icb.GetObject<byte>(); return true; }
        }
        catch { }
        return false;
    }

    static string ResolveStackNode(FPackageIndex idx, UAsset asset)
    {
        try
        {
            if (idx.IsImport()) return idx.ToImport(asset).ObjectName.ToString();
            if (idx.IsExport()) return idx.ToExport(asset).ObjectName.ToString();
        }
        catch { }
        return idx.ToString();
    }

    static string ResolvePropertyName(KismetPropertyPointer ptr, UAsset asset)
    {
        if (ptr == null) return "?";
        if (ptr.Old != null && !ptr.Old.IsNull())
            return ResolveStackNode(ptr.Old, asset);
        return SafeStr(ptr.New);
    }

    static string ResolveObjectConst(EX_ObjectConst oc, UAsset asset)
    {
        try
        {
            var idx = oc.GetObject<FPackageIndex>();
            return idx == null ? "?" : ResolveStackNode(idx, asset);
        }
        catch { return "?"; }
    }

    static string SafeStr(object v)
    {
        try { return v?.ToString() ?? "?"; } catch { return "?"; }
    }

    // 提取可能包含子表达式的属性，供递归
    static IEnumerable<KismetExpression> ChildExpressions(KismetExpression e)
    {
        var list = new List<KismetExpression>();
        switch (e)
        {
            case EX_Context c:
                Add(c.ObjectExpression);
                Add(c.ContextExpression);
                break;
            case EX_SwitchValue sv:
                Add(sv.IndexTerm);
                Add(sv.DefaultTerm);
                foreach (var cs in sv.Cases ?? Array.Empty<FKismetSwitchCase>())
                {
                    Add(cs.CaseIndexValueTerm);
                    Add(cs.CaseTerm);
                }
                break;
            case EX_Let lb:
                Add(lb.Variable);
                Add(lb.Expression);
                break;
            case EX_ArrayGetByRef ag:
                Add(ag.ArrayVariable);
                Add(ag.ArrayIndex);
                break;
            case EX_ComputedJump cj:
                Add(cj.CodeOffsetExpression);
                break;
        }
        void Add(KismetExpression x) { if (x != null) list.Add(x); }
        return list;
    }

    // ---------- FModel 式整体 JSON 导出 ----------
    static (bool ok, JToken json, string error) ExportFile(string path)
    {
        try
        {
            var asset = ReadAsset(path);
            var json = JObject.Parse(asset.SerializeJson());
            // 去掉 UAssetAPI round-trip 元数据($type/$id/$ref)，得到干净的 FModel 式 JSON
            StripTypeAnnotations(json);
            return (true, json, null);
        }
        catch (Exception e)
        {
            return (false, null, e.Message);
        }
    }

    static void StripTypeAnnotations(JToken node)
    {
        if (node is JObject obj)
        {
            obj.Remove("$type");
            obj.Remove("$id");
            obj.Remove("$ref");
            foreach (var child in obj.Properties().ToList())
                StripTypeAnnotations(child.Value);
        }
        else if (node is JArray arr)
        {
            foreach (var child in arr)
                StripTypeAnnotations(child);
        }
    }

    static JObject ExportDirectory(string dir)
    {
        var files = Directory.GetFiles(dir, "*.uasset");
        Array.Sort(files);
        var outObj = new JObject();
        foreach (var file in files)
        {
            var r = ExportFile(file);
            outObj[Path.GetFileName(file)] = r.ok ? (JToken)r.json : new JObject { ["error"] = r.error };
        }
        return outObj;
    }

    // 把目录下每个资产的整体 JSON 写入 <out>/<文件名>.json，返回统计(避免超大单行响应)
    static JObject ExportDirectoryToFiles(string dir, string outDir)
    {
        Directory.CreateDirectory(outDir);
        var files = Directory.GetFiles(dir, "*.uasset");
        Array.Sort(files);
        var stats = new JObject { ["exported"] = 0, ["failed"] = 0, ["failed_files"] = new JArray() };
        foreach (var file in files)
        {
            var name = Path.GetFileNameWithoutExtension(file);
            var r = ExportFile(file);
            if (r.ok)
            {
                File.WriteAllText(
                    Path.Combine(outDir, name + ".json"),
                    r.json.ToString(Newtonsoft.Json.Formatting.Indented),
                    new UTF8Encoding(false));
                stats["exported"] = (int)stats["exported"] + 1;
            }
            else
            {
                stats["failed"] = (int)stats["failed"] + 1;
                ((JArray)stats["failed_files"]).Add(new JObject { ["file"] = Path.GetFileName(file), ["error"] = r.error });
            }
        }
        return stats;
    }

    // ---------- FModel Output/Exports 数组格式（地图导出用） ----------
    // 与 FModel 在 Exports 目录下导出的 JSON 同构：顶层数组，每项含
    // Type/Name/Flags/Class/Outer/Properties（引用为 {ObjectName, ObjectPath}）。
    // 例: WBP_Map_Reg_Chapter01_KK.json 的结构。
    static JArray ExportFileFModel(string path, string package, string mount)
    {
        var asset = ReadAsset(path);
        var arr = new JArray();
        for (int i = 0; i < asset.Exports.Count; i++)
            arr.Add(BuildObjectJson(asset, asset.Exports[i], i, package, mount));
        return arr;
    }

    // 递归导出目录下所有 uasset（含子目录），key 为相对 root 的包路径
    static JObject ExportDirectoryFModel(string dir, string root, string mount)
    {
        var files = Directory.GetFiles(dir, "*.uasset", SearchOption.AllDirectories);
        Array.Sort(files);
        var outObj = new JObject();
        foreach (var file in files)
        {
            string pkg;
            if (!string.IsNullOrEmpty(root))
            {
                var rel = Path.GetRelativePath(root, file).Replace('\\', '/');
                pkg = rel.EndsWith(".uasset") ? rel.Substring(0, rel.Length - ".uasset".Length) : rel;
            }
            else
            {
                pkg = Path.GetFileNameWithoutExtension(file);
            }
            try
            {
                outObj[pkg] = ExportFileFModel(file, pkg, mount);
            }
            catch (Exception e)
            {
                outObj[pkg] = new JObject { ["error"] = e.Message };
            }
        }
        return outObj;
    }

    // 单个 export 的类名（Type 字段）：类为导出时取其 ObjectName，为导入时取导入 ObjectName
    static string TypeName(Export ex, UAsset asset)
    {
        try
        {
            if (ex.ClassIndex.IsImport()) return SafeStr(ex.ClassIndex.ToImport(asset).ObjectName);
            if (ex.ClassIndex.IsExport()) return SafeStr(ex.ClassIndex.ToExport(asset).ObjectName);
        }
        catch { }
        try { return SafeStr(ex.GetExportClassType()); } catch { }
        return SafeStr(ex.ObjectName);
    }

    // 递归拼 import 的完整路径（含自身 ObjectName），如 /Game/UI/.../WBP_Map_Reg_Chapter01_KK
    static string ImportPath(UAsset asset, Import im, int depth = 0)
    {
        if (depth > 16) return SafeStr(im.ObjectName);
        try
        {
            if (im.OuterIndex.IsImport())
            {
                var parent = im.OuterIndex.ToImport(asset);
                var pp = ImportPath(asset, parent, depth + 1);
                if (string.IsNullOrEmpty(pp)) return SafeStr(im.ObjectName);
                return pp + "/" + SafeStr(im.ObjectName);
            }
        }
        catch { }
        return SafeStr(im.ObjectName);
    }

    // /Game/xxx -> mount/xxx（Duet Night Abyss 的 /Game 挂载到 EM/Content）
    static string MountPath(string path, string mount)
    {
        if (string.IsNullOrEmpty(mount)) return path;
        if (path.StartsWith("/Game/"))
            return mount.TrimEnd('/') + "/" + path.Substring("/Game/".Length);
        return path;
    }

    // export 的完整对象路径：ClassName:outer1.outer2.name（如 WBP_Map_Reg_Chapter01_KK_C:WidgetTree.Main）
    static string ExportObjectPath(Export ex, UAsset asset)
    {
        var names = new List<string>();
        Export cur = ex;
        while (true)
        {
            try
            {
                if (cur.OuterIndex.IsNull()) break;
                if (!cur.OuterIndex.IsExport()) break;
                names.Insert(0, SafeStr(cur.ObjectName));
                cur = cur.OuterIndex.ToExport(asset);
            }
            catch { break; }
        }
        if (names.Count == 0) return SafeStr(ex.ObjectName);
        string root;
        if (SafeStr(cur.ObjectName).StartsWith("Default__") && cur.ClassIndex.IsExport())
            root = SafeStr(cur.ClassIndex.ToExport(asset).ObjectName);
        else
            root = SafeStr(cur.ObjectName);
        return root + ":" + string.Join(".", names);
    }

    // 类字符串：UScriptClass'CanvasPanel' / WidgetBlueprintGeneratedClass'<包>.<名>'
    static string ClassString(Export ex, UAsset asset, string package, string mount)
    {
        try
        {
            if (ex.ClassIndex.IsImport())
            {
                var im = ex.ClassIndex.ToImport(asset);
                if (im.ClassName.ToString() == "Class")
                    return "UScriptClass'" + SafeStr(im.ObjectName) + "'";
                // BP 类导入：Class 字段用包路径（不含类对象名）+ 类名
                var full = ImportPath(asset, im);
                int slash = full.LastIndexOf('/');
                var pkgPath = slash > 0 ? full.Substring(0, slash) : full;
                return SafeStr(im.ClassName) + "'" + MountPath(pkgPath, mount) + "." + SafeStr(im.ObjectName) + "'";
            }
            if (ex.ClassIndex.IsExport())
            {
                var cls = ex.ClassIndex.ToExport(asset);
                string clsType;
                try { clsType = SafeStr(cls.GetExportClassType()); } catch { clsType = SafeStr(cls.ObjectName); }
                return clsType + "'" + package + "." + SafeStr(cls.ObjectName) + "'";
            }
        }
        catch { }
        return "null";
    }

    // 引用 JSON：{ObjectName, ObjectPath}
    static JObject BuildRef(UAsset asset, FPackageIndex idx, string package, string mount)
    {
        if (idx == null || idx.IsNull()) return null;
        try
        {
            if (idx.IsExport())
            {
                var ex = idx.ToExport(asset);
                var jo = new JObject();
                jo["ObjectName"] = TypeName(ex, asset) + "'" + ExportObjectPath(ex, asset) + "'";
                jo["ObjectPath"] = package + "." + (idx.Index - 1);
                return jo;
            }
            if (idx.IsImport())
            {
                var im = idx.ToImport(asset);
                var jo = new JObject();
                if (im.ClassName.ToString() == "Class")
                {
                    // 类引用：Class'Xxx' + 包路径（不带对象名与序号）
                    jo["ObjectName"] = "Class'" + SafeStr(im.ObjectName) + "'";
                    var full = ImportPath(asset, im);
                    int slash = full.LastIndexOf('/');
                    jo["ObjectPath"] = slash > 0 ? full.Substring(0, slash) : full;
                    return jo;
                }
                jo["ObjectName"] = SafeStr(im.ClassName) + "'" + SafeStr(im.ObjectName) + "'";
                // ObjectPath 用 outer 链（包路径，不含导入对象自身名）+ 序号；
                // 常规对象/贴图 = export 0；CDO(Default__*) = export 1
                var fullPath = ImportPath(asset, im);
                int lastSlash = fullPath.LastIndexOf('/');
                var outerPath = lastSlash > 0 ? fullPath.Substring(0, lastSlash) : fullPath;
                string objIndex = SafeStr(im.ObjectName).StartsWith("Default__") ? "1" : "0";
                jo["ObjectPath"] = MountPath(outerPath, mount) + "." + objIndex;
                return jo;
            }
        }
        catch { }
        return null;
    }

    // 顶层对象 JSON
    static JObject BuildObjectJson(UAsset asset, Export ex, int index, string package, string mount)
    {
        var jo = new JObject();
        jo["Type"] = TypeName(ex, asset);
        jo["Name"] = SafeStr(ex.ObjectName);
        jo["Flags"] = SafeStr(ex.ObjectFlags).Replace(",", " |");
        jo["Class"] = ClassString(ex, asset, package, mount);
        if (ex.OuterIndex != null && !ex.OuterIndex.IsNull())
        {
            var outer = BuildRef(asset, ex.OuterIndex, package, mount);
            if (outer != null) jo["Outer"] = outer;
        }
        bool isRoot = ex.OuterIndex == null || ex.OuterIndex.IsNull();
        if (isRoot)
            jo["Package"] = package;
        if (ex is ClassExport ce)
        {
            var ss = BuildRef(asset, ce.SuperStruct, package, mount);
            if (ss != null) jo["SuperStruct"] = ss;
            var cw = BuildRef(asset, ce.ClassWithin, package, mount);
            if (cw != null) jo["ClassWithin"] = cw;
            jo["ClassConfigName"] = SafeStr(ce.ClassConfigName);
            jo["bCooked"] = ce.bCooked;
            jo["ClassFlags"] = SafeStr(ce.ClassFlags);
            var cdo = BuildRef(asset, ce.ClassDefaultObject, package, mount);
            if (cdo != null) jo["ClassDefaultObject"] = cdo;
        }
        else if (ex.TemplateIndex != null && !ex.TemplateIndex.IsNull())
        {
            // 仅 BP 类实例（子 Widget 等）带 Template；原生 Widget/槽位等不加
            bool isBpInstance = ex.ClassIndex.IsImport()
                && ex.ClassIndex.ToImport(asset).ClassName.ToString() != "Class";
            if (isBpInstance)
            {
                var t = BuildRef(asset, ex.TemplateIndex, package, mount);
                if (t != null) jo["Template"] = t;
            }
        }
        if (ex is NormalExport ne)
        {
            if (SafeStr(ex.ObjectName) == "BP_RandomActorDataManager1")
            {
                Console.Error.WriteLine($"DEBUG random data count={ne.Data?.Count}");
                foreach (var p in ne.Data)
                    Console.Error.WriteLine($"DEBUG prop={p?.Name} type={p?.GetType().Name} zero={p?.IsZero}");
            }
            jo["Properties"] = BuildProperties(ne.Data, asset, package, mount);
        }
        return jo;
    }

    static JObject BuildProperties(IEnumerable<PropertyData> data, UAsset asset, string package, string mount)
    {
        var jo = new JObject();
        foreach (var p in data)
        {
            if (p == null) continue;
            var token = PropertyToToken(p, asset, package, mount);
            if (token != null) jo[SafeStr(p.Name)] = token;
        }
        return jo;
    }

    // 单个属性 -> FModel JSON 值
    static JToken PropertyToToken(PropertyData p, UAsset asset, string package, string mount)
    {
        if (p == null || p.IsZero) return null;
        try
        {
            if (p is Vector2DPropertyData v2)
            {
                return new JObject { ["X"] = v2.Value.X, ["Y"] = v2.Value.Y };
            }
            if (p is VectorPropertyData v3)
            {
                return new JObject { ["X"] = v3.Value.X, ["Y"] = v3.Value.Y, ["Z"] = v3.Value.Z };
            }
            if (p is RotatorPropertyData rot)
            {
                return new JObject { ["Pitch"] = rot.Value.Pitch, ["Yaw"] = rot.Value.Yaw, ["Roll"] = rot.Value.Roll };
            }
            if (p is LinearColorPropertyData lc)
            {
                return new JObject
                {
                    ["R"] = lc.Value.R, ["G"] = lc.Value.G, ["B"] = lc.Value.B, ["A"] = lc.Value.A,
                    ["Hex"] = HexFromColor(lc.Value.R, lc.Value.G, lc.Value.B),
                };
            }
            if (p is ColorPropertyData col)
            {
                return new JObject
                {
                    ["R"] = (int)col.Value.R, ["G"] = (int)col.Value.G, ["B"] = (int)col.Value.B, ["A"] = (int)col.Value.A,
                    ["Hex"] = string.Format("{0:X2}{1:X2}{2:X2}", col.Value.R, col.Value.G, col.Value.B),
                };
            }
            if (p is StructPropertyData sp)
                return BuildStruct(sp, asset, package, mount);
            if (p is ObjectPropertyData || p is WeakObjectPropertyData || p is InterfacePropertyData)
            {
                var pi = p.RawValue as FPackageIndex;
                return BuildRef(asset, pi, package, mount);
            }
            if (p is ArrayPropertyData ap)
            {
                var arr = new JArray();
                if (ap.Value is IEnumerable<PropertyData> items)
                    foreach (var item in items)
                    {
                        var t = PropertyToToken(item, asset, package, mount);
                        if (t != null) arr.Add(t);
                    }
                return arr;
            }
            if (p is MapPropertyData mpi)
            {
                // TMap<K,V>：FModel 输出为 [{Key, Value}, ...] 数组（如 RandomActorInfos）
                var mapArr = new JArray();
                try
                {
                    for (int mi = 0; mi < mpi.Value.Count; mi++)
                    {
                        var kv = mpi.Value.GetItem(mi);
                        var pair = new JObject();
                        var kt = PropertyToToken(kv.Key, asset, package, mount);
                        if (kt != null) pair["Key"] = kt;
                        var vt = PropertyToToken(kv.Value, asset, package, mount);
                        if (vt != null) pair["Value"] = vt;
                        mapArr.Add(pair);
                    }
                }
                catch (Exception e)
                {
                    return new JValue("(map-error:" + e.Message + ")");
                }
                return mapArr;
            }
            if (p is EnumPropertyData ep)
                return SafeStr(ep.RawValue);
            if (p is BytePropertyData bp)
            {
                // 字节枚举：FModel 只输出值名（如 HAlign_Center）
                if (bp.ByteType == BytePropertyType.FName)
                    return SafeStr(bp.EnumValue);
                return (int)bp.Value;
            }
            var raw = p.RawValue;
            if (raw is bool || raw is byte || raw is sbyte || raw is short || raw is ushort
                || raw is int || raw is uint || raw is long || raw is ulong
                || raw is float || raw is double || raw is decimal)
                return new JValue(raw);
            if (raw != null)
                return new JValue(SafeStr(raw));
        }
        catch (Exception e)
        {
            return new JValue("(error:" + e.Message + ")");
        }
        return null;
    }

    // struct 属性 -> 嵌套 JSON 对象
    static JObject BuildStruct(StructPropertyData sp, UAsset asset, string package, string mount)
    {
        var jo = new JObject();
        IEnumerable<PropertyData> children = sp.Value as IEnumerable<PropertyData>;
        // 按 StructType 名识别原生 struct（UAssetAPI 会包一层 StructPropertyData，需取其子项）
        switch (SafeStr(sp.StructType))
        {
            case "Vector2D":
                if (children != null)
                    foreach (var c in children)
                        if (c is Vector2DPropertyData v2)
                            return new JObject { ["X"] = v2.Value.X, ["Y"] = v2.Value.Y };
                break;
            case "Vector":
                if (children != null)
                    foreach (var c in children)
                        if (c is VectorPropertyData v3)
                            return new JObject { ["X"] = v3.Value.X, ["Y"] = v3.Value.Y, ["Z"] = v3.Value.Z };
                break;
            case "Rotator":
                if (children != null)
                    foreach (var c in children)
                        if (c is RotatorPropertyData r)
                            return new JObject { ["Pitch"] = r.Value.Pitch, ["Yaw"] = r.Value.Yaw, ["Roll"] = r.Value.Roll };
                break;
            case "LinearColor":
                if (children != null)
                    foreach (var c in children)
                        if (c is LinearColorPropertyData lc)
                            return new JObject
                            {
                                ["R"] = lc.Value.R, ["G"] = lc.Value.G, ["B"] = lc.Value.B, ["A"] = lc.Value.A,
                                ["Hex"] = HexFromColor(lc.Value.R, lc.Value.G, lc.Value.B),
                            };
                break;
            case "Color":
                if (children != null)
                    foreach (var c in children)
                        if (c is ColorPropertyData col)
                            return new JObject
                            {
                                ["R"] = (int)col.Value.R, ["G"] = (int)col.Value.G, ["B"] = (int)col.Value.B, ["A"] = (int)col.Value.A,
                                ["Hex"] = string.Format("{0:X2}{1:X2}{2:X2}", col.Value.R, col.Value.G, col.Value.B),
                            };
                break;
        }
        // 通用：子属性逐个序列化
        if (children != null)
            foreach (var child in children)
            {
                if (child == null) continue;
                var t = PropertyToToken(child, asset, package, mount);
                if (t != null) jo[SafeStr(child.Name)] = t;
            }
        return jo;
    }

    static string HexFromColor(float r, float g, float b)
    {
        return string.Format("{0:X2}{1:X2}{2:X2}",
            Math.Clamp((int)Math.Round(r * 255f), 0, 255),
            Math.Clamp((int)Math.Round(g * 255f), 0, 255),
            Math.Clamp((int)Math.Round(b * 255f), 0, 255));
    }
}
