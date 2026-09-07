import type { ModulePlugin } from "../../core/plugin.ts"
import { questStoryModule } from "./questStoryModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "QuestStory", deps: ["Dialogue"], build: async ctx => ({ QuestStory: await questStoryModule(ctx) }) },
]
