return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178703531162315681686",
      startPort = "StoryStart",
      endStory = "178703531794815681941",
      endPort = "In"
    },
    {
      startStory = "178703531794815681941",
      startPort = "Success",
      endStory = "178703531162315681689",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178703531162315681686"] = {
      isStoryNode = true,
      key = "178703531162315681686",
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
    ["178703531162315681689"] = {
      isStoryNode = true,
      key = "178703531162315681689",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1554.0869565217392, y = 292},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178703531794815681941"] = {
      isStoryNode = true,
      key = "178703531794815681941",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1174.8320158102765, y = 275.58695652173924},
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
            startQuest = "178703531794815681946",
            startPort = "QuestStart",
            endQuest = "178739047920724905827",
            endPort = "In"
          },
          {
            startQuest = "178739056270024906512",
            startPort = "Out",
            endQuest = "178739059489024906927",
            endPort = "In"
          },
          {
            startQuest = "178739059489024906927",
            startPort = "Out",
            endQuest = "178739061344924907242",
            endPort = "In"
          },
          {
            startQuest = "178739061344924907242",
            startPort = "Out",
            endQuest = "178739064002324907569",
            endPort = "In"
          },
          {
            startQuest = "178703531794815681946",
            startPort = "QuestStart",
            endQuest = "178739065981524908023",
            endPort = "In"
          },
          {
            startQuest = "178739047920724905827",
            startPort = "Out",
            endQuest = "1788516012602765",
            endPort = "In"
          },
          {
            startQuest = "1788516012602765",
            startPort = "Out",
            endQuest = "178739056270024906512",
            endPort = "In"
          },
          {
            startQuest = "178739065981524908023",
            startPort = "Out",
            endQuest = "178703531794815681948",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["178703531794815681946"] = {
            key = "178703531794815681946",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178703531794815681947"] = {
            key = "178703531794815681947",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2554.409937888199, y = 449.19254658385097},
            propsData = {ModeType = 0}
          },
          ["178703531794815681948"] = {
            key = "178703531794815681948",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1368.8819875776396, y = 535.8385093167702},
            propsData = {}
          },
          ["178739047920724905827"] = {
            key = "178739047920724905827",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1086.2608695652175, y = 298.6086956521739},
            propsData = {QuestRoleId = 41030101, IsPlayFX = false}
          },
          ["178739056270024906512"] = {
            key = "178739056270024906512",
            type = "TalkNode",
            name = "无缝对话看城墙",
            pos = {x = 1666.6096837944663, y = 282.73913043478257},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070699,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120706/12070603.12070603'",
              TalkType = "FixSimpleNew",
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
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = false,
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
          ["178739059489024906927"] = {
            key = "178739059489024906927",
            type = "GoToNode",
            name = "前往城墙上",
            pos = {x = 1965.1422924901185, y = 290.3478260869565},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351192107,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351192107"
            }
          },
          ["178739061344924907242"] = {
            key = "178739061344924907242",
            type = "TalkNode",
            name = "告别过往",
            pos = {x = 2261.1749011857705, y = 284.15217391304344},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070706,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120706/12070604.12070604'",
              TalkType = "FixSimpleNew",
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
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = false,
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
          ["178739064002324907569"] = {
            key = "178739064002324907569",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2553.403162055336, y = 287.7391304347827},
            propsData = {}
          },
          ["178739065981524908023"] = {
            key = "178739065981524908023",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1091.2292490118573, y = 527.7391304347827},
            propsData = {}
          },
          ["1788516012602765"] = {
            key = "1788516012602765",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1377.5346320346323, y = 281.78013214855304},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
