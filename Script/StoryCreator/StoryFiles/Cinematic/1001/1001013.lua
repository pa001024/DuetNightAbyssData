return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178056490780319625435",
      startPort = "StoryStart",
      endStory = "178056490780319625437",
      endPort = "In"
    },
    {
      startStory = "178056490780319625437",
      startPort = "Success",
      endStory = "178056490780319625436",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178056490780319625435"] = {
      isStoryNode = true,
      key = "178056490780319625435",
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
    ["178056490780319625436"] = {
      isStoryNode = true,
      key = "178056490780319625436",
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
    ["178056490780319625437"] = {
      isStoryNode = true,
      key = "178056490780319625437",
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
            startQuest = "178056490780419625443",
            startPort = "Out",
            endQuest = "178056490780419625445",
            endPort = "In"
          },
          {
            startQuest = "178056490780319625440",
            startPort = "QuestStart",
            endQuest = "178056490780419625443",
            endPort = "In"
          },
          {
            startQuest = "178056490780319625440",
            startPort = "QuestStart",
            endQuest = "178056490780419625444",
            endPort = "In"
          },
          {
            startQuest = "178056490780419625444",
            startPort = "Out",
            endQuest = "178056490780419625446",
            endPort = "In"
          },
          {
            startQuest = "178056490780419625446",
            startPort = "Out",
            endQuest = "178056490780319625438",
            endPort = "In"
          },
          {
            startQuest = "178056490780319625439",
            startPort = "Out",
            endQuest = "178056490780419625441",
            endPort = "Success"
          },
          {
            startQuest = "178056490780319625438",
            startPort = "Out",
            endQuest = "178056487955819105301",
            endPort = "In"
          },
          {
            startQuest = "178056487955819105301",
            startPort = "Out",
            endQuest = "178056490780319625439",
            endPort = "In"
          }
        },
        nodeData = {
          ["178056487955819105301"] = {
            key = "178056487955819105301",
            type = "TalkNode",
            name = "过场-100112-SC13-插剑",
            pos = {x = 1858.7272727272727, y = 571.2727272727273},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC013/SQ_OBT0100_SC013",
              BlendInTime = 0,
              BlendOutTime = 0.5,
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
          ["178056490780319625438"] = {
            key = "178056490780319625438",
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
          ["178056490780319625439"] = {
            key = "178056490780319625439",
            type = "PlayOrStopBGMNode",
            name = "BGM - nvshenxiang - start",
            pos = {x = 2156.375939849624, y = 592.6165413533835},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178056490780319625440"] = {
            key = "178056490780319625440",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178056490780419625441"] = {
            key = "178056490780419625441",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2408.095238095237, y = 582.6190476190477},
            propsData = {ModeType = 0}
          },
          ["178056490780419625442"] = {
            key = "178056490780419625442",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178056490780419625443"] = {
            key = "178056490780419625443",
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
          ["178056490780419625444"] = {
            key = "178056490780419625444",
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
          ["178056490780419625445"] = {
            key = "178056490780419625445",
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
          ["178056490780419625446"] = {
            key = "178056490780419625446",
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
