return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178125475606220608661",
      startPort = "StoryStart",
      endStory = "178125475693920608697",
      endPort = "In"
    },
    {
      startStory = "178125475693920608697",
      startPort = "Success",
      endStory = "178125475606320608664",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178125475606220608661"] = {
      isStoryNode = true,
      key = "178125475606220608661",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 990, y = 340},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178125475606320608664"] = {
      isStoryNode = true,
      key = "178125475606320608664",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2088, y = 392},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178125475693920608697"] = {
      isStoryNode = true,
      key = "178125475693920608697",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1542, y = 368},
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
            startQuest = "178125475693920608705",
            startPort = "Out",
            endQuest = "178125475693920608707",
            endPort = "In"
          },
          {
            startQuest = "178125475693920608702",
            startPort = "QuestStart",
            endQuest = "178125475693920608705",
            endPort = "In"
          },
          {
            startQuest = "178125475693920608702",
            startPort = "QuestStart",
            endQuest = "178125475693920608706",
            endPort = "In"
          },
          {
            startQuest = "178125475693920608710",
            startPort = "Out",
            endQuest = "178125475693920608703",
            endPort = "Success"
          },
          {
            startQuest = "178125482034921650199",
            startPort = "Out",
            endQuest = "178125475693920608710",
            endPort = "In"
          },
          {
            startQuest = "178125475693920608709",
            startPort = "Out",
            endQuest = "178125483136221650508",
            endPort = "In"
          },
          {
            startQuest = "178125483136221650508",
            startPort = "Out",
            endQuest = "178125482034921650199",
            endPort = "In"
          },
          {
            startQuest = "178125475693920608706",
            startPort = "Out",
            endQuest = "178125475693920608709",
            endPort = "In"
          }
        },
        nodeData = {
          ["178125475693920608702"] = {
            key = "178125475693920608702",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["178125475693920608703"] = {
            key = "178125475693920608703",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["178125475693920608704"] = {
            key = "178125475693920608704",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178125475693920608705"] = {
            key = "178125475693920608705",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 903.7709033271017, y = 272.1800150206852},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178125475693920608706"] = {
            key = "178125475693920608706",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 821.199819821235, y = 547.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 102101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178125475693920608707"] = {
            key = "178125475693920608707",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1307.2650144283061, y = 283.50950450526625},
            propsData = {
              ModeType = 1,
              Id = 102101,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178125475693920608709"] = {
            key = "178125475693920608709",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1366.742212002493, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "pDafu11010301",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178125475693920608710"] = {
            key = "178125475693920608710",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2301.5206582633054, y = 556.2246376811594},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178125482034921650199"] = {
            key = "178125482034921650199",
            type = "TalkNode",
            name = "过场 - 达芙涅登场",
            pos = {x = 1940.3799079963264, y = 542.9702188269276},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC002/SQ_OBT0102_SC002",
              BlendInTime = 1,
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
          ["178125483136221650508"] = {
            key = "178125483136221650508",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1666.8504962316206, y = 551.7937482386923},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt02/0057_scene_ex01_prepare.0057_scene_ex01_prepare'",
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
