return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742442535631",
      startPort = "StoryStart",
      endStory = "1781144742442535633",
      endPort = "In"
    },
    {
      startStory = "1781144742442535633",
      startPort = "Success",
      endStory = "1781144742442535632",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742442535631"] = {
      isStoryNode = true,
      key = "1781144742442535631",
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
    ["1781144742442535632"] = {
      isStoryNode = true,
      key = "1781144742442535632",
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
    ["1781144742442535633"] = {
      isStoryNode = true,
      key = "1781144742442535633",
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
            startQuest = "1781144742442535639",
            startPort = "Out",
            endQuest = "1781144742442535641",
            endPort = "In"
          },
          {
            startQuest = "1781144742442535636",
            startPort = "QuestStart",
            endQuest = "1781144742442535639",
            endPort = "In"
          },
          {
            startQuest = "1781144742442535636",
            startPort = "QuestStart",
            endQuest = "1781144742442535640",
            endPort = "In"
          },
          {
            startQuest = "1781144742442535640",
            startPort = "Out",
            endQuest = "1781144742442535642",
            endPort = "In"
          },
          {
            startQuest = "1781144742442535642",
            startPort = "Out",
            endQuest = "178118374619222909777",
            endPort = "In"
          },
          {
            startQuest = "178118374619222909777",
            startPort = "Out",
            endQuest = "1781144742442535634",
            endPort = "In"
          },
          {
            startQuest = "1781144742442535634",
            startPort = "Out",
            endQuest = "178118375169722909924",
            endPort = "In"
          },
          {
            startQuest = "178118375169722909924",
            startPort = "Out",
            endQuest = "1781144742442535637",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781144742442535634"] = {
            key = "1781144742442535634",
            type = "TalkNode",
            name = "离开扶疏幻境",
            pos = {x = 1765.735294117647, y = 571.8259803921569},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC020/SQ_Ver0101_SC020",
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
          },
          ["1781144742442535636"] = {
            key = "1781144742442535636",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742442535637"] = {
            key = "1781144742442535637",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2126.505494505494, y = 561.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781144742442535638"] = {
            key = "1781144742442535638",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742442535639"] = {
            key = "1781144742442535639",
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
          ["1781144742442535640"] = {
            key = "1781144742442535640",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 105001,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742442535641"] = {
            key = "1781144742442535641",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 105001,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742442535642"] = {
            key = "1781144742442535642",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1122.242212002493, y = 548.8778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "RespawnPoint_BossFight",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178118374619222909777"] = {
            key = "178118374619222909777",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1494.046176046176, y = 640.275036859276},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/1_1/0116_cs_fushuhuanjing",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {105001}
            }
          },
          ["178118375169722909924"] = {
            key = "178118375169722909924",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1905.608676046176, y = 281.21253685927604},
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
