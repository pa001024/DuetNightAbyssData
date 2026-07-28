return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17817723193257473831",
      startPort = "StoryStart",
      endStory = "17817723201277473853",
      endPort = "In"
    },
    {
      startStory = "17817723201277473853",
      startPort = "Success",
      endStory = "17817723193257473834",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17817723193257473831"] = {
      isStoryNode = true,
      key = "17817723193257473831",
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
    ["17817723193257473834"] = {
      isStoryNode = true,
      key = "17817723193257473834",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2174, y = 372},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17817723201277473853"] = {
      isStoryNode = true,
      key = "17817723201277473853",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1632, y = 326},
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
            startQuest = "17817723201297473861",
            startPort = "Out",
            endQuest = "17817723201297473863",
            endPort = "In"
          },
          {
            startQuest = "17817723201277473858",
            startPort = "QuestStart",
            endQuest = "17817723201297473861",
            endPort = "In"
          },
          {
            startQuest = "17817723201277473858",
            startPort = "QuestStart",
            endQuest = "17817723201297473862",
            endPort = "In"
          },
          {
            startQuest = "17817723201297473866",
            startPort = "Out",
            endQuest = "17817723201277473859",
            endPort = "Success"
          },
          {
            startQuest = "17817723201297473865",
            startPort = "Out",
            endQuest = "17817728089197474461",
            endPort = "In"
          },
          {
            startQuest = "17817728089197474461",
            startPort = "Out",
            endQuest = "17817723201297473866",
            endPort = "In"
          },
          {
            startQuest = "17817723201297473862",
            startPort = "Out",
            endQuest = "17817723201297473865",
            endPort = "In"
          }
        },
        nodeData = {
          ["17817723201277473858"] = {
            key = "17817723201277473858",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17817723201277473859"] = {
            key = "17817723201277473859",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["17817723201277473860"] = {
            key = "17817723201277473860",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17817723201297473861"] = {
            key = "17817723201297473861",
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
          ["17817723201297473862"] = {
            key = "17817723201297473862",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 815.2236293450444, y = 549.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101105,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17817723201297473863"] = {
            key = "17817723201297473863",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 321.9877653748314},
            propsData = {
              ModeType = 1,
              Id = 101105,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17817723201297473865"] = {
            key = "17817723201297473865",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1497.4564977167786, y = 534.1728874616209},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_OuterHome",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17817723201297473866"] = {
            key = "17817723201297473866",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17817728089197474461"] = {
            key = "17817728089197474461",
            type = "TalkNode",
            name = "菲娜登场",
            pos = {x = 1818.2126438351752, y = 463.39719706967713},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "LevelSequence'/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC015/SQ_OBT0101_SC015.SQ_OBT0101_SC015'",
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
