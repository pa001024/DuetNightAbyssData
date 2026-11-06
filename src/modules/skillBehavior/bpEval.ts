/**
 * bpEval — Blueprint 字节码的有界静态求值（供 skillAsset 展平 `skills[].blueprintActions`）。
 *
 * 只做「可证明」的求值：
 * - 语句级控制流来自 UAssetCLI 的 `blocks[].successors`；函数内局部变量做前向数据流分析，
 *   合并点上的不同定义折叠为 `unknown`，不取其中一个分支的值。
 * - 表达式只解析字面量、字面量数组、`EX_SetArray` 局部赋值、局部变量读取与透传转换；
 *   函数参数、实例变量、运行期对象、调用结果一律 `unknown`，并记录原因。
 * - `EX_ComputedJump`（Ubergraph 事件分发）没有静态后继，因此没有静态前驱的基本块以空状态
 *   作为入口；块内局部赋值因此仍可解析，跨事件块读取的局部变量则保持 `unknown`。
 *
 * 本模块不解释游戏语义以外的调用：未列入 `CALL_SEMANTICS` 的函数不产生动作。
 * 无法求值的动作参数逐条进入 `unresolved`（不静默丢弃）。
 */
import type { UAssetBytecodeDocument, UAssetBytecodeExpression, UAssetBytecodeFunction } from "../../lua/UAssetServer.ts"

export interface BpActionSource {
    /** FModel 包路径（等同 skill.sources.bpPackages 的条目） */
    bpPackage: string
    /** 所在的 Blueprint 函数名（事件函数或自定义函数） */
    function: string
    /** 可追溯的节点 id：`${function}#${offset}` */
    nodeId: string
    op: string
    offset: number | null
}

/** `ExecuteSkillEffects` 的数组参数求值结果（SkillEffects id）。 */
export interface BpExecuteEffectsAction {
    kind: "executeEffects"
    effectIds: number[]
    source: BpActionSource
}

/**
 * `AddBuffToTarget`：`args[2]` 是 BuffId 字面量。
 * `duration` 取 `args[3]`（-1 表示永久，按原文保留）；`count` 取 `args[6]`。无法静态求值为 null。
 */
export interface BpApplyBuffAction {
    kind: "applyBuff"
    buffId: number
    duration: number | null
    count: number | null
    source: BpActionSource
}

export interface BpRemoveBuffAction {
    kind: "removeBuff"
    buffId: number
    source: BpActionSource
}

export interface BpReduceBuffLayerAction {
    kind: "reduceBuffLayer"
    buffId: number
    layers: number | null
    source: BpActionSource
}

/**
 * `CreateCreature` / `CreateDoubleCreature` / `CreateSkillCreature` 调用。
 * 这些 BP 函数本身不带 creature 参数：creature id 由被调函数执行的 SkillEffects 行
 * （`TaskEffects[].CreateSkillCreature.CreatureId`）解析；无法解析时为 null 并记录 unresolved。
 */
export interface BpCreateCreatureAction {
    kind: "createCreature"
    /** 被调函数名 */
    function: string
    /** 被调函数在本 BP 内执行的效果（跨本地零参函数展开，深度上限见 MAX_INLINE_DEPTH） */
    effectIds: number[] | null
    creatureIds: number[] | null
    source: BpActionSource
}

/**
 * `GenDamageWithType` 构造的伤害；`ApplyDamage` 接收同一局部变量时 `applied` 为 true。
 * 参数形状（真实数据核对）：`args[2]` 伤害类型名、`args[3]` 倍率、`args[5]` 伤害标签名数组
 * （如 `["Dot"]`），不含 SkillEffects id。
 */
export interface BpDamageAction {
    kind: "damage"
    damageType: string | null
    rate: number | null
    damageTags: string[] | null
    applied: boolean | null
    source: BpActionSource
}

export type BlueprintAction =
    | BpExecuteEffectsAction
    | BpApplyBuffAction
    | BpRemoveBuffAction
    | BpReduceBuffLayerAction
    | BpCreateCreatureAction
    | BpDamageAction

/** 无法静态求值的动作参数，逐条记录（不猜值）。 */
export interface UnresolvedBpRef {
    bpPackage: string
    function: string
    nodeId: string
    /** 调用函数名 */
    call: string
    reason: string
    detail?: string
}

