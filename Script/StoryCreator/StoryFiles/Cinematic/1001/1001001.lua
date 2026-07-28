return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17800509517171491403",
      startPort = "StoryStart",
      endStory = "17800509517171491405",
      endPort = "In"
    },
    {
      startStory = "17800509517171491405",
      startPort = "Success",
      endStory = "17800509517171491404",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17800509517171491403"] = {
      isStoryNode = true,
      key = "17800509517171491403",
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
    ["17800509517171491404"] = {
      isStoryNode = true,
      key = "17800509517171491404",
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
    ["17800509517171491405"] = {
      isStoryNode = true,
      key = "17800509517171491405",
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
            startQuest = "17800509517171491409",
            startPort = "Out",
            endQuest = "17800509517171491411",
            endPort = "In"
          },
          {
            startQuest = "17800509517171491406",
            startPort = "QuestStart",
            endQuest = "17800509517171491409",
            endPort = "In"
          },
          {
            startQuest = "17800509517171491406",
            startPort = "QuestStart",
            endQuest = "17800509517171491410",
            endPort = "In"
          },
          {
            startQuest = "17800509517171491410",
            startPort = "Out",
            endQuest = "17800509517171491412",
            endPort = "In"
          },
          {
            startQuest = "17800494870931187",
            startPort = "Out",
            endQuest = "17800509517171491407",
            endPort = "Success"
          },
          {
            startQuest = "17800509517171491412",
            startPort = "Out",
            endQuest = "17800494870931187",
            endPort = "In"
          }
        },
        nodeData = {
          ["17800494870931187"] = {
            key = "17800494870931187",
            type = "TalkNode",
            name = "过场-sc001-黑桃战斗",
            pos = {x = 1615.023785425101, y = 560.7191295546559},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC001/SQ_OBT0100_SC001",
              InType = "BlendIn",
              OutType = "BlendOut",
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
          ["17800509517171491406"] = {
            key = "17800509517171491406",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17800509517171491407"] = {
            key = "17800509517171491407",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2159.505494505494, y = 549.835164835165},
            propsData = {ModeType = 0}
          },
          ["17800509517171491408"] = {
            key = "17800509517171491408",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17800509517171491409"] = {
            key = "17800509517171491409",
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
          ["17800509517171491410"] = {
            key = "17800509517171491410",
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
          ["17800509517171491411"] = {
            key = "17800509517171491411",
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
          ["17800509517171491412"] = {
            key = "17800509517171491412",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Quest_TargetPoint_BOSS",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
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
