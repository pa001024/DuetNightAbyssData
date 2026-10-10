return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17828032320231",
      startPort = "StoryStart",
      endStory = "1782803638597249",
      endPort = "In"
    },
    {
      startStory = "1782803638597249",
      startPort = "Success",
      endStory = "17828040018701077881",
      endPort = "In"
    },
    {
      startStory = "17828040018701077881",
      startPort = "Success",
      endStory = "17901697474181796",
      endPort = "In"
    },
    {
      startStory = "17901697474181796",
      startPort = "Success",
      endStory = "17828032320245",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17828032320231"] = {
      isStoryNode = true,
      key = "17828032320231",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 795.5494505494506, y = 288.3791208791209},
      propsData = {QuestChainId = 120701},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17828032320245"] = {
      isStoryNode = true,
      key = "17828032320245",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1977.9623481781375, y = 295.8719280719281},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1782803638597249"] = {
      isStoryNode = true,
      key = "1782803638597249",
      type = "StoryNode",
      name = "接任务交互",
      pos = {x = 1078.5994347046976, y = 277.9346769873087},
      propsData = {
        QuestId = 12070101,
        QuestDescriptionComment = "酒馆进任务",
        QuestDescription = "Description_120701_1",
        QuestDeatil = "Content_120701_1",
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
        SubRegionId = 101107,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "Target_Start_120713",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1782803638597250",
            startPort = "QuestStart",
            endQuest = "17872124100132951",
            endPort = "In"
          },
          {
            startQuest = "17872124100132951",
            startPort = "Out",
            endQuest = "1782803638597258",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1782803638597250"] = {
            key = "1782803638597250",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1293.051948051948, y = 297.3376623376624},
            propsData = {ModeType = 0}
          },
          ["1782803638597258"] = {
            key = "1782803638597258",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1905.0909090909095, y = 292.773069036227},
            propsData = {ModeType = 0}
          },
          ["1782803638598266"] = {
            key = "1782803638598266",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1905.412337662338, y = 424.38021189336985},
            propsData = {}
          },
          ["17872124100132951"] = {
            key = "17872124100132951",
            type = "GoToRegionNode",
            name = "判定进入水仙平原",
            pos = {x = 1577.5194805194803, y = 289.44155844155847},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101107,
              bGuideUIEnable = true,
              GuideType = "P",
              GuideName = "Target_Start_120713"
            }
          }
        },
        commentData = {}
      }
    },
    ["17828040018701077881"] = {
      isStoryNode = true,
      key = "17828040018701077881",
      type = "StoryNode",
      name = "酒馆",
      pos = {x = 1370.5909506969006, y = 275.2741285030758},
      propsData = {
        QuestId = 12070102,
        QuestDescriptionComment = "酒馆对话",
        QuestDescription = "Description_120701_1",
        QuestDeatil = "Content_120701_1",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = false,
        bIsNotifyGameMode = true,
        bIsStartChapter = false,
        bIsEndChapter = false,
        bIsPlayBlackScreenOnComplete = true,
        bIsPlayBlackScreenOnFail = false,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        SubRegionId = 101107,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "Target_Start_120713",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17829730635791313",
            startPort = "Success",
            endQuest = "17828040018701077887",
            endPort = "Success"
          },
          {
            startQuest = "17900766860932997",
            startPort = "Out",
            endQuest = "17900766860932996",
            endPort = "Input"
          },
          {
            startQuest = "17900766860932998",
            startPort = "Out",
            endQuest = "17900766860932997",
            endPort = "In"
          },
          {
            startQuest = "17900766860932996",
            startPort = "True",
            endQuest = "17900766860932999",
            endPort = "In"
          },
          {
            startQuest = "17900766860933000",
            startPort = "Out",
            endQuest = "17900766860932998",
            endPort = "In"
          },
          {
            startQuest = "17900766860932996",
            startPort = "False",
            endQuest = "17900766860933000",
            endPort = "In"
          },
          {
            startQuest = "17828040018701077886",
            startPort = "QuestStart",
            endQuest = "17900766860933000",
            endPort = "In"
          },
          {
            startQuest = "17900766860932999",
            startPort = "Out",
            endQuest = "17829730635791313",
            endPort = "In"
          },
          {
            startQuest = "17902317002882857",
            startPort = "Out",
            endQuest = "17902317002882856",
            endPort = "In"
          },
          {
            startQuest = "17829730635791313",
            startPort = "Fail",
            endQuest = "17902317002882857",
            endPort = "In"
          },
          {
            startQuest = "17829730635791313",
            startPort = "PassiveFail",
            endQuest = "17902317002882857",
            endPort = "In"
          },
          {
            startQuest = "17902317002882856",
            startPort = "Out",
            endQuest = "17828040018701077888",
            endPort = "Fail"
          },
          {
            startQuest = "17829730635791313",
            startPort = "Success",
            endQuest = "17902328676271728253",
            endPort = "In"
          }
        },
        nodeData = {
          ["17828040018701077886"] = {
            key = "17828040018701077886",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -265.73853081902604, y = 364.25724739656636},
            propsData = {ModeType = 0}
          },
          ["17828040018701077887"] = {
            key = "17828040018701077887",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1230.3026420902647, y = 591.3896481765643},
            propsData = {ModeType = 0}
          },
          ["17828040018701077888"] = {
            key = "17828040018701077888",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1236.5981942893704, y = 1059.9957297604353},
            propsData = {}
          },
          ["17829730635791313"] = {
            key = "17829730635791313",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务101",
            pos = {x = 880.1518723794269, y = 600.7367266376555},
            propsData = {SpecialConfigId = 12070101, BlackScreenImmediately = true}
          },
          ["17900766860932996"] = {
            key = "17900766860932996",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 852.0269251041059, y = 355.36344522686903},
            propsData = {PopupId = 100110}
          },
          ["17900766860932997"] = {
            key = "17900766860932997",
            type = "PickUpNode",
            name = "交互接任务",
            pos = {x = 578.1402880246509, y = 357.23523157398097},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 120713,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "Target_Start_120713",
              IsUseCount = false
            }
          },
          ["17900766860932998"] = {
            key = "17900766860932998",
            type = "ChangeStaticCreatorNode",
            name = "生成接任务交互",
            pos = {x = 295.42334022149635, y = 364.1881101130664},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351220212}
            }
          },
          ["17900766860932999"] = {
            key = "17900766860932999",
            type = "ChangeStaticCreatorNode",
            name = "销毁接任务交互",
            pos = {x = 588.0327331169307, y = 619.1275185307356},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351220212}
            }
          },
          ["17900766860933000"] = {
            key = "17900766860933000",
            type = "GoToRegionNode",
            name = "判定进入水仙平原",
            pos = {x = 30.202561000716855, y = 352.6371873516174},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101107,
              bGuideUIEnable = true,
              GuideType = "P",
              GuideName = "Target_Start_120713"
            }
          },
          ["17902317002882856"] = {
            key = "17902317002882856",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 1233.8540653841073, y = 900.8408901498067},
            propsData = {}
          },
          ["17902317002882857"] = {
            key = "17902317002882857",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1227.1669136368719, y = 724.9842846753686},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_BarRestart_1207",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17902328676271728253"] = {
            key = "17902328676271728253",
            type = "CommonBlackFadeInOutNode",
            name = "防穿帮",
            pos = {x = 1229.7630454340983, y = 421.36363636363626},
            propsData = {FadeTime = 0.5, FadeType = "FadeOut"}
          }
        },
        commentData = {}
      }
    },
    ["17901697474181796"] = {
      isStoryNode = true,
      key = "17901697474181796",
      type = "StoryNode",
      name = "秘密基地",
      pos = {x = 1675.5584415584415, y = 278.8571428571428},
      propsData = {
        QuestId = 12070103,
        QuestDescriptionComment = "基地怀旧",
        QuestDescription = "Description_120701_2",
        QuestDeatil = "Content_120701_2",
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
        SubRegionId = 101108,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestTrigger_351940053",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17901721821705786",
            startPort = "Out",
            endQuest = "17901721502264882",
            endPort = "In"
          },
          {
            startQuest = "17901721502264882",
            startPort = "Success",
            endQuest = "17901697474181800",
            endPort = "Success"
          },
          {
            startQuest = "17902319246443944",
            startPort = "Out",
            endQuest = "17902319246443943",
            endPort = "In"
          },
          {
            startQuest = "17902319246443943",
            startPort = "Out",
            endQuest = "17901697474181803",
            endPort = "Fail"
          },
          {
            startQuest = "17901721502264882",
            startPort = "Fail",
            endQuest = "17902319246443944",
            endPort = "In"
          },
          {
            startQuest = "17901697474181797",
            startPort = "QuestStart",
            endQuest = "17901722346046200",
            endPort = "In"
          },
          {
            startQuest = "17901722346046200",
            startPort = "true",
            endQuest = "17901721821705786",
            endPort = "In"
          },
          {
            startQuest = "17901722346046200",
            startPort = "false",
            endQuest = "17901721502264882",
            endPort = "In"
          },
          {
            startQuest = "17901721502264882",
            startPort = "PassiveFail",
            endQuest = "17902319246443944",
            endPort = "In"
          },
          {
            startQuest = "17901722346046200",
            startPort = "false",
            endQuest = "17901722346046199",
            endPort = "In"
          }
        },
        nodeData = {
          ["17901697474181797"] = {
            key = "17901697474181797",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 350.37267080745335, y = 277.0807453416149},
            propsData = {ModeType = 0}
          },
          ["17901697474181800"] = {
            key = "17901697474181800",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1610.551242236025, y = 259.45652173913044},
            propsData = {ModeType = 0}
          },
          ["17901697474181803"] = {
            key = "17901697474181803",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1610.3571428571427, y = 750.9083850931678},
            propsData = {}
          },
          ["17901721502264882"] = {
            key = "17901721502264882",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务111",
            pos = {x = 1285.9254658385094, y = 265.552795031056},
            propsData = {SpecialConfigId = 12070111, BlackScreenImmediately = true}
          },
          ["17901721821705786"] = {
            key = "17901721821705786",
            type = "GoToNode",
            name = "前往",
            pos = {x = 963.2701863354037, y = 168.50724637681154},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351940053,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351940053"
            }
          },
          ["17901722346046199"] = {
            key = "17901722346046199",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 960.9299716673611, y = 402.6297083770393},
            propsData = {VarName = "1.7_Lise01", VarValue = 95}
          },
          ["17901722346046200"] = {
            key = "17901722346046200",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 651.5508035676336, y = 267.65947796943584},
            propsData = {
              FunctionName = "Equal",
              VarName = "1.7_Lise01",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "95"}
              }
            }
          },
          ["17902319246443943"] = {
            key = "17902319246443943",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 1612.6178638827635, y = 595.4921150186245},
            propsData = {}
          },
          ["17902319246443944"] = {
            key = "17902319246443944",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1608.9065722074622, y = 409.53099422507296},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_ToScer_1207",
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
