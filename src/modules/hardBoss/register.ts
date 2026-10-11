import type { ModulePlugin } from "../../core/plugin.ts"
import { hardBossDataModule, hardBossModule } from "./hardBossModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "HardBossData", outputs: false, build: ctx => hardBossDataModule(ctx) },
    { name: "HardBoss", deps: ["HardBossData"], build: ctx => ({ HardBoss: hardBossModule(ctx) }) },
]
