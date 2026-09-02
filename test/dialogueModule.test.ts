import { describe, expect, test } from "bun:test"
import type { ModuleContext } from "../src/core/Graph.ts"
import { renderTree } from "../src/i18n/vnode.ts"
import { dialogueModule, flowDialogueIds } from "../src/modules/dialogue/dialogueModule.ts"

describe("DialogueService", () => {
    test("reads flat FModel and nested UAssetCLI GUIDs", () => {
        const flow = (nested: boolean) => [
            {
                Type: "FlowNode_Start",
                Properties: {
                    NodeGuid: nested ? { NodeGuid: "start" } : "start",
                    Connections: [{ Value: { NodeGuid: nested ? { NodeGuid: "talk" } : "talk" } }],
                },
            },
            {
                Type: "FlowNode_Dialogue",
                Properties: {
                    NodeGuid: nested ? { NodeGuid: "talk" } : "talk",
                    DialogueData: [{ DialogueId: 101 }, { DialogueId: 102 }],
                },
            },
        ]

        expect(flowDialogueIds(flow(false))).toEqual([101, 102])
        expect(flowDialogueIds(flow(true))).toEqual([101, 102])
    })

    test("cached chains do not share nested options with callers", () => {
        const data = new Map([
            ["1", { DialogueId: 1, Content: "root", NextOptions: [2] }],
            ["2", { DialogueId: 2, Content: "option" }],
        ])
        const ctx = {
            dm: {
                getTable: () => ({}),
                getDialogueItems: (tables: string[]) => new Map(tables.map(table => [table, data])),
            },
        } as unknown as ModuleContext
        const dialogue = dialogueModule(ctx)

        const first = dialogue.chain(1) as Array<Record<string, any>>
        first[0].options[0].next = 1

        const second = dialogue.chain(1) as Array<Record<string, any>>
        expect(second[0].options[0].next).toBeUndefined()
    })

    test("attaches FlowAsset option branches to the upstream dialogue", () => {
        const data = new Map([
            ["10", { DialogueId: 10, Content: "root" }],
            ["20", { DialogueId: 20, Content: "option" }],
            ["30", { DialogueId: 30, Content: "next" }],
        ])
        const ctx = {
            dm: {
                getTable: () => ({}),
                getDialogueItems: (tables: string[]) => new Map(tables.map(table => [table, data])),
            },
        } as unknown as ModuleContext
        const dialogue = dialogueModule(ctx)
        const flow = [
            {
                Type: "FlowNode_Start",
                Properties: { NodeGuid: "start", Connections: [{ Value: { NodeGuid: "dialogue" } }] },
            },
            {
                Type: "FlowNode_Dialogue",
                Properties: {
                    NodeGuid: "dialogue",
                    DialogueData: [{ DialogueId: 10 }],
                    Connections: [{ Value: { NodeGuid: "option" } }],
                },
            },
            {
                Type: "FlowNode_Option",
                Properties: {
                    NodeGuid: "option",
                    OptionData: [{ DialogueId: 20 }],
                    OptionPinName: [{ Key: "20", Value: "Option_20" }],
                    Connections: [{ Key: "Option_20", Value: { NodeGuid: "next" } }],
                },
            },
            {
                Type: "FlowNode_Dialogue",
                Properties: { NodeGuid: "next", DialogueData: [{ DialogueId: 30 }] },
            },
        ]
        ;(dialogue as any).flowFile = () => flow

        expect(renderTree(dialogue.flowChain("flow"), "cn", {} as never)).toEqual([
            { id: 10, content: "root", options: [{ id: 20, content: "option", next: 30 }] },
            { id: 30, content: "next" },
        ])
    })

    test("removes nested FlowAsset options from the top-level dialogue list", () => {
        const data = new Map([
            ["10", { DialogueId: 10, Content: "root" }],
            ["20", { DialogueId: 20, Content: "outer option", NextOptions: [21] }],
            ["21", { DialogueId: 21, Content: "nested option", NextDialogue: 30 }],
            ["30", { DialogueId: 30, Content: "next" }],
        ])
        const ctx = {
            dm: {
                getTable: () => ({}),
                getDialogueItems: (tables: string[]) => new Map(tables.map(table => [table, data])),
            },
        } as unknown as ModuleContext
        const dialogue = dialogueModule(ctx)
        const flow = [
            {
                Type: "FlowNode_Start",
                Properties: { NodeGuid: "start", Connections: [{ Value: { NodeGuid: "dialogue" } }] },
            },
            {
                Type: "FlowNode_Dialogue",
                Properties: {
                    NodeGuid: "dialogue",
                    DialogueData: [{ DialogueId: 10 }],
                    Connections: [{ Value: { NodeGuid: "option" } }],
                },
            },
            {
                Type: "FlowNode_Option",
                Properties: {
                    NodeGuid: "option",
                    OptionData: [{ DialogueId: 20 }],
                    OptionPinName: [{ Key: "20", Value: "Option_20" }],
                    Connections: [{ Key: "Option_20", Value: { NodeGuid: "next" } }],
                },
            },
            {
                Type: "FlowNode_Dialogue",
                Properties: { NodeGuid: "next", DialogueData: [{ DialogueId: 21 }, { DialogueId: 30 }] },
            },
        ]
        ;(dialogue as any).flowFile = () => flow

        expect(renderTree(dialogue.flowChain("flow"), "cn", {} as never)).toEqual([
            {
                id: 10,
                content: "root",
                options: [
                    {
                        id: 20,
                        content: "outer option",
                        next: 21,
                        options: [{ id: 21, content: "nested option", next: 30 }],
                    },
                ],
            },
            { id: 30, content: "next" },
        ])
    })

    test("story talks use numeric StoryCreator key order", () => {
        const ctx = {
            dm: {
                getTable: () => ({}),
                loadStoryFile: () => ({
                    storyNodeData: {
                        parent: {
                            questNodeData: {
                                nodeData: {
                                    "17429764706543639904": {
                                        type: "TalkNode",
                                        propsData: { FirstDialogueId: 19 },
                                    },
                                    "1743314154288524817": {
                                        type: "TalkNode",
                                        propsData: { FirstDialogueId: 52 },
                                    },
                                },
                            },
                        },
                    },
                }),
            },
        } as unknown as ModuleContext

        expect(dialogueModule(ctx).storyTalks("story").map(item => item.firstDialogueId)).toEqual([52, 19])
    })

    test("keeps localized-only dialogue in the languages that define it", () => {
        const ctx = {
            dm: {
                getTable: () => ({}),
                getDialogueItems: (tables: string[]) =>
                    new Map(
                        tables.map(table => [
                            table,
                            new Map([["1", table === "Dialogue_ContentEN" ? { DialogueId: 1, ContentEN: "localized" } : { DialogueId: 1 }]]),
                        ])
                    ),
            },
        } as unknown as ModuleContext
        const chain = dialogueModule(ctx).chain(1)
        const textmap = {} as never

        expect(renderTree(chain, "cn", textmap)).toEqual([])
        expect(renderTree(chain, "en", textmap)).toEqual([{ id: 1, content: "localized" }])
    })

    test("keeps localized-only dialogue with voice in every language", () => {
        const ctx = {
            dm: {
                getTable: () => ({}),
                getDialogueItems: (tables: string[]) =>
                    new Map(
                        tables.map(table => [
                            table,
                            new Map([
                                [
                                    "1",
                                    table === "Dialogue_ContentEN"
                                        ? { DialogueId: 1, ContentEN: "localized" }
                                        : { DialogueId: 1, VoiceName: "voice/$Locale$/story/voice" },
                                ],
                            ]),
                        ])
                    ),
            },
        } as unknown as ModuleContext
        const chain = dialogueModule(ctx).chain(1)
        const textmap = {} as never

        expect(renderTree(chain, "cn", textmap)).toEqual([{ id: 1, voice: "story/voice" }])
        expect(renderTree(chain, "en", textmap)).toEqual([{ id: 1, content: "localized", voice: "story/voice" }])
    })
})
