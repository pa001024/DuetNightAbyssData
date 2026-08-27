return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17834097528808711073",
      startPort = "StoryStart",
      endStory = "17834097589218711302",
      endPort = "In"
    },
    {
      startStory = "17834097589218711302",
      startPort = "Success",
      endStory = "17834097528808711076",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17834097528808711073"] = {
      isStoryNode = true,
      key = "17834097528808711073",
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
    ["17834097528808711076"] = {
      isStoryNode = true,
      key = "17834097528808711076",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1642, y = 352},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17834097589218711302"] = {
      isStoryNode = true,
      key = "17834097589218711302",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1172, y = 366},
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
            startQuest = "17834097589218711303",
            startPort = "QuestStart",
            endQuest = "17834097756028711773",
            endPort = "In"
          },
          {
            startQuest = "17834097756028711773",
            startPort = "Out",
            endQuest = "17834097589218711306",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17834097589218711303"] = {
            key = "17834097589218711303",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17834097589218711306"] = {
            key = "17834097589218711306",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1800, y = 314},
            propsData = {ModeType = 0}
          },
          ["17834097589218711309"] = {
            key = "17834097589218711309",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17834097756028711773"] = {
            key = "17834097756028711773",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1260, y = 370},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51301601,
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
