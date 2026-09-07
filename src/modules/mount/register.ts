import type { ModulePlugin } from "../../core/plugin.ts"
import { mountModule } from "./mountModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Mount", build: ctx => ({ Mount: mountModule(ctx) }) }]
