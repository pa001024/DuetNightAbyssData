return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178211005664113884501",
      startPort = "StoryStart",
      endStory = "178211005741613884525",
      endPort = "In"
    },
    {
      startStory = "178211005741613884525",
      startPort = "Success",
      endStory = "178211005664113884504",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178211005664113884501"] = {
      isStoryNode = true,
      key = "178211005664113884501",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 980, y = 280},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178211005664113884504"] = {
      isStoryNode = true,
      key = "178211005664113884504",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1916, y = 320},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178211005741613884525"] = {
      isStoryNode = true,
      key = "178211005741613884525",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1416, y = 276},
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
            startQuest = "178211005741613884533",
            startPort = "Out",
            endQuest = "178211005741613884535",
            endPort = "In"
          },
          {
            startQuest = "178211005741613884530",
            startPort = "QuestStart",
            endQuest = "178211005741613884533",
            endPort = "In"
          },
          {
            startQuest = "178211005741613884530",
            startPort = "QuestStart",
            endQuest = "178211005741613884534",
            endPort = "In"
          },
          {
            startQuest = "178211005741613884538",
            startPort = "Out",
            endQuest = "178211005741613884531",
            endPort = "Success"
          },
          {
            startQuest = "178211005741613884537",
            startPort = "Out",
            endQuest = "178211006345213884780",
            endPort = "In"
          },
          {
            startQuest = "178211006345213884780",
            startPort = "Out",
            endQuest = "178211005741613884538",
            endPort = "In"
          },
          {
            startQuest = "178211005741613884534",
            startPort = "Out",
            endQuest = "178211005741613884537",
            endPort = "In"
          }
        },
        nodeData = {
          ["178211005741613884530"] = {
            key = "178211005741613884530",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178211005741613884531"] = {
            key = "178211005741613884531",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["178211005741613884532"] = {
            key = "178211005741613884532",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178211005741613884533"] = {
            key = "178211005741613884533",
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
          ["178211005741613884534"] = {
            key = "178211005741613884534",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 815.2236293450444, y = 549.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101103,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178211005741613884535"] = {
            key = "178211005741613884535",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1528.38161521882, y = 321.9877653748314},
            propsData = {
              ModeType = 1,
              Id = 101103,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178211005741613884537"] = {
            key = "178211005741613884537",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1497.4564977167786, y = 534.1728874616209},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "P1240672",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178211005741613884538"] = {
            key = "178211005741613884538",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178211006345213884780"] = {
            key = "178211006345213884780",
            type = "TalkNode",
            name = "谁在那里！",
            pos = {x = 1760.5214532454256, y = 583.0532482648587},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC018/SQ_OBT0101_SC018",
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = true,
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
