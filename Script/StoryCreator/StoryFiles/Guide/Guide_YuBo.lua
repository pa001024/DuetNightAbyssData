return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17741727495821",
      startPort = "StoryStart",
      endStory = "177417275684398",
      endPort = "In"
    },
    {
      startStory = "177417275684398",
      startPort = "Success",
      endStory = "17741727495835",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17741727495821"] = {
      isStoryNode = true,
      key = "17741727495821",
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
    ["17741727495835"] = {
      isStoryNode = true,
      key = "17741727495835",
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
    ["177417275684398"] = {
      isStoryNode = true,
      key = "177417275684398",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1402, y = 392},
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
            startQuest = "177417275684399",
            startPort = "QuestStart",
            endQuest = "1774172768010511",
            endPort = "In"
          },
          {
            startQuest = "1774172768010511",
            startPort = "Out",
            endQuest = "1774172756844107",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177417275684399"] = {
            key = "177417275684399",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1774172756844107"] = {
            key = "1774172756844107",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1774172756844115"] = {
            key = "1774172756844115",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1774172768010511"] = {
            key = "1774172768010511",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1392, y = 598},
            propsData = {GuideId = 147}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
