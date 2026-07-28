return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17782108266731",
      startPort = "StoryStart",
      endStory = "1778210834532115",
      endPort = "In"
    },
    {
      startStory = "1778210834532115",
      startPort = "Success",
      endStory = "17782108266735",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17782108266731"] = {
      isStoryNode = true,
      key = "17782108266731",
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
    ["17782108266735"] = {
      isStoryNode = true,
      key = "17782108266735",
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
    ["1778210834532115"] = {
      isStoryNode = true,
      key = "1778210834532115",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1570, y = 370},
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
            startQuest = "1778211353857952031",
            startPort = "Out",
            endQuest = "1778211353857952032",
            endPort = "In"
          },
          {
            startQuest = "1778211353857952033",
            startPort = "Gamepad",
            endQuest = "1778211353857952034",
            endPort = "In"
          },
          {
            startQuest = "1778211353857952034",
            startPort = "Out",
            endQuest = "1778211353857952035",
            endPort = "In"
          },
          {
            startQuest = "1778211353857952033",
            startPort = "MouseAndKeyboard",
            endQuest = "1778211353857952031",
            endPort = "In"
          },
          {
            startQuest = "1778211353857952035",
            startPort = "Out",
            endQuest = "1778211353857952032",
            endPort = "In"
          },
          {
            startQuest = "1778211224235951425",
            startPort = "Out",
            endQuest = "1778211353857952033",
            endPort = "Input"
          },
          {
            startQuest = "1778211353857952033",
            startPort = "Touch",
            endQuest = "1778211363537952364",
            endPort = "In"
          },
          {
            startQuest = "1778211363537952364",
            startPort = "Out",
            endQuest = "1778211353857952036",
            endPort = "In"
          },
          {
            startQuest = "17782118162251905119",
            startPort = "Out",
            endQuest = "177822318297022828955",
            endPort = "In"
          },
          {
            startQuest = "177822318297022828955",
            startPort = "Out",
            endQuest = "177822162975911415343",
            endPort = "In"
          },
          {
            startQuest = "1778211353857952032",
            startPort = "Out",
            endQuest = "17782118162251905119",
            endPort = "In"
          },
          {
            startQuest = "1778211353857952036",
            startPort = "Out",
            endQuest = "17782118162251905119",
            endPort = "In"
          },
          {
            startQuest = "177822162975911415343",
            startPort = "Out",
            endQuest = "177822367523325683558",
            endPort = "In"
          },
          {
            startQuest = "177822367523325683558",
            startPort = "Out",
            endQuest = "177822564215039949869",
            endPort = "In"
          },
          {
            startQuest = "177822592386240901787",
            startPort = "Out",
            endQuest = "177822597709541853537",
            endPort = "In"
          },
          {
            startQuest = "1778210834532116",
            startPort = "QuestStart",
            endQuest = "1778211224235951425",
            endPort = "In"
          },
          {
            startQuest = "177822597709541853537",
            startPort = "Out",
            endQuest = "177822631740445659009",
            endPort = "In"
          },
          {
            startQuest = "177822564215039949869",
            startPort = "Out",
            endQuest = "17804670797261483",
            endPort = "In"
          },
          {
            startQuest = "17804670797261483",
            startPort = "Out",
            endQuest = "1778210834533124",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1778210834532116"] = {
            key = "1778210834532116",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 564, y = 346},
            propsData = {ModeType = 0}
          },
          ["1778210834533124"] = {
            key = "1778210834533124",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3040.4516103627407, y = 784.1290271373991},
            propsData = {ModeType = 0}
          },
          ["1778210834533132"] = {
            key = "1778210834533132",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3006.4516103627407, y = 1116.1290271373991},
            propsData = {}
          },
          ["1778211224235951425"] = {
            key = "1778211224235951425",
            type = "ShowGuideTextNode",
            name = "Text显示信息",
            pos = {x = 926, y = 368},
            propsData = {
              MessageId = 304201,
              MessageNote = "",
              IsTimePause = true,
              IsResetPlayer = false,
              IsForbidInAnim = false,
              IsForbidOutAnim = true,
              GuideManPosEnum = "DownLeft",
              GuidemanHead = "Bai_Idle"
            }
          },
          ["1778211353857952031"] = {
            key = "1778211353857952031",
            type = "ShowGuideButtonNode",
            name = "区域右上角UI",
            pos = {x = 1737.1926404867843, y = 171.28571429868953},
            propsData = {
              ShowEnable = true,
              MessageId = 304202,
              MessageNote = "点击“玩法”进入委托系统。",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = false,
              HighLightUIPath = "BattleMain.ListView:8",
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
              MessageLoc = "DownLeft",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["1778211353857952032"] = {
            key = "1778211353857952032",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 2101.6710495315665, y = 346.45348371484954},
            propsData = {
              ShowEnable = true,
              MessageId = 304203,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "StyleOfPlay.ComTab.EMScrollBox_TabItem:2",
              UICompName = "Btn",
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
          ["1778211353857952033"] = {
            key = "1778211353857952033",
            type = "InputDeviceBranchNode",
            name = "输入设备分支",
            pos = {x = 1278.3289504684335, y = 360.6674979701769},
            propsData = {}
          },
          ["1778211353857952034"] = {
            key = "1778211353857952034",
            type = "ShowGuideNode",
            name = "显示引导（支持执行操作后自动关闭/强制引导）",
            pos = {x = 1523.1462208488492, y = 403.8751964877231},
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
          ["1778211353857952035"] = {
            key = "1778211353857952035",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1741.4600785158993, y = 412.6490152215449},
            propsData = {
              ShowEnable = true,
              MessageId = 304202,
              MessageNote = "点击<H>“整备”</>进入整备系统。",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = false,
              HighLightUIPath = "MenuWorld.Panel_Function:8",
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
              MessageLoc = "Right",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["1778211353857952036"] = {
            key = "1778211353857952036",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 2069.4783546946474, y = 580.7142857013105},
            propsData = {
              ShowEnable = true,
              MessageId = 304203,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "StyleOfPlay.ComTab.EMScrollBox_TabItem:2",
              UICompName = "Btn",
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
          ["1778211363537952364"] = {
            key = "1778211363537952364",
            type = "ShowGuideButtonNode",
            name = "区域右上角UI",
            pos = {x = 1684, y = 614},
            propsData = {
              ShowEnable = true,
              MessageId = 304202,
              MessageNote = "点击“玩法”进入委托系统。",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = false,
              HighLightUIPath = "BattleMain.ListView:8",
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
              MessageLoc = "DownLeft",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["17782118162251905119"] = {
            key = "17782118162251905119",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 2435.096774352329, y = 466.8387102331505},
            propsData = {
              ShowEnable = true,
              MessageId = 304204,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "StyleOfPlay.Group_Depute:1.PanelRoot:1.Iron_SwitchTab",
              UICompName = "Btn_Click",
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
              MessageLoc = "Up",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["177822162975911415343"] = {
            key = "177822162975911415343",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1215.1612873057545, y = 915.2258045660966},
            propsData = {
              ShowEnable = true,
              MessageId = 304205,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "StyleOfPlay.Group_Depute:1.PanelRoot:1.List_IronExp:1",
              UICompName = "Btn_Click",
              GamePadWidgetName = "",
              IsAutoClick = true,
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
          ["177822318297022828955"] = {
            key = "177822318297022828955",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 874.7061816196789, y = 922.8317246771941},
            propsData = {
              ShowEnable = true,
              MessageId = 304205,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = false,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "StyleOfPlay.Group_Depute:1.PanelRoot:1.List_IronExp:1",
              UICompName = "Btn_Click",
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
          ["177822367523325683558"] = {
            key = "177822367523325683558",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1614.4677433052814, y = 955.0897887963723},
            propsData = {
              ShowEnable = true,
              MessageId = 304206,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = false,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "StyleOfPlay.Group_Root:4.IronExp_TitleItem",
              UICompName = "Btn_Click",
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
          ["177822564215039949869"] = {
            key = "177822564215039949869",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1918.745436706874, y = 977.3093903522903},
            propsData = {
              ShowEnable = true,
              MessageId = 304207,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = false,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "StyleOfPlay.Group_Root:4.Button_IronExp",
              UICompName = "Button_Area",
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
              MessageLoc = "Up",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["177822592386240901787"] = {
            key = "177822592386240901787",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1608.745450630914, y = 1202.9615600632947},
            propsData = {
              ShowEnable = true,
              MessageId = 304208,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "StyleOfPlay.Group_Root:4.Button_IronExp",
              UICompName = "Button_Area",
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
              MessageLoc = "Up",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["177822597709541853537"] = {
            key = "177822597709541853537",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 888.3106484013715, y = 1306.3156033851888},
            propsData = {
              ShowEnable = true,
              MessageId = 304209,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = false,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "IronExpPopup.List_Item:1",
              UICompName = "Node_Widget",
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
          ["177822631740445659009"] = {
            key = "177822631740445659009",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1599.1802175488388, y = 1349.793864495126},
            propsData = {
              ShowEnable = true,
              MessageId = 304210,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = false,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "IronExpPopup",
              UICompName = "List_Reward",
              GamePadWidgetName = "",
              IsAutoClick = false,
              IsAutoClickByGamepad = false,
              IsFindByMainUI = false,
              UIShape = "Square",
              IsResetPlayer = false,
              IsForbidInAnim = true,
              IsForbidOutAnim = false,
              UICompSizeOffset = {X = 0, Y = 150},
              UICompLocOffset = {X = 0, Y = 0},
              MessageParentLoc = "HighLightUI",
              MessageLoc = "Right",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["17804670797261483"] = {
            key = "17804670797261483",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 2257.1428639158908, y = 976.2857091216003},
            propsData = {GuideId = 150}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
