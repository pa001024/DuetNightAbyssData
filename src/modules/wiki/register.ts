import type { ModulePlugin } from "../../core/plugin.ts"
import { wikiModule } from "./wikiModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Wiki", build: ctx => ({ Wiki: wikiModule(ctx) }) }]
