return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1782291485803244",
      startPort = "Success",
      endStory = "17822914773575",
      endPort = "StoryEnd"
    },
    {
      startStory = "17822914773571",
      startPort = "StoryStart",
      endStory = "1782291485803244",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17822914773571"] = {
      isStoryNode = true,
      key = "17822914773571",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1410.5714285714287, y = 294.35714285714283},
      propsData = {QuestChainId = 110211},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17822914773575"] = {
      isStoryNode = true,
      key = "17822914773575",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2800, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1782291485803244"] = {
      isStoryNode = true,
      key = "1782291485803244",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 2165.05, y = 250.45714285714288},
      propsData = {
        QuestId = 11021101,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110211_01",
        QuestDeatil = "Content_110211_01",
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
        SubRegionId = 107001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_goto_wanju_142780377",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1782291485803245",
            startPort = "QuestStart",
            endQuest = "1782291621165839",
            endPort = "In"
          },
          {
            startQuest = "1782291621165839",
            startPort = "Out",
            endQuest = "17822917308811312",
            endPort = "In"
          },
          {
            startQuest = "17822917308811312",
            startPort = "Success",
            endQuest = "1782291485803253",
            endPort = "Success"
          },
          {
            startQuest = "17822917939771830",
            startPort = "Out",
            endQuest = "1782291485803261",
            endPort = "Fail"
          },
          {
            startQuest = "17822917308811312",
            startPort = "Fail",
            endQuest = "17866329338031677294",
            endPort = "Input"
          },
          {
            startQuest = "17866329338031677294",
            startPort = "Out",
            endQuest = "17822917939771830",
            endPort = "In"
          },
          {
            startQuest = "17822917308811312",
            startPort = "PassiveFail",
            endQuest = "17866329338031677294",
            endPort = "Input"
          }
        },
        nodeData = {
          ["1782291485803245"] = {
            key = "1782291485803245",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1782291485803253"] = {
            key = "1782291485803253",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1782291485803261"] = {
            key = "1782291485803261",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2694, y = 566},
            propsData = {}
          },
          ["1782291621165839"] = {
            key = "1782291621165839",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1245.5925475453341, y = 259.59367167919777},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142780377,
              GuideType = "M",
              GuidePointName = "Mechanism_goto_wanju_142780377"
            }
          },
          ["17822917308811312"] = {
            key = "17822917308811312",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1676.1461189739055, y = 146.02224310776924},
            propsData = {SpecialConfigId = 11021101, BlackScreenImmediately = false}
          },
          ["17822917939771830"] = {
            key = "17822917939771830",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 2370.592547545334, y = 445.6472431077693},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 3,
              IsWhite = false
            }
          },
          ["17866329338031677294"] = {
            key = "17866329338031677294",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2005.7631578947369, y = 323.7631578947368},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
