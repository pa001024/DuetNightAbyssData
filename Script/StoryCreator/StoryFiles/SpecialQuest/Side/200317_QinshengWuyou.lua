return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17730566197758379121",
      startPort = "StoryStart",
      endStory = "17730566204228379139",
      endPort = "In"
    },
    {
      startStory = "17730566204228379139",
      startPort = "Success",
      endStory = "17730566197768379124",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17730566197758379121"] = {
      isStoryNode = true,
      key = "17730566197758379121",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1316.9230769230771, y = 286.15384615384613},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17730566197768379124"] = {
      isStoryNode = true,
      key = "17730566197768379124",
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
    ["17730566204228379139"] = {
      isStoryNode = true,
      key = "17730566204228379139",
      type = "StoryNode",
      name = "跟随无由生",
      pos = {x = 1796, y = 338},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_20031709_01",
        QuestDeatil = "Content_20031709_01",
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
        SubRegionId = 104504,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_WUyouQinsheng01",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17730566204248379144",
            startPort = "QuestStart",
            endQuest = "17730566438238379933",
            endPort = "In"
          },
          {
            startQuest = "17730566438238379933",
            startPort = "Out",
            endQuest = "17730566204248379146",
            endPort = "Fail"
          },
          {
            startQuest = "17739884963495699",
            startPort = "Out",
            endQuest = "17730566204248379148",
            endPort = "In"
          },
          {
            startQuest = "17730566204248379148",
            startPort = "Out",
            endQuest = "17739885150306090",
            endPort = "In"
          },
          {
            startQuest = "17739885150306090",
            startPort = "Out",
            endQuest = "17730566204248379152",
            endPort = "In"
          },
          {
            startQuest = "17730566204248379152",
            startPort = "Out",
            endQuest = "17739885150306091",
            endPort = "In"
          },
          {
            startQuest = "17739885150306091",
            startPort = "Out",
            endQuest = "17730566204248379153",
            endPort = "In"
          },
          {
            startQuest = "17730566204248379153",
            startPort = "Out",
            endQuest = "17730566351758379723",
            endPort = "In"
          },
          {
            startQuest = "17730566204248379144",
            startPort = "QuestStart",
            endQuest = "1778840236349632",
            endPort = "In"
          },
          {
            startQuest = "1778840236349632",
            startPort = "Fail",
            endQuest = "17739884963495699",
            endPort = "In"
          },
          {
            startQuest = "1778840236349632",
            startPort = "Fail",
            endQuest = "17730566204248379147",
            endPort = "In"
          },
          {
            startQuest = "1778840236349632",
            startPort = "Success",
            endQuest = "17730566351758379723",
            endPort = "In"
          }
        },
        nodeData = {
          ["17730566204248379144"] = {
            key = "17730566204248379144",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 651.7368421052631, y = 484.7631578947368},
            propsData = {ModeType = 0}
          },
          ["17730566204248379145"] = {
            key = "17730566204248379145",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2218.842105263158, y = 774.8947368421052},
            propsData = {ModeType = 0}
          },
          ["17730566204248379146"] = {
            key = "17730566204248379146",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1679.6842105263158, y = 983.8345864661655},
            propsData = {}
          },
          ["17730566204248379147"] = {
            key = "17730566204248379147",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1154, y = -45.5},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "200317TraceStart",
              UnitId = -1
            }
          },
          ["17730566204248379148"] = {
            key = "17730566204248379148",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 1639.1148614289352, y = 434.77676074243556},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 2420166,
              StateId = 1210321,
              IsGuideEnable = true,
              GuidePointName = "BP_WUyouQinsheng01"
            }
          },
          ["17730566204248379152"] = {
            key = "17730566204248379152",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 2202.17041698449, y = 433.3323162979912},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 2420162,
              StateId = 1210321,
              IsGuideEnable = true,
              GuidePointName = "BP_BP_WUyouQinsheng02"
            }
          },
          ["17730566204248379153"] = {
            key = "17730566204248379153",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 2847.606924920998, y = 472.8005702662451},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 2420163,
              StateId = 1210321,
              IsGuideEnable = true,
              GuidePointName = "BP_WUyouQinsheng03"
            }
          },
          ["17730566351758379723"] = {
            key = "17730566351758379723",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 1822.0952380952376, y = 588.1309523809524},
            propsData = {}
          },
          ["17730566438238379933"] = {
            key = "17730566438238379933",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1280.2142857142858, y = 940.5},
            propsData = {}
          },
          ["17739884963495699"] = {
            key = "17739884963495699",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 1330.359683794467, y = 428.3349802371542},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 2420166,
              StateId = 1210320,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["17739885150306090"] = {
            key = "17739885150306090",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 1930.72113997114, y = 423.6370851370851},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 2420162,
              StateId = 1210320,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["17739885150306091"] = {
            key = "17739885150306091",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 2494.4909812409815, y = 451.4386724386722},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 2420163,
              StateId = 1210320,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["1778840236349632"] = {
            key = "1778840236349632",
            type = "ConditionNode",
            name = "条件节点",
            pos = {x = 857.4057971014495, y = 415.2147215865752},
            propsData = {ConditionId = 7072038}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
