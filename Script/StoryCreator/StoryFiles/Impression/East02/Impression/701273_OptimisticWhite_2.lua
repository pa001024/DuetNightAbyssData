return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17756375473337615529",
      startPort = "StoryStart",
      endStory = "17756375473337615531",
      endPort = "In"
    },
    {
      startStory = "17756375473337615531",
      startPort = "Success",
      endStory = "17756375473337615530",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17756375473337615529"] = {
      isStoryNode = true,
      key = "17756375473337615529",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1014, y = 322.25},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17756375473337615530"] = {
      isStoryNode = true,
      key = "17756375473337615530",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1795, y = 315},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17756375473337615531"] = {
      isStoryNode = true,
      key = "17756375473337615531",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1389.6428571428573, y = 322.5123847926268},
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
            startQuest = "17756375473337615532",
            startPort = "QuestStart",
            endQuest = "17756375473337615535",
            endPort = "In"
          },
          {
            startQuest = "17756375473337615535",
            startPort = "Out",
            endQuest = "17756375473337615533",
            endPort = "Success"
          },
          {
            startQuest = "17756375473337615535",
            startPort = "Fail",
            endQuest = "17756375473337615534",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17756375473337615532"] = {
            key = "17756375473337615532",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 806, y = 316},
            propsData = {ModeType = 0}
          },
          ["17756375473337615533"] = {
            key = "17756375473337615533",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1636, y = 252},
            propsData = {ModeType = 0}
          },
          ["17756375473337615534"] = {
            key = "17756375473337615534",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1648.0000000000002, y = 421.00000000000006},
            propsData = {}
          },
          ["17756375473337615535"] = {
            key = "17756375473337615535",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1185.2857142857142, y = 313.99999999999994},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51177026,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
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
