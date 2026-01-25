return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17611197578001",
      startPort = "StoryStart",
      endStory = "1761119808063105",
      endPort = "In"
    },
    {
      startStory = "1761119808063105",
      startPort = "Success",
      endStory = "17611197578005",
      endPort = "StoryEnd"
    },
    {
      startStory = "1761119808063105",
      startPort = "Fail",
      endStory = "17611197578005",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17611197578001"] = {
      isStoryNode = true,
      key = "17611197578001",
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
    ["17611197578005"] = {
      isStoryNode = true,
      key = "17611197578005",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1845.7142857142858, y = 312.85714285714283},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1761119808063105"] = {
      isStoryNode = true,
      key = "1761119808063105",
      type = "StoryNode",
      name = "皓京无由生玩法",
      pos = {x = 1233.1428571428573, y = 294.57142857142856},
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
            startQuest = "1761119808063106",
            startPort = "QuestStart",
            endQuest = "1761119953721538",
            endPort = "In"
          },
          {
            startQuest = "1761119953721538",
            startPort = "Branch_1",
            endQuest = "1761119966917807",
            endPort = "In"
          },
          {
            startQuest = "1761119966917807",
            startPort = "Out",
            endQuest = "1761119808064113",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1761119808063106"] = {
            key = "1761119808063106",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1761119808064113"] = {
            key = "1761119808064113",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1839.3582887700534, y = 279.06417112299465},
            propsData = {ModeType = 0}
          },
          ["1761119808064120"] = {
            key = "1761119808064120",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1761119953721538"] = {
            key = "1761119953721538",
            type = "BranchTriggerNode",
            name = "触发分支节点",
            pos = {x = 1107.5454545454545, y = 276.99999999999994},
            propsData = {
              Branches = {721012}
            }
          },
          ["1761119966917807"] = {
            key = "1761119966917807",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1406.181818181818, y = 258.6363636363636},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 72101201,
              FlowAssetPath = "",
              TalkType = "PanFixSimple",
              TalkStageName = "Stage_721012",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 830001,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              OptionType = "normal",
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
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
