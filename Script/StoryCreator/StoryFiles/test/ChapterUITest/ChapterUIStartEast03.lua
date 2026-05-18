return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17769481454811836359",
      startPort = "StoryStart",
      endStory = "17769481454811836361",
      endPort = "In"
    },
    {
      startStory = "17769481454811836361",
      startPort = "Success",
      endStory = "17769481454811836360",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17769481454811836359"] = {
      isStoryNode = true,
      key = "17769481454811836359",
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
    ["17769481454811836360"] = {
      isStoryNode = true,
      key = "17769481454811836360",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1670, y = 306},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17769481454811836361"] = {
      isStoryNode = true,
      key = "17769481454811836361",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1194, y = 280},
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
            startQuest = "17769481454811836362",
            startPort = "QuestStart",
            endQuest = "17769481454811836365",
            endPort = "In"
          },
          {
            startQuest = "17769481454811836365",
            startPort = "Out",
            endQuest = "17769481454811836366",
            endPort = "In"
          },
          {
            startQuest = "17769481454811836366",
            startPort = "Out",
            endQuest = "17769481454811836363",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17769481454811836362"] = {
            key = "17769481454811836362",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 940, y = 296},
            propsData = {ModeType = 0}
          },
          ["17769481454811836363"] = {
            key = "17769481454811836363",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2028, y = 292},
            propsData = {ModeType = 0}
          },
          ["17769481454811836364"] = {
            key = "17769481454811836364",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17769481454811836365"] = {
            key = "17769481454811836365",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1302, y = 280},
            propsData = {WaitTime = 1}
          },
          ["17769481454811836366"] = {
            key = "17769481454811836366",
            type = "OpenChapterUINode",
            name = "打开章节开始UI",
            pos = {x = 1650, y = 296},
            propsData = {ChapterUIId = 120301, UIType = "Start"}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
