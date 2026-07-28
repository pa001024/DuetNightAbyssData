return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178116698305025463091",
      startPort = "StoryStart",
      endStory = "178116698376025463114",
      endPort = "In"
    },
    {
      startStory = "178116698376025463114",
      startPort = "Success",
      endStory = "178116698305025463094",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178116698305025463091"] = {
      isStoryNode = true,
      key = "178116698305025463091",
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
    ["178116698305025463094"] = {
      isStoryNode = true,
      key = "178116698305025463094",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1690, y = 302},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178116698376025463114"] = {
      isStoryNode = true,
      key = "178116698376025463114",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1275.5, y = 272},
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
            startQuest = "178116698376025463122",
            startPort = "Out",
            endQuest = "178116698376025463124",
            endPort = "In"
          },
          {
            startQuest = "178116698376025463119",
            startPort = "QuestStart",
            endQuest = "178116698376025463122",
            endPort = "In"
          },
          {
            startQuest = "178116698376025463119",
            startPort = "QuestStart",
            endQuest = "178116698376025463123",
            endPort = "In"
          },
          {
            startQuest = "178116698376025463123",
            startPort = "Out",
            endQuest = "178116698376025463125",
            endPort = "In"
          },
          {
            startQuest = "178116698376025463125",
            startPort = "Out",
            endQuest = "178116698376025463126",
            endPort = "In"
          },
          {
            startQuest = "178116698376025463127",
            startPort = "Out",
            endQuest = "178116698376025463120",
            endPort = "Success"
          },
          {
            startQuest = "178116698376025463126",
            startPort = "Out",
            endQuest = "178116698376025463128",
            endPort = "In"
          },
          {
            startQuest = "178116698376025463128",
            startPort = "Out",
            endQuest = "1781169489021488",
            endPort = "In"
          },
          {
            startQuest = "1781169489021488",
            startPort = "Out",
            endQuest = "178116698376025463127",
            endPort = "In"
          }
        },
        nodeData = {
          ["178116698376025463119"] = {
            key = "178116698376025463119",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["178116698376025463120"] = {
            key = "178116698376025463120",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["178116698376025463121"] = {
            key = "178116698376025463121",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178116698376025463122"] = {
            key = "178116698376025463122",
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
          ["178116698376025463123"] = {
            key = "178116698376025463123",
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
          ["178116698376025463124"] = {
            key = "178116698376025463124",
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
          ["178116698376025463125"] = {
            key = "178116698376025463125",
            type = "ChangeRoleNode",
            name = "切换角色-女主",
            pos = {x = 1086.102649719395, y = 537.806427834292},
            propsData = {QuestRoleId = 1010101, IsPlayFX = false}
          },
          ["178116698376025463126"] = {
            key = "178116698376025463126",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1364.8067281315252, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_HaluojiEnd",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178116698376025463127"] = {
            key = "178116698376025463127",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2232.7163104372185, y = 567.684265010352},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 1
            }
          },
          ["178116698376025463128"] = {
            key = "178116698376025463128",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1653.3286698251864, y = 569.5472203235364},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0171_combat_lieche_intro.0171_combat_lieche_intro'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["1781169489021488"] = {
            key = "1781169489021488",
            type = "TalkNode",
            name = "过场-Boss战出场",
            pos = {x = 1929.2518261150615, y = 554.0211861667746},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC020/SQ_Ver0104_SC020",
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
