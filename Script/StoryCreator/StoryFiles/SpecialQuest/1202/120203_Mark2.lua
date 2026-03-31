return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17724388093757075839",
      startPort = "StoryStart",
      endStory = "17724388093757075841",
      endPort = "In"
    },
    {
      startStory = "17724388093757075841",
      startPort = "Success",
      endStory = "17724388093757075840",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17724388093757075839"] = {
      isStoryNode = true,
      key = "17724388093757075839",
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
    ["17724388093757075840"] = {
      isStoryNode = true,
      key = "17724388093757075840",
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
    ["17724388093757075841"] = {
      isStoryNode = true,
      key = "17724388093757075841",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1372, y = 352},
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
            startQuest = "17724388093757075842",
            startPort = "QuestStart",
            endQuest = "17724388093757075846",
            endPort = "In"
          },
          {
            startQuest = "17724388093757075846",
            startPort = "Out",
            endQuest = "17724388093757075844",
            endPort = "Fail"
          },
          {
            startQuest = "17724390792702384707",
            startPort = "Out",
            endQuest = "17724390792702384705",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384705",
            startPort = "Out",
            endQuest = "17724390792702384712",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384705",
            startPort = "Out",
            endQuest = "17724390792702384714",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384715",
            startPort = "Out",
            endQuest = "17724390792702384713",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384717",
            startPort = "Out",
            endQuest = "17724390792702384708",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384710",
            startPort = "Out",
            endQuest = "17724388093757075845",
            endPort = "In"
          },
          {
            startQuest = "1772883747907824022",
            startPort = "Out",
            endQuest = "17724390792702384707",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384709",
            startPort = "Out",
            endQuest = "17724390792702384710",
            endPort = "In"
          },
          {
            startQuest = "17724388093757075842",
            startPort = "QuestStart",
            endQuest = "17728846043722466633",
            endPort = "In"
          },
          {
            startQuest = "17724388093757075842",
            startPort = "QuestStart",
            endQuest = "1772883747907824022",
            endPort = "In"
          },
          {
            startQuest = "1772883747907824022",
            startPort = "Out",
            endQuest = "17728846043722466633",
            endPort = "Stop"
          },
          {
            startQuest = "17728846043722466633",
            startPort = "Out",
            endQuest = "17732354923626020938",
            endPort = "In"
          },
          {
            startQuest = "1772883747907824022",
            startPort = "Out",
            endQuest = "17732355213766021204",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384707",
            startPort = "Out",
            endQuest = "17732356791996021790",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384708",
            startPort = "Out",
            endQuest = "17732357180366022458",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384706",
            startPort = "Out",
            endQuest = "17732357361216022749",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384709",
            startPort = "Out",
            endQuest = "17732357361216022750",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384711",
            startPort = "Out",
            endQuest = "17732357909816023314",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384710",
            startPort = "Out",
            endQuest = "17732357952526023460",
            endPort = "In"
          },
          {
            startQuest = "17724388093757075842",
            startPort = "QuestStart",
            endQuest = "17736780509792531901",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384705",
            startPort = "Out",
            endQuest = "1774009517013849042",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384715",
            startPort = "Out",
            endQuest = "1774009531457849243",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384714",
            startPort = "Out",
            endQuest = "17724390792702384715",
            endPort = "In"
          },
          {
            startQuest = "17746922631606831603",
            startPort = "Out",
            endQuest = "17746922751166831848",
            endPort = "In"
          },
          {
            startQuest = "1772883747907824022",
            startPort = "Out",
            endQuest = "17746922631606831603",
            endPort = "In"
          },
          {
            startQuest = "17746923309186833264",
            startPort = "Out",
            endQuest = "17746923309186833265",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384707",
            startPort = "Out",
            endQuest = "17746923309186833264",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384715",
            startPort = "Out",
            endQuest = "17724390792702384717",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384717",
            startPort = "Out",
            endQuest = "17732357090456022215",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384714",
            startPort = "Out",
            endQuest = "17746923580276834048",
            endPort = "In"
          },
          {
            startQuest = "17746926942877689808",
            startPort = "Out",
            endQuest = "17746926942877689809",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384708",
            startPort = "Out",
            endQuest = "17746926942877689808",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384708",
            startPort = "Out",
            endQuest = "17724390792702384709",
            endPort = "In"
          },
          {
            startQuest = "17746927792277692046",
            startPort = "Out",
            endQuest = "17746927792277692047",
            endPort = "In"
          },
          {
            startQuest = "17724390792702384709",
            startPort = "Out",
            endQuest = "17746927792277692046",
            endPort = "In"
          }
        },
        nodeData = {
          ["17724388093757075842"] = {
            key = "17724388093757075842",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -6.5021415017618835, y = 280.1198156682027},
            propsData = {ModeType = 0}
          },
          ["17724388093757075843"] = {
            key = "17724388093757075843",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3844.880192271497, y = 2609.0828012567154},
            propsData = {ModeType = 0}
          },
          ["17724388093757075844"] = {
            key = "17724388093757075844",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1222.6346153846148, y = 1940.3076923076928},
            propsData = {}
          },
          ["17724388093757075845"] = {
            key = "17724388093757075845",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2858.537230056335, y = 1891.686424667942},
            propsData = {}
          },
          ["17724388093757075846"] = {
            key = "17724388093757075846",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 541.7646686984667, y = 1920.1357111955244},
            propsData = {}
          },
          ["17724390792702384704"] = {
            key = "17724390792702384704",
            type = "GoToNode",
            name = "箭头6",
            pos = {x = 1272.8161704595614, y = -350.23715197328943},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2430056,
              GuideType = "M",
              GuidePointName = "Mechanism_12020308hezi6_2430056"
            }
          },
          ["17724390792702384705"] = {
            key = "17724390792702384705",
            type = "GoToNode",
            name = "箭头7盒子",
            pos = {x = 2133.667091301888, y = 248.99568717311942},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 2430057,
              GuideType = "M",
              GuidePointName = "Mechanism_12020308hezi7_2430057"
            }
          },
          ["17724390792702384706"] = {
            key = "17724390792702384706",
            type = "GoToNode",
            name = "箭头8",
            pos = {x = 2727.221674825839, y = 881.3764056266045},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2430058,
              GuideType = "M",
              GuidePointName = "Mechanism_12020308hezi8_2430058"
            }
          },
          ["17724390792702384707"] = {
            key = "17724390792702384707",
            type = "BossBattleFinishNode",
            name = "6号箭头被打了",
            pos = {x = 1275.0791924688886, y = 193.39651676168853},
            propsData = {
              SendMessage = "",
              FinishCondition = "FindArrow_6"
            }
          },
          ["17724390792702384708"] = {
            key = "17724390792702384708",
            type = "BossBattleFinishNode",
            name = "7号箭头被打了",
            pos = {x = 3410.6809372963608, y = 282.73680634251616},
            propsData = {
              SendMessage = "",
              FinishCondition = "FindArrow_7"
            }
          },
          ["17724390792702384709"] = {
            key = "17724390792702384709",
            type = "BossBattleFinishNode",
            name = "8号箭头被打了",
            pos = {x = 2127.258341743605, y = 962.17964243394},
            propsData = {
              SendMessage = "",
              FinishCondition = "FindArrow_8"
            }
          },
          ["17724390792702384710"] = {
            key = "17724390792702384710",
            type = "BossBattleFinishNode",
            name = "9号箭头被打了",
            pos = {x = 2134.5738313301244, y = 1863.7154217822376},
            propsData = {
              SendMessage = "",
              FinishCondition = "FindArrow_9"
            }
          },
          ["17724390792702384711"] = {
            key = "17724390792702384711",
            type = "GoToNode",
            name = "箭头9",
            pos = {x = 2144.0068007972186, y = 1678.6325879225292},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2430059,
              GuideType = "M",
              GuidePointName = "Mechanism_12020308hezi8_2430059"
            }
          },
          ["17724390792702384712"] = {
            key = "17724390792702384712",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 2415.103446764954, y = -1.6319321017161945},
            propsData = {
              NewDescription = "Description_120203_7_4",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["17724390792702384713"] = {
            key = "17724390792702384713",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更回任务目标节点",
            pos = {x = 3083.199279079605, y = 142.2039039123041},
            propsData = {
              NewDescription = "Description_120203_7_2",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["17724390792702384714"] = {
            key = "17724390792702384714",
            type = "ChangeStaticCreatorNode",
            name = "生成7号位置怪物",
            pos = {x = 2422.7004704427795, y = 280.1895215996653},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                162430088,
                162430089,
                162430090,
                162430091,
                162430092,
                162430093,
                162430094,
                162430101,
                162430096,
                162430097,
                162430098,
                162430099,
                162430100
              }
            }
          },
          ["17724390792702384715"] = {
            key = "17724390792702384715",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 2758.881290877046, y = 270.3338786513846},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 13,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                162430088,
                162430089,
                162430090,
                162430091,
                162430092,
                162430093,
                162430094,
                162430101,
                162430096,
                162430097,
                162430098,
                162430099,
                162430100
              }
            }
          },
          ["17724390792702384717"] = {
            key = "17724390792702384717",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 3079.417999513477, y = 287.87352819379106},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "FindArrow_7MonKill",
              UnitId = -1
            }
          },
          ["1772883747907824022"] = {
            key = "1772883747907824022",
            type = "BossBattleFinishNode",
            name = "5号箭头被打了",
            pos = {x = 588.9011986487957, y = 179.11281161293937},
            propsData = {
              SendMessage = "",
              FinishCondition = "FindArrow_5"
            }
          },
          ["17728846043722466633"] = {
            key = "17728846043722466633",
            type = "GoToNode",
            name = "前往",
            pos = {x = 611.3471293247027, y = -348.4651937116788},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2010048,
              GuideType = "M",
              GuidePointName = "Mechanism_12020305suyi_2010048"
            }
          },
          ["177312866370618277315"] = {
            key = "177312866370618277315",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 11.327991452991455, y = -345.3024433296172},
            propsData = {
              NewDescription = "Description_120203_7_4",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["17732354923626020938"] = {
            key = "17732354923626020938",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 932.3541482360557, y = -352.608238220405},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Mechanism_12020305suyi_2010048"
            }
          },
          ["17732355213766021204"] = {
            key = "17732355213766021204",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 905.781146833531, y = -181.4344120290647},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Mechanism_12020305suyi_2010048"
            }
          },
          ["17732356791996021790"] = {
            key = "17732356791996021790",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1685.586188130087, y = 184.51824440461382},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Mechanism_12020308hezi6_2430056"
            }
          },
          ["17732357090456022215"] = {
            key = "17732357090456022215",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 3423.7979810512074, y = 100.02485266749393},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Mechanism_12020308hezi7_2430057"
            }
          },
          ["17732357180366022458"] = {
            key = "17732357180366022458",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 3712.0979311011574, y = 297.52086789218873},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Mechanism_12020308hezi7_2430057"
            }
          },
          ["17732357361216022749"] = {
            key = "17732357361216022749",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2995.2944845477105, y = 863.9259018115624},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "Mechanism_12020308hezi8_2430058top"
            }
          },
          ["17732357361216022750"] = {
            key = "17732357361216022750",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2712.8955834488083, y = 1034.9348540991941},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "Mechanism_12020308hezi8_2430058top"
            }
          },
          ["17732357909816023314"] = {
            key = "17732357909816023314",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2483.9314031846297, y = 1689.881193806194},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Mechanism_12020308hezi8_2430059"
            }
          },
          ["17732357952526023460"] = {
            key = "17732357952526023460",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2493.231403184629, y = 1879.4311938061946},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Mechanism_12020308hezi8_2430059"
            }
          },
          ["17736780509792531901"] = {
            key = "17736780509792531901",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 225.05360200558562, y = -147.48585539068432},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "FindArrow_5_Start",
              UnitId = -1
            }
          },
          ["1774009517013849042"] = {
            key = "1774009517013849042",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 2418.6592007026798, y = 150.44822930692536},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {242430197}
            }
          },
          ["1774009531457849243"] = {
            key = "1774009531457849243",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 3098.5360854371365, y = -8.687882020527907},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {242430197}
            }
          },
          ["17746922631606831603"] = {
            key = "17746922631606831603",
            type = "BossBattleFinishNode",
            name = "鸟飞到6号标记",
            pos = {x = 1281.9403098108794, y = 27.626882566513387},
            propsData = {
              SendMessage = "",
              FinishCondition = "FindArrow_Arrived_6"
            }
          },
          ["17746922751166831848"] = {
            key = "17746922751166831848",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1682.5303670549847, y = 11.095816106515386},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Mechanism_12020308hezi6_2430056"
            }
          },
          ["17746923309186833264"] = {
            key = "17746923309186833264",
            type = "BossBattleFinishNode",
            name = "鸟飞到7号标记",
            pos = {x = 2126.27892134678, y = -177.8527683821306},
            propsData = {
              SendMessage = "",
              FinishCondition = "FindArrow_Arrived_7"
            }
          },
          ["17746923309186833265"] = {
            key = "17746923309186833265",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2393.9879054156945, y = -184.1169122222648},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Mechanism_12020308hezi7_2430057"
            }
          },
          ["17746923580276834048"] = {
            key = "17746923580276834048",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2728.655779009358, y = 89.22042858006247},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Mechanism_12020308hezi6_2430056"
            }
          },
          ["17746926942877689808"] = {
            key = "17746926942877689808",
            type = "BossBattleFinishNode",
            name = "鸟飞到8号标记",
            pos = {x = 2094.458693190043, y = 700.6730606483102},
            propsData = {
              SendMessage = "",
              FinishCondition = "FindArrow_Arrived_8"
            }
          },
          ["17746926942877689809"] = {
            key = "17746926942877689809",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2370.7001447914254, y = 699.5517739510333},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "Mechanism_12020308hezi8_2430058top"
            }
          },
          ["17746927792277692046"] = {
            key = "17746927792277692046",
            type = "BossBattleFinishNode",
            name = "鸟飞到9号标记",
            pos = {x = 2132.9125151860017, y = 1517.9484627426837},
            propsData = {
              SendMessage = "",
              FinishCondition = "FindArrow_Arrived_9"
            }
          },
          ["17746927792277692047"] = {
            key = "17746927792277692047",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2409.153966787384, y = 1516.8271760454068},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Mechanism_12020308hezi8_2430059"
            }
          }
        },
        commentData = {
          ["17724390940352385243"] = {
            key = "17724390940352385243",
            name = "9号",
            position = {x = 2069.7266085016136, y = 1340.9518672274826},
            size = {width = 1116.2604139976845, height = 714.3164806937629}
          },
          ["17724391106352385789"] = {
            key = "17724391106352385789",
            name = "8号",
            position = {x = 2071.009462121424, y = 541.3556958867462},
            size = {width = 1171.1351558209378, height = 760.6118969002101}
          },
          ["17724391189422386089"] = {
            key = "17724391189422386089",
            name = "7号--杀怪",
            position = {x = 2101.550276437809, y = -469.1075789131666},
            size = {width = 1852.0841239865795, height = 921.4673374072}
          },
          ["17724391277972386362"] = {
            key = "17724391277972386362",
            name = "6号",
            position = {x = 1227.0014576095778, y = -427.8604987874099},
            size = {width = 754.8182768829006, height = 787.5040822503556}
          },
          ["17728846199562467064"] = {
            key = "17728846199562467064",
            name = "5号",
            position = {x = 543.8115063798724, y = -448.1272324402138},
            size = {width = 629.8832281126055, height = 785.2708159031595}
          }
        }
      }
    }
  },
  commentData = {}
}
