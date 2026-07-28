return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17773824086203316137",
      startPort = "StoryStart",
      endStory = "17773824086203316139",
      endPort = "In"
    },
    {
      startStory = "17773824086203316139",
      startPort = "Success",
      endStory = "17773824086203316138",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17773824086203316137"] = {
      isStoryNode = true,
      key = "17773824086203316137",
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
    ["17773824086203316138"] = {
      isStoryNode = true,
      key = "17773824086203316138",
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
    ["17773824086203316139"] = {
      isStoryNode = true,
      key = "17773824086203316139",
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
        IsBacktrack = false,
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17773824086203316140",
            startPort = "QuestStart",
            endQuest = "17773824086203316143",
            endPort = "In"
          },
          {
            startQuest = "17773824086203316143",
            startPort = "Out",
            endQuest = "17773824086203316141",
            endPort = "Success"
          },
          {
            startQuest = "17773824086203316143",
            startPort = "Fail",
            endQuest = "17773824086203316142",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17773824086203316140"] = {
            key = "17773824086203316140",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 811.2173913043479, y = 305.5652173913044},
            propsData = {ModeType = 0}
          },
          ["17773824086203316141"] = {
            key = "17773824086203316141",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1646.4347826086957, y = 309.3913043478261},
            propsData = {ModeType = 0}
          },
          ["17773824086203316142"] = {
            key = "17773824086203316142",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1650.6086956521742, y = 411.86956521739137},
            propsData = {}
          },
          ["17773824086203316143"] = {
            key = "17773824086203316143",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1185.2857142857142, y = 315.11111111111103},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51015001,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 0,
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
                  TalkActorId = 701285,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 701286,
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
