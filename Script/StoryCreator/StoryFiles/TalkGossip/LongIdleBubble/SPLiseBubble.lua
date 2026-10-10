return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17893688362651143789",
      startPort = "StoryStart",
      endStory = "17893688392141143863",
      endPort = "In"
    },
    {
      startStory = "17893688392141143863",
      startPort = "Success",
      endStory = "17893688362661143792",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17893688362651143789"] = {
      isStoryNode = true,
      key = "17893688362651143789",
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
    ["17893688362661143792"] = {
      isStoryNode = true,
      key = "17893688362661143792",
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
    ["17893688392141143863"] = {
      isStoryNode = true,
      key = "17893688392141143863",
      type = "StoryNode",
      name = "Aote放置",
      pos = {x = 1706, y = 286},
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
            startQuest = "17893688392141143868",
            startPort = "QuestStart",
            endQuest = "17893688392141143871",
            endPort = "In"
          },
          {
            startQuest = "17893688392141143871",
            startPort = "Out",
            endQuest = "17893688392141143869",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17893688392141143868"] = {
            key = "17893688392141143868",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17893688392141143869"] = {
            key = "17893688392141143869",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1431.1818181818182, y = 295.45454545454544},
            propsData = {ModeType = 0}
          },
          ["17893688392141143870"] = {
            key = "17893688392141143870",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17893688392141143871"] = {
            key = "17893688392141143871",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1105.6363636363635, y = 287.909090909091},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90400000,
              FlowAssetPath = "",
              TalkType = "Bubble",
              BubblePlayType = "Once",
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              ShowSkipButton = true,
              ShowReviewButton = true,
              bBubblePlayCDEnable = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
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
