return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742456538625",
      startPort = "StoryStart",
      endStory = "1781144742456538627",
      endPort = "In"
    },
    {
      startStory = "1781144742456538627",
      startPort = "Success",
      endStory = "1781144742456538626",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742456538625"] = {
      isStoryNode = true,
      key = "1781144742456538625",
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
    ["1781144742456538626"] = {
      isStoryNode = true,
      key = "1781144742456538626",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1976, y = 342},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1781144742456538627"] = {
      isStoryNode = true,
      key = "1781144742456538627",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1266, y = 268},
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
            startQuest = "1781144742456538630",
            startPort = "QuestStart",
            endQuest = "1781144742456538633",
            endPort = "In"
          },
          {
            startQuest = "1781144742456538636",
            startPort = "Out",
            endQuest = "1781144742456538631",
            endPort = "Success"
          },
          {
            startQuest = "1781144742456538633",
            startPort = "Out",
            endQuest = "178116794051644207203",
            endPort = "In"
          },
          {
            startQuest = "178116794051644207203",
            startPort = "Out",
            endQuest = "178116807442745234576",
            endPort = "In"
          },
          {
            startQuest = "178116807442745234576",
            startPort = "Out",
            endQuest = "1781144742456538636",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742456538630"] = {
            key = "1781144742456538630",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742456538631"] = {
            key = "1781144742456538631",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2252.821283979178, y = 566.5720069404281},
            propsData = {ModeType = 0}
          },
          ["1781144742456538632"] = {
            key = "1781144742456538632",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742456538633"] = {
            key = "1781144742456538633",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1207.6839468053622, y = 303.4843628467721},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742456538636"] = {
            key = "1781144742456538636",
            type = "PlayOrStopBGMNode",
            name = "播放或暂停或关闭声音",
            pos = {x = 1921.3684210526317, y = 561.7894736842105},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178116794051644207203"] = {
            key = "178116794051644207203",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1357.3080013023791, y = 530.8762436963335},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_3/0142_story_zhiliu_memory.0142_story_zhiliu_memory'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {104504}
            }
          },
          ["178116807442745234576"] = {
            key = "178116807442745234576",
            type = "TalkNode",
            name = "2DCG",
            pos = {x = 1649.032139233414, y = 556.7383126618507},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1202/12049234.12049234'",
              TalkType = "FixSimple",
              TalkStageName = "East02_12020510",
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
