return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "110201200001",
      startPort = "StoryStart",
      endStory = "110201200003",
      endPort = "In"
    },
    {
      startStory = "110201200003",
      startPort = "Success",
      endStory = "110201200002",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["110201200001"] = {
      isStoryNode = true,
      key = "110201200001",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 0}
    },
    ["110201200002"] = {
      isStoryNode = true,
      key = "110201200002",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1700, y = 300},
      propsData = {}
    },
    ["110201200003"] = {
      isStoryNode = true,
      key = "110201200003",
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
            startQuest = "110201210001",
            startPort = "QuestStart",
            endQuest = "110201210003",
            endPort = "In"
          },
          {
            startQuest = "110201210003",
            startPort = "Out",
            endQuest = "110201210004",
            endPort = "In"
          },
          {
            startQuest = "110201210001",
            startPort = "QuestStart",
            endQuest = "110201210005",
            endPort = "In"
          },
          {
            startQuest = "110201210005",
            startPort = "Out",
            endQuest = "110201210006",
            endPort = "In"
          },
          {
            startQuest = "110201210006",
            startPort = "Out",
            endQuest = "110201210007",
            endPort = "In"
          },
          {
            startQuest = "110201210007",
            startPort = "Out",
            endQuest = "17839441468603305856",
            endPort = "In"
          },
          {
            startQuest = "17839441468603305856",
            startPort = "Out",
            endQuest = "110201210008",
            endPort = "In"
          },
          {
            startQuest = "110201210008",
            startPort = "Out",
            endQuest = "110201210002",
            endPort = "Success"
          }
        },
        nodeData = {
          ["110201210001"] = {
            key = "110201210001",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 600, y = 500},
            propsData = {ModeType = 0}
          },
          ["110201210002"] = {
            key = "110201210002",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2400, y = 700},
            propsData = {ModeType = 0}
          },
          ["110201210003"] = {
            key = "110201210003",
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
          ["110201210004"] = {
            key = "110201210004",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1250, y = 320},
            propsData = {
              ModeType = 1,
              Id = 107601,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["110201210005"] = {
            key = "110201210005",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 900, y = 650},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 107601,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["110201210006"] = {
            key = "110201210006",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1200, y = 650},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "TeleportPoint_04",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["110201210007"] = {
            key = "110201210007",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1520, y = 650},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/1_6/0192_boss_aida_stage_2",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {107601}
            }
          },
          ["17839441468603305856"] = {
            key = "17839441468603305856",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1840, y = 650},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0105/Ver0105_SC012/SQ_Ver0105_SC012",
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
              bTravelFullLoadWorldComposition = true,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["110201210008"] = {
            key = "110201210008",
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
