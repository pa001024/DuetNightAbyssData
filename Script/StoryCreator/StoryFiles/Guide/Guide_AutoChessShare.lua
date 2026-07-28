return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1783931343905666280",
      startPort = "StoryStart",
      endStory = "1783931343905666282",
      endPort = "In"
    },
    {
      startStory = "1783931343905666282",
      startPort = "Success",
      endStory = "1783931343905666281",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1783931343905666280"] = {
      isStoryNode = true,
      key = "1783931343905666280",
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
    ["1783931343905666281"] = {
      isStoryNode = true,
      key = "1783931343905666281",
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
    ["1783931343905666282"] = {
      isStoryNode = true,
      key = "1783931343905666282",
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
            startQuest = "1783931343905666286",
            startPort = "Out",
            endQuest = "1783931343905666287",
            endPort = "In"
          },
          {
            startQuest = "1783931343905666287",
            startPort = "Out",
            endQuest = "1783931343905666290",
            endPort = "In"
          },
          {
            startQuest = "1783931343905666290",
            startPort = "Out",
            endQuest = "1783931343905666288",
            endPort = "In"
          },
          {
            startQuest = "1783931343905666288",
            startPort = "Out",
            endQuest = "1783931343905666291",
            endPort = "In"
          },
          {
            startQuest = "1783931343905666283",
            startPort = "QuestStart",
            endQuest = "1783931343905666286",
            endPort = "In"
          },
          {
            startQuest = "1783931343905666291",
            startPort = "Out",
            endQuest = "1783931343905666284",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1783931343905666283"] = {
            key = "1783931343905666283",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 779.0322583225342, y = 304.83870961787676},
            propsData = {ModeType = 0}
          },
          ["1783931343905666284"] = {
            key = "1783931343905666284",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2100.364053634992, y = 690.6681903612906},
            propsData = {ModeType = 0}
          },
          ["1783931343905666285"] = {
            key = "1783931343905666285",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2097.857142857143, y = 570.7142857142858},
            propsData = {}
          },
          ["1783931343905666286"] = {
            key = "1783931343905666286",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1296.8571428571431, y = 297.2857142857143},
            propsData = {
              ShowEnable = true,
              MessageId = 304501,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = false,
              IsShowCursor = true,
              HighLightUIPath = "AutoChessMain.Anchor:1.Share",
              UICompName = "Button_Area",
              GamePadWidgetName = "Key_Controller",
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
              MessageLoc = "Left",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["1783931343905666287"] = {
            key = "1783931343905666287",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1712, y = 293.7142857142857},
            propsData = {
              ShowEnable = true,
              MessageId = 304502,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = false,
              IsControlPlayer = false,
              IsTimePause = false,
              IsShowCursor = true,
              HighLightUIPath = "AutoChessShare.Level.Image_807",
              UICompName = "",
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
              MessageLoc = "Right",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["1783931343905666288"] = {
            key = "1783931343905666288",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1004.1899720605043, y = 634.1986735250872},
            propsData = {
              ShowEnable = true,
              MessageId = 304505,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = false,
              IsControlPlayer = false,
              IsTimePause = false,
              IsShowCursor = true,
              HighLightUIPath = "AutoChessShare.Main.BtnShare.Button_Area",
              UICompName = "",
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
          ["1783931343905666289"] = {
            key = "1783931343905666289",
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
          ["1783931343905666290"] = {
            key = "1783931343905666290",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 2192.1901297485515, y = 310.9280061205904},
            propsData = {
              ShowEnable = true,
              MessageId = 304503,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = false,
              IsControlPlayer = false,
              IsTimePause = false,
              IsShowCursor = true,
              HighLightUIPath = "AutoChessShare.Main",
              UICompName = "",
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
              MessageLoc = "Right",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["1783931343905666291"] = {
            key = "1783931343905666291",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1514.1314878601995, y = 604.3143991562002},
            propsData = {
              ShowEnable = true,
              MessageId = 304504,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = false,
              IsControlPlayer = false,
              IsTimePause = false,
              IsShowCursor = true,
              HighLightUIPath = "AutoChessShare.Main.BtnConfirm.Button_Area",
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
              MessageLoc = "Left",
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
