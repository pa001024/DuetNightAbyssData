/**
 * Graph — 模块依赖图。
 *
 * defineModule({name, deps, build}) 注册模块；build 阶段按依赖拓扑序执行。
 * 每个模块通过 ctx.getArtifact(name) 读取依赖模块产物。
 *
 * - 依赖决定生成顺序（拓扑排序，DFS + 后序）
 * - 环检测：出现环直接报错
 * - artifacts：模块 build 的返回对象，可被依赖者读取
 * - 一个模块 build 一次（幂等），多语言渲染在其产物上派生
 */
import { getTextMap, type TextMap } from "../i18n/TextMap.ts"
import { getLuaDataManager, type LuaDataManager } from "../lua/LuaDataManager.ts"

export interface ModuleContext {
    /** 依赖图实例 */
    graph: Graph
    /** 数据与计算（Lua 混合层） */
    dm: LuaDataManager
    /** 翻译索引 */
    textmap: TextMap
    /** 读取依赖模块产物 */
    getArtifact<T>(name: string): T | undefined
    /** 模块参数（CLI 透传） */
    args: Record<string, unknown>
    /** 记录日志 */
    log(msg: string): void
}

export interface ModuleDefinition {
    name: string
    deps?: string[]
    /** 是否输出文件（false = 纯依赖模块，不产出文件，仅暴露 artifacts） */
    outputs?: boolean
    build(ctx: ModuleContext): unknown
}

interface ModuleInstance {
    def: ModuleDefinition
    artifact: unknown
    built: boolean
    building: boolean
}

export class Graph {
    private modules = new Map<string, ModuleInstance>()
    private order: string[] = []
    private buildSeq = 0

    defineModule(def: ModuleDefinition): this {
        if (this.modules.has(def.name)) throw new Error(`模块重复定义: ${def.name}`)
        this.modules.set(def.name, { def, artifact: undefined, built: false, building: false })
        return this
    }

    /** 解析依赖顺序（拓扑排序，DFS 后序；环检测） */
    private resolveOrder(): void {
        if (this.order.length > 0) return
        const visiting = new Set<string>()
        const visited = new Set<string>()
        const stack: string[] = []

        const visit = (name: string, trail: string[]): void => {
            if (visited.has(name)) return
            if (visiting.has(name)) {
                const cycleStart = trail.indexOf(name)
                const cycle = [...trail.slice(cycleStart), name].join(" → ")
                throw new Error(`模块依赖环: ${cycle}`)
            }
            const inst = this.modules.get(name)
            if (!inst) throw new Error(`依赖模块不存在: ${name}（被 ${trail.join(" → ")} 引用）`)
            visiting.add(name)
            for (const dep of inst.def.deps ?? []) visit(dep, [...trail, name])
            visiting.delete(name)
            visited.add(name)
            stack.push(name)
        }

        for (const name of this.modules.keys()) visit(name, [])
        this.order = stack
    }

    /** 构建全部（按拓扑序）；返回 { name → artifact } */
    async build(args: Record<string, unknown> = {}, onLog?: (msg: string) => void): Promise<Map<string, unknown>> {
        this.resolveOrder()
        const dm = getLuaDataManager()
        const textmap = getTextMap()
        const ctx: ModuleContext = {
            graph: this,
            dm,
            textmap,
            getArtifact: name => this.getArtifact(name),
            args,
            log: msg => (onLog ? onLog(msg) : console.log(msg)),
        }
        for (const name of this.order) {
            await this.buildOne(name, ctx)
        }
        const result = new Map<string, unknown>()
        for (const name of this.order) result.set(name, this.modules.get(name)!.artifact)
        return result
    }

    private async buildOne(name: string, ctx: ModuleContext): Promise<void> {
        const inst = this.modules.get(name)!
        if (inst.built) return
        if (inst.building) throw new Error(`构建环: ${name}`)
        inst.building = true
        for (const dep of inst.def.deps ?? []) await this.buildOne(dep, ctx)
        ctx.log(`[build] ${name}`)
        inst.artifact = await inst.def.build(ctx)
        inst.built = true
        inst.building = false
        this.buildSeq++
    }

    /** 读取已构建模块产物（未构建返回 undefined） */
    getArtifact<T>(name: string): T | undefined {
        return this.modules.get(name)?.artifact as T | undefined
    }

    /** 构建顺序（供输出阶段使用） */
    get buildOrder(): string[] {
        return [...this.order]
    }
}
