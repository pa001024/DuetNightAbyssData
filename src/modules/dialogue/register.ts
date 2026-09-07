/** Dialogue 纯依赖模块插件注册。 */
import type { ModulePlugin } from "../../core/plugin.ts"
import { dialogueModule } from "./dialogueModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Dialogue", outputs: false, build: ctx => dialogueModule(ctx) }]
