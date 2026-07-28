return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742441535353",
      startPort = "StoryStart",
      endStory = "1781144742441535355",
      endPort = "In"
    },
    {
      startStory = "1781144742441535355",
      startPort = "Success",
      endStory = "1781144742441535354",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742441535353"] = {
      isStoryNode = true,
      key = "1781144742441535353",
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
    ["1781144742441535354"] = {
      isStoryNode = true,
      key = "1781144742441535354",
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
    ["1781144742441535355"] = {
      isStoryNode = true,
      key = "1781144742441535355",
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
            startQuest = "1781144742441535361",
            startPort = "Out",
            endQuest = "1781144742441535363",
            endPort = "In"
          },
          {
            startQuest = "1781144742441535358",
            startPort = "QuestStart",
            endQuest = "1781144742441535361",
            endPort = "In"
          },
          {
            startQuest = "1781144742441535358",
            startPort = "QuestStart",
            endQuest = "1781144742441535362",
            endPort = "In"
          },
          {
            startQuest = "1781144742441535362",
            startPort = "Out",
            endQuest = "1781144742441535364",
            endPort = "In"
          },
          {
            startQuest = "1781144742441535364",
            startPort = "Out",
            endQuest = "178118364216320827264",
            endPort = "In"
          },
          {
            startQuest = "178118364216320827264",
            startPort = "Out",
            endQuest = "1781144742441535356",
            endPort = "In"
          },
          {
            startQuest = "1781144742441535356",
            startPort = "Out",
            endQuest = "178118364991520827520",
            endPort = "In"
          },
          {
            startQuest = "178118364991520827520",
            startPort = "Out",
            endQuest = "1781144742441535359",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781144742441535356"] = {
            key = "1781144742441535356",
            type = "TalkNode",
            name = "止流吸取黑龙力量",
            pos = {x = 1769.2826086956522, y = 570.4782608695652},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC018/SQ_Ver0101_SC018",
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
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["1781144742441535358"] = {
            key = "1781144742441535358",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742441535359"] = {
            key = "1781144742441535359",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2126.505494505494, y = 561.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781144742441535360"] = {
            key = "1781144742441535360",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742441535361"] = {
            key = "1781144742441535361",
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
          ["1781144742441535362"] = {
            key = "1781144742441535362",
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
          ["1781144742441535363"] = {
            key = "1781144742441535363",
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
          ["1781144742441535364"] = {
            key = "1781144742441535364",
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
          ["178118364216320827264"] = {
            key = "178118364216320827264",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1483, y = 711.75},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/1_1/0124_cs_zhiliuxishouheilong",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {105701}
            }
          },
          ["178118364991520827520"] = {
            key = "178118364991520827520",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1956.75, y = 748},
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
