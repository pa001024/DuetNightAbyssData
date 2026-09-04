return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17846205001821852208",
      startPort = "StoryStart",
      endStory = "17846205001821852210",
      endPort = "In"
    },
    {
      startStory = "17846205001821852210",
      startPort = "Success",
      endStory = "17846205001821852209",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17846205001821852208"] = {
      isStoryNode = true,
      key = "17846205001821852208",
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
    ["17846205001821852209"] = {
      isStoryNode = true,
      key = "17846205001821852209",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1400.4545454545455, y = 295.3636363636364},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17846205001821852210"] = {
      isStoryNode = true,
      key = "17846205001821852210",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1100.090909090909, y = 268.9090909090909},
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
            startQuest = "17846205001821852215",
            startPort = "Out",
            endQuest = "17846205001821852214",
            endPort = "In"
          },
          {
            startQuest = "17846205001821852211",
            startPort = "QuestStart",
            endQuest = "17846205001821852215",
            endPort = "In"
          },
          {
            startQuest = "17846205001821852215",
            startPort = "Out",
            endQuest = "178832934452916214442",
            endPort = "In"
          },
          {
            startQuest = "17846205001821852214",
            startPort = "Out",
            endQuest = "178832934928816214607",
            endPort = "In"
          },
          {
            startQuest = "178832934928816214607",
            startPort = "Out",
            endQuest = "17846205001821852212",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17846205001821852211"] = {
            key = "17846205001821852211",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17846205001821852212"] = {
            key = "17846205001821852212",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1932.421052631579, y = 287.7894736842105},
            propsData = {ModeType = 0}
          },
          ["17846205001821852213"] = {
            key = "17846205001821852213",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17846205001821852214"] = {
            key = "17846205001821852214",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1340.624332570557, y = 285.15217391304344},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80270201.80270201'",
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
              HideNpcs = true,
              HideMonsters = true,
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = true,
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
          ["17846205001821852215"] = {
            key = "17846205001821852215",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1079.3756674294432, y = 298.84782608695656},
            propsData = {
              ModeType = 1,
              Id = 107501,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178832934452916214442"] = {
            key = "178832934452916214442",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1364.5263157894738, y = 479.0526315789474},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 1,
              SoundType = 0,
              SoundPath = "event:/bgm/1_6/0185_scene_aerkanuo_town",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["178832934928816214607"] = {
            key = "178832934928816214607",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1632.9473684210527, y = 289.4736842105263},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 1,
              SoundType = 0
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
