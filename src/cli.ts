#!/usr/bin/env bun
import { join } from "node:path"
/**
 * CLI — DuetNightAbyssData TS 重构入口。
 *
 * 用法（对齐原版 step3_output.py）：
 *   bun out -f Weapon Char                       # 构建指定模块并输出全部语言
 *   bun out -f Weapon Char --langs cn,en          # 指定语言
 *   bun out --list                                # 列出已注册模块
 *   bun run warmup                                # 清空并预热 UAsset DuckDB 缓存
 *
 * 流程：建图 → 拓扑序执行 build（Lua 混合层取数+计算，产出 vnode 树）→
 *       逐语言渲染 → 写 final_ts/i18n/<lang>/<file>.json
 */
import { Graph } from "./core/Graph.ts"
import { getTextMap, LANGS } from "./i18n/TextMap.ts"
import { clearUAssetCache, closeUAssetServer } from "./lua/UAssetServer.ts"
import { abyssBuffModule } from "./modules/abyssBuff/abyssBuffModule.ts"
import { achievementModule } from "./modules/achievement/achievementModule.ts"
import { backpackPuzzleItemModule, backpackPuzzleLevelModule } from "./modules/backpackPuzzle/backpackPuzzleModule.ts"
import { charModule } from "./modules/char/charModule.ts"
import { charAccessoryModule } from "./modules/charAccessory/charAccessoryModule.ts"
import { charDataTargetModule } from "./modules/charDataTarget/charDataTargetModule.ts"
import { charVoiceModule } from "./modules/charVoice/charVoiceModule.ts"
import { cutoffModule } from "./modules/cutoff/cutoffModule.ts"
import { dialogueModule } from "./modules/dialogue/dialogueModule.ts"
import { draftModule } from "./modules/draft/draftModule.ts"
import { eventModule } from "./modules/event/eventModule.ts"
import {
    extractionTreasureBagModule,
    extractionTreasureMechanismModule,
    extractionTreasureModule,
} from "./modules/extractionTreasure/extractionTreasureModules.ts"
import { extraExcelWeaponModule } from "./modules/extraExcelWeapon/extraExcelWeaponModule.ts"
import { fishingSpotModule, fishModule } from "./modules/fish/fishModule.ts"
import { forgeLevelQuestModule } from "./modules/forgeLevelQuest/forgeLevelQuestModule.ts"
import { hardBossModule } from "./modules/hardBoss/hardBossModule.ts"
import { impressionShopModule } from "./modules/impressionShop/impressionShopModule.ts"
import { ironTicketModule } from "./modules/ironTicket/ironTicketModule.ts"
import { modModule } from "./modules/mod/modModule.ts"
import { monsterModule } from "./modules/monster/monsterModule.ts"
import { monsterStrongAffixesModule } from "./modules/monsterStrongAffixes/monsterStrongAffixesModule.ts"
import { mountModule } from "./modules/mount/mountModule.ts"
import { musicModule, musicScoreModule } from "./modules/music/musicModule.ts"
import { partyTopicModule } from "./modules/partyTopic/partyTopicModule.ts"
import { petEntryModule } from "./modules/pet/petEntryModule.ts"
import { petModule } from "./modules/pet/petModule.ts"
import { questChainModule } from "./modules/questChain/questChainModule.ts"
import { questStoryModule } from "./modules/questStory/questStoryModule.ts"
import { raidBuffModule } from "./modules/raidBuff/raidBuffModule.ts"
import { regionPointModule } from "./modules/regionPoint/regionPointModule.ts"
import { regionReputationModule } from "./modules/regionReputation/regionReputationModule.ts"
import {
    abyssDungeonModule,
    bookSeriesArchiveModule,
    dispatchModule,
    dungeonModule,
    dynQuestModule,
    ironSurvivalMonsterSpawnModule,
    npcModule,
    regionModule,
    rougeLikeRoomModule,
    rougeLikeStoryEventModule,
    subRegionModule,
} from "./modules/remainingModules.ts"
import { resourceModule } from "./modules/resource/resourceModule.ts"
import { optRewardModule, rewardModule } from "./modules/reward/rewardModule.ts"
import { rewardViewModule } from "./modules/rewardView/rewardViewModule.ts"
import { robotEquipModule } from "./modules/robotEquip/robotEquipModule.ts"
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
} from "./modules/rouge/rougeSimpleModules.ts"
import { shopItemModule } from "./modules/shopItem/shopItemModule.ts"
import {
    hairModule,
    headFrameModule,
    headSculptureModule,
    weaponAccessoryModule,
    weaponSkinModule,
} from "./modules/simple/simpleModules.ts"
import { skillModule } from "./modules/skill/skillModule.ts"
import { skinModule } from "./modules/skin/skinModule.ts"
import {
    skinGachaCumulativeModule,
    skinGachaItemModule,
    skinGachaModule,
    skinGachaTabModule,
    skinGachaTypeModule,
} from "./modules/skinGacha/skinGachaModule.ts"
import { soloTreasureGamePlayModule, soloTreasureModule } from "./modules/soloTreasure/soloTreasureModule.ts"
import { titleModule } from "./modules/title/titleModule.ts"
import {
    treasureHuntProgressModule,
    treasureHuntRepeatDungeonModule,
    treasureHuntStoryDungeonModule,
} from "./modules/treasureHunt/treasureHuntModule.ts"
import { walnutModule } from "./modules/walnut/walnutModule.ts"
import { weaponModule } from "./modules/weapon/weaponModule.ts"
import { OutputCollector } from "./output/OutputCollector.ts"

