import type { ModulePlugin } from "../../core/plugin.ts"
import { treasureHuntProgressModule, treasureHuntRepeatDungeonModule, treasureHuntStoryDungeonModule } from "./treasureHuntModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "TreasureHuntProgress", build: ctx => ({ TreasureHuntProgress: treasureHuntProgressModule(ctx) }) },
    {
        name: "TreasureHuntRepeatDungeon",
        build: ctx => ({ TreasureHuntRepeatDungeon: treasureHuntRepeatDungeonModule(ctx) }),
    },
    {
        name: "TreasureHuntStoryDungeon",
        build: ctx => ({ TreasureHuntStoryDungeon: treasureHuntStoryDungeonModule(ctx) }),
    },
]
