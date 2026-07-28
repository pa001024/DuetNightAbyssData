return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781167101917531769",
      startPort = "StoryStart",
      endStory = "1781167101917531771",
      endPort = "In"
    },
    {
      startStory = "1781167101917531771",
      startPort = "Success",
      endStory = "1781167101917531770",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781167101917531769"] = {
      isStoryNode = true,
      key = "1781167101917531769",
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
    ["1781167101917531770"] = {
      isStoryNode = true,
      key = "1781167101917531770",
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
    ["1781167101917531771"] = {
      isStoryNode = true,
      key = "1781167101917531771",
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
            startQuest = "1781167101917531776",
            startPort = "Out",
            endQuest = "1781167101917531778",
            endPort = "In"
          },
          {
            startQuest = "1781167101917531773",
            startPort = "QuestStart",
            endQuest = "1781167101917531776",
            endPort = "In"
          },
          {
            startQuest = "1781167101917531773",
            startPort = "QuestStart",
            endQuest = "1781167101917531777",
            endPort = "In"
          },
          {
            startQuest = "1781167101917531777",
            startPort = "Out",
            endQuest = "1781167101917531779",
            endPort = "In"
          },
          {
            startQuest = "17811691507937142710",
            startPort = "Out",
            endQuest = "1781167101917531774",
            endPort = "Success"
          },
          {
            startQuest = "1781167101917531779",
            startPort = "Out",
            endQuest = "17811691507937142710",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781167101917531773"] = {
            key = "1781167101917531773",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781167101917531774"] = {
            key = "1781167101917531774",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2159.505494505494, y = 549.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781167101917531775"] = {
            key = "1781167101917531775",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781167101917531776"] = {
            key = "1781167101917531776",
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
          ["1781167101917531777"] = {
            key = "1781167101917531777",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101901,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781167101917531778"] = {
            key = "1781167101917531778",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 101901,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781167101917531779"] = {
            key = "1781167101917531779",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "cp2thea2spspawnpoint3",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17811691507937142710"] = {
            key = "17811691507937142710",
            type = "TalkNode",
            name = "过场",
            pos = {x = 1609.8, y = 550.7431818181819},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0103/OBT0103_SC007/SQ_OBT0103_SC007",
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
