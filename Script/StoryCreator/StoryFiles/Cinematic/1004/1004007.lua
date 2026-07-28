return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17811602824591018920",
      startPort = "StoryStart",
      endStory = "17811602834171018968",
      endPort = "In"
    },
    {
      startStory = "17811602834171018968",
      startPort = "Success",
      endStory = "17811602824591018923",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17811602824591018920"] = {
      isStoryNode = true,
      key = "17811602824591018920",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1136, y = 298},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17811602824591018923"] = {
      isStoryNode = true,
      key = "17811602824591018923",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2138, y = 380},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17811602834171018968"] = {
      isStoryNode = true,
      key = "17811602834171018968",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1534, y = 330},
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
            startQuest = "17811602834171018976",
            startPort = "Out",
            endQuest = "17811602834171018978",
            endPort = "In"
          },
          {
            startQuest = "17811602834171018973",
            startPort = "QuestStart",
            endQuest = "17811602834171018976",
            endPort = "In"
          },
          {
            startQuest = "17811602834171018973",
            startPort = "QuestStart",
            endQuest = "17811602834171018977",
            endPort = "In"
          },
          {
            startQuest = "17811602834171018977",
            startPort = "Out",
            endQuest = "17811602834171018979",
            endPort = "In"
          },
          {
            startQuest = "17811602834171018979",
            startPort = "Out",
            endQuest = "17811602834171018980",
            endPort = "In"
          },
          {
            startQuest = "17811602834171018981",
            startPort = "Out",
            endQuest = "17811602834171018974",
            endPort = "Success"
          },
          {
            startQuest = "17811602834171018980",
            startPort = "Out",
            endQuest = "17811602834171018983",
            endPort = "In"
          },
          {
            startQuest = "17811602834171018983",
            startPort = "Out",
            endQuest = "17811608024032036429",
            endPort = "In"
          },
          {
            startQuest = "17811608024032036429",
            startPort = "Out",
            endQuest = "17811602834171018981",
            endPort = "In"
          },
          {
            startQuest = "17811602834171018977",
            startPort = "Out",
            endQuest = "178125291779115401524",
            endPort = "Input"
          }
        },
        nodeData = {
          ["17811602834171018973"] = {
            key = "17811602834171018973",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17811602834171018974"] = {
            key = "17811602834171018974",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["17811602834171018975"] = {
            key = "17811602834171018975",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17811602834171018976"] = {
            key = "17811602834171018976",
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
          ["17811602834171018977"] = {
            key = "17811602834171018977",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 549.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 106001,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17811602834171018978"] = {
            key = "17811602834171018978",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 106001,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17811602834171018979"] = {
            key = "17811602834171018979",
            type = "ChangeRoleNode",
            name = "切换角色-女主",
            pos = {x = 1087.8169354336808, y = 516.3778564057205},
            propsData = {QuestRoleId = 1010101, IsPlayFX = false}
          },
          ["17811602834171018980"] = {
            key = "17811602834171018980",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1366.742212002493, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_SQ_Ver0104_SC007",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17811602834171018981"] = {
            key = "17811602834171018981",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 1
            }
          },
          ["17811602834171018983"] = {
            key = "17811602834171018983",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1653.3286698251864, y = 569.5472203235364},
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
          ["17811608024032036429"] = {
            key = "17811608024032036429",
            type = "TalkNode",
            name = "爆炸站桩过场",
            pos = {x = 1949.519146015662, y = 545.5789663552821},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "SQ_Ver0104_SC007",
              ShowFilePath = "LevelSequence'/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC007/SQ_Ver0104_SC007.SQ_Ver0104_SC007'",
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
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = true,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["178125291779115401524"] = {
            key = "178125291779115401524",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1103.0064935064938, y = 684.4675324675326},
            propsData = {
              TargetTime = 18,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
