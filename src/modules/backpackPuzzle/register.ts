import type { ModulePlugin } from "../../core/plugin.ts"
import { backpackPuzzleItemModule, backpackPuzzleLevelModule } from "./backpackPuzzleModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "BackpackPuzzleItem", build: ctx => ({ BackpackPuzzleItem: backpackPuzzleItemModule(ctx) }) },
    { name: "BackpackPuzzleLevel", build: ctx => ({ BackpackPuzzleLevel: backpackPuzzleLevelModule(ctx) }) },
]
