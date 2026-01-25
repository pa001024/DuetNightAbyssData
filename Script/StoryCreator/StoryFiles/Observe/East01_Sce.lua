return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17621594112288576",
      startPort = "StoryStart",
      endStory = "17621594165108737",
      endPort = "In"
    },
    {
      startStory = "17621594165108737",
      startPort = "Success",
      endStory = "17621594112288579",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17621594112288576"] = {
      isStoryNode = true,
      key = "17621594112288576",
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
    ["17621594112288579"] = {
      isStoryNode = true,
      key = "17621594112288579",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1789.375, y = 337.5},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17621594165108737"] = {
      isStoryNode = true,
      key = "17621594165108737",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1288, y = 302},
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
        bIsShowOnComplete = true,
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
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17621594165108738",
            startPort = "QuestStart",
            endQuest = "17621594429279789",
            endPort = "In"
          },
          {
            startQuest = "17621594429279789",
            startPort = "Branch_1",
            endQuest = "176215948245810500",
            endPort = "In"
          },
          {
            startQuest = "176215948245810500",
            startPort = "Out",
            endQuest = "17621594165108741",
            endPort = "Success"
          },
          {
            startQuest = "17621594429279789",
            startPort = "Branch_2",
            endQuest = "1762160259399694925",
            endPort = "In"
          },
          {
            startQuest = "1762160259399694925",
            startPort = "Out",
            endQuest = "17621594165108741",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17621594165108738"] = {
            key = "17621594165108738",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17621594165108741"] = {
            key = "17621594165108741",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2098.75, y = 306.75},
            propsData = {ModeType = 0}
          },
          ["17621594165108744"] = {
            key = "17621594165108744",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17621594429279789"] = {
            key = "17621594429279789",
            type = "BranchTriggerNode",
            name = "触发分支节点",
            pos = {x = 1160, y = 292},
            propsData = {
              Branches = {700184, 700185}
            }
          },
          ["176215948245810500"] = {
            key = "176215948245810500",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1592, y = 286},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              FirstDialogueId = 51128301,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 1,
              BlendOutTime = 1,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = true,
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
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              TalkActors = {},
              OptionType = "normal",
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1762160259399694925"] = {
            key = "1762160259399694925",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1622.1480908152737, y = 478.919246646027},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              FirstDialogueId = 51128401,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 1,
              BlendOutTime = 1,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = true,
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
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              TalkActors = {},
              OptionType = "normal",
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
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
