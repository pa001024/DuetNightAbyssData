return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742430533057",
      startPort = "StoryStart",
      endStory = "1781144742430533059",
      endPort = "In"
    },
    {
      startStory = "1781144742430533059",
      startPort = "Success",
      endStory = "1781144742430533058",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742430533057"] = {
      isStoryNode = true,
      key = "1781144742430533057",
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
    ["1781144742430533058"] = {
      isStoryNode = true,
      key = "1781144742430533058",
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
    ["1781144742430533059"] = {
      isStoryNode = true,
      key = "1781144742430533059",
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
            startQuest = "1781144742430533064",
            startPort = "Out",
            endQuest = "1781144742430533066",
            endPort = "In"
          },
          {
            startQuest = "1781144742430533061",
            startPort = "QuestStart",
            endQuest = "1781144742430533064",
            endPort = "In"
          },
          {
            startQuest = "1781144742430533061",
            startPort = "QuestStart",
            endQuest = "1781144742430533065",
            endPort = "In"
          },
          {
            startQuest = "1781144742430533065",
            startPort = "Out",
            endQuest = "1781144742430533067",
            endPort = "In"
          },
          {
            startQuest = "1781144742430533067",
            startPort = "Out",
            endQuest = "17811796407541043764",
            endPort = "In"
          },
          {
            startQuest = "17811796482901043971",
            startPort = "Out",
            endQuest = "1781144742430533062",
            endPort = "Success"
          },
          {
            startQuest = "17811796407541043764",
            startPort = "Out",
            endQuest = "17834234077671059056",
            endPort = "In"
          },
          {
            startQuest = "17834234077671059056",
            startPort = "Out",
            endQuest = "17811796482901043971",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742430533061"] = {
            key = "1781144742430533061",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742430533062"] = {
            key = "1781144742430533062",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2159.505494505494, y = 549.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781144742430533063"] = {
            key = "1781144742430533063",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742430533064"] = {
            key = "1781144742430533064",
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
          ["1781144742430533065"] = {
            key = "1781144742430533065",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104108,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742430533066"] = {
            key = "1781144742430533066",
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
          ["1781144742430533067"] = {
            key = "1781144742430533067",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint_PorStart",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17811796407541043764"] = {
            key = "17811796407541043764",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1404.3174603174602, y = 798.3174603174605},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/1_1/0096_cs_dongguo_opening",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {104108}
            }
          },
          ["17811796482901043971"] = {
            key = "17811796482901043971",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1885.4285714285713, y = 732.7619047619048},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17834234077671059056"] = {
            key = "17834234077671059056",
            type = "TalkNode",
            name = "【SC001】-抵达东国码头",
            pos = {x = 1657.2603753493534, y = 620.9481298320527},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC001/SQ_Ver0101_SC001_PV",
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
