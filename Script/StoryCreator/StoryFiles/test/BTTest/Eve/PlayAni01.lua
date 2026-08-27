return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17665839108691",
      startPort = "StoryStart",
      endStory = "176658391468376",
      endPort = "In"
    },
    {
      startStory = "176658391468376",
      startPort = "Success",
      endStory = "17665839108695",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17665839108691"] = {
      isStoryNode = true,
      key = "17665839108691",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 870, y = 335},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17665839108695"] = {
      isStoryNode = true,
      key = "17665839108695",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1522, y = 318},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["176658391468376"] = {
      isStoryNode = true,
      key = "176658391468376",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1183.9743589743591, y = 319},
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
            startQuest = "17839246958311102423",
            startPort = "Out",
            endQuest = "17839304091566611163",
            endPort = "In"
          },
          {
            startQuest = "17839304091566611163",
            startPort = "Out",
            endQuest = "17839304013006610852",
            endPort = "In"
          },
          {
            startQuest = "17839304013006610852",
            startPort = "Out",
            endQuest = "176658391468385",
            endPort = "Success"
          },
          {
            startQuest = "1766584741457572",
            startPort = "Out",
            endQuest = "17839289973354408970",
            endPort = "In"
          },
          {
            startQuest = "17839289973354408970",
            startPort = "Out",
            endQuest = "17839246958311102423",
            endPort = "In"
          },
          {
            startQuest = "17839327813909916273",
            startPort = "Out",
            endQuest = "17839327872799916488",
            endPort = "In"
          },
          {
            startQuest = "178393287680911018702",
            startPort = "Out",
            endQuest = "176658391468385",
            endPort = "Success"
          },
          {
            startQuest = "17839327872799916488",
            startPort = "Out",
            endQuest = "17839328176249916936",
            endPort = "In"
          },
          {
            startQuest = "17839328176249916936",
            startPort = "Out",
            endQuest = "178393287680911018702",
            endPort = "In"
          },
          {
            startQuest = "176658391468377",
            startPort = "QuestStart",
            endQuest = "1766584741457572",
            endPort = "In"
          }
        },
        nodeData = {
          ["176658391468377"] = {
            key = "176658391468377",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 638, y = 298.5},
            propsData = {ModeType = 0}
          },
          ["176658391468385"] = {
            key = "176658391468385",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2295.25, y = 317.5},
            propsData = {ModeType = 0}
          },
          ["176658391468393"] = {
            key = "176658391468393",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1766584741457572"] = {
            key = "1766584741457572",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1114, y = 306.5},
            propsData = {WaitTime = 1}
          },
          ["1766584750921767"] = {
            key = "1766584750921767",
            type = "SendMessageNode",
            name = "发送消息PlayAni01",
            pos = {x = 2826.434210526316, y = 1242.9736842105262},
            propsData = {
              MessageType = "BehaviorTree",
              MessageContent = "PlayAni01",
              UnitId = 111004
            }
          },
          ["17839246958311102423"] = {
            key = "17839246958311102423",
            type = "ChangeNpcBBKeyNode",
            name = "修改NPC行为树黑板键",
            pos = {x = 1418.2970520087551, y = 137.32384538250318},
            propsData = {
              NpcUnitId = 77000009,
              QuestEventName = "PlayAnimation",
              IsWait = false,
              PostBehaviorEvent = "",
              Animations = {
                "Eve_Story_Squat_Start"
              }
            }
          },
          ["17839285300654407951"] = {
            key = "17839285300654407951",
            type = "ChangeNpcBBKeyNode",
            name = "修改NPC行为树黑板键",
            pos = {x = 2128.017857142857, y = -248.13120870357704},
            propsData = {
              NpcUnitId = 111004,
              QuestEventName = "MoveToPosition",
              IsWait = false,
              PostBehaviorEvent = "",
              MoveToPosEventName = "Location",
              x = 0,
              y = 0,
              z = 0
            }
          },
          ["17839289973354408970"] = {
            key = "17839289973354408970",
            type = "SendMessageNode",
            name = "发送消息PlayAni01",
            pos = {x = 1185.1301759834369, y = 96.11604975878419},
            propsData = {
              MessageType = "BehaviorTree",
              MessageContent = "PlayAnimation",
              UnitId = 77000009
            }
          },
          ["17839304013006610852"] = {
            key = "17839304013006610852",
            type = "ChangeNpcBBKeyNode",
            name = "修改NPC行为树黑板键",
            pos = {x = 1951.3801759834369, y = 179.1160497587842},
            propsData = {
              NpcUnitId = 77000009,
              QuestEventName = "PlayAnimation",
              IsWait = false,
              PostBehaviorEvent = "",
              Animations = {
                "Eve_Story_Squat_End"
              }
            }
          },
          ["17839304091566611163"] = {
            key = "17839304091566611163",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1697.6301759834369, y = 136.6160497587842},
            propsData = {WaitTime = 10}
          },
          ["17839327813909916273"] = {
            key = "17839327813909916273",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1084, y = 654},
            propsData = {WaitTime = 1}
          },
          ["17839327872799916488"] = {
            key = "17839327872799916488",
            type = "SendMessageNode",
            name = "发送消息PlayAni01",
            pos = {x = 1378.2954545454545, y = 667.1818181818181},
            propsData = {
              MessageType = "BehaviorTree",
              MessageContent = "WaitSTL",
              UnitId = 77000009
            }
          },
          ["17839328176249916936"] = {
            key = "17839328176249916936",
            type = "ChangeNpcBBKeyNode",
            name = "修改NPC行为树黑板键",
            pos = {x = 1684.6137931034482, y = 817.301724137931},
            propsData = {
              NpcUnitId = 77000009,
              QuestEventName = "WaitSTL",
              IsWait = true,
              PostBehaviorEvent = "WaitSTL",
              WaitTime = 10
            }
          },
          ["178393287680911018702"] = {
            key = "178393287680911018702",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2074.5155462184875, y = 672.1732492997198},
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
          },
          ["178393364083215423528"] = {
            key = "178393364083215423528",
            type = "ChangeNpcBBKeyNode",
            name = "修改NPC行为树黑板键",
            pos = {x = 1698.6355314419761, y = 649.8891956671432},
            propsData = {
              NpcUnitId = 111004,
              QuestEventName = "PlayAnimation",
              IsWait = false,
              PostBehaviorEvent = "",
              Animations = {
                "Eve_Story_Squat_Start"
              }
            }
          },
          ["178393743488223138433"] = {
            key = "178393743488223138433",
            type = "ChangeNpcBBKeyNode",
            name = "修改NPC行为树黑板键",
            pos = {x = 1098.8683716595247, y = 1370.2909226065804},
            propsData = {
              NpcUnitId = 111004,
              QuestEventName = "MoveToPosition",
              IsWait = false,
              PostBehaviorEvent = "",
              MoveToPosEventName = "Location",
              x = 0,
              y = 0,
              z = 0
            }
          }
        },
        commentData = {
          ["17839327385178814903"] = {
            key = "17839327385178814903",
            name = "playanimation  test",
            position = {x = 1061, y = 18},
            size = {width = 1119, height = 493.5}
          },
          ["178393595212619831753"] = {
            key = "178393595212619831753",
            name = "wait test",
            position = {x = 1046.621432598427, y = 550.3612233858105},
            size = {width = 1524.7058823529412, height = 471.1764705882352}
          }
        }
      }
    }
  },
  commentData = {}
}
