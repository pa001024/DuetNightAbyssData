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
      pos = {x = 1640, y = 271.99999999999994},
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
        SubRegionId = 106101,
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
            startQuest = "177772045534914953121",
            startPort = "Out",
            endQuest = "177772045534914953110",
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
            startQuest = "177772045534914953111",
            startPort = "Out",
            endQuest = "177772045534914953115",
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
            pos = {x = 1697.3158624396372, y = 271.3891395582639},
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
            pos = {x = 1999.348468379446, y = -73.41590909090903},
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
            pos = {x = 2453.776424263613, y = 347.7757543210885},
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
            pos = {x = 1278.1764313137382, y = 129.93989103299296},
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
            pos = {x = 1542.4657531030603, y = 69.60258944569136},
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
            pos = {x = 990.8571428571427, y = 44.28571428571433},
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
