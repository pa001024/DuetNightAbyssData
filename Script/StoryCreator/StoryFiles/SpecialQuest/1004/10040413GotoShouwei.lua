return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177874692782520447684",
      startPort = "StoryStart",
      endStory = "177874693054920447723",
      endPort = "In"
    },
    {
      startStory = "177874693054920447723",
      startPort = "Success",
      endStory = "177874692782520447687",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177874692782520447684"] = {
      isStoryNode = true,
      key = "177874692782520447684",
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
    ["177874692782520447687"] = {
      isStoryNode = true,
      key = "177874692782520447687",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1756, y = 292},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874693054920447723"] = {
      isStoryNode = true,
      key = "177874693054920447723",
      type = "StoryNode",
      name = "前往守卫车厢",
      pos = {x = 1230, y = 286},
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
            startQuest = "177874693054920447731",
            startPort = "Out",
            endQuest = "177874693054920447733",
            endPort = "In"
          },
          {
            startQuest = "177874693054920447731",
            startPort = "Out",
            endQuest = "177874693054920447732",
            endPort = "In"
          },
          {
            startQuest = "177874693054920447728",
            startPort = "QuestStart",
            endQuest = "177874693054920447734",
            endPort = "In"
          },
          {
            startQuest = "177874693054920447728",
            startPort = "QuestStart",
            endQuest = "177874693054920447735",
            endPort = "In"
          },
          {
            startQuest = "177874693054920447728",
            startPort = "QuestStart",
            endQuest = "177874695545520448566",
            endPort = "In"
          },
          {
            startQuest = "177874695545520448566",
            startPort = "Out",
            endQuest = "177874693054920447730",
            endPort = "Fail"
          },
          {
            startQuest = "177874693054920447728",
            startPort = "QuestStart",
            endQuest = "1778754993053976366",
            endPort = "In"
          },
          {
            startQuest = "1778754993053976366",
            startPort = "Out",
            endQuest = "177874693054920447731",
            endPort = "In"
          },
          {
            startQuest = "177874693054920447731",
            startPort = "Out",
            endQuest = "1779696794706404",
            endPort = "In"
          },
          {
            startQuest = "177874693054920447732",
            startPort = "Out",
            endQuest = "1779696797972558",
            endPort = "In"
          },
          {
            startQuest = "1779696797972558",
            startPort = "Out",
            endQuest = "177874694555220448247",
            endPort = "In"
          }
        },
        nodeData = {
          ["177874693054920447728"] = {
            key = "177874693054920447728",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 676.3846153846155, y = 359},
            propsData = {ModeType = 0}
          },
          ["177874693054920447729"] = {
            key = "177874693054920447729",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2813.026877470356, y = 438.13992094861663},
            propsData = {ModeType = 0}
          },
          ["177874693054920447730"] = {
            key = "177874693054920447730",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1764.3478260869565, y = 829.1304347826087},
            propsData = {}
          },
          ["177874693054920447731"] = {
            key = "177874693054920447731",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1322.7472527472528, y = 381.42857142857144},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272730006,
              GuideType = "M",
              GuidePointName = "Mechanism_GetShouwei_272730006"
            }
          },
          ["177874693054920447732"] = {
            key = "177874693054920447732",
            type = "TalkNode",
            name = "守卫车厢对话",
            pos = {x = 1883.95, y = 451.7},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10046601.10046601'",
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
          ["177874693054920447733"] = {
            key = "177874693054920447733",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 1686.25, y = 335.07142857142856},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {272640052}
            }
          },
          ["177874693054920447734"] = {
            key = "177874693054920447734",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1630.2222222222222, y = 178.66666666666666},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "OpenGate03Behind",
              UnitId = -1
            }
          },
          ["177874693054920447735"] = {
            key = "177874693054920447735",
            type = "ChangeRoleNode",
            name = "切换为主角",
            pos = {x = 767.5652173913043, y = 751.7826086956521},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177874694555220448247"] = {
            key = "177874694555220448247",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2544.5121697524446, y = 454.212814645309},
            propsData = {}
          },
          ["177874695545520448566"] = {
            key = "177874695545520448566",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1344.3935926773454, y = 818.7780320366135},
            propsData = {}
          },
          ["1778754993053976366"] = {
            key = "1778754993053976366",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1067.580882352941, y = 434.4127966976265},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_ShidifenRE",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["1779696794706404"] = {
            key = "1779696794706404",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1775.6771306608773, y = 614.8831286102959},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0162_story_jazz_sneak_into.0162_story_jazz_sneak_into'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {106101},
              bStoreToServer = false
            }
          },
          ["1779696797972558"] = {
            key = "1779696797972558",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2247.4953124790586, y = 441.7013104284777},
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
