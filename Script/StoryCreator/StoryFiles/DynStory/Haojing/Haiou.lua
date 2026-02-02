return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17580907223351",
      startPort = "StoryStart",
      endStory = "1758090768225240",
      endPort = "In"
    },
    {
      startStory = "1758090768225240",
      startPort = "Success",
      endStory = "17580907223365",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17580907223351"] = {
      isStoryNode = true,
      key = "17580907223351",
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
    ["17580907223365"] = {
      isStoryNode = true,
      key = "17580907223365",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1524, y = 292},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1758090768225240"] = {
      isStoryNode = true,
      key = "1758090768225240",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1148.4444444444443, y = 294.44444444444446},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "DynQuest_Haiou_Des",
        QuestDeatil = "",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = false,
        bIsNotifyGameMode = true,
        bIsStartChapter = false,
        bIsEndChapter = false,
        bIsShowOnComplete = true,
        bIsPlayBlackScreenOnComplete = false,
        bIsPlayBlackScreenOnFail = false,
        bIsDynamicEvent = true,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1758090768225241",
            startPort = "QuestStart",
            endQuest = "1758090788989971",
            endPort = "In"
          },
          {
            startQuest = "1758090788989971",
            startPort = "Out",
            endQuest = "1758090939097444",
            endPort = "In"
          },
          {
            startQuest = "1758090788989971",
            startPort = "Out",
            endQuest = "17580909738381018",
            endPort = "In"
          },
          {
            startQuest = "1758090939097444",
            startPort = "Option_2",
            endQuest = "17580910177041487",
            endPort = "In"
          },
          {
            startQuest = "1758090939097444",
            startPort = "Option_1",
            endQuest = "17580910539591665",
            endPort = "In"
          },
          {
            startQuest = "17580910539591665",
            startPort = "Out",
            endQuest = "17580910816542092",
            endPort = "In"
          },
          {
            startQuest = "17580911116652528",
            startPort = "Out",
            endQuest = "17580911281993066",
            endPort = "In"
          },
          {
            startQuest = "17580911281993066",
            startPort = "Out",
            endQuest = "1758090768225248",
            endPort = "Success"
          },
          {
            startQuest = "17580910177041487",
            startPort = "Out",
            endQuest = "1758090768225248",
            endPort = "Success"
          },
          {
            startQuest = "17649159617831278",
            startPort = "Out",
            endQuest = "17649159973412218",
            endPort = "Input_2"
          },
          {
            startQuest = "17649159630301325",
            startPort = "Out",
            endQuest = "17649159973412218",
            endPort = "Input_3"
          },
          {
            startQuest = "17649159661891455",
            startPort = "Out",
            endQuest = "17649159973412218",
            endPort = "Input_5"
          },
          {
            startQuest = "17649159651641420",
            startPort = "Out",
            endQuest = "17649159973412218",
            endPort = "Input_4"
          },
          {
            startQuest = "17649159973412218",
            startPort = "Out",
            endQuest = "17580911116652528",
            endPort = "In"
          },
          {
            startQuest = "17649159973412218",
            startPort = "Out",
            endQuest = "17649172430581397795",
            endPort = "In"
          },
          {
            startQuest = "17580910539591665",
            startPort = "Out",
            endQuest = "17675934732572100",
            endPort = "In"
          },
          {
            startQuest = "17675934732572100",
            startPort = "Out",
            endQuest = "1764915948580828",
            endPort = "In"
          },
          {
            startQuest = "1764915948580828",
            startPort = "Out",
            endQuest = "17649159973412218",
            endPort = "Input_1"
          },
          {
            startQuest = "17580910539591665",
            startPort = "Out",
            endQuest = "17675935348023267",
            endPort = "In"
          },
          {
            startQuest = "17675935348023267",
            startPort = "Out",
            endQuest = "17649159617831278",
            endPort = "In"
          },
          {
            startQuest = "17580910539591665",
            startPort = "Out",
            endQuest = "17675935357663306",
            endPort = "In"
          },
          {
            startQuest = "17675935357663306",
            startPort = "Out",
            endQuest = "17649159630301325",
            endPort = "In"
          },
          {
            startQuest = "17580910539591665",
            startPort = "Out",
            endQuest = "17675935363413337",
            endPort = "In"
          },
          {
            startQuest = "17675935363413337",
            startPort = "Out",
            endQuest = "17649159651641420",
            endPort = "In"
          },
          {
            startQuest = "17580910539591665",
            startPort = "Out",
            endQuest = "17675935368493358",
            endPort = "In"
          },
          {
            startQuest = "17675935368493358",
            startPort = "Out",
            endQuest = "17649159661891455",
            endPort = "In"
          },
          {
            startQuest = "17580910539591665",
            startPort = "Out",
            endQuest = "17649172304811397440",
            endPort = "In"
          }
        },
        nodeData = {
          ["1758090768225241"] = {
            key = "1758090768225241",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1758090768225248"] = {
            key = "1758090768225248",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 4137.929388689114, y = 320.2100359594639},
            propsData = {ModeType = 0}
          },
          ["1758090768225255"] = {
            key = "1758090768225255",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3779.714285714286, y = 706.4285714285714},
            propsData = {}
          },
          ["1758090788989971"] = {
            key = "1758090788989971",
            type = "ChangeStaticCreatorNode",
            name = "生成小贩NPC",
            pos = {x = 1210.5263157894738, y = 306.42105263157896},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2400007}
            }
          },
          ["1758090939097444"] = {
            key = "1758090939097444",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1651.548485839104, y = 294.6054109252051},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 818078,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Dyn_2400007",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              FirstDialogueId = 71007502,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              TalkActors = {},
              OptionType = "branch",
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              BranchOptions = {"", ""},
              OverrideFailBlend = false
            }
          },
          ["17580909738381018"] = {
            key = "17580909738381018",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1649.4056286962466, y = 66.39112521091934},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71007501,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17580910177041487"] = {
            key = "17580910177041487",
            type = "DynamicQuestFailNode",
            name = "动态任务主动失败",
            pos = {x = 2086.205628696247, y = 886.4196966394909},
            propsData = {UseTalkFadeOut = false, TalkFadeOutTime = 0}
          },
          ["17580910539591665"] = {
            key = "17580910539591665",
            type = "ChangeStaticCreatorNode",
            name = "生成海鸥",
            pos = {x = 2005.1199144105328, y = 301.0339823537765},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                2400008,
                2400009,
                2400010,
                2400011,
                2400012
              }
            }
          },
          ["17580910816542092"] = {
            key = "17580910816542092",
            type = "TalkNode",
            name = "海鸥来袭开车",
            pos = {x = 2341.8913429819613, y = -419.5660176462236},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71007506,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17580911116652528"] = {
            key = "17580911116652528",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 3517.507492050285, y = 310.0600693102982},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 818078,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Dyn_2400007",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              FirstDialogueId = 71007508,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 2,
              InType = "BlendIn",
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
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              TalkActors = {},
              OptionType = "normal",
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17580911281993066"] = {
            key = "17580911281993066",
            type = "DynamicQuestSuccessNode",
            name = "动态任务主动成功",
            pos = {x = 3796.4646349074283, y = 327.07435502458395},
            propsData = {
              DialogueId = 0,
              UseTalkFadeOut = false,
              TalkFadeOutTime = 0
            }
          },
          ["1764915948580828"] = {
            key = "1764915948580828",
            type = "ListenActorDestroyNode",
            name = "监听Actor销毁节点",
            pos = {x = 2643.8769057029926, y = -77.34873894221712},
            propsData = {StaticCreatorId = 2400008, DestroyReason = "Default"}
          },
          ["17649159617831278"] = {
            key = "17649159617831278",
            type = "ListenActorDestroyNode",
            name = "监听Actor销毁节点",
            pos = {x = 2641.7769057029927, y = 95.7512610577829},
            propsData = {StaticCreatorId = 2400009, DestroyReason = "Default"}
          },
          ["17649159630301325"] = {
            key = "17649159630301325",
            type = "ListenActorDestroyNode",
            name = "监听Actor销毁节点",
            pos = {x = 2650.526905702993, y = 296.3512610577829},
            propsData = {StaticCreatorId = 2400010, DestroyReason = "Default"}
          },
          ["17649159651641420"] = {
            key = "17649159651641420",
            type = "ListenActorDestroyNode",
            name = "监听Actor销毁节点",
            pos = {x = 2647.876905702993, y = 467.10560888386993},
            propsData = {StaticCreatorId = 2400011, DestroyReason = "Default"}
          },
          ["17649159661891455"] = {
            key = "17649159661891455",
            type = "ListenActorDestroyNode",
            name = "监听Actor销毁节点",
            pos = {x = 2663.576905702993, y = 665.201261057783},
            propsData = {StaticCreatorId = 2400012, DestroyReason = "Default"}
          },
          ["17649159973412218"] = {
            key = "17649159973412218",
            type = "WaitQuestFinishedNode",
            name = "等待任务完成",
            pos = {x = 3168.461067193676, y = 269.71275174101265},
            propsData = {ListenCount = 5, NeedFinishCount = 5}
          },
          ["17649172304811397440"] = {
            key = "17649172304811397440",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2627.1675394018644, y = -327.39782113386235},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = true,
              GuideType = "P",
              GuideName = "TargetRange_Dyn_Haiou_1"
            }
          },
          ["17649172430581397795"] = {
            key = "17649172430581397795",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 3518.596110830436, y = 14.566464580423379},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "TargetRange_Dyn_Haiou_1"
            }
          },
          ["17675934732572100"] = {
            key = "17675934732572100",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2383.06512605042, y = -93.10962485264547},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "Monster_Dyn_2400008"
            }
          },
          ["17675935348023267"] = {
            key = "17675935348023267",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2373.06512605042, y = 83.98214285714279},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "Monster_Dyn_2400009"
            }
          },
          ["17675935357663306"] = {
            key = "17675935357663306",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2366.81512605042, y = 286.4821428571429},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "Monster_Dyn_2400010"
            }
          },
          ["17675935363413337"] = {
            key = "17675935363413337",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2369.31512605042, y = 457.7321428571429},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "Monster_Dyn_2400011"
            }
          },
          ["17675935368493358"] = {
            key = "17675935368493358",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2374.31512605042, y = 666.482142857143},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "Monster_Dyn_2400012"
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
