return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178599891407711148402",
      startPort = "Success",
      endStory = "178599891407711148401",
      endPort = "StoryEnd"
    },
    {
      startStory = "178599891407711148400",
      startPort = "StoryStart",
      endStory = "178599891407711148402",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["178599891407711148400"] = {
      isStoryNode = true,
      key = "178599891407711148400",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 894.1739130434785, y = 317.2494279176201},
      propsData = {QuestChainId = 400134},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178599891407711148401"] = {
      isStoryNode = true,
      key = "178599891407711148401",
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
    ["178599891407711148402"] = {
      isStoryNode = true,
      key = "178599891407711148402",
      type = "StoryNode",
      name = "摩天轮拍照",
      pos = {x = 1656.1438909555918, y = 321.57448849104856},
      propsData = {
        QuestId = 40013400,
        QuestDescriptionComment = "",
        QuestDescription = "Description_400134_1",
        QuestDeatil = "Content_400134_1",
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
        SubRegionId = 107001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_TakePhoto_2780662",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "178599891407711148403",
            startPort = "QuestStart",
            endQuest = "178599891407711148408",
            endPort = "In"
          },
          {
            startQuest = "178599891407711148407",
            startPort = "Out",
            endQuest = "178599891407711148406",
            endPort = "In"
          },
          {
            startQuest = "178599891407711148407",
            startPort = "Out",
            endQuest = "178599891407711148409",
            endPort = "In"
          },
          {
            startQuest = "178599891407711148409",
            startPort = "Out",
            endQuest = "178599891407711148410",
            endPort = "In"
          },
          {
            startQuest = "178599891407711148410",
            startPort = "Out",
            endQuest = "178599891407711148407",
            endPort = "In"
          },
          {
            startQuest = "178599891407711148406",
            startPort = "Success",
            endQuest = "178599891407711148407",
            endPort = "Stop"
          },
          {
            startQuest = "178599891407711148408",
            startPort = "Out",
            endQuest = "178599891407711148411",
            endPort = "In"
          },
          {
            startQuest = "178599891407711148412",
            startPort = "Out",
            endQuest = "178599891407711148404",
            endPort = "Success"
          },
          {
            startQuest = "178599891407711148408",
            startPort = "Out",
            endQuest = "178599891407711148413",
            endPort = "In"
          },
          {
            startQuest = "178599891407711148406",
            startPort = "Success",
            endQuest = "178599891407711148412",
            endPort = "In"
          },
          {
            startQuest = "178599891407711148411",
            startPort = "Out",
            endQuest = "178599891407711148407",
            endPort = "In"
          },
          {
            startQuest = "178599891407711148411",
            startPort = "Out",
            endQuest = "178599891407711148414",
            endPort = "In"
          }
        },
        nodeData = {
          ["178599891407711148403"] = {
            key = "178599891407711148403",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -549.45, y = 309.5},
            propsData = {ModeType = 0}
          },
          ["178599891407711148404"] = {
            key = "178599891407711148404",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1496.2220279720282, y = 317.76398601398597},
            propsData = {ModeType = 0}
          },
          ["178599891407711148405"] = {
            key = "178599891407711148405",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["178599891407711148406"] = {
            key = "178599891407711148406",
            type = "CameraNode",
            name = "相机节点",
            pos = {x = 762.5807692307691, y = 317.93461538461537},
            propsData = {
              bFadeInOut = false,
              bIsForceOpenCamera = true,
              bGuideUIEnable = true,
              GuideType = "P",
              _GuidePointName = "BP_PhotoTarget_400134",
              TargetPointList = {
                "BP_PhotoTarget_400134"
              },
              EventId = 103030,
              EventParams = {"5"},
              Text_TargetFound = "",
              Text_TargetNotFound = "",
              ForceMaxLodStaticPointList = {},
              bShouldSetCameraParams = true,
              FocalLength = 15,
              LookAtTargetName = "BP_PhotoTarget_400134",
              StartPos = "(X=-11576.083008,Y=-76436.023438,Z=-2495.098145)",
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
          ["178599891407711148407"] = {
            key = "178599891407711148407",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 351.0009534583062, y = 306.2062349415289},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 2780662,
              StateId = 11301281,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["178599891407711148408"] = {
            key = "178599891407711148408",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = -265.61827731092455, y = 311.92161955691364},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 107001,
              bGuideUIEnable = true,
              GuideType = "M",
              GuideName = "Mechanism_TakePhoto_2780662"
            }
          },
          ["178599891407711148409"] = {
            key = "178599891407711148409",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 157.8394149967678, y = 526.6562349415291},
            propsData = {WaitTime = 1}
          },
          ["178599891407711148410"] = {
            key = "178599891407711148410",
            type = "SwitchMechanismStateNode",
            name = "切换机关状态",
            pos = {x = 505.9009534583063, y = 533.4293118646059},
            propsData = {
              StaticCreatorIdList = {2780662},
              ManualItemIdList = {},
              StateId = 11301280,
              QuestId = 0
            }
          },
          ["178599891407711148411"] = {
            key = "178599891407711148411",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 23.493261150613872, y = 319.5716195569135},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2780662}
            }
          },
          ["178599891407711148412"] = {
            key = "178599891407711148412",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1145.6520024093552, y = 321.81462654992055},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2780662}
            }
          },
          ["178599891407711148413"] = {
            key = "178599891407711148413",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 23.497435897435857, y = 106.33162393162392},
            propsData = {
              NewDescription = "Description_400134_2",
              NewDetail = "Content_400134_2",
              SubTaskTargetIndex = 0
            }
          },
          ["178599891407711148414"] = {
            key = "178599891407711148414",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示拍照点的指引",
            pos = {x = 349.12110423116604, y = 95.89706080812905},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = true,
              GuideType = "M",
              GuideName = "Mechanism_TakePhoto_2780662"
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
