return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17817735016848542724",
      startPort = "StoryStart",
      endStory = "17817735021808542750",
      endPort = "In"
    },
    {
      startStory = "17817735021808542750",
      startPort = "Success",
      endStory = "17817735016848542727",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17817735016848542724"] = {
      isStoryNode = true,
      key = "17817735016848542724",
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
    ["17817735016848542727"] = {
      isStoryNode = true,
      key = "17817735016848542727",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1918, y = 330},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17817735021808542750"] = {
      isStoryNode = true,
      key = "17817735021808542750",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1362, y = 350},
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
            startQuest = "17817735021808542758",
            startPort = "Out",
            endQuest = "17817735021808542760",
            endPort = "In"
          },
          {
            startQuest = "17817735021808542755",
            startPort = "QuestStart",
            endQuest = "17817735021808542758",
            endPort = "In"
          },
          {
            startQuest = "17817735021808542755",
            startPort = "QuestStart",
            endQuest = "17817735021808542759",
            endPort = "In"
          },
          {
            startQuest = "17817735021808542763",
            startPort = "Out",
            endQuest = "17817735021808542756",
            endPort = "Success"
          },
          {
            startQuest = "17817735021808542762",
            startPort = "Out",
            endQuest = "17817735488198543312",
            endPort = "In"
          },
          {
            startQuest = "17817735488198543312",
            startPort = "Out",
            endQuest = "17817735434388543129",
            endPort = "In"
          },
          {
            startQuest = "17817735434388543129",
            startPort = "Out",
            endQuest = "17817735021808542763",
            endPort = "In"
          },
          {
            startQuest = "17817735021808542759",
            startPort = "Out",
            endQuest = "17817735021808542762",
            endPort = "In"
          }
        },
        nodeData = {
          ["17817735021808542755"] = {
            key = "17817735021808542755",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17817735021808542756"] = {
            key = "17817735021808542756",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["17817735021808542757"] = {
            key = "17817735021808542757",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17817735021808542758"] = {
            key = "17817735021808542758",
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
          ["17817735021808542759"] = {
            key = "17817735021808542759",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 815.2236293450444, y = 549.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101106,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17817735021808542760"] = {
            key = "17817735021808542760",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1528.38161521882, y = 321.9877653748314},
            propsData = {
              ModeType = 1,
              Id = 101106,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17817735021808542762"] = {
            key = "17817735021808542762",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1202.3213625816434, y = 532.5512658399992},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "P10106904",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17817735021808542763"] = {
            key = "17817735021808542763",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17817735434388543129"] = {
            key = "17817735434388543129",
            type = "TalkNode",
            name = "梳头发",
            pos = {x = 1867.8086814736039, y = 543.2696984813089},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "LevelSequence'/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC016/SQ_OBT0101_SC016.SQ_OBT0101_SC016'",
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
              TalkActors = {},
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["17817735488198543312"] = {
            key = "17817735488198543312",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1528.7607699256923, y = 528.6751038867142},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/mute",
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
