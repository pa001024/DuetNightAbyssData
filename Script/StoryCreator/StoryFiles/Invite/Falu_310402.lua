return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17846211321905171668",
      startPort = "StoryStart",
      endStory = "17846211321905171670",
      endPort = "In"
    },
    {
      startStory = "17846211321905171670",
      startPort = "Success",
      endStory = "17846211321905171669",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17846211321905171668"] = {
      isStoryNode = true,
      key = "17846211321905171668",
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
    ["17846211321905171669"] = {
      isStoryNode = true,
      key = "17846211321905171669",
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
    ["17846211321905171670"] = {
      isStoryNode = true,
      key = "17846211321905171670",
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
            startQuest = "17846211321905171675",
            startPort = "Out",
            endQuest = "17846211321905171674",
            endPort = "In"
          },
          {
            startQuest = "17846211321905171671",
            startPort = "QuestStart",
            endQuest = "17846211321905171675",
            endPort = "In"
          },
          {
            startQuest = "17846211321905171675",
            startPort = "Out",
            endQuest = "17878158817825610447",
            endPort = "In"
          },
          {
            startQuest = "17846211321905171674",
            startPort = "Out",
            endQuest = "17878158874655610668",
            endPort = "In"
          },
          {
            startQuest = "17878158817825610447",
            startPort = "Out",
            endQuest = "17881667279959505938",
            endPort = "In"
          },
          {
            startQuest = "17878158874655610668",
            startPort = "Out",
            endQuest = "17881667337449506140",
            endPort = "In"
          },
          {
            startQuest = "17881667337449506140",
            startPort = "Out",
            endQuest = "17846211321905171672",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17846211321905171671"] = {
            key = "17846211321905171671",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17846211321905171672"] = {
            key = "17846211321905171672",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2201.0289855072465, y = 285.11594202898556},
            propsData = {ModeType = 0}
          },
          ["17846211321905171673"] = {
            key = "17846211321905171673",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17846211321905171674"] = {
            key = "17846211321905171674",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1340.624332570557, y = 285.15217391304344},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80280201.80280201'",
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
          ["17846211321905171675"] = {
            key = "17846211321905171675",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1079.3756674294432, y = 298.84782608695656},
            propsData = {
              ModeType = 1,
              Id = 106001,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17878158817825610447"] = {
            key = "17878158817825610447",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1347.875, y = 479.79166666666674},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 1,
              SoundType = 2,
              SoundPath = "event:/snapshot/story/mute_broadcast",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["17878158874655610668"] = {
            key = "17878158874655610668",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1631.2083333333333, y = 288.125},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 1,
              SoundType = 2
            }
          },
          ["17881667279959505938"] = {
            key = "17881667279959505938",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1648, y = 504},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 1,
              SoundType = 0,
              SoundPath = "event:/bgm/1_6/0180_cs_intro_loop_ver",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["17881667337449506140"] = {
            key = "17881667337449506140",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1920.883581235698, y = 281.9513729977116},
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
