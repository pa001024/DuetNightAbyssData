import type { ModulePlugin } from "../../core/plugin.ts"
import { regionPointModule } from "./regionPointModule.ts"

export const plugins: ModulePlugin[] = [{ name: "RegionPoint", build: ctx => ({ RegionPoint: regionPointModule(ctx) }) }]
