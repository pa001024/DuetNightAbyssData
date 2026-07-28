return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177824355795610360668",
      startPort = "StoryStart",
      endStory = "17782435125899548978",
      endPort = "In"
    },
    {
      startStory = "17782435125899548978",
      startPort = "Success",
      endStory = "177824355795710360669",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17782435125899548978"] = {
      isStoryNode = true,
      key = "17782435125899548978",
      type = "StoryNode",
      name = "神弃者boss战",
      pos = {x = 1035.4857142857143, y = 85.77857142857157},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040310_01",
        QuestDeatil = "Description_10040309_01",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Kanuo_152480368",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17782435125899548987",
            startPort = "Out",
            endQuest = "17782435125899548988",
            endPort = "In"
          },
          {
            startQuest = "17782435125899548988",
            startPort = "Out",
            endQuest = "17782435125899548989",
            endPort = "In"
          },
          {
            startQuest = "17782435125899548990",
            startPort = "Out",
            endQuest = "17782435125899548987",
            endPort = "In"
          },
          {
            startQuest = "17782435125899548990",
            startPort = "Out",
            endQuest = "17782435125899548991",
            endPort = "In"
          },
          {
            startQuest = "17782435125899548989",
            startPort = "Out",
            endQuest = "17782435251869549364",
            endPort = "In"
          },
          {
            startQuest = "17782435125899548983",
            startPort = "QuestStart",
            endQuest = "17783048979629543873",
            endPort = "In"
          },
          {
            startQuest = "17782435125899548983",
            startPort = "QuestStart",
            endQuest = "177875047920110697597",
            endPort = "In"
          },
          {
            startQuest = "177875047920110697597",
            startPort = "Out",
            endQuest = "17782435125899548985",
            endPort = "Fail"
          },
          {
            startQuest = "17782435125899548990",
            startPort = "Out",
            endQuest = "17787573698991751",
            endPort = "In"
          },
          {
            startQuest = "17782435125899548988",
            startPort = "Out",
            endQuest = "17787573783441978",
            endPort = "In"
          },
          {
            startQuest = "17782435125899548983",
            startPort = "QuestStart",
            endQuest = "177891747346681605088",
            endPort = "Input"
          },
          {
            startQuest = "17782435125899548983",
            startPort = "QuestStart",
            endQuest = "17792819589533865663",
            endPort = "In"
          },
          {
            startQuest = "17792819589533865663",
            startPort = "Out",
            endQuest = "17782435125899548990",
            endPort = "In"
          },
          {
            startQuest = "17782435125899548990",
            startPort = "Out",
            endQuest = "17795206183041936545",
            endPort = "In"
          },
          {
            startQuest = "17782435125899548988",
            startPort = "Out",
            endQuest = "17795206367611936867",
            endPort = "In"
          }
        },
        nodeData = {
          ["17782435125899548983"] = {
            key = "17782435125899548983",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 373.19344050059334, y = 290.45528104434135},
            propsData = {ModeType = 0}
          },
          ["17782435125899548984"] = {
            key = "17782435125899548984",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2699, y = 307.75},
            propsData = {ModeType = 0}
          },
          ["17782435125899548985"] = {
            key = "17782435125899548985",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1378.4583333333333, y = 647.4958333333333},
            propsData = {}
          },
          ["17782435125899548987"] = {
            key = "17782435125899548987",
            type = "SendMessageNode",
            name = "开始精英战",
            pos = {x = 1484.25, y = 279.35},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "ZZZBossStart",
              UnitId = -1
            }
          },
          ["17782435125899548988"] = {
            key = "17782435125899548988",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = 1790.384542052197, y = 280.3201949652307},
            propsData = {
              SendMessage = "",
              FinishCondition = "ZZZBossSuccess"
            }
          },
          ["17782435125899548989"] = {
            key = "17782435125899548989",
            type = "TalkNode",
            name = "boss战后对话",
            pos = {x = 2076.5845420521973, y = 281.3201949652307},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10044601.10044601'",
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
          ["17782435125899548990"] = {
            key = "17782435125899548990",
            type = "TalkNode",
            name = "boss战前战斗",
            pos = {x = 1165.3272311212813, y = 281.8535469107551},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10044501.10044501'",
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
          ["17782435125899548991"] = {
            key = "17782435125899548991",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1485.0837528604118, y = 165.51441647597252},
            propsData = {
              NewDescription = "Content_10040310_02",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["17782435251869549364"] = {
            key = "17782435251869549364",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2380, y = 302},
            propsData = {}
          },
          ["17783048979629543873"] = {
            key = "17783048979629543873",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1142.2803970223326, y = 20.05459057071954},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177875047920110697597"] = {
            key = "177875047920110697597",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1033.4950585072738, y = 548.0562539531943},
            propsData = {}
          },
          ["17787573698991751"] = {
            key = "17787573698991751",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 1484.8, y = 447.6000000000001},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {152480405}
            }
          },
          ["17787573783441978"] = {
            key = "17787573783441978",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 2080, y = 426.80000000000007},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {152480405}
            }
          },
          ["177891747346681605088"] = {
            key = "177891747346681605088",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1165.4, y = -81.70000000000005},
            propsData = {
              TargetTime = 19,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17792819589533865663"] = {
            key = "17792819589533865663",
            type = "ChangeStaticCreatorNode",
            name = "销毁NPC的哈洛吉卡诺史蒂芬",
            pos = {x = 883.899888765295, y = 286.59043381535065},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                152480367,
                152480368,
                152480413
              }
            }
          },
          ["17795206183041936545"] = {
            key = "17795206183041936545",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1477.2428194025108, y = 11.814682876546044},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0168_boss_haluoji.0168_boss_haluoji'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {106001},
              bStoreToServer = true
            }
          },
          ["17795206367611936867"] = {
            key = "17795206367611936867",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2053.4124622596537, y = 84.21852903039223},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          }
        },
        commentData = {}
      }
    },
    ["177824355795610360668"] = {
      isStoryNode = true,
      key = "177824355795610360668",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 777.1999999999999, y = 87.59999999999998},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177824355795710360669"] = {
      isStoryNode = true,
      key = "177824355795710360669",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1331.866851055188, y = 90.86607697013385},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    }
  },
  commentData = {}
}
