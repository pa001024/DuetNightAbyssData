import { describe, expect, test } from "bun:test"
import { animMetaFromFModelData } from "../src/lua/AssetReader.ts"

describe("AssetReader", () => {
    test("射击间隔选择首段 AnimReference 对应的最后片段", () => {
        const meta = animMetaFromFModelData([
            {
                Properties: {
                    SlotAnimTracks: [
                        {
                            AnimTrack: {
                                AnimSegments: [
                                    {
                                        AnimStartTime: 0,
                                        AnimEndTime: 0.5,
                                        AnimPlayRate: 1,
                                        AnimReference: { ObjectPath: "Shooting_Loop" },
                                    },
                                    {
                                        AnimStartTime: 0,
                                        AnimEndTime: 1,
                                        AnimPlayRate: 1.2,
                                        AnimReference: { ObjectPath: "End_Idle" },
                                    },
                                ],
                            },
                        },
                    ],
                },
            },
        ])

        expect(meta.shootingInterval).toBe(0.5)
    })
})
