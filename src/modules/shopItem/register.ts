import type { ModulePlugin } from "../../core/plugin.ts"
import { shopItemModule } from "./shopItemModule.ts"

export const plugins: ModulePlugin[] = [{ name: "ShopItem", build: ctx => ({ ShopItem: shopItemModule(ctx) }) }]
