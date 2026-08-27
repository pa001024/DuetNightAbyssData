return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17665811088113896108",
      startPort = "StoryStart",
      endStory = "17665811181793896283",
      endPort = "In"
    },
    {
      startStory = "17665811181793896283",
      startPort = "Success",
      endStory = "17665811088113896111",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17665811088113896108"] = {
      isStoryNode = true,
      key = "17665811088113896108",
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
    ["17665811088113896111"] = {
      isStoryNode = true,
      key = "17665811088113896111",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1620, y = 312},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17665811181793896283"] = {
      isStoryNode = true,
      key = "17665811181793896283",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1196, y = 280},
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
            startQuest = "17827326356378081679",
            startPort = "Out",
            endQuest = "17827327428239157374",
            endPort = "In"
          },
          {
            startQuest = "17827327428239157374",
            startPort = "Out",
            endQuest = "17665811181793896287",
            endPort = "Success"
          },
          {
            startQuest = "17665811181793896284",
            startPort = "QuestStart",
            endQuest = "17665823361924605412",
            endPort = "In"
          },
          {
            startQuest = "17665823361924605412",
            startPort = "Out",
            endQuest = "17665812163323896986",
            endPort = "In"
          },
          {
            startQuest = "17665812163323896986",
            startPort = "Out",
            endQuest = "17827326356378081679",
            endPort = "In"
          }
        },
        nodeData = {
          ["17665811181793896284"] = {
            key = "17665811181793896284",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 810.0175438596491, y = 433.5964912280702},
            propsData = {ModeType = 0}
          },
          ["17665811181793896287"] = {
            key = "17665811181793896287",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2352.8596491228072, y = 424.52631578947376},
            propsData = {ModeType = 0}
          },
          ["17665811181793896290"] = {
            key = "17665811181793896290",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17665812163323896986"] = {
            key = "17665812163323896986",
            type = "SendMessageNode",
            name = "发送消息Moveto1",
            pos = {x = 1404.7419354838707, y = 248.9677419354839},
            propsData = {
              MessageType = "BehaviorTree",
              MessageContent = "MoveToPosition",
              UnitId = 77000009
            }
          },
          ["17665823361924605412"] = {
            key = "17665823361924605412",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1110.3859649122805, y = 370.57894736842104},
            propsData = {WaitTime = 1}
          },
          ["17827326356378081679"] = {
            key = "17827326356378081679",
            type = "ChangeNpcBBKeyNode",
            name = "修改NPC行为树黑板键",
            pos = {x = 1742.3760504201678, y = 299.9368089341},
            propsData = {
              NpcUnitId = 77000009,
              QuestEventName = "MoveToPosition",
              IsWait = true,
              PostBehaviorEvent = "MoveToPosition",
              MoveToPosEventName = "Location",
              x = -944.818359,
              y = -14080.469727,
              z = -1013.364258
            }
          },
          ["17827327428239157374"] = {
            key = "17827327428239157374",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2030.770806380403, y = 304.4304045857606},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11117601,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
