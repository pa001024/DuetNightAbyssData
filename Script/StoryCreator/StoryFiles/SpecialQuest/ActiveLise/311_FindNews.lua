return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17901694716141144525",
      startPort = "StoryStart",
      endStory = "17901694755801144632",
      endPort = "In"
    },
    {
      startStory = "17901694755801144632",
      startPort = "Success",
      endStory = "17901694716141144528",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17901694716141144525"] = {
      isStoryNode = true,
      key = "17901694716141144525",
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
    ["17901694716141144528"] = {
      isStoryNode = true,
      key = "17901694716141144528",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1489.7391304347825, y = 308.0869565217391},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17901694755801144632"] = {
      isStoryNode = true,
      key = "17901694755801144632",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1158.695652173913, y = 300.95652173913044},
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
            startQuest = "1790173537328569",
            startPort = "Out",
            endQuest = "1790173537328567",
            endPort = "In"
          },
          {
            startQuest = "1790173537328569",
            startPort = "Out",
            endQuest = "1790173537328568",
            endPort = "In"
          },
          {
            startQuest = "1790173537328569",
            startPort = "Out",
            endQuest = "1790173537328566",
            endPort = "In"
          },
          {
            startQuest = "1790173537328567",
            startPort = "Out",
            endQuest = "1790173537328570",
            endPort = "Branch_1"
          },
          {
            startQuest = "1790173537328568",
            startPort = "Out",
            endQuest = "1790173537328570",
            endPort = "Branch_2"
          },
          {
            startQuest = "1790173537328566",
            startPort = "Out",
            endQuest = "1790173537328570",
            endPort = "Branch_3"
          },
          {
            startQuest = "1790173537328570",
            startPort = "Out",
            endQuest = "1790173537328572",
            endPort = "In"
          },
          {
            startQuest = "1790173537328571",
            startPort = "Out",
            endQuest = "1790173537327565",
            endPort = "In"
          },
          {
            startQuest = "1790173537328571",
            startPort = "Out",
            endQuest = "1790173537328569",
            endPort = "In"
          },
          {
            startQuest = "17901694755811144633",
            startPort = "QuestStart",
            endQuest = "17901735866061724",
            endPort = "In"
          },
          {
            startQuest = "17901735866061724",
            startPort = "Out",
            endQuest = "1790173537328571",
            endPort = "In"
          },
          {
            startQuest = "17901694755811144633",
            startPort = "QuestStart",
            endQuest = "17901735972911981",
            endPort = "In"
          },
          {
            startQuest = "1790173537328570",
            startPort = "Out",
            endQuest = "17901736163172472",
            endPort = "In"
          },
          {
            startQuest = "17901735972911981",
            startPort = "Out",
            endQuest = "17901694755811144639",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17901694755811144633"] = {
            key = "17901694755811144633",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 83.52941176470583, y = 631.764705882353},
            propsData = {ModeType = 0}
          },
          ["17901694755811144636"] = {
            key = "17901694755811144636",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1892.8625863300783, y = 801.4050964515361},
            propsData = {ModeType = 0}
          },
          ["17901694755811144639"] = {
            key = "17901694755811144639",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 658.9168416722597, y = 849.7518889778953},
            propsData = {}
          },
          ["1790173537327565"] = {
            key = "1790173537327565",
            type = "TalkNode",
            name = "广场找人开车",
            pos = {x = 936.4310438957174, y = 404.3471669455417},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 12070290,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1790173537328566"] = {
            key = "1790173537328566",
            type = "GoToNode",
            name = "前往开朗市民下游",
            pos = {x = 1281.8713165375539, y = 647.6247311254278},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351192090,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351192090"
            }
          },
          ["1790173537328567"] = {
            key = "1790173537328567",
            type = "TalkNode",
            name = "热情摊贩对话",
            pos = {x = 1285.3569352666527, y = 313.03944684449135},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 260018,
              GuideUIEnable = true,
              GuideType = "NpcBubble",
              GuidePointName = "Npc_Tanfan120703_351192088",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070294,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120703/12070303.12070303'",
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
          ["1790173537328568"] = {
            key = "1790173537328568",
            type = "TalkNode",
            name = "开朗市民对话",
            pos = {x = 1284.6064335944093, y = 479.8585103896419},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 260019,
              GuideUIEnable = true,
              GuideType = "NpcBubble",
              GuidePointName = "Npc_Kailang120703_351192089",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070306,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120703/12070304.12070304'",
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
          ["1790173537328569"] = {
            key = "1790173537328569",
            type = "BranchQuestStartNode",
            name = "子任务开始节点",
            pos = {x = 938.664119615482, y = 635.3164302729618},
            propsData = {
              AllQuestOptions = {
                {
                  IsNeedFinish = false,
                  BranchQuestName = "",
                  TargetBranchQuestKey = ""
                },
                {
                  IsNeedFinish = false,
                  BranchQuestName = "",
                  TargetBranchQuestKey = ""
                },
                {
                  IsNeedFinish = true,
                  BranchQuestName = "",
                  TargetBranchQuestKey = "1790173537328566"
                }
              },
              IsSetCountInfo = false,
              IsDifftation = false,
              AllDiffGuideOptions = {
                {
                  OptionElements = {
                    {
                      TargetIndicatorKey = "1790173537328567",
                      IsShowOptional = true
                    },
                    {
                      TargetIndicatorKey = "1790173537328568",
                      IsShowOptional = true
                    },
                    {
                      TargetIndicatorKey = "1790173537328566",
                      IsShowOptional = false
                    }
                  }
                }
              }
            }
          },
          ["1790173537328570"] = {
            key = "1790173537328570",
            type = "CheckBranchQuestFinishedNode",
            name = "子任务结束节点",
            pos = {x = 1586.6361843928098, y = 605.7609646859175},
            propsData = {
              InputBranchQuestNumber = 3,
              BranchQuestFinishOptions = {
                {IsNeedFinish = false},
                {IsNeedFinish = false},
                {IsNeedFinish = true}
              }
            }
          },
          ["1790173537328571"] = {
            key = "1790173537328571",
            type = "ChangeStaticCreatorNode",
            name = "生成热情摊贩开朗市民",
            pos = {x = 624.5121861381842, y = 646.0843380752149},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351192088, 351192089}
            }
          },
          ["1790173537328572"] = {
            key = "1790173537328572",
            type = "ChangeStaticCreatorNode",
            name = "销毁热情摊贩开朗市民",
            pos = {x = 1893.8536152430977, y = 484.8122738858331},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351192088, 351192089}
            }
          },
          ["17901735866061724"] = {
            key = "17901735866061724",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 358.23562545947806, y = 644.2701678453462},
            propsData = {QuestRoleId = 41030101, IsPlayFX = false}
          },
          ["17901735972911981"] = {
            key = "17901735972911981",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 376.887950806093, y = 836.1820166809903},
            propsData = {}
          },
          ["17901736163172472"] = {
            key = "17901736163172472",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 1892.043674995082, y = 625.0441616533957},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
