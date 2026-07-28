return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17817653411832390",
      startPort = "StoryStart",
      endStory = "17817653418052420",
      endPort = "In"
    },
    {
      startStory = "17817653418052420",
      startPort = "Success",
      endStory = "17817653411832393",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17817653411832390"] = {
      isStoryNode = true,
      key = "17817653411832390",
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
    ["17817653411832393"] = {
      isStoryNode = true,
      key = "17817653411832393",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1774, y = 328},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17817653418052420"] = {
      isStoryNode = true,
      key = "17817653418052420",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1274, y = 322},
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
            startQuest = "17817653418062428",
            startPort = "Out",
            endQuest = "17817653418062430",
            endPort = "In"
          },
          {
            startQuest = "17817653418062425",
            startPort = "QuestStart",
            endQuest = "17817653418062428",
            endPort = "In"
          },
          {
            startQuest = "17817653418062425",
            startPort = "QuestStart",
            endQuest = "17817653418062429",
            endPort = "In"
          },
          {
            startQuest = "17817653418062435",
            startPort = "Out",
            endQuest = "17817653418062426",
            endPort = "Success"
          },
          {
            startQuest = "17817663290221069059",
            startPort = "Out",
            endQuest = "17817653418062435",
            endPort = "In"
          },
          {
            startQuest = "17817653418062433",
            startPort = "Out",
            endQuest = "17817663290221069059",
            endPort = "In"
          },
          {
            startQuest = "17817653418062429",
            startPort = "Out",
            endQuest = "17817653418062433",
            endPort = "In"
          }
        },
        nodeData = {
          ["17817653418062425"] = {
            key = "17817653418062425",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17817653418062426"] = {
            key = "17817653418062426",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["17817653418062427"] = {
            key = "17817653418062427",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17817653418062428"] = {
            key = "17817653418062428",
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
          ["17817653418062429"] = {
            key = "17817653418062429",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 549.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101103,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17817653418062430"] = {
            key = "17817653418062430",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 101103,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17817653418062433"] = {
            key = "17817653418062433",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1366.742212002493, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint_10020102",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17817653418062435"] = {
            key = "17817653418062435",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17817663290221069059"] = {
            key = "17817663290221069059",
            type = "TalkNode",
            name = "苏醒过场",
            pos = {x = 1921.826312668537, y = 517.0263157894736},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC001/SQ_OBT0101_SC001",
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
