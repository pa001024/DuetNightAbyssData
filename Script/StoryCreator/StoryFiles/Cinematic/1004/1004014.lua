return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178116494165612216437",
      startPort = "StoryStart",
      endStory = "178116494311912216468",
      endPort = "In"
    },
    {
      startStory = "178116494311912216468",
      startPort = "Success",
      endStory = "178116494165612216440",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178116494165612216437"] = {
      isStoryNode = true,
      key = "178116494165612216437",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1144, y = 302},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178116494165612216440"] = {
      isStoryNode = true,
      key = "178116494165612216440",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1944, y = 282},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178116494311912216468"] = {
      isStoryNode = true,
      key = "178116494311912216468",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1590, y = 294},
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
            startQuest = "178116494312012216476",
            startPort = "Out",
            endQuest = "178116494312012216478",
            endPort = "In"
          },
          {
            startQuest = "178116494311912216473",
            startPort = "QuestStart",
            endQuest = "178116494312012216476",
            endPort = "In"
          },
          {
            startQuest = "178116494311912216473",
            startPort = "QuestStart",
            endQuest = "178116494312012216477",
            endPort = "In"
          },
          {
            startQuest = "178116494312012216477",
            startPort = "Out",
            endQuest = "178116494312012216479",
            endPort = "In"
          },
          {
            startQuest = "178116494312012216479",
            startPort = "Out",
            endQuest = "178116494312012216480",
            endPort = "In"
          },
          {
            startQuest = "178116494312012216481",
            startPort = "Out",
            endQuest = "178116494312012216474",
            endPort = "Success"
          },
          {
            startQuest = "178116494312012216480",
            startPort = "Out",
            endQuest = "178116494312012216482",
            endPort = "In"
          },
          {
            startQuest = "178116494312012216482",
            startPort = "Out",
            endQuest = "178116519194113235456",
            endPort = "In"
          },
          {
            startQuest = "178116519194113235456",
            startPort = "Out",
            endQuest = "178116494312012216481",
            endPort = "In"
          }
        },
        nodeData = {
          ["178116494311912216473"] = {
            key = "178116494311912216473",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["178116494312012216474"] = {
            key = "178116494312012216474",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["178116494312012216475"] = {
            key = "178116494312012216475",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178116494312012216476"] = {
            key = "178116494312012216476",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 903.7709033271017, y = 272.1800150206852},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178116494312012216477"] = {
            key = "178116494312012216477",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 821.199819821235, y = 547.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 106101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178116494312012216478"] = {
            key = "178116494312012216478",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1307.2650144283061, y = 283.50950450526625},
            propsData = {
              ModeType = 1,
              Id = 106101,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178116494312012216479"] = {
            key = "178116494312012216479",
            type = "ChangeRoleNode",
            name = "切换角色-女主",
            pos = {x = 1086.102649719395, y = 537.806427834292},
            propsData = {QuestRoleId = 1010101, IsPlayFX = false}
          },
          ["178116494312012216480"] = {
            key = "178116494312012216480",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1366.742212002493, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_ZhujueBattle",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178116494312012216481"] = {
            key = "178116494312012216481",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2474.0206582633054, y = 545.5103519668737},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 1
            }
          },
          ["178116494312012216482"] = {
            key = "178116494312012216482",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1653.3286698251864, y = 569.5472203235364},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0169_cs_tiaoche.0169_cs_tiaoche'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["178116519194113235456"] = {
            key = "178116519194113235456",
            type = "TalkNode",
            name = "过场-跳车2",
            pos = {x = 1945.2191590582277, y = 597.5220137847247},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "SQ_Ver0104_SC014",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC014/SQ_Ver0104_SC014",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = false,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = false,
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
