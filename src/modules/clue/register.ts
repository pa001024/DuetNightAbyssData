import type { ModulePlugin } from "../../core/plugin.ts"
import { clueModule } from "./clueModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Clue", build: ctx => ({ Clue: clueModule(ctx) }) }]
