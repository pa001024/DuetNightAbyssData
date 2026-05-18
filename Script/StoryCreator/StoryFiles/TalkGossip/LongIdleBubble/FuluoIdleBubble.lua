return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17758091775301",
      startPort = "StoryStart",
      endStory = "1775809184454141",
      endPort = "In"
    },
    {
      startStory = "1775809184454141",
      startPort = "Success",
      endStory = "17758091775315",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17758091775301"] = {
      isStoryNode = true,
      key = "17758091775301",
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
    ["17758091775315"] = {
      isStoryNode = true,
      key = "17758091775315",
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
    ["1775809184454141"] = {
      isStoryNode = true,
      key = "1775809184454141",
      type = "StoryNode",
      name = "芙罗拉放置",
      pos = {x = 1332, y = 290},
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
            startQuest = "1775809184454142",
            startPort = "QuestStart",
            endQuest = "1775809221455712",
            endPort = "In"
          },
          {
            startQuest = "1775809221455712",
            startPort = "Out",
            endQuest = "1775809184454150",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1775809184454142"] = {
            key = "1775809184454142",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1775809184454150"] = {
            key = "1775809184454150",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1775809184454158"] = {
            key = "1775809184454158",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1775809221455712"] = {
            key = "1775809221455712",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1240, y = 314},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90280000,
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
