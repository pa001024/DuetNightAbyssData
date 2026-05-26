return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17779687146306554400",
      startPort = "StoryStart",
      endStory = "17779687235166554438",
      endPort = "In"
    },
    {
      startStory = "17779687235166554438",
      startPort = "Success",
      endStory = "177815586489924644485",
      endPort = "In"
    },
    {
      startStory = "177815586489924644485",
      startPort = "Success",
      endStory = "17779687146306554403",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17779687146306554400"] = {
      isStoryNode = true,
      key = "17779687146306554400",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1000.1623376623376, y = 175.51948051948048},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17779687146306554403"] = {
      isStoryNode = true,
      key = "17779687146306554403",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2034.92789968652, y = 192.576802507837},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17779687235166554438"] = {
      isStoryNode = true,
      key = "17779687235166554438",
      type = "StoryNode",
      name = "潜入特殊任务开始",
      pos = {x = 1373.375951634572, y = 161.04836542767578},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040109_01",
        QuestDeatil = "Description_10040109_01",
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
        IsBacktrack = false,
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17779687235176554449",
            startPort = "Out",
            endQuest = "17779687235176554448",
            endPort = "In"
          },
          {
            startQuest = "17779687235176554450",
            startPort = "Out",
            endQuest = "17779687235176554447",
            endPort = "In"
          },
          {
            startQuest = "17779687235176554443",
            startPort = "QuestStart",
            endQuest = "17779687235176554451",
            endPort = "In"
          },
          {
            startQuest = "17779687235176554443",
            startPort = "QuestStart",
            endQuest = "17779687528167488330",
            endPort = "In"
          },
          {
            startQuest = "17779687528167488330",
            startPort = "Out",
            endQuest = "17779687235176554445",
            endPort = "Fail"
          },
          {
            startQuest = "17779687235176554451",
            startPort = "Out",
            endQuest = "17779687235176554450",
            endPort = "In"
          },
          {
            startQuest = "17779687235176554450",
            startPort = "Out",
            endQuest = "17779687235176554449",
            endPort = "In"
          },
          {
            startQuest = "17779687235176554448",
            startPort = "Out",
            endQuest = "17779687235176554444",
            endPort = "Success"
          },
          {
            startQuest = "17779687235176554450",
            startPort = "Out",
            endQuest = "1779710199960793",
            endPort = "In"
          }
        },
        nodeData = {
          ["17779687235176554443"] = {
            key = "17779687235176554443",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -267.8163780663781, y = 360.32142857142856},
            propsData = {ModeType = 0}
          },
          ["17779687235176554444"] = {
            key = "17779687235176554444",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1542.2047682709447, y = 347.7803507766743},
            propsData = {ModeType = 0}
          },
          ["17779687235176554445"] = {
            key = "17779687235176554445",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1010.1854395604395, y = 885.6696428571429},
            propsData = {}
          },
          ["17779687235176554446"] = {
            key = "17779687235176554446",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "地下潜入特殊任务",
            pos = {x = 1440.203803100841, y = -160.1522985503462},
            propsData = {SpecialConfigId = 0, BlackScreenImmediately = false}
          },
          ["17779687235176554447"] = {
            key = "17779687235176554447",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 917.715256965257, y = 31.23423798423795},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "DixiaQianruStart",
              UnitId = -1
            }
          },
          ["17779687235176554448"] = {
            key = "17779687235176554448",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1087.4967532467533, y = 349.51948051948057},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480037,
              GuideType = "M",
              GuidePointName = "Mechanism_DixiaQianru01_272480037"
            }
          },
          ["17779687235176554449"] = {
            key = "17779687235176554449",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 753.0353591777433, y = 373.6600340986737},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10041001.10041001'",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17779687235176554450"] = {
            key = "17779687235176554450",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 392.8790231507622, y = 361.9068322981367},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_QianruStart",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17779687235176554451"] = {
            key = "17779687235176554451",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 80.81318681318677, y = 344.4890109890111},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["17779687528167488330"] = {
            key = "17779687528167488330",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 443.7909243057986, y = 867.2148286496113},
            propsData = {}
          },
          ["1779710199960793"] = {
            key = "1779710199960793",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 586, y = -12},
            propsData = {
              VarName = "FirstStateQianru10040102",
              VarValue = 1
            }
          }
        },
        commentData = {}
      }
    },
    ["177815586489924644485"] = {
      isStoryNode = true,
      key = "177815586489924644485",
      type = "StoryNode",
      name = "潜入特殊任务二阶段",
      pos = {x = 1741.4482758620688, y = 166.68965517241378},
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
        IsBacktrack = false,
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177815586490024644490",
            startPort = "QuestStart",
            endQuest = "177815586490024644493",
            endPort = "In"
          },
          {
            startQuest = "177815586490024644493",
            startPort = "Out",
            endQuest = "177815586490024644496",
            endPort = "In"
          },
          {
            startQuest = "177815586490024644493",
            startPort = "Out",
            endQuest = "177815586490024644497",
            endPort = "In"
          },
          {
            startQuest = "177815586490024644498",
            startPort = "Out",
            endQuest = "177815586490024644499",
            endPort = "In"
          },
          {
            startQuest = "177815586490024644490",
            startPort = "QuestStart",
            endQuest = "177815586490024644501",
            endPort = "In"
          },
          {
            startQuest = "177815586490024644501",
            startPort = "Out",
            endQuest = "177815586490024644492",
            endPort = "Fail"
          },
          {
            startQuest = "177815586490124644504",
            startPort = "Out",
            endQuest = "177815586490124644505",
            endPort = "In"
          },
          {
            startQuest = "177815586490124644512",
            startPort = "Out",
            endQuest = "177815586490124644513",
            endPort = "In"
          },
          {
            startQuest = "177815586490124644510",
            startPort = "Out",
            endQuest = "177815586490124644512",
            endPort = "Stop"
          },
          {
            startQuest = "177815586490124644516",
            startPort = "Out",
            endQuest = "177815586490124644504",
            endPort = "Stop"
          },
          {
            startQuest = "177815586490124644505",
            startPort = "Out",
            endQuest = "177815586490224644517",
            endPort = "In"
          },
          {
            startQuest = "177815586490224644517",
            startPort = "Out",
            endQuest = "177815586490124644506",
            endPort = "In"
          },
          {
            startQuest = "177815586490224644520",
            startPort = "Out",
            endQuest = "177815586490224644518",
            endPort = "In"
          },
          {
            startQuest = "177815586490224644522",
            startPort = "Out",
            endQuest = "177815586490224644523",
            endPort = "In"
          },
          {
            startQuest = "177815586490224644525",
            startPort = "Out",
            endQuest = "177815586490224644522",
            endPort = "Stop"
          },
          {
            startQuest = "177815586490024644495",
            startPort = "Out",
            endQuest = "177815586490224644520",
            endPort = "In"
          },
          {
            startQuest = "177815586490024644494",
            startPort = "Out",
            endQuest = "177815586490024644495",
            endPort = "In"
          },
          {
            startQuest = "177815586490024644493",
            startPort = "Out",
            endQuest = "177815586490024644494",
            endPort = "In"
          },
          {
            startQuest = "177815586490224644518",
            startPort = "Out",
            endQuest = "177815588841424645163",
            endPort = "In"
          },
          {
            startQuest = "177815588841424645163",
            startPort = "Out",
            endQuest = "177815586490224644528",
            endPort = "In"
          },
          {
            startQuest = "177815586490124644508",
            startPort = "Out",
            endQuest = "177815586490024644498",
            endPort = "Stop"
          },
          {
            startQuest = "177815586490124644508",
            startPort = "Out",
            endQuest = "177815586490024644499",
            endPort = "Stop"
          },
          {
            startQuest = "177815586490124644510",
            startPort = "Out",
            endQuest = "177815586490124644513",
            endPort = "Stop"
          },
          {
            startQuest = "177815586490124644516",
            startPort = "Out",
            endQuest = "177815586490124644505",
            endPort = "Stop"
          },
          {
            startQuest = "177815586490124644516",
            startPort = "Out",
            endQuest = "177815586490224644517",
            endPort = "Stop"
          },
          {
            startQuest = "177815586490124644516",
            startPort = "Out",
            endQuest = "177815586490124644506",
            endPort = "Stop"
          },
          {
            startQuest = "177815586490124644507",
            startPort = "Out",
            endQuest = "177816041515613265288",
            endPort = "In"
          },
          {
            startQuest = "177815586490224644525",
            startPort = "Out",
            endQuest = "177815586490224644523",
            endPort = "Stop"
          },
          {
            startQuest = "177815586490024644493",
            startPort = "Out",
            endQuest = "177816045435215159407",
            endPort = "In"
          },
          {
            startQuest = "177816045435215159407",
            startPort = "Out",
            endQuest = "177815586490124644508",
            endPort = "In"
          },
          {
            startQuest = "177815586490124644508",
            startPort = "Out",
            endQuest = "177816048864115160058",
            endPort = "Branch_1"
          },
          {
            startQuest = "177815586490124644508",
            startPort = "Out",
            endQuest = "177815586490024644500",
            endPort = "In"
          },
          {
            startQuest = "177815586490024644494",
            startPort = "Out",
            endQuest = "177816056720015161304",
            endPort = "In"
          },
          {
            startQuest = "177816056720015161304",
            startPort = "Out",
            endQuest = "177815586490124644510",
            endPort = "In"
          },
          {
            startQuest = "177815586490124644510",
            startPort = "Out",
            endQuest = "177815586490124644514",
            endPort = "In"
          },
          {
            startQuest = "177815586490124644510",
            startPort = "Out",
            endQuest = "177816057746715161662",
            endPort = "Branch_1"
          },
          {
            startQuest = "177815586490124644516",
            startPort = "Out",
            endQuest = "177815586490124644507",
            endPort = "In"
          },
          {
            startQuest = "177815586490024644495",
            startPort = "Out",
            endQuest = "177816059655115162270",
            endPort = "In"
          },
          {
            startQuest = "177816059655115162270",
            startPort = "Out",
            endQuest = "177815586490124644516",
            endPort = "In"
          },
          {
            startQuest = "177815586490124644516",
            startPort = "Out",
            endQuest = "177816059655115162271",
            endPort = "Branch_1"
          },
          {
            startQuest = "177815586490224644520",
            startPort = "Out",
            endQuest = "177816062145115163063",
            endPort = "In"
          },
          {
            startQuest = "177816062145115163063",
            startPort = "Out",
            endQuest = "177815586490224644525",
            endPort = "In"
          },
          {
            startQuest = "177815586490224644525",
            startPort = "Out",
            endQuest = "177815586490224644524",
            endPort = "In"
          },
          {
            startQuest = "177815586490224644525",
            startPort = "Out",
            endQuest = "177816062145115163064",
            endPort = "Branch_1"
          },
          {
            startQuest = "177815586490224644520",
            startPort = "Out",
            endQuest = "17784940509802440401",
            endPort = "In"
          },
          {
            startQuest = "17797087841102907241",
            startPort = "Out",
            endQuest = "177815586490224644519",
            endPort = "In"
          },
          {
            startQuest = "177815586490224644520",
            startPort = "Out",
            endQuest = "17797087841102907241",
            endPort = "In"
          }
        },
        nodeData = {
          ["177815586490024644490"] = {
            key = "177815586490024644490",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -118.6451406649616, y = 331.06341340884177},
            propsData = {ModeType = 0}
          },
          ["177815586490024644491"] = {
            key = "177815586490024644491",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 4615.14472817419, y = -164.36345600433123},
            propsData = {ModeType = 0}
          },
          ["177815586490024644492"] = {
            key = "177815586490024644492",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1064.0078671328674, y = 1599.700611888112},
            propsData = {}
          },
          ["177815586490024644493"] = {
            key = "177815586490024644493",
            type = "GoToNode",
            name = "前往",
            pos = {x = 277.0720098316005, y = 451.6357989836251},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480038,
              GuideType = "M",
              GuidePointName = "Mechanism_DixiaQianru02_272480038"
            }
          },
          ["177815586490024644494"] = {
            key = "177815586490024644494",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1318.2588792954252, y = 352.2670519008519},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480039,
              GuideType = "M",
              GuidePointName = "Mechanism_DixiaQianru03_272480039"
            }
          },
          ["177815586490024644495"] = {
            key = "177815586490024644495",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2282.61117093672, y = 342.0877739466378},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480040,
              GuideType = "M",
              GuidePointName = "Mechanism_DixiaQianru04_272480040"
            }
          },
          ["177815586490024644496"] = {
            key = "177815586490024644496",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 704.390977443609, y = -209.55263157894737},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049901_64.10049901_64'",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["177815586490024644497"] = {
            key = "177815586490024644497",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 996.5810154757526, y = -28.564751038435347},
            propsData = {
              NewDescription = "Content_10040109_01",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["177815586490024644498"] = {
            key = "177815586490024644498",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 540.716725303682, y = 1202.6116311225007},
            propsData = {WaitTime = 60}
          },
          ["177815586490024644499"] = {
            key = "177815586490024644499",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1156.1838487599364, y = 1239.7644420796594},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_QianruPrompt01"
            }
          },
          ["177815586490024644500"] = {
            key = "177815586490024644500",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1364.1939944113858, y = 708.7436621349665},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_QianruPrompt01"
            }
          },
          ["177815586490024644501"] = {
            key = "177815586490024644501",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 284.6602564102566, y = 1497.9980852480853},
            propsData = {}
          },
          ["177815586490124644504"] = {
            key = "177815586490124644504",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 2456.02719210614, y = 836.0021732653312},
            propsData = {WaitTime = 60}
          },
          ["177815586490124644505"] = {
            key = "177815586490124644505",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2782.9109005030064, y = 915.9266961109065},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_QianruPrompt03"
            }
          },
          ["177815586490124644506"] = {
            key = "177815586490124644506",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 3386.4533544258943, y = 913.3272980833049},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_BP_QianruPrompt03_02"
            }
          },
          ["177815586490124644507"] = {
            key = "177815586490124644507",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 3373.518160234121, y = 594.7071250164787},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_QianruPrompt02"
            }
          },
          ["177815586490124644508"] = {
            key = "177815586490124644508",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 839.3863006973287, y = 733.3926597474854},
            propsData = {
              CreateType = "ManualItem",
              CreateId = 228018,
              StateId = 1610012,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["177815586490124644510"] = {
            key = "177815586490124644510",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 1717.9059471230528, y = 626.7325727677895},
            propsData = {
              CreateType = "ManualItem",
              CreateId = 228006,
              StateId = 504,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["177815586490124644512"] = {
            key = "177815586490124644512",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1744.9205816113717, y = 1263.4990316700844},
            propsData = {WaitTime = 60}
          },
          ["177815586490124644513"] = {
            key = "177815586490124644513",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2296.4283501586146, y = 1286.4197951171632},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_QianruPrompt02"
            }
          },
          ["177815586490124644514"] = {
            key = "177815586490124644514",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2029.0053477224537, y = 456.86136670347196},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_QianruPrompt02"
            }
          },
          ["177815586490124644516"] = {
            key = "177815586490124644516",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 2892.860507436881, y = 472.2258923305497},
            propsData = {
              CreateType = "ManualItem",
              CreateId = 228020,
              StateId = 1610012,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["177815586490224644517"] = {
            key = "177815586490224644517",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 3087.069370387095, y = 907.7219887096048},
            propsData = {
              CreateType = "ManualItem",
              CreateId = 228020,
              StateId = 1610012,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["177815586490224644518"] = {
            key = "177815586490224644518",
            type = "GoToNode",
            name = "前往",
            pos = {x = 4202.566937835128, y = 305.8289472825068},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272890087,
              GuideType = "M",
              GuidePointName = "Mechanism_QainruTiaobanEnd_272890087"
            }
          },
          ["177815586490224644519"] = {
            key = "177815586490224644519",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 3972.0317378111417, y = -80.18551759557991},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049901_65.10049901_65'",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["177815586490224644520"] = {
            key = "177815586490224644520",
            type = "GoToNode",
            name = "前往",
            pos = {x = 3386.6793143058544, y = 339.2215007386822},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480041,
              GuideType = "M",
              GuidePointName = "Mechanism_DixiaQianru05_272480041"
            }
          },
          ["177815586490224644522"] = {
            key = "177815586490224644522",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 3908.199094770488, y = 851.4437140660664},
            propsData = {WaitTime = 60}
          },
          ["177815586490224644523"] = {
            key = "177815586490224644523",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 4285.793983291578, y = 870.0721706590539},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_QianruPrompt03"
            }
          },
          ["177815586490224644524"] = {
            key = "177815586490224644524",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 4615.680122514673, y = 578.2802260476014},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_BP_QianruPrompt03_02"
            }
          },
          ["177815586490224644525"] = {
            key = "177815586490224644525",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 4073.242129650984, y = 508.05107613404743},
            propsData = {
              CreateType = "ManualItem",
              CreateId = 228021,
              StateId = 3901701,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["177815586490224644528"] = {
            key = "177815586490224644528",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 4875.46993168697, y = 298.596057687021},
            propsData = {}
          },
          ["177815588841424645163"] = {
            key = "177815588841424645163",
            type = "GoToNode",
            name = "前往",
            pos = {x = 4525.298522987309, y = 311.0237154150197},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2490002,
              GuideType = "M",
              GuidePointName = "Mechanism_QianruShigu_2490002"
            }
          },
          ["177816041515613265288"] = {
            key = "177816041515613265288",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 3580.870111351949, y = 777.0268182728913},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_BP_QianruPrompt03_02"
            }
          },
          ["177816045435215159407"] = {
            key = "177816045435215159407",
            type = "BranchQuestStartNode",
            name = "子任务开始节点",
            pos = {x = 540.2292837394383, y = 733.8880102845409},
            propsData = {
              AllQuestOptions = {
                {
                  IsNeedFinish = true,
                  BranchQuestName = "Content_10040109_05",
                  TargetBranchQuestKey = ""
                }
              },
              IsSetCountInfo = false,
              IsDifftation = false,
              AllDiffGuideOptions = {
                {
                  OptionElements = {
                    {TargetIndicatorKey = "", IsShowOptional = true}
                  }
                }
              }
            }
          },
          ["177816048864115160058"] = {
            key = "177816048864115160058",
            type = "CheckBranchQuestFinishedNode",
            name = "子任务结束节点",
            pos = {x = 1273.499235211529, y = 908.0320569811823},
            propsData = {
              InputBranchQuestNumber = 1,
              BranchQuestFinishOptions = {
                {IsNeedFinish = true}
              }
            }
          },
          ["177816056720015161304"] = {
            key = "177816056720015161304",
            type = "BranchQuestStartNode",
            name = "子任务开始节点",
            pos = {x = 1290.6109840092386, y = 593.9582185837469},
            propsData = {
              AllQuestOptions = {
                {
                  IsNeedFinish = true,
                  BranchQuestName = "Content_10040109_05",
                  TargetBranchQuestKey = ""
                }
              },
              IsSetCountInfo = false,
              IsDifftation = false,
              AllDiffGuideOptions = {
                {
                  OptionElements = {
                    {TargetIndicatorKey = "", IsShowOptional = true}
                  }
                }
              }
            }
          },
          ["177816057746715161662"] = {
            key = "177816057746715161662",
            type = "CheckBranchQuestFinishedNode",
            name = "子任务结束节点",
            pos = {x = 2129.4314174457713, y = 685.0913455187315},
            propsData = {
              InputBranchQuestNumber = 1,
              BranchQuestFinishOptions = {
                {IsNeedFinish = true}
              }
            }
          },
          ["177816059655115162270"] = {
            key = "177816059655115162270",
            type = "BranchQuestStartNode",
            name = "子任务开始节点",
            pos = {x = 2568.491567821711, y = 495.8093906315137},
            propsData = {
              AllQuestOptions = {
                {
                  IsNeedFinish = true,
                  BranchQuestName = "Content_10040109_05",
                  TargetBranchQuestKey = ""
                }
              },
              IsSetCountInfo = false,
              IsDifftation = false,
              AllDiffGuideOptions = {
                {
                  OptionElements = {
                    {TargetIndicatorKey = "", IsShowOptional = true}
                  }
                }
              }
            }
          },
          ["177816059655115162271"] = {
            key = "177816059655115162271",
            type = "CheckBranchQuestFinishedNode",
            name = "子任务结束节点",
            pos = {x = 3471.0178836111854, y = 1192.6778116841454},
            propsData = {
              InputBranchQuestNumber = 1,
              BranchQuestFinishOptions = {
                {IsNeedFinish = true}
              }
            }
          },
          ["177816062145115163063"] = {
            key = "177816062145115163063",
            type = "BranchQuestStartNode",
            name = "子任务开始节点",
            pos = {x = 3795.986366198728, y = 502.789074495906},
            propsData = {
              AllQuestOptions = {
                {
                  IsNeedFinish = true,
                  BranchQuestName = "Content_10040109_05",
                  TargetBranchQuestKey = ""
                }
              },
              IsSetCountInfo = false,
              IsDifftation = false,
              AllDiffGuideOptions = {
                {
                  OptionElements = {
                    {TargetIndicatorKey = "", IsShowOptional = true}
                  }
                }
              }
            }
          },
          ["177816062145115163064"] = {
            key = "177816062145115163064",
            type = "CheckBranchQuestFinishedNode",
            name = "子任务结束节点",
            pos = {x = 4640.042093752909, y = 1015.1995123552604},
            propsData = {
              InputBranchQuestNumber = 1,
              BranchQuestFinishOptions = {
                {IsNeedFinish = true}
              }
            }
          },
          ["17784940509802440401"] = {
            key = "17784940509802440401",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 3860.1605351170574, y = 186.58193979933114},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "TriggerHWQBoxTrap",
              UnitId = -1
            }
          },
          ["17797087841102907241"] = {
            key = "17797087841102907241",
            type = "GoToNode",
            name = "前往",
            pos = {x = 3585.2496813336634, y = -65.53164311608563},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 272890116,
              GuideType = "M",
              GuidePointName = "Mechanism_QiaobanGuide_272890116"
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
