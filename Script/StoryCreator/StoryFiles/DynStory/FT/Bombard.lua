return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1782443535835544544",
      startPort = "StoryStart",
      endStory = "1782443537699544611",
      endPort = "In"
    },
    {
      startStory = "1782443537699544611",
      startPort = "Success",
      endStory = "1782443535835544547",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1782443535835544544"] = {
      isStoryNode = true,
      key = "1782443535835544544",
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
    ["1782443535835544547"] = {
      isStoryNode = true,
      key = "1782443535835544547",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2192.6190476190473, y = 299.5238095238095},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1782443537699544611"] = {
      isStoryNode = true,
      key = "1782443537699544611",
      type = "StoryNode",
      name = "炮击",
      pos = {x = 1418, y = 288},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "DynQuest_Bombard_Des",
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
            startQuest = "1782443577770545321",
            startPort = "Out",
            endQuest = "17824559469581070",
            endPort = "In"
          },
          {
            startQuest = "1782443577770545321",
            startPort = "Out",
            endQuest = "17824560008061870",
            endPort = "In"
          },
          {
            startQuest = "17824560331292368",
            startPort = "Out",
            endQuest = "1782443537699544615",
            endPort = "Success"
          },
          {
            startQuest = "17824559469581070",
            startPort = "Out",
            endQuest = "17829827892172397",
            endPort = "In"
          },
          {
            startQuest = "17829827892172397",
            startPort = "Out",
            endQuest = "17829827811662174",
            endPort = "In"
          },
          {
            startQuest = "1782443537699544612",
            startPort = "QuestStart",
            endQuest = "17829882186882163629",
            endPort = "In"
          },
          {
            startQuest = "17824560008061870",
            startPort = "Out",
            endQuest = "17829827527041452",
            endPort = "In"
          },
          {
            startQuest = "17829882186882163629",
            startPort = "Out",
            endQuest = "17829882665222164833",
            endPort = "In"
          },
          {
            startQuest = "17829882665222164833",
            startPort = "Out",
            endQuest = "17829882731532165086",
            endPort = "In"
          },
          {
            startQuest = "17829882731532165086",
            startPort = "Out",
            endQuest = "1782443577770545321",
            endPort = "In"
          },
          {
            startQuest = "17829882665222164833",
            startPort = "Out",
            endQuest = "1782455883279553",
            endPort = "In"
          },
          {
            startQuest = "17829882186882163629",
            startPort = "Out",
            endQuest = "17830613856413243167",
            endPort = "In"
          },
          {
            startQuest = "1782455883279553",
            startPort = "Out",
            endQuest = "17830614052443243617",
            endPort = "In"
          },
          {
            startQuest = "17829827527041452",
            startPort = "Out",
            endQuest = "17830614106323243777",
            endPort = "In"
          },
          {
            startQuest = "17830614162003243914",
            startPort = "Out",
            endQuest = "17824560331292368",
            endPort = "In"
          },
          {
            startQuest = "17830633902356489861",
            startPort = "Out",
            endQuest = "17830614162003243914",
            endPort = "In"
          },
          {
            startQuest = "17829827811662174",
            startPort = "Out",
            endQuest = "17830633902356489861",
            endPort = "Input_2"
          },
          {
            startQuest = "17830633720566489574",
            startPort = "Out",
            endQuest = "17830633902356489861",
            endPort = "Input_1"
          },
          {
            startQuest = "17829882731532165086",
            startPort = "Out",
            endQuest = "17830633720566489574",
            endPort = "In"
          }
        },
        nodeData = {
          ["1782443537699544612"] = {
            key = "1782443537699544612",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 243.80952380952377, y = 203.65079365079367},
            propsData = {ModeType = 0}
          },
          ["1782443537699544615"] = {
            key = "1782443537699544615",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3384.459699974574, y = 69.35672514619881},
            propsData = {ModeType = 0}
          },
          ["1782443537699544618"] = {
            key = "1782443537699544618",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1782443577770545321"] = {
            key = "1782443577770545321",
            type = "ChangeStaticCreatorNode",
            name = "生成怪物",
            pos = {x = 1260.6599190283398, y = 215.53846153846155},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                292790080,
                292790081,
                292790082,
                292790083,
                292790084,
                292790085,
                292790086,
                292790087,
                292790088
              }
            }
          },
          ["1782455883279553"] = {
            key = "1782455883279553",
            type = "ChangeStaticCreatorNode",
            name = "生成炮击",
            pos = {x = 1064.9172494172485, y = 471.7999500499503},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {292790089}
            }
          },
          ["17824559469581070"] = {
            key = "17824559469581070",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 1572.8018648018647, y = 223.39335664335667},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 9,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                292790080,
                292790081,
                292790082,
                292790083,
                292790084,
                292790085,
                292790086,
                292790087,
                292790088
              }
            }
          },
          ["17824560008061870"] = {
            key = "17824560008061870",
            type = "KillMonsterNode",
            name = "记录杀了多少怪",
            pos = {x = 1578.9557109557109, y = 447.23951048951056},
            propsData = {
              KillMonsterType = "Nums",
              MonsterNeedNums = 4,
              IsShow = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17824560331292368"] = {
            key = "17824560331292368",
            type = "DynamicQuestSuccessNode",
            name = "动态任务主动成功",
            pos = {x = 3117.97505418558, y = 66.72444076391446},
            propsData = {
              DialogueId = 0,
              UseTalkFadeOut = true,
              TalkFadeOutTime = 1,
              UseTalkFadeIn = true,
              TalkFadeInTime = 1
            }
          },
          ["17829827527041452"] = {
            key = "17829827527041452",
            type = "ChangeStaticCreatorNode",
            name = "生成炮击",
            pos = {x = 1912.6593370111962, y = 457.85634044000767},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {292790139}
            }
          },
          ["17829827811662174"] = {
            key = "17829827811662174",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 2272.5006068524663, y = 195.3563404400076},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 9,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                292790140,
                292790141,
                292790142,
                292790143,
                292790144,
                292790145,
                292790146,
                292790147,
                292790148
              }
            }
          },
          ["17829827892172397"] = {
            key = "17829827892172397",
            type = "ChangeStaticCreatorNode",
            name = "生成怪物",
            pos = {x = 1950.2783846302436, y = 201.70554678921397},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                292790140,
                292790141,
                292790142,
                292790143,
                292790144,
                292790145,
                292790146,
                292790147,
                292790148
              }
            }
          },
          ["17829828000322804"] = {
            key = "17829828000322804",
            type = "KillMonsterNode",
            name = "记录杀了多少怪",
            pos = {x = 2674.5640989159583, y = 817.5785626622298},
            propsData = {
              KillMonsterType = "Nums",
              MonsterNeedNums = 4,
              IsShow = true,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17829882186882163629"] = {
            key = "17829882186882163629",
            type = "SendMessageNode",
            name = "动态刷怪开始",
            pos = {x = 529.8021941540535, y = 202.49919758286455},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "BambardFightStart",
              UnitId = -1
            }
          },
          ["17829882665222164833"] = {
            key = "17829882665222164833",
            type = "KillMonsterNode",
            name = "记录杀了多少怪",
            pos = {x = 789.326003677863, y = 184.8801499638171},
            propsData = {
              KillMonsterType = "Nums",
              MonsterNeedNums = 15,
              IsShow = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17829882731532165086"] = {
            key = "17829882731532165086",
            type = "SendMessageNode",
            name = "动态刷怪结束",
            pos = {x = 1047.5006068524663, y = 22.380149963817136},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "BambardFightEnd",
              UnitId = -1
            }
          },
          ["17830613856413243167"] = {
            key = "17830613856413243167",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 734.5, y = 433},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71009201,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17830614052443243617"] = {
            key = "17830614052443243617",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1341, y = 567.125},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71009202,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17830614106323243777"] = {
            key = "17830614106323243777",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2095.5, y = 607.625},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71009203,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17830614162003243914"] = {
            key = "17830614162003243914",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2822.2222222222226, y = 59.45833333333333},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71009204,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17830633720566489574"] = {
            key = "17830633720566489574",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = 2274.62355945568, y = -100.0528138528139},
            propsData = {
              SendMessage = "",
              FinishCondition = "BambardFightEndBack"
            }
          },
          ["17830633902356489861"] = {
            key = "17830633902356489861",
            type = "WaitQuestFinishedNode",
            name = "等待任务完成",
            pos = {x = 2572.4013372334575, y = 39.94718614718617},
            propsData = {ListenCount = 2, NeedFinishCount = 2}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
