import type { ModulePlugin } from "../../core/plugin.ts"
import { guildBossModule } from "./guildBossModule.ts"

export const plugins: ModulePlugin[] = [{ name: "GuildBoss", build: ctx => ({ GuildBoss: guildBossModule(ctx) }) }]
