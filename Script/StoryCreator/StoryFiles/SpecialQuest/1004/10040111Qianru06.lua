return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177796899431312164223",
      startPort = "StoryStart",
      endStory = "177796899678912164280",
      endPort = "In"
    },
    {
      startStory = "177796899678912164280",
      startPort = "Success",
      endStory = "177796899431312164226",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177796899431312164223"] = {
      isStoryNode = true,
      key = "177796899431312164223",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1154.7826086956522, y = 251.7391304347826},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177796899431312164226"] = {
      isStoryNode = true,
      key = "177796899431312164226",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1911.7391304347825, y = 217.82608695652175},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177796899678912164280"] = {
      isStoryNode = true,
      key = "177796899678912164280",
      type = "StoryNode",
      name = "潜入特殊任务尾声",
      pos = {x = 1542.7688787185355, y = 221.39130434782604},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040109_01",
        QuestDeatil = "Description_10040109_01",
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
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177796899678912164285",
            startPort = "QuestStart",
            endQuest = "177796904557613100682",
            endPort = "In"
          },
          {
            startQuest = "177796904557613100682",
            startPort = "Out",
            endQuest = "177796899678912164287",
            endPort = "Fail"
          },
          {
            startQuest = "177796899678912164285",
            startPort = "QuestStart",
            endQuest = "177796905098413100838",
            endPort = "In"
          },
          {
            startQuest = "177815740932125596719",
            startPort = "Out",
            endQuest = "177796901736012164836",
            endPort = "In"
          },
          {
            startQuest = "177796899678912164285",
            startPort = "QuestStart",
            endQuest = "177815740932125596719",
            endPort = "In"
          },
          {
            startQuest = "177796899678912164285",
            startPort = "QuestStart",
            endQuest = "1779718543146279",
            endPort = "In"
          }
        },
        nodeData = {
          ["177796899678912164285"] = {
            key = "177796899678912164285",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -77.32519738326182, y = 327.8181818181818},
            propsData = {ModeType = 0}
          },
          ["177796899678912164286"] = {
            key = "177796899678912164286",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1901.3164110083471, y = 329.7187232122715},
            propsData = {ModeType = 0}
          },
          ["177796899678912164287"] = {
            key = "177796899678912164287",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 638.1487179487177, y = 667.1897435897436},
            propsData = {}
          },
          ["177796901736012164836"] = {
            key = "177796901736012164836",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 799.7026772247364, y = 234.78619909502248},
            propsData = {}
          },
          ["177796904557613100682"] = {
            key = "177796904557613100682",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 258.6827116830316, y = 661.0274578362812},
            propsData = {}
          },
          ["177796905098413100838"] = {
            key = "177796905098413100838",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 272.52886552918534, y = 487.9505347593581},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177815740932125596719"] = {
            key = "177815740932125596719",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 309.12753036437226, y = 262.331983805668},
            propsData = {
              StaticCreatorId = 272890097,
              UnitId = 10092,
              bGuideUIEnable = true,
              GuidePointName = "BP_DixiaGotoYT",
              LongPressTime = 0,
              MontageName = "",
              bFocusEnable = false,
              SequencePath = ""
            }
          },
          ["1779718543146279"] = {
            key = "1779718543146279",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 129.4021767705981, y = 136.542624042624},
            propsData = {
              VarName = "FirstStateQianru10040106",
              VarValue = 1
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
