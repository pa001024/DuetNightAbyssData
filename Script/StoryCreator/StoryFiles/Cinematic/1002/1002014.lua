return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17817674211064270210",
      startPort = "StoryStart",
      endStory = "17817674218274270246",
      endPort = "In"
    },
    {
      startStory = "17817674218274270246",
      startPort = "Success",
      endStory = "17817674211074270213",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17817674211064270210"] = {
      isStoryNode = true,
      key = "17817674211064270210",
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
    ["17817674211074270213"] = {
      isStoryNode = true,
      key = "17817674211074270213",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2022, y = 356},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17817674218274270246"] = {
      isStoryNode = true,
      key = "17817674218274270246",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1494, y = 380},
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
            startQuest = "17817674218274270254",
            startPort = "Out",
            endQuest = "17817674218274270256",
            endPort = "In"
          },
          {
            startQuest = "17817674218274270251",
            startPort = "QuestStart",
            endQuest = "17817674218274270254",
            endPort = "In"
          },
          {
            startQuest = "17817674218274270251",
            startPort = "QuestStart",
            endQuest = "17817674218274270255",
            endPort = "In"
          },
          {
            startQuest = "17817674218274270259",
            startPort = "Out",
            endQuest = "17817674218274270252",
            endPort = "Success"
          },
          {
            startQuest = "17817674218274270258",
            startPort = "Out",
            endQuest = "17817685252414270716",
            endPort = "In"
          },
          {
            startQuest = "17817685252414270716",
            startPort = "Out",
            endQuest = "17817674218274270259",
            endPort = "In"
          },
          {
            startQuest = "17817674218274270255",
            startPort = "Out",
            endQuest = "17817674218274270258",
            endPort = "In"
          }
        },
        nodeData = {
          ["17817674218274270251"] = {
            key = "17817674218274270251",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17817674218274270252"] = {
            key = "17817674218274270252",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["17817674218274270253"] = {
            key = "17817674218274270253",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17817674218274270254"] = {
            key = "17817674218274270254",
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
          ["17817674218274270255"] = {
            key = "17817674218274270255",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 815.2236293450444, y = 549.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101702,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17817674218274270256"] = {
            key = "17817674218274270256",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 101702,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17817674218274270258"] = {
            key = "17817674218274270258",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1497.4564977167786, y = 533.5207135485774},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "101032Bai2",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17817674218274270259"] = {
            key = "17817674218274270259",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17817685252414270716"] = {
            key = "17817685252414270716",
            type = "TalkNode",
            name = "我们的方式",
            pos = {x = 1885.038294032457, y = 528.1729285178627},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC014/SQ_OBT0101_SC014",
              InType = "BlendIn",
              OutType = "BlendOut",
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = false,
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
