return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17811601321683580220",
      startPort = "Success",
      endStory = "17811601321683580219",
      endPort = "StoryEnd"
    },
    {
      startStory = "17811601321683580218",
      startPort = "StoryStart",
      endStory = "17811601321683580220",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17811601321683580218"] = {
      isStoryNode = true,
      key = "17811601321683580218",
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
    ["17811601321683580219"] = {
      isStoryNode = true,
      key = "17811601321683580219",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1604, y = 302},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17811601321683580220"] = {
      isStoryNode = true,
      key = "17811601321683580220",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1201.4782608695652, y = 292.69565217391306},
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
            startQuest = "17811601321683580224",
            startPort = "Out",
            endQuest = "17811601321683580225",
            endPort = "In"
          },
          {
            startQuest = "17811601321683580221",
            startPort = "QuestStart",
            endQuest = "17811601321683580224",
            endPort = "In"
          },
          {
            startQuest = "17811601321683580221",
            startPort = "QuestStart",
            endQuest = "17811601321683580226",
            endPort = "In"
          },
          {
            startQuest = "17811601321683580227",
            startPort = "Out",
            endQuest = "17811601321683580222",
            endPort = "Success"
          },
          {
            startQuest = "17811601321683580226",
            startPort = "Out",
            endQuest = "17811601321683580228",
            endPort = "In"
          },
          {
            startQuest = "17811601321683580228",
            startPort = "Out",
            endQuest = "17811601321683580229",
            endPort = "In"
          },
          {
            startQuest = "17811601321683580228",
            startPort = "Out",
            endQuest = "17811601321683580230",
            endPort = "In"
          },
          {
            startQuest = "17811601321683580229",
            startPort = "Out",
            endQuest = "17811601321683580227",
            endPort = "In"
          }
        },
        nodeData = {
          ["17811601321683580221"] = {
            key = "17811601321683580221",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17811601321683580222"] = {
            key = "17811601321683580222",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2245.7727272727275, y = 404.90909090909093},
            propsData = {ModeType = 0}
          },
          ["17811601321683580223"] = {
            key = "17811601321683580223",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17811601321683580224"] = {
            key = "17811601321683580224",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1121.4920748841803, y = 204.76753893481157},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17811601321683580225"] = {
            key = "17811601321683580225",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1400.0079251158197, y = 203.42311537591434},
            propsData = {
              ModeType = 1,
              Id = 104504,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17811601321683580226"] = {
            key = "17811601321683580226",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1118.9285714285713, y = 404.42857142857144},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104504,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17811601321683580227"] = {
            key = "17811601321683580227",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1960.4018915866745, y = 406.79853041695145},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17811601321683580228"] = {
            key = "17811601321683580228",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1397.4618890144814, y = 402.4437666610198},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "NewTargetPoint_1203070302",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17811601321683580229"] = {
            key = "17811601321683580229",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1682.7164865230034, y = 405.684422157776},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0103/Ver0103_SC002/Ver0103_SC002",
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
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["17811601321683580230"] = {
            key = "17811601321683580230",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1685.3107397818223, y = 569.8927663366776},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/1_3/0153_cs_juque_on_stage",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {104504}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
