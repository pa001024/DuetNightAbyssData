return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "110200300001",
      startPort = "StoryStart",
      endStory = "110200300003",
      endPort = "In"
    },
    {
      startStory = "110200300003",
      startPort = "Success",
      endStory = "110200300002",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["110200300001"] = {
      isStoryNode = true,
      key = "110200300001",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 0}
    },
    ["110200300002"] = {
      isStoryNode = true,
      key = "110200300002",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1700, y = 300},
      propsData = {}
    },
    ["110200300003"] = {
      isStoryNode = true,
      key = "110200300003",
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
            startQuest = "110200310001",
            startPort = "QuestStart",
            endQuest = "110200310003",
            endPort = "In"
          },
          {
            startQuest = "110200310003",
            startPort = "Out",
            endQuest = "110200310004",
            endPort = "In"
          },
          {
            startQuest = "110200310001",
            startPort = "QuestStart",
            endQuest = "110200310005",
            endPort = "In"
          },
          {
            startQuest = "110200310005",
            startPort = "Out",
            endQuest = "110200310006",
            endPort = "In"
          },
          {
            startQuest = "110200310006",
            startPort = "Out",
            endQuest = "110200310007",
            endPort = "In"
          },
          {
            startQuest = "110200310007",
            startPort = "Out",
            endQuest = "1781531329388535",
            endPort = "In"
          },
          {
            startQuest = "1781531329388535",
            startPort = "Out",
            endQuest = "110200310008",
            endPort = "In"
          },
          {
            startQuest = "110200310008",
            startPort = "Out",
            endQuest = "110200310002",
            endPort = "Success"
          }
        },
        nodeData = {
          ["110200310001"] = {
            key = "110200310001",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 600, y = 500},
            propsData = {ModeType = 0}
          },
          ["110200310002"] = {
            key = "110200310002",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2400, y = 700},
            propsData = {ModeType = 0}
          },
          ["110200310003"] = {
            key = "110200310003",
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
          ["110200310004"] = {
            key = "110200310004",
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
          ["110200310005"] = {
            key = "110200310005",
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
          ["110200310006"] = {
            key = "110200310006",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1200, y = 650},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "tp_lxzx_rebirth01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["110200310007"] = {
            key = "110200310007",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1520, y = 650},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/mute",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {107201}
            }
          },
          ["1781531329388535"] = {
            key = "1781531329388535",
            type = "TalkNode",
            name = "【Ver0105_SC003】法露茜出现过场",
            pos = {x = 1840, y = 650},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0105/Ver0105_SC003/SQ_Ver0105_SC003",
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
          ["110200310008"] = {
            key = "110200310008",
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
