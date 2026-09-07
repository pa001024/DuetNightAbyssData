import type { ModulePlugin } from "../../core/plugin.ts"
import { rewardViewModule } from "./rewardViewModule.ts"

export const plugins: ModulePlugin[] = [{ name: "RewardView", build: ctx => ({ RewardView: rewardViewModule(ctx) }) }]
