import type { ModulePlugin } from "../../core/plugin.ts"
import { draftModule } from "./draftModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Draft", build: ctx => ({ Draft: draftModule(ctx) }) }]
