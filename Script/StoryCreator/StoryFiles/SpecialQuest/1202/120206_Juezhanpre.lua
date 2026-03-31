return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17743348227351",
      startPort = "StoryStart",
      endStory = "177433482535147",
      endPort = "In"
    },
    {
      startStory = "177433482535147",
      startPort = "Success",
      endStory = "17743348227365",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17743348227351"] = {
      isStoryNode = true,
      key = "17743348227351",
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
    ["17743348227365"] = {
      isStoryNode = true,
      key = "17743348227365",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2800, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177433482535147"] = {
      isStoryNode = true,
      key = "177433482535147",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1676, y = 510},
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
            startQuest = "1774335012883845660",
            startPort = "Out",
            endQuest = "1774335012883845662",
            endPort = "In"
          },
          {
            startQuest = "1774335012883845662",
            startPort = "Out",
            endQuest = "1774335012883845663",
            endPort = "In"
          },
          {
            startQuest = "1774335012883845663",
            startPort = "Out",
            endQuest = "1774335012883845661",
            endPort = "In"
          },
          {
            startQuest = "1774335012883845661",
            startPort = "Out",
            endQuest = "1774335012883845664",
            endPort = "In"
          },
          {
            startQuest = "1774335012883845661",
            startPort = "Out",
            endQuest = "1774335012883845665",
            endPort = "In"
          },
          {
            startQuest = "1774335012883845665",
            startPort = "Out",
            endQuest = "1774335012883845666",
            endPort = "Input_1"
          },
          {
            startQuest = "1774335012883845662",
            startPort = "Out",
            endQuest = "1774335012883845667",
            endPort = "In"
          },
          {
            startQuest = "177433482535248",
            startPort = "QuestStart",
            endQuest = "1774335012883845660",
            endPort = "In"
          },
          {
            startQuest = "177433482535248",
            startPort = "QuestStart",
            endQuest = "1774335029389846126",
            endPort = "In"
          },
          {
            startQuest = "17748548016053838307",
            startPort = "Out",
            endQuest = "17748548016053838308",
            endPort = "Input_1"
          },
          {
            startQuest = "1774335029389846126",
            startPort = "Out",
            endQuest = "17748548016053838307",
            endPort = "In"
          },
          {
            startQuest = "1774335029389846126",
            startPort = "Out",
            endQuest = "17748548016053838306",
            endPort = "In"
          },
          {
            startQuest = "17748548016053838308",
            startPort = "Out",
            endQuest = "177433482535264",
            endPort = "Fail"
          },
          {
            startQuest = "177433482535248",
            startPort = "QuestStart",
            endQuest = "17748548116213838567",
            endPort = "In"
          },
          {
            startQuest = "177433482535248",
            startPort = "QuestStart",
            endQuest = "17748548116213838566",
            endPort = "In"
          },
          {
            startQuest = "177433482535248",
            startPort = "QuestStart",
            endQuest = "17748604317126398890",
            endPort = "In"
          },
          {
            startQuest = "17748548016053838306",
            startPort = "Out",
            endQuest = "17748604374436399119",
            endPort = "In"
          },
          {
            startQuest = "17748604374436399119",
            startPort = "Out",
            endQuest = "17748548016053838308",
            endPort = "Input_2"
          },
          {
            startQuest = "1774335012883845666",
            startPort = "Out",
            endQuest = "1774335023080845961",
            endPort = "In"
          },
          {
            startQuest = "1774335012883845664",
            startPort = "Out",
            endQuest = "17748604452186399387",
            endPort = "In"
          },
          {
            startQuest = "17748604452186399387",
            startPort = "Out",
            endQuest = "1774335012883845666",
            endPort = "Input_2"
          }
        },
        nodeData = {
          ["177433482535248"] = {
            key = "177433482535248",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177433482535256"] = {
            key = "177433482535256",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177433482535264"] = {
            key = "177433482535264",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2689.478260869565, y = 1037.4782608695652},
            propsData = {}
          },
          ["1774335012883845660"] = {
            key = "1774335012883845660",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1174.8568087667786, y = 431.8660297515371},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 242410154,
              GuideType = "M",
              GuidePointName = "Mechanism_12020611hezi1_242410154"
            }
          },
          ["1774335012883845661"] = {
            key = "1774335012883845661",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1975.062063665137, y = 435.5795388478049},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {242410157},
              QuestPickupId = -1,
              UnitId = 11229,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "Drop_12020611drop_242410157",
              IsUseCount = false
            }
          },
          ["1774335012883845662"] = {
            key = "1774335012883845662",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1448.5298699218488, y = 425.00949716618186},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 242410155,
              GuideType = "M",
              GuidePointName = "Mechanism_12020611hezi2_242410155"
            }
          },
          ["1774335012883845663"] = {
            key = "1774335012883845663",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1715.268935454018, y = 441.24624892017493},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 242410156,
              GuideType = "M",
              GuidePointName = "Mechanism_12020611hezi3_242410156"
            }
          },
          ["1774335012883845664"] = {
            key = "1774335012883845664",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2212.146778949852, y = 547.9766472949136},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "JuezhanLightEnd",
              UnitId = -1
            }
          },
          ["1774335012883845665"] = {
            key = "1774335012883845665",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2228.6050479671917, y = 382.9945532021001},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "LigntningEnd",
              UnitId = -1
            }
          },
          ["1774335012883845666"] = {
            key = "1774335012883845666",
            type = "WaitQuestFinishedNode",
            name = "等待任务完成",
            pos = {x = 2641.6431912332214, y = 555.2877890517077},
            propsData = {ListenCount = 2, NeedFinishCount = 2}
          },
          ["1774335012883845667"] = {
            key = "1774335012883845667",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1771.6840947300473, y = 260.0233527050864},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 12048748,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1774335023080845961"] = {
            key = "1774335023080845961",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2973.3496240601507, y = 614.5112781954886},
            propsData = {}
          },
          ["1774335029389846126"] = {
            key = "1774335029389846126",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1474.2105263157896, y = 845.6842105263157},
            propsData = {}
          },
          ["17748548016053838306"] = {
            key = "17748548016053838306",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1782.8375467781646, y = 956.7068484075171},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "JuezhanLightEnd",
              UnitId = -1
            }
          },
          ["17748548016053838307"] = {
            key = "17748548016053838307",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1799.2958157955043, y = 791.7247543147035},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "LigntningEnd",
              UnitId = -1
            }
          },
          ["17748548016053838308"] = {
            key = "17748548016053838308",
            type = "WaitQuestFinishedNode",
            name = "等待任务完成",
            pos = {x = 2385.4861329745772, y = 953.3037044500255},
            propsData = {ListenCount = 2, NeedFinishCount = 2}
          },
          ["17748548116213838566"] = {
            key = "17748548116213838566",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1093.0093873736312, y = 20.125325170634028},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "JuezhanLight",
              UnitId = -1
            }
          },
          ["17748548116213838567"] = {
            key = "17748548116213838567",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1074.4716422755919, y = 175.525325170634},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "LigntningStart",
              UnitId = -1
            }
          },
          ["17748604317126398890"] = {
            key = "17748604317126398890",
            type = "SetGlobalSoundParamNode",
            name = "设置全局音效参数",
            pos = {x = 1195, y = -203.66666666666663},
            propsData = {
              ParamName = "parameter:/story/story_1_3_final_disaste",
              ParamValue = 1
            }
          },
          ["17748604374436399119"] = {
            key = "17748604374436399119",
            type = "SetGlobalSoundParamNode",
            name = "设置全局音效参数",
            pos = {x = 2098.768115942029, y = 1064.0144927536232},
            propsData = {
              ParamName = "parameter:/story/story_1_3_final_disaste",
              ParamValue = 0
            }
          },
          ["17748604452186399387"] = {
            key = "17748604452186399387",
            type = "SetGlobalSoundParamNode",
            name = "设置全局音效参数",
            pos = {x = 2372.6993417210806, y = 743.1392206826991},
            propsData = {
              ParamName = "parameter:/story/story_1_3_final_disaste",
              ParamValue = 0
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
