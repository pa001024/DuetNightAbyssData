return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1787034085831998",
      startPort = "StoryStart",
      endStory = "17870342759702664",
      endPort = "In"
    },
    {
      startStory = "17870342759702664",
      startPort = "Success",
      endStory = "17870340858321001",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1787034085831998"] = {
      isStoryNode = true,
      key = "1787034085831998",
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
    ["17870340858321001"] = {
      isStoryNode = true,
      key = "17870340858321001",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1549.7142857142858, y = 295.7142857142857},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17870342759702664"] = {
      isStoryNode = true,
      key = "17870342759702664",
      type = "StoryNode",
      name = "酒馆&秘密基地",
      pos = {x = 1154.857142857143, y = 281.7142857142856},
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
            startQuest = "17870342759702665",
            startPort = "QuestStart",
            endQuest = "1787040736117893",
            endPort = "In"
          },
          {
            startQuest = "17870342759702665",
            startPort = "QuestStart",
            endQuest = "17870434251664367",
            endPort = "In"
          },
          {
            startQuest = "17870424523693387",
            startPort = "Out",
            endQuest = "17870556504328468",
            endPort = "In"
          },
          {
            startQuest = "17870434251664367",
            startPort = "Out",
            endQuest = "17870424523693387",
            endPort = "In"
          },
          {
            startQuest = "17870424523693387",
            startPort = "Out",
            endQuest = "17885779281971811",
            endPort = "In"
          },
          {
            startQuest = "17885779281971811",
            startPort = "Out",
            endQuest = "17883445011881132940",
            endPort = "In"
          },
          {
            startQuest = "17883445011881132940",
            startPort = "Out",
            endQuest = "17901699950383582",
            endPort = "In"
          },
          {
            startQuest = "1787040736117893",
            startPort = "Out",
            endQuest = "17870342759702671",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17870342759702665"] = {
            key = "17870342759702665",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 650.3836898395722, y = 283.9572192513368},
            propsData = {ModeType = 0}
          },
          ["17870342759702668"] = {
            key = "17870342759702668",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2164.4923492400285, y = 469.8035205248827},
            propsData = {ModeType = 0}
          },
          ["17870342759702671"] = {
            key = "17870342759702671",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1318.066351212838, y = 482.396763483148},
            propsData = {}
          },
          ["1787040736117893"] = {
            key = "1787040736117893",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 991.0786134230409, y = 467.2692526771473},
            propsData = {}
          },
          ["17870424523693387"] = {
            key = "17870424523693387",
            type = "TalkNode",
            name = "对话卡米拉",
            pos = {x = 1259.108886521115, y = 277.7190871563935},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 200003,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Kamila120701_351220211",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070001,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120701/12070101.12070101'",
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
              HideNpcs = true,
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
          ["17870434251664367"] = {
            key = "17870434251664367",
            type = "ChangeRoleNode",
            name = "切换SP黎瑟",
            pos = {x = 982.5387566509851, y = 285.67687936418577},
            propsData = {QuestRoleId = 41030101, IsPlayFX = false}
          },
          ["17870556504328468"] = {
            key = "17870556504328468",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务栏-前往基地",
            pos = {x = 1596.74294135517, y = 131.27163123067683},
            propsData = {
              NewDescription = "Description_120701_2",
              NewDetail = "Content_120701_2",
              SubTaskTargetIndex = 0
            }
          },
          ["17883445011881132940"] = {
            key = "17883445011881132940",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1881.3686868686868, y = 274.2423364075536},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_ScerRestart_1207",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17885779281971811"] = {
            key = "17885779281971811",
            type = "GoToNode",
            name = "前往酒馆门口",
            pos = {x = 1587.3744719332954, y = 275.8910054495096},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351220222,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351220222"
            }
          },
          ["17901699950383582"] = {
            key = "17901699950383582",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2167.199335107619, y = 279.46145448119154},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
