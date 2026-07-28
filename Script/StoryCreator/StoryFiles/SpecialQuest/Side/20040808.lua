return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1782204109786984546",
      startPort = "StoryStart",
      endStory = "1782204109786984548",
      endPort = "In"
    },
    {
      startStory = "1782204109786984548",
      startPort = "Success",
      endStory = "1782204109786984547",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1782204109786984546"] = {
      isStoryNode = true,
      key = "1782204109786984546",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1670.7857142857142, y = 326.15714285714284},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1782204109786984547"] = {
      isStoryNode = true,
      key = "1782204109786984547",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2353.4285714285716, y = 306.3},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1782204109786984548"] = {
      isStoryNode = true,
      key = "1782204109786984548",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 2013.9853174603174, y = 312.43571428571425},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "",
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
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestRegion_152480434",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1782204109786984549",
            startPort = "QuestStart",
            endQuest = "1782204109786984552",
            endPort = "In"
          },
          {
            startQuest = "1782204109786984552",
            startPort = "Out",
            endQuest = "1782204109786984551",
            endPort = "Fail"
          },
          {
            startQuest = "1782204109786984549",
            startPort = "QuestStart",
            endQuest = "1782204109786984553",
            endPort = "In"
          },
          {
            startQuest = "1782204109786984553",
            startPort = "Out",
            endQuest = "1782204109786984554",
            endPort = "In"
          },
          {
            startQuest = "1782204109786984554",
            startPort = "Out",
            endQuest = "1783438599229347",
            endPort = "In"
          },
          {
            startQuest = "1783438599229347",
            startPort = "Out",
            endQuest = "1782204109786984555",
            endPort = "In"
          }
        },
        nodeData = {
          ["1782204109786984549"] = {
            key = "1782204109786984549",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -430.610319627962, y = 151.9551930316675},
            propsData = {ModeType = 0}
          },
          ["1782204109786984550"] = {
            key = "1782204109786984550",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1266.3511333028005, y = -163.1744812698551},
            propsData = {ModeType = 0}
          },
          ["1782204109786984551"] = {
            key = "1782204109786984551",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1536.4285714285697, y = 805.7142857142859},
            propsData = {}
          },
          ["1782204109786984552"] = {
            key = "1782204109786984552",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 569.0080106101102, y = 674.2717990046028},
            propsData = {}
          },
          ["1782204109786984553"] = {
            key = "1782204109786984553",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = -78.50703157025936, y = 66.37518146861132},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                242890207,
                242890208,
                242890209,
                242890210,
                242890211,
                242890212,
                242890213,
                242890214,
                242890215
              }
            }
          },
          ["1782204109786984554"] = {
            key = "1782204109786984554",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 286.6358255725977, y = 95.51803861146846},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 9,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                242890207,
                242890208,
                242890209,
                242890210,
                242890211,
                242890212,
                242890213,
                242890214,
                242890215
              }
            }
          },
          ["1782204109786984555"] = {
            key = "1782204109786984555",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 823.9095673505368, y = 80.86435235198938},
            propsData = {}
          },
          ["1783438599229347"] = {
            key = "1783438599229347",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 555.387641954123, y = 18.145392639814474},
            propsData = {WaitTime = 2}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