export interface BlueprintFlattenResult {
    actions: BlueprintAction[]
    unresolved: UnresolvedBpRef[]
}

export interface BlueprintFlattenOptions {
    /**
     * SkillEffects id → 该效果任务里 `CreateSkillCreature.CreatureId` 列表。
     * 效果行缺失返回 null（进入 unresolved）；空数组表示行存在但没有创建实体的任务。
     */
    effectCreatures?: (effectId: number) => number[] | null
}

/** 本地零参函数展开的深度上限（CreateCreature → ExecuteSkillEffects 为一层）。 */
const MAX_INLINE_DEPTH = 4
/** 数据流迭代上限（基本块数 + 该值）；只作为收敛保护，正常数据远小于上限。 */
const DATAFLOW_EXTRA_PASSES = 8

const NUMBER_OPS = new Set([
    "EX_IntConst",
    "EX_IntConstByte",
    "EX_ByteConst",
    "EX_Int64Const",
    "EX_UInt64Const",
    "EX_NothingInt32",
    "EX_FloatConst",
    "EX_DoubleConst",
])
const STRING_OPS = new Set(["EX_NameConst", "EX_StringConst", "EX_UnicodeStringConst"])
const CALL_OPS = new Set(["EX_FinalFunction", "EX_LocalFinalFunction", "EX_LocalVirtualFunction", "EX_VirtualFunction"])
/** 透传目标表达式的转换：求值结果不变。 */
const TRANSPARENT_OPS = new Set([
    "EX_ObjToInterfaceCast",
    "EX_InterfaceToObjCast",
    "EX_ObjectToInterfaceCast",
    "EX_CastBase",
    "EX_PrimitiveCast",
])
const LET_OPS = new Set([
    "EX_Let",
    "EX_LetBool",
    "EX_LetObj",
    "EX_LetWeakObjPtr",
    "EX_LetDelegate",
    "EX_LetMulticastDelegate",
    "EX_LetBase",
])

type Value =
    | { kind: "number"; value: number }
    | { kind: "string"; value: string }
    | { kind: "bool"; value: boolean }
    | { kind: "array"; items: Value[] }
    /** 调用结果（只保留函数名与偏移，用于跨语句连接，例如 ApplyDamage 接收 GenDamageWithType 结果）。 */
    | { kind: "call"; function: string; offset: number | null }
    | { kind: "unknown"; reason: string; detail?: string }

type State = Map<string, Value>

function unknown(reason: string, detail?: string): Value {
    return { kind: "unknown", reason, detail }
}

function numberValue(value: number): Value {
    return { kind: "number", value }
}

function valueKey(value: Value): string {
    return JSON.stringify(value)
}

function sameValue(a: Value, b: Value): boolean {
    return valueKey(a) === valueKey(b)
}

function propertyPath(expr: unknown): string[] | null {
    const path = (expr as Record<string, unknown> | null)?.path
    return Array.isArray(path) ? path.map(item => String(item)) : null
}

/** `EX_LocalVariable` / 赋值目标指针的局部变量名（只接受单段路径）。 */
function localName(expr: unknown): string | null {
    const record = expr as Record<string, unknown> | null
    if (record?.op !== "EX_LocalVariable") return null
    const path = propertyPath(record.property)
    return path && path.length === 1 ? path[0]! : null
}

function literalOperand(value: Value): number | null {
    return value.kind === "number" && Number.isFinite(value.value) ? value.value : null
}

function evaluateArithmetic(fn: string, args: Value[]): Value | null {
    const numbers = args.map(literalOperand)
    if (numbers.some(item => item === null)) return null
    const values = numbers as number[]
    if (values.length !== 2) {
        if (values.length !== 1) return null
        if (fn === "FTrunc") return numberValue(Math.trunc(values[0]!))
        if (fn === "Abs_Int") return numberValue(Math.abs(values[0]!))
        return null
    }
    const [a, b] = values
    switch (fn) {
        case "Add_IntInt":
        case "Add_FloatFloat":
            return numberValue(a! + b!)
        case "Subtract_IntInt":
        case "Subtract_FloatFloat":
            return numberValue(a! - b!)
        case "Multiply_IntInt":
        case "Multiply_FloatFloat":
        case "Multiply_IntFloat":
            return numberValue(a! * b!)
        case "Divide_FloatFloat":
            return b === 0 ? null : numberValue(a! / b!)
        case "Divide_IntInt":
            return b === 0 ? null : numberValue(Math.trunc(a! / b!))
        case "FMin":
            return numberValue(Math.min(a!, b!))
        case "FMax":
            return numberValue(Math.max(a!, b!))
        default:
            return null
    }
}

