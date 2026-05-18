return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1732783210610494875",
      startPort = "StoryStart",
      endStory = "1732783210610494877",
      endPort = "In"
    },
    {
      startStory = "1732783210610494877",
      startPort = "Success",
      endStory = "1732783210610494876",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1732783210610494875"] = {
      isStoryNode = true,
      key = "1732783210610494875",
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
    ["1732783210610494876"] = {
      isStoryNode = true,
      key = "1732783210610494876",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1435.111111111111, y = 298.44444444444446},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1732783210610494877"] = {
      isStoryNode = true,
      key = "1732783210610494877",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1102.888888888889, y = 288.44444444444446},
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
            startQuest = "1732783210610494878",
            startPort = "QuestStart",
            endQuest = "17756330438811310",
            endPort = "In"
          },
          {
            startQuest = "17756330438811310",
            startPort = "Out",
            endQuest = "1732783210610494881",
            endPort = "In"
          },
          {
            startQuest = "17756330438811310",
            startPort = "Out",
            endQuest = "1725246375878179820",
            endPort = "In"
          },
          {
            startQuest = "1732783210610494881",
            startPort = "Out",
            endQuest = "17756333381932674084",
            endPort = "In"
          },
          {
            startQuest = "17756333381932674084",
            startPort = "Out",
            endQuest = "1732783210610494879",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1725246375878179820"] = {
            key = "1725246375878179820",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1081.3733133433282, y = 362.32683658170913},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 1,
              SoundType = 0,
              SoundPath = "event:/bgm/cbt01/0016_judian",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {}
            }
          },
          ["1732783210610494878"] = {
            key = "1732783210610494878",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 520.5171842650103, y = 203.85521048999306},
            propsData = {ModeType = 0}
          },
          ["1732783210610494879"] = {
            key = "1732783210610494879",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1687.1363027133054, y = 207.93864007845696},
            propsData = {ModeType = 0}
          },
          ["1732783210610494880"] = {
            key = "1732783210610494880",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1608.0000000000002, y = 418.9},
            propsData = {}
          },
          ["1732783210610494881"] = {
            key = "1732783210610494881",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1081.0519133040875, y = 199.50398031919758},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80260101.80260101'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17756330438811310"] = {
            key = "17756330438811310",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 799.2067348678602, y = 201.43446291560096},
            propsData = {
              ModeType = 1,
              Id = 101106,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17756333381932674084"] = {
            key = "17756333381932674084",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1401.5294117647059, y = 206.00000000000003},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 1,
              SoundType = 0
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
