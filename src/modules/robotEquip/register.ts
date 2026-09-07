import type { ModulePlugin } from "../../core/plugin.ts"
import { robotEquipModule } from "./robotEquipModule.ts"

export const plugins: ModulePlugin[] = [{ name: "RobotEquip", build: ctx => ({ RobotEquip: robotEquipModule(ctx) }) }]
