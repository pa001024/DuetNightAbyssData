import type { ModulePlugin } from "../../core/plugin.ts"
import { soloTreasureGamePlayModule, soloTreasureModule } from "./soloTreasureModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "SoloTreasure", build: ctx => ({ SoloTreasure: soloTreasureModule(ctx) }) },
    { name: "SoloTreasureGamePlay", build: ctx => ({ SoloTreasureGamePlay: soloTreasureGamePlayModule(ctx) }) },
]
