return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742429532925",
      startPort = "StoryStart",
      endStory = "1781144742429532927",
      endPort = "In"
    },
    {
      startStory = "1781144742429532927",
      startPort = "Success",
      endStory = "1781144742429532926",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742429532925"] = {
      isStoryNode = true,
      key = "1781144742429532925",
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
    ["1781144742429532926"] = {
      isStoryNode = true,
      key = "1781144742429532926",
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
    ["1781144742429532927"] = {
      isStoryNode = true,
      key = "1781144742429532927",
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
            startQuest = "1781144742429532932",
            startPort = "Out",
            endQuest = "1781144742429532934",
            endPort = "In"
          },
          {
            startQuest = "1781144742429532929",
            startPort = "QuestStart",
            endQuest = "1781144742429532932",
            endPort = "In"
          },
          {
            startQuest = "1781144742429532929",
            startPort = "QuestStart",
            endQuest = "1781144742429532933",
            endPort = "In"
          },
          {
            startQuest = "1781144742429532933",
            startPort = "Out",
            endQuest = "1781144742429532935",
            endPort = "In"
          },
          {
            startQuest = "1781144742429532935",
            startPort = "Out",
            endQuest = "178116914016946263187",
            endPort = "In"
          },
          {
            startQuest = "178116914016946263187",
            startPort = "Out",
            endQuest = "1781144742429532928",
            endPort = "In"
          },
          {
            startQuest = "1781144742429532928",
            startPort = "Out",
            endQuest = "178116914822046263348",
            endPort = "In"
          },
          {
            startQuest = "178116914822046263348",
            startPort = "Out",
            endQuest = "1781144742429532930",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781144742429532928"] = {
            key = "1781144742429532928",
            type = "TalkNode",
            name = "深夜溜出休憩所",
            pos = {x = 1615.023785425101, y = 560.7191295546559},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0104/OBT0104_SC001/SQ_OBT0104_SC001",
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
          ["1781144742429532929"] = {
            key = "1781144742429532929",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742429532930"] = {
            key = "1781144742429532930",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2159.505494505494, y = 549.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781144742429532931"] = {
            key = "1781144742429532931",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742429532932"] = {
            key = "1781144742429532932",
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
          ["1781144742429532933"] = {
            key = "1781144742429532933",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742429532934"] = {
            key = "1781144742429532934",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 101101,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742429532935"] = {
            key = "1781144742429532935",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "NewTargetPoint12000303",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178116914016946263187"] = {
            key = "178116914016946263187",
            type = "PlayOrStopBGMNode",
            name = "播放暂停音乐",
            pos = {x = 1363.5811119951177, y = 736.9038052573816},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["178116914822046263348"] = {
            key = "178116914822046263348",
            type = "PlayOrStopBGMNode",
            name = "关音乐",
            pos = {x = 1849.3875636080213, y = 695.290902031575},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178117468588347294623"] = {
            key = "178117468588347294623",
            type = "LayoutPlanNode",
            name = "判断当前当前玩家布局节点",
            pos = {x = 2176.1541907163037, y = 222.3609419495812},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
