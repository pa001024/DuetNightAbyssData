import type { ModulePlugin } from "../../core/plugin.ts"
import {
    skinGachaCumulativeModule,
    skinGachaItemModule,
    skinGachaModule,
    skinGachaTabModule,
    skinGachaTypeModule,
} from "./skinGachaModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "SkinGacha", build: ctx => ({ SkinGacha: skinGachaModule(ctx) }) },
    { name: "SkinGachaTab", build: ctx => ({ SkinGachaTab: skinGachaTabModule(ctx) }) },
    { name: "SkinGachaType", build: ctx => ({ SkinGachaType: skinGachaTypeModule(ctx) }) },
    { name: "SkinGachaItem", build: ctx => ({ SkinGachaItem: skinGachaItemModule(ctx) }) },
    { name: "SkinGachaCumulative", build: ctx => ({ SkinGachaCumulative: skinGachaCumulativeModule(ctx) }) },
]
