import type { ModulePlugin } from "../../core/plugin.ts"
import { rougeLikeRoomModule } from "./rougeLikeRoomModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "RougeLikeRoom", deps: ["Dialogue"], build: async ctx => ({ RougeLikeRoom: await rougeLikeRoomModule(ctx) }) },
]
