import type { ModulePlugin } from "../../core/plugin.ts"
import { questChainModule } from "./questChainModule.ts"

export const plugins: ModulePlugin[] = [{ name: "QuestChain", build: ctx => ({ QuestChain: questChainModule(ctx) }) }]
