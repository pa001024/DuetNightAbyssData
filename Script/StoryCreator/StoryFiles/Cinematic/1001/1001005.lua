return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178056479687218618671",
      startPort = "StoryStart",
      endStory = "178056479687318618673",
      endPort = "In"
    },
    {
      startStory = "178056479687318618673",
      startPort = "Success",
      endStory = "178056479687318618672",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178056479687218618671"] = {
      isStoryNode = true,
      key = "178056479687218618671",
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
    ["178056479687318618672"] = {
      isStoryNode = true,
      key = "178056479687318618672",
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
    ["178056479687318618673"] = {
      isStoryNode = true,
      key = "178056479687318618673",
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
            startQuest = "178056479687318618677",
            startPort = "Out",
            endQuest = "178056479687318618679",
            endPort = "In"
          },
          {
            startQuest = "178056479687318618674",
            startPort = "QuestStart",
            endQuest = "178056479687318618677",
            endPort = "In"
          },
          {
            startQuest = "178056479687318618674",
            startPort = "QuestStart",
            endQuest = "178056479687318618678",
            endPort = "In"
          },
          {
            startQuest = "178056479687318618678",
            startPort = "Out",
            endQuest = "178056479687318618680",
            endPort = "In"
          },
          {
            startQuest = "178056479687318618680",
            startPort = "Out",
            endQuest = "178056477097218099391",
            endPort = "In"
          },
          {
            startQuest = "178056477097218099391",
            startPort = "Out",
            endQuest = "178056476204618099236",
            endPort = "In"
          },
          {
            startQuest = "178056476204618099236",
            startPort = "Out",
            endQuest = "178056477529318099524",
            endPort = "In"
          },
          {
            startQuest = "178056477529318099524",
            startPort = "Out",
            endQuest = "178056479687318618675",
            endPort = "Success"
          }
        },
        nodeData = {
          ["178056476204618099236"] = {
            key = "178056476204618099236",
            type = "TalkNode",
            name = "过场-100111-SC05-女神像",
            pos = {x = 1863.7142857142858, y = 568.2857142857143},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC005/SQ_OBT0100_SC005",
              BlendOutTime = 0.5,
              InType = "BlendIn",
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
              CameraLookAtTartgetPoint = "QuestPoint_Dx",
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
          ["178056477097218099391"] = {
            key = "178056477097218099391",
            type = "PlayOrStopBGMNode",
            name = "BGM - nvshenxiang - start",
            pos = {x = 1552.0902255639098, y = 571.187969924812},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "/Game/Asset/Audio/FMOD/Events/bgm/cbt01/0005_story_nvshenxiang",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["178056477529318099524"] = {
            key = "178056477529318099524",
            type = "PlayOrStopBGMNode",
            name = "BGM - nvshenxiang - start",
            pos = {x = 2154.375939849624, y = 592.6165413533835},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178056479687318618674"] = {
            key = "178056479687318618674",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178056479687318618675"] = {
            key = "178056479687318618675",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2408.095238095237, y = 582.6190476190477},
            propsData = {ModeType = 0}
          },
          ["178056479687318618676"] = {
            key = "178056479687318618676",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178056479687318618677"] = {
            key = "178056479687318618677",
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
          ["178056479687318618678"] = {
            key = "178056479687318618678",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 910.3478529475288, y = 542.6907120531213},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 100101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178056479687318618679"] = {
            key = "178056479687318618679",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 100101,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178056479687318618680"] = {
            key = "178056479687318618680",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1262.2701623130522, y = 549.7318936728011},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint_Dx",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
