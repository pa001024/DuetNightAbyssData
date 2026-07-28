return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17751219662241",
      startPort = "StoryStart",
      endStory = "1776673353925331",
      endPort = "In"
    },
    {
      startStory = "1776673353925331",
      startPort = "Success",
      endStory = "17766830253631645",
      endPort = "In"
    },
    {
      startStory = "17766830253631645",
      startPort = "Success",
      endStory = "177512197041966",
      endPort = "In"
    },
    {
      startStory = "177512197041966",
      startPort = "Success",
      endStory = "17751219662255",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17751219662241"] = {
      isStoryNode = true,
      key = "17751219662241",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1318.75, y = 286.25},
      propsData = {QuestChainId = 200238},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17751219662255"] = {
      isStoryNode = true,
      key = "17751219662255",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2265, y = 296.25},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177512197041966"] = {
      isStoryNode = true,
      key = "177512197041966",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 2074.162162162162, y = 128.27027027027034},
      propsData = {
        QuestId = 20023801,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200238_1",
        QuestDeatil = "Content_200238_1",
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
        SubRegionId = 210101,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Bai_Duanzao",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177512197041971",
            startPort = "QuestStart",
            endQuest = "177512197041974",
            endPort = "In"
          },
          {
            startQuest = "177512197041974",
            startPort = "Out",
            endQuest = "177512197041975",
            endPort = "In"
          },
          {
            startQuest = "177512197041975",
            startPort = "Out",
            endQuest = "177512197041972",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177512197041971"] = {
            key = "177512197041971",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177512197041972"] = {
            key = "177512197041972",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2332.8571428571427, y = 288.57142857142856},
            propsData = {ModeType = 0}
          },
          ["177512197041973"] = {
            key = "177512197041973",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["177512197041974"] = {
            key = "177512197041974",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1252, y = 275.99999999999994},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = true,
              GuideType = "N",
              GuideName = "Npc_Bai_Duanzao"
            }
          },
          ["177512197041975"] = {
            key = "177512197041975",
            type = "SubmitItemNode",
            name = "提交物品",
            pos = {x = 1729.4285714285713, y = 285.71428571428567},
            propsData = {
              AssociatedObjectType = "Npc",
              AssociatedObjectId = 900001,
              InteractionId = 10630,
              bGuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Bai_Duanzao",
              SubmitId = 20023801
            }
          }
        },
        commentData = {}
      }
    },
    ["1776673353925331"] = {
      isStoryNode = true,
      key = "1776673353925331",
      type = "PreStoryNode",
      name = "接取任务",
      pos = {x = 1585.5555555555557, y = 134.6666666666667},
      propsData = {
        QuestId = 20023800,
        QuestDescriptionComment = "",
        SubRegionId = 210101,
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Bai_Duanzao",
        bIsPlayBlackScreenOnComplete = false,
        SubRegionIdList = {}
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1776673353925338",
            startPort = "CancelOut",
            endQuest = "1776673353925337",
            endPort = "Fail"
          },
          {
            startQuest = "1776673353925338",
            startPort = "ApproveOut",
            endQuest = "1776673353925336",
            endPort = "Success"
          },
          {
            startQuest = "1776673353925341",
            startPort = "Out",
            endQuest = "1776673353925338",
            endPort = "Input"
          },
          {
            startQuest = "1776673353925335",
            startPort = "QuestStart",
            endQuest = "1776673353925341",
            endPort = "In"
          },
          {
            startQuest = "1776673353925341",
            startPort = "Fail",
            endQuest = "1776673353925337",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["1776673353925335"] = {
            key = "1776673353925335",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 941.8939393939395, y = 137.3320158102767},
            propsData = {ModeType = 0}
          },
          ["1776673353925336"] = {
            key = "1776673353925336",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2493.766233766234, y = 113.18181818181816},
            propsData = {ModeType = 0}
          },
          ["1776673353925337"] = {
            key = "1776673353925337",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2200, y = 375.45454545454544},
            propsData = {}
          },
          ["1776673353925338"] = {
            key = "1776673353925338",
            type = "ReceiveSideQuestNode",
            name = "支线任务接取节点",
            pos = {x = 1887.0376984126985, y = 121.54872758820136},
            propsData = {
              SideQuestChainId = 200238,
              EnableSequence = true,
              SequencePath = "/Game/UI/Sequence/SQ_Task_DepthField.SQ_Task_DepthField",
              PauseMark = "QuestAccept"
            }
          },
          ["1776673353925341"] = {
            key = "1776673353925341",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1644.3418803418801, y = 215.09890109890117},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 900001,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Bai_Duanzao",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51200334,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
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
              HideMechanismsFX = false,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
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
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17766830253631645"] = {
      isStoryNode = true,
      key = "17766830253631645",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1815.9675324675325, y = 66.42643753295951},
      propsData = {
        QuestId = 20023802,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200238_2",
        QuestDeatil = "Content_200238_2",
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
        SubRegionId = 210101,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Bai_Duanzao",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17766830253631646",
            startPort = "QuestStart",
            endQuest = "17766830731042604",
            endPort = "In"
          },
          {
            startQuest = "17766830731042604",
            startPort = "Out",
            endQuest = "17766830803362745",
            endPort = "In"
          },
          {
            startQuest = "17766830803362745",
            startPort = "Success",
            endQuest = "17766830253641649",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17766830253631646"] = {
            key = "17766830253631646",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17766830253641649"] = {
            key = "17766830253641649",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17766830253641652"] = {
            key = "17766830253641652",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17766830731042604"] = {
            key = "17766830731042604",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1137.4285714285713, y = 276.85714285714283},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = true,
              GuideType = "N",
              GuideName = "Npc_Bai_Duanzao"
            }
          },
          ["17766830803362745"] = {
            key = "17766830803362745",
            type = "AsyncConditionNode",
            name = "异步等待条件完成",
            pos = {x = 1645.107142857143, y = 291.32142857142844},
            propsData = {ConditionId = 20023801}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
