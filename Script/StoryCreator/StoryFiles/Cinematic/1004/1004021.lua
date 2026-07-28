return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17811695231471025685",
      startPort = "Success",
      endStory = "17811695225051025657",
      endPort = "StoryEnd"
    },
    {
      startStory = "17811695225041025654",
      startPort = "StoryStart",
      endStory = "17811695231471025685",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17811695225041025654"] = {
      isStoryNode = true,
      key = "17811695225041025654",
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
    ["17811695225051025657"] = {
      isStoryNode = true,
      key = "17811695225051025657",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1628, y = 244},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17811695231471025685"] = {
      isStoryNode = true,
      key = "17811695231471025685",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1148, y = 246},
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
            startQuest = "17811695231471025693",
            startPort = "Out",
            endQuest = "17811695231471025695",
            endPort = "In"
          },
          {
            startQuest = "17811695231471025690",
            startPort = "QuestStart",
            endQuest = "17811695231471025693",
            endPort = "In"
          },
          {
            startQuest = "17811695231471025690",
            startPort = "QuestStart",
            endQuest = "17811695231471025694",
            endPort = "In"
          },
          {
            startQuest = "17811695231471025694",
            startPort = "Out",
            endQuest = "17811695231471025696",
            endPort = "In"
          },
          {
            startQuest = "17811695231471025696",
            startPort = "Out",
            endQuest = "17811695231471025697",
            endPort = "In"
          },
          {
            startQuest = "17811695231471025698",
            startPort = "Out",
            endQuest = "17811695231471025691",
            endPort = "Success"
          },
          {
            startQuest = "17811695231471025697",
            startPort = "Out",
            endQuest = "17811695231471025699",
            endPort = "In"
          },
          {
            startQuest = "17811695231471025699",
            startPort = "Out",
            endQuest = "17811695231471025700",
            endPort = "In"
          },
          {
            startQuest = "17811695231471025700",
            startPort = "Out",
            endQuest = "17811695231471025698",
            endPort = "In"
          }
        },
        nodeData = {
          ["17811695231471025690"] = {
            key = "17811695231471025690",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["17811695231471025691"] = {
            key = "17811695231471025691",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["17811695231471025692"] = {
            key = "17811695231471025692",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17811695231471025693"] = {
            key = "17811695231471025693",
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
          ["17811695231471025694"] = {
            key = "17811695231471025694",
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
          ["17811695231471025695"] = {
            key = "17811695231471025695",
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
          ["17811695231471025696"] = {
            key = "17811695231471025696",
            type = "ChangeRoleNode",
            name = "切换角色-女主",
            pos = {x = 1086.102649719395, y = 537.806427834292},
            propsData = {QuestRoleId = 1010101, IsPlayFX = false}
          },
          ["17811695231471025697"] = {
            key = "17811695231471025697",
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
          ["17811695231471025698"] = {
            key = "17811695231471025698",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2232.7163104372185, y = 567.684265010352},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 1
            }
          },
          ["17811695231471025699"] = {
            key = "17811695231471025699",
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
          ["17811695231471025700"] = {
            key = "17811695231471025700",
            type = "TalkNode",
            name = "过场-Boss战出场",
            pos = {x = 1929.2518261150615, y = 554.0211861667746},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "LevelSequence'/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC021/SQ_Ver0104_SC021.SQ_Ver0104_SC021'",
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
