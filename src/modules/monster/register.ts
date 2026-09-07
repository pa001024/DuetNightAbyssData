import type { ModulePlugin } from "../../core/plugin.ts"
import { monsterModule } from "./monsterModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Monster", build: ctx => ({ Monster: monsterModule(ctx) }) }]
