return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17805611885974541826",
      startPort = "StoryStart",
      endStory = "17805611885974541828",
      endPort = "In"
    },
    {
      startStory = "17805611885974541828",
      startPort = "Success",
      endStory = "17805611885974541827",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17805611885974541826"] = {
      isStoryNode = true,
      key = "17805611885974541826",
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
    ["17805611885974541827"] = {
      isStoryNode = true,
      key = "17805611885974541827",
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
    ["17805611885974541828"] = {
      isStoryNode = true,
      key = "17805611885974541828",
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
            startQuest = "17805611885974541832",
            startPort = "Out",
            endQuest = "17805611885974541834",
            endPort = "In"
          },
          {
            startQuest = "17805611885974541829",
            startPort = "QuestStart",
            endQuest = "17805611885974541832",
            endPort = "In"
          },
          {
            startQuest = "17805611885974541829",
            startPort = "QuestStart",
            endQuest = "17805611885974541833",
            endPort = "In"
          },
          {
            startQuest = "17805611885974541833",
            startPort = "Out",
            endQuest = "17805611885974541835",
            endPort = "In"
          },
          {
            startQuest = "17805611885974541835",
            startPort = "Out",
            endQuest = "178056459933817093446",
            endPort = "In"
          },
          {
            startQuest = "178056459933817093446",
            startPort = "Out",
            endQuest = "178056458457317093190",
            endPort = "In"
          },
          {
            startQuest = "178056458457317093190",
            startPort = "Out",
            endQuest = "17805611885974541830",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17805611885974541829"] = {
            key = "17805611885974541829",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17805611885974541830"] = {
            key = "17805611885974541830",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2273.809523809523, y = 582.6190476190477},
            propsData = {ModeType = 0}
          },
          ["17805611885974541831"] = {
            key = "17805611885974541831",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17805611885974541832"] = {
            key = "17805611885974541832",
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
          ["17805611885974541833"] = {
            key = "17805611885974541833",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 910.3478529475288, y = 542.6907120531213},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 100101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17805611885974541834"] = {
            key = "17805611885974541834",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 100101,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17805611885974541835"] = {
            key = "17805611885974541835",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1262.2701623130522, y = 549.7318936728011},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint5_10010107",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178056458457317093190"] = {
            key = "178056458457317093190",
            type = "TalkNode",
            name = "过场-100104-拿剑",
            pos = {x = 1871.142857142857, y = 569.7142857142857},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC004/SQ_OBT0100_SC004",
              InType = "BlendIn",
              OutType = "BlendOut",
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
          },
          ["178056459933817093446"] = {
            key = "178056459933817093446",
            type = "PlayOrStopBGMNode",
            name = "BGM - cunzhuang - end",
            pos = {x = 1575.7142857142858, y = 559.7142857142858},
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
