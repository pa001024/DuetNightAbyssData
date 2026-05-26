return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177874874251628244464",
      startPort = "StoryStart",
      endStory = "177874874322828244503",
      endPort = "In"
    },
    {
      startStory = "177874874322828244503",
      startPort = "Success",
      endStory = "177874874251628244467",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177874874251628244464"] = {
      isStoryNode = true,
      key = "177874874251628244464",
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
    ["177874874251628244467"] = {
      isStoryNode = true,
      key = "177874874251628244467",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1768, y = 268},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874874322828244503"] = {
      isStoryNode = true,
      key = "177874874322828244503",
      type = "StoryNode",
      name = "调查车长车厢",
      pos = {x = 1378, y = 274},
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
        bIsPlayBlackScreenOnFail = false,
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
            startQuest = "177874874322828244511",
            startPort = "Out",
            endQuest = "177874874322828244512",
            endPort = "In"
          },
          {
            startQuest = "177874874322828244513",
            startPort = "Out",
            endQuest = "177874874322828244514",
            endPort = "In"
          },
          {
            startQuest = "177874874322828244514",
            startPort = "Out",
            endQuest = "177874874322828244511",
            endPort = "In"
          },
          {
            startQuest = "177874874322828244508",
            startPort = "QuestStart",
            endQuest = "177874875326928244870",
            endPort = "In"
          },
          {
            startQuest = "177874874322828244512",
            startPort = "Out",
            endQuest = "177874897984128245165",
            endPort = "In"
          },
          {
            startQuest = "177874874322828244508",
            startPort = "QuestStart",
            endQuest = "177874898799428245418",
            endPort = "In"
          },
          {
            startQuest = "177874898799428245418",
            startPort = "Out",
            endQuest = "177874874322828244510",
            endPort = "Fail"
          },
          {
            startQuest = "177874874322828244508",
            startPort = "QuestStart",
            endQuest = "177875538085837994325",
            endPort = "In"
          },
          {
            startQuest = "177875538085837994325",
            startPort = "Out",
            endQuest = "177874874322828244513",
            endPort = "In"
          }
        },
        nodeData = {
          ["177874874322828244508"] = {
            key = "177874874322828244508",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -114.05226101820529, y = 273.59850341274483},
            propsData = {ModeType = 0}
          },
          ["177874874322828244509"] = {
            key = "177874874322828244509",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2127.849753694581, y = 288.4433497536946},
            propsData = {ModeType = 0}
          },
          ["177874874322828244510"] = {
            key = "177874874322828244510",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1115.5, y = 785.5},
            propsData = {}
          },
          ["177874874322828244511"] = {
            key = "177874874322828244511",
            type = "TalkNode",
            name = "发现车长 尸体",
            pos = {x = 1371.1115115374641, y = 304.93099025454114},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10047401_02.10047401_02'",
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
          ["177874874322828244512"] = {
            key = "177874874322828244512",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 1680.6000000000001, y = 345.9},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {272640055}
            }
          },
          ["177874874322828244513"] = {
            key = "177874874322828244513",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 740.0734218914429, y = 284.3780963565099},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10047401.10047401'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 2,
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
          ["177874874322828244514"] = {
            key = "177874874322828244514",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 1085.2813283208018, y = 293.05200501253137},
            propsData = {
              StaticCreatorId = 272640073,
              UnitId = 10075,
              bGuideUIEnable = true,
              GuidePointName = "BP_ChezhangDie",
              LongPressTime = 4,
              MontageName = "Interactive_FireWork_Montage",
              bFocusEnable = false,
              SequencePath = ""
            }
          },
          ["177874875326928244870"] = {
            key = "177874875326928244870",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 356.9504643962849, y = 506.44117647058823},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177874897984128245165"] = {
            key = "177874897984128245165",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 1959.921052631579, y = 318.5},
            propsData = {}
          },
          ["177874898799428245418"] = {
            key = "177874898799428245418",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 401.3328173374613, y = 794},
            propsData = {}
          },
          ["177875538085837994325"] = {
            key = "177875538085837994325",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 384.4210526315788, y = 263.57894736842104},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_XierBattle",
              FadeIn = false,
              FadeOut = false,
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
