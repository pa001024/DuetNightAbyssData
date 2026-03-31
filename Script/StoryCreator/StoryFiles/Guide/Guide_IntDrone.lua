return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17745449832711",
      startPort = "StoryStart",
      endStory = "1774544998304123",
      endPort = "In"
    },
    {
      startStory = "1774544998304123",
      startPort = "Success",
      endStory = "17745449832725",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17745449832711"] = {
      isStoryNode = true,
      key = "17745449832711",
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
    ["17745449832725"] = {
      isStoryNode = true,
      key = "17745449832725",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2800, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1774544998304123"] = {
      isStoryNode = true,
      key = "1774544998304123",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1668, y = 248},
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
        IsBacktrack = false,
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1774544998304124",
            startPort = "QuestStart",
            endQuest = "1774545009464471",
            endPort = "In"
          },
          {
            startQuest = "1774545009464471",
            startPort = "Out",
            endQuest = "1774544998304132",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1774544998304124"] = {
            key = "1774544998304124",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1774544998304132"] = {
            key = "1774544998304132",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1774544998305140"] = {
            key = "1774544998305140",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1774545009464471"] = {
            key = "1774545009464471",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1692, y = 398},
            propsData = {GuideId = 128}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
