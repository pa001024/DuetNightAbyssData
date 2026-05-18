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
      pos = {x = 1035.4857142857143, y = 87.02857142857157},
      propsData = {
        QuestId = 10040310,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040310_01",
        QuestDeatil = "Description_10040310_01",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
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
            endQuest = "17782435125899548990",
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
          }
        },
        nodeData = {
          ["17782435125899548983"] = {
            key = "17782435125899548983",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 875.4515050167224, y = 284.6488294314381},
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
            pos = {x = 1479.3333333333333, y = 658.3333333333333},
            propsData = {}
          },
          ["17782435125899548987"] = {
            key = "17782435125899548987",
            type = "SendMessageNode",
            name = "开始精英战",
            pos = {x = 1484.25, y = 293.75},
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
            pos = {x = 1792.7845420521971, y = 294.7201949652307},
            propsData = {
              SendMessage = "",
              FinishCondition = "ZZZBossSuccess"
            }
          },
          ["17782435125899548989"] = {
            key = "17782435125899548989",
            type = "TalkNode",
            name = "boss战后对话",
            pos = {x = 2083.784542052197, y = 301.7201949652307},
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
            pos = {x = 1474.2837528604118, y = 121.11441647597252},
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
            pos = {x = 1164.5384615384617, y = 119.53846153846149},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177875047920110697597"] = {
            key = "177875047920110697597",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1168.5857843137255, y = 455.32843137254906},
            propsData = {}
          },
          ["17787573698991751"] = {
            key = "17787573698991751",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 1486, y = 468.00000000000006},
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
            pos = {x = 2080, y = 464.00000000000006},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {152480405}
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
