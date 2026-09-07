import type { ModulePlugin } from "../../core/plugin.ts"
import { charAccessoryModule } from "./charAccessoryModule.ts"

export const plugins: ModulePlugin[] = [{ name: "CharAccessory", build: ctx => ({ CharAccessory: charAccessoryModule(ctx) }) }]
