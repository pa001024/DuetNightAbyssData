return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17697590104521328793",
      startPort = "StoryStart",
      endStory = "17697590104521328795",
      endPort = "In"
    },
    {
      startStory = "17697590104521328795",
      startPort = "Success",
      endStory = "178099699630122373085",
      endPort = "In"
    },
    {
      startStory = "178099699630122373085",
      startPort = "Success",
      endStory = "17697590104521328794",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17697590104521328793"] = {
      isStoryNode = true,
      key = "17697590104521328793",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 814, y = 322},
      propsData = {QuestChainId = 110213},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17697590104521328794"] = {
      isStoryNode = true,
      key = "17697590104521328794",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1837.3333273910491, y = 395.64705663092184},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17697590104521328795"] = {
      isStoryNode = true,
      key = "17697590104521328795",
      type = "StoryNode",
      name = "在商业街遇见小孩子",
      pos = {x = 1144.152825926805, y = 325.9963518752804},
      propsData = {
        QuestId = 11021301,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110213_1",
        QuestDeatil = "Content_110213_1",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = true,
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
        SubRegionId = 107001,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "QuestSign11021301",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17697590104521328796",
            startPort = "QuestStart",
            endQuest = "178099110183520845479",
            endPort = "In"
          },
          {
            startQuest = "178099486492322371690",
            startPort = "Out",
            endQuest = "178099510542222372148",
            endPort = "In"
          },
          {
            startQuest = "178099706273222373806",
            startPort = "Out",
            endQuest = "17697590104521328797",
            endPort = "Success"
          },
          {
            startQuest = "178099510542222372148",
            startPort = "Out",
            endQuest = "178099706273222373806",
            endPort = "In"
          },
          {
            startQuest = "178099110183520845479",
            startPort = "Out",
            endQuest = "178099486492322371690",
            endPort = "In"
          },
          {
            startQuest = "178099510542222372148",
            startPort = "Out",
            endQuest = "17833446070941632775",
            endPort = "In"
          }
        },
        nodeData = {
          ["17697590104521328796"] = {
            key = "17697590104521328796",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 583.7209359886452, y = 174.41860799340694},
            propsData = {ModeType = 0}
          },
          ["17697590104521328797"] = {
            key = "17697590104521328797",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2249.8181790158333, y = 298.0606059671944},
            propsData = {ModeType = 0}
          },
          ["17697590104521328798"] = {
            key = "17697590104521328798",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["178099110183520845479"] = {
            key = "178099110183520845479",
            type = "ChangeStaticCreatorNode",
            name = "生成小孩子",
            pos = {x = 773.9883108907624, y = -5.8900980239770035},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780027}
            }
          },
          ["178099486492322371690"] = {
            key = "178099486492322371690",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1004.8175541762948, y = 354.3578044998599},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312780030,
              GuideType = "P",
              GuidePointName = "QuestSign11021301"
            }
          },
          ["178099510542222372148"] = {
            key = "178099510542222372148",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1161.1298408662378, y = 495.7793262054101},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110213/11021301.11021301'",
              TalkType = "FixSimple",
              TalkStageName = "",
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
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = false,
              ShowSkipButton = true,
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
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["178099706273222373806"] = {
            key = "178099706273222373806",
            type = "ChangeStaticCreatorNode",
            name = "销毁小孩子",
            pos = {x = 1603.7876368528962, y = 278.3777394250477},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                312780027,
                312780028,
                312780029
              }
            }
          },
          ["17833446070941632775"] = {
            key = "17833446070941632775",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1412.7878783441736, y = 37.93939865668105},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11108501,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          }
        },
        commentData = {}
      }
    },
    ["178099699630122373085"] = {
      isStoryNode = true,
      key = "178099699630122373085",
      type = "StoryNode",
      name = "去仓库",
      pos = {x = 1432.1862044315947, y = 339.69289378655617},
      propsData = {
        QuestId = 11021302,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110213_2",
        QuestDeatil = "Content_110213_2",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = true,
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
        SubRegionId = 107001,
        SubRegionIdList = {107801},
        StoryGuideType = "Point",
        StoryGuidePointName = "QuestSign11021302",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "178099699630122373090",
            startPort = "QuestStart",
            endQuest = "178100276001622376284",
            endPort = "In"
          },
          {
            startQuest = "178099699630122373090",
            startPort = "QuestStart",
            endQuest = "178100550116722378574",
            endPort = "In"
          },
          {
            startQuest = "178100550116722378574",
            startPort = "Region_1",
            endQuest = "178100552955922379170",
            endPort = "In"
          },
          {
            startQuest = "178100552955922379170",
            startPort = "Fail",
            endQuest = "178100555334222379943",
            endPort = "In"
          },
          {
            startQuest = "178100552955922379170",
            startPort = "PassiveFail",
            endQuest = "178100555334222379943",
            endPort = "In"
          },
          {
            startQuest = "178100555334222379943",
            startPort = "Out",
            endQuest = "178099699630122373092",
            endPort = "Fail"
          },
          {
            startQuest = "178106234987831535209",
            startPort = "Out",
            endQuest = "178099699630122373091",
            endPort = "Success"
          },
          {
            startQuest = "178333132533833675743",
            startPort = "Out",
            endQuest = "178333136993933676361",
            endPort = "In"
          },
          {
            startQuest = "178100276001622376284",
            startPort = "Region_1",
            endQuest = "17833372568691029",
            endPort = "In"
          },
          {
            startQuest = "17833372568691029",
            startPort = "Out",
            endQuest = "178333132533833675743",
            endPort = "In"
          },
          {
            startQuest = "178100552955922379170",
            startPort = "Success",
            endQuest = "17877246554745069944",
            endPort = "Input"
          },
          {
            startQuest = "17877246554745069944",
            startPort = "Out",
            endQuest = "178106234987831535209",
            endPort = "In"
          }
        },
        nodeData = {
          ["178099699630122373090"] = {
            key = "178099699630122373090",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 583.7209359886452, y = 174.41860799340694},
            propsData = {ModeType = 0}
          },
          ["178099699630122373091"] = {
            key = "178099699630122373091",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2314.1760859994247, y = 321.9990073405236},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 3,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["178099699630122373092"] = {
            key = "178099699630122373092",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2017.5102809990394, y = 577.9525794115644},
            propsData = {}
          },
          ["178100276001622376284"] = {
            key = "178100276001622376284",
            type = "JudgeRegionNode",
            name = "判断位于区域",
            pos = {x = 895.7950545620455, y = 17.126485554692707},
            propsData = {
              IsWaitingEnterRegion = true,
              RegionIds = {107001}
            }
          },
          ["178100550116722378574"] = {
            key = "178100550116722378574",
            type = "JudgeRegionNode",
            name = "判断位于区域",
            pos = {x = 857.1111063350766, y = 373.7731943202376},
            propsData = {
              IsWaitingEnterRegion = true,
              RegionIds = {107801}
            }
          },
          ["178100552955922379170"] = {
            key = "178100552955922379170",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1179.9924541012786, y = 422.9257403880019},
            propsData = {SpecialConfigId = 11021302, BlackScreenImmediately = false}
          },
          ["178100555334222379943"] = {
            key = "178100555334222379943",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1555.2618311204117, y = 577.057965269544},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 3,
              IsWhite = false
            }
          },
          ["178106234987831535209"] = {
            key = "178106234987831535209",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1934.3264889685959, y = 257.4193569623965},
            propsData = {
              VarName = "ex02_110213",
              VarValue = 1
            }
          },
          ["178333132533833675743"] = {
            key = "178333132533833675743",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1567.7076774652573, y = 38.107285131753315},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {312780398},
              QuestPickupId = -1,
              UnitId = 11021301,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "QuestSign11021302",
              IsUseCount = false
            }
          },
          ["178333136993933676361"] = {
            key = "178333136993933676361",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1880.9729738325043, y = 15.658306238986516},
            propsData = {
              ModeType = 1,
              Id = 107801,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17833372568691029"] = {
            key = "17833372568691029",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1270, y = -126},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780398}
            }
          },
          ["17877246554745069944"] = {
            key = "17877246554745069944",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 1533.3333366727989, y = 305.15151568863206},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 0.5,
              IsStandAlone = true
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
