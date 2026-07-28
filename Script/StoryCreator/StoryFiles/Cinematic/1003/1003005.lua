return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781167101916531505",
      startPort = "StoryStart",
      endStory = "1781167101916531507",
      endPort = "In"
    },
    {
      startStory = "1781167101916531507",
      startPort = "Success",
      endStory = "1781167101916531506",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781167101916531505"] = {
      isStoryNode = true,
      key = "1781167101916531505",
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
    ["1781167101916531506"] = {
      isStoryNode = true,
      key = "1781167101916531506",
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
    ["1781167101916531507"] = {
      isStoryNode = true,
      key = "1781167101916531507",
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
            startQuest = "1781167101916531512",
            startPort = "Out",
            endQuest = "1781167101916531514",
            endPort = "In"
          },
          {
            startQuest = "1781167101916531509",
            startPort = "QuestStart",
            endQuest = "1781167101916531512",
            endPort = "In"
          },
          {
            startQuest = "1781167101916531509",
            startPort = "QuestStart",
            endQuest = "1781167101916531513",
            endPort = "In"
          },
          {
            startQuest = "1781167101916531513",
            startPort = "Out",
            endQuest = "1781167101916531515",
            endPort = "In"
          },
          {
            startQuest = "1781167101916531515",
            startPort = "Out",
            endQuest = "17811687363895101841",
            endPort = "In"
          },
          {
            startQuest = "17811687363895101841",
            startPort = "Out",
            endQuest = "17811687363895101840",
            endPort = "In"
          },
          {
            startQuest = "17811687363895101840",
            startPort = "Out",
            endQuest = "17811687407025101981",
            endPort = "In"
          },
          {
            startQuest = "17811687407025101981",
            startPort = "Out",
            endQuest = "1781167101916531510",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781167101916531509"] = {
            key = "1781167101916531509",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781167101916531510"] = {
            key = "1781167101916531510",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2159.505494505494, y = 549.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781167101916531511"] = {
            key = "1781167101916531511",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781167101916531512"] = {
            key = "1781167101916531512",
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
          ["1781167101916531513"] = {
            key = "1781167101916531513",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101901,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781167101916531514"] = {
            key = "1781167101916531514",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 101901,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781167101916531515"] = {
            key = "1781167101916531515",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "cp2thea2spspawnpoint5kelaifu",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17811687363895101840"] = {
            key = "17811687363895101840",
            type = "TalkNode",
            name = "过场",
            pos = {x = 1640.91205657088, y = 767.4757409257409},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0103/OBT0103_SC005/SQ_OBT0103_SC005",
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
          ["17811687363895101841"] = {
            key = "17811687363895101841",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1473.7288397876632, y = 581.3837828837828},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/mute",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {101901}
            }
          },
          ["17811687407025101981"] = {
            key = "17811687407025101981",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1869.9204481792717, y = 675.0297619047619},
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
