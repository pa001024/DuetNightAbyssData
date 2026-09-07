import type { ModulePlugin } from "../../core/plugin.ts"
import { extraExcelWeaponModule } from "./extraExcelWeaponModule.ts"

export const plugins: ModulePlugin[] = [{ name: "ExtraExcelWeapon", build: ctx => ({ ExtraExcelWeapon: extraExcelWeaponModule(ctx) }) }]
