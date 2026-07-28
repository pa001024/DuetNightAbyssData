return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1732692284093444265",
      startPort = "Success",
      endStory = "1732692284093444264",
      endPort = "StoryEnd"
    },
    {
      startStory = "1732692284093444263",
      startPort = "StoryStart",
      endStory = "1732692284093444265",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["1732692284093444263"] = {
      isStoryNode = true,
      key = "1732692284093444263",
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
    ["1732692284093444264"] = {
      isStoryNode = true,
      key = "1732692284093444264",
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
    ["1732692284093444265"] = {
      isStoryNode = true,
      key = "1732692284093444265",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1096.0023923444974, y = 290.27272727272725},
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
            startQuest = "1732692284093444266",
            startPort = "QuestStart",
            endQuest = "1732692284093444269",
            endPort = "In"
          },
          {
            startQuest = "1732692284093444269",
            startPort = "Out",
            endQuest = "1732692284093444267",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1732692284093444266"] = {
            key = "1732692284093444266",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1732692284093444267"] = {
            key = "1732692284093444267",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2244.4, y = 300},
            propsData = {ModeType = 0}
          },
          ["1732692284093444268"] = {
            key = "1732692284093444268",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1732692284093444269"] = {
            key = "1732692284093444269",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1513.809923538793, y = 296.4121212121212},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = false,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 741147330,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
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
                  TalkActorType = "Npc",
                  TalkActorId = 74114733,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
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