function evaluate(expr: unknown, state: State, params: ReadonlySet<string>): Value {
    if (!expr || typeof expr !== "object") return unknown("missing-expression")
    const node = expr as UAssetBytecodeExpression
    const op = String(node.op ?? "")
    if (op === "EX_IntZero") return numberValue(0)
    if (op === "EX_IntOne") return numberValue(1)
    if (op === "EX_True") return { kind: "bool", value: true }
    if (op === "EX_False") return { kind: "bool", value: false }
    if (NUMBER_OPS.has(op)) {
        return typeof node.value === "number" ? numberValue(node.value) : unknown("non-numeric-constant", op)
    }
    if (STRING_OPS.has(op)) {
        return typeof node.value === "string" ? { kind: "string", value: node.value } : unknown("non-string-constant", op)
    }
    if (op === "EX_LocalVariable") {
        const name = localName(node)
        if (!name) return unknown("local-path", JSON.stringify(propertyPath((node as Record<string, unknown>).property)))
        if (params.has(name)) return unknown("function-parameter", name)
        const value = state.get(name)
        return value ?? unknown("uninitialized-local", name)
    }
    if (op === "EX_LocalOutVariable")
        return unknown("out-parameter", JSON.stringify(propertyPath((node as Record<string, unknown>).property)))
    if (op === "EX_InstanceVariable")
        return unknown("instance-variable", JSON.stringify(propertyPath((node as Record<string, unknown>).property)))
    if (op === "EX_SetArray" || op === "EX_MakeArray" || op === "EX_ArrayConst") {
        const elements = Array.isArray(node.elements) ? node.elements : []
        return { kind: "array", items: elements.map(item => evaluate(item, state, params)) }
    }
    if (op === "EX_ArrayGetByRef" || op === "EX_ArrayGetByIndex") {
        const array = evaluate((node as Record<string, unknown>).array, state, params)
        const index = evaluate((node as Record<string, unknown>).index, state, params)
        if (array.kind !== "array") return unknown("array-value", array.kind === "unknown" ? array.reason : array.kind)
        if (index.kind !== "number" || !Number.isInteger(index.value) || index.value < 0 || index.value >= array.items.length)
            return unknown("array-index-unresolved")
        return array.items[index.value]!
    }
    if (op === "EX_Context") return evaluate((node as Record<string, unknown>).context, state, params)
    if (TRANSPARENT_OPS.has(op)) return evaluate((node as Record<string, unknown>).target, state, params)
    if (CALL_OPS.has(op) || op === "EX_CallMath") {
        const name = String(node.function ?? "")
        const args = Array.isArray(node.args) ? node.args : []
        if (op === "EX_CallMath") {
            const computed = evaluateArithmetic(
                name,
                args.map(item => evaluate(item, state, params))
            )
            if (computed) return computed
        }
        return { kind: "call", function: name, offset: typeof node.offset === "number" ? node.offset : null }
    }
    if (op === "EX_Self" || op === "EX_ObjectConst" || op === "EX_NoObject" || op === "EX_NoInterface" || op === "EX_Nothing")
        return unknown("runtime-object", op)
    return unknown("unsupported-expression", op)
}

interface BlockInfo {
    index: number
    statements: number[]
    successors: number[]
}

function buildBlocks(fn: UAssetBytecodeFunction): { blocks: BlockInfo[]; cfgMissing: boolean } {
    const raw = Array.isArray(fn.blocks) ? fn.blocks : []
    if (raw.length === 0) {
        const bodyLength = Array.isArray(fn.body) ? fn.body.length : 0
        return {
            blocks: [
                {
                    index: 0,
                    statements: Array.from({ length: bodyLength }, (_, index) => index),
                    successors: [],
                },
            ],
            cfgMissing: true,
        }
    }
    return {
        blocks: raw.map(block => ({
            index: Number(block.index),
            statements: Array.isArray(block.statements) ? block.statements.map(Number) : [],
            successors: (Array.isArray(block.successors) ? block.successors : [])
                .map(successor => (typeof successor.block === "number" ? successor.block : null))
                .filter((index): index is number => index !== null),
        })),
        cfgMissing: false,
    }
}

