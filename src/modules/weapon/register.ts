import type { ModulePlugin } from "../../core/plugin.ts"
import { weaponModule } from "./weaponModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Weapon", deps: ["Skill"], uasset: true, build: ctx => weaponModule(ctx) }]
