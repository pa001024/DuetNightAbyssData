import type { ModulePlugin } from "../../core/plugin.ts"
import { monsterStrongAffixesModule } from "./monsterStrongAffixesModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "MonsterStrongAffixes", build: ctx => ({ MonsterStrongAffixes: monsterStrongAffixesModule(ctx) }) },
]
