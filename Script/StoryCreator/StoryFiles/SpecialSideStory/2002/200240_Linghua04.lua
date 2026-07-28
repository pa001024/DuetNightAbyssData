return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1775122313936104",
      startPort = "Success",
      endStory = "17751223011755",
      endPort = "StoryEnd"
    },
    {
      startStory = "17751223011741",
      startPort = "StoryStart",
      endStory = "1776673439718212",
      endPort = "In"
    },
    {
      startStory = "1776673439718212",
      startPort = "Success",
      endStory = "17767538055061384013",
      endPort = "In"
    },
    {
      startStory = "17767538055061384013",
      startPort = "Success",
      endStory = "1775122313936104",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17751223011741"] = {
      isStoryNode = true,
      key = "17751223011741",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 200240},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17751223011755"] = {
      isStoryNode = true,
      key = "17751223011755",
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
    ["1775122313936104"] = {
      isStoryNode = true,
      key = "1775122313936104",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1714, y = 274},
      propsData = {
        QuestId = 20024001,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200240_1",
        QuestDeatil = "Content_200240_1",
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
            startQuest = "1775122313936109",
            startPort = "QuestStart",
            endQuest = "1775122313936112",
            endPort = "In"
          },
          {
            startQuest = "1775122313936112",
            startPort = "Out",
            endQuest = "1775122313936113",
            endPort = "In"
          },
          {
            startQuest = "1775122313936113",
            startPort = "Out",
            endQuest = "1775122313936110",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1775122313936109"] = {
            key = "1775122313936109",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1775122313936110"] = {
            key = "1775122313936110",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2332.8571428571427, y = 288.57142857142856},
            propsData = {ModeType = 0}
          },
          ["1775122313936111"] = {
            key = "1775122313936111",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1775122313936112"] = {
            key = "1775122313936112",
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
          ["1775122313936113"] = {
            key = "1775122313936113",
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
              SubmitId = 20024001
            }
          }
        },
        commentData = {}
      }
    },
    ["1776673439718212"] = {
      isStoryNode = true,
      key = "1776673439718212",
      type = "PreStoryNode",
      name = "接取任务",
      pos = {x = 1323.1428571428569, y = 288.57142857142856},
      propsData = {
        QuestId = 20024000,
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
            startQuest = "1776673439718219",
            startPort = "CancelOut",
            endQuest = "1776673439718218",
            endPort = "Fail"
          },
          {
            startQuest = "1776673439718219",
            startPort = "ApproveOut",
            endQuest = "1776673439718217",
            endPort = "Success"
          },
          {
            startQuest = "1776673439718222",
            startPort = "Out",
            endQuest = "1776673439718219",
            endPort = "Input"
          },
          {
            startQuest = "1776673439718216",
            startPort = "QuestStart",
            endQuest = "1776673439718222",
            endPort = "In"
          },
          {
            startQuest = "1776673439718222",
            startPort = "Fail",
            endQuest = "1776673439718218",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["1776673439718216"] = {
            key = "1776673439718216",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 941.8939393939395, y = 137.3320158102767},
            propsData = {ModeType = 0}
          },
          ["1776673439718217"] = {
            key = "1776673439718217",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2493.766233766234, y = 113.18181818181816},
            propsData = {ModeType = 0}
          },
          ["1776673439718218"] = {
            key = "1776673439718218",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2200, y = 375.45454545454544},
            propsData = {}
          },
          ["1776673439718219"] = {
            key = "1776673439718219",
            type = "ReceiveSideQuestNode",
            name = "支线任务接取节点",
            pos = {x = 1886.955280830281, y = 121.54872758820136},
            propsData = {
              SideQuestChainId = 200240,
              EnableSequence = true,
              SequencePath = "/Game/UI/Sequence/SQ_Task_DepthField.SQ_Task_DepthField",
              PauseMark = "QuestAccept"
            }
          },
          ["1776673439718222"] = {
            key = "1776673439718222",
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
    ["17767538055061384013"] = {
      isStoryNode = true,
      key = "17767538055061384013",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1524.9108219366838, y = 74.25807382272868},
      propsData = {
        QuestId = 20024002,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200240_2",
        QuestDeatil = "Content_200240_2",
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
            startQuest = "17767538055061384018",
            startPort = "QuestStart",
            endQuest = "17767538055061384021",
            endPort = "In"
          },
          {
            startQuest = "17767538055061384021",
            startPort = "Out",
            endQuest = "17767538055061384022",
            endPort = "In"
          },
          {
            startQuest = "17767538055061384022",
            startPort = "Success",
            endQuest = "17767538055061384019",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17767538055061384018"] = {
            key = "17767538055061384018",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17767538055061384019"] = {
            key = "17767538055061384019",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17767538055061384020"] = {
            key = "17767538055061384020",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17767538055061384021"] = {
            key = "17767538055061384021",
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
          ["17767538055061384022"] = {
            key = "17767538055061384022",
            type = "AsyncConditionNode",
            name = "异步等待条件完成",
            pos = {x = 1645.107142857143, y = 291.32142857142844},
            propsData = {ConditionId = 20024001}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
