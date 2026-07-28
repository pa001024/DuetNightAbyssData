return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17758081807071",
      startPort = "StoryStart",
      endStory = "1775808188804120",
      endPort = "In"
    },
    {
      startStory = "1775808188804120",
      startPort = "Success",
      endStory = "17758081807075",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17758081807071"] = {
      isStoryNode = true,
      key = "17758081807071",
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
    ["17758081807075"] = {
      isStoryNode = true,
      key = "17758081807075",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2142, y = 308},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1775808188804120"] = {
      isStoryNode = true,
      key = "1775808188804120",
      type = "StoryNode",
      name = "芙罗拉放置",
      pos = {x = 1376, y = 272},
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
            startQuest = "1775808188804121",
            startPort = "QuestStart",
            endQuest = "1775808227604654",
            endPort = "In"
          },
          {
            startQuest = "17758082652051088",
            startPort = "Out",
            endQuest = "1775808188805129",
            endPort = "Success"
          },
          {
            startQuest = "1775808227604654",
            startPort = "Out",
            endQuest = "17758082781051382",
            endPort = "In"
          },
          {
            startQuest = "17758082781051382",
            startPort = "Out",
            endQuest = "17758082652051088",
            endPort = "In"
          }
        },
        nodeData = {
          ["1775808188804121"] = {
            key = "1775808188804121",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1775808188805129"] = {
            key = "1775808188805129",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1775808188805137"] = {
            key = "1775808188805137",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1775808227604654"] = {
            key = "1775808227604654",
            type = "SetNpcPoseNode",
            name = "设置Npc姿态",
            pos = {x = 1114, y = 310},
            propsData = {
              NpcInfos = {
                {NpcId = 81102, NpcPose = "Idle"}
              }
            }
          },
          ["17758082652051088"] = {
            key = "17758082652051088",
            type = "SetNpcPoseNode",
            name = "设置Npc姿态",
            pos = {x = 2124, y = 350},
            propsData = {
              NpcInfos = {
                {NpcId = 81102, NpcPose = "Seating"}
              }
            }
          },
          ["17758082781051382"] = {
            key = "17758082781051382",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1564, y = 340},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 90280001,
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
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
              ShowSkipButton = false,
              ShowAutoPlayButton = false,
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
                  TalkActorId = 81102,
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
