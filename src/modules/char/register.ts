import type { ModulePlugin } from "../../core/plugin.ts"
import { charModule } from "./charModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Char", deps: ["Skill"], uasset: true, build: ctx => charModule(ctx) }]
