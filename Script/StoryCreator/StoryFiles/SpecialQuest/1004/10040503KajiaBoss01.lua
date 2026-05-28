return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177772045240414953062",
      startPort = "StoryStart",
      endStory = "177772045534914953102",
      endPort = "In"
    },
    {
      startStory = "177772045534914953102",
      startPort = "Success",
      endStory = "177772045240414953065",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177772045240414953062"] = {
      isStoryNode = true,
      key = "177772045240414953062",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1264.2105263157896, y = 265.2631578947368},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177772045240414953065"] = {
      isStoryNode = true,
      key = "177772045240414953065",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2027.8947368421052, y = 273.15789473684214},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177772045534914953102"] = {
      isStoryNode = true,
      key = "177772045534914953102",
      type = "StoryNode",
      name = "卡嘉Boss战一阶段",
      pos = {x = 1634, y = 271.99999999999994},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040505_01",
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
            startQuest = "177772045534914953110",
            startPort = "Out",
            endQuest = "177772045534914953111",
            endPort = "In"
          },
          {
            startQuest = "177772045534914953110",
            startPort = "Out",
            endQuest = "177772045534914953112",
            endPort = "In"
          },
          {
            startQuest = "177772045534914953110",
            startPort = "Out",
            endQuest = "177772045534914953117",
            endPort = "In"
          },
          {
            startQuest = "177772045534914953115",
            startPort = "Out",
            endQuest = "177772045534914953118",
            endPort = "In"
          },
          {
            startQuest = "177772045534914953107",
            startPort = "QuestStart",
            endQuest = "177772045534914953116",
            endPort = "In"
          },
          {
            startQuest = "177772045534914953107",
            startPort = "QuestStart",
            endQuest = "177772045534914953120",
            endPort = "In"
          },
          {
            startQuest = "177772045534914953119",
            startPort = "Out",
            endQuest = "177772045534914953121",
            endPort = "In"
          },
          {
            startQuest = "177772045534914953107",
            startPort = "QuestStart",
            endQuest = "177772155220222432681",
            endPort = "In"
          },
          {
            startQuest = "177772155220222432681",
            startPort = "Out",
            endQuest = "177772045534914953109",
            endPort = "Fail"
          },
          {
            startQuest = "177772045534914953107",
            startPort = "QuestStart",
            endQuest = "177772167199224300208",
            endPort = "In"
          },
          {
            startQuest = "177772167199224300208",
            startPort = "Out",
            endQuest = "177772045534914953119",
            endPort = "In"
          },
          {
            startQuest = "177772045534914953110",
            startPort = "Out",
            endQuest = "177883237185551202859",
            endPort = "In"
          },
          {
            startQuest = "177772045534914953118",
            startPort = "Out",
            endQuest = "177883241517551203582",
            endPort = "In"
          },
          {
            startQuest = "177883241517551203582",
            startPort = "Out",
            endQuest = "177772156256222433039",
            endPort = "In"
          },
          {
            startQuest = "177772045534914953121",
            startPort = "Out",
            endQuest = "177969833157741615706",
            endPort = "In"
          },
          {
            startQuest = "177969833157741615706",
            startPort = "Out",
            endQuest = "177969834552341616074",
            endPort = "In"
          },
          {
            startQuest = "177772045534914953111",
            startPort = "Out",
            endQuest = "177772045534914953115",
            endPort = "In"
          },
          {
            startQuest = "177772045534914953110",
            startPort = "Out",
            endQuest = "177969835122441616312",
            endPort = "In"
          },
          {
            startQuest = "177969835122441616312",
            startPort = "Out",
            endQuest = "17795210722591935845",
            endPort = "In"
          },
          {
            startQuest = "177969834552341616074",
            startPort = "Out",
            endQuest = "177772045534914953110",
            endPort = "In"
          },
          {
            startQuest = "177772045534914953107",
            startPort = "QuestStart",
            endQuest = "1779787486825797",
            endPort = "In"
          }
        },
        nodeData = {
          ["177772045534914953107"] = {
            key = "177772045534914953107",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 635, y = 340.90909090909093},
            propsData = {ModeType = 0}
          },
          ["177772045534914953108"] = {
            key = "177772045534914953108",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3426.9097507331376, y = 363.053054740958},
            propsData = {ModeType = 0}
          },
          ["177772045534914953109"] = {
            key = "177772045534914953109",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2253.076923076923, y = 843.0769230769231},
            propsData = {}
          },
          ["177772045534914953110"] = {
            key = "177772045534914953110",
            type = "TalkNode",
            name = "过场-Boss战出场",
            pos = {x = 1553.3158624396372, y = 182.38913955826388},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC020/SQ_Ver0104_SC020",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = false,
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
          ["177772045534914953111"] = {
            key = "177772045534914953111",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2041.3885187105693, y = 344.30403955290524},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "TrainBoss01Start",
              UnitId = -1
            }
          },
          ["177772045534914953112"] = {
            key = "177772045534914953112",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1903.5792376102154, y = -91.87744755244749},
            propsData = {
              NewDescription = "Content_10040505_02",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["177772045534914953115"] = {
            key = "177772045534914953115",
            type = "BossBattleFinishNode",
            name = "播完UI消息",
            pos = {x = 2568.0071934943826, y = 342.00652355185775},
            propsData = {
              SendMessage = "",
              FinishCondition = "TrainBoss01AndUISuccess"
            }
          },
          ["177772045534914953116"] = {
            key = "177772045534914953116",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 1096.604862389073, y = 704.1328794013003},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {272640056}
            }
          },
          ["177772045534914953117"] = {
            key = "177772045534914953117",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 1955.3503169345277, y = 603.9753036437248},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {272640057}
            }
          },
          ["177772045534914953118"] = {
            key = "177772045534914953118",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 2795.1725391567493, y = 392.90863697705817},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {272640057}
            }
          },
          ["177772045534914953119"] = {
            key = "177772045534914953119",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1187.1050027423096, y = 14.225605318707238},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272640060,
              GuideType = "M",
              GuidePointName = "Mechanism_KajiaBossPre_272640060"
            }
          },
          ["177772045534914953120"] = {
            key = "177772045534914953120",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1078.6634443007515, y = 975.223080066182},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177772045534914953121"] = {
            key = "177772045534914953121",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1449.4657531030603, y = 48.602589445691365},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049901_63.10049901_63'",
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
          ["177772155220222432681"] = {
            key = "177772155220222432681",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1584.1085791020573, y = 793.7960638776427},
            propsData = {}
          },
          ["177772156256222433039"] = {
            key = "177772156256222433039",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 3154.231756578177, y = 439.59546055939217},
            propsData = {}
          },
          ["177772167199224300208"] = {
            key = "177772167199224300208",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 942.6428571428569, y = 41.07142857142861},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_HaluojiEnd",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177883237185551202859"] = {
            key = "177883237185551202859",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 2029.099681020734, y = 197.67939735702885},
            propsData = {QuestRoleId = 11020201, IsPlayFX = false}
          },
          ["177883241517551203582"] = {
            key = "177883241517551203582",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 3135.0087719298244, y = 286.3157609933925},
            propsData = {}
          },
          ["17795210722591935845"] = {
            key = "17795210722591935845",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2428.5974358974363, y = 9.812179487179321},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0171_combat_lieche_loop.0171_combat_lieche_loop'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {106101},
              bStoreToServer = false
            }
          },
          ["177969833157741615706"] = {
            key = "177969833157741615706",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1578.7864635364633, y = -197.76541221935963},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          },
          ["177969834552341616074"] = {
            key = "177969834552341616074",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1869.1654845154844, y = -230.5304471843947},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0171_combat_lieche_intro.0171_combat_lieche_intro'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {106101},
              bStoreToServer = false
            }
          },
          ["177969835122441616312"] = {
            key = "177969835122441616312",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2075.703946053946, y = 3.700322046374609},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          },
          ["1779787486825797"] = {
            key = "1779787486825797",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1027.4343706307902, y = -165.2717615717614},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt03/0080_story_the_abandoned_theme.0080_story_the_abandoned_theme'",
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
