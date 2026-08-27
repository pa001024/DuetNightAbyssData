return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178599935188214490869",
      startPort = "Success",
      endStory = "178599935188214490868",
      endPort = "StoryEnd"
    },
    {
      startStory = "178599935188214490867",
      startPort = "StoryStart",
      endStory = "178599935188214490869",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["178599935188214490867"] = {
      isStoryNode = true,
      key = "178599935188214490867",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 889.5585284280938, y = 316.09558176377396},
      propsData = {QuestChainId = 400136},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178599935188214490868"] = {
      isStoryNode = true,
      key = "178599935188214490868",
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
    ["178599935188214490869"] = {
      isStoryNode = true,
      key = "178599935188214490869",
      type = "StoryNode",
      name = "裂隙拍照",
      pos = {x = 1657.297737109438, y = 321.57448849104856},
      propsData = {
        QuestId = 40013600,
        QuestDescriptionComment = "",
        QuestDescription = "Description_400136_1",
        QuestDeatil = "Content_400136_1",
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
        SubRegionId = 107201,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_TakePhoto_2800327",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "178599935188214490870",
            startPort = "QuestStart",
            endQuest = "178599935188214490875",
            endPort = "In"
          },
          {
            startQuest = "178599935188214490874",
            startPort = "Out",
            endQuest = "178599935188214490873",
            endPort = "In"
          },
          {
            startQuest = "178599935188214490874",
            startPort = "Out",
            endQuest = "178599935188214490876",
            endPort = "In"
          },
          {
            startQuest = "178599935188214490876",
            startPort = "Out",
            endQuest = "178599935188214490877",
            endPort = "In"
          },
          {
            startQuest = "178599935188214490877",
            startPort = "Out",
            endQuest = "178599935188214490874",
            endPort = "In"
          },
          {
            startQuest = "178599935188214490873",
            startPort = "Success",
            endQuest = "178599935188214490874",
            endPort = "Stop"
          },
          {
            startQuest = "178599935188214490875",
            startPort = "Out",
            endQuest = "178599935188214490878",
            endPort = "In"
          },
          {
            startQuest = "178599935188214490879",
            startPort = "Out",
            endQuest = "178599935188214490871",
            endPort = "Success"
          },
          {
            startQuest = "178599935188214490875",
            startPort = "Out",
            endQuest = "178599935188214490880",
            endPort = "In"
          },
          {
            startQuest = "178599935188214490873",
            startPort = "Success",
            endQuest = "178599935188214490879",
            endPort = "In"
          },
          {
            startQuest = "178599935188214490878",
            startPort = "Out",
            endQuest = "178599935188214490874",
            endPort = "In"
          },
          {
            startQuest = "178599935188214490878",
            startPort = "Out",
            endQuest = "178599935188214490881",
            endPort = "In"
          }
        },
        nodeData = {
          ["178599935188214490870"] = {
            key = "178599935188214490870",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -549.45, y = 309.5},
            propsData = {ModeType = 0}
          },
          ["178599935188214490871"] = {
            key = "178599935188214490871",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1496.2220279720282, y = 317.76398601398597},
            propsData = {ModeType = 0}
          },
          ["178599935188214490872"] = {
            key = "178599935188214490872",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["178599935188214490873"] = {
            key = "178599935188214490873",
            type = "CameraNode",
            name = "相机节点",
            pos = {x = 762.5807692307691, y = 317.93461538461537},
            propsData = {
              bFadeInOut = false,
              bIsForceOpenCamera = true,
              bGuideUIEnable = true,
              GuideType = "P",
              _GuidePointName = "BP_PhotoTarget_400136",
              TargetPointList = {
                "BP_PhotoTarget_400136"
              },
              EventId = 103030,
              EventParams = {"7"},
              Text_TargetFound = "",
              Text_TargetNotFound = "",
              ForceMaxLodStaticPointList = {},
              bShouldSetCameraParams = true,
              FocalLength = 15,
              LookAtTargetName = "BP_PhotoTarget_400136",
              StartPos = "(X=-34983.125000,Y=-12531.262695,Z=-26099.722656)",
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
          ["178599935188214490874"] = {
            key = "178599935188214490874",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 351.0009534583062, y = 306.2062349415289},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 2800327,
              StateId = 11301281,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["178599935188214490875"] = {
            key = "178599935188214490875",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = -266.81827731092454, y = 311.92161955691364},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 107201,
              bGuideUIEnable = true,
              GuideType = "M",
              GuideName = "Mechanism_TakePhoto_2800327"
            }
          },
          ["178599935188214490876"] = {
            key = "178599935188214490876",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 156.6394149967678, y = 526.6562349415291},
            propsData = {WaitTime = 1}
          },
          ["178599935188214490877"] = {
            key = "178599935188214490877",
            type = "SwitchMechanismStateNode",
            name = "切换机关状态",
            pos = {x = 505.9009534583063, y = 533.4293118646059},
            propsData = {
              StaticCreatorIdList = {2800327},
              ManualItemIdList = {},
              StateId = 11301280,
              QuestId = 0
            }
          },
          ["178599935188214490878"] = {
            key = "178599935188214490878",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 23.493261150613872, y = 319.5716195569135},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2800327}
            }
          },
          ["178599935188214490879"] = {
            key = "178599935188214490879",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1145.6520024093552, y = 321.81462654992055},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2800327}
            }
          },
          ["178599935188214490880"] = {
            key = "178599935188214490880",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 23.497435897435857, y = 106.33162393162392},
            propsData = {
              NewDescription = "Description_400136_2",
              NewDetail = "Content_400136_2",
              SubTaskTargetIndex = 0
            }
          },
          ["178599935188214490881"] = {
            key = "178599935188214490881",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示拍照点的指引",
            pos = {x = 347.92110423116605, y = 95.89706080812905},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = true,
              GuideType = "M",
              GuideName = "Mechanism_TakePhoto_2800327"
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
