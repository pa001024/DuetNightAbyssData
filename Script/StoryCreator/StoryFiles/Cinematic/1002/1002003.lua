return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178211071412119229074",
      startPort = "StoryStart",
      endStory = "178211071459419229100",
      endPort = "In"
    },
    {
      startStory = "178211071459419229100",
      startPort = "Success",
      endStory = "178211071412119229077",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178211071412119229074"] = {
      isStoryNode = true,
      key = "178211071412119229074",
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
    ["178211071412119229077"] = {
      isStoryNode = true,
      key = "178211071412119229077",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1794, y = 400},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178211071459419229100"] = {
      isStoryNode = true,
      key = "178211071459419229100",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1508, y = 436},
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
            startQuest = "178211071459419229108",
            startPort = "Out",
            endQuest = "178211071459419229110",
            endPort = "In"
          },
          {
            startQuest = "178211071459419229105",
            startPort = "QuestStart",
            endQuest = "178211071459419229108",
            endPort = "In"
          },
          {
            startQuest = "178211071459419229105",
            startPort = "QuestStart",
            endQuest = "178211071459419229109",
            endPort = "In"
          },
          {
            startQuest = "178211071459419229109",
            startPort = "Out",
            endQuest = "178211071459419229111",
            endPort = "In"
          },
          {
            startQuest = "178211071459419229111",
            startPort = "Out",
            endQuest = "178211071459419229112",
            endPort = "In"
          },
          {
            startQuest = "178211071459419229113",
            startPort = "Out",
            endQuest = "178211071459419229106",
            endPort = "Success"
          },
          {
            startQuest = "178211071459419229112",
            startPort = "Out",
            endQuest = "178211079232019229385",
            endPort = "In"
          },
          {
            startQuest = "178211079232019229385",
            startPort = "Out",
            endQuest = "178211071459419229113",
            endPort = "In"
          }
        },
        nodeData = {
          ["178211071459419229105"] = {
            key = "178211071459419229105",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178211071459419229106"] = {
            key = "178211071459419229106",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["178211071459419229107"] = {
            key = "178211071459419229107",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178211071459419229108"] = {
            key = "178211071459419229108",
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
          ["178211071459419229109"] = {
            key = "178211071459419229109",
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
          ["178211071459419229110"] = {
            key = "178211071459419229110",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1529.960562587241, y = 321.9877653748314},
            propsData = {
              ModeType = 1,
              Id = 101103,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178211071459419229111"] = {
            key = "178211071459419229111",
            type = "ChangeRoleNode",
            name = "切换角色-女主",
            pos = {x = 1087.8169354336808, y = 516.3778564057205},
            propsData = {QuestRoleId = 1010101, IsPlayFX = false}
          },
          ["178211071459419229112"] = {
            key = "178211071459419229112",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1497.4564977167786, y = 534.1728874616209},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint_SaiqiBossBattle",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178211071459419229113"] = {
            key = "178211071459419229113",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178211079232019229385"] = {
            key = "178211079232019229385",
            type = "TalkNode",
            name = "过场动画 赛琪变身",
            pos = {x = 1878.1557017543867, y = 539.4539473684209},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC003/SQ_OBT0101_SC003",
              BlendInTime = 0,
              InType = "FadeIn",
              OutType = "BlendOut",
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
              EndNewTargetPointName = "QuestPoint_SaiqiBossBattle",
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
