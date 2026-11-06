# UAssetCLI — 通用 uasset 解析器

用 [UAssetAPI](https://github.com/atenfyr/UAssetAPI) 直接读取 UE4.27 的 `.uasset/.uexp`，
支持两类导出：

- **字节码调用解析**：解析各 `FunctionExport.ScriptBytecode`（Kismet 表达式树），
  提取其中所有函数调用的函数名与参数常量。
- **FModel 式整体 JSON**：用 UAssetAPI 的 `SerializeJson` 导出整个资产
  （NameMap / Imports / Exports / 属性 / 函数体），格式与 FModel 的 JSON 导出同构
  （每个导出含 `ObjectName`/`ObjectFlags`/`Data` 等字段），并去掉 UAssetAPI 的
  round-trip 元数据（`$type` 等）。

FModel 的 JSON 导出只有属性签名、不含编译后的字节码（`ScriptBytecode` 在 `.uexp`
二进制里），所以被动蓝图（BP）实际叠加了哪些 buff 只能靠直接读 uasset 拿到。

## 运行模式

### 1. server 模式（供 TS 工具自动调用，stdio JSON 行协议）

从 stdin 读一行一个 JSON 命令，向 stdout 写一行 JSON 响应，收到 `shutdown` 或 stdin
关闭后自动退出：

```json
{"cmd":"parse","path":"<uasset文件>"}
{"cmd":"parse_dir","path":"<目录>"}
{"cmd":"export","path":"<uasset文件>"}
{"cmd":"export","path":"<uasset文件>","keepTypes":true}
{"cmd":"export_dir","path":"<目录>"}
{"cmd":"export_dir","path":"<目录>","out":"<输出目录>"}
{"cmd":"fmodel","path":"<uasset文件>","package":"<包路径>","mount":"EM/Content"}
{"cmd":"fmodel_dir","path":"<目录>","root":"<Exports根>","mount":"EM/Content"}
{"cmd":"bytecode","path":"<uasset文件>"}
{"cmd":"shutdown"}
```

响应统一为 `{"ok":true,"result":...}` 或 `{"ok":false,"error":...}`。

请求可带任意 JSON 值 `id`，响应会原样回传 `id`，供调用方在并发场景关联请求与响应。

- `parse_dir`：`result.Files` 为 `{文件名: {函数名: [调用汇总...]}}`。
- `export`：`result` 为该资产的整体 JSON（可能较大，一次性请用 export_dir 写文件）。
- `export_dir` 带 `out`：把每个资产的 JSON 写入 `<out>/<文件名>.json`（UTF-8 无 BOM），
  返回 `{"exported":N,"failed":N,"failed_files":[...]}`——大目录建议用此模式避免
  超大单行响应；不带 `out` 则内联返回 `{"Files":{文件名: JSON}}`。
- `fmodel`：把单个 uasset 按 **FModel Output/Exports 数组格式** 直接导出为内存 JSON
  （`result` 为数组，每个对象含 `Type`/`Name`/`Flags`/`Class`/`Outer`/`Properties` 等），
  `package` 为包路径（如 `EM/Content/UI/WBP/Map/Widget/Map_Splice/Chapter01/...`），
  `mount` 用于把 `/Game/` 重写为解包挂载路径（本游戏为 `EM/Content`）。
  支持 `TMap` 属性（如蓝图 `RandomActorInfos`），按 FModel 风格输出为
  `[{Key, Value}, ...]` 数组。
- `fmodel_dir`：递归导出目录下所有 uasset，返回 `{"Files":{包路径: [数组]}}`，
  供地图导出脚本一次性取回整棵 Widget 树。
- `bytecode`：输出类型化 Blueprint 字节码。每个 `FunctionExport` 保留 opcode
  （`EX_*`）、语句/子表达式字节偏移、基本块与后继边；顶层附类信息、事件入口、
  CDO 变量默认值与组件。输出只含资产名/对象名，不含文件系统绝对路径，同一输入逐字节稳定。

`bytecode` 结果结构（`schemaVersion: 1`）：

```json
{
  "schemaVersion": 1,
  "asset": "BP_Feina",
  "class": { "name": "BP_Feina_C", "super": "BP_PassiveEffectBase_C", "interfaces": [] },
  "events": [{ "name": "ReceiveBeginPlay", "target": "ExecuteUbergraph_BP_Feina", "entryOffset": 25, "flags": ["FUNC_Event"] }],
  "variables": [{ "name": "PassiveLastTime", "type": "FloatProperty", "default": 15 }],
  "components": [],
  "functions": [
    {
      "name": "Skill1AddBuff",
      "flags": ["FUNC_Public", "FUNC_BlueprintCallable"],
      "params": [{ "name": "NodeId", "type": "IntProperty", "out": false }],
      "locals": [{ "name": "CallFunc_GetInt_ReturnValue", "type": "IntProperty", "out": false }],
      "codeSize": 604,
      "body": [
        {
          "op": "EX_JumpIfNot",
          "offset": 60,
          "targetOffset": 340,
          "condition": { "op": "EX_LocalVariable", "offset": 65, "property": { "path": ["CallFunc_CheckSkillGrade_IsSuccess"] } }
        },
        { "op": "EX_Let", "offset": 74, "variable": { "op": "EX_LocalVariable" }, "value": { "op": "EX_CallMath", "function": "CastToCharacterBase", "args": [] } },
        { "op": "EX_Return", "offset": 601, "value": { "op": "EX_Nothing" } }
      ],
      "blocks": [
        {
          "index": 0,
          "startOffset": 0,
          "endOffset": 340,
          "statements": [0, 1],
          "successors": [{ "kind": "jumpIfNot", "from": 1, "targetOffset": 340, "block": 1 }]
        }
      ]
    }
  ]
}
```

- `offset` 是表达式在 `ScriptBytecode` 中的字节偏移（与 `ScriptBytecodeSize` 一致）；
  `blocks[].statements` 是 `body` 的下标，`successors[].block` 为目标基本块。
- 跳转目标无法落到语句起点时 `block` 为 `null`，保留 `targetOffset` 供诊断。
- 单个函数解析失败时该函数项为 `{"name": "...", "error": "..."}`，其余函数照常输出。
- 未识别的 opcode 保留 `op`/`offset` 并标记 `"unsupported": true`，不静默丢弃。

字节码调用汇总（通用，不做游戏语义过滤）：

```json
{ "Function": "AddBuffToTarget", "IntParams": [540203], "AllParams": [540203, "..."] }
```

- `IntParams`：参数中的整数常量（可能含 buff id / 枚举 / 层数等），由调用方按需解释。
- `AllParams`：参数摘要（`InstanceVariable:xxx` / `LocalVariable:xxx` / `ObjectConst:xxx` 等）。

### 2. 一次性模式

```bash
UAssetCLI <uasset文件|目录>                     # 字节码调用解析，直接打印 JSON 后退出
UAssetCLI export <uasset文件|目录>              # FModel 式整体 JSON
UAssetCLI export --keep-types <uasset文件|目录> # 同上，保留 $type/$id/$ref
```

## 与 TS 工具链集成

UAssetCLI server 由 TS 侧 `src/lua/UAssetServer.ts` 封装，供地图拼接导出（`src/tools/exportMaps.ts`）
与动画等资产解析使用：

1. 定位 `tools/UAssetCLI/UAssetCLI.exe`；
2. 通过 `DNA_UNPACK_DIR` 环境变量（缺省时尝试仓库同级 `../dna-unpack`）定位解包目录；
3. 以 **server 模式** 请求 `fmodel` / `fmodel_dir` / `parse_dir` / `bytecode` 等命令；
4. 使用完毕发送 `shutdown` 关闭 server（不占用额外进程）。

`UAssetServer` 的传输约定：请求串行发送并带自增 `id`，响应必须回传同一 `id`
（缺失或不匹配视为协议错误）；stdout 按 UTF-8 字符流解码。单个请求默认 120s 超时
（`DNA_UASSET_TIMEOUT_MS` 或构造参数覆盖）。超时或进程退出会杀掉子进程，下一次请求自动重启。
`close()` 后的实例不可再启动进程。

生命周期：`acquireUAssetServer()` / `releaseUAssetServer(server)` 引用计数，最后一个持有者释放时
只关进程、保留共享 DuckDB 缓存；陈旧引用不会影响当前引用数或关闭当前实例。
`closeUAssetServer({ keepCache: true })` 只关进程、保留缓存。

### 缓存

- `fmodel` 使用旧表 `uasset_fmodel_cache`：key 为
  `[绝对路径, 包路径, mount]`，命中不校验指纹（保持历史行为）。
- `bytecode` 使用
  `uasset_kind_cache(cache_key, kind, parser_version, source_mtime_ms, source_size, source_fingerprint, payload, updated_at)`，
  主键 `(cache_key, kind)`；key 为
  `["bytecode", 绝对路径(正斜杠), 指纹]`，其中指纹是
  `[parserVersion, [[后缀, mtimeMs, size], ...]]`，覆盖主资产与 sidecar：
  `.uasset`（包头/导入表）+ `.uexp`（ScriptBytecode/属性值）+ `.ubulk`（存在时）。
  行内再校验同一 `source_fingerprint`；主资产或任一 sidecar 的 mtime/size、
  或 `UASSET_BYTECODE_PARSER_VERSION` 变化即失效。
  `source_mtime_ms`/`source_size` 仅作诊断汇总（最大 mtime、size 之和）。
  命中只做 stat + DuckDB 查询，不启动 CLI。
- `bun warmup` 清空两张表。
- 环境变量 `DNA_UASSET_CACHE` 可覆盖 DuckDB 路径（相对路径按 cwd 解析），
  便于在 worktree 中复用主 checkout 的缓存或做基准测试。

`src/modules/char/data/BPAddBuff.json` 是角色被动 BP 的 `{BP名: [buff id...]}` 映射
（从 uasset 提取并提交在仓库中以保证可复现），由 TS 的 char 模块在生成技能行为摘要时读取。

## 重新构建 exe

exe 是 framework-dependent 单文件发布（约 5MB，需 .NET 10 运行时）：

```bash
cd tools/UAssetCLI
dotnet publish -c Release -r win-x64 --self-contained false \
  -p:PublishSingleFile=true -p:SelfContained=false -p:PublishTrimmed=false \
  -p:DebugType=None -p:DebugSymbols=false -o publish2
copy publish2\UAssetCLI.exe UAssetCLI.exe
rmdir /s /q publish2
```

`UAssetCLI.exe` 提交进 git（`tools/UAssetCLI/` 下的 bin/obj 已被 .gitignore 忽略）。

## 重新生成 src/modules/char/data/BPAddBuff.json

用 `parse_dir` 解析角色被动 BP 目录后，按下述清洗规则生成映射并写回该文件：

清洗规则：仅取 `Function == "AddBuffToTarget"` 的调用，取 `IntParams` 中 >=100000
且存在于 Buff 表的 id，去重保序。

## 限制

- 只在 `IntConst` 直传 buff id 时能提取；buff id 通过变量/属性间接传入的调用
  （如 `AddBuffToTarget [1]`）无法还原，对应 BP 不会出现在映射里。
- `KismetSerializer.SerializeScript`（完整表达式 JSON）在这批资产上会因 UAssetAPI 对
  `FFieldPath` 的序列化缺陷抛空引用，故本工具用自定义 walker 提取调用汇总。
