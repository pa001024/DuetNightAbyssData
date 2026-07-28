return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177512225275745",
      startPort = "Success",
      endStory = "17751222474025",
      endPort = "StoryEnd"
    },
    {
      startStory = "17751222474021",
      startPort = "StoryStart",
      endStory = "1776673397151226",
      endPort = "In"
    },
    {
      startStory = "1776673397151226",
      startPort = "Success",
      endStory = "1776753730328894",
      endPort = "In"
    },
    {
      startStory = "1776753730328894",
      startPort = "Success",
      endStory = "177512225275745",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17751222474021"] = {
      isStoryNode = true,
      key = "17751222474021",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 200239},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17751222474025"] = {
      isStoryNode = true,
      key = "17751222474025",
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
    ["177512225275745"] = {
      isStoryNode = true,
      key = "177512225275745",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1784, y = 270},
      propsData = {
        QuestId = 20023901,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200239_1",
        QuestDeatil = "Content_200239_1",
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
            startQuest = "177512225275850",
            startPort = "QuestStart",
            endQuest = "177512225275853",
            endPort = "In"
          },
          {
            startQuest = "177512225275853",
            startPort = "Out",
            endQuest = "177512225275854",
            endPort = "In"
          },
          {
            startQuest = "177512225275854",
            startPort = "Out",
            endQuest = "177512225275851",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177512225275850"] = {
            key = "177512225275850",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177512225275851"] = {
            key = "177512225275851",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2332.8571428571427, y = 288.57142857142856},
            propsData = {ModeType = 0}
          },
          ["177512225275852"] = {
            key = "177512225275852",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["177512225275853"] = {
            key = "177512225275853",
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
          ["177512225275854"] = {
            key = "177512225275854",
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
              SubmitId = 20023901
            }
          }
        },
        commentData = {}
      }
    },
    ["1776673397151226"] = {
      isStoryNode = true,
      key = "1776673397151226",
      type = "PreStoryNode",
      name = "接取任务",
      pos = {x = 1316, y = 246.07692307692307},
      propsData = {
        QuestId = 20023900,
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
            startQuest = "1776673397151233",
            startPort = "CancelOut",
            endQuest = "1776673397151232",
            endPort = "Fail"
          },
          {
            startQuest = "1776673397151233",
            startPort = "ApproveOut",
            endQuest = "1776673397151231",
            endPort = "Success"
          },
          {
            startQuest = "1776673397151236",
            startPort = "Out",
            endQuest = "1776673397151233",
            endPort = "Input"
          },
          {
            startQuest = "1776673397151230",
            startPort = "QuestStart",
            endQuest = "1776673397151236",
            endPort = "In"
          },
          {
            startQuest = "1776673397151236",
            startPort = "Fail",
            endQuest = "1776673397151232",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["1776673397151230"] = {
            key = "1776673397151230",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 941.8939393939395, y = 137.3320158102767},
            propsData = {ModeType = 0}
          },
          ["1776673397151231"] = {
            key = "1776673397151231",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2493.766233766234, y = 113.18181818181816},
            propsData = {ModeType = 0}
          },
          ["1776673397151232"] = {
            key = "1776673397151232",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2200, y = 375.45454545454544},
            propsData = {}
          },
          ["1776673397151233"] = {
            key = "1776673397151233",
            type = "ReceiveSideQuestNode",
            name = "支线任务接取节点",
            pos = {x = 1888.1091269841272, y = 121.54872758820136},
            propsData = {
              SideQuestChainId = 200239,
              EnableSequence = true,
              SequencePath = "/Game/UI/Sequence/SQ_Task_DepthField.SQ_Task_DepthField",
              PauseMark = "QuestAccept"
            }
          },
          ["1776673397151236"] = {
            key = "1776673397151236",
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
    ["1776753730328894"] = {
      isStoryNode = true,
      key = "1776753730328894",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1536.587912087912, y = 95.56043956043949},
      propsData = {
        QuestId = 20023902,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200239_2",
        QuestDeatil = "Content_200239_2",
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
            startQuest = "1776753730328899",
            startPort = "QuestStart",
            endQuest = "1776753730328902",
            endPort = "In"
          },
          {
            startQuest = "1776753730328902",
            startPort = "Out",
            endQuest = "1776753730328903",
            endPort = "In"
          },
          {
            startQuest = "1776753730328903",
            startPort = "Success",
            endQuest = "1776753730328900",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1776753730328899"] = {
            key = "1776753730328899",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1776753730328900"] = {
            key = "1776753730328900",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1776753730328901"] = {
            key = "1776753730328901",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1776753730328902"] = {
            key = "1776753730328902",
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
          ["1776753730328903"] = {
            key = "1776753730328903",
            type = "AsyncConditionNode",
            name = "异步等待条件完成",
            pos = {x = 1645.107142857143, y = 291.32142857142844},
            propsData = {ConditionId = 20023901}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
