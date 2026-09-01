return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17846234110196278719",
      startPort = "StoryStart",
      endStory = "17846234110196278721",
      endPort = "In"
    },
    {
      startStory = "17846234110196278721",
      startPort = "Success",
      endStory = "17846234110196278720",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17846234110196278719"] = {
      isStoryNode = true,
      key = "17846234110196278719",
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
    ["17846234110196278720"] = {
      isStoryNode = true,
      key = "17846234110196278720",
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
    ["17846234110196278721"] = {
      isStoryNode = true,
      key = "17846234110196278721",
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
            startQuest = "17846234110196278726",
            startPort = "Out",
            endQuest = "17846234110196278725",
            endPort = "In"
          },
          {
            startQuest = "17846234110196278722",
            startPort = "QuestStart",
            endQuest = "17846234110196278726",
            endPort = "In"
          },
          {
            startQuest = "17846234110196278726",
            startPort = "Out",
            endQuest = "178816678216310623600",
            endPort = "In"
          },
          {
            startQuest = "17846234110196278725",
            startPort = "Out",
            endQuest = "178816678912510623859",
            endPort = "In"
          },
          {
            startQuest = "178816678912510623859",
            startPort = "Out",
            endQuest = "17846234110196278723",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17846234110196278722"] = {
            key = "17846234110196278722",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17846234110196278723"] = {
            key = "17846234110196278723",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2011.7272727272727, y = 299.27272727272725},
            propsData = {ModeType = 0}
          },
          ["17846234110196278724"] = {
            key = "17846234110196278724",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17846234110196278725"] = {
            key = "17846234110196278725",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1340.624332570557, y = 285.15217391304344},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80280301.80280301'",
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
          ["17846234110196278726"] = {
            key = "17846234110196278726",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1079.3756674294432, y = 298.84782608695656},
            propsData = {
              ModeType = 1,
              Id = 101104,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178816678216310623600"] = {
            key = "178816678216310623600",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1337.4242424242423, y = 480},
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
          ["178816678912510623859"] = {
            key = "178816678912510623859",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1649.712918660287, y = 270.1515151515152},
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
