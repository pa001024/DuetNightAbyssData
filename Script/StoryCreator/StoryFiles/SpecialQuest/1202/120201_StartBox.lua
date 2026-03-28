return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17621726816923025229",
      startPort = "StoryStart",
      endStory = "17621726816923025231",
      endPort = "In"
    },
    {
      startStory = "17621726816923025231",
      startPort = "Success",
      endStory = "17621726816923025230",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17621726816923025229"] = {
      isStoryNode = true,
      key = "17621726816923025229",
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
    ["17621726816923025230"] = {
      isStoryNode = true,
      key = "17621726816923025230",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2800, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17621726816923025231"] = {
      isStoryNode = true,
      key = "17621726816923025231",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1714, y = 300},
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
            startQuest = "17621726816923025232",
            startPort = "QuestStart",
            endQuest = "17621726816923025235",
            endPort = "In"
          },
          {
            startQuest = "17621726816923025232",
            startPort = "QuestStart",
            endQuest = "17621726816923025241",
            endPort = "In"
          },
          {
            startQuest = "17621726816923025235",
            startPort = "Out",
            endQuest = "17621726816923025236",
            endPort = "In"
          },
          {
            startQuest = "17621726816923025236",
            startPort = "Out",
            endQuest = "1774180185389592",
            endPort = "In"
          },
          {
            startQuest = "1774180185389592",
            startPort = "Out",
            endQuest = "17621726816923025240",
            endPort = "In"
          },
          {
            startQuest = "1774181307621480",
            startPort = "Out",
            endQuest = "17621726816923025234",
            endPort = "Fail"
          },
          {
            startQuest = "17621726816923025241",
            startPort = "Out",
            endQuest = "1774181307621480",
            endPort = "In"
          }
        },
        nodeData = {
          ["17621726816923025232"] = {
            key = "17621726816923025232",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17621726816923025233"] = {
            key = "17621726816923025233",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17621726816923025234"] = {
            key = "17621726816923025234",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2447.419972809294, y = 688.8352939854609},
            propsData = {}
          },
          ["17621726816923025235"] = {
            key = "17621726816923025235",
            type = "TalkNode",
            name = "过场 - 小黑屋",
            pos = {x = 1376.9144943560955, y = 336.716003163279},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC001/SQ_Ver0102_SC001",
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
              HideMechanismsFX = true,
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
                  TalkActorVisible = false,
                  AroundPlayer = false
                }
              },
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["17621726816923025236"] = {
            key = "17621726816923025236",
            type = "TalkNode",
            name = "【East02_FixSimple_01】主角与止流在止流幻境争执",
            pos = {x = 1640.9292325816677, y = 340.02648049685166},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1202/12040101.12040101'",
              TalkType = "FixSimple",
              TalkStageName = "East02_12020101",
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
              OptionType = "normal",
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17621726816923025237"] = {
            key = "17621726816923025237",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1352.5710064240031, y = 750.810417352057},
            propsData = {
              ModeType = 1,
              Id = 105602,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17621726816923025238"] = {
            key = "17621726816923025238",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1668.2088555122996, y = 805.1672740833374},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
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
              TalkActors = {},
              OptionType = "normal",
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17621726816923025239"] = {
            key = "17621726816923025239",
            type = "JudgeRegionNode",
            name = "判断位于区域",
            pos = {x = 1100.3372994276456, y = 740.6228547749586},
            propsData = {
              IsWaitingEnterRegion = false,
              RegionIds = {}
            }
          },
          ["17621726816923025240"] = {
            key = "17621726816923025240",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2210.627973366831, y = 330.86732552718837},
            propsData = {}
          },
          ["17621726816923025241"] = {
            key = "17621726816923025241",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1641.0573679256297, y = 575.8767926607802},
            propsData = {}
          },
          ["1774180185389592"] = {
            key = "1774180185389592",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1935.1875, y = 368.90340909090907},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          },
          ["1774181307621480"] = {
            key = "1774181307621480",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2016.3434343434346, y = 599.2864768082158},
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
