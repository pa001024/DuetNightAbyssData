return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17784908538651466460",
      startPort = "StoryStart",
      endStory = "17784908557621466518",
      endPort = "In"
    },
    {
      startStory = "17784908557621466518",
      startPort = "Success",
      endStory = "17784908538651466463",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17784908538651466460"] = {
      isStoryNode = true,
      key = "17784908538651466460",
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
    ["17784908538651466463"] = {
      isStoryNode = true,
      key = "17784908538651466463",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2000, y = 358},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17784908557621466518"] = {
      isStoryNode = true,
      key = "17784908557621466518",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1538, y = 430},
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
            startQuest = "17784908557621466519",
            startPort = "QuestStart",
            endQuest = "17784908647731466779",
            endPort = "In"
          },
          {
            startQuest = "17784908647731466779",
            startPort = "Out",
            endQuest = "17784908557621466522",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17784908557621466519"] = {
            key = "17784908557621466519",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17784908557621466522"] = {
            key = "17784908557621466522",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2190, y = 474},
            propsData = {ModeType = 0}
          },
          ["17784908557621466525"] = {
            key = "17784908557621466525",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17784908647731466779"] = {
            key = "17784908647731466779",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1524, y = 472},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC021/SQ_Ver0104_SC021",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
