return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "110200500001",
      startPort = "StoryStart",
      endStory = "110200500003",
      endPort = "In"
    },
    {
      startStory = "110200500003",
      startPort = "Success",
      endStory = "110200500002",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["110200500001"] = {
      isStoryNode = true,
      key = "110200500001",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 0}
    },
    ["110200500002"] = {
      isStoryNode = true,
      key = "110200500002",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1700, y = 300},
      propsData = {}
    },
    ["110200500003"] = {
      isStoryNode = true,
      key = "110200500003",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1250, y = 300},
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
            startQuest = "110200510001",
            startPort = "QuestStart",
            endQuest = "110200510003",
            endPort = "In"
          },
          {
            startQuest = "110200510003",
            startPort = "Out",
            endQuest = "110200510004",
            endPort = "In"
          },
          {
            startQuest = "110200510001",
            startPort = "QuestStart",
            endQuest = "110200510005",
            endPort = "In"
          },
          {
            startQuest = "110200510005",
            startPort = "Out",
            endQuest = "110200510006",
            endPort = "In"
          },
          {
            startQuest = "110200510006",
            startPort = "Out",
            endQuest = "110200510007",
            endPort = "In"
          },
          {
            startQuest = "110200510007",
            startPort = "Out",
            endQuest = "178168301593214719901",
            endPort = "In"
          },
          {
            startQuest = "178168301593214719901",
            startPort = "Out",
            endQuest = "110200510008",
            endPort = "In"
          },
          {
            startQuest = "110200510008",
            startPort = "Out",
            endQuest = "110200510002",
            endPort = "Success"
          }
        },
        nodeData = {
          ["110200510001"] = {
            key = "110200510001",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 600, y = 500},
            propsData = {ModeType = 0}
          },
          ["110200510002"] = {
            key = "110200510002",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2400, y = 700},
            propsData = {ModeType = 0}
          },
          ["110200510003"] = {
            key = "110200510003",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 900, y = 320},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["110200510004"] = {
            key = "110200510004",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1250, y = 320},
            propsData = {
              ModeType = 1,
              Id = 107201,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["110200510005"] = {
            key = "110200510005",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 900, y = 650},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 107201,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["110200510006"] = {
            key = "110200510006",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1200, y = 650},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "tp_lxzx_rebirth08",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["110200510007"] = {
            key = "110200510007",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1520, y = 650},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/cbt02/0061_scene_ex01_escape",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {107201}
            }
          },
          ["178168301593214719901"] = {
            key = "178168301593214719901",
            type = "TalkNode",
            name = "【Ver0105_SC005】",
            pos = {x = 1840, y = 650},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0105/Ver0105_SC005/SQ_Ver0105_SC005",
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
              HideNpcs = true,
              HideMonsters = true,
              bHidePickup = true,
              bHideSkillCreature = true,
              bHideSceneEffects = true,
              HideMechanismsFX = false,
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
          ["110200510008"] = {
            key = "110200510008",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2160, y = 650},
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
