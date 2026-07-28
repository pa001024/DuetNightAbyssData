return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17758149970381652830",
      startPort = "StoryStart",
      endStory = "17758149970381652832",
      endPort = "In"
    },
    {
      startStory = "17758149970381652832",
      startPort = "Success",
      endStory = "17758149970381652831",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17758149970381652830"] = {
      isStoryNode = true,
      key = "17758149970381652830",
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
    ["17758149970381652831"] = {
      isStoryNode = true,
      key = "17758149970381652831",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1624.5454545454545, y = 313.6363636363636},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17758149970381652832"] = {
      isStoryNode = true,
      key = "17758149970381652832",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1168.8500000000001, y = 292.894671169903},
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
            startQuest = "17758149970381652833",
            startPort = "QuestStart",
            endQuest = "17758149970381652836",
            endPort = "In"
          },
          {
            startQuest = "17758149970381652836",
            startPort = "Out",
            endQuest = "17758149970381652834",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17758149970381652833"] = {
            key = "17758149970381652833",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 654.0909090909091, y = 332.72727272727275},
            propsData = {ModeType = 0}
          },
          ["17758149970381652834"] = {
            key = "17758149970381652834",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1661.3636363636365, y = 370.90909090909093},
            propsData = {ModeType = 0}
          },
          ["17758149970381652835"] = {
            key = "17758149970381652835",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1833.181818181818, y = 712.2727272727273},
            propsData = {}
          },
          ["17758149970381652836"] = {
            key = "17758149970381652836",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1066.6679841897237, y = 356.0262917232629},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 6103101,
              FlowAssetPath = "",
              TalkType = "RougeLike",
              OptionType = "rougeLike",
              RougeLikeOptions = {},
              OverrideFailBlend = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
