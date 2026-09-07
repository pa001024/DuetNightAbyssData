# DuetNightAbyssData

Duet Night Abyss 游戏数据导出工具。主流程使用 TypeScript/Bun，直接读取 Lua 数据并生成多语言 JSON。

## 环境

- [Bun](https://bun.sh/) 1.4+
- `.env` 中可选配置 `DNA_UNPACK_DIR`，指向游戏解包目录
- 使用 UAsset 资产解析时需要 .NET 10 运行时

安装依赖：

```sh
bun install --frozen-lockfile
```

## 导出

直接运行会构建所有已注册模块，并生成 `final/i18n/` 下的多语言 JSON：

```sh
bun run src/cli.ts
```

列出可用模块：

```sh
bun run src/cli.ts --list
```

只导出指定模块和语言：

```sh
bun run src/cli.ts -f Weapon Char --langs cn,en
```

模块名按插件注册表中的规范名称传入（各模块目录 `src/modules/*/register.ts` 自动登记，主程序不再维护静态清单），`-f/--file-types` 匹配时不区分大小写。

## 历史版本解析（-v）

git 历史中记录了各游戏版本的 Lua 数据（`Script/` 目录，含 `Datas/`、`Utils/`、`CommonConst.lua`
等；仓库根不再保留任何 Lua 文件），版本标记
来自 **tag**（`v1.1`、`v1.2`）与 **master 主线 commit subject 即版本号**（`v1.3.125.1` … `v1.6.4.1`）。
`-v` 会把 Lua 数据层切到指定历史版本再解析；代码、uasset 解包与 `out/` 等当前工作区内容不变：

```sh
# 精确版本（tag）
bun run src/cli.ts -v 1.2 -f MonsterStrongAffixes --langs cn
# 只传部分段则匹配同前缀里最新版本：1.6 → v1.6.4.1
bun run src/cli.ts -v 1.6
# 也支持 v 前缀 / commit 哈希
bun run src/cli.ts -v v1.2
bun run src/cli.ts -v eb0af1e4
```

该版本的 `Script/` 会先用 `git archive` 物化到 `.cache/script-snapshots/<version>-<commit>/`
（按 commit 缓存，重复运行直接复用），输出仍写入 `final/i18n/`。

## 翻译词典同步（copytrans）

`final/i18n/<lang>/translation.json` 是网页端（dna-builder）维护的"中文 → 各语言"术语/文案
词典，历史上由 `copy.tran.bat` + `create_translation.py` 维护。TS 工具 `src/tools/copyTranslation.ts`
等价移植：

```sh
# 仅重建 final/i18n 各语言 translation.json（读各语言导出、以 cn 为键源按 id 对齐合并更新）
bun run copytrans
# 外部网页 i18n 目录往返：拉取 → 重建 → 推回（路径也可用环境变量 DNA_BUILDER_DIR）
bun run copytrans --web D:/path/to/dna-builder/public/i18n
bun run copytrans --web <dir> --pull-only     # 只拉取
bun run copytrans --web <dir> --push-only     # 只推回
bun run copytrans --gen-only                  # 显式只重建
```

重建逻辑与 python 原版一致：`ALLOW_TYPES` / `FIELD_CONFIG` / `EX_FIELDS` / `EX_T`（含角色标签）
配置原样迁移，查词用的 TextMap 数据直接取自当前 Lua（`Script/Datas/TextMap_I18n.lua`），
不再依赖已删除的 `out/TextMap_I18n.json`。`--final <dir>` 可覆盖 i18n 根（供测试）。

## UAsset 缓存

动画、地图等资产解析结果会缓存到 `.cache/uasset.duckdb`。解包资产更新后可清空并按实际导出流程预热缓存：

```sh
bun run warmup
```

也可以只预热指定模块：

```sh
bun run src/cli.ts --warmup -f Weapon Char
```

## 检查与测试

```sh
bun test
bunx biome check src test
tsc --noEmit
```

## 地图工具

地图拼接导出是独立的 TypeScript 工具（`src/tools/exportMaps.ts`，不属于主数据导出）：

```sh
bun run export:maps
```

`--splice-dir` 默认指向解包目录的 `Map_Splice` UMG 布局目录，`--output-root` 默认为
`out/map_splice`（保留相对目录结构）。支持 `--splice-dir` / `--texture-root` /
`--output-root` / `--grid-name` / `--force-static-json` 等选项，详细见 `bun run export:maps --help`。

导出剧情节点引用的实际视频和 BGM 文件（独立于主数据导出）：

```sh
bun run src/tools/exportStoryMedia.ts
```

文件会按资源缩名复制到 `out/Video/` 和 `out/BGM/`。视频从序列中的 `FileMediaSource` 定位真实媒体文件；BGM 根据 FModel 日志中每次事件提取后保存的 `.ogg` 记录定位真实音频，并从 `dna-voice-dataset` 复制。缺少映射、一个事件对应多个 `.ogg` 或缩名冲突时命令会报错，不会静默选择文件。

地图与媒体工具默认通过 UAssetCLI server 解析 `.uasset`（见 `src/lua/UAssetServer.ts`）。解包目录解析顺序为 `DNA_UNPACK_DIR` 环境变量、仓库根目录 `.env`，最后是仓库同级的 `../dna-unpack`。
