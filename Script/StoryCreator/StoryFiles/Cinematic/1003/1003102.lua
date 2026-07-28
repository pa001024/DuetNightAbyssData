return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781167101916531241",
      startPort = "StoryStart",
      endStory = "1781167101916531243",
      endPort = "In"
    },
    {
      startStory = "1781167101916531243",
      startPort = "Success",
      endStory = "1781167101916531242",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781167101916531241"] = {
      isStoryNode = true,
      key = "1781167101916531241",
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
    ["1781167101916531242"] = {
      isStoryNode = true,
      key = "1781167101916531242",
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
    ["1781167101916531243"] = {
      isStoryNode = true,
      key = "1781167101916531243",
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
            startQuest = "1781167101916531248",
            startPort = "Out",
            endQuest = "1781167101916531250",
            endPort = "In"
          },
          {
            startQuest = "1781167101916531245",
            startPort = "QuestStart",
            endQuest = "1781167101916531248",
            endPort = "In"
          },
          {
            startQuest = "1781167101916531245",
            startPort = "QuestStart",
            endQuest = "1781167101916531249",
            endPort = "In"
          },
          {
            startQuest = "1781167101916531249",
            startPort = "Out",
            endQuest = "1781167101916531251",
            endPort = "In"
          },
          {
            startQuest = "17811681859064082340",
            startPort = "Out",
            endQuest = "17811685274183061269",
            endPort = "In"
          },
          {
            startQuest = "17811685274183061269",
            startPort = "Out",
            endQuest = "1781167101916531246",
            endPort = "Success"
          },
          {
            startQuest = "17811685266283061236",
            startPort = "Out",
            endQuest = "17811681859064082340",
            endPort = "In"
          },
          {
            startQuest = "1781167101916531251",
            startPort = "Out",
            endQuest = "17811685266283061236",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781167101916531245"] = {
            key = "1781167101916531245",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781167101916531246"] = {
            key = "1781167101916531246",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2159.505494505494, y = 549.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781167101916531247"] = {
            key = "1781167101916531247",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781167101916531248"] = {
            key = "1781167101916531248",
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
          ["1781167101916531249"] = {
            key = "1781167101916531249",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101703,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781167101916531250"] = {
            key = "1781167101916531250",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 101703,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781167101916531251"] = {
            key = "1781167101916531251",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "cp2sew1passivefailpoint3",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17811681859064082340"] = {
            key = "17811681859064082340",
            type = "TalkNode",
            name = "过场",
            pos = {x = 1637.3549829480858, y = 583.4557787040548},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0103/OBT0103_SC002/SQ_OBT0103_SC002_B",
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
          ["17811685266283061236"] = {
            key = "17811685266283061236",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1501.914705882353, y = 473.4749999999999},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/cbt03/0074_story_encounter_with_blues",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {101703}
            }
          },
          ["17811685274183061269"] = {
            key = "17811685274183061269",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1849.914705882353, y = 492.67500000000007},
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
