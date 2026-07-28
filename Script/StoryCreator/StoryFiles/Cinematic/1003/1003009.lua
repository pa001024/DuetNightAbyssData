return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781167101918532033",
      startPort = "StoryStart",
      endStory = "1781167101918532035",
      endPort = "In"
    },
    {
      startStory = "1781167101918532035",
      startPort = "Success",
      endStory = "1781167101918532034",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781167101918532033"] = {
      isStoryNode = true,
      key = "1781167101918532033",
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
    ["1781167101918532034"] = {
      isStoryNode = true,
      key = "1781167101918532034",
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
    ["1781167101918532035"] = {
      isStoryNode = true,
      key = "1781167101918532035",
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
            startQuest = "1781167101918532040",
            startPort = "Out",
            endQuest = "1781167101918532042",
            endPort = "In"
          },
          {
            startQuest = "1781167101918532037",
            startPort = "QuestStart",
            endQuest = "1781167101918532040",
            endPort = "In"
          },
          {
            startQuest = "1781167101918532037",
            startPort = "QuestStart",
            endQuest = "1781167101918532041",
            endPort = "In"
          },
          {
            startQuest = "1781167101918532041",
            startPort = "Out",
            endQuest = "1781167101918532043",
            endPort = "In"
          },
          {
            startQuest = "17811693620439183277",
            startPort = "Out",
            endQuest = "17811693620439183276",
            endPort = "In"
          },
          {
            startQuest = "1781167101918532043",
            startPort = "Out",
            endQuest = "17811693620439183277",
            endPort = "In"
          },
          {
            startQuest = "17811693620439183276",
            startPort = "Out",
            endQuest = "17811693695419183536",
            endPort = "In"
          },
          {
            startQuest = "17811693695419183536",
            startPort = "Out",
            endQuest = "1781167101918532038",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781167101918532037"] = {
            key = "1781167101918532037",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781167101918532038"] = {
            key = "1781167101918532038",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2273.9499389499383, y = 549.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781167101918532039"] = {
            key = "1781167101918532039",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781167101918532040"] = {
            key = "1781167101918532040",
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
          ["1781167101918532041"] = {
            key = "1781167101918532041",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 103201,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781167101918532042"] = {
            key = "1781167101918532042",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 103201,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781167101918532043"] = {
            key = "1781167101918532043",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "alchSpawnPoint",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17811693620439183276"] = {
            key = "17811693620439183276",
            type = "TalkNode",
            name = "改造动画",
            pos = {x = 1759.1468107871935, y = 639.3853091353092},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0103/OBT0103_SC009/SQ_OBT0103_SC009",
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
              TalkActors = {},
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["17811693620439183277"] = {
            key = "17811693620439183277",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1481.3055701651863, y = 622.1702464202464},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/cbt03/0081_scene_alchemyacademy",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {103201}
            }
          },
          ["17811693695419183536"] = {
            key = "17811693695419183536",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1998.0000000000002, y = 644.6666666666666},
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
