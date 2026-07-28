return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17817670258803202593",
      startPort = "StoryStart",
      endStory = "17817670266673202626",
      endPort = "In"
    },
    {
      startStory = "17817670266673202626",
      startPort = "Success",
      endStory = "17817670258813202596",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17817670258803202593"] = {
      isStoryNode = true,
      key = "17817670258803202593",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1102, y = 352},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17817670258813202596"] = {
      isStoryNode = true,
      key = "17817670258813202596",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1910, y = 356},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17817670266673202626"] = {
      isStoryNode = true,
      key = "17817670266673202626",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1468, y = 384},
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
            startQuest = "17817670266673202634",
            startPort = "Out",
            endQuest = "17817670266673202636",
            endPort = "In"
          },
          {
            startQuest = "17817670266673202631",
            startPort = "QuestStart",
            endQuest = "17817670266673202634",
            endPort = "In"
          },
          {
            startQuest = "17817670266673202631",
            startPort = "QuestStart",
            endQuest = "17817670266673202635",
            endPort = "In"
          },
          {
            startQuest = "17817670266673202639",
            startPort = "Out",
            endQuest = "17817670266673202632",
            endPort = "Success"
          },
          {
            startQuest = "17817670266673202638",
            startPort = "Out",
            endQuest = "17817670696783203191",
            endPort = "In"
          },
          {
            startQuest = "17817670696783203191",
            startPort = "Out",
            endQuest = "17817670266673202639",
            endPort = "In"
          },
          {
            startQuest = "17817670266673202635",
            startPort = "Out",
            endQuest = "17817670266673202638",
            endPort = "In"
          }
        },
        nodeData = {
          ["17817670266673202631"] = {
            key = "17817670266673202631",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17817670266673202632"] = {
            key = "17817670266673202632",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["17817670266673202633"] = {
            key = "17817670266673202633",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17817670266673202634"] = {
            key = "17817670266673202634",
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
          ["17817670266673202635"] = {
            key = "17817670266673202635",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 549.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17817670266673202636"] = {
            key = "17817670266673202636",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 101101,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17817670266673202638"] = {
            key = "17817670266673202638",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1497.4564977167786, y = 533.5207135485774},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "TargetPoint_icelakecity",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17817670266673202639"] = {
            key = "17817670266673202639",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17817670696783203191"] = {
            key = "17817670696783203191",
            type = "TalkNode",
            name = "人为刀俎",
            pos = {x = 1871.2143975818447, y = 572.5014133911129},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC002/SQ_OBT0101_SC002",
              InType = "BlendIn",
              OutType = "BlendOut",
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
