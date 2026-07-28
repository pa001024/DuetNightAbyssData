return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17816812897881",
      startPort = "StoryStart",
      endStory = "1781681329081241",
      endPort = "In"
    },
    {
      startStory = "1781681329081241",
      startPort = "Success",
      endStory = "17816812897895",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17816812897881"] = {
      isStoryNode = true,
      key = "17816812897881",
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
    ["17816812897895"] = {
      isStoryNode = true,
      key = "17816812897895",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1858.57144567269, y = 282.8571431685467},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1781681329081241"] = {
      isStoryNode = true,
      key = "1781681329081241",
      type = "StoryNode",
      name = "伊薇看板娘EX02前",
      pos = {x = 1339.3333340868537, y = 273.5555548334318},
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
            startQuest = "1781681329081242",
            startPort = "QuestStart",
            endQuest = "17816813898911282",
            endPort = "In"
          },
          {
            startQuest = "17816813898911282",
            startPort = "Out",
            endQuest = "17816814128911659",
            endPort = "In"
          },
          {
            startQuest = "17816814128911659",
            startPort = "Out",
            endQuest = "17816814682752677",
            endPort = "In"
          },
          {
            startQuest = "17816814682752677",
            startPort = "Out",
            endQuest = "1781681329082250",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781681329081242"] = {
            key = "1781681329081242",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781681329082250"] = {
            key = "1781681329082250",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781681329082258"] = {
            key = "1781681329082258",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17816813898911282"] = {
            key = "17816813898911282",
            type = "SetNpcPoseNode",
            name = "设置Npc姿态",
            pos = {x = 1124.6486517695112, y = 310.8648635273523},
            propsData = {
              NpcInfos = {
                {NpcId = 82102, NpcPose = "Idle"}
              }
            }
          },
          ["17816814128911659"] = {
            key = "17816814128911659",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1471.0796434714853, y = 298.64865176951116},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 90290001,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 1,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = false,
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
              TalkActors = {
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 82102,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17816814682752677"] = {
            key = "17816814682752677",
            type = "SetNpcPoseNode",
            name = "设置Npc姿态",
            pos = {x = 1872.4309844849793, y = 320.2702698522976},
            propsData = {
              NpcInfos = {
                {NpcId = 82102, NpcPose = "Seating"}
              }
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
