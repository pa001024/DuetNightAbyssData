return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178211051987616021788",
      startPort = "StoryStart",
      endStory = "178211052047316021819",
      endPort = "In"
    },
    {
      startStory = "178211052047316021819",
      startPort = "Success",
      endStory = "178211051987716021791",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178211051987616021788"] = {
      isStoryNode = true,
      key = "178211051987616021788",
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
    ["178211051987716021791"] = {
      isStoryNode = true,
      key = "178211051987716021791",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2110, y = 390},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178211052047316021819"] = {
      isStoryNode = true,
      key = "178211052047316021819",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1516, y = 330},
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
            startQuest = "178211052047316021827",
            startPort = "Out",
            endQuest = "178211052047316021829",
            endPort = "In"
          },
          {
            startQuest = "178211052047316021824",
            startPort = "QuestStart",
            endQuest = "178211052047316021827",
            endPort = "In"
          },
          {
            startQuest = "178211052047316021824",
            startPort = "QuestStart",
            endQuest = "178211052047316021828",
            endPort = "In"
          },
          {
            startQuest = "178211052047316021832",
            startPort = "Out",
            endQuest = "178211052047316021825",
            endPort = "Success"
          },
          {
            startQuest = "178211052047316021831",
            startPort = "Out",
            endQuest = "178211060498816022198",
            endPort = "In"
          },
          {
            startQuest = "178211060498816022198",
            startPort = "Out",
            endQuest = "178211052047316021832",
            endPort = "In"
          },
          {
            startQuest = "178211052047316021828",
            startPort = "Out",
            endQuest = "178211052047316021831",
            endPort = "In"
          }
        },
        nodeData = {
          ["178211052047316021824"] = {
            key = "178211052047316021824",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178211052047316021825"] = {
            key = "178211052047316021825",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["178211052047316021826"] = {
            key = "178211052047316021826",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178211052047316021827"] = {
            key = "178211052047316021827",
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
          ["178211052047316021828"] = {
            key = "178211052047316021828",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 840.2236293450444, y = 546.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101106,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178211052047316021829"] = {
            key = "178211052047316021829",
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
          ["178211052047316021831"] = {
            key = "178211052047316021831",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1497.4564977167786, y = 534.1728874616209},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "P101108Nvzhu1",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178211052047316021832"] = {
            key = "178211052047316021832",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178211060498816022198"] = {
            key = "178211060498816022198",
            type = "TalkNode",
            name = "救救赛琪",
            pos = {x = 1866.5214532454256, y = 563.0532482648587},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC019/SQ_OBT0101_SC019",
              BlendOutTime = 0.5,
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
              EndNewTargetPointName = "P101108Nvzhu1",
              CameraLookAtTartgetPoint = "P10110802",
              RestoreStand = false,
              TalkActors = {},
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
