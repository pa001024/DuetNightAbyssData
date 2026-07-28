return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17740134996421",
      startPort = "StoryStart",
      endStory = "177401352247897",
      endPort = "In"
    },
    {
      startStory = "177401352247897",
      startPort = "Success",
      endStory = "17740134996435",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17740134996421"] = {
      isStoryNode = true,
      key = "17740134996421",
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
    ["17740134996435"] = {
      isStoryNode = true,
      key = "17740134996435",
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
    ["177401352247897"] = {
      isStoryNode = true,
      key = "177401352247897",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1612, y = 330},
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
            startQuest = "177401352247898",
            startPort = "QuestStart",
            endQuest = "1774013746483512",
            endPort = "In"
          },
          {
            startQuest = "1774013746483512",
            startPort = "Out",
            endQuest = "1774013522479106",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177401352247898"] = {
            key = "177401352247898",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1774013522479106"] = {
            key = "1774013522479106",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1774013522479114"] = {
            key = "1774013522479114",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1774013746483512"] = {
            key = "1774013746483512",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1420, y = 416},
            propsData = {GuideId = 138}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
