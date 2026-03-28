import json
from collections import OrderedDict
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
SOURCE_PATH = ROOT / "final" / "i18n" / "cn" / "Dungeon.json"
TARGET_PATH = Path(r"D:\dev\dna-builder\src\data\d\dungeon.data.ts")


INTERFACE_BLOCK = """export interface Dungeon {
    id: number
    n: string
    t: string
    e?: string
    ts?: string
    lv: number
    rd: number
    desc?: string
    m: number[]
    r: number[]
    win: number
    sm?: number[]
    sr?: number[]
    spawn?: SpawnInfo[][]
}

export interface SpawnInfo {
    /** 生成器ID */
    id: number
    /** 检查时间 单位秒 */
    time?: number
    /** 刷新阈值 */
    th?: number
    /** 刷新范围 单位米*100 */
    radius?: number[]
    /** 普通怪物 */
    m?: SpawnMonster[]
    /** 组刷怪 */
    mg?: SpawnGroup[]
    /** 号令者 */
    sm?: SpawnTagMonster[]
    /** 数量 */
    smnum?: number[]
}

export interface SpawnTagMonster {
    id: number
    /** 权重 */
    w: number
    /** 等级偏移 */
    lv?: number
}

export interface SpawnMonster {
    id: number
    num: number
    numf?: number
    /** 等级偏移 */
    lv?: number
}

export interface SpawnGroup {
    id: number
    num?: number
    /** 权重 */
    w?: number
    /** 等级偏移 */
    lv?: number
    /** 组成员 */
    m?: SpawnGroupMember[]
    /** 刷怪中心范围 */
    gr?: number[]
    /** 刷怪阈值 */
    gth?: number
    /** 补怪间隔 */
    gri?: number
    /** 初始刷怪中心范围 */
    gir?: number[]
    /** 检测延迟 */
    gdt?: number
    /** 检测时间 */
    gt?: number
    /** 组上限 */
    gl?: number
    /** 组半径 */
    gar?: number
    /** Z 轴范围 */
    gz?: number
}

export interface SpawnGroupMember {
    id: number
    /** 概率 */
    p?: number
}
"""


def _ordered(value):
    if isinstance(value, dict):
        result = OrderedDict()
        for key, item in value.items():
            result[key] = _ordered(item)
        return result
    if isinstance(value, list):
        return [_ordered(item) for item in value]
    return value


def main():
    with SOURCE_PATH.open("r", encoding="utf-8") as f:
        dungeons = json.load(f, object_pairs_hook=OrderedDict)

    serialized = json.dumps(_ordered(dungeons), ensure_ascii=False, indent=4)
    output = (
        INTERFACE_BLOCK
        + "\n"
        + "export const dungeonsData: Dungeon[] = "
        + serialized
        + "\n\nexport default dungeonsData\n"
    )
    TARGET_PATH.write_text(output, encoding="utf-8", newline="\n")
    print(f"written {TARGET_PATH}")


if __name__ == "__main__":
    main()
