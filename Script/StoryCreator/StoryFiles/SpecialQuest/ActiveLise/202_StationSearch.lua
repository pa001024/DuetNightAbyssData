return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17870344780212242183",
      startPort = "StoryStart",
      endStory = "17870344833492242481",
      endPort = "In"
    },
    {
      startStory = "17870344833492242481",
      startPort = "Success",
      endStory = "17870344780212242186",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17870344780212242183"] = {
      isStoryNode = true,
      key = "17870344780212242183",
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
    ["17870344780212242186"] = {
      isStoryNode = true,
      key = "17870344780212242186",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1650, y = 310},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17870344833492242481"] = {
      isStoryNode = true,
      key = "17870344833492242481",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1211.5454545454545, y = 290.18181818181824},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_120702_2",
        QuestDeatil = "Content_120702_2",
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
            startQuest = "17870344833492242482",
            startPort = "QuestStart",
            endQuest = "17872166383861125705",
            endPort = "In"
          },
          {
            startQuest = "17870344833492242482",
            startPort = "QuestStart",
            endQuest = "17872166242581125446",
            endPort = "In"
          },
          {
            startQuest = "17872166242581125446",
            startPort = "Out",
            endQuest = "17872168478541128085",
            endPort = "In"
          },
          {
            startQuest = "17872171166811131349",
            startPort = "Out",
            endQuest = "17872172274671132229",
            endPort = "In"
          },
          {
            startQuest = "17872171166811131349",
            startPort = "Out",
            endQuest = "17872172327411132393",
            endPort = "In"
          },
          {
            startQuest = "17872171166811131349",
            startPort = "Out",
            endQuest = "17872172330441132402",
            endPort = "In"
          },
          {
            startQuest = "17872172327411132393",
            startPort = "Out",
            endQuest = "17872171199771131406",
            endPort = "Branch_1"
          },
          {
            startQuest = "17872172330441132402",
            startPort = "Out",
            endQuest = "17872171199771131406",
            endPort = "Branch_2"
          },
          {
            startQuest = "17872172274671132229",
            startPort = "Out",
            endQuest = "17872171199771131406",
            endPort = "Branch_3"
          },
          {
            startQuest = "17872171199771131406",
            startPort = "Out",
            endQuest = "17872180360631136304",
            endPort = "In"
          },
          {
            startQuest = "17872180360631136304",
            startPort = "Out",
            endQuest = "17872180642791136856",
            endPort = "In"
          },
          {
            startQuest = "17872180642791136856",
            startPort = "Out",
            endQuest = "17872166472821125834",
            endPort = "In"
          },
          {
            startQuest = "17872168478541128085",
            startPort = "Out",
            endQuest = "17872171166811131349",
            endPort = "In"
          },
          {
            startQuest = "17872171199771131406",
            startPort = "Out",
            endQuest = "1790084039015716",
            endPort = "In"
          },
          {
            startQuest = "17872166383861125705",
            startPort = "Out",
            endQuest = "17870344833492242488",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17870344833492242482"] = {
            key = "17870344833492242482",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1055.7142857142858, y = 298.8888888888889},
            propsData = {ModeType = 0}
          },
          ["17870344833492242485"] = {
            key = "17870344833492242485",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3388.5714285714284, y = 445.7142857142857},
            propsData = {ModeType = 0}
          },
          ["17870344833492242488"] = {
            key = "17870344833492242488",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1654.2857142857142, y = 561.7460317460317},
            propsData = {}
          },
          ["17872166242581125446"] = {
            key = "17872166242581125446",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1360.8095238095239, y = 299.65079365079373},
            propsData = {QuestRoleId = 41030101, IsPlayFX = false}
          },
          ["17872166383861125705"] = {
            key = "17872166383861125705",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1357.0595238095239, y = 547.3293650793653},
            propsData = {}
          },
          ["17872166472821125834"] = {
            key = "17872166472821125834",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 3387.9523809523807, y = 289.3333333333334},
            propsData = {}
          },
          ["17872168478541128085"] = {
            key = "17872168478541128085",
            type = "ChangeStaticCreatorNode",
            name = "工人/克拉拉/卫兵/马蒂斯",
            pos = {x = 1653.031746031746, y = 297.5873015873018},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                352480704,
                352480705,
                352480708,
                352480709
              }
            }
          },
          ["17872171166811131349"] = {
            key = "17872171166811131349",
            type = "BranchQuestStartNode",
            name = "车站对话子任务",
            pos = {x = 1935.0952380952383, y = 300.7619047619049},
            propsData = {
              AllQuestOptions = {
                {
                  IsNeedFinish = true,
                  BranchQuestName = "",
                  TargetBranchQuestKey = "17872172327411132393"
                },
                {
                  IsNeedFinish = true,
                  BranchQuestName = "",
                  TargetBranchQuestKey = "17872172330441132402"
                },
                {
                  IsNeedFinish = true,
                  BranchQuestName = "",
                  TargetBranchQuestKey = "17872172274671132229"
                }
              },
              IsSetCountInfo = true,
              IsDifftation = false,
              AllDiffGuideOptions = {
                {
                  OptionElements = {
                    {
                      TargetIndicatorKey = "17872172327411132393",
                      IsShowOptional = false
                    }
                  }
                },
                {
                  OptionElements = {
                    {
                      TargetIndicatorKey = "17872172330441132402",
                      IsShowOptional = false
                    }
                  }
                },
                {
                  OptionElements = {
                    {
                      TargetIndicatorKey = "17872172274671132229",
                      IsShowOptional = false
                    }
                  }
                }
              }
            }
          },
          ["17872171199771131406"] = {
            key = "17872171199771131406",
            type = "CheckBranchQuestFinishedNode",
            name = "子任务结束节点",
            pos = {x = 2539.3809523809523, y = 277.90476190476204},
            propsData = {
              InputBranchQuestNumber = 3,
              BranchQuestFinishOptions = {
                {IsNeedFinish = true},
                {IsNeedFinish = true},
                {IsNeedFinish = true}
              }
            }
          },
          ["17872172274671132229"] = {
            key = "17872172274671132229",
            type = "TalkNode",
            name = "不耐烦卫兵",
            pos = {x = 2217.9523809523807, y = 435.04761904761915},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 260006,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_ImpatientMan120702_352480708",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070120,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120702/12070203.12070203'",
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
          ["17872172327411132393"] = {
            key = "17872172327411132393",
            type = "TalkNode",
            name = "走神工人",
            pos = {x = 2223.6666666666665, y = 136.4761904761905},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 260007,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Zoushen120702_352480704",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070123,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120702/12070204.12070204'",
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
          ["17872172330441132402"] = {
            key = "17872172330441132402",
            type = "TalkNode",
            name = "克拉拉",
            pos = {x = 2222.238095238095, y = 285.04761904761915},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 260008,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Kelala120702_352480705",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070127,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120702/12070205.12070205'",
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
          ["17872180360631136304"] = {
            key = "17872180360631136304",
            type = "GoToNode",
            name = "前往警觉卫兵附近",
            pos = {x = 2820.5497835497827, y = 286.6060606060606},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 352480710,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_352480710"
            }
          },
          ["17872180642791136856"] = {
            key = "17872180642791136856",
            type = "TalkNode",
            name = "马蒂斯触发",
            pos = {x = 3099.3809523809523, y = 290.7619047619047},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070134,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120702/12070206.12070206'",
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
          ["1790084039015716"] = {
            key = "1790084039015716",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 2821.874893435635, y = 101.62988513483197},
            propsData = {
              NewDescription = "Description_120702_2_2",
              NewDetail = "Content_120702_2_2",
              SubTaskTargetIndex = 0
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
