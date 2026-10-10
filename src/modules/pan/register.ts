import type { ModulePlugin } from "../../core/plugin.ts"
import { panModule } from "./panModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "Pan", deps: ["Dialogue"], uasset: true, build: async ctx => ({ Pan: await panModule(ctx) }) },
]
