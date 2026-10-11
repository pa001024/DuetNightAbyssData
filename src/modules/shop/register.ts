import type { ModulePlugin } from "../../core/plugin.ts"
import { shopDataModule } from "./shopDataModule.ts"

export const plugins: ModulePlugin[] = [{ name: "ShopData", outputs: false, build: ctx => shopDataModule(ctx) }]
