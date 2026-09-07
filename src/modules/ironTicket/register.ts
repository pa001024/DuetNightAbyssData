import type { ModulePlugin } from "../../core/plugin.ts"
import { ironTicketModule } from "./ironTicketModule.ts"

export const plugins: ModulePlugin[] = [{ name: "IronTicket", build: ctx => ({ IronTicket: ironTicketModule(ctx) }) }]
