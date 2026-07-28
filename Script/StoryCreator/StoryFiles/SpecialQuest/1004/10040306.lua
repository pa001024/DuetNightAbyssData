return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17782426112415580940",
      startPort = "StoryStart",
      endStory = "17782425578054770724",
      endPort = "In"
    },
    {
      startStory = "17782425578054770724",
      startPort = "Success",
      endStory = "17782426112415580941",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17782425578054770724"] = {
      isStoryNode = true,
      key = "17782425578054770724",
      type = "StoryNode",
      name = "引爆炸弹战斗节点",
      pos = {x = 1109.2, y = 64.39408866995086},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040306_01",
        QuestDeatil = "Description_10040306_01",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_Storeroom_2480211",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17782425578054770732",
            startPort = "Out",
            endQuest = "17782425578054770733",
            endPort = "In"
          },
          {
            startQuest = "17782425578054770729",
            startPort = "QuestStart",
            endQuest = "17782425578054770734",
            endPort = "In"
          },
          {
            startQuest = "17782425578054770729",
            startPort = "QuestStart",
            endQuest = "17783048049114774482",
            endPort = "In"
          },
          {
            startQuest = "17782425578054770729",
            startPort = "QuestStart",
            endQuest = "177830615490020045808",
            endPort = "In"
          },
          {
            startQuest = "17782425578054770729",
            startPort = "QuestStart",
            endQuest = "1778740022264784",
            endPort = "In"
          },
          {
            startQuest = "17782425578054770729",
            startPort = "QuestStart",
            endQuest = "17787502705655835715",
            endPort = "In"
          },
          {
            startQuest = "17787502705655835715",
            startPort = "Out",
            endQuest = "17782425578054770731",
            endPort = "Fail"
          },
          {
            startQuest = "17782425578054770729",
            startPort = "QuestStart",
            endQuest = "177891737792077745592",
            endPort = "Input"
          },
          {
            startQuest = "17782425578054770729",
            startPort = "QuestStart",
            endQuest = "1779189029526135220167",
            endPort = "In"
          },
          {
            startQuest = "17782425578054770733",
            startPort = "Out",
            endQuest = "1779189043780135220498",
            endPort = "In"
          },
          {
            startQuest = "1779189043780135220498",
            startPort = "Out",
            endQuest = "1779189053935135220770",
            endPort = "In"
          },
          {
            startQuest = "1779189053935135220770",
            startPort = "Out",
            endQuest = "17782425775454771195",
            endPort = "In"
          },
          {
            startQuest = "17782425578054770729",
            startPort = "QuestStart",
            endQuest = "1779420671975751",
            endPort = "In"
          },
          {
            startQuest = "1779420671975751",
            startPort = "Out",
            endQuest = "17782425578054770732",
            endPort = "In"
          }
        },
        nodeData = {
          ["17782425578054770729"] = {
            key = "17782425578054770729",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -258.0259345117358, y = 350.38310787109765},
            propsData = {ModeType = 0}
          },
          ["17782425578054770730"] = {
            key = "17782425578054770730",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1981.144937077831, y = 344.79605025371785},
            propsData = {ModeType = 0}
          },
          ["17782425578054770731"] = {
            key = "17782425578054770731",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 858.3916083916089, y = 840.979020979021},
            propsData = {}
          },
          ["17782425578054770732"] = {
            key = "17782425578054770732",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 580.2924259240366, y = 350.02234902423515},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                2530078,
                2530079,
                2530080,
                2530081,
                2530082,
                2530083,
                2530084,
                2530085,
                2530086,
                2530087,
                2530088,
                2530089,
                2530090,
                2530091,
                2530092,
                2530093,
                2530094,
                2530095,
                2530096,
                2530097
              }
            }
          },
          ["17782425578054770733"] = {
            key = "17782425578054770733",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 954.0228334475478, y = 348.6587126605988},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 20,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                2530078,
                2530079,
                2530080,
                2530081,
                2530082,
                2530083,
                2530084,
                2530085,
                2530086,
                2530087,
                2530088,
                2530089,
                2530090,
                2530091,
                2530092,
                2530093,
                2530094,
                2530095,
                2530096,
                2530097
              }
            }
          },
          ["17782425578054770734"] = {
            key = "17782425578054770734",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 577.4285934186661, y = 238.43403939056117},
            propsData = {
              NewDescription = "Content_10040306_02",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["17782425775454771195"] = {
            key = "17782425775454771195",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 1734.0000000000002, y = 348.22222222222223},
            propsData = {}
          },
          ["17783048049114774482"] = {
            key = "17783048049114774482",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 576.7969924812029, y = 456.6165413533836},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177830615490020045808"] = {
            key = "177830615490020045808",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 580.4821428571428, y = 569.4075630252104},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {272480343}
            }
          },
          ["1778740022264784"] = {
            key = "1778740022264784",
            type = "AtmosphereNpcHideNode",
            name = "隐藏氛围",
            pos = {x = 579.9313909774436, y = 128.34398496240604},
            propsData = {
              IsHide = true,
              AtmosphereTagList = {"Story_YT", "Story_BHCZ"}
            }
          },
          ["17787502705655835715"] = {
            key = "17787502705655835715",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 581.1546456527274, y = 825.7221841457774},
            propsData = {}
          },
          ["177891737792077745592"] = {
            key = "177891737792077745592",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 594.8, y = 690.325},
            propsData = {
              TargetTime = 18,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["1779189029526135220167"] = {
            key = "1779189029526135220167",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 593.187134502924, y = -10.138157894736793},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {172480414}
            }
          },
          ["1779189043780135220498"] = {
            key = "1779189043780135220498",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1225.4093567251462, y = 349.86184210526324},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {172480414}
            }
          },
          ["1779189053935135220770"] = {
            key = "1779189053935135220770",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1489.6801900584796, y = 334.30628654970764},
            propsData = {WaitTime = 5}
          },
          ["1779420671975751"] = {
            key = "1779420671975751",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 320.6148459383753, y = 340.2857142857142},
            propsData = {
              VarName = "First10040306",
              VarValue = 1
            }
          }
        },
        commentData = {}
      }
    },
    ["17782426112415580940"] = {
      isStoryNode = true,
      key = "17782426112415580940",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 795.3714285714285, y = 91.97142857142856},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17782426112415580941"] = {
      isStoryNode = true,
      key = "17782426112415580941",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1409.7811367694735, y = 96.18036268441956},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    }
  },
  commentData = {}
}
