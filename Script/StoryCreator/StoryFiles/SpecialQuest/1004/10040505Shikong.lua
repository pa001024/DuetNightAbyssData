return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177772057065416822022",
      startPort = "Success",
      endStory = "177772057065316822021",
      endPort = "In"
    },
    {
      startStory = "177772056663716821971",
      startPort = "StoryStart",
      endStory = "177772057065416822022",
      endPort = "In"
    },
    {
      startStory = "177772057065316822021",
      startPort = "Success",
      endStory = "177772056663716821974",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177772056663716821971"] = {
      isStoryNode = true,
      key = "177772056663716821971",
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
    ["177772056663716821974"] = {
      isStoryNode = true,
      key = "177772056663716821974",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1813.3333333333333, y = 315},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177772057065316822021"] = {
      isStoryNode = true,
      key = "177772057065316822021",
      type = "StoryNode",
      name = "列车失控",
      pos = {x = 1467.1412947754861, y = 274.1711081402257},
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
        SubRegionId = 106101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177772057065516822032",
            startPort = "QuestStart",
            endQuest = "177772057065516822035",
            endPort = "In"
          },
          {
            startQuest = "177772057065516822035",
            startPort = "Out",
            endQuest = "1778765708439833",
            endPort = "In"
          },
          {
            startQuest = "177772057065516822032",
            startPort = "QuestStart",
            endQuest = "17787657169391050",
            endPort = "In"
          },
          {
            startQuest = "17787657169391050",
            startPort = "Out",
            endQuest = "177772057065516822034",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["177772057065516822032"] = {
            key = "177772057065516822032",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177772057065516822033"] = {
            key = "177772057065516822033",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2297.0588235294117, y = 302.64705882352945},
            propsData = {ModeType = 0}
          },
          ["177772057065516822034"] = {
            key = "177772057065516822034",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["177772057065516822035"] = {
            key = "177772057065516822035",
            type = "TalkNode",
            name = "过场-签订契约",
            pos = {x = 1506.059210526316, y = 327.36513157894734},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC025/SQ_Ver0104_SC025",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["1778765708439833"] = {
            key = "1778765708439833",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 1951.0588235294117, y = 385.99999999999994},
            propsData = {}
          },
          ["17787657169391050"] = {
            key = "17787657169391050",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1476.3529411764705, y = 581.8823529411765},
            propsData = {}
          }
        },
        commentData = {}
      }
    },
    ["177772057065416822022"] = {
      isStoryNode = true,
      key = "177772057065416822022",
      type = "StoryNode",
      name = "列车失控前",
      pos = {x = 1235.1920385578471, y = 273.82889185977444},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040506_01",
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
        SubRegionId = 106101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177772057065816822053",
            startPort = "Out",
            endQuest = "177772057065716822050",
            endPort = "In"
          },
          {
            startQuest = "177772057065816822054",
            startPort = "Out",
            endQuest = "177772057065816822055",
            endPort = "In"
          },
          {
            startQuest = "177772057065716822050",
            startPort = "Out",
            endQuest = "177772057065816822056",
            endPort = "In"
          },
          {
            startQuest = "177772057065716822052",
            startPort = "Out",
            endQuest = "177772057065816822053",
            endPort = "In"
          },
          {
            startQuest = "177772057065716822050",
            startPort = "Out",
            endQuest = "177772057065816822059",
            endPort = "In"
          },
          {
            startQuest = "177772057065716822051",
            startPort = "Out",
            endQuest = "177772057065816822060",
            endPort = "In"
          },
          {
            startQuest = "177772057065716822050",
            startPort = "Out",
            endQuest = "177772057065816822061",
            endPort = "In"
          },
          {
            startQuest = "177772057065816822061",
            startPort = "Out",
            endQuest = "177772057065716822051",
            endPort = "In"
          },
          {
            startQuest = "177772057065616822047",
            startPort = "QuestStart",
            endQuest = "177772201386727103320",
            endPort = "In"
          },
          {
            startQuest = "177772201386727103320",
            startPort = "Out",
            endQuest = "177772057065616822049",
            endPort = "Fail"
          },
          {
            startQuest = "177772057065616822047",
            startPort = "QuestStart",
            endQuest = "177772203423427103864",
            endPort = "In"
          },
          {
            startQuest = "177772057065616822047",
            startPort = "QuestStart",
            endQuest = "177772057065716822052",
            endPort = "In"
          },
          {
            startQuest = "177772057065816822060",
            startPort = "Out",
            endQuest = "177772057065616822048",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177772057065616822047"] = {
            key = "177772057065616822047",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -1027.0846352703156, y = 269.27099022142295},
            propsData = {ModeType = 0}
          },
          ["177772057065616822048"] = {
            key = "177772057065616822048",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2704.749040920716, y = 269.7122762148338},
            propsData = {ModeType = 0}
          },
          ["177772057065616822049"] = {
            key = "177772057065616822049",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 533.124999999999, y = 752.5},
            propsData = {}
          },
          ["177772057065716822050"] = {
            key = "177772057065716822050",
            type = "TalkNode",
            name = "准备控制列车",
            pos = {x = 699.7132992327367, y = 292.0807400379507},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10048801.10048801'",
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
          ["177772057065716822051"] = {
            key = "177772057065716822051",
            type = "TalkNode",
            name = "缔结契约",
            pos = {x = 1450.6935955307795, y = 275.9586225794665},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10048901.10048901'",
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
          ["177772057065716822052"] = {
            key = "177772057065716822052",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = -157.95059288537544, y = 280.9721407624634},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_GetTrainHead",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177772057065816822053"] = {
            key = "177772057065816822053",
            type = "TalkNode",
            name = "过场-主角试图操作控制台",
            pos = {x = 330.59817671809265, y = 297.6514726507714},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC024/SQ_Ver0104_SC024",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              HideNpcs = true,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
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
          ["177772057065816822054"] = {
            key = "177772057065816822054",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1146.4307917888566, y = 767.2970674486804},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272640049}
            }
          },
          ["177772057065816822055"] = {
            key = "177772057065816822055",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 1627.0529116045248, y = 726.1653586556811},
            propsData = {
              StaticCreatorId = 272640049,
              UnitId = 10073,
              bGuideUIEnable = true,
              GuidePointName = "BP_TrainHead_272640049",
              LongPressTime = 0,
              MontageName = "",
              bFocusEnable = false,
              SequencePath = ""
            }
          },
          ["177772057065816822056"] = {
            key = "177772057065816822056",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1178.148052234554, y = -71.77263743719539},
            propsData = {
              NewDescription = "Content_10040506_02",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["177772057065816822059"] = {
            key = "177772057065816822059",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 1127.5872388481087, y = 518.0208921513268},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {272640058}
            }
          },
          ["177772057065816822060"] = {
            key = "177772057065816822060",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 2097, y = 302.28260869565213},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {272640058}
            }
          },
          ["177772057065816822061"] = {
            key = "177772057065816822061",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 1150.5517771701982, y = 260.5782638414217},
            propsData = {
              StaticCreatorId = 272640061,
              UnitId = 10073,
              bGuideUIEnable = true,
              GuidePointName = "BP_TrainHead_272640049",
              LongPressTime = 0,
              MontageName = "",
              bFocusEnable = false,
              SequencePath = ""
            }
          },
          ["177772201386727103320"] = {
            key = "177772201386727103320",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = -308.87207749340047, y = 715.4765388654989},
            propsData = {}
          },
          ["177772203423427103864"] = {
            key = "177772203423427103864",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = -699.6185522629819, y = 131.38940832362687},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
