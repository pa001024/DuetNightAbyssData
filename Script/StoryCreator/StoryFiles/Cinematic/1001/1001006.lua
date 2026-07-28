return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1780566927196523135",
      startPort = "StoryStart",
      endStory = "1780566927197523137",
      endPort = "In"
    },
    {
      startStory = "1780566927197523137",
      startPort = "Success",
      endStory = "1780566927197523136",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1780566927196523135"] = {
      isStoryNode = true,
      key = "1780566927196523135",
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
    ["1780566927197523136"] = {
      isStoryNode = true,
      key = "1780566927197523136",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1976, y = 342},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1780566927197523137"] = {
      isStoryNode = true,
      key = "1780566927197523137",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1268, y = 272},
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
            startQuest = "1780566927197523141",
            startPort = "Out",
            endQuest = "1780566927197523143",
            endPort = "In"
          },
          {
            startQuest = "1780566927197523138",
            startPort = "QuestStart",
            endQuest = "1780566927197523141",
            endPort = "In"
          },
          {
            startQuest = "1780566927197523138",
            startPort = "QuestStart",
            endQuest = "1780566927197523142",
            endPort = "In"
          },
          {
            startQuest = "1780566927197523142",
            startPort = "Out",
            endQuest = "1780566927197523144",
            endPort = "In"
          },
          {
            startQuest = "1780566927197523144",
            startPort = "Out",
            endQuest = "1780566886394864",
            endPort = "In"
          },
          {
            startQuest = "1780566886394864",
            startPort = "Out",
            endQuest = "1780566927197523139",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1780566886394864"] = {
            key = "1780566886394864",
            type = "TalkNode",
            name = "过场-100179-老头环-SC06",
            pos = {x = 1686.8283817434267, y = 564},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC006/SQ_OBT0100_SC006",
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
              EndNewTargetPointName = "QuestPoint_Balcony2",
              CameraLookAtTartgetPoint = "QuestPoint_Balcony1",
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
          ["1780566927197523138"] = {
            key = "1780566927197523138",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1780566927197523139"] = {
            key = "1780566927197523139",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2241.4285714285706, y = 584.2857142857143},
            propsData = {ModeType = 0}
          },
          ["1780566927197523140"] = {
            key = "1780566927197523140",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1780566927197523141"] = {
            key = "1780566927197523141",
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
          ["1780566927197523142"] = {
            key = "1780566927197523142",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 912.0145196141955, y = 542.6907120531213},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 100102,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1780566927197523143"] = {
            key = "1780566927197523143",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 100102,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1780566927197523144"] = {
            key = "1780566927197523144",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1262.2701623130522, y = 549.7318936728011},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint_Balcony1",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
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
