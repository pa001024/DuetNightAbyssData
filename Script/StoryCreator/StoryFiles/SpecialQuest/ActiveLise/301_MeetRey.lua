return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17870346470715601248",
      startPort = "Success",
      endStory = "17870346414015600939",
      endPort = "StoryEnd"
    },
    {
      startStory = "17870346414015600936",
      startPort = "StoryStart",
      endStory = "17870346470715601248",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17870346414015600936"] = {
      isStoryNode = true,
      key = "17870346414015600936",
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
    ["17870346414015600939"] = {
      isStoryNode = true,
      key = "17870346414015600939",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1572, y = 304},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17870346470715601248"] = {
      isStoryNode = true,
      key = "17870346470715601248",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1183.1676249447146, y = 295.69482529854037},
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
            startQuest = "17870346470715601249",
            startPort = "QuestStart",
            endQuest = "17872803243871300",
            endPort = "In"
          },
          {
            startQuest = "17872805096063939",
            startPort = "Out",
            endQuest = "17872805278704264",
            endPort = "In"
          },
          {
            startQuest = "17872805278704264",
            startPort = "Out",
            endQuest = "17872806806565432",
            endPort = "In"
          },
          {
            startQuest = "17872804487082878",
            startPort = "Out",
            endQuest = "17872809175099324",
            endPort = "In"
          },
          {
            startQuest = "17872809175099324",
            startPort = "Out",
            endQuest = "17872804864293538",
            endPort = "In"
          },
          {
            startQuest = "17870346470715601249",
            startPort = "QuestStart",
            endQuest = "1787280063110825",
            endPort = "In"
          },
          {
            startQuest = "17872804864293538",
            startPort = "Out",
            endQuest = "17872805096063939",
            endPort = "In"
          },
          {
            startQuest = "1787280063110825",
            startPort = "Out",
            endQuest = "17872807277626584",
            endPort = "In"
          },
          {
            startQuest = "17872806806565432",
            startPort = "Out",
            endQuest = "17872988038522298540",
            endPort = "In"
          },
          {
            startQuest = "17872988038522298540",
            startPort = "Out",
            endQuest = "17884039500141794",
            endPort = "In"
          },
          {
            startQuest = "17872807277626584",
            startPort = "Out",
            endQuest = "17872804487082878",
            endPort = "In"
          },
          {
            startQuest = "17872806806565432",
            startPort = "Out",
            endQuest = "17885105731182282850",
            endPort = "In"
          },
          {
            startQuest = "17884039500141794",
            startPort = "Out",
            endQuest = "17873873966686694",
            endPort = "In"
          },
          {
            startQuest = "17872803243871300",
            startPort = "Out",
            endQuest = "17870346470715601255",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17870346470715601249"] = {
            key = "17870346470715601249",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1612.8461538461538, y = 275.025641025641},
            propsData = {ModeType = 0}
          },
          ["17870346470715601252"] = {
            key = "17870346470715601252",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2743.437967448265, y = 921.6796928090979},
            propsData = {ModeType = 0}
          },
          ["17870346470715601255"] = {
            key = "17870346470715601255",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2225.982881534941, y = 86.88262043067553},
            propsData = {}
          },
          ["1787280063110825"] = {
            key = "1787280063110825",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1922.432274247492, y = 279.38433667781493},
            propsData = {QuestRoleId = 41030101, IsPlayFX = false}
          },
          ["17872803243871300"] = {
            key = "17872803243871300",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1949.818693891921, y = 75.76419937804374},
            propsData = {}
          },
          ["17872804487082878"] = {
            key = "17872804487082878",
            type = "TalkNode",
            name = "卡米拉蕾伊对话",
            pos = {x = 2514.414715719063, y = 278.7383676582761},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070243,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120703/12070301.12070301'",
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
          ["17872804864293538"] = {
            key = "17872804864293538",
            type = "ChangeStaticCreatorNode",
            name = "生成入座交互和桌边蕾伊",
            pos = {x = 1948.9537933462418, y = 465.8357096755266},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351220217, 351220220}
            }
          },
          ["17872805096063939"] = {
            key = "17872805096063939",
            type = "PickUpNode",
            name = "交互桌边",
            pos = {x = 2224.42574664085, y = 488.88291380625463},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 120707,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "Target_Seat_120707",
              IsUseCount = false
            }
          },
          ["17872805278704264"] = {
            key = "17872805278704264",
            type = "TalkNode",
            name = "桌边蕾伊对话",
            pos = {x = 2541.367775626358, y = 489.29595728451557},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070263,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120703/12070302.12070302'",
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
          ["17872806806565432"] = {
            key = "17872806806565432",
            type = "ChangeStaticCreatorNode",
            name = "销毁入座交互",
            pos = {x = 1935.837645954352, y = 729.0213577421816},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351220217}
            }
          },
          ["17872807277626584"] = {
            key = "17872807277626584",
            type = "ChangeStaticCreatorNode",
            name = "生成吧台蕾伊和卡米拉",
            pos = {x = 2227.35147861292, y = 286.9974769700169},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351220219, 351220218}
            }
          },
          ["17872809175099324"] = {
            key = "17872809175099324",
            type = "ChangeStaticCreatorNode",
            name = "销毁吧台蕾伊",
            pos = {x = 2800.8147039840396, y = 293.8096579240743},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351220219}
            }
          },
          ["17872988038522298540"] = {
            key = "17872988038522298540",
            type = "GoToNode",
            name = "前往酒馆门口",
            pos = {x = 2191.249795618747, y = 767.031669574426},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351220222,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351220222"
            }
          },
          ["17873873966686694"] = {
            key = "17873873966686694",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2740.048259978007, y = 766.7420904038753},
            propsData = {}
          },
          ["17884039500141794"] = {
            key = "17884039500141794",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 2462.6134891790425, y = 769.1936181032291},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_OutBar_1207",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17885105731182282850"] = {
            key = "17885105731182282850",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务栏-巡查路线",
            pos = {x = 2181.153587734937, y = 947.5400676681567},
            propsData = {
              NewDescription = "Description_120703_2",
              NewDetail = "Content_120703_2",
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
