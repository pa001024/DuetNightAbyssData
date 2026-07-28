return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1777290692888764",
      startPort = "StoryStart",
      endStory = "1777290695777839",
      endPort = "In"
    },
    {
      startStory = "1777290695777839",
      startPort = "Success",
      endStory = "1777290692889767",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1777290692888764"] = {
      isStoryNode = true,
      key = "1777290692888764",
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
    ["1777290692889767"] = {
      isStoryNode = true,
      key = "1777290692889767",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1444.375, y = 320.625},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1777290695777839"] = {
      isStoryNode = true,
      key = "1777290695777839",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1109, y = 292.5},
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
            startQuest = "17772907302081512",
            startPort = "Out",
            endQuest = "17772907302081513",
            endPort = "In"
          },
          {
            startQuest = "17772907302081513",
            startPort = "Out",
            endQuest = "17772907302081515",
            endPort = "In"
          },
          {
            startQuest = "17772907302081509",
            startPort = "Out",
            endQuest = "17772907302081516",
            endPort = "In"
          },
          {
            startQuest = "17772907302081515",
            startPort = "Out",
            endQuest = "17772907302081514",
            endPort = "In"
          },
          {
            startQuest = "17772907302081512",
            startPort = "Out",
            endQuest = "17772907302081517",
            endPort = "In"
          },
          {
            startQuest = "17772907302081509",
            startPort = "Out",
            endQuest = "17772907302081512",
            endPort = "In"
          },
          {
            startQuest = "17772907302081514",
            startPort = "Out",
            endQuest = "17772907650162341",
            endPort = "In"
          },
          {
            startQuest = "1777290695777840",
            startPort = "QuestStart",
            endQuest = "17772909352162930",
            endPort = "In"
          },
          {
            startQuest = "17772909352162930",
            startPort = "Out",
            endQuest = "1777290695777846",
            endPort = "Fail"
          },
          {
            startQuest = "1777290695777840",
            startPort = "QuestStart",
            endQuest = "17773423502601396352",
            endPort = "Input"
          },
          {
            startQuest = "1777290695777840",
            startPort = "QuestStart",
            endQuest = "17773452507655102520",
            endPort = "In"
          },
          {
            startQuest = "17773452507655102520",
            startPort = "Out",
            endQuest = "17772907302081509",
            endPort = "In"
          },
          {
            startQuest = "17773452507655102520",
            startPort = "Out",
            endQuest = "17772907302081511",
            endPort = "In"
          }
        },
        nodeData = {
          ["1777290695777840"] = {
            key = "1777290695777840",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 557.6785714285713, y = 289.98809523809524},
            propsData = {ModeType = 0}
          },
          ["1777290695777843"] = {
            key = "1777290695777843",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1858.5714285714284, y = 89.76190476190473},
            propsData = {ModeType = 0}
          },
          ["1777290695777846"] = {
            key = "1777290695777846",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1403.0036630036625, y = 132.87545787545787},
            propsData = {}
          },
          ["17772907302081509"] = {
            key = "17772907302081509",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1122.7943851467494, y = 286.32698601227},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 12061445,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17772907302081511"] = {
            key = "17772907302081511",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1119.787670497689, y = 449.91643551288576},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {132420053, 132420055}
            }
          },
          ["17772907302081512"] = {
            key = "17772907302081512",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 1405.311786478327, y = 290.75090994448533},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 1,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {132420055}
            }
          },
          ["17772907302081513"] = {
            key = "17772907302081513",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1685.754884443164, y = 292.206465531177},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 250017,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_12030304Xiaoan_132420053",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1203/12061501.12061501'",
              TalkType = "FixSimple",
              TalkStageName = "TalkStageNew_12030302",
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
          },
          ["17772907302081514"] = {
            key = "17772907302081514",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2244.0276543521, y = 285.6723992717217},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {132420053}
            }
          },
          ["17772907302081515"] = {
            key = "17772907302081515",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1965.3595957476011, y = 290.2169898324453},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 12061516,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17772907302081516"] = {
            key = "17772907302081516",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1403.9120291435936, y = 448.5698365068436},
            propsData = {
              NewDescription = "Description_120303_5",
              NewDetail = "Content__120303_5",
              SubTaskTargetIndex = 0
            }
          },
          ["17772907302081517"] = {
            key = "17772907302081517",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1683.530690176048, y = 448.2817916972474},
            propsData = {
              NewDescription = "Description_120303_6",
              NewDetail = "Content__120303_6",
              SubTaskTargetIndex = 0
            }
          },
          ["17772907650162341"] = {
            key = "17772907650162341",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2250.33356594386, y = 438.785768926636},
            propsData = {}
          },
          ["17772909352162930"] = {
            key = "17772909352162930",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1116.3991253844192, y = 130.8007232705376},
            propsData = {}
          },
          ["17773423502601396352"] = {
            key = "17773423502601396352",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 1124.2827077418863, y = -31.03425391376686},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 1,
              IsStandAlone = true
            }
          },
          ["17773452507655102520"] = {
            key = "17773452507655102520",
            type = "ChangeRoleNode",
            name = "切换主角",
            pos = {x = 838.584326305878, y = 290.9443650381549},
            propsData = {QuestRoleId = 16010103, IsPlayFX = false}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
