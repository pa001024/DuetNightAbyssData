return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742446536672",
      startPort = "StoryStart",
      endStory = "1781144742446536674",
      endPort = "In"
    },
    {
      startStory = "1781144742446536674",
      startPort = "Success",
      endStory = "1781144742446536673",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742446536672"] = {
      isStoryNode = true,
      key = "1781144742446536672",
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
    ["1781144742446536673"] = {
      isStoryNode = true,
      key = "1781144742446536673",
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
    ["1781144742446536674"] = {
      isStoryNode = true,
      key = "1781144742446536674",
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
            startQuest = "1781144742446536679",
            startPort = "Out",
            endQuest = "1781144742446536681",
            endPort = "In"
          },
          {
            startQuest = "1781144742446536676",
            startPort = "QuestStart",
            endQuest = "1781144742446536679",
            endPort = "In"
          },
          {
            startQuest = "1781144742446536676",
            startPort = "QuestStart",
            endQuest = "1781144742446536680",
            endPort = "In"
          },
          {
            startQuest = "1781144742446536680",
            startPort = "Out",
            endQuest = "1781144742446536682",
            endPort = "In"
          },
          {
            startQuest = "1781144742446536682",
            startPort = "Out",
            endQuest = "178116315810412349269",
            endPort = "In"
          },
          {
            startQuest = "178116315810412349269",
            startPort = "Out",
            endQuest = "1781144742446536675",
            endPort = "In"
          },
          {
            startQuest = "1781144742446536675",
            startPort = "Out",
            endQuest = "178116316584912349459",
            endPort = "In"
          },
          {
            startQuest = "178116316584912349459",
            startPort = "Out",
            endQuest = "1781144742446536677",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781144742446536675"] = {
            key = "1781144742446536675",
            type = "TalkNode",
            name = "逃离执律阁",
            pos = {x = 1686.8283817434267, y = 564},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC006/Ver0102_SC006",
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
          ["1781144742446536676"] = {
            key = "1781144742446536676",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742446536677"] = {
            key = "1781144742446536677",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2241.4285714285706, y = 584.2857142857143},
            propsData = {ModeType = 0}
          },
          ["1781144742446536678"] = {
            key = "1781144742446536678",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742446536679"] = {
            key = "1781144742446536679",
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
          ["1781144742446536680"] = {
            key = "1781144742446536680",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 912.0145196141955, y = 542.6907120531213},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104506,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742446536681"] = {
            key = "1781144742446536681",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 104506,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742446536682"] = {
            key = "1781144742446536682",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1262.2701623130522, y = 549.7318936728011},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "12020209teshu_242440006",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178116315810412349269"] = {
            key = "178116315810412349269",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1403.2684508586042, y = 724.2078195809216},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_1/0129_boss_yuming.0129_boss_yuming'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["178116316584912349459"] = {
            key = "178116316584912349459",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1977.5541651443186, y = 676.0825873827791},
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
