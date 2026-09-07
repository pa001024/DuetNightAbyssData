import type { ModulePlugin } from "../../core/plugin.ts"
import { walnutModule } from "./walnutModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Walnut", build: ctx => ({ Walnut: walnutModule(ctx) }) }]
