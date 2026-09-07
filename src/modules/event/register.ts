import type { ModulePlugin } from "../../core/plugin.ts"
import { eventModule } from "./eventModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Event", build: ctx => ({ Event: eventModule(ctx) }) }]
