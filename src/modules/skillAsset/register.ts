/** SkillAsset 语言无关产物模块注册（final/skill-behavior.json）。 */
import type { ModulePlugin } from "../../core/plugin.ts"
import { skillAssetModule } from "./skillAssetModule.ts"

export const plugins: ModulePlugin[] = [
    {
        name: "SkillAsset",
        deps: ["Skill", "SkillBehavior"],
        outputs: true,
        uasset: true,
        languageNeutral: true,
        build: ctx => skillAssetModule(ctx),
    },
]
