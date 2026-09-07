import type { ModulePlugin } from "../../core/plugin.ts"
import { hardBossModule } from "./hardBossModule.ts"

export const plugins: ModulePlugin[] = [{ name: "HardBoss", build: ctx => ({ HardBoss: hardBossModule(ctx) }) }]
