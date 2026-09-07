import type { ModulePlugin } from "../../core/plugin.ts"
import { charVoiceModule } from "./charVoiceModule.ts"

export const plugins: ModulePlugin[] = [{ name: "CharVoice", build: ctx => ({ CharVoice: charVoiceModule(ctx) }) }]
