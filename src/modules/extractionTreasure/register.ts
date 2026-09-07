import type { ModulePlugin } from "../../core/plugin.ts"
import { extractionTreasureBagModule, extractionTreasureMechanismModule, extractionTreasureModule } from "./extractionTreasureModules.ts"

export const plugins: ModulePlugin[] = [
    { name: "ExtractionTreasure", build: ctx => ({ ExtractionTreasure: extractionTreasureModule(ctx) }) },
    { name: "ExtractionTreasureBag", build: ctx => ({ ExtractionTreasureBag: extractionTreasureBagModule(ctx) }) },
    {
        name: "ExtractionTreasureMechanism",
        build: ctx => ({ ExtractionTreasureMechanism: extractionTreasureMechanismModule(ctx) }),
    },
]
