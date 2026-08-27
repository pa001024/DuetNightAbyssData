return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1782376173109592875",
      startPort = "StoryStart",
      endStory = "1782376173109592877",
      endPort = "In"
    },
    {
      startStory = "1782376173109592877",
      startPort = "Success",
      endStory = "1782376173109592876",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1782376173109592875"] = {
      isStoryNode = true,
      key = "1782376173109592875",
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
    ["1782376173109592876"] = {
      isStoryNode = true,
      key = "1782376173109592876",
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
    ["1782376173109592877"] = {
      isStoryNode = true,
      key = "1782376173109592877",
      type = "StoryNode",
      name = "宠物",
      pos = {x = 1211.75, y = 285.5},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "DynQuest_FTOldPet_Des",
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
            startQuest = "1782376173109592884",
            startPort = "Out",
            endQuest = "1782376173109592885",
            endPort = "In"
          },
          {
            startQuest = "1782376173109592886",
            startPort = "Out",
            endQuest = "1782376173109592884",
            endPort = "In"
          },
          {
            startQuest = "1782376173109592886",
            startPort = "Out",
            endQuest = "1782376173109592882",
            endPort = "In"
          },
          {
            startQuest = "1782376173109592885",
            startPort = "Out",
            endQuest = "1782376173109592888",
            endPort = "In"
          },
          {
            startQuest = "1782376173109592890",
            startPort = "Out",
            endQuest = "1782376173109592881",
            endPort = "In"
          },
          {
            startQuest = "1782376173109592886",
            startPort = "Out",
            endQuest = "1782376173109592891",
            endPort = "In"
          },
          {
            startQuest = "1782376173109592885",
            startPort = "Out",
            endQuest = "1782376173109592893",
            endPort = "In"
          },
          {
            startQuest = "1782376173109592893",
            startPort = "Out",
            endQuest = "1782376173109592890",
            endPort = "In"
          },
          {
            startQuest = "1782376173109592896",
            startPort = "Out",
            endQuest = "1782376173109592886",
            endPort = "In"
          },
          {
            startQuest = "1782376173109592895",
            startPort = "Out",
            endQuest = "1782376173109592896",
            endPort = "In"
          },
          {
            startQuest = "1782376173109592881",
            startPort = "Out",
            endQuest = "1782376173109592892",
            endPort = "In"
          },
          {
            startQuest = "1782376173109592881",
            startPort = "Out",
            endQuest = "1782376173109592894",
            endPort = "In"
          },
          {
            startQuest = "1782376173109592894",
            startPort = "Out",
            endQuest = "1782376173109592889",
            endPort = "In"
          },
          {
            startQuest = "1782376173109592889",
            startPort = "Out",
            endQuest = "1782376173109592883",
            endPort = "In"
          },
          {
            startQuest = "1782376173109592883",
            startPort = "Out",
            endQuest = "1782376173109592879",
            endPort = "Success"
          },
          {
            startQuest = "1782376173109592878",
            startPort = "QuestStart",
            endQuest = "1782376173109592895",
            endPort = "In"
          }
        },
        nodeData = {
          ["1782376173109592878"] = {
            key = "1782376173109592878",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1782376173109592879"] = {
            key = "1782376173109592879",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 4215.454545454545, y = 339.54545454545456},
            propsData = {ModeType = 0}
          },
          ["1782376173109592880"] = {
            key = "1782376173109592880",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 4114.545454545454, y = 885.4545454545455},
            propsData = {}
          },
          ["1782376173109592881"] = {
            key = "1782376173109592881",
            type = "KillMonsterNode",
            name = "击杀守卫",
            pos = {x = 3025.6888611388604, y = 317.7428280053282},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 9,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                292790066,
                292790067,
                292790068,
                292790069,
                292790070,
                292790071,
                292790072,
                292790073,
                292790074
              }
            }
          },
          ["1782376173109592882"] = {
            key = "1782376173109592882",
            type = "TalkNode",
            name = "解救宠物开车",
            pos = {x = 1864.7974691974687, y = 99.13611512756279},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71009101,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1782376173109592883"] = {
            key = "1782376173109592883",
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
          ["1782376173109592884"] = {
            key = "1782376173109592884",
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
                292790063,
                292790064,
                292790065
              }
            }
          },
          ["1782376173109592885"] = {
            key = "1782376173109592885",
            type = "KillMonsterNode",
            name = "击杀围绕着宠物的守卫",
            pos = {x = 2172.5570429570425, y = 319.57057920150044},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 3,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                292790063,
                292790064,
                292790065
              }
            }
          },
          ["1782376173109592886"] = {
            key = "1782376173109592886",
            type = "SendMessageNode",
            name = "锁住宠物",
            pos = {x = 1602.2934065934064, y = 325.80526819671593},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "LockPet",
              UnitId = -1
            }
          },
          ["1782376173109592887"] = {
            key = "1782376173109592887",
            type = "SendMessageNode",
            name = "解锁宠物",
            pos = {x = 3402.293406593407, y = 678.2552681967157},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "UnlockPet",
              UnitId = -1
            }
          },
          ["1782376173109592888"] = {
            key = "1782376173109592888",
            type = "TalkNode",
            name = "击杀秽兽开车",
            pos = {x = 2532.6115827155304, y = 583.7727038312562},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71009102,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1782376173109592889"] = {
            key = "1782376173109592889",
            type = "TalkNode",
            name = "击杀怪物开车",
            pos = {x = 3638.930789824212, y = 320.64608045463285},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71009103,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1782376173109592890"] = {
            key = "1782376173109592890",
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
                292790066,
                292790067,
                292790068,
                292790069,
                292790070,
                292790071,
                292790072,
                292790073,
                292790074
              }
            }
          },
          ["1782376173109592891"] = {
            key = "1782376173109592891",
            type = "ChangeStaticCreatorNode",
            name = "生成锁定特效",
            pos = {x = 1853.9609226720247, y = 504.86485239028536},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {292790060}
            }
          },
          ["1782376173109592892"] = {
            key = "1782376173109592892",
            type = "SwitchMechanismStateNode",
            name = "切换机关状态",
            pos = {x = 3374.9609226720245, y = 109.30121602664882},
            propsData = {
              StaticCreatorIdList = {292790060},
              ManualItemIdList = {},
              StateId = 780341,
              QuestId = 0
            }
          },
          ["1782376173109592893"] = {
            key = "1782376173109592893",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 2475.0735317235312, y = 321.2490002904476},
            propsData = {WaitTime = 2}
          },
          ["1782376173109592894"] = {
            key = "1782376173109592894",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 3385.0163888663883, y = 335.6918574333048},
            propsData = {WaitTime = 2}
          },
          ["1782376173109592895"] = {
            key = "1782376173109592895",
            type = "ChangeStaticCreatorNode",
            name = "生成宠物",
            pos = {x = 1064.3888611388606, y = 316.82799546944295},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {292790075}
            }
          },
          ["1782376173109592896"] = {
            key = "1782376173109592896",
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