function mergeStates(a: State, b: State): State {
    const merged: State = new Map()
    for (const key of new Set([...a.keys(), ...b.keys()])) {
        const left = a.get(key)
        const right = b.get(key)
        if (left && right) {
            if (sameValue(left, right)) merged.set(key, left)
            else merged.set(key, unknown("ambiguous-definitions", key))
            continue
        }
        merged.set(key, unknown("maybe-unassigned", key))
    }
    return merged
}

function stateKey(state: State): string {
    return JSON.stringify([...state.entries()].sort(([a], [b]) => (a < b ? -1 : a > b ? 1 : 0)))
}

/** 应用一条语句的赋值（不产生动作）；返回新状态。 */
function applyAssignment(stmt: unknown, state: State, params: ReadonlySet<string>): State {
    const node = stmt as UAssetBytecodeExpression
    const op = String(node?.op ?? "")
    if (LET_OPS.has(op)) {
        const target = localName((node as Record<string, unknown>).variable)
        if (!target) return state
        const next = new Map(state)
        next.set(target, evaluate((node as Record<string, unknown>).value, state, params))
        return next
    }
    if (op === "EX_SetArray") {
        const target = localName((node as Record<string, unknown>).property)
        if (!target) return state
        const next = new Map(state)
        next.set(target, evaluate(node, state, params))
        return next
    }
    return state
}

function intValue(value: Value): number | null {
    return value.kind === "number" && Number.isInteger(value.value) ? value.value : null
}

function intArray(value: Value): number[] | null {
    if (value.kind !== "array") return null
    const out: number[] = []
    for (const item of value.items) {
        const id = intValue(item)
        if (id === null) return null
        if (!out.includes(id)) out.push(id)
    }
    return out
}

function stringArray(value: Value): string[] | null {
    if (value.kind !== "array") return null
    const out: string[] = []
    for (const item of value.items) {
        if (item.kind !== "string") return null
        if (!out.includes(item.value)) out.push(item.value)
    }
    return out
}

function unknownReason(value: Value): string {
    if (value.kind === "unknown") return value.reason
    return `non-literal-${value.kind}`
}

function nodeIdFor(fn: string, node: UAssetBytecodeExpression): string {
    return `${fn}#${String(node.offset ?? "?")}`
}

function sourceFor(bpPackage: string, fn: string, node: UAssetBytecodeExpression): BpActionSource {
    return {
        bpPackage,
        function: fn,
        nodeId: nodeIdFor(fn, node),
        op: String(node.op ?? ""),
        offset: typeof node.offset === "number" ? node.offset : null,
    }
}

/** 单函数求值结果：动作与未解析项，按语句顺序稳定输出。 */
interface FunctionResult {
    actions: BlueprintAction[]
    unresolved: UnresolvedBpRef[]
}

