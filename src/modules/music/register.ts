import type { ModulePlugin } from "../../core/plugin.ts"
import { musicModule, musicScoreModule } from "./musicModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "Music", build: ctx => ({ Music: musicModule(ctx) }) },
    { name: "MusicScore", build: ctx => ({ MusicScore: musicScoreModule(ctx) }) },
]
