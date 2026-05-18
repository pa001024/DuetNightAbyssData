return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177381632584097",
      startPort = "Success",
      endStory = "17751184978822637967",
      endPort = "In"
    },
    {
      startStory = "17751184978822637967",
      startPort = "Success",
      endStory = "17738159178805",
      endPort = "StoryEnd"
    },
    {
      startStory = "17738159178801",
      startPort = "StoryStart",
      endStory = "1776509299584863",
      endPort = "In"
    },
    {
      startStory = "1776509299584863",
      startPort = "Success",
      endStory = "177381632584097",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17738159178801"] = {
      isStoryNode = true,
      key = "17738159178801",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 200237},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17738159178805"] = {
      isStoryNode = true,
      key = "17738159178805",
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
    ["177381632584097"] = {
      isStoryNode = true,
      key = "177381632584097",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1628, y = 372},
      propsData = {
        QuestId = 20023701,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200237_1",
        QuestDeatil = "Content_200237_1",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = true,
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
        SubRegionId = 210101,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Bai_Duanzao",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177381632584098",
            startPort = "QuestStart",
            endQuest = "1773816426261756",
            endPort = "In"
          },
          {
            startQuest = "1774493725338359",
            startPort = "Out",
            endQuest = "1773816325840106",
            endPort = "Success"
          },
          {
            startQuest = "1773816426261756",
            startPort = "Out",
            endQuest = "1775630962607714",
            endPort = "In"
          },
          {
            startQuest = "1775630962607714",
            startPort = "Out",
            endQuest = "1774493725338359",
            endPort = "In"
          }
        },
        nodeData = {
          ["177381632584098"] = {
            key = "177381632584098",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1773816325840106"] = {
            key = "1773816325840106",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2332.8571428571427, y = 288.57142857142856},
            propsData = {ModeType = 0}
          },
          ["1773816325840114"] = {
            key = "1773816325840114",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1773816426261756"] = {
            key = "1773816426261756",
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
          ["1773816432280930"] = {
            key = "1773816432280930",
            type = "SubmitItemNode",
            name = "提交物品",
            pos = {x = 2418, y = -184.28571428571436},
            propsData = {
              AssociatedObjectType = "Npc",
              AssociatedObjectId = 900001,
              InteractionId = 10630,
              bGuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Bai_Duanzao",
              SubmitId = 20023701
            }
          },
          ["1774493725338359"] = {
            key = "1774493725338359",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1662.706168831169, y = 265.60443722943717},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51200301,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2002/200237/20023701.20023701'",
              TalkType = "QuestImpression",
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
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1775630962607714"] = {
            key = "1775630962607714",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1461.1304347826087, y = 13.744565217391234},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 1210131,
              GuideType = "M",
              GuidePointName = "Mechanism_200237linghua01_1210131"
            }
          }
        },
        commentData = {}
      }
    },
    ["17751184978822637967"] = {
      isStoryNode = true,
      key = "17751184978822637967",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 2002.164031620553, y = 357.0553359683796},
      propsData = {
        QuestId = 20023702,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200237_2",
        QuestDeatil = "Content_200237_2",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = true,
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
        SubRegionId = 210101,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Bai_Duanzao",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17751185218182638765",
            startPort = "Out",
            endQuest = "17751184978822637971",
            endPort = "Success"
          },
          {
            startQuest = "17751184978822637968",
            startPort = "QuestStart",
            endQuest = "17751194645632640785",
            endPort = "In"
          },
          {
            startQuest = "17751194645632640785",
            startPort = "Out",
            endQuest = "17751185218182638764",
            endPort = "In"
          },
          {
            startQuest = "17751185218182638764",
            startPort = "Out",
            endQuest = "17751197084645275547",
            endPort = "In"
          },
          {
            startQuest = "17751185218182638764",
            startPort = "Out",
            endQuest = "17751199759295279245",
            endPort = "In"
          },
          {
            startQuest = "17751197084645275547",
            startPort = "Success",
            endQuest = "17751185218182638765",
            endPort = "Branch_1"
          },
          {
            startQuest = "17751199759295279245",
            startPort = "Success",
            endQuest = "17751185218182638765",
            endPort = "Branch_2"
          }
        },
        nodeData = {
          ["17751184978822637968"] = {
            key = "17751184978822637968",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17751184978822637971"] = {
            key = "17751184978822637971",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17751184978822637974"] = {
            key = "17751184978822637974",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17751185218182638763"] = {
            key = "17751185218182638763",
            type = "ConditionNode",
            name = "条件节点意一次大秘境通关12层且",
            pos = {x = 1314.214285714285, y = -132.49999999999994},
            propsData = {ConditionId = 0}
          },
          ["17751185218182638764"] = {
            key = "17751185218182638764",
            type = "BranchQuestStartNode",
            name = "子任务开始节点",
            pos = {x = 1579.5714285714284, y = 347.14285714285734},
            propsData = {
              AllQuestOptions = {
                {
                  IsNeedFinish = true,
                  BranchQuestName = "Description_200237_3",
                  TargetBranchQuestKey = "17751197084645275547"
                },
                {
                  IsNeedFinish = true,
                  BranchQuestName = "Description_200237_4",
                  TargetBranchQuestKey = "17751199759295279245"
                }
              },
              IsSetCountInfo = true,
              IsDifftation = true,
              AllDiffGuideOptions = {}
            }
          },
          ["17751185218182638765"] = {
            key = "17751185218182638765",
            type = "CheckBranchQuestFinishedNode",
            name = "子任务结束节点",
            pos = {x = 2152.4285714285716, y = 338.5714285714286},
            propsData = {
              InputBranchQuestNumber = 2,
              BranchQuestFinishOptions = {
                {IsNeedFinish = true},
                {IsNeedFinish = true}
              }
            }
          },
          ["17751185218182638766"] = {
            key = "17751185218182638766",
            type = "ConditionNode",
            name = "条件节点有任意一个金色+10的魔之模1",
            pos = {x = 1318.4999999999998, y = 81.78571428571422},
            propsData = {ConditionId = 0}
          },
          ["17751194645632640785"] = {
            key = "17751194645632640785",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1246, y = 309.99999999999994},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = true,
              GuideType = "N",
              GuideName = "Npc_Bai_Duanzao"
            }
          },
          ["17751197015055275450"] = {
            key = "17751197015055275450",
            type = "ConditionNode",
            name = "条件节点",
            pos = {x = 1634.192833306849, y = 50.102335928809765},
            propsData = {ConditionId = 0}
          },
          ["17751197084645275547"] = {
            key = "17751197084645275547",
            type = "AsyncConditionNode",
            name = "异步等待条件完成-任意一次大秘境通关12层",
            pos = {x = 1865.5844589226126, y = 265.2378039091053},
            propsData = {ConditionId = 20023702}
          },
          ["17751199759295279245"] = {
            key = "17751199759295279245",
            type = "AsyncConditionNode",
            name = "异步等待条件完成-任意一个金色+10的魔之楔",
            pos = {x = 1871.434212617194, y = 432.6392817416175},
            propsData = {ConditionId = 20023703}
          }
        },
        commentData = {}
      }
    },
    ["1776509299584863"] = {
      isStoryNode = true,
      key = "1776509299584863",
      type = "PreStoryNode",
      name = "接取任务",
      pos = {x = 1277.6, y = 231.9999999999999},
      propsData = {
        QuestId = 20023700,
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
            startQuest = "1776509299584870",
            startPort = "CancelOut",
            endQuest = "1776509299584869",
            endPort = "Fail"
          },
          {
            startQuest = "1776509299584870",
            startPort = "ApproveOut",
            endQuest = "1776509299584868",
            endPort = "Success"
          },
          {
            startQuest = "17766704000502756088",
            startPort = "Out",
            endQuest = "1776509299584870",
            endPort = "Input"
          },
          {
            startQuest = "1776509299584867",
            startPort = "QuestStart",
            endQuest = "17766704000502756088",
            endPort = "In"
          },
          {
            startQuest = "17766704000502756088",
            startPort = "Fail",
            endQuest = "1776509299584869",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["1776509299584867"] = {
            key = "1776509299584867",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 941.8939393939395, y = 137.3320158102767},
            propsData = {ModeType = 0}
          },
          ["1776509299584868"] = {
            key = "1776509299584868",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2493.766233766234, y = 113.18181818181816},
            propsData = {ModeType = 0}
          },
          ["1776509299584869"] = {
            key = "1776509299584869",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2200, y = 375.45454545454544},
            propsData = {}
          },
          ["1776509299584870"] = {
            key = "1776509299584870",
            type = "ReceiveSideQuestNode",
            name = "支线任务接取节点",
            pos = {x = 1888.1091269841272, y = 121.54872758820136},
            propsData = {
              SideQuestChainId = 200237,
              EnableSequence = true,
              SequencePath = "/Game/UI/Sequence/SQ_Task_DepthField.SQ_Task_DepthField",
              PauseMark = "QuestAccept"
            }
          },
          ["17766704000502756088"] = {
            key = "17766704000502756088",
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
    }
  },
  commentData = {}
}
