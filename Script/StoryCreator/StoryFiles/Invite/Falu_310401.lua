return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17846210882704065124",
      startPort = "StoryStart",
      endStory = "17846210882704065126",
      endPort = "In"
    },
    {
      startStory = "17846210882704065126",
      startPort = "Success",
      endStory = "17846210882704065125",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17846210882704065124"] = {
      isStoryNode = true,
      key = "17846210882704065124",
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
    ["17846210882704065125"] = {
      isStoryNode = true,
      key = "17846210882704065125",
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
    ["17846210882704065126"] = {
      isStoryNode = true,
      key = "17846210882704065126",
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
            startQuest = "17846210882704065127",
            startPort = "QuestStart",
            endQuest = "17846210882704065131",
            endPort = "In"
          },
          {
            startQuest = "17846210882704065131",
            startPort = "Out",
            endQuest = "17846210882704065130",
            endPort = "In"
          },
          {
            startQuest = "17846210882704065131",
            startPort = "Out",
            endQuest = "17878145713164493439",
            endPort = "In"
          },
          {
            startQuest = "17846210882704065130",
            startPort = "Out",
            endQuest = "17878145998014493749",
            endPort = "In"
          },
          {
            startQuest = "17878145713164493439",
            startPort = "Out",
            endQuest = "17881666516268388121",
            endPort = "In"
          },
          {
            startQuest = "17878145998014493749",
            startPort = "Out",
            endQuest = "17881666674478388440",
            endPort = "In"
          },
          {
            startQuest = "17881666674478388440",
            startPort = "Out",
            endQuest = "17846210882704065128",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17846210882704065127"] = {
            key = "17846210882704065127",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17846210882704065128"] = {
            key = "17846210882704065128",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2359.779220779221, y = 306.02597402597394},
            propsData = {ModeType = 0}
          },
          ["17846210882704065129"] = {
            key = "17846210882704065129",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17846210882704065130"] = {
            key = "17846210882704065130",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1386.3386182848428, y = 268.00931677018633},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80280101.80280101'",
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
          ["17846210882704065131"] = {
            key = "17846210882704065131",
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
          ["17878145713164493439"] = {
            key = "17878145713164493439",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1370.9749373433585, y = 461.40319548872185},
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
          ["17878145998014493749"] = {
            key = "17878145998014493749",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1736.689223057644, y = 280.54605263157896},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 1,
              SoundType = 2
            }
          },
          ["17881666516268388121"] = {
            key = "17881666516268388121",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1661.142156862745, y = 455.97303921568624},
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
          ["17881666674478388440"] = {
            key = "17881666674478388440",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2073.8391265597147, y = 306.4275846702316},
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
