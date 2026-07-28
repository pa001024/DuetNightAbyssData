return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742438534748",
      startPort = "StoryStart",
      endStory = "1781144742438534750",
      endPort = "In"
    },
    {
      startStory = "1781144742438534750",
      startPort = "Success",
      endStory = "1781144742438534749",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742438534748"] = {
      isStoryNode = true,
      key = "1781144742438534748",
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
    ["1781144742438534749"] = {
      isStoryNode = true,
      key = "1781144742438534749",
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
    ["1781144742438534750"] = {
      isStoryNode = true,
      key = "1781144742438534750",
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
            startQuest = "1781144742438534754",
            startPort = "Out",
            endQuest = "1781144742438534756",
            endPort = "In"
          },
          {
            startQuest = "1781144742438534751",
            startPort = "QuestStart",
            endQuest = "1781144742438534754",
            endPort = "In"
          },
          {
            startQuest = "1781144742438534751",
            startPort = "QuestStart",
            endQuest = "1781144742438534755",
            endPort = "In"
          },
          {
            startQuest = "1781144742438534755",
            startPort = "Out",
            endQuest = "1781144742438534757",
            endPort = "In"
          },
          {
            startQuest = "1781144742438534758",
            startPort = "Out",
            endQuest = "1781144742438534760",
            endPort = "In"
          },
          {
            startQuest = "1781144742438534760",
            startPort = "Out",
            endQuest = "1781144742438534752",
            endPort = "Success"
          },
          {
            startQuest = "1781144742438534757",
            startPort = "Out",
            endQuest = "178118346940816662990",
            endPort = "In"
          },
          {
            startQuest = "178118346940816662990",
            startPort = "Out",
            endQuest = "1781144742438534758",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742438534751"] = {
            key = "1781144742438534751",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742438534752"] = {
            key = "1781144742438534752",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2476.505494505494, y = 575.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781144742438534753"] = {
            key = "1781144742438534753",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742438534754"] = {
            key = "1781144742438534754",
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
          ["1781144742438534755"] = {
            key = "1781144742438534755",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 105701,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742438534756"] = {
            key = "1781144742438534756",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 105701,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742438534757"] = {
            key = "1781144742438534757",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1122.242212002493, y = 548.8778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "RegionPoint_Alt_01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1781144742438534758"] = {
            key = "1781144742438534758",
            type = "TalkNode",
            name = "抵达黑龙祭坛",
            pos = {x = 1798, y = 572},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC012/SQ_Ver0101_SC012",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = false,
              ShowWikiButton = false,
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
          ["1781144742438534760"] = {
            key = "1781144742438534760",
            type = "PlayOrStopBGMNode",
            name = "mute",
            pos = {x = 2120, y = 584},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178118346940816662990"] = {
            key = "178118346940816662990",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1525.0000000000002, y = 692.2142857142858},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/1_1/0126_cs_reach_heilongjitan",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {105701}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
