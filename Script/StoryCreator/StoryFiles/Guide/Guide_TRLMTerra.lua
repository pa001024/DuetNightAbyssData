return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17745446163101",
      startPort = "StoryStart",
      endStory = "1774544782577149",
      endPort = "In"
    },
    {
      startStory = "1774544782577149",
      startPort = "Success",
      endStory = "17745446163105",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17745446163101"] = {
      isStoryNode = true,
      key = "17745446163101",
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
    ["17745446163105"] = {
      isStoryNode = true,
      key = "17745446163105",
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
    ["1774544782577149"] = {
      isStoryNode = true,
      key = "1774544782577149",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1722, y = 322},
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
            startQuest = "1774544782577150",
            startPort = "QuestStart",
            endQuest = "1774544796872605",
            endPort = "In"
          },
          {
            startQuest = "1774544796872605",
            startPort = "Out",
            endQuest = "1774544782577158",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1774544782577150"] = {
            key = "1774544782577150",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1774544782577158"] = {
            key = "1774544782577158",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1774544782577166"] = {
            key = "1774544782577166",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1774544796872605"] = {
            key = "1774544796872605",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1468, y = 360},
            propsData = {GuideId = 125}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
