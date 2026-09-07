import type { ModulePlugin } from "../../core/plugin.ts"
import { dispatchModule } from "./dispatchModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "Dispatch", deps: ["Dialogue"], build: async ctx => ({ Dispatch: await dispatchModule(ctx) }) },
]
