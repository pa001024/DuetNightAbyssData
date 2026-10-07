import type { ModulePlugin } from "../../core/plugin.ts"
import { reviewModule } from "./reviewModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Review", build: ctx => ({ Review: reviewModule(ctx) }) }]
