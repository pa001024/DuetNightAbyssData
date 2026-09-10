import type { ModulePlugin } from "../../core/plugin.ts"
import { soloTreasureDropModule, soloTreasureGamePlayModule, soloTreasureModule } from "./soloTreasureModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "SoloTreasure", build: ctx => ({ SoloTreasure: soloTreasureModule(ctx) }) },
    { name: "SoloTreasureDrop", build: ctx => ({ SoloTreasureDrop: soloTreasureDropModule(ctx) }) },
    { name: "SoloTreasureGamePlay", build: ctx => ({ SoloTreasureGamePlay: soloTreasureGamePlayModule(ctx) }) },
]
