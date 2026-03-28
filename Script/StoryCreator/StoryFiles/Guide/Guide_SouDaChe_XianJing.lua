return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17740130076801",
      startPort = "StoryStart",
      endStory = "177401301314271",
      endPort = "In"
    },
    {
      startStory = "177401301314271",
      startPort = "Success",
      endStory = "17740130076815",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17740130076801"] = {
      isStoryNode = true,
      key = "17740130076801",
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
    ["17740130076815"] = {
      isStoryNode = true,
      key = "17740130076815",
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
    ["177401301314271"] = {
      isStoryNode = true,
      key = "177401301314271",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1520, y = 316},
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
            startQuest = "177401301314272",
            startPort = "QuestStart",
            endQuest = "1774013027229428",
            endPort = "In"
          },
          {
            startQuest = "1774013027229428",
            startPort = "Out",
            endQuest = "177401301314280",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177401301314272"] = {
            key = "177401301314272",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177401301314280"] = {
            key = "177401301314280",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177401301314288"] = {
            key = "177401301314288",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1774013027229428"] = {
            key = "1774013027229428",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1502, y = 408},
            propsData = {GuideId = 137}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
