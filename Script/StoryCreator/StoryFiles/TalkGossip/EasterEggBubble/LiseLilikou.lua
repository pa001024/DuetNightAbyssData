return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "175325342380448338230",
      startPort = "Success",
      endStory = "175325342380448338229",
      endPort = "StoryEnd"
    },
    {
      startStory = "175325342380448338228",
      startPort = "StoryStart",
      endStory = "175325342380448338230",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["175325342380448338228"] = {
      isStoryNode = true,
      key = "175325342380448338228",
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
    ["175325342380448338229"] = {
      isStoryNode = true,
      key = "175325342380448338229",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1492, y = 306},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["175325342380448338230"] = {
      isStoryNode = true,
      key = "175325342380448338230",
      type = "StoryNode",
      name = "黎瑟莉莉蔻互动",
      pos = {x = 1126, y = 308},
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
            startQuest = "175325342380448338231",
            startPort = "QuestStart",
            endQuest = "175325342380448338234",
            endPort = "In"
          },
          {
            startQuest = "175325342380448338234",
            startPort = "Out",
            endQuest = "175325342380448338232",
            endPort = "Success"
          }
        },
        nodeData = {
          ["175325342380448338231"] = {
            key = "175325342380448338231",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["175325342380448338232"] = {
            key = "175325342380448338232",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1646, y = 314},
            propsData = {ModeType = 0}
          },
          ["175325342380448338233"] = {
            key = "175325342380448338233",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1610, y = 554},
            propsData = {}
          },
          ["175325342380448338234"] = {
            key = "175325342380448338234",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1230, y = 292},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90211001,
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
