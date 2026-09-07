# DuetNightAbyssData Agent Guide

本仓库的唯一主线是 TypeScript/Bun 流水线，直接从 Lua/资产数据构建并输出多语言 JSON。
Python 脚本仅保留为独立的地图工具或明确指定的历史工具，不参与正常数据导出。不要因为旧
Python 目录结构、处理器命名或历史输出习惯，就推断 TypeScript 的行为。

## 工作原则

- 从原始需求、真实数据和期望输出出发。目标或字段语义不清时先询问，不猜测。
- 先追调用链和数据来源，再修改最小范围；不要用模板化重构或旁路补丁掩盖根因。
- 任何新增 fallback、改变数据源优先级、静默吞错或把错误转换为空值的方案，都必须先得到用户确认。
- 前端/导出文案必须面向最终使用者；不要把开发过程、推测或诊断信息写入用户可见输出。
- 保留无关工作区修改。生成物不得通过手工编辑来修复实现问题。

## 当前架构

TypeScript 流水线直接从游戏 Lua/资产数据构建多语言导出，不经过 Python JSON 中间层：

```text
src/cli.ts
  -> 插件发现（src/modules/*/register.ts）与目标解析
src/core/Graph.ts
  -> 依赖拓扑、环检测、一次性 build、artifacts 共享
src/core/plugin.ts
  -> 插件契约（ModulePlugin）与目录级自动发现/校验
src/lua/LuaDataManager.ts
  -> Fengari 常驻 Lua state，读取 Script/Datas/*.lua，调用 Script/Utils/*.lua
src/modules/*
  -> 领域模块，构建语言无关的 vnode/普通数据
src/i18n/vnode.ts + TextMap.ts
  -> 保留文本 key 和模板占位符，按语言渲染
src/output/OutputCollector.ts
  -> 写入 final/i18n/<lang>/*.json
```

关键约束：

- `skill` 是共享的纯依赖模块，不直接输出文件；它暴露技能数值计算、字段解释、战斗元数据和
  实体/子技能等 artifacts。`char`、`weapon` 依赖 `skill`。
- 领域模块以插件形式注册：每个模块目录 `src/modules/<dir>/register.ts` 导出
  `plugins: ModulePlugin[]`（契约见 `src/core/plugin.ts`），主程序只做目录级自动发现，
  不静态 import 具体模块。模块返回单个 vnode 树或 `{ 文件名: vnode 树 }`；
  新增模块只需新增目录与 register.ts，无需修改主程序，但必须声明真实依赖。
- Graph 只负责构建顺序和 artifacts 传递，不应被模块绕过来重复解析同一依赖。
- 模块 build 阶段必须语言无关：名称、描述和模板使用 `T`、`LTemplate`、`compile` 等 vnode
  表达；语言选择只发生在输出阶段。
- `final/` 是 TypeScript 的正式输出目录；生成文件不得手工编辑。

### 数据与资产边界

- Lua 是 TypeScript 数据主源：`LuaDataManager` 从 `Script/Datas` 懒加载表，并在同一个 Fengari
  state 中运行 `Script/Utils` 的游戏函数。需要结构化遍历时才将表物化为 JS 并缓存。
- `TextMap` 主要读取 `TextMap_I18n.lua`，中文分片表通过物化读取。代码中已有的语言字段回退、
  少量历史文本常量和资产 JSON 兼容路径属于现存行为；不得未经确认扩大其适用范围或调整优先级。
- 动画 Montage 元数据由 `AssetReader` 读取。UAssetCLI server 可直接解析解包目录中的 `.uasset`；
  同路径 `.json` 兼容读取仍存在。解包目录可由 `.env` 的 `DNA_UNPACK_DIR` 指定，UAssetCLI 需要
  .NET 10。
- 资产路径、Lua 表键、游戏字段名和 UAsset/FModel 属性名都是外部数据契约。剧情媒体节点输出
  `name` 使用节点实际名称，`resource` 使用按 icon 规则缩短的资源名。修改解析前必须用
  真实样本确认字段形状，并检查相邻正例和负例。

### 近期提交与正在收敛方向

近期重构提交和当前工作区的新增模块反映了下一阶段方向；除已由测试和差异输出确认的行为外，
这些方向仍不应被扩展成未经验证的全局契约：

