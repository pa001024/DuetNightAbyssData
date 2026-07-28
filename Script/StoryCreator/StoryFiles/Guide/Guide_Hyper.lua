return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17781243437641",
      startPort = "StoryStart",
      endStory = "1778124352663169",
      endPort = "In"
    },
    {
      startStory = "1778124352663169",
      startPort = "Success",
      endStory = "17781243437645",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17781243437641"] = {
      isStoryNode = true,
      key = "17781243437641",
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
    ["17781243437645"] = {
      isStoryNode = true,
      key = "17781243437645",
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
    ["1778124352663169"] = {
      isStoryNode = true,
      key = "1778124352663169",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1558, y = 290},
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
            startQuest = "1778124533108946988",
            startPort = "Out",
            endQuest = "1778125222551948232",
            endPort = "In"
          },
          {
            startQuest = "1778125222551948232",
            startPort = "Out",
            endQuest = "1778134420643949186",
            endPort = "In"
          },
          {
            startQuest = "1778124352663170",
            startPort = "QuestStart",
            endQuest = "1778124533108946988",
            endPort = "In"
          },
          {
            startQuest = "1778134420643949186",
            startPort = "Out",
            endQuest = "1778134590015949655",
            endPort = "In"
          },
          {
            startQuest = "1778134590015949655",
            startPort = "Out",
            endQuest = "1778315970388480702",
            endPort = "In"
          },
          {
            startQuest = "1778315970388480702",
            startPort = "Out",
            endQuest = "1778124352663178",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1778124352663170"] = {
            key = "1778124352663170",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1778124352663178"] = {
            key = "1778124352663178",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1778124352663186"] = {
            key = "1778124352663186",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1778124533108946988"] = {
            key = "1778124533108946988",
            type = "ShowGuideTextNode",
            name = "Text显示信息",
            pos = {x = 1214, y = 156},
            propsData = {
              MessageId = 304101,
              MessageNote = "我们获得了一把灾厄武器。具有独特成长路线与潜能效果的强力武器。",
              IsTimePause = true,
              IsResetPlayer = false,
              IsForbidInAnim = false,
              IsForbidOutAnim = true,
              GuideManPosEnum = "DownLeft",
              GuidemanHead = "Tiejiang_Idle"
            }
          },
          ["1778125222551948232"] = {
            key = "1778125222551948232",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1605.8260869445032, y = 188.17391305549685},
            propsData = {
              ShowEnable = true,
              MessageId = 304102,
              MessageNote = "点击查看近战武器",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "ArmoryMain.Tab_Arm.EMScrollBox_TabItem:2",
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
          ["1778134420643949186"] = {
            key = "1778134420643949186",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1904, y = 224},
            propsData = {
              ShowEnable = true,
              MessageId = 304103,
              MessageNote = "点击只显示灾厄武器",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "ArmoryMain.CheckBox_Incarnon",
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
          ["1778134590015949655"] = {
            key = "1778134590015949655",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1456.1739130554968, y = 577.8260869445031},
            propsData = {
              ShowEnable = true,
              MessageId = 304104,
              MessageNote = "点击灾厄熔炼",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "ArmoryMain.EMListView_SubTab:2",
              UICompName = "TextBlock_Name",
              GamePadWidgetName = "",
              IsAutoClick = false,
              IsAutoClickByGamepad = false,
              IsFindByMainUI = false,
              UIShape = "Square",
              IsResetPlayer = false,
              IsForbidInAnim = true,
              IsForbidOutAnim = true,
              UICompSizeOffset = {X = 75, Y = 30},
              UICompLocOffset = {X = -15, Y = 0},
              MessageParentLoc = "HighLightUI",
              MessageLoc = "Right",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["1778315970388480702"] = {
            key = "1778315970388480702",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1976.363641968334, y = 587.6363649674793},
            propsData = {GuideId = 149}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
