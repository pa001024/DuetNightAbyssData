return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178150988829323080847",
      startPort = "StoryStart",
      endStory = "178150988889423080870",
      endPort = "In"
    },
    {
      startStory = "178150988889423080870",
      startPort = "Success",
      endStory = "178150988829323080850",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178150988829323080847"] = {
      isStoryNode = true,
      key = "178150988829323080847",
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
    ["178150988829323080850"] = {
      isStoryNode = true,
      key = "178150988829323080850",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1744, y = 256},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178150988889423080870"] = {
      isStoryNode = true,
      key = "178150988889423080870",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1354, y = 274},
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
            startQuest = "178150988889423080885",
            startPort = "Out",
            endQuest = "178150988889423080876",
            endPort = "Success"
          },
          {
            startQuest = "178150988889423080875",
            startPort = "QuestStart",
            endQuest = "178150994902523081773",
            endPort = "In"
          },
          {
            startQuest = "178150994902523081773",
            startPort = "Out",
            endQuest = "178150988889423080885",
            endPort = "In"
          }
        },
        nodeData = {
          ["178150988889423080875"] = {
            key = "178150988889423080875",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178150988889423080876"] = {
            key = "178150988889423080876",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["178150988889423080877"] = {
            key = "178150988889423080877",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178150988889423080885"] = {
            key = "178150988889423080885",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178150994902523081773"] = {
            key = "178150994902523081773",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1781.594110900841, y = 462.7786874786319},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC018/SQ_OBT0102_SC018",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = true,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
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
