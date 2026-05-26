return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177847742045418822130",
      startPort = "StoryStart",
      endStory = "177847742045518822132",
      endPort = "In"
    },
    {
      startStory = "177847742045518822132",
      startPort = "Success",
      endStory = "177847742045518822131",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177847742045418822130"] = {
      isStoryNode = true,
      key = "177847742045418822130",
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
    ["177847742045518822131"] = {
      isStoryNode = true,
      key = "177847742045518822131",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1752.353846153846, y = 285.83076923076925},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177847742045518822132"] = {
      isStoryNode = true,
      key = "177847742045518822132",
      type = "StoryNode",
      name = "靠近芙罗拉专列",
      pos = {x = 1266.1691368323607, y = 283.0658367467912},
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
            startQuest = "177847742045618822136",
            startPort = "Out",
            endQuest = "177847742045618822137",
            endPort = "In"
          },
          {
            startQuest = "177847742045518822133",
            startPort = "QuestStart",
            endQuest = "177847742045618822140",
            endPort = "In"
          },
          {
            startQuest = "177847742045518822133",
            startPort = "QuestStart",
            endQuest = "177847742045618822141",
            endPort = "In"
          },
          {
            startQuest = "177847742045618822141",
            startPort = "Out",
            endQuest = "177847742045518822135",
            endPort = "Fail"
          },
          {
            startQuest = "177847742045518822133",
            startPort = "QuestStart",
            endQuest = "177891693187769540108",
            endPort = "Input"
          },
          {
            startQuest = "177847742045618822137",
            startPort = "Fail",
            endQuest = "1779163564102749",
            endPort = "In"
          },
          {
            startQuest = "1779163564102749",
            startPort = "Out",
            endQuest = "177847742045518822135",
            endPort = "Fail"
          },
          {
            startQuest = "177847742045518822133",
            startPort = "QuestStart",
            endQuest = "17795244169351102",
            endPort = "In"
          },
          {
            startQuest = "17795244169351102",
            startPort = "true",
            endQuest = "177847742045618822137",
            endPort = "In"
          },
          {
            startQuest = "17795244169351102",
            startPort = "false",
            endQuest = "177847742045618822136",
            endPort = "In"
          },
          {
            startQuest = "177847742045618822137",
            startPort = "Out",
            endQuest = "177969448552911607484",
            endPort = "In"
          },
          {
            startQuest = "177969448552911607484",
            startPort = "Out",
            endQuest = "177847742045618822139",
            endPort = "In"
          },
          {
            startQuest = "177847742045618822139",
            startPort = "Out",
            endQuest = "177847742045618822138",
            endPort = "In"
          },
          {
            startQuest = "177847742045618822138",
            startPort = "Out",
            endQuest = "1779712658731970205",
            endPort = "In"
          },
          {
            startQuest = "1779712658731970205",
            startPort = "Out",
            endQuest = "17784740019714854835",
            endPort = "In"
          }
        },
        nodeData = {
          ["17784740019714854835"] = {
            key = "17784740019714854835",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 3004.425696594427, y = 295.5961042311664},
            propsData = {}
          },
          ["177847742045518822133"] = {
            key = "177847742045518822133",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -249.98526473526476, y = 331.9095571095571},
            propsData = {ModeType = 0}
          },
          ["177847742045518822134"] = {
            key = "177847742045518822134",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3200.4866946778707, y = 628.7850140056022},
            propsData = {ModeType = 0}
          },
          ["177847742045518822135"] = {
            key = "177847742045518822135",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2076.229691876751, y = 706.2608543417365},
            propsData = {}
          },
          ["177847742045618822136"] = {
            key = "177847742045618822136",
            type = "GoToNode",
            name = "前往",
            pos = {x = 708.9451015901021, y = 347.26435759329087},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2530011,
              GuideType = "M",
              GuidePointName = "Mechanism_KaojinZhuanlie_2530011"
            }
          },
          ["177847742045618822137"] = {
            key = "177847742045618822137",
            type = "TalkNode",
            name = "初遇史蒂芬",
            pos = {x = 1124.1364955404574, y = 282.85321676165046},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10041801.10041801'",
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
              HideNpcs = true,
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
          ["177847742045618822138"] = {
            key = "177847742045618822138",
            type = "TalkNode",
            name = "与史蒂芬对话",
            pos = {x = 2436.3934837092734, y = 311.4636591478696},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10041901.10041901'",
              TalkType = "QuestImpression",
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
              HideMechanismsFX = true,
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
          ["177847742045618822139"] = {
            key = "177847742045618822139",
            type = "TalkNode",
            name = "站桩过场-帮助史蒂芬",
            pos = {x = 2054.7781385281387, y = 274.8008658008657},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/Chapter03_Fix_SEQ_04.Chapter03_Fix_SEQ_04'",
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
              HideNpcs = true,
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
          ["177847742045618822140"] = {
            key = "177847742045618822140",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 723.6796542987904, y = -134.07154744568928},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177847742045618822141"] = {
            key = "177847742045618822141",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1271.4857313738894, y = 685.2525632262475},
            propsData = {}
          },
          ["177891693187769540108"] = {
            key = "177891693187769540108",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 10, y = -58},
            propsData = {
              TargetTime = 16,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true
            }
          },
          ["1779163564102749"] = {
            key = "1779163564102749",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1664.9543226381459, y = 533.9226827094471},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Fail",
              UnitId = -1
            }
          },
          ["17795244169351102"] = {
            key = "17795244169351102",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 395.13043478260846, y = 267.8012422360248},
            propsData = {
              FunctionName = "Equal",
              VarName = "FirstStateChaosPre100402",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "2"}
              }
            }
          },
          ["177969448552911607484"] = {
            key = "177969448552911607484",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1700.4210526315787, y = 271.5541795665634},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {106001},
              bStoreToServer = false
            }
          },
          ["1779712658731970205"] = {
            key = "1779712658731970205",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2728.5, y = 300},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
