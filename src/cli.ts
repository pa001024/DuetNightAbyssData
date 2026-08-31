#!/usr/bin/env bun
import { join } from "node:path"
/**
 * CLI — DuetNightAbyssData TS 重构入口。
 *
 * 用法（对齐原版 step3_output.py）：
 *   bun out -f Weapon Char                       # 构建指定模块并输出全部语言
 *   bun out -f Weapon Char --langs cn,en          # 指定语言
 *   bun out --list                                # 列出已注册模块
 *
 * 流程：建图 → 拓扑序执行 build（Lua 混合层取数+计算，产出 vnode 树）→
 *       逐语言渲染 → 写 final_ts/i18n/<lang>/<file>.json
 */
import { Graph } from "./core/Graph.ts"
import { getTextMap, LANGS } from "./i18n/TextMap.ts"
import { abyssBuffModule } from "./modules/abyssBuff/abyssBuffModule.ts"
import { achievementModule } from "./modules/achievement/achievementModule.ts"
import { backpackPuzzleItemModule, backpackPuzzleLevelModule } from "./modules/backpackPuzzle/backpackPuzzleModule.ts"
import { charModule } from "./modules/char/charModule.ts"
import { charAccessoryModule } from "./modules/charAccessory/charAccessoryModule.ts"
import { charDataTargetModule } from "./modules/charDataTarget/charDataTargetModule.ts"
import { charVoiceModule } from "./modules/charVoice/charVoiceModule.ts"
import { cutoffModule } from "./modules/cutoff/cutoffModule.ts"
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
import { petEntryModule } from "./modules/pet/petEntryModule.ts"
import { petModule } from "./modules/pet/petModule.ts"
import { questChainModule } from "./modules/questChain/questChainModule.ts"
import { raidBuffModule } from "./modules/raidBuff/raidBuffModule.ts"
import { regionPointModule } from "./modules/regionPoint/regionPointModule.ts"
import { regionReputationModule } from "./modules/regionReputation/regionReputationModule.ts"
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
    { name: "skill", deps: [], outputs: false, build: ctx => skillModule(ctx) },
    { name: "abyssbuff", deps: [], outputs: true, build: ctx => ({ AbyssBuff: abyssBuffModule(ctx) }) },
    { name: "achievement", deps: [], outputs: true, build: ctx => ({ Achievement: achievementModule(ctx) }) },
    { name: "weapon", deps: ["skill"], outputs: true, build: ctx => weaponModule(ctx) },
    { name: "char", deps: ["skill"], outputs: true, build: ctx => charModule(ctx) },
    { name: "cutoff", deps: [], outputs: true, build: ctx => ({ Cutoff: cutoffModule(ctx) }) },
    { name: "charvoice", deps: [], outputs: true, build: ctx => ({ CharVoice: charVoiceModule(ctx) }) },
    { name: "characcessory", deps: [], outputs: true, build: ctx => ({ CharAccessory: charAccessoryModule(ctx) }) },
    { name: "draft", deps: [], outputs: true, build: ctx => ({ Draft: draftModule(ctx) }) },
    { name: "extraexcelweapon", deps: [], outputs: true, build: ctx => ({ ExtraExcelWeapon: extraExcelWeaponModule(ctx) }) },
    { name: "ironticket", deps: [], outputs: true, build: ctx => ({ IronTicket: ironTicketModule(ctx) }) },
    { name: "walnut", deps: [], outputs: true, build: ctx => ({ Walnut: walnutModule(ctx) }) },
    { name: "reward", deps: [], outputs: true, build: ctx => ({ Reward: rewardModule(ctx) }) },
    { name: "optreward", deps: [], outputs: true, build: ctx => ({ OptReward: optRewardModule(ctx) }) },
    { name: "rewardview", deps: [], outputs: true, build: ctx => ({ RewardView: rewardViewModule(ctx) }) },
    { name: "skin", deps: [], outputs: true, build: ctx => ({ Skin: skinModule(ctx) }) },
    { name: "questchain", deps: [], outputs: true, build: ctx => ({ QuestChain: questChainModule(ctx) }) },
    { name: "weaponaccessory", deps: [], outputs: true, build: ctx => ({ WeaponAccessory: weaponAccessoryModule(ctx) }) },
    { name: "weaponskin", deps: [], outputs: true, build: ctx => ({ WeaponSkin: weaponSkinModule(ctx) }) },
    { name: "hair", deps: [], outputs: true, build: ctx => ({ Hair: hairModule(ctx) }) },
    { name: "headframe", deps: [], outputs: true, build: ctx => ({ HeadFrame: headFrameModule(ctx) }) },
    { name: "headsculpture", deps: [], outputs: true, build: ctx => ({ HeadSculpture: headSculptureModule(ctx) }) },
    { name: "mount", deps: [], outputs: true, build: ctx => ({ Mount: mountModule(ctx) }) },
    { name: "mod", deps: ["skill"], outputs: true, build: ctx => ({ Mod: modModule(ctx) }) },
    { name: "monster", deps: [], outputs: true, build: ctx => ({ Monster: monsterModule(ctx) }) },
    { name: "monsterstrongaffixes", deps: [], outputs: true, build: ctx => ({ MonsterStrongAffixes: monsterStrongAffixesModule(ctx) }) },
    { name: "fish", deps: [], outputs: true, build: ctx => ({ Fish: fishModule(ctx) }) },
    { name: "fishingspot", deps: [], outputs: true, build: ctx => ({ FishingSpot: fishingSpotModule(ctx) }) },
    { name: "music", deps: [], outputs: true, build: ctx => ({ Music: musicModule(ctx) }) },
    { name: "musicscore", deps: [], outputs: true, build: ctx => ({ MusicScore: musicScoreModule(ctx) }) },
    { name: "backpackpuzzleitem", deps: [], outputs: true, build: ctx => ({ BackpackPuzzleItem: backpackPuzzleItemModule(ctx) }) },
    { name: "backpackpuzzlelevel", deps: [], outputs: true, build: ctx => ({ BackpackPuzzleLevel: backpackPuzzleLevelModule(ctx) }) },
    { name: "forgelevelquest", deps: [], outputs: true, build: ctx => ({ ForgeLevelQuest: forgeLevelQuestModule(ctx) }) },
    { name: "regionpoint", deps: [], outputs: true, build: ctx => ({ RegionPoint: regionPointModule(ctx) }) },
    { name: "regionreputation", deps: [], outputs: true, build: ctx => ({ RegionReputation: regionReputationModule(ctx) }) },
    { name: "rougeliketalentbranch", deps: [], outputs: true, build: ctx => ({ RougeLikeTalentBranch: rougeLikeTalentBranchModule(ctx) }) },
    {
        name: "rougelikeblessinggroup",
        deps: [],
        outputs: true,
        build: ctx => ({ RougeLikeBlessingGroup: rougeLikeBlessingGroupModule(ctx) }),
    },
    {
        name: "rougeliketreasuregroup",
        deps: [],
        outputs: true,
        build: ctx => ({ RougeLikeTreasureGroup: rougeLikeTreasureGroupModule(ctx) }),
    },
    { name: "rougelikeblessing", deps: ["mod"], outputs: true, build: ctx => ({ RougeLikeBlessing: rougeLikeBlessingModule(ctx) }) },
    { name: "rougelikecontract", deps: [], outputs: true, build: ctx => ({ RougeLikeContract: rougeLikeContractModule(ctx) }) },
    { name: "rougeliketalent", deps: ["mod"], outputs: true, build: ctx => ({ RougeLikeTalent: rougeLikeTalentModule(ctx) }) },
    { name: "rougeliketreasure", deps: ["mod"], outputs: true, build: ctx => ({ RougeLikeTreasure: rougeLikeTreasureModule(ctx) }) },
    { name: "rougeproclass", deps: [], outputs: true, build: ctx => ({ RougeProClass: rougeProClassModule(ctx) }) },
    { name: "hardboss", deps: [], outputs: true, build: ctx => ({ HardBoss: hardBossModule(ctx) }) },
    { name: "chardatatarget", deps: [], outputs: true, build: ctx => ({ CharDataTarget: charDataTargetModule(ctx) }) },
    { name: "treasurehuntprogress", deps: [], outputs: true, build: ctx => ({ TreasureHuntProgress: treasureHuntProgressModule(ctx) }) },
    {
        name: "treasurehuntrepeatdungeon",
        deps: [],
        outputs: true,
        build: ctx => ({ TreasureHuntRepeatDungeon: treasureHuntRepeatDungeonModule(ctx) }),
    },
    {
        name: "treasurehuntstorydungeon",
        deps: [],
        outputs: true,
        build: ctx => ({ TreasureHuntStoryDungeon: treasureHuntStoryDungeonModule(ctx) }),
    },
    { name: "solotreasure", deps: [], outputs: true, build: ctx => ({ SoloTreasure: soloTreasureModule(ctx) }) },
    { name: "solotreasuregameplay", deps: [], outputs: true, build: ctx => ({ SoloTreasureGamePlay: soloTreasureGamePlayModule(ctx) }) },
    { name: "petentry", deps: [], outputs: true, build: ctx => ({ PetEntry: petEntryModule(ctx) }) },
    { name: "pet", deps: ["skill"], outputs: true, build: ctx => ({ Pet: petModule(ctx) }) },
    { name: "shopitem", deps: [], outputs: true, build: ctx => ({ ShopItem: shopItemModule(ctx) }) },
    { name: "title", deps: [], outputs: true, build: ctx => ({ Title: titleModule(ctx) }) },
    { name: "event", deps: [], outputs: true, build: ctx => ({ Event: eventModule(ctx) }) },
    { name: "extractiontreasure", deps: [], outputs: true, build: ctx => ({ ExtractionTreasure: extractionTreasureModule(ctx) }) },
    { name: "extractiontreasurebag", deps: [], outputs: true, build: ctx => ({ ExtractionTreasureBag: extractionTreasureBagModule(ctx) }) },
    {
        name: "extractiontreasuremechanism",
        deps: [],
        outputs: true,
        build: ctx => ({ ExtractionTreasureMechanism: extractionTreasureMechanismModule(ctx) }),
    },
    { name: "impressionshop", deps: [], outputs: true, build: ctx => ({ ImpressionShop: impressionShopModule(ctx) }) },
    { name: "robotequip", deps: [], outputs: true, build: ctx => ({ RobotEquip: robotEquipModule(ctx) }) },
    { name: "raidbuff", deps: [], outputs: true, build: ctx => ({ RaidBuff: raidBuffModule(ctx) }) },
]

interface CliArgs {
    files: string[]
    langs: string[]
    list: boolean
}

/** 解析 argv：支持 -f/--file-types 的值列表（对齐原版 nargs="+"，-f 后所有非标志参数）、--langs、--list */
function parseArgs(argv: string[]): CliArgs {
    const files: string[] = []
    const langs: string[] = []
    let list = false
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
    return { files, langs, list }
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

    // 模块名 → 小写；缺省输出全部产出模块
    const requested = args.files.length > 0 ? args.files.map(n => n.toLowerCase()) : REGISTRY.filter(m => m.outputs).map(m => m.name)
    const langs = (args.langs.length > 0 ? args.langs : LANGS) as any[]

    const g = new Graph()
    for (const m of REGISTRY) {
        g.defineModule({ name: m.name, deps: m.deps, outputs: m.outputs, build: m.build })
    }

    console.log(`构建模块: ${requested.join(", ")}`)
    const t0 = performance.now()
    const artifacts = await g.build({}, msg => console.log(msg), requested)

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
