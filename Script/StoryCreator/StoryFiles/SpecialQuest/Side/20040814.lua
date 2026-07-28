return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1782204109792985182",
      startPort = "StoryStart",
      endStory = "1782204109792985184",
      endPort = "In"
    },
    {
      startStory = "1782204109792985184",
      startPort = "Success",
      endStory = "1782204109792985183",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1782204109792985182"] = {
      isStoryNode = true,
      key = "1782204109792985182",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1670.7857142857142, y = 326.15714285714284},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1782204109792985183"] = {
      isStoryNode = true,
      key = "1782204109792985183",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2353.4285714285716, y = 306.3},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1782204109792985184"] = {
      isStoryNode = true,
      key = "1782204109792985184",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 2013.9853174603174, y = 312.43571428571425},
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestRegion_152480434",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1782204109792985216",
            startPort = "QuestStart",
            endQuest = "1782214663510469",
            endPort = "In"
          },
          {
            startQuest = "1782214663510469",
            startPort = "Out",
            endQuest = "1782204109792985218",
            endPort = "Fail"
          },
          {
            startQuest = "1782204109792985216",
            startPort = "QuestStart",
            endQuest = "17822146793511058",
            endPort = "In"
          },
          {
            startQuest = "17822146793511058",
            startPort = "Out",
            endQuest = "17822146841431190",
            endPort = "In"
          },
          {
            startQuest = "17822146841431190",
            startPort = "Out",
            endQuest = "1783438661347300",
            endPort = "In"
          },
          {
            startQuest = "1783438661347300",
            startPort = "Out",
            endQuest = "1782214656063354",
            endPort = "In"
          }
        },
        nodeData = {
          ["1782204109792985216"] = {
            key = "1782204109792985216",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -430.610319627962, y = 151.9551930316675},
            propsData = {ModeType = 0}
          },
          ["1782204109792985217"] = {
            key = "1782204109792985217",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1266.3511333028005, y = -163.1744812698551},
            propsData = {ModeType = 0}
          },
          ["1782204109792985218"] = {
            key = "1782204109792985218",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1536.4285714285697, y = 805.7142857142859},
            propsData = {}
          },
          ["1782214656063354"] = {
            key = "1782214656063354",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 934.8947890254137, y = 108.59834249977264},
            propsData = {}
          },
          ["1782214663510469"] = {
            key = "1782214663510469",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 569.0080106101102, y = 674.2717990046028},
            propsData = {}
          },
          ["17822146793511058"] = {
            key = "17822146793511058",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = -78.50703157025936, y = 66.37518146861132},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                242480645,
                242480646,
                242480647,
                242480648,
                242480649,
                242480650,
                242480651,
                242480652,
                242480653,
                242480654,
                242480655
              }
            }
          },
          ["17822146841431190"] = {
            key = "17822146841431190",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 286.6358255725977, y = 95.51803861146846},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 11,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                242480645,
                242480646,
                242480647,
                242480648,
                242480649,
                242480650,
                242480651,
                242480652,
                242480653,
                242480654,
                242480655
              }
            }
          },
          ["1783438661347300"] = {
            key = "1783438661347300",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 551.6608617131063, y = 181.5222983930414},
            propsData = {WaitTime = 2}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
