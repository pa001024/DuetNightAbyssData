return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178211096865521368416",
      startPort = "StoryStart",
      endStory = "178211096924821368454",
      endPort = "In"
    },
    {
      startStory = "178211096924821368454",
      startPort = "Success",
      endStory = "178211096865521368419",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178211096865521368416"] = {
      isStoryNode = true,
      key = "178211096865521368416",
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
    ["178211096865521368419"] = {
      isStoryNode = true,
      key = "178211096865521368419",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1936, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178211096924821368454"] = {
      isStoryNode = true,
      key = "178211096924821368454",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1358, y = 286},
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
            startQuest = "178211096924821368462",
            startPort = "Out",
            endQuest = "178211096924821368464",
            endPort = "In"
          },
          {
            startQuest = "178211096924821368459",
            startPort = "QuestStart",
            endQuest = "178211096924821368462",
            endPort = "In"
          },
          {
            startQuest = "178211096924821368459",
            startPort = "QuestStart",
            endQuest = "178211096924821368463",
            endPort = "In"
          },
          {
            startQuest = "178211096924821368467",
            startPort = "Out",
            endQuest = "178211096924821368460",
            endPort = "Success"
          },
          {
            startQuest = "178211096924821368466",
            startPort = "Out",
            endQuest = "178211103209021368970",
            endPort = "In"
          },
          {
            startQuest = "178211103209021368970",
            startPort = "Out",
            endQuest = "178211096924821368467",
            endPort = "In"
          },
          {
            startQuest = "178211096924821368466",
            startPort = "Out",
            endQuest = "178211103774621369155",
            endPort = "In"
          },
          {
            startQuest = "178211096924821368463",
            startPort = "Out",
            endQuest = "178211096924821368466",
            endPort = "In"
          }
        },
        nodeData = {
          ["178211096924821368459"] = {
            key = "178211096924821368459",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178211096924821368460"] = {
            key = "178211096924821368460",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["178211096924821368461"] = {
            key = "178211096924821368461",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178211096924821368462"] = {
            key = "178211096924821368462",
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
          ["178211096924821368463"] = {
            key = "178211096924821368463",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 815.2236293450444, y = 549.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101103,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178211096924821368464"] = {
            key = "178211096924821368464",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1528.38161521882, y = 323.9877653748314},
            propsData = {
              ModeType = 1,
              Id = 101103,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178211096924821368466"] = {
            key = "178211096924821368466",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1497.4564977167786, y = 534.1728874616209},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "TargetPoint_IceLake3",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178211096924821368467"] = {
            key = "178211096924821368467",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178211103209021368970"] = {
            key = "178211103209021368970",
            type = "TalkNode",
            name = "过场动画 战后递花",
            pos = {x = 1875.7112068965519, y = 559.3965517241379},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC006/SQ_OBT0101_SC006",
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
          },
          ["178211103774621369155"] = {
            key = "178211103774621369155",
            type = "SendMessageNode",
            name = "发送消息,夜里",
            pos = {x = 1903.6422413793105, y = 407.3275862068965},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "IcelakeNight",
              UnitId = -1
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
