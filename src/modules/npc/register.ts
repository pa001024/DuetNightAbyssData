import type { ModulePlugin } from "../../core/plugin.ts"
import { npcModule } from "./npcModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Npc", deps: ["Dialogue"], build: ctx => ({ Npc: npcModule(ctx) }) }]
