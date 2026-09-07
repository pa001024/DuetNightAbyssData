import type { ModulePlugin } from "../../core/plugin.ts"
import { dynQuestModule } from "./dynQuestModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "DynQuest", deps: ["Dialogue"], build: async ctx => ({ DynQuest: await dynQuestModule(ctx) }) },
]
