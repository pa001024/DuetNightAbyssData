return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17782434274471",
      startPort = "StoryStart",
      endStory = "177824344300985",
      endPort = "In"
    },
    {
      startStory = "177824344300985",
      startPort = "Success",
      endStory = "17782434274475",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17782434274471"] = {
      isStoryNode = true,
      key = "17782434274471",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 930, y = 312},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17782434274475"] = {
      isStoryNode = true,
      key = "17782434274475",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2170, y = 288},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177824344300985"] = {
      isStoryNode = true,
      key = "177824344300985",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1346, y = 312},
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
            startQuest = "1778243767296849",
            startPort = "Out",
            endQuest = "17782444266718572302",
            endPort = "In"
          },
          {
            startQuest = "177824467241412382109",
            startPort = "Out",
            endQuest = "177824344300994",
            endPort = "Success"
          },
          {
            startQuest = "177824344300986",
            startPort = "QuestStart",
            endQuest = "1778243767296849",
            endPort = "In"
          },
          {
            startQuest = "17782444266718572302",
            startPort = "Out",
            endQuest = "177824467241412382109",
            endPort = "In"
          }
        },
        nodeData = {
          ["177824344300986"] = {
            key = "177824344300986",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177824344300994"] = {
            key = "177824344300994",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1778243443009102"] = {
            key = "1778243443009102",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1778243767296849"] = {
            key = "1778243767296849",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1252, y = 326},
            propsData = {
              ShowEnable = true,
              MessageId = 304401,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "GuildMain.Anchor:1.UserActivity",
              UICompName = "Btn_Click",
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
              MessageLoc = "Up",
              MessageLocOffset = {X = 0, Y = 0}
            }
          },
          ["17782444266718572302"] = {
            key = "17782444266718572302",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1608, y = 310},
            propsData = {
              ShowEnable = true,
              MessageId = 304402,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = false,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "GuildReward",
              UICompName = "List_Tab",
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
          ["177824467241412382109"] = {
            key = "177824467241412382109",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1944, y = 334},
            propsData = {
              ShowEnable = true,
              MessageId = 304403,
              MessageNote = "",
              DelayTime = 0,
              IsForceClick = false,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "GuildReward",
              UICompName = "Bar_Progress",
              GamePadWidgetName = "",
              IsAutoClick = false,
              IsAutoClickByGamepad = false,
              IsFindByMainUI = false,
              UIShape = "Square",
              IsResetPlayer = false,
              IsForbidInAnim = true,
              IsForbidOutAnim = false,
              UICompSizeOffset = {X = 100, Y = 150},
              UICompLocOffset = {X = 0, Y = 0},
              MessageParentLoc = "HighLightUI",
              MessageLoc = "Up",
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
