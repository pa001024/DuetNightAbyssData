import type { ModulePlugin } from "../../core/plugin.ts"
import { optRewardModule, rewardModule } from "./rewardModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "Reward", build: ctx => ({ Reward: rewardModule(ctx) }) },
    { name: "OptReward", build: ctx => ({ OptReward: optRewardModule(ctx) }) },
]
