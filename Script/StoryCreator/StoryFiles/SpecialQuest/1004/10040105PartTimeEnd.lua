return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17779554836602812192",
      startPort = "StoryStart",
      endStory = "17779554846552812215",
      endPort = "In"
    },
    {
      startStory = "17779554846552812215",
      startPort = "Success",
      endStory = "17779554836612812195",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17779554836602812192"] = {
      isStoryNode = true,
      key = "17779554836602812192",
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
    ["17779554836612812195"] = {
      isStoryNode = true,
      key = "17779554836612812195",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2014, y = 266.4},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17779554846552812215"] = {
      isStoryNode = true,
      key = "17779554846552812215",
      type = "StoryNode",
      name = "监工贵族",
      pos = {x = 1475.4285714285713, y = 277.42857142857144},
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
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Jiangong_132480171",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17779554846562812220",
            startPort = "QuestStart",
            endQuest = "17779554846562812225",
            endPort = "In"
          },
          {
            startQuest = "17779554846562812223",
            startPort = "Out",
            endQuest = "17779555289492813299",
            endPort = "In"
          },
          {
            startQuest = "17779554846562812223",
            startPort = "Fail",
            endQuest = "17779555380692813574",
            endPort = "In"
          },
          {
            startQuest = "17779555380692813574",
            startPort = "Out",
            endQuest = "17779554846562812223",
            endPort = "In"
          },
          {
            startQuest = "17779554846562812220",
            startPort = "QuestStart",
            endQuest = "17779556639003749251",
            endPort = "In"
          },
          {
            startQuest = "17779556639003749251",
            startPort = "Out",
            endQuest = "17779554846562812222",
            endPort = "Fail"
          },
          {
            startQuest = "17779554846562812220",
            startPort = "QuestStart",
            endQuest = "17779778099485613856",
            endPort = "Input"
          },
          {
            startQuest = "17779554846562812220",
            startPort = "QuestStart",
            endQuest = "177797952445911226521",
            endPort = "In"
          },
          {
            startQuest = "177797952445911226521",
            startPort = "Out",
            endQuest = "17779554846562812223",
            endPort = "In"
          }
        },
        nodeData = {
          ["17779554846562812220"] = {
            key = "17779554846562812220",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 495.34050179211476, y = 299.2456826327794},
            propsData = {ModeType = 0}
          },
          ["17779554846562812221"] = {
            key = "17779554846562812221",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1918.854213244255, y = 362.1675902939219},
            propsData = {ModeType = 0}
          },
          ["17779554846562812222"] = {
            key = "17779554846562812222",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1741, y = 698.5},
            propsData = {}
          },
          ["17779554846562812223"] = {
            key = "17779554846562812223",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1291.0492857638167, y = 338.1213742622073},
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
                  TalkActorVisible = false
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
          ["17779554846562812225"] = {
            key = "17779554846562812225",
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
          ["17779555289492813299"] = {
            key = "17779555289492813299",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 1656.6480328911168, y = 352.58487085963776},
            propsData = {}
          },
          ["17779555380692813574"] = {
            key = "17779555380692813574",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1312.6029400529208, y = 535.5689557402743},
            propsData = {WaitTime = 1}
          },
          ["17779556639003749251"] = {
            key = "17779556639003749251",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1307.542824537834, y = 768.4137931034484},
            propsData = {}
          },
          ["17779778099485613856"] = {
            key = "17779778099485613856",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 861, y = 870},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true
            }
          },
          ["177797952445911226521"] = {
            key = "177797952445911226521",
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
