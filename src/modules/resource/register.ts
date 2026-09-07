import type { ModulePlugin } from "../../core/plugin.ts"
import { resourceDataModule, resourceModule } from "./resourceModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "ResourceData", outputs: false, build: ctx => resourceDataModule(ctx) },
    { name: "Resource", deps: ["ResourceData"], uasset: true, build: ctx => ({ Resource: resourceModule(ctx) }) },
]
