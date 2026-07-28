return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178151001525824131749",
      startPort = "StoryStart",
      endStory = "178151001599824131778",
      endPort = "In"
    },
    {
      startStory = "178151001599824131778",
      startPort = "Success",
      endStory = "178151001525824131752",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178151001525824131749"] = {
      isStoryNode = true,
      key = "178151001525824131749",
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
    ["178151001525824131752"] = {
      isStoryNode = true,
      key = "178151001525824131752",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2022, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178151001599824131778"] = {
      isStoryNode = true,
      key = "178151001599824131778",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1452, y = 314},
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
            startQuest = "178151001599824131786",
            startPort = "Out",
            endQuest = "178151001599824131784",
            endPort = "Success"
          },
          {
            startQuest = "178151003850624131994",
            startPort = "Out",
            endQuest = "178151001599824131786",
            endPort = "In"
          },
          {
            startQuest = "178151001599824131783",
            startPort = "QuestStart",
            endQuest = "17828067381496388988",
            endPort = "In"
          },
          {
            startQuest = "17828067381496388988",
            startPort = "Out",
            endQuest = "178151003850624131994",
            endPort = "In"
          }
        },
        nodeData = {
          ["178151001599824131783"] = {
            key = "178151001599824131783",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1099.6206896551723, y = 394.82758620689657},
            propsData = {ModeType = 0}
          },
          ["178151001599824131784"] = {
            key = "178151001599824131784",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["178151001599824131785"] = {
            key = "178151001599824131785",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178151001599824131786"] = {
            key = "178151001599824131786",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178151003850624131994"] = {
            key = "178151003850624131994",
            type = "TalkNode",
            name = "达芙涅回忆过场",
            pos = {x = 1786.443864595422, y = 359.22136549027545},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = false,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1101/11015101.11015101'",
              TalkType = "FixSimple",
              TalkStageName = "",
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
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 110022,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 110005,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17828067381496388988"] = {
            key = "17828067381496388988",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1443.0082254179379, y = 370.68364762172797},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
