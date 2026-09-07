import type { ModulePlugin } from "../../core/plugin.ts"
import { forgeLevelQuestModule } from "./forgeLevelQuestModule.ts"

export const plugins: ModulePlugin[] = [{ name: "ForgeLevelQuest", build: ctx => ({ ForgeLevelQuest: forgeLevelQuestModule(ctx) }) }]
