return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177874835460125318565",
      startPort = "StoryStart",
      endStory = "177874835560325318616",
      endPort = "In"
    },
    {
      startStory = "177874835560325318616",
      startPort = "Success",
      endStory = "177874835460125318568",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177874835460125318565"] = {
      isStoryNode = true,
      key = "177874835460125318565",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1163.157894736842, y = 265.2631578947368},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874835460125318568"] = {
      isStoryNode = true,
      key = "177874835460125318568",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1955.2631578947367, y = 276.3157894736842},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874835560325318616"] = {
      isStoryNode = true,
      key = "177874835560325318616",
      type = "StoryNode",
      name = "进入贵族车厢",
      pos = {x = 1529.8418472652218, y = 255.0593395252838},
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
            startQuest = "177874835560325318625",
            startPort = "Out",
            endQuest = "177874835560325318626",
            endPort = "In"
          },
          {
            startQuest = "177874835560325318624",
            startPort = "Out",
            endQuest = "177874835560325318625",
            endPort = "In"
          },
          {
            startQuest = "177874835560325318629",
            startPort = "Out",
            endQuest = "177874835560325318628",
            endPort = "In"
          },
          {
            startQuest = "177874835560325318621",
            startPort = "QuestStart",
            endQuest = "177874835560325318629",
            endPort = "In"
          },
          {
            startQuest = "177874835560325318626",
            startPort = "Out",
            endQuest = "177874837238525319131",
            endPort = "In"
          },
          {
            startQuest = "177874835560325318621",
            startPort = "QuestStart",
            endQuest = "177874837981725319378",
            endPort = "In"
          },
          {
            startQuest = "177874837981725319378",
            startPort = "Out",
            endQuest = "177874835560325318623",
            endPort = "Fail"
          },
          {
            startQuest = "177874835560325318621",
            startPort = "QuestStart",
            endQuest = "17787551972142926351",
            endPort = "In"
          },
          {
            startQuest = "177874835560325318621",
            startPort = "QuestStart",
            endQuest = "177874835560325318627",
            endPort = "In"
          },
          {
            startQuest = "17787551972142926351",
            startPort = "Out",
            endQuest = "177874835560325318624",
            endPort = "In"
          },
          {
            startQuest = "17787551972142926351",
            startPort = "Out",
            endQuest = "177935152257350292574",
            endPort = "In"
          },
          {
            startQuest = "177874835560325318624",
            startPort = "Out",
            endQuest = "177935152592150292734",
            endPort = "In"
          },
          {
            startQuest = "177874835560325318624",
            startPort = "Out",
            endQuest = "1779520834249545",
            endPort = "In"
          },
          {
            startQuest = "17787551972142926351",
            startPort = "Out",
            endQuest = "1779696954856643",
            endPort = "In"
          },
          {
            startQuest = "1779696954856643",
            startPort = "Out",
            endQuest = "1779696959308797",
            endPort = "In"
          }
        },
        nodeData = {
          ["177874835560325318621"] = {
            key = "177874835560325318621",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 108.73684210526312, y = 314},
            propsData = {ModeType = 0}
          },
          ["177874835560325318622"] = {
            key = "177874835560325318622",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2220.1785714285716, y = 345.7142857142857},
            propsData = {ModeType = 0}
          },
          ["177874835560325318623"] = {
            key = "177874835560325318623",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1282.5, y = 587.5},
            propsData = {}
          },
          ["177874835560325318624"] = {
            key = "177874835560325318624",
            type = "GoToNode",
            name = "进入贵族车厢",
            pos = {x = 1119.0462474645028, y = 322.5176470588235},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272640005,
              GuideType = "M",
              GuidePointName = "Mechanism_GetGuizu_272640005"
            }
          },
          ["177874835560325318625"] = {
            key = "177874835560325318625",
            type = "TalkNode",
            name = "贵族车厢氛围",
            pos = {x = 1426.4011927351582, y = 319.6877280688951},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10047001.10047001'",
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
          ["177874835560325318626"] = {
            key = "177874835560325318626",
            type = "TalkNode",
            name = "主角对话",
            pos = {x = 1692.8717809704524, y = 326.7465515983069},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10047101.10047101'",
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
          ["177874835560325318627"] = {
            key = "177874835560325318627",
            type = "ChangeRoleNode",
            name = "切换为芙罗拉",
            pos = {x = 532.7368421052631, y = 97.15789473684202},
            propsData = {QuestRoleId = 11020201, IsPlayFX = false}
          },
          ["177874835560325318628"] = {
            key = "177874835560325318628",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1112.2608695652175, y = -67.3913043478261},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "OpenGate05Behind",
              UnitId = -1
            }
          },
          ["177874835560325318629"] = {
            key = "177874835560325318629",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 876, y = 148},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "OpenGate04Front",
              UnitId = -1
            }
          },
          ["177874837238525319131"] = {
            key = "177874837238525319131",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 1961.3694835641768, y = 338.19266837169664},
            propsData = {}
          },
          ["177874837981725319378"] = {
            key = "177874837981725319378",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 927.6194835641768, y = 558.1926683716965},
            propsData = {}
          },
          ["17787551972142926351"] = {
            key = "17787551972142926351",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 586.421052631579, y = 328.84210526315815},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_FuluoSearch",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177935152257350292574"] = {
            key = "177935152257350292574",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 856.7058823529413, y = 781.2941176470588},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {272640152}
            }
          },
          ["177935152592150292734"] = {
            key = "177935152592150292734",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 1568.4705882352937, y = 597.7647058823529},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {272640152}
            }
          },
          ["1779520834249545"] = {
            key = "1779520834249545",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1444.4347826086955, y = 167.70750988142285},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {},
              bStoreToServer = false
            }
          },
          ["1779696954856643"] = {
            key = "1779696954856643",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 578, y = 870},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          },
          ["1779696959308797"] = {
            key = "1779696959308797",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1224, y = 962},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "event:/bgm/mute",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {106101},
              bStoreToServer = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
