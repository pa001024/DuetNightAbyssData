return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1789039835322346",
      startPort = "StoryStart",
      endStory = "1789039835955367",
      endPort = "In"
    },
    {
      startStory = "1789039835955367",
      startPort = "Success",
      endStory = "1789039835322349",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1789039835322346"] = {
      isStoryNode = true,
      key = "1789039835322346",
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
    ["1789039835322349"] = {
      isStoryNode = true,
      key = "1789039835322349",
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
    ["1789039835955367"] = {
      isStoryNode = true,
      key = "1789039835955367",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1752, y = 342},
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
            startQuest = "1789039835955372",
            startPort = "QuestStart",
            endQuest = "1789039835955375",
            endPort = "In"
          },
          {
            startQuest = "1789039835955376",
            startPort = "Out",
            endQuest = "1789039835955373",
            endPort = "Success"
          },
          {
            startQuest = "1789039835955375",
            startPort = "Out",
            endQuest = "1789039835955377",
            endPort = "In"
          },
          {
            startQuest = "1789039835955377",
            startPort = "Out",
            endQuest = "1789039835955376",
            endPort = "In"
          }
        },
        nodeData = {
          ["1789039835955372"] = {
            key = "1789039835955372",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1789039835955373"] = {
            key = "1789039835955373",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1789039835955374"] = {
            key = "1789039835955374",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1789039835955375"] = {
            key = "1789039835955375",
            type = "SetNpcPoseNode",
            name = "设置Npc姿态",
            pos = {x = 1178, y = 348},
            propsData = {
              NpcInfos = {
                {NpcId = 84103, NpcPose = "Idle"}
              }
            }
          },
          ["1789039835955376"] = {
            key = "1789039835955376",
            type = "SetNpcPoseNode",
            name = "设置Npc姿态",
            pos = {x = 2290, y = 370},
            propsData = {
              NpcInfos = {
                {NpcId = 84103, NpcPose = "Seating"}
              }
            }
          },
          ["1789039835955377"] = {
            key = "1789039835955377",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1696, y = 392},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 90400001,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 1,
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
              ShowSkipButton = false,
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
                  TalkActorId = 84103,
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
