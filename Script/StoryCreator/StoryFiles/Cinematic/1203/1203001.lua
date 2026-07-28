return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781145114290989",
      startPort = "Success",
      endStory = "1781145091634832",
      endPort = "StoryEnd"
    },
    {
      startStory = "1781145091634829",
      startPort = "StoryStart",
      endStory = "1781145114290989",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["1781145091634829"] = {
      isStoryNode = true,
      key = "1781145091634829",
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
    ["1781145091634832"] = {
      isStoryNode = true,
      key = "1781145091634832",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1604, y = 302},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1781145114290989"] = {
      isStoryNode = true,
      key = "1781145114290989",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1201.4782608695652, y = 292.69565217391306},
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
            startQuest = "17811451262121466",
            startPort = "Out",
            endQuest = "17811451262121467",
            endPort = "In"
          },
          {
            startQuest = "1781145114290990",
            startPort = "QuestStart",
            endQuest = "17811451262121466",
            endPort = "In"
          },
          {
            startQuest = "1781145114290990",
            startPort = "QuestStart",
            endQuest = "17811451303211575",
            endPort = "In"
          },
          {
            startQuest = "17811456510213649",
            startPort = "Out",
            endQuest = "1781145114290993",
            endPort = "Success"
          },
          {
            startQuest = "17811451303211575",
            startPort = "Out",
            endQuest = "17811601728724071016",
            endPort = "In"
          },
          {
            startQuest = "17811601728724071016",
            startPort = "Out",
            endQuest = "17811601872324071216",
            endPort = "In"
          },
          {
            startQuest = "17811601872324071216",
            startPort = "Out",
            endQuest = "17811456510213649",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781145114290990"] = {
            key = "1781145114290990",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781145114290993"] = {
            key = "1781145114290993",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2245.7727272727275, y = 404.90909090909093},
            propsData = {ModeType = 0}
          },
          ["1781145114290996"] = {
            key = "1781145114290996",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17811451262121466"] = {
            key = "17811451262121466",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1121.4920748841803, y = 204.76753893481157},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17811451262121467"] = {
            key = "17811451262121467",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1402.8650679729626, y = 210.56597251877147},
            propsData = {
              ModeType = 1,
              Id = 104503,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17811451303211575"] = {
            key = "17811451303211575",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1118.9285714285713, y = 404.42857142857144},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104503,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17811456510213649"] = {
            key = "17811456510213649",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1960.4018915866745, y = 406.79853041695145},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17811601728724071016"] = {
            key = "17811601728724071016",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1399.7142857142858, y = 406.57142857142856},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_NewTargetPoint_12030201",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17811601872324071216"] = {
            key = "17811601872324071216",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1680, y = 408},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0103/Ver0103_SC001/Ver0103_SC001_P2",
              InType = "BlendIn",
              OutType = "BlendOut",
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = false,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = true,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = true,
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
