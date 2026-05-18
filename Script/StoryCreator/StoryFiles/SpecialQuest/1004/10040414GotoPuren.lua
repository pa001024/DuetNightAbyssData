return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177874791789222394297",
      startPort = "StoryStart",
      endStory = "177874791985022394340",
      endPort = "In"
    },
    {
      startStory = "177874791985022394340",
      startPort = "Success",
      endStory = "177874791789222394300",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177874791789222394297"] = {
      isStoryNode = true,
      key = "177874791789222394297",
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
    ["177874791789222394300"] = {
      isStoryNode = true,
      key = "177874791789222394300",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1616, y = 226},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874791985022394340"] = {
      isStoryNode = true,
      key = "177874791985022394340",
      type = "StoryNode",
      name = "前往仆人车厢",
      pos = {x = 1250, y = 204},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040408_01",
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
            startQuest = "177874791985022394348",
            startPort = "Out",
            endQuest = "177874791985022394349",
            endPort = "In"
          },
          {
            startQuest = "177874791985022394345",
            startPort = "QuestStart",
            endQuest = "177874791985022394350",
            endPort = "In"
          },
          {
            startQuest = "177874791985022394352",
            startPort = "Out",
            endQuest = "177874791985022394351",
            endPort = "In"
          },
          {
            startQuest = "177874791985022394345",
            startPort = "QuestStart",
            endQuest = "177874791985022394352",
            endPort = "In"
          },
          {
            startQuest = "177874791985022394349",
            startPort = "Out",
            endQuest = "177874791985022394353",
            endPort = "In"
          },
          {
            startQuest = "177874791985022394345",
            startPort = "QuestStart",
            endQuest = "177874791985022394354",
            endPort = "In"
          },
          {
            startQuest = "177874791985022394353",
            startPort = "Out",
            endQuest = "177874795010822394846",
            endPort = "In"
          },
          {
            startQuest = "177874791985022394345",
            startPort = "QuestStart",
            endQuest = "177874796027822395084",
            endPort = "In"
          },
          {
            startQuest = "177874796027822395084",
            startPort = "Out",
            endQuest = "177874791985022394347",
            endPort = "Fail"
          },
          {
            startQuest = "177874791985022394345",
            startPort = "QuestStart",
            endQuest = "177875505879637018038",
            endPort = "In"
          },
          {
            startQuest = "177875505879637018038",
            startPort = "Out",
            endQuest = "177874791985022394348",
            endPort = "In"
          }
        },
        nodeData = {
          ["177874791985022394345"] = {
            key = "177874791985022394345",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 516, y = 398},
            propsData = {ModeType = 0}
          },
          ["177874791985022394346"] = {
            key = "177874791985022394346",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2704.252631578947, y = 419.87368421052633},
            propsData = {ModeType = 0}
          },
          ["177874791985022394347"] = {
            key = "177874791985022394347",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1886, y = 1012},
            propsData = {}
          },
          ["177874791985022394348"] = {
            key = "177874791985022394348",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1501.2987012987014, y = 387.27272727272725},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272640003,
              GuideType = "M",
              GuidePointName = "Mechanism_GetPuren_272640003"
            }
          },
          ["177874791985022394349"] = {
            key = "177874791985022394349",
            type = "TalkNode",
            name = "仆人车厢对话",
            pos = {x = 1815.2, y = 409.2},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10046701.10046701'",
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
          ["177874791985022394350"] = {
            key = "177874791985022394350",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 1547.657894736842, y = 800.0789473684212},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = true,
              IsSync = false,
              StaticCreatorIdList = {272640053}
            }
          },
          ["177874791985022394351"] = {
            key = "177874791985022394351",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1840, y = 220},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "OpenGate04Behind",
              UnitId = -1
            }
          },
          ["177874791985022394352"] = {
            key = "177874791985022394352",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1516, y = 208},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "OpenGate03Front",
              UnitId = -1
            }
          },
          ["177874791985022394353"] = {
            key = "177874791985022394353",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 2103.0526315789475, y = 412.84210526315786},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {272640053}
            }
          },
          ["177874791985022394354"] = {
            key = "177874791985022394354",
            type = "ChangeRoleNode",
            name = "切换为主角",
            pos = {x = 1542, y = 582},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177874795010822394846"] = {
            key = "177874795010822394846",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2416, y = 396},
            propsData = {}
          },
          ["177874796027822395084"] = {
            key = "177874796027822395084",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1552, y = 1002},
            propsData = {}
          },
          ["177875505879637018038"] = {
            key = "177875505879637018038",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1131.847910216718, y = 390.03405572755423},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_ShouweiGoon",
              FadeIn = false,
              FadeOut = true,
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
