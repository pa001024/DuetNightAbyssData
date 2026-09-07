import type { ModulePlugin } from "../../core/plugin.ts"
import { impressionShopModule } from "./impressionShopModule.ts"

export const plugins: ModulePlugin[] = [{ name: "ImpressionShop", build: ctx => ({ ImpressionShop: impressionShopModule(ctx) }) }]
