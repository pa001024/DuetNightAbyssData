return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17821160791913765661",
      startPort = "StoryStart",
      endStory = "17821160791913765663",
      endPort = "In"
    },
    {
      startStory = "17821160791913765663",
      startPort = "Success",
      endStory = "17821160791913765662",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17821160791913765661"] = {
      isStoryNode = true,
      key = "17821160791913765661",
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
    ["17821160791913765662"] = {
      isStoryNode = true,
      key = "17821160791913765662",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2354, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17821160791913765663"] = {
      isStoryNode = true,
      key = "17821160791913765663",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1596, y = 298},
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
            startQuest = "17821160791913765667",
            startPort = "Out",
            endQuest = "17821160791913765669",
            endPort = "In"
          },
          {
            startQuest = "17821160791913765664",
            startPort = "QuestStart",
            endQuest = "17821160791913765667",
            endPort = "In"
          },
          {
            startQuest = "17821160791913765664",
            startPort = "QuestStart",
            endQuest = "17821160791913765668",
            endPort = "In"
          },
          {
            startQuest = "17821160791913765670",
            startPort = "Out",
            endQuest = "17821160791913765665",
            endPort = "Success"
          },
          {
            startQuest = "17821160791913765668",
            startPort = "Out",
            endQuest = "17821160791913765670",
            endPort = "In"
          }
        },
        nodeData = {
          ["17821160791913765664"] = {
            key = "17821160791913765664",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17821160791913765665"] = {
            key = "17821160791913765665",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2717.894736842105, y = 543.1578947368422},
            propsData = {ModeType = 0}
          },
          ["17821160791913765666"] = {
            key = "17821160791913765666",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2752.6315789473683, y = 816.8421052631579},
            propsData = {}
          },
          ["17821160791913765667"] = {
            key = "17821160791913765667",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1102.7046601440443, y = 310.83896750624024},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17821160791913765668"] = {
            key = "17821160791913765668",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1162.8984780220724, y = 533.7144896449201},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101105,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17821160791913765669"] = {
            key = "17821160791913765669",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1678.7205103756837, y = 315.994543947343},
            propsData = {
              ModeType = 1,
              Id = 101105,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17821160791913765670"] = {
            key = "17821160791913765670",
            type = "TalkNode",
            name = "SC03【过场】晚会",
            pos = {x = 2074, y = 530.5},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Activity/Activity_Feina/Activity_Feina_SC003/SQ_Activity_Feina_SC003",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = true,
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
