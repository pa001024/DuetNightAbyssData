return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17834098706189800433",
      startPort = "StoryStart",
      endStory = "17834100011149800702",
      endPort = "In"
    },
    {
      startStory = "17834100011149800702",
      startPort = "Success",
      endStory = "17834098706189800436",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17834098706189800433"] = {
      isStoryNode = true,
      key = "17834098706189800433",
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
    ["17834098706189800436"] = {
      isStoryNode = true,
      key = "17834098706189800436",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1386, y = 314},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17834100011149800702"] = {
      isStoryNode = true,
      key = "17834100011149800702",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1066, y = 354},
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
            startQuest = "17834100011149800703",
            startPort = "QuestStart",
            endQuest = "17834100130109801202",
            endPort = "In"
          },
          {
            startQuest = "17834100130109801202",
            startPort = "Out",
            endQuest = "17834100011149800706",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17834100011149800703"] = {
            key = "17834100011149800703",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17834100011149800706"] = {
            key = "17834100011149800706",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1644, y = 348},
            propsData = {ModeType = 0}
          },
          ["17834100011149800709"] = {
            key = "17834100011149800709",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17834100130109801202"] = {
            key = "17834100130109801202",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1308, y = 370},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51301701,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = true,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = true,
              ShowSkipButton = true,
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
              SwitchToMaster = "EXPlayer",
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
