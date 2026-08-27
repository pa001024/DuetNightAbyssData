return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17859862544002798652",
      startPort = "Success",
      endStory = "17859862544002798651",
      endPort = "StoryEnd"
    },
    {
      startStory = "17859862544002798650",
      startPort = "StoryStart",
      endStory = "17859862544002798652",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17859862544002798650"] = {
      isStoryNode = true,
      key = "17859862544002798650",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 894.1739130434785, y = 317.2494279176201},
      propsData = {QuestChainId = 400131},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17859862544002798651"] = {
      isStoryNode = true,
      key = "17859862544002798651",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2618.8853754940715, y = 318.8043478260869},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17859862544002798652"] = {
      isStoryNode = true,
      key = "17859862544002798652",
      type = "StoryNode",
      name = "轨道拍照",
      pos = {x = 1658.1438909555918, y = 320.2108521274122},
      propsData = {
        QuestId = 40013100,
        QuestDescriptionComment = "",
        QuestDescription = "Description_400131_1",
        QuestDeatil = "Content_400131_1",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = true,
        bIsEndQuest = true,
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
        StoryGuidePointName = "Mechanism_TakePhoto_2480702",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17859862544002798653",
            startPort = "QuestStart",
            endQuest = "17859862544002798658",
            endPort = "In"
          },
          {
            startQuest = "17859862544002798657",
            startPort = "Out",
            endQuest = "17859862544002798656",
            endPort = "In"
          },
          {
            startQuest = "17859862544002798657",
            startPort = "Out",
            endQuest = "17859862544002798659",
            endPort = "In"
          },
          {
            startQuest = "17859862544002798659",
            startPort = "Out",
            endQuest = "17859862544002798660",
            endPort = "In"
          },
          {
            startQuest = "17859862544002798660",
            startPort = "Out",
            endQuest = "17859862544002798657",
            endPort = "In"
          },
          {
            startQuest = "17859862544002798656",
            startPort = "Success",
            endQuest = "17859862544002798657",
            endPort = "Stop"
          },
          {
            startQuest = "17859862544002798658",
            startPort = "Out",
            endQuest = "17859862544002798661",
            endPort = "In"
          },
          {
            startQuest = "17859862544002798662",
            startPort = "Out",
            endQuest = "17859862544002798654",
            endPort = "Success"
          },
          {
            startQuest = "17859862544002798658",
            startPort = "Out",
            endQuest = "17859862544002798663",
            endPort = "In"
          },
          {
            startQuest = "17859862544002798656",
            startPort = "Success",
            endQuest = "17859862544002798662",
            endPort = "In"
          },
          {
            startQuest = "17859862544002798661",
            startPort = "Out",
            endQuest = "17859862544002798657",
            endPort = "In"
          },
          {
            startQuest = "17859862544002798661",
            startPort = "Out",
            endQuest = "17859862544002798664",
            endPort = "In"
          }
        },
        nodeData = {
          ["17859862544002798653"] = {
            key = "17859862544002798653",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -549.45, y = 309.5},
            propsData = {ModeType = 0}
          },
          ["17859862544002798654"] = {
            key = "17859862544002798654",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1496.2220279720282, y = 317.76398601398597},
            propsData = {ModeType = 0}
          },
          ["17859862544002798655"] = {
            key = "17859862544002798655",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17859862544002798656"] = {
            key = "17859862544002798656",
            type = "CameraNode",
            name = "相机节点",
            pos = {x = 762.5807692307691, y = 316.7346153846154},
            propsData = {
              bFadeInOut = false,
              bIsForceOpenCamera = true,
              bGuideUIEnable = true,
              GuideType = "P",
              _GuidePointName = "BP_PhotoTarget_400131",
              TargetPointList = {
                "BP_PhotoTarget_400131"
              },
              EventId = 103030,
              EventParams = {"2"},
              Text_TargetFound = "",
              Text_TargetNotFound = "",
              ForceMaxLodStaticPointList = {},
              bShouldSetCameraParams = true,
              FocalLength = 15,
              LookAtTargetName = "BP_PhotoTarget_400131",
              StartPos = "(X=-42831.710938,Y=-287.987549,Z=2499.250000)",
              StartRotation = "",
              bLockCameraPos = false,
              bStartHiddenRole = true,
              bLockHiddenRole = true,
              bStartHiddenNPC = false,
              bLockHiddenNPC = false,
              bStartHiddenMonster = false,
              bLockHiddenMonster = false,
              bStartHiddenPet = false,
              bLockHiddenPet = false,
              bLockGamePause = true,
              bForceGamePause = true
            }
          },
          ["17859862544002798657"] = {
            key = "17859862544002798657",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 351.0009534583062, y = 306.2062349415289},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 2480702,
              StateId = 11301281,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["17859862544002798658"] = {
            key = "17859862544002798658",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = -265.61827731092455, y = 311.92161955691364},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 106001,
              bGuideUIEnable = true,
              GuideType = "M",
              GuideName = "Mechanism_TakePhoto_2480700"
            }
          },
          ["17859862544002798659"] = {
            key = "17859862544002798659",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 157.8394149967678, y = 526.6562349415291},
            propsData = {WaitTime = 1}
          },
          ["17859862544002798660"] = {
            key = "17859862544002798660",
            type = "SwitchMechanismStateNode",
            name = "切换机关状态",
            pos = {x = 504.74710730446014, y = 533.4293118646059},
            propsData = {
              StaticCreatorIdList = {2480702},
              ManualItemIdList = {},
              StateId = 11301280,
              QuestId = 0
            }
          },
          ["17859862544002798661"] = {
            key = "17859862544002798661",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 23.493261150613872, y = 318.3216195569135},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2480702}
            }
          },
          ["17859862544002798662"] = {
            key = "17859862544002798662",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1145.6520024093552, y = 321.81462654992055},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2480702}
            }
          },
          ["17859862544002798663"] = {
            key = "17859862544002798663",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 23.497435897435857, y = 106.33162393162392},
            propsData = {
              NewDescription = "Description_400131_2",
              NewDetail = "Content_400131_2",
              SubTaskTargetIndex = 0
            }
          },
          ["17859862544002798664"] = {
            key = "17859862544002798664",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示拍照点的指引",
            pos = {x = 345.37110423116604, y = 94.64706080812905},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = true,
              GuideType = "M",
              GuideName = "Mechanism_TakePhoto_2480702"
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
