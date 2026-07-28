return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17802956959821",
      startPort = "StoryStart",
      endStory = "1780295709942164",
      endPort = "In"
    },
    {
      startStory = "1780295709942164",
      startPort = "Success",
      endStory = "1780295715710333",
      endPort = "In"
    },
    {
      startStory = "1780295715710333",
      startPort = "Success",
      endStory = "17802956959835",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17802956959821"] = {
      isStoryNode = true,
      key = "17802956959821",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 123456},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17802956959835"] = {
      isStoryNode = true,
      key = "17802956959835",
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
    ["1780295709942164"] = {
      isStoryNode = true,
      key = "1780295709942164",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1548, y = 234},
      propsData = {
        QuestId = 12345601,
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
            startQuest = "1780295709942165",
            startPort = "QuestStart",
            endQuest = "17802966780251447264",
            endPort = "In"
          },
          {
            startQuest = "17802966780251447264",
            startPort = "Out",
            endQuest = "1780295709943173",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1780295709942165"] = {
            key = "1780295709942165",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1780295709943173"] = {
            key = "1780295709943173",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1780295709943181"] = {
            key = "1780295709943181",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17802966780251447264"] = {
            key = "17802966780251447264",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1522, y = 136},
            propsData = {WaitTime = 999}
          }
        },
        commentData = {}
      }
    },
    ["1780295715710333"] = {
      isStoryNode = true,
      key = "1780295715710333",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 2132, y = 568},
      propsData = {
        QuestId = 12345602,
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
            startQuest = "1780295715710334",
            startPort = "QuestStart",
            endQuest = "1780295715710337",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1780295715710334"] = {
            key = "1780295715710334",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1780295715710337"] = {
            key = "1780295715710337",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1780295715711340"] = {
            key = "1780295715711340",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
