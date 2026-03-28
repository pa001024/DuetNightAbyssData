import json
from collections import OrderedDict
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
SOURCE_PATH = ROOT / "final" / "i18n" / "cn" / "Monster.json"
TARGET_PATH = Path(r"D:\dev\dna-builder\src\data\d\monster.data.ts")


INTERFACE_BLOCK = """export interface Monster {
    id: number
    n: string
    t?: "Rescue_Elite_Monster" | "Elite_Monster" | "Boss"
    f?: Faction
    atk: number
    def: number
    hp: number
    es?: number
    tn?: number
    icon?: string
    /** 号令者词条标签，来自 GamePlayTags 中的 Mon.Strong.* */
    tags?: string[]
}

export enum Faction {
    其他 = 0,
    秽兽 = 1,
    海伯利亚帝国 = 2,
    神弃者同盟 = 3,
    艾利西安传颂会 = 4,
    华胥 = 5,
}

export interface DynamicMonster extends Monster {
    currentHP: number
    currentShield: number
    currentWarPose: number
}
"""

MOCK_BLOCK = """const mock: Monster[] = [
    { id: 0, n: "护盾木桩", f: 1, atk: 10, def: 130, es: 1000000000, hp: 1000000000, tn: 150 },
    { id: 130, n: "生命木桩130", f: 1, atk: 10, def: 130, hp: 1000000000, tn: 150 },
    { id: 200, n: "生命木桩200", f: 1, atk: 10, def: 200, hp: 1000000000, tn: 150 },
    { id: 300, n: "生命木桩300", f: 1, atk: 10, def: 300, hp: 1000000000, tn: 150 },
]
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
        monsters = json.load(f, object_pairs_hook=OrderedDict)

    serialized = json.dumps(_ordered(monsters), ensure_ascii=False, indent=4)
    output = (
        INTERFACE_BLOCK
        + "\n"
        + MOCK_BLOCK
        + "\n\n"
        + "const monsterData: Monster[] = "
        + serialized
        + "\n\nmonsterData.push(...mock)\n\n"
        + "export const monsterMap = new Map<number, Monster>()\n"
        + "monsterData.forEach(v => monsterMap.set(v.id, v))\n\n"
        + "export default monsterData\n"
    )
    TARGET_PATH.write_text(output, encoding="utf-8", newline="\n")
    print(f"written {TARGET_PATH}")


if __name__ == "__main__":
    main()
