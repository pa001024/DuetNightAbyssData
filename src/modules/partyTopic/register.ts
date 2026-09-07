import type { ModulePlugin } from "../../core/plugin.ts"
import { partyTopicModule } from "./partyTopicModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "PartyTopic", deps: ["Dialogue"], build: async ctx => ({ PartyTopic: await partyTopicModule(ctx) }) },
]
