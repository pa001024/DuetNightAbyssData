return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178005279953813302758",
      startPort = "StoryStart",
      endStory = "178005279953813302760",
      endPort = "In"
    },
    {
      startStory = "178005279953813302760",
      startPort = "Success",
      endStory = "178005279953813302759",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178005279953813302758"] = {
      isStoryNode = true,
      key = "178005279953813302758",
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
    ["178005279953813302759"] = {
      isStoryNode = true,
      key = "178005279953813302759",
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
    ["178005279953813302760"] = {
      isStoryNode = true,
      key = "178005279953813302760",
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
            startQuest = "178005279953813302764",
            startPort = "Out",
            endQuest = "178005279953813302766",
            endPort = "In"
          },
          {
            startQuest = "178005279953813302761",
            startPort = "QuestStart",
            endQuest = "178005279953813302764",
            endPort = "In"
          },
          {
            startQuest = "178005279953813302761",
            startPort = "QuestStart",
            endQuest = "178005279953813302765",
            endPort = "In"
          },
          {
            startQuest = "178005279953813302765",
            startPort = "Out",
            endQuest = "178005279953813302767",
            endPort = "In"
          },
          {
            startQuest = "178005276650612794260",
            startPort = "Out",
            endQuest = "178005275975412794094",
            endPort = "In"
          },
          {
            startQuest = "178005279953813302767",
            startPort = "Out",
            endQuest = "178005276650612794260",
            endPort = "In"
          },
          {
            startQuest = "178005275975412794094",
            startPort = "Out",
            endQuest = "17805636259899050675",
            endPort = "In"
          },
          {
            startQuest = "17805636259899050675",
            startPort = "Out",
            endQuest = "178005279953813302762",
            endPort = "Success"
          }
        },
        nodeData = {
          ["178005275975412794094"] = {
            key = "178005275975412794094",
            type = "TalkNode",
            name = "过场-100116-士兵找人-SC07",
            pos = {x = 1770.6363636363637, y = 555.3636363636364},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC007/SQ_OBT0100_SC007",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "FadeIn",
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
          ["178005276650612794260"] = {
            key = "178005276650612794260",
            type = "PlayOrStopBGMNode",
            name = "BGM - shendianyiji - Stop(MUTE)",
            pos = {x = 1501.212637207993, y = 577.0778014555104},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["178005279953813302761"] = {
            key = "178005279953813302761",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178005279953813302762"] = {
            key = "178005279953813302762",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2314.9600399600395, y = 571.6533466533468},
            propsData = {ModeType = 0}
          },
          ["178005279953813302763"] = {
            key = "178005279953813302763",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178005279953813302764"] = {
            key = "178005279953813302764",
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
          ["178005279953813302765"] = {
            key = "178005279953813302765",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 100103,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178005279953813302766"] = {
            key = "178005279953813302766",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 100103,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178005279953813302767"] = {
            key = "178005279953813302767",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_NewTargetPoint10010301BP_NewTargetPoint10010301",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17805636259899050675"] = {
            key = "17805636259899050675",
            type = "PlayOrStopBGMNode",
            name = "BGM - shendianyiji - Stop(MUTE)",
            pos = {x = 2023.6022727272725, y = 570.8484848484848},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
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
