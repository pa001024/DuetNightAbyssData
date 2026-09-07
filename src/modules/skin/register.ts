import type { ModulePlugin } from "../../core/plugin.ts"
import { skinModule } from "./skinModule.ts"

export const plugins: ModulePlugin[] = [{ name: "Skin", build: ctx => ({ Skin: skinModule(ctx) }) }]
