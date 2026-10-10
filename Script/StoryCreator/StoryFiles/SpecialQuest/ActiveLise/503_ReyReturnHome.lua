return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178703520721313440955",
      startPort = "StoryStart",
      endStory = "178703521010813441056",
      endPort = "In"
    },
    {
      startStory = "178703521010813441056",
      startPort = "Success",
      endStory = "178703520721313440958",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178703520721313440955"] = {
      isStoryNode = true,
      key = "178703520721313440955",
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
    ["178703520721313440958"] = {
      isStoryNode = true,
      key = "178703520721313440958",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1564, y = 294},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178703521010813441056"] = {
      isStoryNode = true,
      key = "178703521010813441056",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1180, y = 282},
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
            startQuest = "178703521010913441061",
            startPort = "QuestStart",
            endQuest = "178738918497021505031",
            endPort = "In"
          },
          {
            startQuest = "178703521010913441061",
            startPort = "QuestStart",
            endQuest = "178738921675421505502",
            endPort = "In"
          },
          {
            startQuest = "178738939252621507848",
            startPort = "Out",
            endQuest = "178738936884821507479",
            endPort = "In"
          },
          {
            startQuest = "178738936884821507479",
            startPort = "Out",
            endQuest = "178738943523721508624",
            endPort = "In"
          },
          {
            startQuest = "178738943523721508624",
            startPort = "Out",
            endQuest = "178738920830721505296",
            endPort = "In"
          },
          {
            startQuest = "178738918497021505031",
            startPort = "Out",
            endQuest = "178738939252621507848",
            endPort = "In"
          },
          {
            startQuest = "178738921675421505502",
            startPort = "Out",
            endQuest = "178703521010913441063",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["178703521010913441061"] = {
            key = "178703521010913441061",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1062.1739130434783, y = 306.5217391304348},
            propsData = {ModeType = 0}
          },
          ["178703521010913441062"] = {
            key = "178703521010913441062",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2527.6, y = 446.4},
            propsData = {ModeType = 0}
          },
          ["178703521010913441063"] = {
            key = "178703521010913441063",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1664.1217391304347, y = 501.5652173913043},
            propsData = {}
          },
          ["178738918497021505031"] = {
            key = "178738918497021505031",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1354.03273657289, y = 308.3805626598464},
            propsData = {QuestRoleId = 41030101, IsPlayFX = false}
          },
          ["178738920830721505296"] = {
            key = "178738920830721505296",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2528.964705882353, y = 286.3294117647057},
            propsData = {}
          },
          ["178738921675421505502"] = {
            key = "178738921675421505502",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1369.0158567774938, y = 488.92992327365715},
            propsData = {}
          },
          ["178738936884821507479"] = {
            key = "178738936884821507479",
            type = "GoToNode",
            name = "前往柯芮身边",
            pos = {x = 1944.9803844067276, y = 291.3507168875454},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351192105,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351192105"
            }
          },
          ["178738939252621507848"] = {
            key = "178738939252621507848",
            type = "ChangeStaticCreatorNode",
            name = "生成柯芮",
            pos = {x = 1654.5803844067273, y = 304.55071688754526},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351192104}
            }
          },
          ["178738943523721508624"] = {
            key = "178738943523721508624",
            type = "TalkNode",
            name = "蕾伊回家",
            pos = {x = 2238.9803844067274, y = 287.75071688754537},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070653,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120705/12070506.12070506'",
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
