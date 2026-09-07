import type { ModulePlugin } from "../../core/plugin.ts"
import { regionReputationModule } from "./regionReputationModule.ts"

export const plugins: ModulePlugin[] = [{ name: "RegionReputation", build: ctx => ({ RegionReputation: regionReputationModule(ctx) }) }]
