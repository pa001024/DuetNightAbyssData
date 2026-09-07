import type { ModulePlugin } from "../../core/plugin.ts"
import { achievementModule } from "./achievementModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Achievement", build: ctx => ({ Achievement: achievementModule(ctx) }) }]
