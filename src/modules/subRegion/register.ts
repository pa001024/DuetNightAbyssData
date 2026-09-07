import type { ModulePlugin } from "../../core/plugin.ts"
import { subRegionModule } from "./subRegionModule.ts"

export const plugins: ModulePlugin[] = [{ name: "SubRegion", build: async ctx => ({ SubRegion: await subRegionModule(ctx) }) }]