interface ModuleReg {
    name: string
    deps: string[]
    build: (ctx: any) => unknown
    outputs: boolean
}

const REGISTRY: ModuleReg[] = [
    { name: "Skill", deps: [], outputs: false, build: ctx => skillModule(ctx) },
    { name: "Dialogue", deps: [], outputs: false, build: ctx => dialogueModule(ctx) },
    { name: "AbyssBuff", deps: [], outputs: true, build: ctx => ({ AbyssBuff: abyssBuffModule(ctx) }) },
    { name: "Achievement", deps: [], outputs: true, build: ctx => ({ Achievement: achievementModule(ctx) }) },
    { name: "Weapon", deps: ["Skill"], outputs: true, build: ctx => weaponModule(ctx) },
    { name: "Char", deps: ["Skill"], outputs: true, build: ctx => charModule(ctx) },
    { name: "Cutoff", deps: [], outputs: true, build: ctx => ({ Cutoff: cutoffModule(ctx) }) },
    { name: "CharVoice", deps: [], outputs: true, build: ctx => ({ CharVoice: charVoiceModule(ctx) }) },
    { name: "CharAccessory", deps: [], outputs: true, build: ctx => ({ CharAccessory: charAccessoryModule(ctx) }) },
    { name: "Draft", deps: [], outputs: true, build: ctx => ({ Draft: draftModule(ctx) }) },
    { name: "ExtraExcelWeapon", deps: [], outputs: true, build: ctx => ({ ExtraExcelWeapon: extraExcelWeaponModule(ctx) }) },
    { name: "IronTicket", deps: [], outputs: true, build: ctx => ({ IronTicket: ironTicketModule(ctx) }) },
    { name: "Walnut", deps: [], outputs: true, build: ctx => ({ Walnut: walnutModule(ctx) }) },
    { name: "Reward", deps: [], outputs: true, build: ctx => ({ Reward: rewardModule(ctx) }) },
    { name: "OptReward", deps: [], outputs: true, build: ctx => ({ OptReward: optRewardModule(ctx) }) },
    { name: "RewardView", deps: [], outputs: true, build: ctx => ({ RewardView: rewardViewModule(ctx) }) },
    { name: "Resource", deps: [], outputs: true, build: async ctx => ({ Resource: await resourceModule(ctx) }) },
    { name: "Skin", deps: [], outputs: true, build: ctx => ({ Skin: skinModule(ctx) }) },
    { name: "SkinGacha", deps: [], outputs: true, build: ctx => ({ SkinGacha: skinGachaModule(ctx) }) },
    { name: "SkinGachaTab", deps: [], outputs: true, build: ctx => ({ SkinGachaTab: skinGachaTabModule(ctx) }) },
    { name: "SkinGachaType", deps: [], outputs: true, build: ctx => ({ SkinGachaType: skinGachaTypeModule(ctx) }) },
    { name: "SkinGachaItem", deps: [], outputs: true, build: ctx => ({ SkinGachaItem: skinGachaItemModule(ctx) }) },
    { name: "SkinGachaCumulative", deps: [], outputs: true, build: ctx => ({ SkinGachaCumulative: skinGachaCumulativeModule(ctx) }) },
    { name: "QuestChain", deps: [], outputs: true, build: ctx => ({ QuestChain: questChainModule(ctx) }) },
    { name: "QuestStory", deps: ["Dialogue"], outputs: true, build: ctx => ({ QuestStory: questStoryModule(ctx) }) },
    { name: "PartyTopic", deps: ["Dialogue"], outputs: true, build: ctx => ({ PartyTopic: partyTopicModule(ctx) }) },
    { name: "WeaponAccessory", deps: [], outputs: true, build: ctx => ({ WeaponAccessory: weaponAccessoryModule(ctx) }) },
    { name: "WeaponSkin", deps: [], outputs: true, build: ctx => ({ WeaponSkin: weaponSkinModule(ctx) }) },
    { name: "Hair", deps: [], outputs: true, build: ctx => ({ Hair: hairModule(ctx) }) },
    { name: "HeadFrame", deps: [], outputs: true, build: ctx => ({ HeadFrame: headFrameModule(ctx) }) },
    { name: "HeadSculpture", deps: [], outputs: true, build: ctx => ({ HeadSculpture: headSculptureModule(ctx) }) },
    { name: "Mount", deps: [], outputs: true, build: ctx => ({ Mount: mountModule(ctx) }) },
    { name: "Mod", deps: ["Skill"], outputs: true, build: async ctx => ({ Mod: await modModule(ctx) }) },
    { name: "Monster", deps: [], outputs: true, build: ctx => ({ Monster: monsterModule(ctx) }) },
    { name: "MonsterStrongAffixes", deps: [], outputs: true, build: ctx => ({ MonsterStrongAffixes: monsterStrongAffixesModule(ctx) }) },
    { name: "Fish", deps: [], outputs: true, build: ctx => ({ Fish: fishModule(ctx) }) },
    { name: "FishingSpot", deps: [], outputs: true, build: ctx => ({ FishingSpot: fishingSpotModule(ctx) }) },
    { name: "Music", deps: [], outputs: true, build: ctx => ({ Music: musicModule(ctx) }) },
    { name: "MusicScore", deps: [], outputs: true, build: ctx => ({ MusicScore: musicScoreModule(ctx) }) },
    { name: "BackpackPuzzleItem", deps: [], outputs: true, build: ctx => ({ BackpackPuzzleItem: backpackPuzzleItemModule(ctx) }) },
    { name: "BackpackPuzzleLevel", deps: [], outputs: true, build: ctx => ({ BackpackPuzzleLevel: backpackPuzzleLevelModule(ctx) }) },
    { name: "ForgeLevelQuest", deps: [], outputs: true, build: ctx => ({ ForgeLevelQuest: forgeLevelQuestModule(ctx) }) },
    { name: "RegionPoint", deps: [], outputs: true, build: ctx => ({ RegionPoint: regionPointModule(ctx) }) },
    { name: "RegionReputation", deps: [], outputs: true, build: ctx => ({ RegionReputation: regionReputationModule(ctx) }) },
    { name: "RougeLikeTalentBranch", deps: [], outputs: true, build: ctx => ({ RougeLikeTalentBranch: rougeLikeTalentBranchModule(ctx) }) },
    {
        name: "RougeLikeBlessingGroup",
        deps: [],
        outputs: true,
        build: ctx => ({ RougeLikeBlessingGroup: rougeLikeBlessingGroupModule(ctx) }),
    },
    {
        name: "RougeLikeTreasureGroup",
        deps: [],
        outputs: true,
        build: ctx => ({ RougeLikeTreasureGroup: rougeLikeTreasureGroupModule(ctx) }),
    },
    { name: "RougeLikeBlessing", deps: ["Mod"], outputs: true, build: ctx => ({ RougeLikeBlessing: rougeLikeBlessingModule(ctx) }) },
    { name: "RougeLikeContract", deps: [], outputs: true, build: ctx => ({ RougeLikeContract: rougeLikeContractModule(ctx) }) },
    { name: "RougeLikeTalent", deps: ["Mod"], outputs: true, build: ctx => ({ RougeLikeTalent: rougeLikeTalentModule(ctx) }) },
    { name: "RougeLikeTreasure", deps: ["Mod"], outputs: true, build: ctx => ({ RougeLikeTreasure: rougeLikeTreasureModule(ctx) }) },
    { name: "RougeProClass", deps: [], outputs: true, build: ctx => ({ RougeProClass: rougeProClassModule(ctx) }) },
    { name: "RougeProConvert", deps: [], outputs: true, build: ctx => ({ RougeProConvert: rougeProConvertModule(ctx) }) },
    { name: "RougeProTalent", deps: ["Mod"], outputs: true, build: ctx => ({ RougeProTalent: rougeProTalentModule(ctx) }) },
    { name: "RougeProTreasure", deps: [], outputs: true, build: ctx => ({ RougeProTreasure: rougeProTreasureModule(ctx) }) },
    ...[
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
    ].map(tableName => ({
        name: tableName,
        deps: [],
        outputs: true,
        build: (ctx: any) => ({ [tableName]: rougeProTableModule(ctx, tableName) }),
    })),
    { name: "HardBoss", deps: [], outputs: true, build: ctx => ({ HardBoss: hardBossModule(ctx) }) },
    { name: "CharDataTarget", deps: [], outputs: true, build: ctx => ({ CharDataTarget: charDataTargetModule(ctx) }) },
    { name: "TreasureHuntProgress", deps: [], outputs: true, build: ctx => ({ TreasureHuntProgress: treasureHuntProgressModule(ctx) }) },
    {
        name: "TreasureHuntRepeatDungeon",
        deps: [],
        outputs: true,
        build: ctx => ({ TreasureHuntRepeatDungeon: treasureHuntRepeatDungeonModule(ctx) }),
    },
    {
        name: "TreasureHuntStoryDungeon",
        deps: [],
        outputs: true,
        build: ctx => ({ TreasureHuntStoryDungeon: treasureHuntStoryDungeonModule(ctx) }),
    },
    { name: "SoloTreasure", deps: [], outputs: true, build: ctx => ({ SoloTreasure: soloTreasureModule(ctx) }) },
    { name: "SoloTreasureGamePlay", deps: [], outputs: true, build: ctx => ({ SoloTreasureGamePlay: soloTreasureGamePlayModule(ctx) }) },
    { name: "PetEntry", deps: [], outputs: true, build: ctx => ({ PetEntry: petEntryModule(ctx) }) },
    { name: "Pet", deps: ["Skill"], outputs: true, build: ctx => ({ Pet: petModule(ctx) }) },
    { name: "ShopItem", deps: [], outputs: true, build: ctx => ({ ShopItem: shopItemModule(ctx) }) },
    { name: "Title", deps: [], outputs: true, build: ctx => ({ Title: titleModule(ctx) }) },
    { name: "Event", deps: [], outputs: true, build: ctx => ({ Event: eventModule(ctx) }) },
    { name: "ExtractionTreasure", deps: [], outputs: true, build: ctx => ({ ExtractionTreasure: extractionTreasureModule(ctx) }) },
    { name: "ExtractionTreasureBag", deps: [], outputs: true, build: ctx => ({ ExtractionTreasureBag: extractionTreasureBagModule(ctx) }) },
    {
        name: "ExtractionTreasureMechanism",
        deps: [],
        outputs: true,
        build: ctx => ({ ExtractionTreasureMechanism: extractionTreasureMechanismModule(ctx) }),
    },
    { name: "ImpressionShop", deps: [], outputs: true, build: ctx => ({ ImpressionShop: impressionShopModule(ctx) }) },
    { name: "RobotEquip", deps: [], outputs: true, build: ctx => ({ RobotEquip: robotEquipModule(ctx) }) },
    { name: "RaidBuff", deps: [], outputs: true, build: ctx => ({ RaidBuff: raidBuffModule(ctx) }) },
    { name: "AbyssDungeon", deps: [], outputs: true, build: ctx => ({ AbyssDungeon: abyssDungeonModule(ctx) }) },
    { name: "BookSeriesArchive", deps: [], outputs: true, build: ctx => ({ BookSeriesArchive: bookSeriesArchiveModule(ctx) }) },
    { name: "Dispatch", deps: ["Dialogue"], outputs: true, build: ctx => ({ Dispatch: dispatchModule(ctx) }) },
    { name: "DynQuest", deps: ["Dialogue"], outputs: true, build: ctx => ({ DynQuest: dynQuestModule(ctx) }) },
    { name: "Dungeon", deps: [], outputs: true, build: ctx => ({ Dungeon: dungeonModule(ctx) }) },
    {
        name: "IronSurvivalMonsterSpawn",
        deps: [],
        outputs: true,
        build: ctx => ({ IronSurvivalMonsterSpawn: ironSurvivalMonsterSpawnModule(ctx) }),
    },
    { name: "Npc", deps: ["Dialogue"], outputs: true, build: ctx => ({ Npc: npcModule(ctx) }) },
    { name: "Region", deps: [], outputs: true, build: ctx => ({ Region: regionModule(ctx) }) },
    { name: "SubRegion", deps: [], outputs: true, build: ctx => ({ SubRegion: subRegionModule(ctx) }) },
    { name: "RougeLikeRoom", deps: [], outputs: true, build: ctx => ({ RougeLikeRoom: rougeLikeRoomModule(ctx) }) },
    {
        name: "RougeLikeStoryEvent",
        deps: ["Dialogue"],
        outputs: true,
        build: ctx => ({ RougeLikeStoryEvent: rougeLikeStoryEventModule(ctx) }),
    },
]

