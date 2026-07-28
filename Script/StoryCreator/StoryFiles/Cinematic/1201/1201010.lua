return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742437534439",
      startPort = "StoryStart",
      endStory = "1781144742437534441",
      endPort = "In"
    },
    {
      startStory = "1781144742437534441",
      startPort = "Success",
      endStory = "1781144742437534440",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742437534439"] = {
      isStoryNode = true,
      key = "1781144742437534439",
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
    ["1781144742437534440"] = {
      isStoryNode = true,
      key = "1781144742437534440",
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
    ["1781144742437534441"] = {
      isStoryNode = true,
      key = "1781144742437534441",
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
            startQuest = "1781144742437534447",
            startPort = "Out",
            endQuest = "1781144742437534449",
            endPort = "In"
          },
          {
            startQuest = "1781144742437534444",
            startPort = "QuestStart",
            endQuest = "1781144742437534447",
            endPort = "In"
          },
          {
            startQuest = "1781144742437534444",
            startPort = "QuestStart",
            endQuest = "1781144742437534448",
            endPort = "In"
          },
          {
            startQuest = "1781144742437534448",
            startPort = "Out",
            endQuest = "1781144742437534450",
            endPort = "In"
          },
          {
            startQuest = "1781144742437534450",
            startPort = "Out",
            endQuest = "178118335037614580540",
            endPort = "In"
          },
          {
            startQuest = "178118335037614580540",
            startPort = "Out",
            endQuest = "1781144742437534443",
            endPort = "In"
          },
          {
            startQuest = "1781144742437534443",
            startPort = "Out",
            endQuest = "178118335545214580671",
            endPort = "In"
          },
          {
            startQuest = "178118335545214580671",
            startPort = "Out",
            endQuest = "1781144742437534445",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781144742437534443"] = {
            key = "1781144742437534443",
            type = "TalkNode",
            name = "虬先生袭击玩家",
            pos = {x = 1707.0562613430125, y = 582.5843920145192},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC010/SQ_Ver0101_SC010",
              BlendOutTime = 0.5,
              InType = "BlendIn",
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
              EndNewTargetPointName = "QuestPoint10507",
              CameraLookAtTartgetPoint = "QuestPoint10507_Look",
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
          ["1781144742437534444"] = {
            key = "1781144742437534444",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742437534445"] = {
            key = "1781144742437534445",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2126.505494505494, y = 561.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781144742437534446"] = {
            key = "1781144742437534446",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742437534447"] = {
            key = "1781144742437534447",
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
          ["1781144742437534448"] = {
            key = "1781144742437534448",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104102,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742437534449"] = {
            key = "1781144742437534449",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 104102,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742437534450"] = {
            key = "1781144742437534450",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1122.242212002493, y = 548.8778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint_BattWonderland",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178118335037614580540"] = {
            key = "178118335037614580540",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1515.5052400270456, y = 697.7682555780934},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/1_1/0128_cs_qiusir_attack_player",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {104102}
            }
          },
          ["178118335545214580671"] = {
            key = "178118335545214580671",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2006.8845503718733, y = 706.044117647059},
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
