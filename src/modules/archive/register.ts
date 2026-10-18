import type { ModulePlugin } from "../../core/plugin.ts"
import { archiveModule } from "./archiveModule.ts"

export const plugins: ModulePlugin[] = [
    {
        name: "Archive",
        deps: ["BookSeriesArchive", "Char", "Monster", "ResourceData", "Weapon"],
        build: ctx => ({ Archive: archiveModule(ctx) }),
    },
]
