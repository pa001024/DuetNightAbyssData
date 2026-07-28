return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742455538489",
      startPort = "StoryStart",
      endStory = "1781144742455538491",
      endPort = "In"
    },
    {
      startStory = "1781144742455538491",
      startPort = "Success",
      endStory = "1781144742455538490",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742455538489"] = {
      isStoryNode = true,
      key = "1781144742455538489",
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
    ["1781144742455538490"] = {
      isStoryNode = true,
      key = "1781144742455538490",
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
    ["1781144742455538491"] = {
      isStoryNode = true,
      key = "1781144742455538491",
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
            startQuest = "1781144742456538497",
            startPort = "Out",
            endQuest = "1781144742456538499",
            endPort = "In"
          },
          {
            startQuest = "1781144742456538494",
            startPort = "QuestStart",
            endQuest = "1781144742456538497",
            endPort = "In"
          },
          {
            startQuest = "1781144742456538494",
            startPort = "QuestStart",
            endQuest = "1781144742456538498",
            endPort = "In"
          },
          {
            startQuest = "1781144742455538492",
            startPort = "Out",
            endQuest = "1781144742456538493",
            endPort = "In"
          },
          {
            startQuest = "1781144742456538493",
            startPort = "Out",
            endQuest = "1781144742456538495",
            endPort = "Success"
          },
          {
            startQuest = "178116781203842151930",
            startPort = "Out",
            endQuest = "1781144742455538492",
            endPort = "In"
          },
          {
            startQuest = "1781144742456538498",
            startPort = "Out",
            endQuest = "178116781203842151930",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742455538492"] = {
            key = "1781144742455538492",
            type = "TalkNode",
            name = "黑白合一",
            pos = {x = 1621.735294117647, y = 575.8259803921569},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC019/Ver0102_SC019",
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
          ["1781144742456538493"] = {
            key = "1781144742456538493",
            type = "PlayOrStopBGMNode",
            name = "bgm - xibi_p1  - end",
            pos = {x = 1879.735294117647, y = 694.3259803921569},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["1781144742456538494"] = {
            key = "1781144742456538494",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742456538495"] = {
            key = "1781144742456538495",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2126.505494505494, y = 561.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781144742456538496"] = {
            key = "1781144742456538496",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2219.428571428571, y = 825.1428571428571},
            propsData = {}
          },
          ["1781144742456538497"] = {
            key = "1781144742456538497",
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
          ["1781144742456538498"] = {
            key = "1781144742456538498",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104506,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742456538499"] = {
            key = "1781144742456538499",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 104506,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178116781203842151930"] = {
            key = "178116781203842151930",
            type = "PlayOrStopBGMNode",
            name = "播放暂停音乐",
            pos = {x = 1342, y = 508.1793478260869},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_3/0149_cs_two_lonng_merge.0149_cs_two_lonng_merge'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {104506}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
