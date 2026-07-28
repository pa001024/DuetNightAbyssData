return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17800523229618378900",
      startPort = "StoryStart",
      endStory = "17800523229618378902",
      endPort = "In"
    },
    {
      startStory = "17800523229618378902",
      startPort = "Success",
      endStory = "17800523229618378901",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17800523229618378900"] = {
      isStoryNode = true,
      key = "17800523229618378900",
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
    ["17800523229618378901"] = {
      isStoryNode = true,
      key = "17800523229618378901",
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
    ["17800523229618378902"] = {
      isStoryNode = true,
      key = "17800523229618378902",
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
            startQuest = "17800523229618378906",
            startPort = "Out",
            endQuest = "17800523229618378908",
            endPort = "In"
          },
          {
            startQuest = "17800523229618378903",
            startPort = "QuestStart",
            endQuest = "17800523229618378906",
            endPort = "In"
          },
          {
            startQuest = "17800523229618378903",
            startPort = "QuestStart",
            endQuest = "17800523229618378907",
            endPort = "In"
          },
          {
            startQuest = "17800523229618378907",
            startPort = "Out",
            endQuest = "17800523229618378909",
            endPort = "In"
          },
          {
            startQuest = "17800523229618378909",
            startPort = "Out",
            endQuest = "17800511112563459087",
            endPort = "In"
          },
          {
            startQuest = "17800511112563459087",
            startPort = "Out",
            endQuest = "17800510408311967811",
            endPort = "In"
          },
          {
            startQuest = "17800510408311967811",
            startPort = "Out",
            endQuest = "17800523229618378904",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17800510408311967811"] = {
            key = "17800510408311967811",
            type = "TalkNode",
            name = "过场-100102-倒叙-SC18",
            pos = {x = 1765.735294117647, y = 571.8259803921569},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC018/SQ_OBT0100_SC018",
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
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["17800511112563459087"] = {
            key = "17800511112563459087",
            type = "PlayOrStopBGMNode",
            name = "bgm - xibi_p1  - end",
            pos = {x = 1444.735294117647, y = 564.3259803921569},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17800523229618378903"] = {
            key = "17800523229618378903",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17800523229618378904"] = {
            key = "17800523229618378904",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2126.505494505494, y = 561.835164835165},
            propsData = {ModeType = 0}
          },
          ["17800523229618378905"] = {
            key = "17800523229618378905",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17800523229618378906"] = {
            key = "17800523229618378906",
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
          ["17800523229618378907"] = {
            key = "17800523229618378907",
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
          ["17800523229618378908"] = {
            key = "17800523229618378908",
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
          ["17800523229618378909"] = {
            key = "17800523229618378909",
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
