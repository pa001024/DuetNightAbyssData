import type { ModulePlugin } from "../../core/plugin.ts"
import { bookSeriesArchiveModule } from "./bookSeriesArchiveModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "BookSeriesArchive", deps: ["ResourceData"], build: ctx => ({ BookSeriesArchive: bookSeriesArchiveModule(ctx) }) },
]
