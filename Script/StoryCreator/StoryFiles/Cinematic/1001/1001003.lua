return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17805606025862529690",
      startPort = "StoryStart",
      endStory = "17805606025862529692",
      endPort = "In"
    },
    {
      startStory = "17805606025862529692",
      startPort = "Success",
      endStory = "17805606025862529691",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17805606025862529690"] = {
      isStoryNode = true,
      key = "17805606025862529690",
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
    ["17805606025862529691"] = {
      isStoryNode = true,
      key = "17805606025862529691",
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
    ["17805606025862529692"] = {
      isStoryNode = true,
      key = "17805606025862529692",
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
            startQuest = "17805606025862529696",
            startPort = "Out",
            endQuest = "17805606025862529698",
            endPort = "In"
          },
          {
            startQuest = "17805606025862529693",
            startPort = "QuestStart",
            endQuest = "17805606025862529696",
            endPort = "In"
          },
          {
            startQuest = "17805606025862529693",
            startPort = "QuestStart",
            endQuest = "17805606025862529697",
            endPort = "In"
          },
          {
            startQuest = "17805606025862529697",
            startPort = "Out",
            endQuest = "17805606025862529699",
            endPort = "In"
          },
          {
            startQuest = "17805606025862529699",
            startPort = "Out",
            endQuest = "17805605496912010955",
            endPort = "In"
          },
          {
            startQuest = "17805605496912010955",
            startPort = "Out",
            endQuest = "17805605181882010596",
            endPort = "In"
          },
          {
            startQuest = "17805605181882010596",
            startPort = "Out",
            endQuest = "17805635513518045523",
            endPort = "In"
          },
          {
            startQuest = "17805635513518045523",
            startPort = "Out",
            endQuest = "17805606025862529694",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17805605181882010596"] = {
            key = "17805605181882010596",
            type = "TalkNode",
            name = "过场-100101-醒来",
            pos = {x = 1875.7614171977652, y = 567.7391304347826},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC003/SQ_OBT0100_SC003",
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
          ["17805605496912010955"] = {
            key = "17805605496912010955",
            type = "PlayOrStopBGMNode",
            name = "Mute屏蔽场景音效",
            pos = {x = 1576.6091424504064, y = 592.900457665904},
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
          ["17805606025862529693"] = {
            key = "17805606025862529693",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17805606025862529694"] = {
            key = "17805606025862529694",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2409.9999999999995, y = 562.857142857143},
            propsData = {ModeType = 0}
          },
          ["17805606025862529695"] = {
            key = "17805606025862529695",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17805606025862529696"] = {
            key = "17805606025862529696",
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
          ["17805606025862529697"] = {
            key = "17805606025862529697",
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
          ["17805606025862529698"] = {
            key = "17805606025862529698",
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
          ["17805606025862529699"] = {
            key = "17805606025862529699",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1262.2701623130522, y = 549.7318936728011},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint6",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17805635513518045523"] = {
            key = "17805635513518045523",
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
