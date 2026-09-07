import type { ModulePlugin } from "../../core/plugin.ts"
import { charDataTargetModule } from "./charDataTargetModule.ts"

export const plugins: ModulePlugin[] = [{ name: "CharDataTarget", build: ctx => ({ CharDataTarget: charDataTargetModule(ctx) }) }]