const UASSET_MODULES = ["Resource", "Weapon", "Char", "Mod"]

interface CliArgs {
    files: string[]
    langs: string[]
    list: boolean
    warmup: boolean
}

/** 解析 argv：支持文件类型、语言、模块列表和 UAsset DuckDB 缓存预热。 */
function parseArgs(argv: string[]): CliArgs {
    const files: string[] = []
    const langs: string[] = []
    let list = false
    let warmup = false
    let i = 0
    while (i < argv.length) {
        const a = argv[i]
        if (a === "-f" || a === "--file-types") {
            // 消费后续所有非标志参数（对齐原版 nargs="+"）
            i++
            while (i < argv.length && !argv[i].startsWith("-")) {
                files.push(
                    ...argv[i]
                        .split(",")
                        .map(s => s.trim())
                        .filter(Boolean)
                )
                i++
            }
            continue
        }
        if (a === "--langs") {
            i++
            while (i < argv.length && !argv[i].startsWith("-")) {
                langs.push(
                    ...argv[i]
                        .split(",")
                        .map(s => s.trim())
                        .filter(Boolean)
                )
                i++
            }
            continue
        }
        if (a === "--list") {
            list = true
        } else if (a === "--warmup") {
            warmup = true
        } else if (a.startsWith("-f") && a.length > 2) {
            files.push(
                ...a
                    .slice(2)
                    .split(",")
                    .map(s => s.trim())
                    .filter(Boolean)
            )
        } else if (a.startsWith("--langs=")) {
            langs.push(
                ...a
                    .slice(8)
                    .split(",")
                    .map(s => s.trim())
                    .filter(Boolean)
            )
        }
        i++
    }
    return { files, langs, list, warmup }
}

