return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17859858673141129408",
      startPort = "Success",
      endStory = "17859858673141129407",
      endPort = "StoryEnd"
    },
    {
      startStory = "17859858673131129406",
      startPort = "StoryStart",
      endStory = "17859858673141129408",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17859858673131129406"] = {
      isStoryNode = true,
      key = "17859858673131129406",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 894.1739130434785, y = 317.2494279176201},
      propsData = {QuestChainId = 400130},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17859858673141129407"] = {
      isStoryNode = true,
      key = "17859858673141129407",
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
    ["17859858673141129408"] = {
      isStoryNode = true,
      key = "17859858673141129408",
      type = "StoryNode",
      name = "车站广场拍照",
      pos = {x = 1656.1438909555918, y = 321.57448849104856},
      propsData = {
        QuestId = 40013000,
        QuestDescriptionComment = "",
        QuestDescription = "Description_400130_1",
        QuestDeatil = "Content_400130_1",
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
        StoryGuidePointName = "Mechanism_TakePhoto_2480700",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17859858673141129409",
            startPort = "QuestStart",
            endQuest = "17859858673141129414",
            endPort = "In"
          },
          {
            startQuest = "17859858673141129413",
            startPort = "Out",
            endQuest = "17859858673141129412",
            endPort = "In"
          },
          {
            startQuest = "17859858673141129413",
            startPort = "Out",
            endQuest = "17859858673141129415",
            endPort = "In"
          },
          {
            startQuest = "17859858673141129415",
            startPort = "Out",
            endQuest = "17859858673141129416",
            endPort = "In"
          },
          {
            startQuest = "17859858673141129416",
            startPort = "Out",
            endQuest = "17859858673141129413",
            endPort = "In"
          },
          {
            startQuest = "17859858673141129412",
            startPort = "Success",
            endQuest = "17859858673141129413",
            endPort = "Stop"
          },
          {
            startQuest = "17859858673141129414",
            startPort = "Out",
            endQuest = "17859858673141129417",
            endPort = "In"
          },
          {
            startQuest = "17859858673141129418",
            startPort = "Out",
            endQuest = "17859858673141129410",
            endPort = "Success"
          },
          {
            startQuest = "17859858673141129414",
            startPort = "Out",
            endQuest = "17859858673141129419",
            endPort = "In"
          },
          {
            startQuest = "17859858673141129412",
            startPort = "Success",
            endQuest = "17859858673141129418",
            endPort = "In"
          },
          {
            startQuest = "17859858673141129417",
            startPort = "Out",
            endQuest = "17859858673141129413",
            endPort = "In"
          },
          {
            startQuest = "17859858673141129417",
            startPort = "Out",
            endQuest = "17859858673141129420",
            endPort = "In"
          }
        },
        nodeData = {
          ["17859858673141129409"] = {
            key = "17859858673141129409",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -549.45, y = 309.5},
            propsData = {ModeType = 0}
          },
          ["17859858673141129410"] = {
            key = "17859858673141129410",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1496.2220279720282, y = 317.76398601398597},
            propsData = {ModeType = 0}
          },
          ["17859858673141129411"] = {
            key = "17859858673141129411",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17859858673141129412"] = {
            key = "17859858673141129412",
            type = "CameraNode",
            name = "相机节点",
            pos = {x = 762.5807692307691, y = 316.7346153846154},
            propsData = {
              bFadeInOut = false,
              bIsForceOpenCamera = true,
              bGuideUIEnable = true,
              GuideType = "P",
              _GuidePointName = "BP_PhotoTarget_400130",
              TargetPointList = {
                "BP_PhotoTarget_400130"
              },
              EventId = 103030,
              EventParams = {"1"},
              Text_TargetFound = "",
              Text_TargetNotFound = "",
              ForceMaxLodStaticPointList = {},
              bShouldSetCameraParams = true,
              FocalLength = 15,
              LookAtTargetName = "BP_PhotoTarget_400130",
              StartPos = "(X=-2237.168945,Y=30.277832,Z=444.762329)",
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
          ["17859858673141129413"] = {
            key = "17859858673141129413",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 351.0009534583062, y = 306.2062349415289},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 2480700,
              StateId = 11301281,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["17859858673141129414"] = {
            key = "17859858673141129414",
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
          ["17859858673141129415"] = {
            key = "17859858673141129415",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 157.8394149967678, y = 526.6562349415291},
            propsData = {WaitTime = 1}
          },
          ["17859858673141129416"] = {
            key = "17859858673141129416",
            type = "SwitchMechanismStateNode",
            name = "切换机关状态",
            pos = {x = 505.9009534583063, y = 533.4293118646059},
            propsData = {
              StaticCreatorIdList = {2480700},
              ManualItemIdList = {},
              StateId = 11301280,
              QuestId = 0
            }
          },
          ["17859858673141129417"] = {
            key = "17859858673141129417",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 23.493261150613872, y = 319.5716195569135},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2480700}
            }
          },
          ["17859858673141129418"] = {
            key = "17859858673141129418",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1145.6520024093552, y = 321.81462654992055},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2480700}
            }
          },
          ["17859858673141129419"] = {
            key = "17859858673141129419",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 23.497435897435857, y = 106.33162393162392},
            propsData = {
              NewDescription = "Description_400130_2",
              NewDetail = "Content_400130_2",
              SubTaskTargetIndex = 0
            }
          },
          ["17859858673141129420"] = {
            key = "17859858673141129420",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示拍照点的指引",
            pos = {x = 345.37110423116604, y = 94.64706080812905},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = true,
              GuideType = "M",
              GuideName = "Mechanism_TakePhoto_2480700"
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
