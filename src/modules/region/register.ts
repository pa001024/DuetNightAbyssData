import type { ModulePlugin } from "../../core/plugin.ts"
import { regionModule } from "./regionModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Region", build: async ctx => ({ Region: await regionModule(ctx) }) }]
