return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17817688441285337868",
      startPort = "StoryStart",
      endStory = "17817688447085337892",
      endPort = "In"
    },
    {
      startStory = "17817688447085337892",
      startPort = "Success",
      endStory = "17817688441285337871",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17817688441285337868"] = {
      isStoryNode = true,
      key = "17817688441285337868",
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
    ["17817688441285337871"] = {
      isStoryNode = true,
      key = "17817688441285337871",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1950, y = 398},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17817688447085337892"] = {
      isStoryNode = true,
      key = "17817688447085337892",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1534, y = 426},
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
            startQuest = "17817688447085337900",
            startPort = "Out",
            endQuest = "17817688447085337902",
            endPort = "In"
          },
          {
            startQuest = "17817688447085337897",
            startPort = "QuestStart",
            endQuest = "17817688447085337900",
            endPort = "In"
          },
          {
            startQuest = "17817688447085337897",
            startPort = "QuestStart",
            endQuest = "17817688447085337901",
            endPort = "In"
          },
          {
            startQuest = "17817688447085337905",
            startPort = "Out",
            endQuest = "17817688447085337898",
            endPort = "Success"
          },
          {
            startQuest = "17817688447085337904",
            startPort = "Out",
            endQuest = "17817689299005338243",
            endPort = "In"
          },
          {
            startQuest = "17817689299005338243",
            startPort = "Out",
            endQuest = "17817688447085337905",
            endPort = "In"
          },
          {
            startQuest = "17817688447085337901",
            startPort = "Out",
            endQuest = "17817688447085337904",
            endPort = "In"
          }
        },
        nodeData = {
          ["17817688447085337897"] = {
            key = "17817688447085337897",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17817688447085337898"] = {
            key = "17817688447085337898",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["17817688447085337899"] = {
            key = "17817688447085337899",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17817688447085337900"] = {
            key = "17817688447085337900",
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
          ["17817688447085337901"] = {
            key = "17817688447085337901",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 815.2236293450444, y = 549.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101304,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17817688447085337902"] = {
            key = "17817688447085337902",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 321.9877653748314},
            propsData = {
              ModeType = 1,
              Id = 101304,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17817688447085337904"] = {
            key = "17817688447085337904",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1497.4564977167786, y = 534.1728874616209},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint_SJZBossWake",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17817688447085337905"] = {
            key = "17817688447085337905",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17817689299005338243"] = {
            key = "17817689299005338243",
            type = "TalkNode",
            name = "过场动画 SJZ出场",
            pos = {x = 1797.0039481830004, y = 543.3015448957639},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC004/SQ_OBT0101_SC004",
              InType = "BlendIn",
              OutType = "BlendOut",
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
