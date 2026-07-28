return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17782283938211",
      startPort = "StoryStart",
      endStory = "1778228403995136",
      endPort = "In"
    },
    {
      startStory = "1778228403995136",
      startPort = "Success",
      endStory = "17782283938215",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17782283938211"] = {
      isStoryNode = true,
      key = "17782283938211",
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
    ["17782283938215"] = {
      isStoryNode = true,
      key = "17782283938215",
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
    ["1778228403995136"] = {
      isStoryNode = true,
      key = "1778228403995136",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1312, y = 240},
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
            startQuest = "1778231208148952987",
            startPort = "Gamepad",
            endQuest = "1778231208148952986",
            endPort = "In"
          },
          {
            startQuest = "1778231208148952987",
            startPort = "Touch",
            endQuest = "1778231208148952984",
            endPort = "In"
          },
          {
            startQuest = "1778231208148952987",
            startPort = "MouseAndKeyboard",
            endQuest = "1778231208148952985",
            endPort = "In"
          },
          {
            startQuest = "1778231214429953155",
            startPort = "Out",
            endQuest = "1778231208148952987",
            endPort = "Input"
          },
          {
            startQuest = "1778231208148952985",
            startPort = "Out",
            endQuest = "17782317149462857735",
            endPort = "In"
          },
          {
            startQuest = "1778231208148952986",
            startPort = "Out",
            endQuest = "17782317149462857735",
            endPort = "In"
          },
          {
            startQuest = "1778231208148952984",
            startPort = "Out",
            endQuest = "17782317149462857735",
            endPort = "In"
          },
          {
            startQuest = "1778228403995137",
            startPort = "QuestStart",
            endQuest = "1778231214429953155",
            endPort = "In"
          },
          {
            startQuest = "17782317149462857735",
            startPort = "Out",
            endQuest = "17782321934663810959",
            endPort = "In"
          },
          {
            startQuest = "17782321934663810959",
            startPort = "Out",
            endQuest = "1778228403996145",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1778228403995137"] = {
            key = "1778228403995137",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1778228403996145"] = {
            key = "1778228403996145",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2456, y = 742},
            propsData = {ModeType = 0}
          },
          ["1778228403996153"] = {
            key = "1778228403996153",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1778231208148952984"] = {
            key = "1778231208148952984",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1947.3405776475604, y = 553.3278657306762},
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
          ["1778231208148952985"] = {
            key = "1778231208148952985",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1956.848063161361, y = 186.6721342693238},
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
          ["1778231208148952986"] = {
            key = "1778231208148952986",
            type = "ShowGuideNode",
            name = "显示引导（支持执行操作后自动关闭/强制引导）",
            pos = {x = 1915.151936838639, y = 410.1625880287574},
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
          ["1778231208148952987"] = {
            key = "1778231208148952987",
            type = "InputDeviceBranchNode",
            name = "输入设备分支",
            pos = {x = 1519.151936838639, y = 392.1625880287574},
            propsData = {}
          },
          ["1778231214429953155"] = {
            key = "1778231214429953155",
            type = "ShowGuideTextNode",
            name = "Text显示信息",
            pos = {x = 1204, y = 444},
            propsData = {
              MessageId = 304301,
              MessageNote = "协会已解锁",
              IsTimePause = true,
              IsResetPlayer = false,
              IsForbidInAnim = false,
              IsForbidOutAnim = true,
              GuideManPosEnum = "DownLeft",
              GuidemanHead = "Bai_Idle"
            }
          },
          ["17782317149462857735"] = {
            key = "17782317149462857735",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 2332, y = 428},
            propsData = {
              ShowEnable = true,
              MessageId = 304302,
              MessageNote = "点击协会",
              DelayTime = 0,
              IsForceClick = true,
              IsControlPlayer = false,
              IsTimePause = true,
              IsShowCursor = true,
              HighLightUIPath = "MenuWorld.Panel_Function:33",
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
          ["17782321934663810959"] = {
            key = "17782321934663810959",
            type = "ShowGuideButtonNode",
            name = "Button显示/隐藏信息",
            pos = {x = 1260, y = 768},
            propsData = {
              ShowEnable = true,
              MessageId = 304303,
              MessageNote = "点击协会",
              DelayTime = 0,
              IsForceClick = false,
              IsControlPlayer = false,
              IsTimePause = false,
              IsShowCursor = true,
              HighLightUIPath = "GuildMain.Anchor:1",
              UICompName = "GuildList",
              GamePadWidgetName = "",
              IsAutoClick = false,
              IsAutoClickByGamepad = false,
              IsFindByMainUI = true,
              UIShape = "Square",
              IsResetPlayer = false,
              IsForbidInAnim = true,
              IsForbidOutAnim = false,
              UICompSizeOffset = {X = 30, Y = 10},
              UICompLocOffset = {X = 0, Y = 0},
              MessageParentLoc = "HighLightUI",
              MessageLoc = "Right",
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
