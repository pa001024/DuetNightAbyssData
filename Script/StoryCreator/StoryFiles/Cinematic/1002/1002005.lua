return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17817711985156405786",
      startPort = "StoryStart",
      endStory = "17817711989996405811",
      endPort = "In"
    },
    {
      startStory = "17817711989996405811",
      startPort = "Success",
      endStory = "17817711985156405789",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17817711985156405786"] = {
      isStoryNode = true,
      key = "17817711985156405786",
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
    ["17817711985156405789"] = {
      isStoryNode = true,
      key = "17817711985156405789",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2800, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17817711989996405811"] = {
      isStoryNode = true,
      key = "17817711989996405811",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1732, y = 382},
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
            startQuest = "17817711989996405819",
            startPort = "Out",
            endQuest = "17817711989996405821",
            endPort = "In"
          },
          {
            startQuest = "17817711989996405816",
            startPort = "QuestStart",
            endQuest = "17817711989996405819",
            endPort = "In"
          },
          {
            startQuest = "17817711989996405816",
            startPort = "QuestStart",
            endQuest = "17817711989996405820",
            endPort = "In"
          },
          {
            startQuest = "17817711989996405824",
            startPort = "Out",
            endQuest = "17817711989996405817",
            endPort = "Success"
          },
          {
            startQuest = "17817711989996405823",
            startPort = "Out",
            endQuest = "17817713100876406098",
            endPort = "In"
          },
          {
            startQuest = "17817713100876406098",
            startPort = "Out",
            endQuest = "17817711989996405824",
            endPort = "In"
          },
          {
            startQuest = "17817711989996405820",
            startPort = "Out",
            endQuest = "17817711989996405823",
            endPort = "In"
          }
        },
        nodeData = {
          ["17817711989996405816"] = {
            key = "17817711989996405816",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17817711989996405817"] = {
            key = "17817711989996405817",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["17817711989996405818"] = {
            key = "17817711989996405818",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17817711989996405819"] = {
            key = "17817711989996405819",
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
          ["17817711989996405820"] = {
            key = "17817711989996405820",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 815.2236293450444, y = 549.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101304,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17817711989996405821"] = {
            key = "17817711989996405821",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 321.9877653748314},
            propsData = {
              ModeType = 1,
              Id = 101304,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17817711989996405823"] = {
            key = "17817711989996405823",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1497.4564977167786, y = 534.1728874616209},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint_SJZBossWake",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17817711989996405824"] = {
            key = "17817711989996405824",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17817713100876406098"] = {
            key = "17817713100876406098",
            type = "TalkNode",
            name = "过场动画 宝石争夺",
            pos = {x = 1792.8751745038385, y = 541.197197069677},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC005/SQ_OBT0101_SC005",
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
