return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17849756643741",
      startPort = "StoryStart",
      endStory = "178497567361857",
      endPort = "In"
    },
    {
      startStory = "178497567361857",
      startPort = "Success",
      endStory = "17849756643745",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17849756643741"] = {
      isStoryNode = true,
      key = "17849756643741",
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
    ["17849756643745"] = {
      isStoryNode = true,
      key = "17849756643745",
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
    ["178497567361857"] = {
      isStoryNode = true,
      key = "178497567361857",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1604, y = 320},
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
            startQuest = "178497567361858",
            startPort = "QuestStart",
            endQuest = "1784975686985459",
            endPort = "In"
          },
          {
            startQuest = "1784975703378796",
            startPort = "Out",
            endQuest = "178497567361866",
            endPort = "Success"
          },
          {
            startQuest = "1784975686985459",
            startPort = "Out",
            endQuest = "17849757158011072",
            endPort = "In"
          },
          {
            startQuest = "17849757158011072",
            startPort = "Out",
            endQuest = "1784975703378796",
            endPort = "In"
          }
        },
        nodeData = {
          ["178497567361858"] = {
            key = "178497567361858",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178497567361866"] = {
            key = "178497567361866",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178497567361974"] = {
            key = "178497567361974",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1784975686985459"] = {
            key = "1784975686985459",
            type = "SetNpcPoseNode",
            name = "设置Npc姿态",
            pos = {x = 1178, y = 348},
            propsData = {
              NpcInfos = {
                {NpcId = 83104, NpcPose = "Idle"}
              }
            }
          },
          ["1784975703378796"] = {
            key = "1784975703378796",
            type = "SetNpcPoseNode",
            name = "设置Npc姿态",
            pos = {x = 2290, y = 370},
            propsData = {
              NpcInfos = {
                {NpcId = 83104, NpcPose = "Seating"}
              }
            }
          },
          ["17849757158011072"] = {
            key = "17849757158011072",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1696, y = 392},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 90300001,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = false,
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
              TalkActors = {
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 83104,
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
