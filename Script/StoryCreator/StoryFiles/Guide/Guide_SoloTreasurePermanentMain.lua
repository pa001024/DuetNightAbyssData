return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17839529888964888526",
      startPort = "StoryStart",
      endStory = "17839529888964888528",
      endPort = "In"
    },
    {
      startStory = "17839529888964888528",
      startPort = "Success",
      endStory = "17839529888964888527",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17839529888964888526"] = {
      isStoryNode = true,
      key = "17839529888964888526",
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
    ["17839529888964888527"] = {
      isStoryNode = true,
      key = "17839529888964888527",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2232, y = 328},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17839529888964888528"] = {
      isStoryNode = true,
      key = "17839529888964888528",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1568, y = 346},
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
            startQuest = "17839529888964888533",
            startPort = "Out",
            endQuest = "17839529888964888530",
            endPort = "Success"
          },
          {
            startQuest = "17839516130603187933",
            startPort = "Out",
            endQuest = "17839529888964888533",
            endPort = "In"
          },
          {
            startQuest = "17845474471672121062",
            startPort = "Out",
            endQuest = "17839516130603187933",
            endPort = "In"
          },
          {
            startQuest = "17839529888964888529",
            startPort = "QuestStart",
            endQuest = "17845475129123181834",
            endPort = "Input"
          },
          {
            startQuest = "17845475129123181834",
            startPort = "Gamepad",
            endQuest = "17845474471672121062",
            endPort = "In"
          },
          {
            startQuest = "17845475129123181834",
            startPort = "MouseAndKeyboard",
            endQuest = "17845475556453182488",
            endPort = "In"
          },
          {
            startQuest = "17845475129123181834",
            startPort = "Touch",
            endQuest = "17845475556453182488",
            endPort = "In"
          },
          {
            startQuest = "17845475556453182488",
            startPort = "Out",
            endQuest = "17839529888964888533",
            endPort = "In"
          }
        },
        nodeData = {
          ["17839516130603187933"] = {
            key = "17839516130603187933",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1394.3636363636363, y = 684.7818181818183},
            propsData = {
              ShowEnable = true,
              MessageId = 304901,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = false,
              IsShowCursor = true,
              HighLightUIPath = "SoloTreasurePermanentMain.Entrance_Illustrated",
              UICompName = "Btn_Area",
              GamePadWidgetName = "",
              IsAutoClick = true,
              IsAutoClickByGamepad = false,
              IsFindByMainUI = false,
              UIShape = "Square",
              IsResetPlayer = false,
              IsForbidInAnim = false,
              IsForbidOutAnim = true,
              UICompSizeOffset = {X = 0, Y = 0},
              UICompLocOffset = {X = 0, Y = 0},
              MessageParentLoc = "HighLightUI",
              MessageLoc = "UpRight",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["17839529888964888529"] = {
            key = "17839529888964888529",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 779.0322583225342, y = 304.83870961787676},
            propsData = {ModeType = 0}
          },
          ["17839529888964888530"] = {
            key = "17839529888964888530",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2173.1354822064204, y = 498.7539046470047},
            propsData = {ModeType = 0}
          },
          ["17839529888964888531"] = {
            key = "17839529888964888531",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17839529888964888532"] = {
            key = "17839529888964888532",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 2215.664784397924, y = 78.43953139301345},
            propsData = {
              ShowEnable = true,
              MessageId = 303804,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = false,
              IsShowCursor = true,
              HighLightUIPath = "AutoChessMain.Anchor:2.Panel_Detail.Controller_Equipment",
              UICompName = "Button_Key",
              GamePadWidgetName = "",
              IsAutoClick = false,
              IsAutoClickByGamepad = false,
              IsFindByMainUI = false,
              UIShape = "Square",
              IsResetPlayer = false,
              IsForbidInAnim = true,
              IsForbidOutAnim = true,
              UICompSizeOffset = {X = 0, Y = 0},
              UICompLocOffset = {X = 0, Y = 0},
              MessageParentLoc = "HighLightUI",
              MessageLoc = "Left",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["17839529888964888533"] = {
            key = "17839529888964888533",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1787.950835253624, y = 485.83144459494815},
            propsData = {
              ShowEnable = true,
              MessageId = 304902,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = false,
              IsShowCursor = true,
              HighLightUIPath = "SoloTreasurePermanentillustrated.Btn_Reward.Btn_Area",
              UICompName = "",
              GamePadWidgetName = "",
              IsAutoClick = false,
              IsAutoClickByGamepad = false,
              IsFindByMainUI = false,
              UIShape = "Square",
              IsResetPlayer = false,
              IsForbidInAnim = true,
              IsForbidOutAnim = false,
              UICompSizeOffset = {X = 0, Y = 0},
              UICompLocOffset = {X = 0, Y = 0},
              MessageParentLoc = "HighLightUI",
              MessageLoc = "UpRight",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["17845474471672121062"] = {
            key = "17845474471672121062",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1061.3636363636363, y = 654},
            propsData = {
              ShowEnable = true,
              MessageId = 304901,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = false,
              IsControlPlayer = false,
              IsTimePause = false,
              IsShowCursor = true,
              HighLightUIPath = "SoloTreasurePermanentMain.Entrance_Illustrated",
              UICompName = "Btn_Area",
              GamePadWidgetName = "",
              IsAutoClick = false,
              IsAutoClickByGamepad = false,
              IsFindByMainUI = false,
              UIShape = "Square",
              IsResetPlayer = false,
              IsForbidInAnim = false,
              IsForbidOutAnim = true,
              UICompSizeOffset = {X = 0, Y = 0},
              UICompLocOffset = {X = 0, Y = 0},
              MessageParentLoc = "HighLightUI",
              MessageLoc = "UpRight",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["17845475129123181834"] = {
            key = "17845475129123181834",
            type = "InputDeviceBranchNode",
            name = "输入设备分支",
            pos = {x = 1156.4805194805194, y = 238.90909090909088},
            propsData = {}
          },
          ["17845475556453182488"] = {
            key = "17845475556453182488",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1536.4805194805192, y = 279.8181818181818},
            propsData = {
              ShowEnable = true,
              MessageId = 304901,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = false,
              IsShowCursor = true,
              HighLightUIPath = "SoloTreasurePermanentMain.Entrance_Illustrated",
              UICompName = "Btn_Area",
              GamePadWidgetName = "",
              IsAutoClick = false,
              IsAutoClickByGamepad = false,
              IsFindByMainUI = false,
              UIShape = "Square",
              IsResetPlayer = false,
              IsForbidInAnim = false,
              IsForbidOutAnim = true,
              UICompSizeOffset = {X = 0, Y = 0},
              UICompLocOffset = {X = 0, Y = 0},
              MessageParentLoc = "HighLightUI",
              MessageLoc = "UpRight",
              MessageLocOffset = {X = 0, Y = 0}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
