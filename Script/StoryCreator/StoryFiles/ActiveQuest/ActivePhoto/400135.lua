return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178599917642012819538",
      startPort = "Success",
      endStory = "178599917642012819537",
      endPort = "StoryEnd"
    },
    {
      startStory = "178599917642012819536",
      startPort = "StoryStart",
      endStory = "178599917642012819538",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["178599917642012819536"] = {
      isStoryNode = true,
      key = "178599917642012819536",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 894.1739130434785, y = 317.2494279176201},
      propsData = {QuestChainId = 400135},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178599917642012819537"] = {
      isStoryNode = true,
      key = "178599917642012819537",
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
    ["178599917642012819538"] = {
      isStoryNode = true,
      key = "178599917642012819538",
      type = "StoryNode",
      name = "村庄广场拍照",
      pos = {x = 1656.1438909555918, y = 321.57448849104856},
      propsData = {
        QuestId = 40013500,
        QuestDescriptionComment = "",
        QuestDescription = "Description_400135_1",
        QuestDeatil = "Content_400135_1",
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
        StoryGuidePointName = "Mechanism_TakePhoto_2780664",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "178599917642012819539",
            startPort = "QuestStart",
            endQuest = "178599917642012819544",
            endPort = "In"
          },
          {
            startQuest = "178599917642012819543",
            startPort = "Out",
            endQuest = "178599917642012819542",
            endPort = "In"
          },
          {
            startQuest = "178599917642012819543",
            startPort = "Out",
            endQuest = "178599917642012819545",
            endPort = "In"
          },
          {
            startQuest = "178599917642012819545",
            startPort = "Out",
            endQuest = "178599917642012819546",
            endPort = "In"
          },
          {
            startQuest = "178599917642012819546",
            startPort = "Out",
            endQuest = "178599917642012819543",
            endPort = "In"
          },
          {
            startQuest = "178599917642012819542",
            startPort = "Success",
            endQuest = "178599917642012819543",
            endPort = "Stop"
          },
          {
            startQuest = "178599917642012819544",
            startPort = "Out",
            endQuest = "178599917642012819547",
            endPort = "In"
          },
          {
            startQuest = "178599917642012819548",
            startPort = "Out",
            endQuest = "178599917642012819540",
            endPort = "Success"
          },
          {
            startQuest = "178599917642012819544",
            startPort = "Out",
            endQuest = "178599917642012819549",
            endPort = "In"
          },
          {
            startQuest = "178599917642012819542",
            startPort = "Success",
            endQuest = "178599917642012819548",
            endPort = "In"
          },
          {
            startQuest = "178599917642012819547",
            startPort = "Out",
            endQuest = "178599917642012819543",
            endPort = "In"
          },
          {
            startQuest = "178599917642012819547",
            startPort = "Out",
            endQuest = "178599917642012819550",
            endPort = "In"
          }
        },
        nodeData = {
          ["178599917642012819539"] = {
            key = "178599917642012819539",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -549.45, y = 309.5},
            propsData = {ModeType = 0}
          },
          ["178599917642012819540"] = {
            key = "178599917642012819540",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1496.2220279720282, y = 317.76398601398597},
            propsData = {ModeType = 0}
          },
          ["178599917642012819541"] = {
            key = "178599917642012819541",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["178599917642012819542"] = {
            key = "178599917642012819542",
            type = "CameraNode",
            name = "相机节点",
            pos = {x = 764.5807692307691, y = 317.93461538461537},
            propsData = {
              bFadeInOut = false,
              bIsForceOpenCamera = true,
              bGuideUIEnable = true,
              GuideType = "P",
              _GuidePointName = "BP_PhotoTarget_400135",
              TargetPointList = {
                "BP_PhotoTarget_400135"
              },
              EventId = 103030,
              EventParams = {"6"},
              Text_TargetFound = "",
              Text_TargetNotFound = "",
              ForceMaxLodStaticPointList = {},
              bShouldSetCameraParams = true,
              FocalLength = 15,
              LookAtTargetName = "BP_PhotoTarget_400135",
              StartPos = "(X=-21877.351562,Y=-76099.500000,Z=-4393.827637)",
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
          ["178599917642012819543"] = {
            key = "178599917642012819543",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 351.0009534583062, y = 306.2062349415289},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 2780664,
              StateId = 11301281,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["178599917642012819544"] = {
            key = "178599917642012819544",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = -265.61827731092455, y = 311.92161955691364},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 107001,
              bGuideUIEnable = true,
              GuideType = "M",
              GuideName = "Mechanism_TakePhoto_2780664"
            }
          },
          ["178599917642012819545"] = {
            key = "178599917642012819545",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 156.6394149967678, y = 526.6562349415291},
            propsData = {WaitTime = 1}
          },
          ["178599917642012819546"] = {
            key = "178599917642012819546",
            type = "SwitchMechanismStateNode",
            name = "切换机关状态",
            pos = {x = 505.9009534583063, y = 533.4293118646059},
            propsData = {
              StaticCreatorIdList = {2780664},
              ManualItemIdList = {},
              StateId = 11301280,
              QuestId = 0
            }
          },
          ["178599917642012819547"] = {
            key = "178599917642012819547",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 23.493261150613872, y = 319.5716195569135},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2780664}
            }
          },
          ["178599917642012819548"] = {
            key = "178599917642012819548",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1145.6520024093552, y = 321.81462654992055},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2780664}
            }
          },
          ["178599917642012819549"] = {
            key = "178599917642012819549",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 23.497435897435857, y = 106.33162393162392},
            propsData = {
              NewDescription = "Description_400135_2",
              NewDetail = "Content_400135_2",
              SubTaskTargetIndex = 0
            }
          },
          ["178599917642012819550"] = {
            key = "178599917642012819550",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示拍照点的指引",
            pos = {x = 347.92110423116605, y = 95.89706080812905},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = true,
              GuideType = "M",
              GuideName = "Mechanism_TakePhoto_2780664"
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
