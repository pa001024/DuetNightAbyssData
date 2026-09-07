import type { ModulePlugin } from "../../core/plugin.ts"
import { modModule } from "./modModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Mod", deps: ["Skill"], uasset: true, build: async ctx => ({ Mod: await modModule(ctx) }) }]
