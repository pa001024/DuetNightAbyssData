return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17800515785515426090",
      startPort = "StoryStart",
      endStory = "17800515785515426092",
      endPort = "In"
    },
    {
      startStory = "17800515785515426092",
      startPort = "Success",
      endStory = "17800515785515426091",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17800515785515426090"] = {
      isStoryNode = true,
      key = "17800515785515426090",
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
    ["17800515785515426091"] = {
      isStoryNode = true,
      key = "17800515785515426091",
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
    ["17800515785515426092"] = {
      isStoryNode = true,
      key = "17800515785515426092",
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
            startQuest = "17800515785515426097",
            startPort = "Out",
            endQuest = "17800515785515426099",
            endPort = "In"
          },
          {
            startQuest = "17800515785515426094",
            startPort = "QuestStart",
            endQuest = "17800515785515426097",
            endPort = "In"
          },
          {
            startQuest = "17800515785515426094",
            startPort = "QuestStart",
            endQuest = "17800515785515426098",
            endPort = "In"
          },
          {
            startQuest = "17800515785515426098",
            startPort = "Out",
            endQuest = "17800515785515426100",
            endPort = "In"
          },
          {
            startQuest = "17800515785515426100",
            startPort = "Out",
            endQuest = "17800515785515426093",
            endPort = "In"
          },
          {
            startQuest = "17800515785515426093",
            startPort = "Out",
            endQuest = "17800510990032951291",
            endPort = "In"
          },
          {
            startQuest = "17800510990032951291",
            startPort = "Out",
            endQuest = "17800515785515426095",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17800510990032951291"] = {
            key = "17800510990032951291",
            type = "TalkNode",
            name = "过场-100120-发现黑桃身份-SC16",
            pos = {x = 1766.7826086956522, y = 565.4782608695652},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC016/SQ_OBT0100_SC016",
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
          },
          ["17800515785515426093"] = {
            key = "17800515785515426093",
            type = "PlayOrStopBGMNode",
            name = "bgm - xibi_p1  - end",
            pos = {x = 1444.735294117647, y = 564.3259803921569},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17800515785515426094"] = {
            key = "17800515785515426094",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17800515785515426095"] = {
            key = "17800515785515426095",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2126.505494505494, y = 561.835164835165},
            propsData = {ModeType = 0}
          },
          ["17800515785515426096"] = {
            key = "17800515785515426096",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17800515785515426097"] = {
            key = "17800515785515426097",
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
          ["17800515785515426098"] = {
            key = "17800515785515426098",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 100103,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17800515785515426099"] = {
            key = "17800515785515426099",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 100103,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17800515785515426100"] = {
            key = "17800515785515426100",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1122.242212002493, y = 548.8778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Quest_TargetPoint_BOSS",
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
