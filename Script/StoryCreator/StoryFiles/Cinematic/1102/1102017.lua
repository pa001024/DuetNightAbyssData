return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "110201700001",
      startPort = "StoryStart",
      endStory = "110201700003",
      endPort = "In"
    },
    {
      startStory = "110201700003",
      startPort = "Success",
      endStory = "110201700002",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["110201700001"] = {
      isStoryNode = true,
      key = "110201700001",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 0}
    },
    ["110201700002"] = {
      isStoryNode = true,
      key = "110201700002",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1700, y = 300},
      propsData = {}
    },
    ["110201700003"] = {
      isStoryNode = true,
      key = "110201700003",
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
            startQuest = "110201710001",
            startPort = "QuestStart",
            endQuest = "110201710003",
            endPort = "In"
          },
          {
            startQuest = "110201710003",
            startPort = "Out",
            endQuest = "110201710004",
            endPort = "In"
          },
          {
            startQuest = "110201710001",
            startPort = "QuestStart",
            endQuest = "110201710005",
            endPort = "In"
          },
          {
            startQuest = "110201710005",
            startPort = "Out",
            endQuest = "110201710006",
            endPort = "In"
          },
          {
            startQuest = "110201710006",
            startPort = "Out",
            endQuest = "110201710007",
            endPort = "In"
          },
          {
            startQuest = "110201710007",
            startPort = "Out",
            endQuest = "1783516069623819",
            endPort = "In"
          },
          {
            startQuest = "1783516069623819",
            startPort = "Out",
            endQuest = "110201710008",
            endPort = "In"
          },
          {
            startQuest = "110201710008",
            startPort = "Out",
            endQuest = "110201710002",
            endPort = "Success"
          }
        },
        nodeData = {
          ["110201710001"] = {
            key = "110201710001",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 600, y = 500},
            propsData = {ModeType = 0}
          },
          ["110201710002"] = {
            key = "110201710002",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2400, y = 700},
            propsData = {ModeType = 0}
          },
          ["110201710003"] = {
            key = "110201710003",
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
          ["110201710004"] = {
            key = "110201710004",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1250, y = 320},
            propsData = {
              ModeType = 1,
              Id = 107101,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["110201710005"] = {
            key = "110201710005",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 900, y = 650},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 107101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["110201710006"] = {
            key = "110201710006",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1200, y = 650},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "TeleportPoint11023203",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["110201710007"] = {
            key = "110201710007",
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
              RelatedRegionId = {107101}
            }
          },
          ["1783516069623819"] = {
            key = "1783516069623819",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1840, y = 650},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0105/Ver0105_SC017/SQ_Ver0105_SC017",
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
          ["110201710008"] = {
            key = "110201710008",
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
