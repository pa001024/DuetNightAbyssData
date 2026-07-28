return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781167101918532165",
      startPort = "StoryStart",
      endStory = "1781167101918532167",
      endPort = "In"
    },
    {
      startStory = "1781167101918532167",
      startPort = "Success",
      endStory = "1781167101918532166",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781167101918532165"] = {
      isStoryNode = true,
      key = "1781167101918532165",
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
    ["1781167101918532166"] = {
      isStoryNode = true,
      key = "1781167101918532166",
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
    ["1781167101918532167"] = {
      isStoryNode = true,
      key = "1781167101918532167",
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
            startQuest = "1781167101918532172",
            startPort = "Out",
            endQuest = "1781167101918532174",
            endPort = "In"
          },
          {
            startQuest = "1781167101918532169",
            startPort = "QuestStart",
            endQuest = "1781167101918532172",
            endPort = "In"
          },
          {
            startQuest = "1781167101918532169",
            startPort = "QuestStart",
            endQuest = "1781167101918532173",
            endPort = "In"
          },
          {
            startQuest = "1781167101918532173",
            startPort = "Out",
            endQuest = "1781167101918532175",
            endPort = "In"
          },
          {
            startQuest = "1781167101918532175",
            startPort = "Out",
            endQuest = "1782198273118626",
            endPort = "In"
          },
          {
            startQuest = "1782198273118626",
            startPort = "Out",
            endQuest = "178116951343810203862",
            endPort = "In"
          },
          {
            startQuest = "178116951343810203862",
            startPort = "Out",
            endQuest = "1782198282821968",
            endPort = "In"
          },
          {
            startQuest = "1782198282821968",
            startPort = "Out",
            endQuest = "1781167101918532170",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781167101918532169"] = {
            key = "1781167101918532169",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781167101918532170"] = {
            key = "1781167101918532170",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2248.596403596403, y = 537.1078921078922},
            propsData = {ModeType = 0}
          },
          ["1781167101918532171"] = {
            key = "1781167101918532171",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781167101918532172"] = {
            key = "1781167101918532172",
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
          ["1781167101918532173"] = {
            key = "1781167101918532173",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101901,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781167101918532174"] = {
            key = "1781167101918532174",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 101901,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781167101918532175"] = {
            key = "1781167101918532175",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "cp2thea2spspawnpoint3",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178116951343810203862"] = {
            key = "178116951343810203862",
            type = "TalkNode",
            name = "过场",
            pos = {x = 1716.5443197153725, y = 592.8211874274602},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0103/OBT0103_SC010/SQ_OBT0103_SC010",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = false,
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
          ["1782198273118626"] = {
            key = "1782198273118626",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1447.82131661442, y = 584.8056426332287},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/cbt03/0069_boss_devil_linen",
              ParamKey = "state",
              ParamValue = 3,
              RelatedRegionId = {101901}
            }
          },
          ["1782198282821968"] = {
            key = "1782198282821968",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1979.6394984326018, y = 579.3510971786834},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
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
