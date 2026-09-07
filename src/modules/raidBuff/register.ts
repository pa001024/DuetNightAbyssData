import type { ModulePlugin } from "../../core/plugin.ts"
import { raidBuffModule } from "./raidBuffModule.ts"

export const plugins: ModulePlugin[] = [{ name: "RaidBuff", build: ctx => ({ RaidBuff: raidBuffModule(ctx) }) }]
