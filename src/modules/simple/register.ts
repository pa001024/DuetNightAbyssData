import type { ModulePlugin } from "../../core/plugin.ts"
import { hairModule, headFrameModule, headSculptureModule, weaponAccessoryModule, weaponSkinModule } from "./simpleModules.ts"

export const plugins: ModulePlugin[] = [
    { name: "WeaponAccessory", build: ctx => ({ WeaponAccessory: weaponAccessoryModule(ctx) }) },
    { name: "WeaponSkin", build: ctx => ({ WeaponSkin: weaponSkinModule(ctx) }) },
    { name: "Hair", build: ctx => ({ Hair: hairModule(ctx) }) },
    { name: "HeadFrame", build: ctx => ({ HeadFrame: headFrameModule(ctx) }) },
    { name: "HeadSculpture", build: ctx => ({ HeadSculpture: headSculptureModule(ctx) }) },
]