function analyzeFunction(bpPackage: string, fn: UAssetBytecodeFunction): FunctionResult {
    const actions: BlueprintAction[] = []
    const unresolved: UnresolvedBpRef[] = []
    /** ApplyDamage 接收的 GenDamageWithType 调用偏移：用于标记 damage 动作确实被施加。 */
    const appliedDamageOffsets = new Set<number>()
    const body = Array.isArray(fn.body) ? fn.body : []
    const params = new Set((fn.params ?? []).map(param => String(param.name)))
    const { blocks, cfgMissing } = buildBlocks(fn)

    if (cfgMissing) {
        unresolved.push({
            bpPackage,
            function: fn.name,
            nodeId: `${fn.name}#?`,
            call: "",
            reason: "cfg-missing",
            detail: "blocks 缺失，按语句线性顺序求值",
        })
    }

    const inStates: Array<State | null> = blocks.map(() => null)
    if (blocks.length > 0) inStates[blocks[0]!.index] = new Map()
    const hasPredecessor = new Set<number>()
    for (const block of blocks) for (const successor of block.successors) hasPredecessor.add(successor)
    for (const block of blocks) {
        if (block.index !== blocks[0]!.index && !hasPredecessor.has(block.index)) inStates[block.index] = new Map()
    }

    const runBlock = (block: BlockInfo, entry: State): State => {
        let state = entry
        for (const index of block.statements) state = applyAssignment(body[index], state, params)
        return state
    }

    const maxPasses = blocks.length + DATAFLOW_EXTRA_PASSES
    for (let pass = 0; pass < maxPasses; pass++) {
        let changed = false
        for (const block of blocks) {
            const entry = inStates[block.index]
            if (!entry) continue
            const exit = runBlock(block, entry)
            for (const successor of block.successors) {
                const previous = inStates[successor]
                const merged = previous ? mergeStates(previous, exit) : exit
                if (!previous || stateKey(previous) !== stateKey(merged)) {
                    inStates[successor] = merged
                    changed = true
                }
            }
        }
        if (!changed) break
    }

    const record = (call: UAssetBytecodeExpression, state: State): void => {
        const name = String(call.function ?? "")
        const args = Array.isArray(call.args) ? call.args : []
        const source = sourceFor(bpPackage, fn.name, call)
        const arg = (index: number): Value => evaluate(args[index], state, params)
        const note = (reason: string, detail?: string): void => {
            unresolved.push({ bpPackage, function: fn.name, nodeId: source.nodeId, call: name, reason, detail })
        }
        switch (name) {
            case "ExecuteSkillEffects": {
                const effectIds = intArray(arg(1))
                if (!effectIds) {
                    note("effect-array-unresolved", unknownReason(arg(1)))
                    return
                }
                actions.push({ kind: "executeEffects", effectIds, source })
                return
            }
            case "AddBuffToTarget": {
                const buffId = intValue(arg(2))
                if (buffId === null) {
                    note("buff-id-unresolved", unknownReason(arg(2)))
                    return
                }
                const duration = literalOperand(arg(3))
                if (args.length > 3 && duration === null) note("buff-duration-unresolved", unknownReason(arg(3)))
                const count = intValue(arg(6))
                if (args.length > 6 && count === null) note("buff-count-unresolved", unknownReason(arg(6)))
                actions.push({ kind: "applyBuff", buffId, duration, count, source })
                return
            }
            case "RemoveBuffFromTarget":
            case "RemoveBuff": {
                const buffId = intValue(arg(2))
                if (buffId === null) {
                    note("buff-id-unresolved", unknownReason(arg(2)))
                    return
                }
                actions.push({ kind: "removeBuff", buffId, source })
                return
            }
            case "ReduceBuffLayerFromTarget": {
                const buffId = intValue(arg(2))
                if (buffId === null) {
                    note("buff-id-unresolved", unknownReason(arg(2)))
                    return
                }
                actions.push({ kind: "reduceBuffLayer", buffId, layers: intValue(arg(3)), source })
                return
            }
            case "GenDamageWithType": {
                const typeValue = arg(2)
                const damageType = typeValue.kind === "string" ? typeValue.value : null
                if (damageType === null) note("damage-type-unresolved", unknownReason(typeValue))
                const rate = literalOperand(arg(3))
                if (rate === null) note("damage-rate-unresolved", unknownReason(arg(3)))
                const damageTags = stringArray(arg(5))
                if (!damageTags) note("damage-tags-unresolved", unknownReason(arg(5)))
                actions.push({ kind: "damage", damageType, rate, damageTags, applied: null, source })
                return
            }
            case "ApplyDamage": {
                const target = arg(0)
                if (target.kind !== "call" || target.function !== "GenDamageWithType") {
                    note("apply-damage-source-unresolved", target.kind === "unknown" ? target.reason : "non-call-argument")
                    return
                }
                if (target.offset !== null) appliedDamageOffsets.add(target.offset)
                return
            }
            case "CreateCreature":
            case "CreateDoubleCreature":
            case "CreateSkillCreature": {
                actions.push({ kind: "createCreature", function: name, effectIds: null, creatureIds: null, source })
                return
            }
            default:
                return
        }
    }

    const walk = (expr: unknown, state: State): void => {
        if (!expr || typeof expr !== "object") return
        if (Array.isArray(expr)) {
            for (const item of expr) walk(item, state)
            return
        }
        const node = expr as UAssetBytecodeExpression
        if (typeof node.function === "string") record(node, state)
        for (const [key, value] of Object.entries(node)) {
            if (key === "op" || key === "function") continue
            if (value && typeof value === "object") walk(value, state)
        }
    }

    for (const block of blocks) {
        let state = inStates[block.index]
        if (!state) continue
        for (const index of block.statements) {
            const stmt = body[index]
            walk(stmt, state)
            state = applyAssignment(stmt, state, params)
        }
    }

    for (const action of actions) {
        if (action.kind !== "damage" || action.source.offset === null) continue
        if (appliedDamageOffsets.has(action.source.offset)) action.applied = true
    }

    return { actions, unresolved }
}

