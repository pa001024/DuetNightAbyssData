return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17779574249024684502",
      startPort = "Success",
      endStory = "17779573945454684429",
      endPort = "StoryEnd"
    },
    {
      startStory = "17779573945454684426",
      startPort = "StoryStart",
      endStory = "177816461881471479520",
      endPort = "In"
    },
    {
      startStory = "177816461881471479520",
      startPort = "Success",
      endStory = "17779574249024684502",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17779573945454684426"] = {
      isStoryNode = true,
      key = "17779573945454684426",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 576.9565217391304, y = 276.52173913043475},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17779573945454684429"] = {
      isStoryNode = true,
      key = "17779573945454684429",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1579.1304347826085, y = 289.5652173913044},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17779574249024684502"] = {
      isStoryNode = true,
      key = "17779574249024684502",
      type = "StoryNode",
      name = "准备进入通风管道",
      pos = {x = 1214.9899885583525, y = 297.32437070938204},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040107_03",
        QuestDeatil = "Description_10040108_01",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = false,
        bIsNotifyGameMode = true,
        bIsStartChapter = false,
        bIsEndChapter = false,
        bIsPlayBlackScreenOnComplete = true,
        bIsPlayBlackScreenOnFail = false,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17779574249034684507",
            startPort = "QuestStart",
            endQuest = "17779574249034684514",
            endPort = "In"
          },
          {
            startQuest = "17779574249034684514",
            startPort = "Out",
            endQuest = "17779574249034684511",
            endPort = "In"
          },
          {
            startQuest = "17779574249034684511",
            startPort = "Out",
            endQuest = "17779574458324685187",
            endPort = "In"
          },
          {
            startQuest = "17779574249034684507",
            startPort = "QuestStart",
            endQuest = "17779574538854685432",
            endPort = "In"
          },
          {
            startQuest = "17779574538854685432",
            startPort = "Out",
            endQuest = "17779574249034684509",
            endPort = "Fail"
          },
          {
            startQuest = "177815259931117066853",
            startPort = "Out",
            endQuest = "17779574249034684511",
            endPort = "In"
          },
          {
            startQuest = "17779574249034684507",
            startPort = "QuestStart",
            endQuest = "177815269550918013482",
            endPort = "In"
          },
          {
            startQuest = "17779574249034684507",
            startPort = "QuestStart",
            endQuest = "177815388885620854764",
            endPort = "In"
          },
          {
            startQuest = "177815388885620854764",
            startPort = "Out",
            endQuest = "177815385868920854588",
            endPort = "In"
          },
          {
            startQuest = "17779574249034684514",
            startPort = "Out",
            endQuest = "177816623985575281956",
            endPort = "In"
          },
          {
            startQuest = "17779574249034684511",
            startPort = "Fail",
            endQuest = "177815259931117066853",
            endPort = "In"
          }
        },
        nodeData = {
          ["17779574249034684507"] = {
            key = "17779574249034684507",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 408.47953216374265, y = 318.8304093567251},
            propsData = {ModeType = 0}
          },
          ["17779574249034684508"] = {
            key = "17779574249034684508",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1861.3069810624156, y = 323.4988652651696},
            propsData = {
              ModeType = 1,
              Id = 106301,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17779574249034684509"] = {
            key = "17779574249034684509",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1478, y = 630},
            propsData = {}
          },
          ["17779574249034684511"] = {
            key = "17779574249034684511",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1215.4192761694194, y = 315.7690002915976},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100454,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_TFKWeibing_272480290",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10040901.10040901'",
              TalkType = "FreeSimple",
              BlendInTime = 1,
              BlendOutTime = 1,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100001,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100401,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100402,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100454,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17779574249034684514"] = {
            key = "17779574249034684514",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 779.3618895724159, y = 347.1811346548189},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100411,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Guizu_132480170",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049901_54.10049901_54'",
              TalkType = "FreeSimple",
              BlendInTime = 1,
              BlendOutTime = 1,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100001,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100401,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100402,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100411,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17779574458324685187"] = {
            key = "17779574458324685187",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 1552.0119988706942, y = 326.72655205206695},
            propsData = {}
          },
          ["17779574538854685432"] = {
            key = "17779574538854685432",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 872.9894424797171, y = 632.8167776159767},
            propsData = {}
          },
          ["177815259931117066853"] = {
            key = "177815259931117066853",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1220.156263091747, y = 545.522832006703},
            propsData = {WaitTime = 1}
          },
          ["177815269550918013482"] = {
            key = "177815269550918013482",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 734.1298701298701, y = 5.038961038961084},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177815385868920854588"] = {
            key = "177815385868920854588",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1090.9473684210525, y = 34.258373205741634},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {132480170}
            }
          },
          ["177815388885620854764"] = {
            key = "177815388885620854764",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 835.9473684210526, y = 135.16746411483257},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {132480170}
            }
          },
          ["177816623985575281956"] = {
            key = "177816623985575281956",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1244.5230382432974, y = 213.29513440353338},
            propsData = {
              NewDescription = "Content_10040108_01",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          }
        },
        commentData = {}
      }
    },
    ["177816461881471479520"] = {
      isStoryNode = true,
      key = "177816461881471479520",
      type = "StoryNode",
      name = "监工贵族",
      pos = {x = 899.0635123614662, y = 286.8072541269472},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040107_02",
        QuestDeatil = "Description_10040107_01",
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
            startQuest = "177816461881471479525",
            startPort = "QuestStart",
            endQuest = "177816461881471479529",
            endPort = "In"
          },
          {
            startQuest = "177816461881471479528",
            startPort = "Fail",
            endQuest = "177816461881471479531",
            endPort = "In"
          },
          {
            startQuest = "177816461881471479531",
            startPort = "Out",
            endQuest = "177816461881471479528",
            endPort = "In"
          },
          {
            startQuest = "177816461881471479525",
            startPort = "QuestStart",
            endQuest = "177816461881471479532",
            endPort = "In"
          },
          {
            startQuest = "177816461881471479532",
            startPort = "Out",
            endQuest = "177816461881471479527",
            endPort = "Fail"
          },
          {
            startQuest = "177816461881471479525",
            startPort = "QuestStart",
            endQuest = "177816461881471479533",
            endPort = "Input"
          },
          {
            startQuest = "177816461881471479525",
            startPort = "QuestStart",
            endQuest = "177816461881471479534",
            endPort = "In"
          },
          {
            startQuest = "177816461881471479534",
            startPort = "Out",
            endQuest = "177816461881471479528",
            endPort = "In"
          },
          {
            startQuest = "177816461881471479528",
            startPort = "Out",
            endQuest = "177816461881471479526",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177816461881471479525"] = {
            key = "177816461881471479525",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 495.34050179211476, y = 299.2456826327794},
            propsData = {ModeType = 0}
          },
          ["177816461881471479526"] = {
            key = "177816461881471479526",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1918.854213244255, y = 362.1675902939219},
            propsData = {ModeType = 0}
          },
          ["177816461881471479527"] = {
            key = "177816461881471479527",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1741, y = 698.5},
            propsData = {}
          },
          ["177816461881471479528"] = {
            key = "177816461881471479528",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1292.2031319176629, y = 336.2463742622073},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100449,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Jiangong_132480171",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049501.10049501'",
              TalkType = "FreeSimple",
              BlendInTime = 1,
              BlendOutTime = 1,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100001,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100401,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100402,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100449,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["177816461881471479529"] = {
            key = "177816461881471479529",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 799.639386968275, y = -4.619384737041159},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {132480170}
            }
          },
          ["177816461881471479531"] = {
            key = "177816461881471479531",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1312.6029400529208, y = 535.5689557402743},
            propsData = {WaitTime = 1}
          },
          ["177816461881471479532"] = {
            key = "177816461881471479532",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1307.542824537834, y = 768.4137931034484},
            propsData = {}
          },
          ["177816461881471479533"] = {
            key = "177816461881471479533",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1170, y = 990},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["177816461881471479534"] = {
            key = "177816461881471479534",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 922.2535885167462, y = 322.6507177033492},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