- vnode 模板占位符按完整索引匹配（例如 `#1` 不得误替换 `#10`），数值格式继续对齐 Lua 的
  `FormatDescValue1` 舍入规则。
- 召唤物 effect 索引改为首次使用时懒加载并缓存，避免技能模块初始化时无条件读取全部召唤物表。
- Char/Weapon 的动画读取暂时保留 JSON 时间线结果的偏好；在资产路径和数值舍入验证完成前，
  不要把该偏好扩展成新的全局优先级。
- 稀疏数字键表、单值/对象形态的字段归一化，以及技能/伤害标签链仍需以真实 Lua 数据和差异输出
  逐项验证，不能仅凭字段名称泛化规则。

## 常用 TypeScript 命令

需要 Bun 1.4+。在仓库根目录执行：

```sh
# 依 bun.lock 安装依赖
bun install --frozen-lockfile

# 全部 TypeScript 测试，或运行聚焦测试
bun test
bun test test/luaDataManager.test.ts
bun test --test-name-pattern "LuaDataManager"

# 默认构建所有已注册的输出模块并生成六种语言
bun run src/cli.ts

# 构建指定模块/语言；模块名按 registry 的小写名称传入
bun out -f Weapon Char --langs cn,en
bun run src/cli.ts --list

# 检查
bunx biome check src test
tsc --noEmit

# 独立导出剧情媒体文件（不属于主 out CLI）
bun run src/tools/exportStoryMedia.ts

# 独立 agent：逐 QuestChain 生成剧情 AI 总结（storysummary，非主 out CLI；仅生成缺失/变更项，
# 输出 final/i18n/cn/storySummary.json，配置见 .env 的 STORY_SUMMARY_*）
bun run src/tools/storySummary/agent.ts --dry-run   # 测试/演练：只报告，不调用任何 API
bun run src/tools/storySummary/agent.ts             # 真实生成（前置: bun out -f QuestChain QuestStory）
```

`bun run lint` 当前会执行 `biome check --write && tsc --noEmit`，可能改写格式；运行前先确认
工作区状态。若 TypeScript/Bun/探针等已有基线错误，必须把它们与本次改动引入的错误分开记录，
不能笼统声称检查通过。

## 编码约定

- 使用 TypeScript ESM；本地导入保留 `.ts` 扩展名；遵循严格类型检查和 4 空格缩进。
- Biome 是格式和 lint 基准，行宽为 140；Node 内置模块使用 `node:` 前缀。
- 公共接口和复杂结构写清楚类型；只有在 Lua/JSON 外部边界确有必要时才使用 `any`。
- 优先复用 `LuaDataManager`、Graph artifacts、vnode 和现有模块 helper，不为单次调用增加抽象。
- 注释只说明数据契约、算法原因或非显然约束；不要把猜测写成事实。
- 保持既有错误语义。只有调用方明确约定可恢复时才返回 `undefined`、空集合或默认值。
- 临时文件放在 `.tmp/`文件夹下，退出前清理。

## 测试与导出验证

1. 先用真实样本确认数据字段和成功条件；解析/字段映射变更先写最小回归测试。
2. 运行受影响的 Bun 测试；涉及 Graph、vnode、Lua 数据层、CLI 或共享 skill artifacts 时再运行完整 `bun test`。
3. 涉及导出时运行对应 CLI，并使用 `diffFinal`/`diffAll` 检查旧输出与新输出；确认生成内容后再报告。
4. 最后运行 `bunx biome check src test` 和必要的 `tsc --noEmit`，明确区分已修复、基线失败和未验证边界。

## Python 工具

地图脚本等独立 Python 工具的约定见 [`AGENTS.py.md`](AGENTS.py.md)。它们不生成正式数据导出，
也不应被重新接回 TypeScript 主线。

## 禁止事项

- 未确认就新增 fallback、改变 Lua/uasset/JSON 数据源优先级或静默吞掉解析错误。
- 手工编辑 `final/` 或把生成结果当作实现代码提交。
- 用旧 Python Processor 的结构替代 TypeScript 模块依赖图，或绕过共享 artifacts 重复加载数据。
- 在导出文本中写入调试日志、开发思路、推测性说明或面向开发者的功能解释。