/**
 * 展平一个 Blueprint 包的可证明调用。
 * 输出的 `actions` 已按语句顺序稳定排列；`unresolved` 记录每个无法静态求值的动作参数。
 */
export function flattenBlueprintActions(
    bpPackage: string,
    doc: UAssetBytecodeDocument,
    options: BlueprintFlattenOptions = {}
): BlueprintFlattenResult {
    const actions: BlueprintAction[] = []
    const unresolved: UnresolvedBpRef[] = []
    const byFunction = new Map<string, FunctionResult>()

    for (const fn of doc.functions ?? []) {
        if (fn.error || !Array.isArray(fn.body)) {
            unresolved.push({
                bpPackage,
                function: fn.name,
                nodeId: `${fn.name}#?`,
                call: "",
                reason: "function-parse-error",
                detail: fn.error ?? "body missing",
            })
            continue
        }
        const result = analyzeFunction(bpPackage, fn)
        byFunction.set(fn.name, result)
        actions.push(...result.actions)
        unresolved.push(...result.unresolved)
    }

    resolveCreatureActions(bpPackage, actions, unresolved, byFunction, options)

    return { actions, unresolved }
}

/** 递归收集本地函数直接执行的效果（零参函数调用才会被展开）。 */
function collectLocalEffects(
    functionName: string,
    byFunction: Map<string, FunctionResult>,
    seen: Set<string>,
    depth: number
): number[] | null {
    if (depth > MAX_INLINE_DEPTH || seen.has(functionName)) return null
    const target = byFunction.get(functionName)
    if (!target) return null
    seen.add(functionName)
    const out: number[] = []
    for (const action of target.actions) {
        if (action.kind === "executeEffects") {
            for (const effectId of action.effectIds) if (!out.includes(effectId)) out.push(effectId)
            continue
        }
        if (action.kind === "createCreature") {
            const nested = collectLocalEffects(action.function, byFunction, seen, depth + 1)
            if (nested) for (const effectId of nested) if (!out.includes(effectId)) out.push(effectId)
        }
    }
    seen.delete(functionName)
    return out
}

function resolveCreatureActions(
    bpPackage: string,
    actions: BlueprintAction[],
    unresolved: UnresolvedBpRef[],
    byFunction: Map<string, FunctionResult>,
    options: BlueprintFlattenOptions
): void {
    for (const action of actions) {
        if (action.kind !== "createCreature") continue
        const effects = collectLocalEffects(action.function, byFunction, new Set(), 0)
        if (!effects) {
            unresolved.push({
                bpPackage,
                function: action.source.function,
                nodeId: action.source.nodeId,
                call: action.function,
                reason: "local-function-unresolved",
                detail: "被调函数不在本资产内或展开深度超限",
            })
            continue
        }
        action.effectIds = effects
        if (!options.effectCreatures) {
            unresolved.push({
                bpPackage,
                function: action.source.function,
                nodeId: action.source.nodeId,
                call: action.function,
                reason: "creature-lookup-unavailable",
            })
            continue
        }
        const creatureIds: number[] = []
        let missing: number | null = null
        for (const effectId of effects) {
            const ids = options.effectCreatures(effectId)
            if (ids === null) {
                missing = effectId
                break
            }
            for (const id of ids) if (!creatureIds.includes(id)) creatureIds.push(id)
        }
        if (missing !== null) {
            unresolved.push({
                bpPackage,
                function: action.source.function,
                nodeId: action.source.nodeId,
                call: action.function,
                reason: "creature-effect-row-missing",
                detail: String(missing),
            })
            continue
        }
        action.creatureIds = creatureIds
    }
}
