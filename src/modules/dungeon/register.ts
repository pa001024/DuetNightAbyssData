import type { ModulePlugin } from "../../core/plugin.ts"
import { dungeonModule } from "./dungeonModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Dungeon", build: ctx => ({ Dungeon: dungeonModule(ctx) }) }]
