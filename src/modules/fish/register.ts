import type { ModulePlugin } from "../../core/plugin.ts"
import { fishingSpotModule, fishModule } from "./fishModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "Fish", build: ctx => ({ Fish: fishModule(ctx) }) },
    { name: "FishingSpot", build: ctx => ({ FishingSpot: fishingSpotModule(ctx) }) },
]
