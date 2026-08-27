return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17730375390233285353",
      startPort = "StoryStart",
      endStory = "17730375406313285415",
      endPort = "In"
    },
    {
      startStory = "17730375406313285415",
      startPort = "Success",
      endStory = "17730375390233285356",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17730375390233285353"] = {
      isStoryNode = true,
      key = "17730375390233285353",
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
    ["17730375390233285356"] = {
      isStoryNode = true,
      key = "17730375390233285356",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1368, y = 306},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17730375406313285415"] = {
      isStoryNode = true,
      key = "17730375406313285415",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1092, y = 308},
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
            startQuest = "17731442507236771702",
            startPort = "Out",
            endQuest = "17730375406313285419",
            endPort = "Success"
          },
          {
            startQuest = "17730375406313285416",
            startPort = "QuestStart",
            endQuest = "17736618156576515607",
            endPort = "In"
          },
          {
            startQuest = "17736618156576515607",
            startPort = "Out",
            endQuest = "1773740183423401",
            endPort = "Input"
          },
          {
            startQuest = "17839321126113309357",
            startPort = "Out",
            endQuest = "17731442507236771702",
            endPort = "In"
          },
          {
            startQuest = "17736618156576515607",
            startPort = "Out",
            endQuest = "17839321126113309357",
            endPort = "In"
          }
        },
        nodeData = {
          ["17730375406313285416"] = {
            key = "17730375406313285416",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17730375406313285419"] = {
            key = "17730375406313285419",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1970.4615384615386, y = 320.25961538461536},
            propsData = {ModeType = 0}
          },
          ["17730375406313285422"] = {
            key = "17730375406313285422",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17731442507236771702"] = {
            key = "17731442507236771702",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1602.1487351657631, y = 312.16307544364827},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80240201.80240201'",
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
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = true,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
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
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17736618156576515607"] = {
            key = "17736618156576515607",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1086.907894736842, y = 308.54605263157896},
            propsData = {
              ModeType = 1,
              Id = 104503,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1773740183423401"] = {
            key = "1773740183423401",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1361.241968557758, y = 510.57795055821373},
            propsData = {
              TargetTime = 24,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17839321126113309357"] = {
            key = "17839321126113309357",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1354.1254940711465, y = 314.18475432695055},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 80240201,
              FlowAssetPath = "",
              TalkType = "Black",
              BlendInTime = 0,
              BlendOutTime = 0,
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              ForceAutoPlay = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
              FreezeWorldComposition = false,
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
