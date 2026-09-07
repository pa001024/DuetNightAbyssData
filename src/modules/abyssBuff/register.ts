import type { ModulePlugin } from "../../core/plugin.ts"
import { abyssBuffModule } from "./abyssBuffModule.ts"

export const plugins: ModulePlugin[] = [{ name: "AbyssBuff", build: ctx => ({ AbyssBuff: abyssBuffModule(ctx) }) }]
