return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17829765374393243173",
      startPort = "StoryStart",
      endStory = "17829765401833243258",
      endPort = "In"
    },
    {
      startStory = "17829765401833243258",
      startPort = "Success",
      endStory = "1782983594394771",
      endPort = "In"
    },
    {
      startStory = "1782983594394771",
      startPort = "Success",
      endStory = "1782983596684853",
      endPort = "In"
    },
    {
      startStory = "1782983596684853",
      startPort = "Success",
      endStory = "1782983598456938",
      endPort = "In"
    },
    {
      startStory = "1782983598456938",
      startPort = "Success",
      endStory = "17829765374393243176",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17829765374393243173"] = {
      isStoryNode = true,
      key = "17829765374393243173",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 120702},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17829765374393243176"] = {
      isStoryNode = true,
      key = "17829765374393243176",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2200.7368421052633, y = 293.7631578947368},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17829765401833243258"] = {
      isStoryNode = true,
      key = "17829765401833243258",
      type = "StoryNode",
      name = "冰湖城",
      pos = {x = 1079.4225545252712, y = 270.5889382264595},
      propsData = {
        QuestId = 12070201,
        QuestDescriptionComment = "冰湖城调查名单家庭",
        QuestDescription = "Description_120702_1",
        QuestDeatil = "Content_120702_1",
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
        SubRegionId = 101101,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestTrigger_351192082",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17870611535315056947",
            startPort = "Out",
            endQuest = "17829803988194865234",
            endPort = "In"
          },
          {
            startQuest = "17829765401833243259",
            startPort = "QuestStart",
            endQuest = "17870611535315056947",
            endPort = "In"
          },
          {
            startQuest = "17829803988194865234",
            startPort = "Success",
            endQuest = "17829765401833243262",
            endPort = "Success"
          },
          {
            startQuest = "17902333599755163110",
            startPort = "Out",
            endQuest = "17902333510405163014",
            endPort = "In"
          },
          {
            startQuest = "17829803988194865234",
            startPort = "Fail",
            endQuest = "17902333599755163110",
            endPort = "In"
          },
          {
            startQuest = "17829803988194865234",
            startPort = "PassiveFail",
            endQuest = "17902333599755163110",
            endPort = "In"
          },
          {
            startQuest = "17902333510405163014",
            startPort = "Out",
            endQuest = "17829765401833243265",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17829765401833243259"] = {
            key = "17829765401833243259",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 870.5272727272727, y = 251.1818181818182},
            propsData = {ModeType = 0}
          },
          ["17829765401833243262"] = {
            key = "17829765401833243262",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1810.7183212040793, y = 232.69063970085642},
            propsData = {ModeType = 0}
          },
          ["17829765401833243265"] = {
            key = "17829765401833243265",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1820.9768427307126, y = 728.9916949235835},
            propsData = {}
          },
          ["17829803988194865234"] = {
            key = "17829803988194865234",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务201",
            pos = {x = 1468.1938000080415, y = 250.6395199228016},
            propsData = {SpecialConfigId = 12070201, BlackScreenImmediately = true}
          },
          ["17870611535315056947"] = {
            key = "17870611535315056947",
            type = "GoToNode",
            name = "前往冰湖城雾区",
            pos = {x = 1184.7072896144105, y = 253.60170479675116},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351192082,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351192082"
            }
          },
          ["17902333510405163014"] = {
            key = "17902333510405163014",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 1815.6825396825398, y = 562.3174603174602},
            propsData = {}
          },
          ["17902333599755163110"] = {
            key = "17902333599755163110",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1813.4603174603176, y = 381.2063492063491},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_CityRestart_1207",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["1782983594394771"] = {
      isStoryNode = true,
      key = "1782983594394771",
      type = "StoryNode",
      name = "百花车站",
      pos = {x = 1360.5767226743164, y = 271.1578947368421},
      propsData = {
        QuestId = 12070202,
        QuestDescriptionComment = "百花车站找沃伦弟弟",
        QuestDescription = "Description_120702_2",
        QuestDeatil = "Content_120702_2",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestTrigger_352480703",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17870613674935059694",
            startPort = "Out",
            endQuest = "1782983594394780",
            endPort = "In"
          },
          {
            startQuest = "1782983594394776",
            startPort = "QuestStart",
            endQuest = "17870613674935059694",
            endPort = "In"
          },
          {
            startQuest = "1782983594394780",
            startPort = "Success",
            endQuest = "1782983594394777",
            endPort = "Success"
          },
          {
            startQuest = "17902336984978599293",
            startPort = "Out",
            endQuest = "17902336932908599215",
            endPort = "In"
          },
          {
            startQuest = "1782983594394780",
            startPort = "Fail",
            endQuest = "17902336984978599293",
            endPort = "In"
          },
          {
            startQuest = "1782983594394780",
            startPort = "PassiveFail",
            endQuest = "17902336984978599293",
            endPort = "In"
          },
          {
            startQuest = "17902336932908599215",
            startPort = "Out",
            endQuest = "1782983594394778",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["1782983594394776"] = {
            key = "1782983594394776",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 855.1818181818181, y = 253.7272727272727},
            propsData = {ModeType = 0}
          },
          ["1782983594394777"] = {
            key = "1782983594394777",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1778.8421052631575, y = 244.2535885167464},
            propsData = {ModeType = 0}
          },
          ["1782983594394778"] = {
            key = "1782983594394778",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1779.5933014354068, y = 712.7033492822968},
            propsData = {}
          },
          ["1782983594394780"] = {
            key = "1782983594394780",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务202",
            pos = {x = 1434.3397129186603, y = 251.68421052631578},
            propsData = {SpecialConfigId = 12070202, BlackScreenImmediately = true}
          },
          ["17870613674935059694"] = {
            key = "17870613674935059694",
            type = "GoToNode",
            name = "前往车站精确框",
            pos = {x = 1154.4545454545455, y = 258.45454545454544},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 352480703,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_352480703"
            }
          },
          ["17902336932908599215"] = {
            key = "17902336932908599215",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 1776.6363636363637, y = 568.4545454545456},
            propsData = {}
          },
          ["17902336984978599293"] = {
            key = "17902336984978599293",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1777.0909090909092, y = 391.18181818181824},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_Station_1207",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["1782983596684853"] = {
      isStoryNode = true,
      key = "1782983596684853",
      type = "StoryNode",
      name = "地下工厂",
      pos = {x = 1638.8157894736842, y = 270.2105263157894},
      propsData = {
        QuestId = 12070203,
        QuestDescriptionComment = "工厂找道吉打催债人",
        QuestDescription = "Description_120702_3",
        QuestDeatil = "Content_120702_3",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestTrigger_352890222",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17870623927255062118",
            startPort = "Out",
            endQuest = "1782983596684862",
            endPort = "In"
          },
          {
            startQuest = "1782983596684858",
            startPort = "QuestStart",
            endQuest = "17870623927255062118",
            endPort = "In"
          },
          {
            startQuest = "1782983596684862",
            startPort = "Success",
            endQuest = "1782983596684859",
            endPort = "Success"
          },
          {
            startQuest = "1782983596684862",
            startPort = "Fail",
            endQuest = "17902344151708601321",
            endPort = "In"
          },
          {
            startQuest = "1782983596684862",
            startPort = "PassiveFail",
            endQuest = "17902344151708601321",
            endPort = "In"
          },
          {
            startQuest = "17902344151708601321",
            startPort = "Out",
            endQuest = "17902349644898602608",
            endPort = "In"
          },
          {
            startQuest = "17902349644898602608",
            startPort = "Out",
            endQuest = "1782983596684860",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["1782983596684858"] = {
            key = "1782983596684858",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 953.6153846153846, y = 269.53846153846155},
            propsData = {ModeType = 0}
          },
          ["1782983596684859"] = {
            key = "1782983596684859",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1836.5253220463742, y = 237.19274935590713},
            propsData = {ModeType = 0}
          },
          ["1782983596684860"] = {
            key = "1782983596684860",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1846.5191755612807, y = 670.4145380934854},
            propsData = {}
          },
          ["1782983596684862"] = {
            key = "1782983596684862",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务203",
            pos = {x = 1532.657894736842, y = 265.1842105263158},
            propsData = {SpecialConfigId = 12070203, BlackScreenImmediately = true}
          },
          ["17870623927255062118"] = {
            key = "17870623927255062118",
            type = "GoToNode",
            name = "前往工厂精确框",
            pos = {x = 1277.6818181818182, y = 273.77272727272725},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 352890222,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_352890222"
            }
          },
          ["17902344151708601321"] = {
            key = "17902344151708601321",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1833.1999999999998, y = 374},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_QianruStart",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17902349644898602608"] = {
            key = "17902349644898602608",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 1840.4360617452726, y = 535.836403508772},
            propsData = {}
          }
        },
        commentData = {}
      }
    },
    ["1782983598456938"] = {
      isStoryNode = true,
      key = "1782983598456938",
      type = "StoryNode",
      name = "冰湖城",
      pos = {x = 1924.2959000064263, y = 271.6723259762309},
      propsData = {
        QuestId = 12070204,
        QuestDescriptionComment = "回冰湖城播过场",
        QuestDescription = "Description_120702_4",
        QuestDeatil = "Content_120702_4",
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
        SubRegionId = 101101,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestTrigger_351192086",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17870624910595064503",
            startPort = "Out",
            endQuest = "1782983598456947",
            endPort = "In"
          },
          {
            startQuest = "1782983598456943",
            startPort = "QuestStart",
            endQuest = "17870624910595064503",
            endPort = "In"
          },
          {
            startQuest = "1782983598456947",
            startPort = "Success",
            endQuest = "1782983598456944",
            endPort = "Success"
          },
          {
            startQuest = "17902335805426881526",
            startPort = "Out",
            endQuest = "17902335738826881389",
            endPort = "In"
          },
          {
            startQuest = "17902335738826881389",
            startPort = "Out",
            endQuest = "1782983598456945",
            endPort = "Fail"
          },
          {
            startQuest = "1782983598456947",
            startPort = "Fail",
            endQuest = "17902335805426881526",
            endPort = "In"
          },
          {
            startQuest = "1782983598456947",
            startPort = "PassiveFail",
            endQuest = "17902335805426881526",
            endPort = "In"
          }
        },
        nodeData = {
          ["1782983598456943"] = {
            key = "1782983598456943",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 793.7662337662338, y = 261.8079289131921},
            propsData = {ModeType = 0}
          },
          ["1782983598456944"] = {
            key = "1782983598456944",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1694.1651712132254, y = 227.15785358805954},
            propsData = {ModeType = 0}
          },
          ["1782983598456945"] = {
            key = "1782983598456945",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1709.6144701979938, y = 671.111954407149},
            propsData = {}
          },
          ["1782983598456947"] = {
            key = "1782983598456947",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务204",
            pos = {x = 1388.9839816933638, y = 254.29290617848972},
            propsData = {SpecialConfigId = 12070204, BlackScreenImmediately = true}
          },
          ["17870624910595064503"] = {
            key = "17870624910595064503",
            type = "GoToNode",
            name = "前往冰湖城街道",
            pos = {x = 1115.3841050254093, y = 262.66516092603047},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351192086,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351192086"
            }
          },
          ["17902335738826881389"] = {
            key = "17902335738826881389",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 1701.5944055944058, y = 528.2447552447551},
            propsData = {}
          },
          ["17902335805426881526"] = {
            key = "17902335805426881526",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1702.3636363636367, y = 365.55244755244735},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_CityRestart_1207",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
