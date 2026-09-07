import type { ModulePlugin } from "../../core/plugin.ts"
import { titleModule } from "./titleModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Title", build: ctx => ({ Title: titleModule(ctx) }) }]
