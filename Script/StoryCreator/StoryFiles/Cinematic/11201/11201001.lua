return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17821131332404247",
      startPort = "StoryStart",
      endStory = "17821131350784280",
      endPort = "In"
    },
    {
      startStory = "17821131350784280",
      startPort = "Success",
      endStory = "17821131332404250",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17821131332404247"] = {
      isStoryNode = true,
      key = "17821131332404247",
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
    ["17821131332404250"] = {
      isStoryNode = true,
      key = "17821131332404250",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2354, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17821131350784280"] = {
      isStoryNode = true,
      key = "17821131350784280",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1596, y = 298},
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
            startQuest = "17821131399274509",
            startPort = "Out",
            endQuest = "17821131399274511",
            endPort = "In"
          },
          {
            startQuest = "17821131350784281",
            startPort = "QuestStart",
            endQuest = "17821131399274509",
            endPort = "In"
          },
          {
            startQuest = "17821131399274514",
            startPort = "Out",
            endQuest = "17821132894204753",
            endPort = "In"
          },
          {
            startQuest = "17821131399274516",
            startPort = "Out",
            endQuest = "17821131350784284",
            endPort = "Success"
          },
          {
            startQuest = "17821131350784281",
            startPort = "QuestStart",
            endQuest = "17821131399274510",
            endPort = "In"
          },
          {
            startQuest = "17821131399274510",
            startPort = "Out",
            endQuest = "17821131399274514",
            endPort = "In"
          },
          {
            startQuest = "17821132894204753",
            startPort = "Out",
            endQuest = "17821135635451075050",
            endPort = "In"
          },
          {
            startQuest = "17821135635451075050",
            startPort = "Out",
            endQuest = "17821131399274516",
            endPort = "In"
          }
        },
        nodeData = {
          ["17821131350784281"] = {
            key = "17821131350784281",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17821131350784284"] = {
            key = "17821131350784284",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2717.894736842105, y = 543.1578947368422},
            propsData = {ModeType = 0}
          },
          ["17821131350784287"] = {
            key = "17821131350784287",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2752.6315789473683, y = 816.8421052631579},
            propsData = {}
          },
          ["17821131399274509"] = {
            key = "17821131399274509",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1102.7046601440443, y = 310.83896750624024},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17821131399274510"] = {
            key = "17821131399274510",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1162.8984780220724, y = 533.7144896449201},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101103,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17821131399274511"] = {
            key = "17821131399274511",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1678.7205103756837, y = 315.994543947343},
            propsData = {
              ModeType = 1,
              Id = 101103,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17821131399274514"] = {
            key = "17821131399274514",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1517.762925341175, y = 519.7324610651884},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Mechanism_QuestTrigger_1240949",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17821131399274516"] = {
            key = "17821131399274516",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2358.469943030559, y = 549.1506709120561},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17821132894204753"] = {
            key = "17821132894204753",
            type = "PlayOrStopBGMNode",
            name = "BGM-Play",
            pos = {x = 1766.9736842105265, y = 530.1776315789473},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/mute",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["17821135635451075050"] = {
            key = "17821135635451075050",
            type = "TalkNode",
            name = "SC01【过场】女主飞踢",
            pos = {x = 2076.4473684210525, y = 522.2828947368422},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Activity/Activity_Feina/Activity_Feina_SC001/SQ_Activity_Feina_SC001",
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
              HideNpcs = true,
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
