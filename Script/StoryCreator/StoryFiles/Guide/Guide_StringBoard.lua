return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17873200528991",
      startPort = "StoryStart",
      endStory = "1787320088798275",
      endPort = "In"
    },
    {
      startStory = "1787320088798275",
      startPort = "Success",
      endStory = "17873200529005",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17873200528991"] = {
      isStoryNode = true,
      key = "17873200528991",
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
    ["17873200529005"] = {
      isStoryNode = true,
      key = "17873200529005",
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
    ["1787320088798275"] = {
      isStoryNode = true,
      key = "1787320088798275",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1572, y = 312},
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
            startQuest = "1787320088798276",
            startPort = "QuestStart",
            endQuest = "1787320096718597",
            endPort = "In"
          },
          {
            startQuest = "1787320096718597",
            startPort = "Out",
            endQuest = "1787320088798284",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1787320088798276"] = {
            key = "1787320088798276",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1787320088798284"] = {
            key = "1787320088798284",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1787320088798292"] = {
            key = "1787320088798292",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1787320096718597"] = {
            key = "1787320096718597",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1582, y = 506},
            propsData = {GuideId = 160}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
