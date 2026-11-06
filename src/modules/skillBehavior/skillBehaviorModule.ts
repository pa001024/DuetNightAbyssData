/**
 * SkillBehavior — 纯依赖模块：技能行为链（Char / SkillAsset 共用）。
 *
 * 遍历契约与产物语义见 behaviorChain.ts 文件头。此模块只把该文件声明为图中的
 * 依赖节点，避免 Char 与 SkillAsset 通过跨目录 import 形成未声明的依赖。
 */
import type { ModuleContext } from "../../core/Graph.ts"
import type { VNodeTree } from "../../i18n/vnode.ts"
import type { SkillArtifacts } from "../skill/skillModule.ts"
import { generateSkillBehavior, generateSkillBehaviorText, getSkillEntry, normalizeMapOrArray } from "./behaviorChain.ts"

export interface SkillBehaviorArtifacts {
    generateSkillBehavior(
        dm: ModuleContext["dm"],
        skillArtifacts: SkillArtifacts,
        skillId: number,
        inheritedDescValues?: unknown[]
    ): VNodeTree
    /** 行为文本（保留 GT{} 哨兵，不做翻译替换） */
    generateSkillBehaviorText(
        dm: ModuleContext["dm"],
        skillArtifacts: SkillArtifacts,
        skillId: number,
        inheritedDescValues?: unknown[]
    ): string
    getSkillEntry(dm: ModuleContext["dm"], skillId: number): Record<string, any> | null
    normalizeMapOrArray(value: unknown): any[]
}

export function skillBehaviorModule(_ctx: ModuleContext): SkillBehaviorArtifacts {
    return { generateSkillBehavior, generateSkillBehaviorText, getSkillEntry, normalizeMapOrArray }
}
