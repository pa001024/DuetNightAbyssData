return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781167101917531637",
      startPort = "StoryStart",
      endStory = "1781167101917531639",
      endPort = "In"
    },
    {
      startStory = "1781167101917531639",
      startPort = "Success",
      endStory = "1781167101917531638",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781167101917531637"] = {
      isStoryNode = true,
      key = "1781167101917531637",
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
    ["1781167101917531638"] = {
      isStoryNode = true,
      key = "1781167101917531638",
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
    ["1781167101917531639"] = {
      isStoryNode = true,
      key = "1781167101917531639",
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
            startQuest = "1781167101917531644",
            startPort = "Out",
            endQuest = "1781167101917531646",
            endPort = "In"
          },
          {
            startQuest = "1781167101917531641",
            startPort = "QuestStart",
            endQuest = "1781167101917531644",
            endPort = "In"
          },
          {
            startQuest = "1781167101917531641",
            startPort = "QuestStart",
            endQuest = "1781167101917531645",
            endPort = "In"
          },
          {
            startQuest = "1781167101917531645",
            startPort = "Out",
            endQuest = "1781167101917531647",
            endPort = "In"
          },
          {
            startQuest = "1781167101917531647",
            startPort = "Out",
            endQuest = "17811688651706122153",
            endPort = "In"
          },
          {
            startQuest = "17811688651706122153",
            startPort = "Out",
            endQuest = "17811688651706122152",
            endPort = "In"
          },
          {
            startQuest = "17811688651706122152",
            startPort = "Out",
            endQuest = "17821283711991067225",
            endPort = "In"
          },
          {
            startQuest = "17821283711991067225",
            startPort = "Out",
            endQuest = "1781167101917531642",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781167101917531641"] = {
            key = "1781167101917531641",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781167101917531642"] = {
            key = "1781167101917531642",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2159.505494505494, y = 549.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781167101917531643"] = {
            key = "1781167101917531643",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781167101917531644"] = {
            key = "1781167101917531644",
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
          ["1781167101917531645"] = {
            key = "1781167101917531645",
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
          ["1781167101917531646"] = {
            key = "1781167101917531646",
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
          ["1781167101917531647"] = {
            key = "1781167101917531647",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1208.2744700670091, y = 548.3455983412042},
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
          ["17811688651706122152"] = {
            key = "17811688651706122152",
            type = "TalkNode",
            name = "过场",
            pos = {x = 1758.0489335932884, y = 608.457328961361},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0103/OBT0103_SC006/SQ_OBT0103_SC006",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = false,
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
          ["17811688651706122153"] = {
            key = "17811688651706122153",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1476.4179812123357, y = 562.6597099137421},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/cbt03/0069_boss_devil_linen",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {101901}
            }
          },
          ["17821283711991067225"] = {
            key = "17821283711991067225",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1939.583996648513, y = 434.3079178885631},
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
