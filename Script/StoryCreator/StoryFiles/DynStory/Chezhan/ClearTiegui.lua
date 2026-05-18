return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17756403941641",
      startPort = "StoryStart",
      endStory = "1775640679706390",
      endPort = "In"
    },
    {
      startStory = "1775640679706390",
      startPort = "Success",
      endStory = "17756403941655",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17756403941641"] = {
      isStoryNode = true,
      key = "17756403941641",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17756403941655"] = {
      isStoryNode = true,
      key = "17756403941655",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1712.857142857143, y = 282.85714285714283},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1775640679706390"] = {
      isStoryNode = true,
      key = "1775640679706390",
      type = "StoryNode",
      name = "清理铁轨",
      pos = {x = 1213.764705882353, y = 299.3298319327731},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "DynQuest_ClearTiegui_Des",
        QuestDeatil = "",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = false,
        bIsNotifyGameMode = true,
        bIsStartChapter = false,
        bIsEndChapter = false,
        bIsPlayBlackScreenOnComplete = false,
        bIsPlayBlackScreenOnFail = false,
        bIsDynamicEvent = true,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        IsBacktrack = false,
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17757030931412207",
            startPort = "Out",
            endQuest = "17757030931412206",
            endPort = "In"
          },
          {
            startQuest = "17757030931412207",
            startPort = "Out",
            endQuest = "17757030931412208",
            endPort = "In"
          },
          {
            startQuest = "17757030931412211",
            startPort = "Out",
            endQuest = "17757030931412213",
            endPort = "In"
          },
          {
            startQuest = "17757030931412213",
            startPort = "Out",
            endQuest = "17757030931412212",
            endPort = "In"
          },
          {
            startQuest = "17757030931412210",
            startPort = "Out",
            endQuest = "17757030931412215",
            endPort = "In"
          },
          {
            startQuest = "17757030931412215",
            startPort = "Out",
            endQuest = "17757030931412214",
            endPort = "In"
          },
          {
            startQuest = "17757030931412210",
            startPort = "Out",
            endQuest = "17757030931412216",
            endPort = "In"
          },
          {
            startQuest = "17757030931412216",
            startPort = "Out",
            endQuest = "17757030931412211",
            endPort = "Input_1"
          },
          {
            startQuest = "17757030931412210",
            startPort = "Out",
            endQuest = "17757030931412217",
            endPort = "In"
          },
          {
            startQuest = "17757030931412210",
            startPort = "Out",
            endQuest = "17757030931412218",
            endPort = "In"
          },
          {
            startQuest = "17757030931412210",
            startPort = "Out",
            endQuest = "17757030931412219",
            endPort = "In"
          },
          {
            startQuest = "17757030931412210",
            startPort = "Out",
            endQuest = "17757030931412220",
            endPort = "In"
          },
          {
            startQuest = "17757030931412217",
            startPort = "Out",
            endQuest = "17757030931412211",
            endPort = "Input_2"
          },
          {
            startQuest = "17757030931412218",
            startPort = "Out",
            endQuest = "17757030931412211",
            endPort = "Input_3"
          },
          {
            startQuest = "17757030931412219",
            startPort = "Out",
            endQuest = "17757030931412211",
            endPort = "Input_4"
          },
          {
            startQuest = "17757030931412220",
            startPort = "Out",
            endQuest = "17757030931412211",
            endPort = "Input_5"
          },
          {
            startQuest = "17757030931412208",
            startPort = "Option_1",
            endQuest = "17757030931412210",
            endPort = "In"
          },
          {
            startQuest = "17757030931412208",
            startPort = "Option_2",
            endQuest = "17757030931412209",
            endPort = "In"
          },
          {
            startQuest = "1775640679706391",
            startPort = "QuestStart",
            endQuest = "17757030931412207",
            endPort = "In"
          },
          {
            startQuest = "17757030931412212",
            startPort = "Out",
            endQuest = "1775640679707399",
            endPort = "Success"
          },
          {
            startQuest = "17757030931412209",
            startPort = "Out",
            endQuest = "1775640679707399",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1775640679706391"] = {
            key = "1775640679706391",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1775640679707399"] = {
            key = "1775640679707399",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3664.9896103896103, y = 307.9246753246753},
            propsData = {ModeType = 0}
          },
          ["1775640679707407"] = {
            key = "1775640679707407",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3948.5714285714284, y = 777.1428571428571},
            propsData = {}
          },
          ["17757030931412206"] = {
            key = "17757030931412206",
            type = "TalkNode",
            name = "开车",
            pos = {x = 1472.7510142205579, y = 52.15467373398849},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71008501,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17757030931412207"] = {
            key = "17757030931412207",
            type = "ChangeStaticCreatorNode",
            name = "生成捕鱼NPC",
            pos = {x = 1111.6652999348437, y = 296.3832451625599},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {292480114}
            }
          },
          ["17757030931412208"] = {
            key = "17757030931412208",
            type = "TalkNode",
            name = "交互请求清理垃圾",
            pos = {x = 1470.666948286492, y = 256.20137703069173},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 818039,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Dyn_292480114",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 71008502,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 2,
              InType = "BlendIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {},
              OptionType = "branch",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              BranchOptions = {"", ""},
              OverrideFailBlend = false
            }
          },
          ["17757030931412209"] = {
            key = "17757030931412209",
            type = "DynamicQuestFailNode",
            name = "动态任务主动失败",
            pos = {x = 1877.6975766106964, y = 626.1731384478094},
            propsData = {UseTalkFadeOut = false, TalkFadeOutTime = 0}
          },
          ["17757030931412210"] = {
            key = "17757030931412210",
            type = "ChangeStaticCreatorNode",
            name = "生成可破坏物",
            pos = {x = 1937.1206535337735, y = 272.2885230631938},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                292480115,
                292480116,
                292480117,
                292480118,
                292480119
              }
            }
          },
          ["17757030931412211"] = {
            key = "17757030931412211",
            type = "WaitQuestFinishedNode",
            name = "等待任务完成",
            pos = {x = 2614.1505680636874, y = 223.35262562729642},
            propsData = {ListenCount = 5, NeedFinishCount = 5}
          },
          ["17757030931412212"] = {
            key = "17757030931412212",
            type = "DynamicQuestSuccessNode",
            name = "动态任务主动成功",
            pos = {x = 3292.8898843030042, y = 308.7308307555015},
            propsData = {
              DialogueId = 0,
              UseTalkFadeOut = true,
              TalkFadeOutTime = 1,
              UseTalkFadeIn = true,
              TalkFadeInTime = 1
            }
          },
          ["17757030931412213"] = {
            key = "17757030931412213",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2913.4194298082084, y = 273.64788651654413},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 818039,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Dyn_292480114",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 71008505,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17757030931412214"] = {
            key = "17757030931412214",
            type = "SendMessageNode",
            name = "挂垃圾指引点",
            pos = {x = 2259.7793073799266, y = -157.2089184572739},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "OpenGuidePoint",
              UnitId = -1
            }
          },
          ["17757030931412215"] = {
            key = "17757030931412215",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1960.7168073799269, y = -151.5839184572739},
            propsData = {WaitTime = 1}
          },
          ["17757030931412216"] = {
            key = "17757030931412216",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = 2288.7168073799266, y = 11.742470431615004},
            propsData = {SendMessage = "", FinishCondition = "292480115"}
          },
          ["17757030931412217"] = {
            key = "17757030931412217",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = 2297.4668073799266, y = 146.7424704316149},
            propsData = {SendMessage = "", FinishCondition = "292480116"}
          },
          ["17757030931412218"] = {
            key = "17757030931412218",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = 2297.4668073799266, y = 275.4924704316149},
            propsData = {SendMessage = "", FinishCondition = "292480117"}
          },
          ["17757030931412219"] = {
            key = "17757030931412219",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = 2308.7168073799266, y = 402.9924704316149},
            propsData = {SendMessage = "", FinishCondition = "292480118"}
          },
          ["17757030931412220"] = {
            key = "17757030931412220",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = 2292.4668073799266, y = 542.992470431615},
            propsData = {SendMessage = "", FinishCondition = "292480119"}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
