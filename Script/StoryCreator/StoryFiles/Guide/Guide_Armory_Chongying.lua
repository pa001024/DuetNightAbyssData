return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17890275782043441951",
      startPort = "StoryStart",
      endStory = "17890275798513441981",
      endPort = "In"
    },
    {
      startStory = "17890275798513441981",
      startPort = "Success",
      endStory = "17890275782043441954",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17890275782043441951"] = {
      isStoryNode = true,
      key = "17890275782043441951",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17890275782043441954"] = {
      isStoryNode = true,
      key = "17890275782043441954",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2204, y = 402},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17890275798513441981"] = {
      isStoryNode = true,
      key = "17890275798513441981",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1422, y = 296},
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
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17890275873403442231",
            startPort = "Out",
            endQuest = "17890275798523441985",
            endPort = "Success"
          },
          {
            startQuest = "17890275798513441982",
            startPort = "QuestStart",
            endQuest = "178912394418714901216",
            endPort = "In"
          },
          {
            startQuest = "178912394418714901216",
            startPort = "Out",
            endQuest = "17890275873403442231",
            endPort = "In"
          }
        },
        nodeData = {
          ["17890275798513441982"] = {
            key = "17890275798513441982",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17890275798523441985"] = {
            key = "17890275798523441985",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2112, y = 346},
            propsData = {ModeType = 0}
          },
          ["17890275798523441988"] = {
            key = "17890275798523441988",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17890275873403442231"] = {
            key = "17890275873403442231",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1364, y = 310},
            propsData = {GuideId = 164}
          },
          ["178912394418714901216"] = {
            key = "178912394418714901216",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1068, y = 286},
            propsData = {WaitTime = 2}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
