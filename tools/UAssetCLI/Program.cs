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
using UAssetAPI.UnrealTypes;

class Program
{
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
        var asset = new UAsset(path, EngineVersion.VER_UE4_27);
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
            var asset = new UAsset(path, EngineVersion.VER_UE4_27);
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
}
