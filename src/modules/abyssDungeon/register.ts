import type { ModulePlugin } from "../../core/plugin.ts"
import { abyssDungeonModule } from "./abyssDungeonModule.ts"

export const plugins: ModulePlugin[] = [{ name: "AbyssDungeon", build: ctx => ({ AbyssDungeon: abyssDungeonModule(ctx) }) }]
