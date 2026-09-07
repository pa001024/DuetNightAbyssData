import type { ModulePlugin } from "../../core/plugin.ts"
import {
    rougeLikeBlessingGroupModule,
    rougeLikeBlessingModule,
    rougeLikeContractModule,
    rougeLikeTalentBranchModule,
    rougeLikeTalentModule,
    rougeLikeTreasureGroupModule,
    rougeLikeTreasureModule,
    rougeProClassModule,
    rougeProConvertModule,
    rougeProTableModule,
    rougeProTalentModule,
    rougeProTreasureModule,
} from "./rougeSimpleModules.ts"

/** RougePro 通用表插件工厂：表名即模块名/输出文件名。 */
const proTablePlugin = (table: string): ModulePlugin => ({
    name: table,
    build: ctx => ({ [table]: rougeProTableModule(ctx, table) }),
})

const ROUGE_PRO_TABLES = [
    "RougeProContract",
    "RougeProDifficulty",
    "RougeProEffect",
    "RougeProSeason",
    "RougeProShopRandom",
    "RougeProTreasureGroup",
    "RougeProTreasureRandom",
    "RougePro_Defence",
    "RougePro_Event",
    "RougePro_EventArea",
    "RougePro_Exterminate",
    "RougePro_KillEliteMob",
    "RougePro_MSRound",
    "RougePro_MonsterSP",
    "RougePro_Occupation",
    "RougePro_RewardDropBox",
    "RougePro_Room",
    "RougePro_SabotagePro",
    "RougePro_SurvivalPro",
]

export const plugins: ModulePlugin[] = [
    { name: "RougeLikeTalentBranch", build: ctx => ({ RougeLikeTalentBranch: rougeLikeTalentBranchModule(ctx) }) },
    { name: "RougeLikeBlessingGroup", build: ctx => ({ RougeLikeBlessingGroup: rougeLikeBlessingGroupModule(ctx) }) },
    { name: "RougeLikeTreasureGroup", build: ctx => ({ RougeLikeTreasureGroup: rougeLikeTreasureGroupModule(ctx) }) },
    { name: "RougeLikeBlessing", deps: ["Mod"], build: ctx => ({ RougeLikeBlessing: rougeLikeBlessingModule(ctx) }) },
    { name: "RougeLikeContract", build: ctx => ({ RougeLikeContract: rougeLikeContractModule(ctx) }) },
    { name: "RougeLikeTalent", deps: ["Mod"], build: ctx => ({ RougeLikeTalent: rougeLikeTalentModule(ctx) }) },
    { name: "RougeLikeTreasure", deps: ["Mod"], build: ctx => ({ RougeLikeTreasure: rougeLikeTreasureModule(ctx) }) },
    { name: "RougeProClass", build: ctx => ({ RougeProClass: rougeProClassModule(ctx) }) },
    { name: "RougeProConvert", build: ctx => ({ RougeProConvert: rougeProConvertModule(ctx) }) },
    { name: "RougeProTalent", deps: ["Mod"], build: ctx => ({ RougeProTalent: rougeProTalentModule(ctx) }) },
    { name: "RougeProTreasure", build: ctx => ({ RougeProTreasure: rougeProTreasureModule(ctx) }) },
    ...ROUGE_PRO_TABLES.map(proTablePlugin),
]
