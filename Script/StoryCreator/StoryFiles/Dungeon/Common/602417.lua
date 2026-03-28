return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17738439016048011500",
      startPort = "StoryStart",
      endStory = "17738439016048011502",
      endPort = "In"
    },
    {
      startStory = "17738439016048011502",
      startPort = "Success",
      endStory = "17738439016048011501",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17738439016048011500"] = {
      isStoryNode = true,
      key = "17738439016048011500",
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
    ["17738439016048011501"] = {
      isStoryNode = true,
      key = "17738439016048011501",
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
    ["17738439016048011502"] = {
      isStoryNode = true,
      key = "17738439016048011502",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1532, y = 320},
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
            startQuest = "17738439016048011503",
            startPort = "QuestStart",
            endQuest = "17738439016048011506",
            endPort = "In"
          },
          {
            startQuest = "17738439016048011506",
            startPort = "Out",
            endQuest = "17738439016048011504",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17738439016048011503"] = {
            key = "17738439016048011503",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17738439016048011504"] = {
            key = "17738439016048011504",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2226, y = 392},
            propsData = {ModeType = 0}
          },
          ["17738439016048011505"] = {
            key = "17738439016048011505",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17738439016048011506"] = {
            key = "17738439016048011506",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1450, y = 328},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 60241701,
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
