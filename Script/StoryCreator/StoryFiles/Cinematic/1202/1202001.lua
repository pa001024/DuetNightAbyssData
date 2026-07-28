return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17811454314231563984",
      startPort = "StoryStart",
      endStory = "17811454314231563986",
      endPort = "In"
    },
    {
      startStory = "17811454314231563986",
      startPort = "Success",
      endStory = "17811454314231563985",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17811454314231563984"] = {
      isStoryNode = true,
      key = "17811454314231563984",
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
    ["17811454314231563985"] = {
      isStoryNode = true,
      key = "17811454314231563985",
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
    ["17811454314231563986"] = {
      isStoryNode = true,
      key = "17811454314231563986",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1266, y = 272},
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
            startQuest = "17811454314231563988",
            startPort = "QuestStart",
            endQuest = "17811454314231563991",
            endPort = "In"
          },
          {
            startQuest = "17811454314231563992",
            startPort = "Out",
            endQuest = "17811454314231563994",
            endPort = "In"
          },
          {
            startQuest = "17811454314231563987",
            startPort = "Out",
            endQuest = "17811454314231563989",
            endPort = "Success"
          },
          {
            startQuest = "17811454314231563988",
            startPort = "QuestStart",
            endQuest = "17811454314231563992",
            endPort = "In"
          },
          {
            startQuest = "17811454160081029323",
            startPort = "Out",
            endQuest = "17811454160081029324",
            endPort = "In"
          },
          {
            startQuest = "17811454314231563994",
            startPort = "Out",
            endQuest = "17811454160081029323",
            endPort = "In"
          },
          {
            startQuest = "17811454160081029324",
            startPort = "Out",
            endQuest = "17811454314231563989",
            endPort = "Success"
          },
          {
            startQuest = "17811454314231563991",
            startPort = "Out",
            endQuest = "17811454314231563993",
            endPort = "In"
          }
        },
        nodeData = {
          ["17811454160081029323"] = {
            key = "17811454160081029323",
            type = "TalkNode",
            name = "过场 - 小黑屋",
            pos = {x = 1432.829315358573, y = 708.1076342961637},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC001/SQ_Ver0102_SC001",
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
          },
          ["17811454160081029324"] = {
            key = "17811454160081029324",
            type = "TalkNode",
            name = "【East02_FixSimple_01】主角与止流在止流幻境争执",
            pos = {x = 1696.8440535841453, y = 711.4181116297364},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1202/12040101.12040101'",
              TalkType = "FixSimple",
              TalkStageName = "East02_12020101",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17811454314231563987"] = {
            key = "17811454314231563987",
            type = "TalkNode",
            name = "闪回(mp4)",
            pos = {x = 1585.023785425101, y = 523.796052631579},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC001/SQ_Ver0102_SC001",
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
          },
          ["17811454314231563988"] = {
            key = "17811454314231563988",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17811454314231563989"] = {
            key = "17811454314231563989",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2159.505494505494, y = 549.835164835165},
            propsData = {ModeType = 0}
          },
          ["17811454314231563990"] = {
            key = "17811454314231563990",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17811454314231563991"] = {
            key = "17811454314231563991",
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
          ["17811454314231563992"] = {
            key = "17811454314231563992",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 105602,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17811454314231563993"] = {
            key = "17811454314231563993",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 105602,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17811454314231563994"] = {
            key = "17811454314231563994",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1113.4729812332623, y = 566.9932410211048},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Quest_TargetPoint_BOSS",
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
