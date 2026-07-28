return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742434533830",
      startPort = "StoryStart",
      endStory = "1781144742434533832",
      endPort = "In"
    },
    {
      startStory = "1781144742434533832",
      startPort = "Success",
      endStory = "1781144742434533831",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742434533830"] = {
      isStoryNode = true,
      key = "1781144742434533830",
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
    ["1781144742434533831"] = {
      isStoryNode = true,
      key = "1781144742434533831",
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
    ["1781144742434533832"] = {
      isStoryNode = true,
      key = "1781144742434533832",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1268, y = 272},
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
            startQuest = "1781144742434533837",
            startPort = "Out",
            endQuest = "1781144742434533839",
            endPort = "In"
          },
          {
            startQuest = "1781144742434533834",
            startPort = "QuestStart",
            endQuest = "1781144742434533837",
            endPort = "In"
          },
          {
            startQuest = "1781144742434533834",
            startPort = "QuestStart",
            endQuest = "1781144742434533838",
            endPort = "In"
          },
          {
            startQuest = "1781144742434533838",
            startPort = "Out",
            endQuest = "1781144742434533840",
            endPort = "In"
          },
          {
            startQuest = "1781144742434533840",
            startPort = "Out",
            endQuest = "1781144742434533833",
            endPort = "In"
          },
          {
            startQuest = "1781144742434533833",
            startPort = "Out",
            endQuest = "17811808613766251508",
            endPort = "In"
          },
          {
            startQuest = "17811808613766251508",
            startPort = "Out",
            endQuest = "1781144742434533835",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781144742434533833"] = {
            key = "1781144742434533833",
            type = "TalkNode",
            name = "扶疏咳血",
            pos = {x = 1686.8283817434267, y = 564},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC006/SQ_Ver0101_SC006",
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
              EndNewTargetPointName = "QuestPoint_Balcony2",
              CameraLookAtTartgetPoint = "QuestPoint_Balcony1",
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
          ["1781144742434533834"] = {
            key = "1781144742434533834",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742434533835"] = {
            key = "1781144742434533835",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2241.4285714285706, y = 584.2857142857143},
            propsData = {ModeType = 0}
          },
          ["1781144742434533836"] = {
            key = "1781144742434533836",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742434533837"] = {
            key = "1781144742434533837",
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
          ["1781144742434533838"] = {
            key = "1781144742434533838",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 912.0145196141955, y = 542.6907120531213},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104109,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742434533839"] = {
            key = "1781144742434533839",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 104109,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742434533840"] = {
            key = "1781144742434533840",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1262.2701623130522, y = 549.7318936728011},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint_12010306",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17811808613766251508"] = {
            key = "17811808613766251508",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1923.559523809524, y = 655.9887218045113},
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
