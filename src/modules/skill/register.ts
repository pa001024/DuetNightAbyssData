/** Skill 纯依赖模块插件注册。 */
import type { ModulePlugin } from "../../core/plugin.ts"
import { skillModule } from "./skillModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Skill", outputs: false, build: ctx => skillModule(ctx) }]
