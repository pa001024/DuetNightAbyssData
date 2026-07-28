return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742431533403",
      startPort = "StoryStart",
      endStory = "1781144742431533405",
      endPort = "In"
    },
    {
      startStory = "1781144742431533405",
      startPort = "Success",
      endStory = "1781144742431533404",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742431533403"] = {
      isStoryNode = true,
      key = "1781144742431533403",
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
    ["1781144742431533404"] = {
      isStoryNode = true,
      key = "1781144742431533404",
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
    ["1781144742431533405"] = {
      isStoryNode = true,
      key = "1781144742431533405",
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
            startQuest = "1781144742431533411",
            startPort = "Out",
            endQuest = "1781144742431533413",
            endPort = "In"
          },
          {
            startQuest = "1781144742431533408",
            startPort = "QuestStart",
            endQuest = "1781144742431533411",
            endPort = "In"
          },
          {
            startQuest = "1781144742431533408",
            startPort = "QuestStart",
            endQuest = "1781144742431533412",
            endPort = "In"
          },
          {
            startQuest = "1781144742431533412",
            startPort = "Out",
            endQuest = "1781144742431533414",
            endPort = "In"
          },
          {
            startQuest = "1781144742431533406",
            startPort = "Out",
            endQuest = "1781144742431533415",
            endPort = "In"
          },
          {
            startQuest = "1781144742431533415",
            startPort = "Out",
            endQuest = "1781144742431533409",
            endPort = "Success"
          },
          {
            startQuest = "1781144742431533414",
            startPort = "Out",
            endQuest = "1781144742431533406",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742431533406"] = {
            key = "1781144742431533406",
            type = "TalkNode",
            name = "煜明登场",
            pos = {x = 1642.6844941208421, y = 570.0468227424749},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC003/SQ_Ver0101_SC003",
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
              EndNewTargetPointName = "QuestPoint6",
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
          ["1781144742431533408"] = {
            key = "1781144742431533408",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742431533409"] = {
            key = "1781144742431533409",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2409.9999999999995, y = 562.857142857143},
            propsData = {ModeType = 0}
          },
          ["1781144742431533410"] = {
            key = "1781144742431533410",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742431533411"] = {
            key = "1781144742431533411",
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
          ["1781144742431533412"] = {
            key = "1781144742431533412",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 910.3478529475288, y = 542.6907120531213},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104103,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742431533413"] = {
            key = "1781144742431533413",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 104103,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742431533414"] = {
            key = "1781144742431533414",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1262.2701623130522, y = 549.7318936728011},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "RegionPoint_Cav_01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1781144742431533415"] = {
            key = "1781144742431533415",
            type = "PlayOrStopBGMNode",
            name = "Mute屏蔽场景音效",
            pos = {x = 2146.4761904761904, y = 556.5595238095239},
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
