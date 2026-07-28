return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17821168491485908175",
      startPort = "StoryStart",
      endStory = "17821168491485908177",
      endPort = "In"
    },
    {
      startStory = "17821168491485908177",
      startPort = "Success",
      endStory = "17821168491485908176",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17821168491485908175"] = {
      isStoryNode = true,
      key = "17821168491485908175",
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
    ["17821168491485908176"] = {
      isStoryNode = true,
      key = "17821168491485908176",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2354, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17821168491485908177"] = {
      isStoryNode = true,
      key = "17821168491485908177",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1596, y = 298},
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
            startQuest = "17821168491485908181",
            startPort = "Out",
            endQuest = "17821168491485908183",
            endPort = "In"
          },
          {
            startQuest = "17821168491485908178",
            startPort = "QuestStart",
            endQuest = "17821168491485908181",
            endPort = "In"
          },
          {
            startQuest = "17821168491485908178",
            startPort = "QuestStart",
            endQuest = "17821168491485908182",
            endPort = "In"
          },
          {
            startQuest = "17821168491485908182",
            startPort = "Out",
            endQuest = "17821161044314275292",
            endPort = "In"
          },
          {
            startQuest = "17821161044314275292",
            startPort = "Out",
            endQuest = "17821160860454274990",
            endPort = "In"
          },
          {
            startQuest = "17821160860454274990",
            startPort = "Out",
            endQuest = "17821161112784275464",
            endPort = "In"
          },
          {
            startQuest = "17821161112784275464",
            startPort = "Out",
            endQuest = "17821168491485908179",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17821160860454274990"] = {
            key = "17821160860454274990",
            type = "TalkNode",
            name = "SC02【过场】大合照",
            pos = {x = 1813.5, y = 548},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Activity/Activity_Feina/Activity_Feina_SC002/SQ_Activity_Feina_SC002",
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
          },
          ["17821161044314275292"] = {
            key = "17821161044314275292",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1477.5, y = 558.5},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/1_0/0091_feina_activity_cs_01",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["17821161112784275464"] = {
            key = "17821161112784275464",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2127, y = 569},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17821168491485908178"] = {
            key = "17821168491485908178",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17821168491485908179"] = {
            key = "17821168491485908179",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2515.394736842105, y = 561.1578947368422},
            propsData = {ModeType = 0}
          },
          ["17821168491485908180"] = {
            key = "17821168491485908180",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2752.6315789473683, y = 816.8421052631579},
            propsData = {}
          },
          ["17821168491485908181"] = {
            key = "17821168491485908181",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1102.7046601440443, y = 310.83896750624024},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17821168491485908182"] = {
            key = "17821168491485908182",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1162.8984780220724, y = 533.7144896449201},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101105,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17821168491485908183"] = {
            key = "17821168491485908183",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1678.7205103756837, y = 315.994543947343},
            propsData = {
              ModeType = 1,
              Id = 101105,
              StartIndex = 1,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
