return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17738439016048011422",
      startPort = "StoryStart",
      endStory = "17738439016048011424",
      endPort = "In"
    },
    {
      startStory = "17738439016048011424",
      startPort = "Success",
      endStory = "17738439016048011423",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17738439016048011422"] = {
      isStoryNode = true,
      key = "17738439016048011422",
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
    ["17738439016048011423"] = {
      isStoryNode = true,
      key = "17738439016048011423",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2158, y = 354},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17738439016048011424"] = {
      isStoryNode = true,
      key = "17738439016048011424",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1532, y = 322},
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
            startQuest = "17738439016048011425",
            startPort = "QuestStart",
            endQuest = "17738439016048011428",
            endPort = "In"
          },
          {
            startQuest = "17738439016048011428",
            startPort = "Out",
            endQuest = "17738439016048011426",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17738439016048011425"] = {
            key = "17738439016048011425",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17738439016048011426"] = {
            key = "17738439016048011426",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2226, y = 392},
            propsData = {ModeType = 0}
          },
          ["17738439016048011427"] = {
            key = "17738439016048011427",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17738439016048011428"] = {
            key = "17738439016048011428",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1450, y = 330},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 60241601,
              FlowAssetPath = "",
              TalkType = "Black",
              BlendInTime = 1,
              BlendOutTime = 1,
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              ForceAutoPlay = true,
              ShowSkipButton = false,
              ShowAutoPlayButton = false,
              ShowReviewButton = false,
              ShowWikiButton = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
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
