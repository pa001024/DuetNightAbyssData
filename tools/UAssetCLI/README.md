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

### 1. server 模式（供 step3 流水线自动调用，stdio JSON 行协议）

从 stdin 读一行一个 JSON 命令，向 stdout 写一行 JSON 响应，收到 `shutdown` 或 stdin
关闭后自动退出：

```json
{"cmd":"parse","path":"<uasset文件>"}
{"cmd":"parse_dir","path":"<目录>"}
{"cmd":"export","path":"<uasset文件>"}
{"cmd":"export_dir","path":"<目录>"}
{"cmd":"export_dir","path":"<目录>","out":"<输出目录>"}
{"cmd":"shutdown"}
```

响应统一为 `{"ok":true,"result":...}` 或 `{"ok":false,"error":...}`。

- `parse_dir`：`result.Files` 为 `{文件名: {函数名: [调用汇总...]}}`。
- `export`：`result` 为该资产的整体 JSON（可能较大，一次性请用 export_dir 写文件）。
- `export_dir` 带 `out`：把每个资产的 JSON 写入 `<out>/<文件名>.json`（UTF-8 无 BOM），
  返回 `{"exported":N,"failed":N,"failed_files":[...]}`——大目录建议用此模式避免
  超大单行响应；不带 `out` 则内联返回 `{"Files":{文件名: JSON}}`。

字节码调用汇总（通用，不做游戏语义过滤）：

```json
{ "Function": "AddBuffToTarget", "IntParams": [540203], "AllParams": [540203, "..."] }
```

- `IntParams`：参数中的整数常量（可能含 buff id / 枚举 / 层数等），由调用方按需解释。
- `AllParams`：参数摘要（`InstanceVariable:xxx` / `LocalVariable:xxx` / `ObjectConst:xxx` 等）。

### 2. 一次性模式

```bash
UAssetCLI <uasset文件|目录>          # 字节码调用解析，直接打印 JSON 后退出
UAssetCLI export <uasset文件|目录>   # FModel 式整体 JSON
```

## 与 step3 流水线集成

`step3_output.py -f Char` 会在导出开始时自动：

1. 定位 `tools/UAssetCLI/UAssetCLI.exe`；
2. 通过 `DNA_UNPACK_DIR` 环境变量（缺省时尝试仓库同级 `../dna-unpack`）定位解包后的
   蓝图目录 `Fmodel/Output/Exports/*/Content/BluePrints/Combat/PassiveEffect/DesignerBP/Player`；
3. 以 **server 模式** 批量解析全部角色被动 BP，提取 `AddBuffToTarget` 的 buff id，
   生成 `{BP名: [buff id...]}` 映射传给 `CharProcessor`；
4. 提取完成即发送 `shutdown` 关闭 server（不占用额外进程）。

无 uasset / 无 exe / 提取失败时自动回退到仓库内置的 `processor/BPAddBuff.json`
（同样从 uasset 提取，提交在仓库中以保证可复现）。

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

## 重新生成 processor/BPAddBuff.json

```bash
python -c "..."   # 见 step3_output.py 的 _load_bp_addbuff_map 实现
```

清洗规则：仅取 `Function == "AddBuffToTarget"` 的调用，取 `IntParams` 中 >=100000
且存在于 `out/Buff.json` 的 id，去重保序。

## 限制

- 只在 `IntConst` 直传 buff id 时能提取；buff id 通过变量/属性间接传入的调用
  （如 `AddBuffToTarget [1]`）无法还原，对应 BP 不会出现在映射里。
- `KismetSerializer.SerializeScript`（完整表达式 JSON）在这批资产上会因 UAssetAPI 对
  `FFieldPath` 的序列化缺陷抛空引用，故本工具用自定义 walker 提取调用汇总。
