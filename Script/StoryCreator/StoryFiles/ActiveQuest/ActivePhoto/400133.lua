return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17859983860209477963",
      startPort = "Success",
      endStory = "17859983860209477962",
      endPort = "StoryEnd"
    },
    {
      startStory = "17859983860209477961",
      startPort = "StoryStart",
      endStory = "17859983860209477963",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17859983860209477961"] = {
      isStoryNode = true,
      key = "17859983860209477961",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 894.1739130434785, y = 317.2494279176201},
      propsData = {QuestChainId = 400133},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17859983860209477962"] = {
      isStoryNode = true,
      key = "17859983860209477962",
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
    ["17859983860209477963"] = {
      isStoryNode = true,
      key = "17859983860209477963",
      type = "StoryNode",
      name = "废墟游乐场拍照",
      pos = {x = 1656.1438909555918, y = 321.57448849104856},
      propsData = {
        QuestId = 40013300,
        QuestDescriptionComment = "",
        QuestDescription = "Description_400133_1",
        QuestDeatil = "Content_400133_1",
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
        SubRegionId = 107101,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_TakePhoto_2790454",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17859983860209477964",
            startPort = "QuestStart",
            endQuest = "17859983860209477969",
            endPort = "In"
          },
          {
            startQuest = "17859983860209477968",
            startPort = "Out",
            endQuest = "17859983860209477967",
            endPort = "In"
          },
          {
            startQuest = "17859983860209477968",
            startPort = "Out",
            endQuest = "17859983860209477970",
            endPort = "In"
          },
          {
            startQuest = "17859983860209477970",
            startPort = "Out",
            endQuest = "17859983860209477971",
            endPort = "In"
          },
          {
            startQuest = "17859983860209477971",
            startPort = "Out",
            endQuest = "17859983860209477968",
            endPort = "In"
          },
          {
            startQuest = "17859983860209477967",
            startPort = "Success",
            endQuest = "17859983860209477968",
            endPort = "Stop"
          },
          {
            startQuest = "17859983860209477969",
            startPort = "Out",
            endQuest = "17859983860209477972",
            endPort = "In"
          },
          {
            startQuest = "17859983860209477973",
            startPort = "Out",
            endQuest = "17859983860209477965",
            endPort = "Success"
          },
          {
            startQuest = "17859983860209477969",
            startPort = "Out",
            endQuest = "17859983860209477974",
            endPort = "In"
          },
          {
            startQuest = "17859983860209477967",
            startPort = "Success",
            endQuest = "17859983860209477973",
            endPort = "In"
          },
          {
            startQuest = "17859983860209477972",
            startPort = "Out",
            endQuest = "17859983860209477968",
            endPort = "In"
          },
          {
            startQuest = "17859983860209477972",
            startPort = "Out",
            endQuest = "17859983860209477975",
            endPort = "In"
          }
        },
        nodeData = {
          ["17859983860209477964"] = {
            key = "17859983860209477964",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -549.45, y = 309.5},
            propsData = {ModeType = 0}
          },
          ["17859983860209477965"] = {
            key = "17859983860209477965",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1496.2220279720282, y = 317.76398601398597},
            propsData = {ModeType = 0}
          },
          ["17859983860209477966"] = {
            key = "17859983860209477966",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17859983860209477967"] = {
            key = "17859983860209477967",
            type = "CameraNode",
            name = "相机节点",
            pos = {x = 762.5807692307691, y = 317.93461538461537},
            propsData = {
              bFadeInOut = false,
              bIsForceOpenCamera = true,
              bGuideUIEnable = true,
              GuideType = "P",
              _GuidePointName = "BP_PhotoTarget_400133",
              TargetPointList = {
                "BP_PhotoTarget_400133"
              },
              EventId = 103030,
              EventParams = {"4"},
              Text_TargetFound = "",
              Text_TargetNotFound = "",
              ForceMaxLodStaticPointList = {},
              bShouldSetCameraParams = true,
              FocalLength = 15,
              LookAtTargetName = "BP_PhotoTarget_400133",
              StartPos = "(X=-25666.968750,Y=-29836.644531,Z=-3435.711914)",
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
          ["17859983860209477968"] = {
            key = "17859983860209477968",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 351.0009534583062, y = 306.2062349415289},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 2790454,
              StateId = 11301281,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["17859983860209477969"] = {
            key = "17859983860209477969",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = -265.61827731092455, y = 311.92161955691364},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 107101,
              bGuideUIEnable = true,
              GuideType = "M",
              GuideName = "Mechanism_TakePhoto_2790454"
            }
          },
          ["17859983860209477970"] = {
            key = "17859983860209477970",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 157.8394149967678, y = 526.6562349415291},
            propsData = {WaitTime = 1}
          },
          ["17859983860209477971"] = {
            key = "17859983860209477971",
            type = "SwitchMechanismStateNode",
            name = "切换机关状态",
            pos = {x = 505.9009534583063, y = 533.4293118646059},
            propsData = {
              StaticCreatorIdList = {2790454},
              ManualItemIdList = {},
              StateId = 11301280,
              QuestId = 0
            }
          },
          ["17859983860209477972"] = {
            key = "17859983860209477972",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 23.493261150613872, y = 319.5716195569135},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2790454}
            }
          },
          ["17859983860209477973"] = {
            key = "17859983860209477973",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1145.6520024093552, y = 321.81462654992055},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2790454}
            }
          },
          ["17859983860209477974"] = {
            key = "17859983860209477974",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 23.497435897435857, y = 106.33162393162392},
            propsData = {
              NewDescription = "Description_400133_2",
              NewDetail = "Content_400133_2",
              SubTaskTargetIndex = 0
            }
          },
          ["17859983860209477975"] = {
            key = "17859983860209477975",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示拍照点的指引",
            pos = {x = 349.12110423116604, y = 95.89706080812905},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = true,
              GuideType = "M",
              GuideName = "Mechanism_TakePhoto_2790454"
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
