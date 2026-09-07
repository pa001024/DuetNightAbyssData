import type { ModulePlugin } from "../../core/plugin.ts"
import { ironSurvivalMonsterSpawnModule } from "./ironSurvivalMonsterSpawnModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "IronSurvivalMonsterSpawn", build: ctx => ({ IronSurvivalMonsterSpawn: ironSurvivalMonsterSpawnModule(ctx) }) },
]
