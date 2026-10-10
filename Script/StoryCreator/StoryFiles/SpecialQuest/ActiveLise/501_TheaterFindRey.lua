return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178703505909411200528",
      startPort = "StoryStart",
      endStory = "178703506374711200760",
      endPort = "In"
    },
    {
      startStory = "178703506374711200760",
      startPort = "Success",
      endStory = "178703505909411200531",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178703505909411200528"] = {
      isStoryNode = true,
      key = "178703505909411200528",
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
    ["178703505909411200531"] = {
      isStoryNode = true,
      key = "178703505909411200531",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1512, y = 296},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178703506374711200760"] = {
      isStoryNode = true,
      key = "178703506374711200760",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1156.0357142857142, y = 285.96428571428584},
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
            startQuest = "178703506374711200765",
            startPort = "QuestStart",
            endQuest = "178738727473118105403",
            endPort = "In"
          },
          {
            startQuest = "178703506374711200765",
            startPort = "QuestStart",
            endQuest = "178738726367618105223",
            endPort = "In"
          },
          {
            startQuest = "178738779558318107498",
            startPort = "Out",
            endQuest = "178738783664518108068",
            endPort = "In"
          },
          {
            startQuest = "178738783664518108068",
            startPort = "Out",
            endQuest = "178738790252518108741",
            endPort = "In"
          },
          {
            startQuest = "178738790252518108741",
            startPort = "Out",
            endQuest = "178738792599718109208",
            endPort = "In"
          },
          {
            startQuest = "178738792599718109208",
            startPort = "Out",
            endQuest = "178738808937118110691",
            endPort = "In"
          },
          {
            startQuest = "178738803476318110081",
            startPort = "Out",
            endQuest = "178738756668518105796",
            endPort = "In"
          },
          {
            startQuest = "178738726367618105223",
            startPort = "Out",
            endQuest = "178738779558318107498",
            endPort = "In"
          },
          {
            startQuest = "178738808937118110691",
            startPort = "Out",
            endQuest = "17887768103461319",
            endPort = "In"
          },
          {
            startQuest = "178738808937118110691",
            startPort = "Out",
            endQuest = "17887768976752829",
            endPort = "In"
          },
          {
            startQuest = "17887768976752829",
            startPort = "Out",
            endQuest = "17887768518502239",
            endPort = "In"
          },
          {
            startQuest = "17887768518502239",
            startPort = "Out",
            endQuest = "178738803476318110081",
            endPort = "In"
          },
          {
            startQuest = "178738727473118105403",
            startPort = "Out",
            endQuest = "178703506374711200767",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["178703506374711200765"] = {
            key = "178703506374711200765",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1096.4, y = 304.8},
            propsData = {ModeType = 0}
          },
          ["178703506374711200766"] = {
            key = "178703506374711200766",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 4002.8409090909095, y = 456.59090909090907},
            propsData = {ModeType = 0}
          },
          ["178703506374711200767"] = {
            key = "178703506374711200767",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1682.7522727272728, y = 522.7545454545455},
            propsData = {}
          },
          ["178738726367618105223"] = {
            key = "178738726367618105223",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1391.8318181818183, y = 308.16742424242415},
            propsData = {QuestRoleId = 41030101, IsPlayFX = false}
          },
          ["178738727473118105403"] = {
            key = "178738727473118105403",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1392.3431818181818, y = 509.81515151515146},
            propsData = {}
          },
          ["178738756668518105796"] = {
            key = "178738756668518105796",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 4003.6704545454545, y = 284.2196969696969},
            propsData = {}
          },
          ["178738779558318107498"] = {
            key = "178738779558318107498",
            type = "ChangeStaticCreatorNode",
            name = "生成工作人员和蕾伊",
            pos = {x = 1671.056818181818, y = 304.7310606060605},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351970002, 351970003}
            }
          },
          ["178738783664518108068"] = {
            key = "178738783664518108068",
            type = "TalkNode",
            name = "跟工作人员打听",
            pos = {x = 1968.3295454545455, y = 289.7310606060605},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 260026,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_TheaWoman120705_351970002",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070481,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120705/12070501.12070501'",
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
          ["178738790252518108741"] = {
            key = "178738790252518108741",
            type = "GoToNode",
            name = "来到蕾伊附近",
            pos = {x = 2262.875, y = 287.00378787878776},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351970004,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351970004"
            }
          },
          ["178738792599718109208"] = {
            key = "178738792599718109208",
            type = "TalkNode",
            name = "揭开蕾伊目的",
            pos = {x = 2558.7840909090905, y = 282.9128787878787},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070490,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120705/12070502.12070502'",
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
          ["178738803476318110081"] = {
            key = "178738803476318110081",
            type = "TalkNode",
            name = "骂醒蕾伊",
            pos = {x = 3707.0795454545446, y = 285.4128787878786},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 260017,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Rey120705_2_351970009",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070561,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120705/12070503.12070503'",
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
          ["178738808937118110691"] = {
            key = "178738808937118110691",
            type = "TalkNode",
            name = "夺刀过场",
            pos = {x = 2860.147727272727, y = 284.276515151515},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "LevelSequence'/Game/Asset/Cinematics/Story/Ver01/Ver0107/Ver0107_SC001/SQ_Ver0107_SC001.SQ_Ver0107_SC001'",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = true,
              HideMonsters = true,
              bHidePickup = true,
              bHideSkillCreature = true,
              bHideSceneEffects = true,
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["17887768103461319"] = {
            key = "17887768103461319",
            type = "ChangeStaticCreatorNode",
            name = "销毁蕾伊1",
            pos = {x = 3151.75, y = 116.99999999999983},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351970003}
            }
          },
          ["17887768518502239"] = {
            key = "17887768518502239",
            type = "ChangeStaticCreatorNode",
            name = "生成蕾伊2",
            pos = {x = 3424.25, y = 290.7499999999999},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351970009}
            }
          },
          ["17887768976752829"] = {
            key = "17887768976752829",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 3148, y = 279.4999999999999},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_ReyBattle_1207",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
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
