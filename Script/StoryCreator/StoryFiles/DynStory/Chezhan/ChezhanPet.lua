return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1758263979523833",
      startPort = "StoryStart",
      endStory = "1758263980869889",
      endPort = "In"
    },
    {
      startStory = "1758263980869889",
      startPort = "Success",
      endStory = "1758263979523836",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1758263979523833"] = {
      isStoryNode = true,
      key = "1758263979523833",
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
    ["1758263979523836"] = {
      isStoryNode = true,
      key = "1758263979523836",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1610.9868421052631, y = 287.5657894736842},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1758263980869889"] = {
      isStoryNode = true,
      key = "1758263980869889",
      type = "StoryNode",
      name = "宠物",
      pos = {x = 1211.75, y = 287.5},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "DynQuest_ChezhanPet_Des",
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
            startQuest = "1758264789181353",
            startPort = "Out",
            endQuest = "1758264789181354",
            endPort = "In"
          },
          {
            startQuest = "1758264789181355",
            startPort = "Out",
            endQuest = "1758264789181353",
            endPort = "In"
          },
          {
            startQuest = "1758264789181355",
            startPort = "Out",
            endQuest = "1758264789181351",
            endPort = "In"
          },
          {
            startQuest = "1758264789181354",
            startPort = "Out",
            endQuest = "1758264789181357",
            endPort = "In"
          },
          {
            startQuest = "1758264789181359",
            startPort = "Out",
            endQuest = "1758264789181350",
            endPort = "In"
          },
          {
            startQuest = "1758264789181355",
            startPort = "Out",
            endQuest = "1758264789181360",
            endPort = "In"
          },
          {
            startQuest = "1758264789181354",
            startPort = "Out",
            endQuest = "1758264789181362",
            endPort = "In"
          },
          {
            startQuest = "1758264789181362",
            startPort = "Out",
            endQuest = "1758264789181359",
            endPort = "In"
          },
          {
            startQuest = "1758264789181365",
            startPort = "Out",
            endQuest = "1758264789181355",
            endPort = "In"
          },
          {
            startQuest = "1758264789181364",
            startPort = "Out",
            endQuest = "1758264789181365",
            endPort = "In"
          },
          {
            startQuest = "1758264789181350",
            startPort = "Out",
            endQuest = "1758264789181361",
            endPort = "In"
          },
          {
            startQuest = "1758264789181350",
            startPort = "Out",
            endQuest = "1758264789181363",
            endPort = "In"
          },
          {
            startQuest = "1758264789181363",
            startPort = "Out",
            endQuest = "1758264789181358",
            endPort = "In"
          },
          {
            startQuest = "1758264789181358",
            startPort = "Out",
            endQuest = "1758264789181352",
            endPort = "In"
          },
          {
            startQuest = "1758264789181352",
            startPort = "Out",
            endQuest = "1758263980869893",
            endPort = "Success"
          },
          {
            startQuest = "1758263980869890",
            startPort = "QuestStart",
            endQuest = "1758264789181364",
            endPort = "In"
          }
        },
        nodeData = {
          ["1758263980869890"] = {
            key = "1758263980869890",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1758263980869893"] = {
            key = "1758263980869893",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 4215.454545454545, y = 339.54545454545456},
            propsData = {ModeType = 0}
          },
          ["1758263980869896"] = {
            key = "1758263980869896",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 4114.545454545454, y = 885.4545454545455},
            propsData = {}
          },
          ["1758264789181350"] = {
            key = "1758264789181350",
            type = "KillMonsterNode",
            name = "击杀守卫",
            pos = {x = 3025.6888611388604, y = 320.9007227421703},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 9,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                292480146,
                292480147,
                292480148,
                292480149,
                292480150,
                292480151,
                292480152,
                292480153,
                292480154
              }
            }
          },
          ["1758264789181351"] = {
            key = "1758264789181351",
            type = "TalkNode",
            name = "解救宠物开车",
            pos = {x = 1864.7974691974687, y = 99.13611512756279},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71008701,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1758264789181352"] = {
            key = "1758264789181352",
            type = "DynamicQuestSuccessNode",
            name = "动态任务主动成功",
            pos = {x = 3923.434315684315, y = 328.3208526123002},
            propsData = {
              DialogueId = 0,
              UseTalkFadeOut = false,
              TalkFadeOutTime = 0,
              UseTalkFadeIn = false,
              TalkFadeInTime = 0
            }
          },
          ["1758264789181353"] = {
            key = "1758264789181353",
            type = "ChangeStaticCreatorNode",
            name = "生成守卫",
            pos = {x = 1869.8434065934061, y = 327.39617728762494},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                292480143,
                292480144,
                292480145
              }
            }
          },
          ["1758264789181354"] = {
            key = "1758264789181354",
            type = "KillMonsterNode",
            name = "击杀围绕着宠物的守卫",
            pos = {x = 2172.5570429570425, y = 317.9916318330794},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 3,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                292480143,
                292480144,
                292480145
              }
            }
          },
          ["1758264789181355"] = {
            key = "1758264789181355",
            type = "SendMessageNode",
            name = "锁住宠物",
            pos = {x = 1602.2934065934064, y = 325.80526819671593},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "LockPet",
              UnitId = -1
            }
          },
          ["1758264789181356"] = {
            key = "1758264789181356",
            type = "SendMessageNode",
            name = "解锁宠物",
            pos = {x = 3402.293406593407, y = 678.2552681967157},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "UnlockPet",
              UnitId = -1
            }
          },
          ["1758264789181357"] = {
            key = "1758264789181357",
            type = "TalkNode",
            name = "击杀秽兽开车",
            pos = {x = 2532.6115827155304, y = 583.7727038312562},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71008702,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1758264789181358"] = {
            key = "1758264789181358",
            type = "TalkNode",
            name = "击杀怪物开车",
            pos = {x = 3638.930789824212, y = 320.64608045463285},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71008703,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1758264789181359"] = {
            key = "1758264789181359",
            type = "ChangeStaticCreatorNode",
            name = "生成第二波守卫",
            pos = {x = 2743.256114499536, y = 325.4220544806068},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                292480146,
                292480147,
                292480148,
                292480149,
                292480150,
                292480151,
                292480152,
                292480153,
                292480154
              }
            }
          },
          ["1758264789181360"] = {
            key = "1758264789181360",
            type = "ChangeStaticCreatorNode",
            name = "生成锁定特效",
            pos = {x = 1853.9609226720247, y = 504.86485239028536},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {292480066}
            }
          },
          ["1758264789181361"] = {
            key = "1758264789181361",
            type = "SwitchMechanismStateNode",
            name = "切换机关状态",
            pos = {x = 3374.9609226720245, y = 110.80121602664882},
            propsData = {
              StaticCreatorIdList = {292480066},
              ManualItemIdList = {},
              StateId = 780341,
              QuestId = 0
            }
          },
          ["1758264789181362"] = {
            key = "1758264789181362",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 2475.0735317235312, y = 321.2490002904476},
            propsData = {WaitTime = 2}
          },
          ["1758264789181363"] = {
            key = "1758264789181363",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 3385.0163888663883, y = 335.6918574333048},
            propsData = {WaitTime = 2}
          },
          ["1758264789181364"] = {
            key = "1758264789181364",
            type = "ChangeStaticCreatorNode",
            name = "生成宠物",
            pos = {x = 1064.3888611388606, y = 316.82799546944295},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {292480067}
            }
          },
          ["1758264789181365"] = {
            key = "1758264789181365",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1341.3888611388609, y = 324.82799546944295},
            propsData = {WaitTime = 1}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
