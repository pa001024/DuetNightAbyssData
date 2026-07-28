return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17811604688416633466",
      startPort = "Success",
      endStory = "17811604688416633465",
      endPort = "StoryEnd"
    },
    {
      startStory = "17811604688416633464",
      startPort = "StoryStart",
      endStory = "17811604688416633466",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17811604688416633464"] = {
      isStoryNode = true,
      key = "17811604688416633464",
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
    ["17811604688416633465"] = {
      isStoryNode = true,
      key = "17811604688416633465",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1604, y = 302},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17811604688416633466"] = {
      isStoryNode = true,
      key = "17811604688416633466",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1201.4782608695652, y = 292.69565217391306},
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
            startQuest = "17811604688416633470",
            startPort = "Out",
            endQuest = "17811604688416633471",
            endPort = "In"
          },
          {
            startQuest = "17811604688416633467",
            startPort = "QuestStart",
            endQuest = "17811604688416633470",
            endPort = "In"
          },
          {
            startQuest = "17811604688416633467",
            startPort = "QuestStart",
            endQuest = "17811604688416633472",
            endPort = "In"
          },
          {
            startQuest = "17811604688416633473",
            startPort = "Out",
            endQuest = "17811604688416633468",
            endPort = "Success"
          },
          {
            startQuest = "17811603071905088743",
            startPort = "Out",
            endQuest = "17811604688416633473",
            endPort = "In"
          },
          {
            startQuest = "17811602930465088623",
            startPort = "Out",
            endQuest = "17811603071905088743",
            endPort = "In"
          },
          {
            startQuest = "17811602930465088623",
            startPort = "Out",
            endQuest = "17811603145805088905",
            endPort = "In"
          },
          {
            startQuest = "17811604688416633472",
            startPort = "Out",
            endQuest = "17811602930465088623",
            endPort = "In"
          }
        },
        nodeData = {
          ["17811602930465088623"] = {
            key = "17811602930465088623",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1396.2615546218487, y = 405.50840336134445},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint_Juque02BossBattle",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17811603071905088743"] = {
            key = "17811603071905088743",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1681.9758403361345, y = 401.2226890756303},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0103/Ver0103_SC004/Ver0103_SC004",
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
              HideMechanismsFX = false,
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
          ["17811603145805088905"] = {
            key = "17811603145805088905",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1680.547268907563, y = 571.2226890756301},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/1_1/0123_boss_juque",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {105901}
            }
          },
          ["17811604688416633467"] = {
            key = "17811604688416633467",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17811604688416633468"] = {
            key = "17811604688416633468",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2245.7727272727275, y = 404.90909090909093},
            propsData = {ModeType = 0}
          },
          ["17811604688416633469"] = {
            key = "17811604688416633469",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17811604688416633470"] = {
            key = "17811604688416633470",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1121.4920748841803, y = 204.76753893481157},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17811604688416633471"] = {
            key = "17811604688416633471",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1402.8650679729626, y = 210.56597251877147},
            propsData = {
              ModeType = 1,
              Id = 105901,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17811604688416633472"] = {
            key = "17811604688416633472",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1120.3571428571427, y = 404.42857142857144},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 105901,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17811604688416633473"] = {
            key = "17811604688416633473",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1960.4018915866745, y = 406.79853041695145},
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
