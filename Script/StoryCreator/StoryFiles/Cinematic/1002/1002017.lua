return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178210884862211747655",
      startPort = "StoryStart",
      endStory = "178210884950711747701",
      endPort = "In"
    },
    {
      startStory = "178210884950711747701",
      startPort = "Success",
      endStory = "178210884862211747658",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178210884862211747655"] = {
      isStoryNode = true,
      key = "178210884862211747655",
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
    ["178210884862211747658"] = {
      isStoryNode = true,
      key = "178210884862211747658",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1931.6666666666665, y = 291.6666666666667},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178210884950711747701"] = {
      isStoryNode = true,
      key = "178210884950711747701",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1375.9485294117649, y = 366.66666666666663},
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
            startQuest = "178210884950711747709",
            startPort = "Out",
            endQuest = "178210884950711747711",
            endPort = "In"
          },
          {
            startQuest = "178210884950711747706",
            startPort = "QuestStart",
            endQuest = "178210884950711747709",
            endPort = "In"
          },
          {
            startQuest = "178210884950711747706",
            startPort = "QuestStart",
            endQuest = "178210884950711747710",
            endPort = "In"
          },
          {
            startQuest = "178210884950711747714",
            startPort = "Out",
            endQuest = "178210884950711747707",
            endPort = "Success"
          },
          {
            startQuest = "178210884950711747713",
            startPort = "Out",
            endQuest = "178210885984011748119",
            endPort = "In"
          },
          {
            startQuest = "178210885984011748119",
            startPort = "Out",
            endQuest = "178210884950711747714",
            endPort = "In"
          },
          {
            startQuest = "178210884950711747710",
            startPort = "Out",
            endQuest = "178210884950711747713",
            endPort = "In"
          }
        },
        nodeData = {
          ["178210884950711747706"] = {
            key = "178210884950711747706",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178210884950711747707"] = {
            key = "178210884950711747707",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["178210884950711747708"] = {
            key = "178210884950711747708",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178210884950711747709"] = {
            key = "178210884950711747709",
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
          ["178210884950711747710"] = {
            key = "178210884950711747710",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 897.2236293450444, y = 543.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101106,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178210884950711747711"] = {
            key = "178210884950711747711",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1528.38161521882, y = 321.9877653748314},
            propsData = {
              ModeType = 1,
              Id = 101106,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178210884950711747713"] = {
            key = "178210884950711747713",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1497.4564977167786, y = 534.1728874616209},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "TalkPoint_101093_EnlikeComeIn4",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178210884950711747714"] = {
            key = "178210884950711747714",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178210885984011748119"] = {
            key = "178210885984011748119",
            type = "TalkNode",
            name = "你在哭吗？",
            pos = {x = 1879.521453245426, y = 537.0532482648586},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC017/SQ_OBT0101_SC017",
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
              TalkActors = {},
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
