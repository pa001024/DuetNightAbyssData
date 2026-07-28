return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742455538349",
      startPort = "StoryStart",
      endStory = "1781144742455538351",
      endPort = "In"
    },
    {
      startStory = "1781144742455538351",
      startPort = "Success",
      endStory = "1781144742455538350",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742455538349"] = {
      isStoryNode = true,
      key = "1781144742455538349",
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
    ["1781144742455538350"] = {
      isStoryNode = true,
      key = "1781144742455538350",
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
    ["1781144742455538351"] = {
      isStoryNode = true,
      key = "1781144742455538351",
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
            startQuest = "1781144742455538358",
            startPort = "Out",
            endQuest = "1781144742455538360",
            endPort = "In"
          },
          {
            startQuest = "1781144742455538355",
            startPort = "QuestStart",
            endQuest = "1781144742455538358",
            endPort = "In"
          },
          {
            startQuest = "1781144742455538355",
            startPort = "QuestStart",
            endQuest = "1781144742455538359",
            endPort = "In"
          },
          {
            startQuest = "1781144742455538352",
            startPort = "Out",
            endQuest = "1781144742455538354",
            endPort = "In"
          },
          {
            startQuest = "1781144742455538354",
            startPort = "Out",
            endQuest = "1781144742455538356",
            endPort = "Success"
          },
          {
            startQuest = "178116757704038041361",
            startPort = "Out",
            endQuest = "1781144742455538352",
            endPort = "In"
          },
          {
            startQuest = "1781144742455538359",
            startPort = "Out",
            endQuest = "178116757704038041361",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742455538352"] = {
            key = "1781144742455538352",
            type = "TalkNode",
            name = "VS双龙（下）斩杀",
            pos = {x = 1805.655172413793, y = 578.2068965517242},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC018/Ver0102_SC018",
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
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["1781144742455538354"] = {
            key = "1781144742455538354",
            type = "PlayOrStopBGMNode",
            name = "开启任务提示音",
            pos = {x = 2198.3333333333335, y = 564.6666666666669},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["1781144742455538355"] = {
            key = "1781144742455538355",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742455538356"] = {
            key = "1781144742455538356",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2540.9523809523803, y = 536.904761904762},
            propsData = {ModeType = 0}
          },
          ["1781144742455538357"] = {
            key = "1781144742455538357",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742455538358"] = {
            key = "1781144742455538358",
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
          ["1781144742455538359"] = {
            key = "1781144742455538359",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 910.3478529475288, y = 542.6907120531213},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 105301,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742455538360"] = {
            key = "1781144742455538360",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 105301,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178116757704038041361"] = {
            key = "178116757704038041361",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1296.3058434018285, y = 560.0914511231779},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_3/0148_theme_song_hyb_story_cut3.0148_theme_song_hyb_story_cut3'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
