import type { ModulePlugin } from "../../core/plugin.ts"
import { rougeLikeStoryEventModule } from "./rougeLikeStoryEventModule.ts"

export const plugins: ModulePlugin[] = [
    {
        name: "RougeLikeStoryEvent",
        deps: ["Dialogue"],
        build: async ctx => ({ RougeLikeStoryEvent: await rougeLikeStoryEventModule(ctx) }),
    },
]
