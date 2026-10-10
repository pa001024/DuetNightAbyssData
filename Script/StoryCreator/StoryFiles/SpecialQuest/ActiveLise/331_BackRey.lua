return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17901695652643431377",
      startPort = "StoryStart",
      endStory = "17901695676953431476",
      endPort = "In"
    },
    {
      startStory = "17901695676953431476",
      startPort = "Success",
      endStory = "17901695652643431380",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17901695652643431377"] = {
      isStoryNode = true,
      key = "17901695652643431377",
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
    ["17901695652643431380"] = {
      isStoryNode = true,
      key = "17901695652643431380",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1666, y = 284},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17901695676953431476"] = {
      isStoryNode = true,
      key = "17901695676953431476",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1220, y = 286},
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
            startQuest = "1790174002077240",
            startPort = "Out",
            endQuest = "1790174002077241",
            endPort = "In"
          },
          {
            startQuest = "1790174002077241",
            startPort = "Out",
            endQuest = "1790174017733785",
            endPort = "In"
          },
          {
            startQuest = "17901695676953431477",
            startPort = "QuestStart",
            endQuest = "1790174049567985",
            endPort = "In"
          },
          {
            startQuest = "1790174049567985",
            startPort = "Out",
            endQuest = "1790174002077240",
            endPort = "In"
          },
          {
            startQuest = "17901695676953431477",
            startPort = "QuestStart",
            endQuest = "1790174049567986",
            endPort = "In"
          },
          {
            startQuest = "1790174049567986",
            startPort = "Out",
            endQuest = "17901695676953431483",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17901695676953431477"] = {
            key = "17901695676953431477",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 816, y = 406},
            propsData = {ModeType = 0}
          },
          ["17901695676953431480"] = {
            key = "17901695676953431480",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2046.25, y = 559.5},
            propsData = {ModeType = 0}
          },
          ["17901695676953431483"] = {
            key = "17901695676953431483",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1423.2934782608697, y = 624.5326086956521},
            propsData = {}
          },
          ["1790174002077240"] = {
            key = "1790174002077240",
            type = "ChangeStaticCreatorNode",
            name = "生成酒馆门口蕾伊",
            pos = {x = 1430.1418660436484, y = 425.47047823999674},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351192099}
            }
          },
          ["1790174002077241"] = {
            key = "1790174002077241",
            type = "TalkNode",
            name = "回复蕾伊",
            pos = {x = 1724.1418660436484, y = 414.97047823999674},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 260017,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_ReyOut120703_351192099",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070342,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120703/12070306.12070306'",
              TalkType = "FixSimpleNew",
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
              HideMechanismsFX = false,
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
          ["1790174017733785"] = {
            key = "1790174017733785",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2046, y = 407.99999999999994},
            propsData = {}
          },
          ["1790174049567985"] = {
            key = "1790174049567985",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1129.8368245027282, y = 423.88329519450804},
            propsData = {QuestRoleId = 41030101, IsPlayFX = false}
          },
          ["1790174049567986"] = {
            key = "1790174049567986",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1133.282168632283, y = 608.3192219679634},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
