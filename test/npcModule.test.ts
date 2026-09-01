import { describe, expect, test } from "bun:test"
import type { DialogueService } from "../src/modules/dialogue/dialogueModule.ts"
import { buildNpcGuidePointIndex, findNpcGuidePoint, npcStoryDialogues } from "../src/modules/npc/npcModule.ts"

describe("Npc guide point resolution", () => {
    test("uses only a unique structural token match", () => {
        const fuluo = { __key: "EntrySeatPoint_Fuluo" }
        const heitao = { __key: "EntrySeatPoint_Heitao" }
        const awa = { __key: "fix30awa" }
        const index = buildNpcGuidePointIndex([
            fuluo,
            { __key: "Npc_Fuluo_272640019" },
            heitao,
            { __key: "Point_heitao" },
            awa,
            { __key: "Npc_Awa_1650052" },
        ])

        expect(findNpcGuidePoint(index, "Fuluo")).toBe(fuluo)
        expect(findNpcGuidePoint(index, "Heitao")).toBeUndefined()
        expect(findNpcGuidePoint(index, "Awa")).toBe(awa)
    })

    test("reads talk nodes in numeric key order without losing 20-digit precision", () => {
        const dialogue = {
            story: () => ({
                storyNodeData: {
                    "20": {
                        questNodeData: {
                            nodeData: {
                                "17361551876042262": { type: "TalkNode", propsData: { FirstDialogueId: 3 } },
                                "1748490198478917": { type: "TalkNode", propsData: { FirstDialogueId: 2 } },
                            },
                        },
                    },
                    "2": { type: "TalkNode", propsData: { FirstDialogueId: 1 } },
                },
            }),
            chain: (id: unknown) => [{ id }],
        } as unknown as DialogueService

        expect(npcStoryDialogues(dialogue, "story")).toEqual([{ id: 1 }, { id: 2 }, { id: 3 }])
    })
})
