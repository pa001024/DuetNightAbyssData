return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742446536538",
      startPort = "StoryStart",
      endStory = "1781144742446536540",
      endPort = "In"
    },
    {
      startStory = "1781144742446536540",
      startPort = "Success",
      endStory = "1781144742446536539",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742446536538"] = {
      isStoryNode = true,
      key = "1781144742446536538",
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
    ["1781144742446536539"] = {
      isStoryNode = true,
      key = "1781144742446536539",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1976, y = 342},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1781144742446536540"] = {
      isStoryNode = true,
      key = "1781144742446536540",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1266, y = 272},
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
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1781144742446536547",
            startPort = "Out",
            endQuest = "1781144742446536549",
            endPort = "In"
          },
          {
            startQuest = "1781144742446536544",
            startPort = "QuestStart",
            endQuest = "1781144742446536547",
            endPort = "In"
          },
          {
            startQuest = "1781144742446536544",
            startPort = "QuestStart",
            endQuest = "1781144742446536548",
            endPort = "In"
          },
          {
            startQuest = "1781144742446536548",
            startPort = "Out",
            endQuest = "1781144742446536550",
            endPort = "In"
          },
          {
            startQuest = "1781144742446536550",
            startPort = "Out",
            endQuest = "178116257617610292763",
            endPort = "In"
          },
          {
            startQuest = "178116257617610292763",
            startPort = "Out",
            endQuest = "1781144742446536541",
            endPort = "In"
          },
          {
            startQuest = "1781144742446536541",
            startPort = "Out",
            endQuest = "1781144742446536545",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781144742446536541"] = {
            key = "1781144742446536541",
            type = "TalkNode",
            name = "审判刻舟（下）共战太皓",
            pos = {x = 1860.857142857143, y = 579.7142857142858},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC005/SQ_Ver0102_SC005",
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = true,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
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
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["1781144742446536544"] = {
            key = "1781144742446536544",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742446536545"] = {
            key = "1781144742446536545",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2408.095238095237, y = 582.6190476190477},
            propsData = {ModeType = 0}
          },
          ["1781144742446536546"] = {
            key = "1781144742446536546",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742446536547"] = {
            key = "1781144742446536547",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1207.6839468053622, y = 303.4843628467721},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742446536548"] = {
            key = "1781144742446536548",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 910.3478529475288, y = 542.6907120531213},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104506,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742446536549"] = {
            key = "1781144742446536549",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 104506,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742446536550"] = {
            key = "1781144742446536550",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1262.2701623130522, y = 549.7318936728011},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "12020209teshu_242440006",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178116257617610292763"] = {
            key = "178116257617610292763",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1571.2798573975044, y = 597.220568859955},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_3/0138_cs_kezhou_attack_bailong.0138_cs_kezhou_attack_bailong'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
