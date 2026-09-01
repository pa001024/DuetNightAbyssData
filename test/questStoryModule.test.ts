import { describe, expect, test } from "bun:test"
import { collectSpecialStoryPaths } from "../src/modules/questStory/questStoryModule.ts"

describe("QuestStory special stories", () => {
    test("collects only explicit configured story paths", () => {
        const story = {
            storyNodeData: {
                parent: {
                    questNodeData: {
                        nodeData: {
                            first: {
                                type: "WaitingSpecialQuestStartAndFinishNode",
                                propsData: { SpecialConfigId: 10 },
                            },
                            missingId: {
                                type: "WaitingSpecialQuestStartAndFinishNode",
                                propsData: {},
                            },
                            missingConfig: {
                                type: "WaitingSpecialQuestStartAndFinishNode",
                                propsData: { SpecialConfigId: 11 },
                            },
                        },
                    },
                },
            },
        }

        expect(collectSpecialStoryPaths(story, { 10: { StoryPath: "SpecialQuest/10.story" } })).toEqual(["SpecialQuest/10.story"])
    })

})
