import type { ModulePlugin } from "../../core/plugin.ts"
import { walnutModule } from "./walnutModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Walnut", deps: ["HardBossData", "ShopData"], build: ctx => ({ Walnut: walnutModule(ctx) }) }]
