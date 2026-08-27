return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17873202599081",
      startPort = "StoryStart",
      endStory = "1787320291640262",
      endPort = "In"
    },
    {
      startStory = "1787320291640262",
      startPort = "Success",
      endStory = "17873202599095",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17873202599081"] = {
      isStoryNode = true,
      key = "17873202599081",
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
    ["17873202599095"] = {
      isStoryNode = true,
      key = "17873202599095",
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
    ["1787320291640262"] = {
      isStoryNode = true,
      key = "1787320291640262",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1758, y = 314},
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
            startQuest = "1787320291640263",
            startPort = "QuestStart",
            endQuest = "1787320307745691",
            endPort = "In"
          },
          {
            startQuest = "1787320307745691",
            startPort = "Out",
            endQuest = "1787320291641271",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1787320291640263"] = {
            key = "1787320291640263",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1787320291641271"] = {
            key = "1787320291641271",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1787320291641279"] = {
            key = "1787320291641279",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1787320307745691"] = {
            key = "1787320307745691",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1472, y = 444},
            propsData = {GuideId = 159}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
