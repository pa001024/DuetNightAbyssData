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
//       {"cmd":"bytecode","path":"<文件>"}       -> {"ok":true,"result":<类型化字节码文档>}
//         result 含 class/events/variables/components/functions；每个函数保留 opcode、
//         语句字节偏移和基本块，不剥离表达式类型（见 BuildBytecodeResult）。
//       请求可带 "id"（任意 JSON 值），响应原样回传，供并发调用关联请求与响应。
//       {"cmd":"shutdown"}                       -> {"ok":true,"closed":true} 后退出
//  2) 一次性模式：UAssetCLI <文件|目录>  直接打印解析结果(字节码)后退出。
//     UAssetCLI export <文件|目录> 直接打印 FModel 式整体 JSON 后退出。
//     UAssetCLI export --keep-types <文件|目录> 同上，但保留 $type/$id/$ref。
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
using UAssetAPI.FieldTypes;
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
            // 一次性 FModel 式整体 JSON 导出；--keep-types 保留 UAssetAPI round-trip 元数据
            bool keepTypes = args[1] == "--keep-types";
            int argIndex = keepTypes ? 2 : 1;
            if (args.Length <= argIndex)
            {
                Console.Error.WriteLine("用法: UAssetCLI export [--keep-types] <文件|目录>");
                return 1;
            }
            var target = args[argIndex];
            if (File.Exists(target))
            {
                var r = ExportFile(target, keepTypes);
                if (r.ok) Console.WriteLine(r.json.ToString(Newtonsoft.Json.Formatting.Indented));
                else { Console.Error.WriteLine("导出失败: " + r.error); return 1; }
            }
            else if (Directory.Exists(target))
            {
                Console.WriteLine(ExportDirectory(target, keepTypes).ToString(Newtonsoft.Json.Formatting.Indented));
            }
            else
            {
                Console.Error.WriteLine("路径不存在: " + target);
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
        Console.Error.WriteLine("用法: UAssetCLI server | export [--keep-types] <文件|目录> | <uasset文件|目录>");
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
            JToken? reqId = null;
            try
            {
                var req = JObject.Parse(line);
                reqId = req["id"];
                var cmd = (string)req["cmd"];
                switch (cmd)
                {
                    case "shutdown":
                        reply = new JObject { ["ok"] = true, ["closed"] = true };
                        WriteLineWithId(reply, reqId);
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
                    case "bytecode":
                        // 类型化字节码：保留 opcode、语句偏移与基本块（不下钻游戏语义）
                        var bcPath = (string?)req["path"] ?? "";
                        try
                        {
                            reply = new JObject { ["ok"] = true, ["result"] = BuildBytecodeResult(bcPath) };
                        }
                        catch (Exception e)
                        {
                            reply = new JObject { ["ok"] = false, ["error"] = RedactPath(e.Message, bcPath) };
                        }
                        break;
                    case "export":
                        // FModel 式整体 JSON(单文件)
                        var er = ExportFile((string)req["path"], req["keepTypes"]?.Value<bool>() ?? false);
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
            WriteLineWithId(reply, reqId);
        }
        return 0;
    }

    // 请求带 "id" 时原样回传，供调用方在并发请求中关联响应
    static void WriteLineWithId(JObject obj, JToken? id)
    {
        if (id != null) obj["id"] = id.DeepClone();
        WriteLine(obj);
    }

    static void WriteLine(JObject obj)
    {
        Console.WriteLine(obj.ToString(Newtonsoft.Json.Formatting.None));
        Console.Out.Flush();
    }

    // 错误信息里不出现绝对路径（bytecode 输出契约）
    static string RedactPath(string message, string path)
    {
        if (string.IsNullOrEmpty(message) || string.IsNullOrEmpty(path)) return message;
        var name = Path.GetFileName(path);
        return message.Replace(path, name).Replace(path.Replace('\\', '/'), name);
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
        if (idx == null) return "null";
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

    static string SafeStr(object? v)
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

    // ---------- 类型化字节码（bytecode 命令） ----------
    // 输出契约（schemaVersion 1）：
    //   { schemaVersion, asset, class:{name,super,interfaces[]},
    //     events:[{name,target,entryOffset,flags[]}],
    //     variables:[{name,type,struct?,innerType?,enum?,default}],
    //     components:[...],
    //     functions:[{name,flags[],params[],locals[],codeSize,body[],blocks[]} | {name,error}] }
    // body 中每个表达式都带 op（EExprToken 名）与语句/子表达式字节偏移；
    // blocks 的 successors 用 block 索引表达后继，无法落到语句边界的偏移保留 targetOffset。
    // 只输出资产名与对象名，不含文件系统绝对路径。

    static JObject BuildBytecodeResult(string path)
    {
        var asset = ReadAsset(path);
        var root = new JObject
        {
            ["schemaVersion"] = 1,
            ["asset"] = Path.GetFileNameWithoutExtension(path),
            ["class"] = BuildClassInfo(asset),
        };
        var events = new JArray();
        var functions = new JArray();
        foreach (var fe in asset.Exports.OfType<FunctionExport>())
        {
            try
            {
                functions.Add(BuildFunctionInfo(asset, fe, events));
            }
            catch (Exception e)
            {
                // 单个函数解析失败不静默丢弃：显式记录错误，其余函数继续输出
                functions.Add(new JObject { ["name"] = SafeStr(fe.ObjectName), ["error"] = e.Message });
            }
        }
        root["events"] = events;
        root["variables"] = BuildCdoVariables(asset);
        root["components"] = BuildCdoComponents(asset);
        root["functions"] = functions;
        return root;
    }

    static JObject BuildClassInfo(UAsset asset)
    {
        var jo = new JObject();
        var cls = asset.Exports.OfType<ClassExport>().FirstOrDefault();
        if (cls == null)
        {
            jo["name"] = JValue.CreateNull();
            jo["super"] = JValue.CreateNull();
            jo["interfaces"] = new JArray();
            return jo;
        }
        jo["name"] = SafeStr(cls.ObjectName);
        jo["super"] = cls.SuperStruct == null || cls.SuperStruct.IsNull()
            ? JValue.CreateNull()
            : (JToken)ResolveStackNode(cls.SuperStruct, asset);
        var interfaces = new JArray();
        foreach (var i in cls.Interfaces ?? Array.Empty<SerializedInterfaceReference>())
        {
            interfaces.Add(new JObject
            {
                ["name"] = ResolveStackNode(FPackageIndex.FromRawIndex(i.Class), asset),
                ["implementedByBlueprint"] = i.bImplementedByK2,
            });
        }
        jo["interfaces"] = interfaces;
        return jo;
    }

    static JObject BuildFunctionInfo(UAsset asset, FunctionExport fe, JArray events)
    {
        var jo = new JObject { ["name"] = SafeStr(fe.ObjectName) };
        jo["flags"] = FlagNames(fe.FunctionFlags);

        var parameters = new JArray();
        var locals = new JArray();
        foreach (var p in fe.LoadedProperties ?? Array.Empty<FProperty>())
        {
            if (p == null) continue;
            var flags = p.PropertyFlags;
            bool isParm = (flags & EPropertyFlags.CPF_Parm) != 0;
            var item = new JObject
            {
                ["name"] = SafeStr(p.Name),
                ["type"] = SafeStr(p.SerializedType),
                ["out"] = (flags & EPropertyFlags.CPF_OutParm) != 0,
            };
            if ((flags & EPropertyFlags.CPF_ReturnParm) != 0) item["return"] = true;
            AddFieldTypeDetail(asset, p, item);
            (isParm ? parameters : locals).Add(item);
        }
        jo["params"] = parameters;
        jo["locals"] = locals;

        var code = fe.ScriptBytecode ?? Array.Empty<KismetExpression>();
        // UAssetAPI 的 Visit 按序列化顺序回调每个子表达式及其字节偏移；
        // 顶层语句起点由 GetSize 累加（与 ScriptBytecodeSize 一致）。
        var offsets = new Dictionary<KismetExpression, uint>();
        var starts = new uint[code.Length];
        uint cursor = 0;
        for (int i = 0; i < code.Length; i++)
        {
            starts[i] = cursor;
            code[i].Visit(asset, ref cursor, (expr, offset) => offsets[expr] = offset);
        }

        jo["codeSize"] = fe.ScriptBytecodeSize;
        var body = new JArray();
        foreach (var stmt in code) body.Add(SerializeExpression(asset, stmt, offsets));
        jo["body"] = body;
        jo["blocks"] = BuildBlocks(code, starts, fe.ScriptBytecodeSize);

        TryAddEvent(asset, fe, code, events);
        return jo;
    }

    // 事件入口：函数体首个 BlueprintEvent 调用是 ExecuteUbergraph_X(IntConst offset)。
    static void TryAddEvent(UAsset asset, FunctionExport fe, KismetExpression[] code, JArray events)
    {
        foreach (var stmt in code)
        {
            string target;
            KismetExpression[] args;
            if (stmt is EX_CallMath cm)
            {
                target = ResolveStackNode(cm.StackNode, asset);
                args = cm.Parameters;
            }
            else if (stmt is EX_FinalFunction ff)
            {
                target = ResolveStackNode(ff.StackNode, asset);
                args = ff.Parameters;
            }
            else
            {
                continue;
            }
            if (target == null || !target.StartsWith("ExecuteUbergraph_", StringComparison.Ordinal)) continue;
            events.Add(new JObject
            {
                ["name"] = SafeStr(fe.ObjectName),
                ["target"] = target,
                ["entryOffset"] = FirstIntConst(args) is int entry ? entry : (JToken)JValue.CreateNull(),
                ["flags"] = FlagNames(fe.FunctionFlags),
            });
            return;
        }
    }

    static int? FirstIntConst(KismetExpression[] args)
    {
        foreach (var arg in args ?? Array.Empty<KismetExpression>())
        {
            if (arg is EX_IntConst ic) return ic.Value;
            if (arg is EX_IntConstByte icb) return icb.Value;
            if (arg is EX_NothingInt32 ni) return ni.Value;
        }
        return null;
    }

    static JArray FlagNames<T>(T flags) where T : struct, Enum
    {
        var arr = new JArray();
        var text = flags.ToString();
        if (string.IsNullOrEmpty(text) || text == "0") return arr;
        foreach (var part in text.Split(','))
        {
            var name = part.Trim();
            if (name.Length > 0) arr.Add(name);
        }
        return arr;
    }

    static void AddFieldTypeDetail(UAsset asset, FProperty p, JObject jo)
    {
        if (p is FStructProperty sp) jo["struct"] = ResolveStackNode(sp.Struct, asset);
        else if (p is FObjectProperty op) jo["objectClass"] = ResolveStackNode(op.PropertyClass, asset);
        else if (p is FEnumProperty ep) jo["enum"] = ResolveStackNode(ep.Enum, asset);
        else if (p is FByteProperty bp && bp.Enum != null && !bp.Enum.IsNull()) jo["enum"] = ResolveStackNode(bp.Enum, asset);
        else if (p is FArrayProperty ap && ap.Inner != null)
        {
            jo["innerType"] = SafeStr(ap.Inner.SerializedType);
            AddFieldTypeDetail(asset, ap.Inner, jo);
        }
        else if (p is FMapProperty mp)
        {
            jo["keyType"] = SafeStr(mp.KeyProp?.SerializedType);
            jo["valueType"] = SafeStr(mp.ValueProp?.SerializedType);
        }
    }

    // 表达式树：保留 opcode 与全部可递归子表达式；未知类型显式标记 unsupported。
    static JToken SerializeExpression(UAsset asset, KismetExpression e, IDictionary<KismetExpression, uint> offsets)
    {
        if (e == null) return JValue.CreateNull();
        var jo = new JObject { ["op"] = e.Token.ToString() };
        if (offsets.TryGetValue(e, out var off)) jo["offset"] = off;

        switch (e)
        {
            // 派生自 EX_FinalFunction / EX_VirtualFunction 的类型必须先于基类匹配
            case EX_CallMath cm:
                jo["function"] = ResolveStackNode(cm.StackNode, asset);
                jo["args"] = ExpressionArray(asset, cm.Parameters, offsets);
                break;
            case EX_CallMulticastDelegate cmd:
                jo["delegate"] = SerializeExpression(asset, cmd.Delegate, offsets);
                jo["function"] = ResolveStackNode(cmd.StackNode, asset);
                jo["args"] = ExpressionArray(asset, cmd.Parameters, offsets);
                break;
            case EX_FinalFunction ff:
                jo["function"] = ResolveStackNode(ff.StackNode, asset);
                jo["args"] = ExpressionArray(asset, ff.Parameters, offsets);
                break;
            case EX_VirtualFunction vf:
                jo["function"] = SafeStr(vf.VirtualFunctionName);
                jo["args"] = ExpressionArray(asset, vf.Parameters, offsets);
                break;
            case EX_Let let:
                jo["property"] = PointerJson(asset, let.Value);
                jo["variable"] = SerializeExpression(asset, let.Variable, offsets);
                jo["value"] = SerializeExpression(asset, let.Expression, offsets);
                break;
            case EX_LetBase lb:
                jo["variable"] = SerializeExpression(asset, lb.VariableExpression, offsets);
                jo["value"] = SerializeExpression(asset, lb.AssignmentExpression, offsets);
                break;
            case EX_LetValueOnPersistentFrame lpf:
                jo["property"] = PointerJson(asset, lpf.DestinationProperty);
                jo["value"] = SerializeExpression(asset, lpf.AssignmentExpression, offsets);
                break;
            case EX_Context ctx:
                jo["object"] = SerializeExpression(asset, ctx.ObjectExpression, offsets);
                jo["context"] = SerializeExpression(asset, ctx.ContextExpression, offsets);
                jo["property"] = PointerJson(asset, ctx.RValuePointer);
                break;
            case EX_Jump jump:
                jo["targetOffset"] = jump.CodeOffset;
                break;
            case EX_JumpIfNot jumpIfNot:
                jo["targetOffset"] = jumpIfNot.CodeOffset;
                jo["condition"] = SerializeExpression(asset, jumpIfNot.BooleanExpression, offsets);
                break;
            case EX_PushExecutionFlow push:
                jo["targetOffset"] = push.PushingAddress;
                break;
            case EX_ComputedJump computed:
                jo["target"] = SerializeExpression(asset, computed.CodeOffsetExpression, offsets);
                break;
            case EX_Skip skip:
                jo["targetOffset"] = skip.CodeOffset;
                jo["expression"] = SerializeExpression(asset, skip.SkipExpression, offsets);
                break;
            case EX_Return ret:
                jo["value"] = SerializeExpression(asset, ret.ReturnExpression, offsets);
                break;
            case EX_SwitchValue sw:
                jo["endTargetOffset"] = sw.EndGotoOffset;
                jo["index"] = SerializeExpression(asset, sw.IndexTerm, offsets);
                jo["default"] = SerializeExpression(asset, sw.DefaultTerm, offsets);
                var cases = new JArray();
                foreach (var c in sw.Cases ?? Array.Empty<FKismetSwitchCase>())
                {
                    cases.Add(new JObject
                    {
                        ["index"] = SerializeExpression(asset, c.CaseIndexValueTerm, offsets),
                        ["nextOffset"] = c.NextOffset,
                        ["value"] = SerializeExpression(asset, c.CaseTerm, offsets),
                    });
                }
                jo["cases"] = cases;
                break;
            case EX_CastBase cast:
                jo["class"] = ResolveStackNode(cast.ClassPtr, asset);
                jo["target"] = SerializeExpression(asset, cast.Target, offsets);
                break;
            case EX_PrimitiveCast primitive:
                jo["conversion"] = SafeStr(primitive.ConversionType);
                jo["target"] = SerializeExpression(asset, primitive.Target, offsets);
                break;
            case EX_VariableBase variable:
                jo["property"] = PointerJson(asset, variable.Variable);
                break;
            case EX_StructMemberContext member:
                jo["member"] = PointerJson(asset, member.StructMemberExpression);
                jo["struct"] = SerializeExpression(asset, member.StructExpression, offsets);
                break;
            case EX_ArrayGetByRef arrayRef:
                jo["array"] = SerializeExpression(asset, arrayRef.ArrayVariable, offsets);
                jo["index"] = SerializeExpression(asset, arrayRef.ArrayIndex, offsets);
                break;
            case EX_SetArray setArray:
                jo["property"] = SerializeExpression(asset, setArray.AssigningProperty, offsets);
                jo["innerType"] = ResolveStackNode(setArray.ArrayInnerProp, asset);
                jo["elements"] = ExpressionArray(asset, setArray.Elements, offsets);
                break;
            case EX_SetConst setConst:
                jo["innerProperty"] = PointerJson(asset, setConst.InnerProperty);
                jo["elements"] = ExpressionArray(asset, setConst.Elements, offsets);
                break;
            case EX_SetMap setMap:
                jo["property"] = SerializeExpression(asset, setMap.MapProperty, offsets);
                jo["elements"] = ExpressionArray(asset, setMap.Elements, offsets);
                break;
            case EX_SetSet setSet:
                jo["property"] = SerializeExpression(asset, setSet.SetProperty, offsets);
                jo["elements"] = ExpressionArray(asset, setSet.Elements, offsets);
                break;
            case EX_ArrayConst arrayConst:
                jo["innerProperty"] = PointerJson(asset, arrayConst.InnerProperty);
                jo["elements"] = ExpressionArray(asset, arrayConst.Elements, offsets);
                break;
            case EX_MapConst mapConst:
                jo["keyProperty"] = PointerJson(asset, mapConst.KeyProperty);
                jo["valueProperty"] = PointerJson(asset, mapConst.ValueProperty);
                jo["elements"] = ExpressionArray(asset, mapConst.Elements, offsets);
                break;
            case EX_StructConst structConst:
                jo["struct"] = ResolveStackNode(structConst.Struct, asset);
                jo["size"] = structConst.StructSize;
                jo["elements"] = ExpressionArray(asset, structConst.Value, offsets);
                break;
            case EX_Assert assert:
                jo["lineNumber"] = assert.LineNumber;
                jo["debugMode"] = assert.DebugMode;
                jo["condition"] = SerializeExpression(asset, assert.AssertExpression, offsets);
                break;
            case EX_InterfaceContext interfaceContext:
                jo["value"] = SerializeExpression(asset, interfaceContext.InterfaceValue, offsets);
                break;
            case EX_PopExecutionFlowIfNot popIfNot:
                jo["condition"] = SerializeExpression(asset, popIfNot.BooleanExpression, offsets);
                break;
            case EX_IntConst intConst:
                jo["value"] = intConst.Value;
                break;
            case EX_IntConstByte intConstByte:
                jo["value"] = intConstByte.Value;
                break;
            case EX_ByteConst byteConst:
                jo["value"] = byteConst.Value;
                break;
            case EX_Int64Const int64Const:
                jo["value"] = int64Const.Value;
                break;
            case EX_UInt64Const uint64Const:
                jo["value"] = uint64Const.Value;
                break;
            case EX_NothingInt32 nothingInt32:
                jo["value"] = nothingInt32.Value;
                break;
            case EX_SkipOffsetConst skipOffset:
                jo["value"] = skipOffset.Value;
                break;
            case EX_FloatConst floatConst:
                jo["value"] = floatConst.Value;
                break;
            case EX_DoubleConst doubleConst:
                jo["value"] = doubleConst.Value;
                break;
            case EX_StringConst stringConst:
                jo["value"] = stringConst.Value;
                break;
            case EX_UnicodeStringConst unicodeConst:
                jo["value"] = unicodeConst.Value;
                break;
            case EX_NameConst nameConst:
                jo["value"] = SafeStr(nameConst.Value);
                break;
            case EX_TextConst textConst:
                jo["value"] = TextConstJson(asset, textConst.Value, offsets);
                break;
            case EX_ObjectConst objectConst:
                jo["object"] = ConstRefJson(asset, objectConst.GetObject<FPackageIndex>());
                break;
            case EX_SoftObjectConst softObject:
                jo["value"] = SerializeExpression(asset, softObject.Value, offsets);
                break;
            case EX_FieldPathConst fieldPath:
                jo["value"] = SerializeExpression(asset, fieldPath.Value, offsets);
                break;
            case EX_VectorConst vector:
                jo["value"] = new JObject { ["x"] = vector.Value.X, ["y"] = vector.Value.Y, ["z"] = vector.Value.Z };
                break;
            case EX_Vector3fConst vector3f:
                jo["value"] = new JObject { ["x"] = vector3f.X, ["y"] = vector3f.Y, ["z"] = vector3f.Z };
                break;
            case EX_RotationConst rotation:
                jo["value"] = new JObject
                {
                    ["pitch"] = rotation.Value.Pitch,
                    ["yaw"] = rotation.Value.Yaw,
                    ["roll"] = rotation.Value.Roll,
                };
                break;
            case EX_TransformConst transform:
                jo["value"] = new JObject
                {
                    ["translation"] = new JObject
                    {
                        ["x"] = transform.Value.Translation.X,
                        ["y"] = transform.Value.Translation.Y,
                        ["z"] = transform.Value.Translation.Z,
                    },
                    ["rotation"] = new JObject
                    {
                        ["x"] = transform.Value.Rotation.X,
                        ["y"] = transform.Value.Rotation.Y,
                        ["z"] = transform.Value.Rotation.Z,
                        ["w"] = transform.Value.Rotation.W,
                    },
                    ["scale"] = new JObject
                    {
                        ["x"] = transform.Value.Scale3D.X,
                        ["y"] = transform.Value.Scale3D.Y,
                        ["z"] = transform.Value.Scale3D.Z,
                    },
                };
                break;
            case EX_InstanceDelegate instanceDelegate:
                jo["function"] = SafeStr(instanceDelegate.FunctionName);
                break;
            case EX_BindDelegate bindDelegate:
                jo["function"] = SafeStr(bindDelegate.FunctionName);
                jo["delegate"] = SerializeExpression(asset, bindDelegate.Delegate, offsets);
                jo["object"] = SerializeExpression(asset, bindDelegate.ObjectTerm, offsets);
                break;
            case EX_AddMulticastDelegate addDelegate:
                jo["delegate"] = SerializeExpression(asset, addDelegate.Delegate, offsets);
                jo["delegateToAdd"] = SerializeExpression(asset, addDelegate.DelegateToAdd, offsets);
                break;
            case EX_RemoveMulticastDelegate removeDelegate:
                jo["delegate"] = SerializeExpression(asset, removeDelegate.Delegate, offsets);
                jo["delegateToAdd"] = SerializeExpression(asset, removeDelegate.DelegateToAdd, offsets);
                break;
            case EX_ClearMulticastDelegate clearDelegate:
                jo["delegate"] = SerializeExpression(asset, clearDelegate.DelegateToClear, offsets);
                break;
            case EX_BitFieldConst bitField:
                jo["property"] = PointerJson(asset, bitField.Property);
                jo["value"] = bitField.Value;
                break;
            case EX_PropertyConst propertyConst:
                jo["property"] = PointerJson(asset, propertyConst.Property);
                break;
            case EX_InstrumentationEvent instrumentation:
                jo["eventType"] = SafeStr(instrumentation.EventType);
                jo["eventName"] = SafeStr(instrumentation.EventName);
                break;
            default:
                // 无子字段的 opcode 只保留 op/offset；UAssetAPI 新增且未覆盖的类型显式标记
                if (!KnownLeafOps.Contains(e.GetType().Name)) jo["unsupported"] = true;
                break;
        }
        return jo;
    }

    static readonly HashSet<string> KnownLeafOps = new HashSet<string>(StringComparer.Ordinal)
    {
        "EX_Self", "EX_True", "EX_False", "EX_IntZero", "EX_IntOne", "EX_NoObject", "EX_NoInterface",
        "EX_Nothing", "EX_EndOfScript", "EX_EndFunctionParms", "EX_EndArray", "EX_EndArrayConst",
        "EX_EndMap", "EX_EndMapConst", "EX_EndParmValue", "EX_EndSet", "EX_EndSetConst",
        "EX_EndStructConst", "EX_Tracepoint", "EX_WireTracepoint", "EX_Breakpoint", "EX_DeprecatedOp4A",
        "EX_PopExecutionFlow",
    };

    static JArray ExpressionArray(UAsset asset, KismetExpression[] expressions, IDictionary<KismetExpression, uint> offsets)
    {
        var arr = new JArray();
        foreach (var e in expressions ?? Array.Empty<KismetExpression>()) arr.Add(SerializeExpression(asset, e, offsets));
        return arr;
    }

    static JToken PointerJson(UAsset asset, KismetPropertyPointer pointer)
    {
        if (pointer == null) return JValue.CreateNull();
        var jo = new JObject();
        if (pointer.Old != null && !pointer.Old.IsNull())
        {
            jo["path"] = new JArray(ResolveStackNode(pointer.Old, asset));
            return jo;
        }
        var path = new JArray();
        foreach (var name in pointer.New?.Path ?? Array.Empty<FName>()) path.Add(SafeStr(name));
        if (path.Count == 0) return JValue.CreateNull();
        jo["path"] = path;
        if (pointer.New != null && pointer.New.ResolvedOwner != null && !pointer.New.ResolvedOwner.IsNull())
            jo["owner"] = ResolveStackNode(pointer.New.ResolvedOwner, asset);
        return jo;
    }

    static JObject ConstRefJson(UAsset asset, FPackageIndex index)
    {
        var jo = new JObject();
        if (index == null || index.IsNull())
        {
            jo["name"] = JValue.CreateNull();
            return jo;
        }
        try
        {
            if (index.IsImport())
            {
                jo["kind"] = "import";
                jo["name"] = SafeStr(index.ToImport(asset).ObjectName);
                jo["class"] = SafeStr(index.ToImport(asset).ClassName);
            }
            else if (index.IsExport())
            {
                jo["kind"] = "export";
                jo["name"] = SafeStr(index.ToExport(asset).ObjectName);
            }
            else
            {
                jo["kind"] = "unknown";
                jo["name"] = JValue.CreateNull();
            }
        }
        catch (Exception)
        {
            jo["kind"] = "unknown";
            jo["name"] = JValue.CreateNull();
        }
        return jo;
    }

    static JObject TextConstJson(UAsset asset, FScriptText text, IDictionary<KismetExpression, uint> offsets)
    {
        var jo = new JObject();
        if (text == null) return jo;
        jo["textLiteralType"] = SafeStr(text.TextLiteralType);
        switch (text.TextLiteralType)
        {
            case EBlueprintTextLiteralType.LocalizedText:
                jo["namespace"] = SerializeExpression(asset, text.LocalizedNamespace, offsets);
                jo["key"] = SerializeExpression(asset, text.LocalizedKey, offsets);
                jo["source"] = SerializeExpression(asset, text.LocalizedSource, offsets);
                break;
            case EBlueprintTextLiteralType.InvariantText:
                jo["value"] = SerializeExpression(asset, text.InvariantLiteralString, offsets);
                break;
            case EBlueprintTextLiteralType.LiteralString:
                jo["value"] = SerializeExpression(asset, text.LiteralString, offsets);
                break;
            case EBlueprintTextLiteralType.StringTableEntry:
                jo["table"] = ResolveStackNode(text.StringTableAsset, asset);
                jo["id"] = SerializeExpression(asset, text.StringTableId, offsets);
                jo["key"] = SerializeExpression(asset, text.StringTableKey, offsets);
                break;
        }
        return jo;
    }

    // 基本块：起点 = 函数入口 / 跳转目标 / 硬终止语句之后；successors 给出静态控制流边。
    static JArray BuildBlocks(KismetExpression[] code, uint[] starts, int codeSize)
    {
        var blocks = new JArray();
        if (code.Length == 0) return blocks;

        var statementByOffset = new Dictionary<uint, int>();
        for (int i = 0; i < code.Length; i++) statementByOffset[starts[i]] = i;

        var isStart = new bool[code.Length];
        isStart[0] = true;
        for (int i = 0; i < code.Length; i++)
        {
            foreach (var target in StaticTargets(code[i]))
                if (statementByOffset.TryGetValue(target, out var targetStatement)) isStart[targetStatement] = true;
            if (IsHardTerminator(code[i]) && i + 1 < code.Length) isStart[i + 1] = true;
        }

        var startStatements = new List<int>();
        for (int i = 0; i < code.Length; i++)
            if (isStart[i]) startStatements.Add(i);

        var blockByOffset = new Dictionary<uint, int>();
        for (int b = 0; b < startStatements.Count; b++) blockByOffset[starts[startStatements[b]]] = b;

        for (int b = 0; b < startStatements.Count; b++)
        {
            int first = startStatements[b];
            int last = (b + 1 < startStatements.Count ? startStatements[b + 1] : code.Length) - 1;
            var statements = new JArray();
            for (int i = first; i <= last; i++) statements.Add(i);
            var jo = new JObject
            {
                ["index"] = b,
                ["startOffset"] = starts[first],
                ["endOffset"] = last + 1 < code.Length ? starts[last + 1] : (uint)codeSize,
                ["statements"] = statements,
            };

            var successors = new JArray();
            for (int i = first; i <= last; i++)
            {
                foreach (var edge in ControlFlowEdges(code[i]))
                {
                    var item = new JObject { ["kind"] = edge.kind, ["from"] = i };
                    if (edge.targetOffset.HasValue)
                    {
                        item["targetOffset"] = edge.targetOffset.Value;
                        item["block"] = blockByOffset.TryGetValue(edge.targetOffset.Value, out var targetBlock)
                            ? (JToken)targetBlock
                            : JValue.CreateNull();
                    }
                    else
                    {
                        item["block"] = JValue.CreateNull();
                    }
                    successors.Add(item);
                }
            }
            if (!IsHardTerminator(code[last]) && b + 1 < startStatements.Count)
                successors.Add(new JObject { ["kind"] = "fallthrough", ["block"] = b + 1 });
            jo["successors"] = successors;
            blocks.Add(jo);
        }
        return blocks;
    }

    static IEnumerable<(string kind, uint? targetOffset)> ControlFlowEdges(KismetExpression e)
    {
        switch (e)
        {
            case EX_Jump jump:
                yield return ("jump", jump.CodeOffset);
                break;
            case EX_JumpIfNot jumpIfNot:
                yield return ("jumpIfNot", jumpIfNot.CodeOffset);
                break;
            case EX_PushExecutionFlow push:
                yield return ("pushFlow", push.PushingAddress);
                break;
            case EX_Skip skip:
                yield return ("skip", skip.CodeOffset);
                break;
            case EX_SwitchValue sw:
                foreach (var c in sw.Cases ?? Array.Empty<FKismetSwitchCase>())
                    yield return ("switchCase", c.NextOffset);
                yield return ("switchEnd", sw.EndGotoOffset);
                break;
            case EX_ComputedJump _:
                yield return ("computedJump", null);
                break;
            case EX_PopExecutionFlowIfNot _:
                yield return ("popFlowIfNot", null);
                break;
            case EX_PopExecutionFlow _:
                yield return ("popFlow", null);
                break;
        }
    }

    static IEnumerable<uint> StaticTargets(KismetExpression e)
    {
        foreach (var (_, targetOffset) in ControlFlowEdges(e))
            if (targetOffset.HasValue) yield return targetOffset.Value;
    }

    static bool IsHardTerminator(KismetExpression e)
    {
        return e is EX_Jump || e is EX_Return || e is EX_EndOfScript
            || e is EX_ComputedJump || e is EX_PopExecutionFlow;
    }

    // CDO 默认值：只输出属性名、类型与默认值；对象引用输出名称/类别，不含包路径。
    static JArray BuildCdoVariables(UAsset asset)
    {
        var arr = new JArray();
        var cdo = FindClassDefaultObject(asset);
        if (cdo == null) return arr;
        foreach (var p in cdo.Data)
        {
            if (p == null) continue;
            var jo = new JObject
            {
                ["name"] = SafeStr(p.Name),
                ["type"] = SafeStr(p.PropertyType),
            };
            if (p is StructPropertyData sp) jo["struct"] = SafeStr(sp.StructType);
            else if (p is ArrayPropertyData ap) jo["innerType"] = SafeStr(ap.ArrayType);
            else if (p is EnumPropertyData ep) jo["enum"] = SafeStr(ep.EnumType);
            else if (p is BytePropertyData bp && bp.ByteType == BytePropertyType.FName) jo["enum"] = SafeStr(bp.EnumType);
            jo["default"] = DefaultValueJson(asset, p);
            arr.Add(jo);
        }
        return arr;
    }

    static JArray BuildCdoComponents(UAsset asset)
    {
        var arr = new JArray();
        var cdo = FindClassDefaultObject(asset);
        var prop = cdo?.Data?.FirstOrDefault(p => SafeStr(p.Name) == "BlueprintCreatedComponents") as ArrayPropertyData;
        if (prop?.Value == null) return arr;
        foreach (var item in prop.Value)
        {
            try
            {
                if (item?.RawValue is FPackageIndex index)
                    arr.Add(index.IsImport() ? SafeStr(index.ToImport(asset).ObjectName) : SafeStr(index.ToExport(asset).ObjectName));
                else if (item != null)
                    arr.Add(DefaultValueJson(asset, item));
            }
            catch (Exception e)
            {
                arr.Add(new JObject { ["error"] = e.Message });
            }
        }
        return arr;
    }

    static NormalExport? FindClassDefaultObject(UAsset asset)
    {
        return asset.Exports.OfType<NormalExport>().FirstOrDefault(x => SafeStr(x.ObjectName).StartsWith("Default__", StringComparison.Ordinal));
    }

    static JToken DefaultValueJson(UAsset asset, PropertyData p)
    {
        if (p == null) return JValue.CreateNull();
        try
        {
            if (p is Vector2DPropertyData v2) return new JObject { ["x"] = v2.Value.X, ["y"] = v2.Value.Y };
            if (p is VectorPropertyData v3) return new JObject { ["x"] = v3.Value.X, ["y"] = v3.Value.Y, ["z"] = v3.Value.Z };
            if (p is RotatorPropertyData rot) return new JObject { ["pitch"] = rot.Value.Pitch, ["yaw"] = rot.Value.Yaw, ["roll"] = rot.Value.Roll };
            if (p is LinearColorPropertyData lc)
                return new JObject { ["r"] = lc.Value.R, ["g"] = lc.Value.G, ["b"] = lc.Value.B, ["a"] = lc.Value.A };
            if (p is ColorPropertyData col)
                return new JObject { ["r"] = (int)col.Value.R, ["g"] = (int)col.Value.G, ["b"] = (int)col.Value.B, ["a"] = (int)col.Value.A };
            if (p is StructPropertyData sp)
            {
                var obj = new JObject();
                if (sp.Value is IEnumerable<PropertyData> children)
                    foreach (var child in children)
                        if (child != null) obj[SafeStr(child.Name)] = DefaultValueJson(asset, child);
                return obj;
            }
            if (p is ArrayPropertyData ap)
            {
                var list = new JArray();
                if (ap.Value is IEnumerable<PropertyData> items)
                    foreach (var item in items)
                        if (item != null) list.Add(DefaultValueJson(asset, item));
                return list;
            }
            if (p is MapPropertyData map)
            {
                var list = new JArray();
                for (int i = 0; i < map.Value.Count; i++)
                {
                    var pair = map.Value.GetItem(i);
                    list.Add(new JObject
                    {
                        ["key"] = DefaultValueJson(asset, pair.Key),
                        ["value"] = DefaultValueJson(asset, pair.Value),
                    });
                }
                return list;
            }
            if (p is EnumPropertyData ep) return SafeStr(ep.RawValue);
            if (p is BytePropertyData bp)
                return bp.ByteType == BytePropertyType.FName ? (JToken)SafeStr(bp.EnumValue) : new JValue((int)bp.Value);

            var raw = p.RawValue;
            if (raw is FName name) return SafeStr(name);
            if (raw is FString text) return SafeStr(text);
            if (raw is FPackageIndex index) return ConstRefJson(asset, index);
            if (raw is IEnumerable<PropertyData> nested)
            {
                var list = new JArray();
                foreach (var item in nested)
                    if (item != null) list.Add(DefaultValueJson(asset, item));
                return list;
            }
            if (raw is bool || raw is byte || raw is sbyte || raw is short || raw is ushort
                || raw is int || raw is uint || raw is long || raw is ulong
                || raw is float || raw is double || raw is decimal)
                return new JValue(raw);
            if (raw is string str) return new JValue(str);
            if (raw != null) return new JValue(SafeStr(raw));
        }
        catch (Exception e)
        {
            return new JObject { ["error"] = e.Message };
        }
        return JValue.CreateNull();
    }

    // ---------- FModel 式整体 JSON 导出 ----------
    static (bool ok, JToken json, string error) ExportFile(string path, bool keepTypes = false)
    {
        try
        {
            var asset = ReadAsset(path);
            var json = JObject.Parse(asset.SerializeJson());
            // 默认去掉 UAssetAPI round-trip 元数据($type/$id/$ref)，得到干净的 FModel 式 JSON；
            // keep-types 保留它们（$ref 仍指向同一次响应内的 $id）
            if (!keepTypes) StripTypeAnnotations(json);
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

    static JObject ExportDirectory(string dir, bool keepTypes = false)
    {
        var files = Directory.GetFiles(dir, "*.uasset");
        Array.Sort(files);
        var outObj = new JObject();
        foreach (var file in files)
        {
            var r = ExportFile(file, keepTypes);
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
