return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17846194824001",
      startPort = "StoryStart",
      endStory = "1784619561530402",
      endPort = "In"
    },
    {
      startStory = "1784619561530402",
      startPort = "Success",
      endStory = "17846194824005",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17846194824001"] = {
      isStoryNode = true,
      key = "17846194824001",
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
    ["17846194824005"] = {
      isStoryNode = true,
      key = "17846194824005",
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
    ["1784619561530402"] = {
      isStoryNode = true,
      key = "1784619561530402",
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
            startQuest = "17846196038371187",
            startPort = "Out",
            endQuest = "17846196038371186",
            endPort = "In"
          },
          {
            startQuest = "1784619561530403",
            startPort = "QuestStart",
            endQuest = "17846196038371187",
            endPort = "In"
          },
          {
            startQuest = "17846196038371187",
            startPort = "Out",
            endQuest = "178832927078615095531",
            endPort = "In"
          },
          {
            startQuest = "17846196038371186",
            startPort = "Out",
            endQuest = "178832931209515095928",
            endPort = "In"
          },
          {
            startQuest = "178832931209515095928",
            startPort = "Out",
            endQuest = "1784619561531411",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1784619561530403"] = {
            key = "1784619561530403",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1784619561531411"] = {
            key = "1784619561531411",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1871.2727272727273, y = 281.54545454545456},
            propsData = {ModeType = 0}
          },
          ["1784619561531419"] = {
            key = "1784619561531419",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17846196038371186"] = {
            key = "17846196038371186",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1340.624332570557, y = 285.15217391304344},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80270101.80270101'",
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
          ["17846196038371187"] = {
            key = "17846196038371187",
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
          ["178832927078615095531"] = {
            key = "178832927078615095531",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1326, y = 482.5454545454545},
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
          ["178832931209515095928"] = {
            key = "178832931209515095928",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1608.328947368421, y = 272.28520164046483},
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
