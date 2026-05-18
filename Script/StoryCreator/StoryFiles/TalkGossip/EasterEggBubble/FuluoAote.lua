return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17758094650471",
      startPort = "StoryStart",
      endStory = "1775810240796318",
      endPort = "In"
    },
    {
      startStory = "1775810240796318",
      startPort = "Success",
      endStory = "17758094650485",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17758094650471"] = {
      isStoryNode = true,
      key = "17758094650471",
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
    ["17758094650485"] = {
      isStoryNode = true,
      key = "17758094650485",
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
    ["1775810240796318"] = {
      isStoryNode = true,
      key = "1775810240796318",
      type = "StoryNode",
      name = "芙罗拉奥特赛德互动",
      pos = {x = 1442, y = 318},
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
            startQuest = "1775810240796319",
            startPort = "QuestStart",
            endQuest = "17758102908301109",
            endPort = "In"
          },
          {
            startQuest = "17758102908301109",
            startPort = "Out",
            endQuest = "1775810240796327",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1775810240796319"] = {
            key = "1775810240796319",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1775810240796327"] = {
            key = "1775810240796327",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1775810240796335"] = {
            key = "1775810240796335",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17758102908301109"] = {
            key = "17758102908301109",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1348, y = 370},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90280701,
              FlowAssetPath = "",
              TalkType = "Bubble",
              BubblePlayType = "Once",
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
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
