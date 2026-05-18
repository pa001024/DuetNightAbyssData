return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177772034007213086548",
      startPort = "StoryStart",
      endStory = "177772034494613086621",
      endPort = "In"
    },
    {
      startStory = "177772034494613086621",
      startPort = "Success",
      endStory = "177772034007313086551",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177772034007213086548"] = {
      isStoryNode = true,
      key = "177772034007213086548",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1325, y = 285},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177772034007313086551"] = {
      isStoryNode = true,
      key = "177772034007313086551",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2408.3333333333335, y = 326.6666666666667},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177772034494613086621"] = {
      isStoryNode = true,
      key = "177772034494613086621",
      type = "StoryNode",
      name = "炮台玩法",
      pos = {x = 1966, y = 294},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040501_02",
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
        SubRegionId = 106101,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_paotai_172640002",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177772034494713086626",
            startPort = "QuestStart",
            endQuest = "177772034494713086629",
            endPort = "In"
          },
          {
            startQuest = "177772034494713086629",
            startPort = "Out",
            endQuest = "177772034494713086631",
            endPort = "In"
          },
          {
            startQuest = "177772034494713086626",
            startPort = "QuestStart",
            endQuest = "177772034494713086630",
            endPort = "In"
          },
          {
            startQuest = "177772034494713086626",
            startPort = "QuestStart",
            endQuest = "177772034494713086632",
            endPort = "In"
          },
          {
            startQuest = "177772034494713086626",
            startPort = "QuestStart",
            endQuest = "177772121828619627964",
            endPort = "In"
          },
          {
            startQuest = "177772121828619627964",
            startPort = "Out",
            endQuest = "177772034494713086628",
            endPort = "Fail"
          },
          {
            startQuest = "177772034494713086629",
            startPort = "Out",
            endQuest = "1778840503576600",
            endPort = "In"
          },
          {
            startQuest = "1778840503576600",
            startPort = "Out",
            endQuest = "1778840521428998",
            endPort = "In"
          },
          {
            startQuest = "177772034494713086631",
            startPort = "Out",
            endQuest = "1778840569800965840",
            endPort = "In"
          },
          {
            startQuest = "1778840569800965840",
            startPort = "Out",
            endQuest = "177772122678019628237",
            endPort = "In"
          }
        },
        nodeData = {
          ["177772034494713086626"] = {
            key = "177772034494713086626",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 663.6876725327812, y = 304.1062801932367},
            propsData = {ModeType = 0}
          },
          ["177772034494713086627"] = {
            key = "177772034494713086627",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1896.8251811594205, y = 332.6539855072464},
            propsData = {ModeType = 0}
          },
          ["177772034494713086628"] = {
            key = "177772034494713086628",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2344.705882352941, y = 567.6470588235294},
            propsData = {}
          },
          ["177772034494713086629"] = {
            key = "177772034494713086629",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "将玩家设置在车顶",
            pos = {x = 978.4230932597868, y = 308.09036796536793},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_TrainPaotaiStart",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177772034494713086630"] = {
            key = "177772034494713086630",
            type = "SendMessageNode",
            name = "开始炮台玩法",
            pos = {x = 885.8290265826605, y = 29.202963671930036},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "YWPaotaiStart",
              UnitId = -1
            }
          },
          ["177772034494713086631"] = {
            key = "177772034494713086631",
            type = "BossBattleFinishNode",
            name = "炮台玩法完成",
            pos = {x = 1338.971195652174, y = 301.39482265446225},
            propsData = {
              SendMessage = "",
              FinishCondition = "YWPaotaiSuccess"
            }
          },
          ["177772034494713086632"] = {
            key = "177772034494713086632",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1052.4991678801748, y = 598.1487414187643},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177772121828619627964"] = {
            key = "177772121828619627964",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1867.7620137299773, y = 521.0480549199084},
            propsData = {}
          },
          ["177772122678019628237"] = {
            key = "177772122678019628237",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 1923.6141105495662, y = 163.505788127608},
            propsData = {}
          },
          ["1778840503576600"] = {
            key = "1778840503576600",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = 1236.1674641148325, y = 122.82177033492819},
            propsData = {
              SendMessage = "",
              FinishCondition = "YWPaotaiInteract"
            }
          },
          ["1778840521428998"] = {
            key = "1778840521428998",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1611.1674641148325, y = 54.639952153110016},
            propsData = {
              NewDescription = "Content_10040501_02",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["1778840569800965840"] = {
            key = "1778840569800965840",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1651.2482721956405, y = 266.0944976076554},
            propsData = {WaitTime = 2}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
