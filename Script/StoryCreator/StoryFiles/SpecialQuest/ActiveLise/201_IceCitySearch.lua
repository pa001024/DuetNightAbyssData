return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17870344074841122653",
      startPort = "StoryStart",
      endStory = "17870344100761122760",
      endPort = "In"
    },
    {
      startStory = "17870344100761122760",
      startPort = "Success",
      endStory = "17870344074841122656",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17870344074841122653"] = {
      isStoryNode = true,
      key = "17870344074841122653",
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
    ["17870344074841122656"] = {
      isStoryNode = true,
      key = "17870344074841122656",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1740.2857142857142, y = 302.57142857142856},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17870344100761122760"] = {
      isStoryNode = true,
      key = "17870344100761122760",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1258.5714285714287, y = 289.42857142857144},
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
            startQuest = "17870344100761122761",
            startPort = "QuestStart",
            endQuest = "17872138371284502320",
            endPort = "In"
          },
          {
            startQuest = "17870344100761122761",
            startPort = "QuestStart",
            endQuest = "17872137790304501970",
            endPort = "In"
          },
          {
            startQuest = "17872137790304501970",
            startPort = "Out",
            endQuest = "17872148985344504332",
            endPort = "In"
          },
          {
            startQuest = "17872148985344504332",
            startPort = "Out",
            endQuest = "17872149335034504809",
            endPort = "In"
          },
          {
            startQuest = "17872149335034504809",
            startPort = "Out",
            endQuest = "17872151228024505401",
            endPort = "In"
          },
          {
            startQuest = "17872151228024505401",
            startPort = "Out",
            endQuest = "17872152265874506230",
            endPort = "In"
          },
          {
            startQuest = "17872152476114506652",
            startPort = "Out",
            endQuest = "17872153023084507659",
            endPort = "In"
          },
          {
            startQuest = "17872153023084507659",
            startPort = "Out",
            endQuest = "17872153414534508302",
            endPort = "In"
          },
          {
            startQuest = "17872152265874506230",
            startPort = "Out",
            endQuest = "17872154087664509574",
            endPort = "In"
          },
          {
            startQuest = "17872154087664509574",
            startPort = "Out",
            endQuest = "17872152476114506652",
            endPort = "In"
          },
          {
            startQuest = "17872152265874506230",
            startPort = "Out",
            endQuest = "17884906744551424",
            endPort = "In"
          },
          {
            startQuest = "17872138371284502320",
            startPort = "Out",
            endQuest = "17870344100761122767",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17870344100761122761"] = {
            key = "17870344100761122761",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17870344100761122764"] = {
            key = "17870344100761122764",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3458.8622247317903, y = 436.57820440429134},
            propsData = {ModeType = 0}
          },
          ["17870344100761122767"] = {
            key = "17870344100761122767",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1397.391304347826, y = 514.695652173913},
            propsData = {}
          },
          ["17872137790304501970"] = {
            key = "17872137790304501970",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1094.5172924901187, y = 304.21986166007906},
            propsData = {QuestRoleId = 41030101, IsPlayFX = false}
          },
          ["17872138371284502320"] = {
            key = "17872138371284502320",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1095.6991106719368, y = 502.5834980237154},
            propsData = {}
          },
          ["17872148985344504332"] = {
            key = "17872148985344504332",
            type = "ChangeStaticCreatorNode",
            name = "生成敲门交互",
            pos = {x = 1381.5710897797856, y = 301.36362224731783},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351192083}
            }
          },
          ["17872149335034504809"] = {
            key = "17872149335034504809",
            type = "PickUpNode",
            name = "交互敲门",
            pos = {x = 1684.1797854319598, y = 287.0157961603613},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 120706,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "Target_Knock_120706",
              IsUseCount = false
            }
          },
          ["17872151228024505401"] = {
            key = "17872151228024505401",
            type = "TalkNode",
            name = "敲门对话",
            pos = {x = 1986.8477696216833, y = 284.5256775832862},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070075,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120702/12070201.12070201'",
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
          ["17872152265874506230"] = {
            key = "17872152265874506230",
            type = "ChangeStaticCreatorNode",
            name = "销毁敲门交互",
            pos = {x = 2280.563184641446, y = 296.2055194805193},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351192083}
            }
          },
          ["17872152476114506652"] = {
            key = "17872152476114506652",
            type = "GoToNode",
            name = "前往冰湖城广场附近",
            pos = {x = 2862.3023150762283, y = 281.56125070581584},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351192085,
              GuideType = "N",
              GuidePointName = "Npc_Rodes120702_351192084"
            }
          },
          ["17872153023084507659"] = {
            key = "17872153023084507659",
            type = "TalkNode",
            name = "罗德斯奶奶",
            pos = {x = 3148.8297007340493, y = 281.55560417843},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070081,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120702/12070202.12070202'",
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
          ["17872153414534508302"] = {
            key = "17872153414534508302",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 3454.4790513834, y = 280.1270327498586},
            propsData = {}
          },
          ["17872154087664509574"] = {
            key = "17872154087664509574",
            type = "ChangeStaticCreatorNode",
            name = "生成npc罗德斯奶奶",
            pos = {x = 2570.054363326358, y = 300.73815447127487},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351192084}
            }
          },
          ["17884906744551424"] = {
            key = "17884906744551424",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务栏-广场找人",
            pos = {x = 2568.668153102936, y = 123.88041620215506},
            propsData = {
              NewDescription = "Description_120702_1_2",
              NewDetail = "Content_120702_1_2",
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
