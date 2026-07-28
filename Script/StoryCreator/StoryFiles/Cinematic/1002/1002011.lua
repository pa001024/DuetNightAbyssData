return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178211115109922438934",
      startPort = "StoryStart",
      endStory = "178211115159422438959",
      endPort = "In"
    },
    {
      startStory = "178211115159422438959",
      startPort = "Success",
      endStory = "178211115109922438937",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178211115109922438934"] = {
      isStoryNode = true,
      key = "178211115109922438934",
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
    ["178211115109922438937"] = {
      isStoryNode = true,
      key = "178211115109922438937",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2108, y = 310},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178211115159422438959"] = {
      isStoryNode = true,
      key = "178211115159422438959",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1488, y = 354},
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
            startQuest = "178211115159422438967",
            startPort = "Out",
            endQuest = "178211115159422438969",
            endPort = "In"
          },
          {
            startQuest = "178211115159422438964",
            startPort = "QuestStart",
            endQuest = "178211115159422438967",
            endPort = "In"
          },
          {
            startQuest = "178211115159422438964",
            startPort = "QuestStart",
            endQuest = "178211115159422438968",
            endPort = "In"
          },
          {
            startQuest = "178211115159422438972",
            startPort = "Out",
            endQuest = "178211115159422438965",
            endPort = "Success"
          },
          {
            startQuest = "178211115159422438971",
            startPort = "Out",
            endQuest = "178211116312022439298",
            endPort = "In"
          },
          {
            startQuest = "178211116312022439298",
            startPort = "Out",
            endQuest = "178211116062322439260",
            endPort = "In"
          },
          {
            startQuest = "178211116062322439260",
            startPort = "Out",
            endQuest = "178211115159422438972",
            endPort = "In"
          },
          {
            startQuest = "178211115159422438968",
            startPort = "Out",
            endQuest = "178211115159422438971",
            endPort = "In"
          }
        },
        nodeData = {
          ["178211115159422438964"] = {
            key = "178211115159422438964",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178211115159422438965"] = {
            key = "178211115159422438965",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["178211115159422438966"] = {
            key = "178211115159422438966",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178211115159422438967"] = {
            key = "178211115159422438967",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1207.6839468053622, y = 301.4843628467721},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178211115159422438968"] = {
            key = "178211115159422438968",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 815.2236293450444, y = 549.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101402,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178211115159422438969"] = {
            key = "178211115159422438969",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1529.960562587241, y = 321.9877653748314},
            propsData = {
              ModeType = 1,
              Id = 101402,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178211115159422438971"] = {
            key = "178211115159422438971",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1335.4564977167786, y = 546.1728874616209},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "P_StartPoint3",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178211115159422438972"] = {
            key = "178211115159422438972",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 553.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178211116062322439260"] = {
            key = "178211116062322439260",
            type = "TalkNode",
            name = "过场动画 飞向太阳",
            pos = {x = 1976.1277650648358, y = 527.9073226544623},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC011/SQ_OBT0101_SC011",
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
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["178211116312022439298"] = {
            key = "178211116312022439298",
            type = "PlayOrStopBGMNode",
            name = "播放bgm",
            pos = {x = 1677.4321128909228, y = 527.5594965675058},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/cbt02/0056_story_saiqi_fly_to_sun",
              ParamKey = "state",
              ParamValue = 1,
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
