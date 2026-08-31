# DuetNightAbyssData TypeScript Agent Guide

本仓库当前的重构主线使用 Bun + TypeScript。修改代码前先确认需求、数据来源和期望输出；不要用旧 Python 目录结构或惯例推断 TypeScript 代码的行为。

## 项目边界

- `src/cli.ts` 是导出入口，负责解析参数、构建模块依赖图并写入 `final_ts/i18n/<lang>/`。
- `src/core/Graph.ts` 管理模块注册、依赖拓扑、构建产物和环检测。
- `src/modules/` 放领域模块：`skill` 提供共享技能产物，`weapon` 和 `char` 生成可输出数据。
- `src/lua/` 是 Lua/Fengari 数据访问层；`LuaDataManager` 从 `Script/Datas/*.lua` 取数并调用 `Script/Utils` 中的游戏函数。
- `src/i18n/` 保存 TextMap 和 vnode。模块构建阶段保持语言无关，输出阶段再按语言渲染。
- `src/output/` 负责将 vnode 树写成 JSON。
- `src/tools/` 提供 `final` 与 `final_ts` 的差异比较工具。
- `test/` 使用 Bun test；`final_ts/`、`out/` 是生成物，不应手工编辑。
- `tools/UAssetCLI/` 是可选的 .NET 10 uasset 解析器；只有需要动画或蓝图资产时才依赖它。

仓库仍保留旧的 Python 转换脚本和 `AGENTS.py.md`，但它们不是 TypeScript 主流程的编码约定。除非需求明确涉及旧流水线，否则不要把 Python 处理器规则迁移到 `src/`。

## 常用命令

需要 Bun 1.4+。在仓库根目录执行：

```sh
# 安装依赖（按 bun.lock 安装）
bun install --frozen-lockfile

# 运行全部 TypeScript 测试
bun test

# 运行单个测试文件或匹配测试名
bun test test/luaDataManager.test.ts
bun test --test-name-pattern "LuaDataManager"

# 默认构建 Char、Weapon，并生成六种语言到 final_ts/
bun run src/cli.ts

# 也可使用 package.json 别名
bun out -f Weapon Char --langs cn,en

# 查看已注册模块
bun run src/cli.ts --list

# 与旧输出比较（先生成 final_ts）
bun run src/tools/diffFinal.ts --lang cn
bun run src/tools/diffFinal.ts --lang cn --file Weapon
bun run src/tools/diffAll.ts --file Char --max 200

# Biome 格式化/检查和 TypeScript 检查
bun run fmt
bun run lint
```

`bun run lint` 当前脚本会执行 `biome check --write && tsc --noEmit`，因此可能修改格式；需要只做不写入的 Biome 检查时使用 `bunx biome check src test`。如果 `tsc` 报 Node/Bun 类型、探针文件或其他已有基线错误，应记录具体错误并与本次改动造成的错误分开，不要声称检查通过。

## 数据与运行前提

- 默认数据根是仓库内的 `Script/`；`Script/Datas` 和 `Script/Utils` 缺失时，Lua 相关测试或导出无法代表正常运行。
- `TextMap` 主源是 Lua；代码中已有的 `out/*.json` 回退只用于兼容旧环境。新增数据读取路径时，不得擅自增加新的 fallback、静默吞错或改变优先级；需要 fallback 时先确认需求。
- 动画资产优先读取解包目录中的 `.uasset`，由 `tools/UAssetCLI/UAssetCLI.exe` 解析；`.env` 中可设置 `DNA_UNPACK_DIR`。该 exe 需要 .NET 10 运行时。
- 资产路径、Lua 表键和游戏字段名是外部数据契约。修改解析逻辑时，先用真实样本确认字段形状，再检查相邻正例和负例。
- `final/` 是旧 Python 输出，`final_ts/` 是新输出。迁移或行为修改至少运行一个聚焦导出和对应 `diffFinal`；不要直接修改生成 JSON 来“修复”差异。

## 编码约定

- 使用 TypeScript ESM，导入本地模块时保留 `.ts` 扩展名，遵循 `tsconfig.json` 的严格模式。
- 使用 4 个空格缩进；Biome 是格式和 lint 的唯一基准，行宽配置为 140。
- Node 内置模块使用 `node:` 前缀；优先使用现有 Bun/TypeScript API 和仓库已有 helper，不为单次调用新增抽象。
- 公共接口和复杂数据结构写清楚类型；避免无依据地把 `unknown` 扩成 `any`。现有 `any` 只有在外部 Lua/JSON 边界确有必要时才沿用。
- 模块 build 应保持语言无关：文本使用 vnode/翻译 key，数值和结构保持普通 JS；不要在模块内部提前固定某种语言文本。
- `Graph` 中通过 artifacts 共享已构建结果；不要绕过依赖图重新解析同一模块。
- 保持现有错误语义。只有确实可恢复且已有调用方约定时才返回 `undefined`/空值；不要为了“健壮”吞掉可诊断错误。
- 注释只解释数据契约、算法原因或非显然约束；不要把开发过程、推测或功能说明写进用户可见输出。
- 所有临时文件均放在 `.tmp` 下，并确保在退出时删除。

## 修改与验证流程

1. 先定位调用链和真实数据样本，明确成功条件；需求或数据语义不清时先询问，不猜测。
2. 只修改实现所需文件，保留其他工作区变更；不要重排无关格式或删除旧脚本。
3. 对解析、字段映射和输出差异先添加/更新最小回归测试，再实现修改。
4. 运行相关 Bun 测试；涉及公共模块、vnode、Lua 数据层或 CLI 时，再运行完整 `bun test`。
5. 涉及导出时运行对应 CLI 和 `diffFinal`/`diffAll`。确认生成物内容后再报告结果。
6. 最后运行 `bunx biome check src test`；能修复的 lint/类型错误要修复，无法修复的基线错误要明确列出。

不要在没有用户确认的情况下新增 fallback 策略、改变数据源优先级、批量重生成无关输出，或把诊断信息变成前端/导出文案。
