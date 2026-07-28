return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742440535213",
      startPort = "StoryStart",
      endStory = "1781144742440535215",
      endPort = "In"
    },
    {
      startStory = "1781144742440535215",
      startPort = "Success",
      endStory = "1781144742440535214",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742440535213"] = {
      isStoryNode = true,
      key = "1781144742440535213",
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
    ["1781144742440535214"] = {
      isStoryNode = true,
      key = "1781144742440535214",
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
    ["1781144742440535215"] = {
      isStoryNode = true,
      key = "1781144742440535215",
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
            startQuest = "1781144742440535221",
            startPort = "Out",
            endQuest = "1781144742440535223",
            endPort = "In"
          },
          {
            startQuest = "1781144742440535218",
            startPort = "QuestStart",
            endQuest = "1781144742440535221",
            endPort = "In"
          },
          {
            startQuest = "1781144742440535218",
            startPort = "QuestStart",
            endQuest = "1781144742440535222",
            endPort = "In"
          },
          {
            startQuest = "1781144742440535222",
            startPort = "Out",
            endQuest = "1781144742440535224",
            endPort = "In"
          },
          {
            startQuest = "1781144742440535216",
            startPort = "Out",
            endQuest = "1781144742440535225",
            endPort = "In"
          },
          {
            startQuest = "1781144742440535225",
            startPort = "Out",
            endQuest = "1781144742440535219",
            endPort = "Success"
          },
          {
            startQuest = "1781144742440535224",
            startPort = "Out",
            endQuest = "178118360057719786249",
            endPort = "In"
          },
          {
            startQuest = "178118360057719786249",
            startPort = "Out",
            endQuest = "1781144742440535216",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742440535216"] = {
            key = "1781144742440535216",
            type = "TalkNode",
            name = "止流囚禁玩家",
            pos = {x = 1829.157894736842, y = 584.2105263157895},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC017/SQ_Ver0101_SC017",
              BlendInTime = 0,
              BlendOutTime = 0.5,
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
          ["1781144742440535218"] = {
            key = "1781144742440535218",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742440535219"] = {
            key = "1781144742440535219",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2541.505494505494, y = 569.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781144742440535220"] = {
            key = "1781144742440535220",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742440535221"] = {
            key = "1781144742440535221",
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
          ["1781144742440535222"] = {
            key = "1781144742440535222",
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
          ["1781144742440535223"] = {
            key = "1781144742440535223",
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
          ["1781144742440535224"] = {
            key = "1781144742440535224",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
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
          ["1781144742440535225"] = {
            key = "1781144742440535225",
            type = "PlayOrStopBGMNode",
            name = "BGM - shendianyiji - Stop(MUTE)",
            pos = {x = 2168, y = 560},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178118360057719786249"] = {
            key = "178118360057719786249",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1494.3148425787106, y = 729.2769865067467},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/1_1/0127_cs_zhiliuqiujinwanjia",
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
