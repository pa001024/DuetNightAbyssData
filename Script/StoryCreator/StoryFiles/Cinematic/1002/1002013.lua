return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178211154691527792060",
      startPort = "StoryStart",
      endStory = "178211154805327792102",
      endPort = "In"
    },
    {
      startStory = "178211154805327792102",
      startPort = "Success",
      endStory = "178211154691527792063",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178211154691527792060"] = {
      isStoryNode = true,
      key = "178211154691527792060",
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
    ["178211154691527792063"] = {
      isStoryNode = true,
      key = "178211154691527792063",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2370, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178211154805327792102"] = {
      isStoryNode = true,
      key = "178211154805327792102",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1640, y = 346},
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
            startQuest = "178211154805427792110",
            startPort = "Out",
            endQuest = "178211154805427792112",
            endPort = "In"
          },
          {
            startQuest = "178211154805427792107",
            startPort = "QuestStart",
            endQuest = "178211154805427792110",
            endPort = "In"
          },
          {
            startQuest = "178211154805427792107",
            startPort = "QuestStart",
            endQuest = "178211154805427792111",
            endPort = "In"
          },
          {
            startQuest = "178211154805427792115",
            startPort = "Out",
            endQuest = "178211154805427792108",
            endPort = "Success"
          },
          {
            startQuest = "178211154805427792114",
            startPort = "Out",
            endQuest = "178211157684727792556",
            endPort = "In"
          },
          {
            startQuest = "178211157684727792556",
            startPort = "Out",
            endQuest = "178211154805427792115",
            endPort = "In"
          },
          {
            startQuest = "178211154805427792111",
            startPort = "Out",
            endQuest = "178211154805427792114",
            endPort = "In"
          }
        },
        nodeData = {
          ["178211154805427792107"] = {
            key = "178211154805427792107",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178211154805427792108"] = {
            key = "178211154805427792108",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["178211154805427792109"] = {
            key = "178211154805427792109",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178211154805427792110"] = {
            key = "178211154805427792110",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1189.1545350406564, y = 306.5324911890181},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178211154805427792111"] = {
            key = "178211154805427792111",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 840.2236293450444, y = 546.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178211154805427792112"] = {
            key = "178211154805427792112",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1528.38161521882, y = 321.9877653748314},
            propsData = {
              ModeType = 1,
              Id = 101101,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178211154805427792114"] = {
            key = "178211154805427792114",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1500.103556540308, y = 534.1728874616209},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "P10110602",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178211154805427792115"] = {
            key = "178211154805427792115",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178211157684727792556"] = {
            key = "178211157684727792556",
            type = "TalkNode",
            name = "赛琪摔倒",
            pos = {x = 1848.1786419037057, y = 576.2178592933067},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC013/SQ_OBT0101_SC013",
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
