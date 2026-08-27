return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17823701028761",
      startPort = "StoryStart",
      endStory = "1782370147488208",
      endPort = "In"
    },
    {
      startStory = "1782370147488208",
      startPort = "Success",
      endStory = "17823701028775",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17823701028761"] = {
      isStoryNode = true,
      key = "17823701028761",
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
    ["17823701028775"] = {
      isStoryNode = true,
      key = "17823701028775",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1836, y = 308},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1782370147488208"] = {
      isStoryNode = true,
      key = "1782370147488208",
      type = "StoryNode",
      name = "击杀历战者",
      pos = {x = 1348.75, y = 302},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "DynQuest_FightLizhan_Des",
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
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1782370147488209",
            startPort = "QuestStart",
            endQuest = "17823704004931081962",
            endPort = "In"
          },
          {
            startQuest = "17823704004931081962",
            startPort = "Out",
            endQuest = "17823705400361082639",
            endPort = "In"
          },
          {
            startQuest = "17823742137603245404",
            startPort = "Out",
            endQuest = "1782370147488217",
            endPort = "Success"
          },
          {
            startQuest = "17823704004931081962",
            startPort = "Out",
            endQuest = "17823743482854326468",
            endPort = "In"
          },
          {
            startQuest = "17823705400361082639",
            startPort = "Out",
            endQuest = "17830610926631405",
            endPort = "In"
          },
          {
            startQuest = "17830674302089735346",
            startPort = "Out",
            endQuest = "17830674667799735710",
            endPort = "In"
          },
          {
            startQuest = "17830674667799735710",
            startPort = "Out",
            endQuest = "17830674169959735142",
            endPort = "In"
          },
          {
            startQuest = "17830674794839736063",
            startPort = "Out",
            endQuest = "17830611978911082025",
            endPort = "In"
          },
          {
            startQuest = "1783651460776935",
            startPort = "Out",
            endQuest = "17830674794839736063",
            endPort = "Input_1"
          },
          {
            startQuest = "17830611978911082025",
            startPort = "Out",
            endQuest = "17823742137603245404",
            endPort = "In"
          },
          {
            startQuest = "17823705400361082639",
            startPort = "Out",
            endQuest = "17830674052779734932",
            endPort = "In"
          },
          {
            startQuest = "17830674052779734932",
            startPort = "Out",
            endQuest = "1783651460776935",
            endPort = "In"
          },
          {
            startQuest = "17823705400361082639",
            startPort = "Out",
            endQuest = "17836680657273841343",
            endPort = "In"
          },
          {
            startQuest = "17836680657273841343",
            startPort = "Out",
            endQuest = "17836680778643841606",
            endPort = "In"
          },
          {
            startQuest = "17836680778643841606",
            startPort = "Out",
            endQuest = "17830674794839736063",
            endPort = "Input_2"
          }
        },
        nodeData = {
          ["1782370147488209"] = {
            key = "1782370147488209",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1782370147488217"] = {
            key = "1782370147488217",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3807.5809716599188, y = 376.2874493927126},
            propsData = {ModeType = 0}
          },
          ["1782370147488225"] = {
            key = "1782370147488225",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17823704004931081962"] = {
            key = "17823704004931081962",
            type = "ChangeStaticCreatorNode",
            name = "生成历战者",
            pos = {x = 1149.3846153846152, y = 294.3402834008097},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {292790059}
            }
          },
          ["17823705400361082639"] = {
            key = "17823705400361082639",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 1495.3584382042645, y = 307.61033535430096},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 1,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {292790059}
            }
          },
          ["17823742137603245404"] = {
            key = "17823742137603245404",
            type = "DynamicQuestSuccessNode",
            name = "动态任务主动成功",
            pos = {x = 3528.1745951417006, y = 359.6148487735176},
            propsData = {
              DialogueId = 0,
              UseTalkFadeOut = false,
              TalkFadeOutTime = 0,
              UseTalkFadeIn = false,
              TalkFadeInTime = 0
            }
          },
          ["17823743482854326468"] = {
            key = "17823743482854326468",
            type = "TalkNode",
            name = "历战者出现开车",
            pos = {x = 1459.720773219915, y = 74.04396885252322},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71009001,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17830610926631405"] = {
            key = "17830610926631405",
            type = "TalkNode",
            name = "历战者出现开车",
            pos = {x = 1799.6153846153848, y = 53.57692307692299},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71009002,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17830611978911082025"] = {
            key = "17830611978911082025",
            type = "TalkNode",
            name = "历战者出现开车",
            pos = {x = 3141.5384615384614, y = 342.2692307692308},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71009003,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17830674052779734932"] = {
            key = "17830674052779734932",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1833.7747252747256, y = 304.98717948717956},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "LizhanFightStart",
              UnitId = -1
            }
          },
          ["17830674169959735142"] = {
            key = "17830674169959735142",
            type = "BossBattleFinishNode",
            name = "击杀小兵",
            pos = {x = 2335.1208791208796, y = 942.1410256410256},
            propsData = {
              SendMessage = "",
              FinishCondition = "LizhanFightEndBack"
            }
          },
          ["17830674302089735346"] = {
            key = "17830674302089735346",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 1800.8901098901104, y = 938.6794871794873},
            propsData = {
              KillMonsterType = "Nums",
              MonsterNeedNums = 10,
              IsShow = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17830674667799735710"] = {
            key = "17830674667799735710",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2042.428571428572, y = 947.9102564102565},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "LizhanFightEnd",
              UnitId = -1
            }
          },
          ["17830674794839736063"] = {
            key = "17830674794839736063",
            type = "WaitQuestFinishedNode",
            name = "等待任务完成",
            pos = {x = 2809.697802197803, y = 358.1794871794873},
            propsData = {ListenCount = 2, NeedFinishCount = 2}
          },
          ["1783651460776935"] = {
            key = "1783651460776935",
            type = "BossBattleFinishNode",
            name = "击杀历战者",
            pos = {x = 2163.005494505495, y = 303.4340659340659},
            propsData = {SendMessage = "", FinishCondition = "LizhanRule"}
          },
          ["17836680657273841343"] = {
            key = "17836680657273841343",
            type = "ChangeStaticCreatorNode",
            name = "生成小兵",
            pos = {x = 1877.0285714285717, y = 581.7535714285714},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                292790231,
                292790232,
                292790233,
                292790234,
                292790235,
                292790236,
                292790237,
                292790238,
                292790239,
                292790240
              }
            }
          },
          ["17836680778643841606"] = {
            key = "17836680778643841606",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 2201.528571428572, y = 583.2535714285714},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 10,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                292790231,
                292790232,
                292790233,
                292790234,
                292790235,
                292790236,
                292790237,
                292790238,
                292790239,
                292790240
              }
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
