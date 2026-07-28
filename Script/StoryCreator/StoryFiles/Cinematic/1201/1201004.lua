return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742433533543",
      startPort = "StoryStart",
      endStory = "1781144742433533545",
      endPort = "In"
    },
    {
      startStory = "1781144742433533545",
      startPort = "Success",
      endStory = "1781144742433533544",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742433533543"] = {
      isStoryNode = true,
      key = "1781144742433533543",
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
    ["1781144742433533544"] = {
      isStoryNode = true,
      key = "1781144742433533544",
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
    ["1781144742433533545"] = {
      isStoryNode = true,
      key = "1781144742433533545",
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
            startQuest = "1781144742433533549",
            startPort = "Out",
            endQuest = "1781144742433533551",
            endPort = "In"
          },
          {
            startQuest = "1781144742433533546",
            startPort = "QuestStart",
            endQuest = "1781144742433533549",
            endPort = "In"
          },
          {
            startQuest = "1781144742433533546",
            startPort = "QuestStart",
            endQuest = "1781144742433533550",
            endPort = "In"
          },
          {
            startQuest = "1781144742433533550",
            startPort = "Out",
            endQuest = "1781144742433533552",
            endPort = "In"
          },
          {
            startQuest = "1781144742433533553",
            startPort = "Out",
            endQuest = "1781144742433533554",
            endPort = "In"
          },
          {
            startQuest = "1781144742433533554",
            startPort = "Out",
            endQuest = "1781144742433533547",
            endPort = "Success"
          },
          {
            startQuest = "17811805971894168854",
            startPort = "Out",
            endQuest = "1781144742433533553",
            endPort = "In"
          },
          {
            startQuest = "1781144742433533552",
            startPort = "Out",
            endQuest = "17811805971894168854",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742433533546"] = {
            key = "1781144742433533546",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742433533547"] = {
            key = "1781144742433533547",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2273.809523809523, y = 582.6190476190477},
            propsData = {ModeType = 0}
          },
          ["1781144742433533548"] = {
            key = "1781144742433533548",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742433533549"] = {
            key = "1781144742433533549",
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
          ["1781144742433533550"] = {
            key = "1781144742433533550",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 910.3478529475288, y = 542.6907120531213},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104103,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742433533551"] = {
            key = "1781144742433533551",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 104103,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742433533552"] = {
            key = "1781144742433533552",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1262.2701623130522, y = 549.7318936728011},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "RegionPoint_Cav_Door01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1781144742433533553"] = {
            key = "1781144742433533553",
            type = "TalkNode",
            name = "主角加入战斗",
            pos = {x = 1871.142857142857, y = 567.7142857142857},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC004/SQ_Ver0101_SC004",
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
          ["1781144742433533554"] = {
            key = "1781144742433533554",
            type = "PlayOrStopBGMNode",
            name = "BGM - cunzhuang - end",
            pos = {x = 2143.105590062112, y = 322.32298136645966},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17811805971894168854"] = {
            key = "17811805971894168854",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1573.8874680306906, y = 758.2269484452822},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/1_1/0107_story_zhuyinzhizai_full",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {104103}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
