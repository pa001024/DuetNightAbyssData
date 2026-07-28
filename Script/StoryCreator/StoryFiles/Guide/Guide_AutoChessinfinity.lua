return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17839510685752744656",
      startPort = "StoryStart",
      endStory = "17839510685752744658",
      endPort = "In"
    },
    {
      startStory = "17839510685752744658",
      startPort = "Success",
      endStory = "17839510685752744657",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17839510685752744656"] = {
      isStoryNode = true,
      key = "17839510685752744656",
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
    ["17839510685752744657"] = {
      isStoryNode = true,
      key = "17839510685752744657",
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
    ["17839510685752744658"] = {
      isStoryNode = true,
      key = "17839510685752744658",
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
            startQuest = "17839510685752744662",
            startPort = "Out",
            endQuest = "17839510685752744663",
            endPort = "In"
          },
          {
            startQuest = "17839510685752744663",
            startPort = "Out",
            endQuest = "17839510685752744666",
            endPort = "In"
          },
          {
            startQuest = "17839510685752744659",
            startPort = "QuestStart",
            endQuest = "17839510685752744662",
            endPort = "In"
          },
          {
            startQuest = "17839510685752744666",
            startPort = "Out",
            endQuest = "17840982608129545824",
            endPort = "In"
          },
          {
            startQuest = "17840982608129545824",
            startPort = "Out",
            endQuest = "17840982637329545911",
            endPort = "In"
          },
          {
            startQuest = "17840982637329545911",
            startPort = "Out",
            endQuest = "17839510685752744660",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17839510685752744659"] = {
            key = "17839510685752744659",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 779.0322583225342, y = 304.83870961787676},
            propsData = {ModeType = 0}
          },
          ["17839510685752744660"] = {
            key = "17839510685752744660",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1651.9414792079197, y = 921.168297450603},
            propsData = {ModeType = 0}
          },
          ["17839510685752744661"] = {
            key = "17839510685752744661",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17839510685752744662"] = {
            key = "17839510685752744662",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1520, y = 308},
            propsData = {
              ShowEnable = true,
              MessageId = 304801,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = false,
              IsShowCursor = true,
              HighLightUIPath = "AutoChessMain.Anchor:1.LevelSelect.Btn_Random",
              UICompName = "",
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
              MessageLoc = "Left",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["17839510685752744663"] = {
            key = "17839510685752744663",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1850, y = 298},
            propsData = {
              ShowEnable = true,
              MessageId = 304802,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = false,
              IsControlPlayer = false,
              IsTimePause = false,
              IsShowCursor = true,
              HighLightUIPath = "AutoChessMain.Anchor:2.Level.BtnRe01.BtnArea",
              UICompName = "",
              GamePadWidgetName = "",
              IsAutoClick = false,
              IsAutoClickByGamepad = false,
              IsFindByMainUI = false,
              UIShape = "Square",
              IsResetPlayer = false,
              IsForbidInAnim = false,
              IsForbidOutAnim = false,
              UICompSizeOffset = {X = 0, Y = 0},
              UICompLocOffset = {X = 0, Y = 0},
              MessageParentLoc = "HighLightUI",
              MessageLoc = "Left",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["17839510685752744665"] = {
            key = "17839510685752744665",
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
          ["17839510685752744666"] = {
            key = "17839510685752744666",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 2164.304072777037, y = 351.22785619555293},
            propsData = {
              ShowEnable = true,
              MessageId = 304803,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = false,
              IsControlPlayer = false,
              IsTimePause = false,
              IsShowCursor = true,
              HighLightUIPath = "AutoChessMain.Anchor:2.Level.EMRichTextBlock_74",
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
          ["17840982608129545824"] = {
            key = "17840982608129545824",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 919.0160183066362, y = 875.5469107551488},
            propsData = {
              ShowEnable = true,
              MessageId = 304804,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = false,
              IsControlPlayer = false,
              IsTimePause = false,
              IsShowCursor = true,
              HighLightUIPath = "AutoChessMain.Anchor:2.Level.BtnRe02.BtnArea",
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
          ["17840982637329545911"] = {
            key = "17840982637329545911",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1224.233409610984, y = 929.0251716247142},
            propsData = {
              ShowEnable = true,
              MessageId = 304805,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = false,
              IsShowCursor = true,
              HighLightUIPath = "AutoChessMain.Tab.Panel_Back:1.Btn_Back",
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
              MessageLoc = "DownRight",
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
