return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17829745566321",
      startPort = "StoryStart",
      endStory = "1782975510808115",
      endPort = "In"
    },
    {
      startStory = "1782975510808115",
      startPort = "Success",
      endStory = "17829745566335",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17829745566321"] = {
      isStoryNode = true,
      key = "17829745566321",
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
    ["17829745566335"] = {
      isStoryNode = true,
      key = "17829745566335",
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
    ["1782975510808115"] = {
      isStoryNode = true,
      key = "1782975510808115",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1484, y = 274},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "DynQuest_Besiege_Des",
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
        bIsDynamicEvent = true,
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
            startQuest = "1782975510808116",
            startPort = "QuestStart",
            endQuest = "1782976976823706",
            endPort = "In"
          },
          {
            startQuest = "17829772858403067",
            startPort = "Out",
            endQuest = "1782975510808124",
            endPort = "Success"
          },
          {
            startQuest = "1782976976823706",
            startPort = "Out",
            endQuest = "1783307025062544",
            endPort = "In"
          },
          {
            startQuest = "17833249370991088040",
            startPort = "Out",
            endQuest = "17833070675661187",
            endPort = "In"
          },
          {
            startQuest = "1783307025062544",
            startPort = "Out",
            endQuest = "17833249370991088040",
            endPort = "In"
          },
          {
            startQuest = "1782976976823706",
            startPort = "Out",
            endQuest = "17830615326795406630",
            endPort = "In"
          },
          {
            startQuest = "17833252785121088568",
            startPort = "Out",
            endQuest = "17830615663685407551",
            endPort = "In"
          },
          {
            startQuest = "17830615663685407551",
            startPort = "Out",
            endQuest = "17829772858403067",
            endPort = "In"
          },
          {
            startQuest = "17833283185173262741",
            startPort = "Out",
            endQuest = "17833283185173262740",
            endPort = "In"
          },
          {
            startQuest = "17833283185173262739",
            startPort = "Out",
            endQuest = "17833283185173262741",
            endPort = "In"
          },
          {
            startQuest = "17833283185173262740",
            startPort = "Out",
            endQuest = "17833252785121088568",
            endPort = "In"
          },
          {
            startQuest = "17833070675661187",
            startPort = "Out",
            endQuest = "17833284398344350274",
            endPort = "In"
          },
          {
            startQuest = "17833284398344350274",
            startPort = "Out",
            endQuest = "17833283185173262739",
            endPort = "In"
          },
          {
            startQuest = "17833283185173262739",
            startPort = "Out",
            endQuest = "17830646891498652733",
            endPort = "In"
          }
        },
        nodeData = {
          ["1782975510808116"] = {
            key = "1782975510808116",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1782975510808124"] = {
            key = "1782975510808124",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3183.75, y = 292.5},
            propsData = {ModeType = 0}
          },
          ["1782975510808132"] = {
            key = "1782975510808132",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3281.25, y = 756.25},
            propsData = {}
          },
          ["1782976976823706"] = {
            key = "1782976976823706",
            type = "ChangeStaticCreatorNode",
            name = "生成巢穴",
            pos = {x = 1240.1493808049536, y = 301.47414860681107},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {292790137, 292790138}
            }
          },
          ["17829772858403067"] = {
            key = "17829772858403067",
            type = "DynamicQuestSuccessNode",
            name = "动态任务主动成功",
            pos = {x = 2678.5176190884094, y = 295.94758169546157},
            propsData = {
              DialogueId = 0,
              UseTalkFadeOut = false,
              TalkFadeOutTime = 0,
              UseTalkFadeIn = false,
              TalkFadeInTime = 0
            }
          },
          ["17830615326795406630"] = {
            key = "17830615326795406630",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1531.7964912280704, y = 113.26081871345023},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71009401,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17830615663685407551"] = {
            key = "17830615663685407551",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2638.261152882206, y = 552.0473684210527},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71009403,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17830646891498652733"] = {
            key = "17830646891498652733",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1776.4834368530016, y = 785.2972739820567},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71009402,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1783307025062544"] = {
            key = "1783307025062544",
            type = "SendMessageNode",
            name = "Gamemode刷怪",
            pos = {x = 1544.8, y = 324.92499999999995},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "NestStart",
              UnitId = -1
            }
          },
          ["17833070675661187"] = {
            key = "17833070675661187",
            type = "SendMessageNode",
            name = "Gamemode结束刷怪",
            pos = {x = 2125.078260869565, y = 314.2641304347825},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "NestEnd",
              UnitId = -1
            }
          },
          ["1783320843063483"] = {
            key = "1783320843063483",
            type = "SwitchMechanismStateNode",
            name = "切换机关状态",
            pos = {x = 1207.7142857142858, y = -156.57142857142856},
            propsData = {
              StaticCreatorIdList = {292790137, 292790138},
              ManualItemIdList = {29279003},
              StateId = 112011,
              QuestId = 0
            }
          },
          ["17833249370991088040"] = {
            key = "17833249370991088040",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 1825.534798534799, y = 313.2698412698413},
            propsData = {
              KillMonsterType = "Nums",
              MonsterNeedNums = 7,
              IsShow = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17833252785121088568"] = {
            key = "17833252785121088568",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = 2336.0506715506713, y = 533.9444444444445},
            propsData = {
              SendMessage = "",
              FinishCondition = "BesiegeEndBack2"
            }
          },
          ["17833283185173262739"] = {
            key = "17833283185173262739",
            type = "SendMessageNode",
            name = "Gamemode刷怪",
            pos = {x = 1417.4953814301646, y = 535.4090732335299},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "NestStart2",
              UnitId = -1
            }
          },
          ["17833283185173262740"] = {
            key = "17833283185173262740",
            type = "SendMessageNode",
            name = "Gamemode结束刷怪",
            pos = {x = 1997.7736422997295, y = 522.6053465254552},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "NestEnd2",
              UnitId = -1
            }
          },
          ["17833283185173262741"] = {
            key = "17833283185173262741",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 1698.2301799649636, y = 523.7539145033711},
            propsData = {
              KillMonsterType = "Nums",
              MonsterNeedNums = 15,
              IsShow = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17833284398344350274"] = {
            key = "17833284398344350274",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = 2373.5972447842023, y = 282.17466157031384},
            propsData = {
              SendMessage = "",
              FinishCondition = "BesiegeEndBack1"
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
