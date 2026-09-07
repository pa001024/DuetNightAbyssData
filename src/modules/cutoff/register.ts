import type { ModulePlugin } from "../../core/plugin.ts"
import { cutoffModule } from "./cutoffModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Cutoff", build: ctx => ({ Cutoff: cutoffModule(ctx) }) }]
