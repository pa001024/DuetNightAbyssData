return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17780542653911",
      startPort = "StoryStart",
      endStory = "177805427037293",
      endPort = "In"
    },
    {
      startStory = "177805427037293",
      startPort = "Success",
      endStory = "17780542653925",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17780542653911"] = {
      isStoryNode = true,
      key = "17780542653911",
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
    ["17780542653925"] = {
      isStoryNode = true,
      key = "17780542653925",
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
    ["177805427037293"] = {
      isStoryNode = true,
      key = "177805427037293",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1356, y = 304},
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
            startQuest = "1778054274158281",
            startPort = "Gamepad",
            endQuest = "1778054274158280",
            endPort = "In"
          },
          {
            startQuest = "1778054274158281",
            startPort = "Touch",
            endQuest = "1778054274158277",
            endPort = "In"
          },
          {
            startQuest = "1778054274158281",
            startPort = "MouseAndKeyboard",
            endQuest = "1778054274158278",
            endPort = "In"
          },
          {
            startQuest = "1778054274158278",
            startPort = "Out",
            endQuest = "17780551703012708",
            endPort = "In"
          },
          {
            startQuest = "1778054274158280",
            startPort = "Out",
            endQuest = "17780551703012708",
            endPort = "In"
          },
          {
            startQuest = "1778054274158277",
            startPort = "Out",
            endQuest = "17780551703012708",
            endPort = "In"
          },
          {
            startQuest = "17780543175971121",
            startPort = "Out",
            endQuest = "1778054274158281",
            endPort = "Input"
          },
          {
            startQuest = "17780551703012708",
            startPort = "Out",
            endQuest = "17780644077221067",
            endPort = "In"
          },
          {
            startQuest = "17780644077221067",
            startPort = "Out",
            endQuest = "17780649113096547243",
            endPort = "In"
          },
          {
            startQuest = "17780649113096547243",
            startPort = "Out",
            endQuest = "17780651517028417911",
            endPort = "In"
          },
          {
            startQuest = "17780651517028417911",
            startPort = "Out",
            endQuest = "17780654274799354433",
            endPort = "In"
          },
          {
            startQuest = "177805427037294",
            startPort = "QuestStart",
            endQuest = "17780543175971121",
            endPort = "In"
          },
          {
            startQuest = "17780654274799354433",
            startPort = "Out",
            endQuest = "177831457905622861511",
            endPort = "In"
          },
          {
            startQuest = "177831457905622861511",
            startPort = "Out",
            endQuest = "1778054270372102",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177805427037294"] = {
            key = "177805427037294",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -180, y = 214},
            propsData = {ModeType = 0}
          },
          ["1778054270372102"] = {
            key = "1778054270372102",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1778054270372110"] = {
            key = "1778054270372110",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1778054274158277"] = {
            key = "1778054274158277",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1574.7121664387603, y = 443.32786573067614},
            propsData = {
              ShowEnable = true,
              MessageId = 302905,
              MessageNote = "打开菜单",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = false,
              HighLightUIPath = "BattleMain.Btn_Esc",
              UICompName = "Btn_top",
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
              MessageLoc = "DownRight",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["1778054274158278"] = {
            key = "1778054274158278",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1584.219651952561, y = 76.6721342693238},
            propsData = {
              ShowEnable = true,
              MessageId = 302905,
              MessageNote = "打开菜单",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = false,
              HighLightUIPath = "BattleMain.Btn_Esc",
              UICompName = "Btn_top",
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
              MessageLoc = "DownRight",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["1778054274158280"] = {
            key = "1778054274158280",
            type = "ShowGuideNode",
            name = "显示引导（支持执行操作后自动关闭/强制引导）",
            pos = {x = 1542.5235256298388, y = 300.1625880287574},
            propsData = {
              MessageId = 301611,
              SkillNameList = {"OpenMenu"},
              LastTime = -1,
              bIsForceTouch = true,
              bIsTimeDilation = true,
              HighLightUIPath = "BattleMain.Btn_Esc",
              UICompName = "Btn_top",
              UIShape = "Square",
              IsForbidInAnim = false,
              IsForbidOutAnim = false,
              ForbidSuccessAnim = true,
              IsNotForceRelease = false,
              UICompSizeOffset = {X = 0, Y = 0},
              UICompLocOffset = {X = 0, Y = 0},
              MessageParentLoc = "HighLightUI",
              MessageLoc = "Left",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["1778054274158281"] = {
            key = "1778054274158281",
            type = "InputDeviceBranchNode",
            name = "输入设备分支",
            pos = {x = 1146.5235256298388, y = 282.1625880287574},
            propsData = {}
          },
          ["17780543175971121"] = {
            key = "17780543175971121",
            type = "ShowGuideTextNode",
            name = "Text显示信息",
            pos = {x = 174, y = 236},
            propsData = {
              MessageId = 304001,
              MessageNote = "外观系统解锁，可以在这里管理已拥有的外观部件",
              IsTimePause = true,
              IsResetPlayer = false,
              IsForbidInAnim = false,
              IsForbidOutAnim = true,
              GuideManPosEnum = "DownLeft",
              GuidemanHead = "Bai_Idle"
            }
          },
          ["17780551703012708"] = {
            key = "17780551703012708",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 2158, y = 256},
            propsData = {
              ShowEnable = true,
              MessageId = 304002,
              MessageNote = "点击外观",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "MenuWorld.Panel_Function:34",
              UICompName = "Button_Area",
              GamePadWidgetName = "",
              IsAutoClick = false,
              IsAutoClickByGamepad = false,
              IsFindByMainUI = true,
              UIShape = "Square",
              IsResetPlayer = false,
              IsForbidInAnim = true,
              IsForbidOutAnim = true,
              UICompSizeOffset = {X = 0, Y = 0},
              UICompLocOffset = {X = 0, Y = 0},
              MessageParentLoc = "HighLightUI",
              MessageLoc = "Up",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["17780644077221067"] = {
            key = "17780644077221067",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 360.1961211005435, y = 750.5161251619877},
            propsData = {
              ShowEnable = true,
              MessageId = 304003,
              MessageNote = "这里编辑外观方案",
              DelayTime = 0,
              IsForceClick = false,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "AppearanceMain.Panel_Part:1",
              UICompName = "List_Appearance",
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
          ["17780649113096547243"] = {
            key = "17780649113096547243",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 894.988726414238, y = 786.3372787445679},
            propsData = {
              ShowEnable = true,
              MessageId = 304004,
              MessageNote = "这里导入和导出外观方案",
              DelayTime = 0,
              IsForceClick = false,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "AppearanceMain.Panel_Part:1.Plan_Appearance",
              UICompName = "Btn_Share",
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
          ["17780651517028417911"] = {
            key = "17780651517028417911",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1385.464921619154, y = 919.6706118760652},
            propsData = {
              ShowEnable = true,
              MessageId = 304005,
              MessageNote = "切换页签，可以查看不同类型的外观，包括角色、近战武器、远程武器与坐骑",
              DelayTime = 0,
              IsForceClick = false,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "AppearanceMain.Com_Tab",
              UICompName = "EMScrollBox_TabItem",
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
              MessageLoc = "Down",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["17780654274799354433"] = {
            key = "17780654274799354433",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1956.8935011788258, y = 924.43251851216},
            propsData = {
              ShowEnable = true,
              MessageId = 304006,
              MessageNote = "点击进入外观图鉴",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "AppearanceMain.Panel_Part:1.Entrance_Archive",
              UICompName = "Btn_Area",
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
          },
          ["177831457905622861511"] = {
            key = "177831457905622861511",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 2238, y = 926},
            propsData = {GuideId = 148}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