async function main() {
    const args = parseArgs(process.argv.slice(2))
    const baseDir = join(import.meta.dir, "..")
    const outputRoot = join(baseDir, "final_ts")

    if (args.list) {
        console.log("已注册模块:")
        for (const m of REGISTRY) {
            console.log(`  ${m.name}${m.outputs ? "" : " (纯依赖, 不输出文件)"}${m.deps.length ? ` <- ${m.deps.join(", ")}` : ""}`)
        }
        return
    }

    if (args.warmup) {
        await clearUAssetCache()
        console.log("已清空 UAsset DuckDB 缓存，开始预热资产请求")
    }

    // 只有 -f/--file-types 的值按大小写不敏感匹配；registry 保留规范模块名。
    const moduleNames = new Map(REGISTRY.map(m => [m.name.toLowerCase(), m.name]))
    const requested =
        args.files.length > 0
            ? args.files.map(name => moduleNames.get(name.toLowerCase()) ?? name)
            : args.warmup
              ? UASSET_MODULES
              : REGISTRY.filter(m => m.outputs).map(m => m.name)
    const langs = (args.langs.length > 0 ? args.langs : LANGS) as any[]

    const g = new Graph()
    for (const m of REGISTRY) {
        g.defineModule({ name: m.name, deps: m.deps, outputs: m.outputs, build: m.build })
    }

    console.log(`构建模块: ${requested.join(", ")}`)
    const t0 = performance.now()
    const artifacts = await g.build({}, msg => console.log(msg), requested)

    if (args.warmup) {
        await closeUAssetServer()
        console.log(`\n缓存预热完成: ${(performance.now() - t0).toFixed(0)}ms`)
        return
    }

    // 收集输出（产出文件的模块）：模块返回 { 文件名(可含.json): vnode树 }
    const collector = new OutputCollector()
    const outputModules = REGISTRY.filter(m => m.outputs && requested.includes(m.name))
    for (const m of outputModules) {
        const artifact = artifacts.get(m.name) as Record<string, unknown> | undefined
        if (!artifact) continue
        for (const [fileName, tree] of Object.entries(artifact)) {
            const name = fileName.endsWith(".json") ? fileName : `${fileName}.json`
            collector.add(name, tree as any)
        }
    }

    const textmap = getTextMap()
    const written = collector.writeAll(outputRoot, langs, textmap)
    console.log(`\n完成: ${(performance.now() - t0).toFixed(0)}ms, ${written.length} 个文件`)
    console.log(`输出目录: ${outputRoot}`)
}

await main()
