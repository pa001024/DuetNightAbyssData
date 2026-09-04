return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17846208838342958374",
      startPort = "StoryStart",
      endStory = "17846208838342958376",
      endPort = "In"
    },
    {
      startStory = "17846208838342958376",
      startPort = "Success",
      endStory = "17846208838342958375",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17846208838342958374"] = {
      isStoryNode = true,
      key = "17846208838342958374",
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
    ["17846208838342958375"] = {
      isStoryNode = true,
      key = "17846208838342958375",
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
    ["17846208838342958376"] = {
      isStoryNode = true,
      key = "17846208838342958376",
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
            startQuest = "17846208838342958381",
            startPort = "Out",
            endQuest = "17846208838342958380",
            endPort = "In"
          },
          {
            startQuest = "17846208838342958377",
            startPort = "QuestStart",
            endQuest = "17846208838342958381",
            endPort = "In"
          },
          {
            startQuest = "17846208838342958381",
            startPort = "Out",
            endQuest = "178833150146318451476",
            endPort = "In"
          },
          {
            startQuest = "17846208838342958380",
            startPort = "Out",
            endQuest = "178833150778618451689",
            endPort = "In"
          },
          {
            startQuest = "178833150778618451689",
            startPort = "Out",
            endQuest = "17846208838342958378",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17846208838342958377"] = {
            key = "17846208838342958377",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17846208838342958378"] = {
            key = "17846208838342958378",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1967.6, y = 300.8},
            propsData = {ModeType = 0}
          },
          ["17846208838342958379"] = {
            key = "17846208838342958379",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17846208838342958380"] = {
            key = "17846208838342958380",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1340.624332570557, y = 285.15217391304344},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80270301.80270301'",
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
          ["17846208838342958381"] = {
            key = "17846208838342958381",
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
          ["178833150146318451476"] = {
            key = "178833150146318451476",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1332.6526315789474, y = 480.37894736842105},
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
          ["178833150778618451689"] = {
            key = "178833150778618451689",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1654.3167048054918, y = 272.7995995423341},
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
