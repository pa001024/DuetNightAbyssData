return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742436534137",
      startPort = "StoryStart",
      endStory = "1781144742436534139",
      endPort = "In"
    },
    {
      startStory = "1781144742436534139",
      startPort = "Success",
      endStory = "1781144742436534138",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742436534137"] = {
      isStoryNode = true,
      key = "1781144742436534137",
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
    ["1781144742436534138"] = {
      isStoryNode = true,
      key = "1781144742436534138",
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
    ["1781144742436534139"] = {
      isStoryNode = true,
      key = "1781144742436534139",
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
            startQuest = "1781144742436534143",
            startPort = "Out",
            endQuest = "1781144742436534145",
            endPort = "In"
          },
          {
            startQuest = "1781144742436534140",
            startPort = "QuestStart",
            endQuest = "1781144742436534143",
            endPort = "In"
          },
          {
            startQuest = "1781144742436534140",
            startPort = "QuestStart",
            endQuest = "1781144742436534144",
            endPort = "In"
          },
          {
            startQuest = "1781144742436534144",
            startPort = "Out",
            endQuest = "1781144742436534146",
            endPort = "In"
          },
          {
            startQuest = "1781144742436534147",
            startPort = "Out",
            endQuest = "1781144742436534149",
            endPort = "In"
          },
          {
            startQuest = "1781144742436534149",
            startPort = "Out",
            endQuest = "1781144742436534141",
            endPort = "Success"
          },
          {
            startQuest = "1781144742436534146",
            startPort = "Out",
            endQuest = "1781144742436534147",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742436534140"] = {
            key = "1781144742436534140",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742436534141"] = {
            key = "1781144742436534141",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2245.242336610757, y = 583.5807788702526},
            propsData = {ModeType = 0}
          },
          ["1781144742436534142"] = {
            key = "1781144742436534142",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742436534143"] = {
            key = "1781144742436534143",
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
          ["1781144742436534144"] = {
            key = "1781144742436534144",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104104,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742436534145"] = {
            key = "1781144742436534145",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 104104,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742436534146"] = {
            key = "1781144742436534146",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1122.242212002493, y = 548.8778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_FixSimple_39_fushu",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1781144742436534147"] = {
            key = "1781144742436534147",
            type = "TalkNode",
            name = "无由生营地开启",
            pos = {x = 1682.8123566639379, y = 582.145933014354},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC008/SQ_Ver0101_SC008",
              BlendOutTime = 0,
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
              EndNewTargetPointName = "QuestPoint0205",
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
          ["1781144742436534149"] = {
            key = "1781144742436534149",
            type = "PlayOrStopBGMNode",
            name = "bgm - zhuizhuzhan  - start",
            pos = {x = 1968.5, y = 582},
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
