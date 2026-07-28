return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742431533245",
      startPort = "StoryStart",
      endStory = "1781144742431533247",
      endPort = "In"
    },
    {
      startStory = "1781144742431533247",
      startPort = "Success",
      endStory = "1781144742431533246",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742431533245"] = {
      isStoryNode = true,
      key = "1781144742431533245",
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
    ["1781144742431533246"] = {
      isStoryNode = true,
      key = "1781144742431533246",
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
    ["1781144742431533247"] = {
      isStoryNode = true,
      key = "1781144742431533247",
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
            startQuest = "1781144742431533251",
            startPort = "Out",
            endQuest = "1781144742431533253",
            endPort = "In"
          },
          {
            startQuest = "1781144742431533248",
            startPort = "QuestStart",
            endQuest = "1781144742431533251",
            endPort = "In"
          },
          {
            startQuest = "1781144742431533248",
            startPort = "QuestStart",
            endQuest = "1781144742431533252",
            endPort = "In"
          },
          {
            startQuest = "1781144742431533252",
            startPort = "Out",
            endQuest = "1781144742431533254",
            endPort = "In"
          },
          {
            startQuest = "1781144742431533260",
            startPort = "Out",
            endQuest = "1781144742431533249",
            endPort = "Success"
          },
          {
            startQuest = "1781144742431533255",
            startPort = "Out",
            endQuest = "1781144742431533260",
            endPort = "In"
          },
          {
            startQuest = "1781144742431533254",
            startPort = "Out",
            endQuest = "17811801822452086126",
            endPort = "In"
          },
          {
            startQuest = "17811801822452086126",
            startPort = "Out",
            endQuest = "1781144742431533255",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742431533248"] = {
            key = "1781144742431533248",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742431533249"] = {
            key = "1781144742431533249",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.763975155279, y = 516.3975155279504},
            propsData = {ModeType = 0}
          },
          ["1781144742431533250"] = {
            key = "1781144742431533250",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742431533251"] = {
            key = "1781144742431533251",
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
          ["1781144742431533252"] = {
            key = "1781144742431533252",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 911.6522007736158, y = 542.6907120531213},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104108,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742431533253"] = {
            key = "1781144742431533253",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 104108,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742431533254"] = {
            key = "1781144742431533254",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1278.4170888497838, y = 538.3975608392178},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint_FindBai",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1781144742431533255"] = {
            key = "1781144742431533255",
            type = "TalkNode",
            name = "白狴犴惩戒劫匪",
            pos = {x = 1887.1724137931035, y = 523.6256157635469},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC002/SQ_Ver0101_SC002",
              BlendInTime = 1,
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
          ["1781144742431533259"] = {
            key = "1781144742431533259",
            type = "PlayOrStopBGMNode",
            name = "bgm - start",
            pos = {x = 1848.725504472644, y = 919.4094289577702},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "/Game/Asset/Audio/FMOD/Events/bgm/cbt01/0002_story_shahai",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["1781144742431533260"] = {
            key = "1781144742431533260",
            type = "PlayOrStopBGMNode",
            name = "bgm - stop",
            pos = {x = 2253.0733305596004, y = 520.2789941751614},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17811801822452086126"] = {
            key = "17811801822452086126",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1584.3147804302973, y = 603.3466990863541},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/1_1/0132_cs_baibianchegnjiejiefei",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {104108}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
