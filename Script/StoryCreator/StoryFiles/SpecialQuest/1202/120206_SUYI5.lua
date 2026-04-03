return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1772421504262707368",
      startPort = "StoryStart",
      endStory = "1772421504262707370",
      endPort = "In"
    },
    {
      startStory = "1772421504262707370",
      startPort = "Success",
      endStory = "1772421504262707369",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1772421504262707368"] = {
      isStoryNode = true,
      key = "1772421504262707368",
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
    ["1772421504262707369"] = {
      isStoryNode = true,
      key = "1772421504262707369",
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
    ["1772421504262707370"] = {
      isStoryNode = true,
      key = "1772421504262707370",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1372, y = 352},
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
            startQuest = "1772421504262707371",
            startPort = "QuestStart",
            endQuest = "1772421504262707376",
            endPort = "In"
          },
          {
            startQuest = "17724330598334753424",
            startPort = "Out",
            endQuest = "17724330789184753922",
            endPort = "Input_1"
          },
          {
            startQuest = "17724330598334753425",
            startPort = "Out",
            endQuest = "17724330789184753922",
            endPort = "Input_2"
          },
          {
            startQuest = "17724330598334753426",
            startPort = "Out",
            endQuest = "17724330789184753922",
            endPort = "Input_3"
          },
          {
            startQuest = "1772421504262707371",
            startPort = "QuestStart",
            endQuest = "17724330962054754429",
            endPort = "In"
          },
          {
            startQuest = "1772421504262707376",
            startPort = "Out",
            endQuest = "1772716676920818778",
            endPort = "In"
          },
          {
            startQuest = "1772716676920818778",
            startPort = "Out",
            endQuest = "17724330598334753424",
            endPort = "In"
          },
          {
            startQuest = "1772716676920818778",
            startPort = "Out",
            endQuest = "17724330598334753425",
            endPort = "In"
          },
          {
            startQuest = "1772716676920818778",
            startPort = "Out",
            endQuest = "17724330598334753426",
            endPort = "In"
          },
          {
            startQuest = "1772421504262707371",
            startPort = "QuestStart",
            endQuest = "17748544740188096109",
            endPort = "In"
          },
          {
            startQuest = "1772421504262707371",
            startPort = "QuestStart",
            endQuest = "17748544740188096108",
            endPort = "In"
          },
          {
            startQuest = "17748544922268096451",
            startPort = "Out",
            endQuest = "17748544922268096452",
            endPort = "Input_1"
          },
          {
            startQuest = "17724330962054754429",
            startPort = "Out",
            endQuest = "17748544922268096451",
            endPort = "In"
          },
          {
            startQuest = "17724330962054754429",
            startPort = "Out",
            endQuest = "17748544922268096450",
            endPort = "In"
          },
          {
            startQuest = "17748544922268096452",
            startPort = "Out",
            endQuest = "1772421504262707373",
            endPort = "Fail"
          },
          {
            startQuest = "1772421504262707371",
            startPort = "QuestStart",
            endQuest = "17748603129393842376",
            endPort = "In"
          },
          {
            startQuest = "17748544922268096450",
            startPort = "Out",
            endQuest = "17748603169943842574",
            endPort = "In"
          },
          {
            startQuest = "17748603169943842574",
            startPort = "Out",
            endQuest = "17748544922268096452",
            endPort = "Input_2"
          },
          {
            startQuest = "17724330789184753922",
            startPort = "Out",
            endQuest = "17748603231303842799",
            endPort = "In"
          },
          {
            startQuest = "17748603231303842799",
            startPort = "Out",
            endQuest = "17724330891184754190",
            endPort = "In"
          }
        },
        nodeData = {
          ["1772421504262707371"] = {
            key = "1772421504262707371",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 521.1330049261084, y = 350.5911330049261},
            propsData = {ModeType = 0}
          },
          ["1772421504262707372"] = {
            key = "1772421504262707372",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1772421504262707373"] = {
            key = "1772421504262707373",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2096.691729323308, y = 710.0375939849624},
            propsData = {}
          },
          ["1772421504262707376"] = {
            key = "1772421504262707376",
            type = "ChangeRoleNode",
            name = "切换苏乙",
            pos = {x = 875.3094086221872, y = 273.9446921574377},
            propsData = {QuestRoleId = 15040101, IsPlayFX = false}
          },
          ["17724330598334753424"] = {
            key = "17724330598334753424",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1519.0537831733486, y = -131.2687747035573},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 240066,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_12020607fawuqinpc1_242410150",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              FirstDialogueId = 12048403,
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
              TalkActors = {},
              OptionType = "normal",
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17724330598334753425"] = {
            key = "17724330598334753425",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1561.5580180688878, y = 154.81535855448902},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 240067,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_12020607fawuqinpc2_242410151",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              FirstDialogueId = 12048401,
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
              TalkActors = {},
              OptionType = "normal",
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17724330598334753426"] = {
            key = "17724330598334753426",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1602.6201298701303, y = 448.703557312253},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 240068,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_12020607fawuqinpc3_242410152",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              FirstDialogueId = 12048402,
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
              TalkActors = {},
              OptionType = "normal",
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17724330789184753922"] = {
            key = "17724330789184753922",
            type = "WaitQuestFinishedNode",
            name = "等待任务完成",
            pos = {x = 2048.380434782609, y = 92.8478260869565},
            propsData = {ListenCount = 3, NeedFinishCount = 3}
          },
          ["17724330891184754190"] = {
            key = "17724330891184754190",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2754.4555410264793, y = 141.98234717227854},
            propsData = {}
          },
          ["17724330962054754429"] = {
            key = "17724330962054754429",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 960.4743380189605, y = 632.865805818895},
            propsData = {}
          },
          ["1772716676920818778"] = {
            key = "1772716676920818778",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1110.1280788177341, y = 215.1810344827586},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                242410150,
                242410151,
                242410152
              }
            }
          },
          ["17748544740188096108"] = {
            key = "17748544740188096108",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 793.679586834734, y = -149.16428571428577},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "JuezhanLight",
              UnitId = -1
            }
          },
          ["17748544740188096109"] = {
            key = "17748544740188096109",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 775.1418417366947, y = 6.235714285714224},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "LigntningStart",
              UnitId = -1
            }
          },
          ["17748544922268096450"] = {
            key = "17748544922268096450",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1256.7730200958458, y = 724.114147287127},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "JuezhanLightEnd",
              UnitId = -1
            }
          },
          ["17748544922268096451"] = {
            key = "17748544922268096451",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1258.2876800906292, y = 565.9553614649901},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "LigntningEnd",
              UnitId = -1
            }
          },
          ["17748544922268096452"] = {
            key = "17748544922268096452",
            type = "WaitQuestFinishedNode",
            name = "等待任务完成",
            pos = {x = 1825.5551466649297, y = 707.8538604724924},
            propsData = {ListenCount = 2, NeedFinishCount = 2}
          },
          ["17748603129393842376"] = {
            key = "17748603129393842376",
            type = "SetGlobalSoundParamNode",
            name = "设置全局音效参数",
            pos = {x = 808.7447014734269, y = -332.93000100249725},
            propsData = {
              ParamName = "story_1_3_final_disaste",
              ParamValue = 1
            }
          },
          ["17748603169943842574"] = {
            key = "17748603169943842574",
            type = "SetGlobalSoundParamNode",
            name = "设置全局音效参数",
            pos = {x = 1537.2630722331023, y = 823.2519626859881},
            propsData = {
              ParamName = "parameter:/story/story_1_3_final_disaste",
              ParamValue = 0
            }
          },
          ["17748603231303842799"] = {
            key = "17748603231303842799",
            type = "SetGlobalSoundParamNode",
            name = "设置全局音效参数",
            pos = {x = 2352.522812492843, y = 167.53767697170247},
            propsData = {
              ParamName = "story_1_3_final_disaste",
              ParamValue = 0
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
