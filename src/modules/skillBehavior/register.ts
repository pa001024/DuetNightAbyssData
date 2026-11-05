/** SkillBehavior 纯依赖模块注册（不输出文件）。 */
import type { ModulePlugin } from "../../core/plugin.ts"
import { skillBehaviorModule } from "./skillBehaviorModule.ts"

export const plugins: ModulePlugin[] = [{ name: "SkillBehavior", deps: ["Skill"], outputs: false, build: ctx => skillBehaviorModule(ctx) }]
