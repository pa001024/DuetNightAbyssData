return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17643146248561",
      startPort = "StoryStart",
      endStory = "1764314639869116",
      endPort = "In"
    },
    {
      startStory = "1764314639869116",
      startPort = "Success",
      endStory = "17643146248575",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17643146248561"] = {
      isStoryNode = true,
      key = "17643146248561",
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
    ["17643146248575"] = {
      isStoryNode = true,
      key = "17643146248575",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1492, y = 320},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1764314639869116"] = {
      isStoryNode = true,
      key = "1764314639869116",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1128, y = 302},
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
        bIsShowOnComplete = true,
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
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1764314639869117",
            startPort = "QuestStart",
            endQuest = "1764314660694512",
            endPort = "In"
          },
          {
            startQuest = "1764314660694512",
            startPort = "Out",
            endQuest = "1764314639870124",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1764314639869117"] = {
            key = "1764314639869117",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1764314639870124"] = {
            key = "1764314639870124",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1342, y = 298},
            propsData = {ModeType = 0}
          },
          ["1764314639870131"] = {
            key = "1764314639870131",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1764314660694512"] = {
            key = "1764314660694512",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1064, y = 300},
            propsData = {GuideId = 112}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
