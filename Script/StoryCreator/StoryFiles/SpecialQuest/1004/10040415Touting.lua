return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177874808708623368493",
      startPort = "StoryStart",
      endStory = "177874808819623368528",
      endPort = "In"
    },
    {
      startStory = "177874808819623368528",
      startPort = "Success",
      endStory = "177874808708623368496",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177874808708623368493"] = {
      isStoryNode = true,
      key = "177874808708623368493",
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
    ["177874808708623368496"] = {
      isStoryNode = true,
      key = "177874808708623368496",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1790, y = 346},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874808819623368528"] = {
      isStoryNode = true,
      key = "177874808819623368528",
      type = "StoryNode",
      name = "偷听对话 ",
      pos = {x = 1396, y = 321.9999999999999},
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
        bIsPlayBlackScreenOnComplete = true,
        bIsPlayBlackScreenOnFail = true,
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
            startQuest = "177874808819623368536",
            startPort = "Out",
            endQuest = "177874808819623368537",
            endPort = "In"
          },
          {
            startQuest = "177874808819623368538",
            startPort = "Out",
            endQuest = "177874808819623368536",
            endPort = "In"
          },
          {
            startQuest = "177874808819623368533",
            startPort = "QuestStart",
            endQuest = "177874808819623368539",
            endPort = "In"
          },
          {
            startQuest = "177874808819623368537",
            startPort = "Out",
            endQuest = "177874808819623368540",
            endPort = "In"
          },
          {
            startQuest = "177874808819623368533",
            startPort = "QuestStart",
            endQuest = "177874808819623368541",
            endPort = "In"
          },
          {
            startQuest = "177874808819623368540",
            startPort = "Out",
            endQuest = "177874814392923368964",
            endPort = "In"
          },
          {
            startQuest = "177874808819623368533",
            startPort = "QuestStart",
            endQuest = "177874816026523369318",
            endPort = "In"
          },
          {
            startQuest = "177874816026523369318",
            startPort = "Out",
            endQuest = "177874808819623368535",
            endPort = "Fail"
          },
          {
            startQuest = "177874808819623368533",
            startPort = "QuestStart",
            endQuest = "17787551318271951603",
            endPort = "In"
          },
          {
            startQuest = "17787551318271951603",
            startPort = "Out",
            endQuest = "177874808819623368538",
            endPort = "In"
          }
        },
        nodeData = {
          ["177874808819623368533"] = {
            key = "177874808819623368533",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -262.7470355731226, y = 491.2411067193676},
            propsData = {ModeType = 0}
          },
          ["177874808819623368534"] = {
            key = "177874808819623368534",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2034.9648337595909, y = 292.4565217391307},
            propsData = {ModeType = 0}
          },
          ["177874808819623368535"] = {
            key = "177874808819623368535",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 752.5513254412842, y = 716.8434799373016},
            propsData = {}
          },
          ["177874808819623368536"] = {
            key = "177874808819623368536",
            type = "TalkNode",
            name = "偷听",
            pos = {x = 821.2495960505154, y = 311.83968651709904},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10046801.10046801'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 2,
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
              HideMechanismsFX = false,
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
          ["177874808819623368537"] = {
            key = "177874808819623368537",
            type = "TalkNode",
            name = "偷听后",
            pos = {x = 1180.1552360682797, y = 299.9053989488774},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10046901.10046901'",
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
              HideMechanismsFX = false,
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
          ["177874808819623368538"] = {
            key = "177874808819623368538",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 437.86745032461147, y = 281.9473735982687},
            propsData = {
              StaticCreatorId = 272640004,
              UnitId = 10098,
              bGuideUIEnable = true,
              GuidePointName = "BP_Hide_272640004",
              LongPressTime = 3,
              MontageName = "Interactive_Crouch_Montage",
              bFocusEnable = false,
              SequencePath = ""
            }
          },
          ["177874808819623368539"] = {
            key = "177874808819623368539",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 358.37105114565065, y = 926.12306501548},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272640075}
            }
          },
          ["177874808819623368540"] = {
            key = "177874808819623368540",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1474.5552616719667, y = 301.42105263157896},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272640075}
            }
          },
          ["177874808819623368541"] = {
            key = "177874808819623368541",
            type = "ChangeRoleNode",
            name = "切换为主角",
            pos = {x = 447.60511813421044, y = 489.160227134332},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177874814392923368964"] = {
            key = "177874814392923368964",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 1773.4313725490197, y = 283.1510577915377},
            propsData = {}
          },
          ["177874816026523369318"] = {
            key = "177874816026523369318",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 435.7843137254901, y = 706.6804695562437},
            propsData = {}
          },
          ["17787551318271951603"] = {
            key = "17787551318271951603",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 92.12145748987832, y = 310.65587044534414},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_HideStart",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
