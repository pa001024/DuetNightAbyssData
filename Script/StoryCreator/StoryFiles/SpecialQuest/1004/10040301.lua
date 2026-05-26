return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17782391587721288349",
      startPort = "StoryStart",
      endStory = "17782391587721288351",
      endPort = "In"
    },
    {
      startStory = "17782391587721288351",
      startPort = "Success",
      endStory = "17782391587721288350",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17782391587721288349"] = {
      isStoryNode = true,
      key = "17782391587721288349",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 816.8, y = 98.39999999999998},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17782391587721288350"] = {
      isStoryNode = true,
      key = "17782391587721288350",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1459.0668510551877, y = 100.46607697013386},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17782391587721288351"] = {
      isStoryNode = true,
      key = "17782391587721288351",
      type = "StoryNode",
      name = "前往爆炸现场",
      pos = {x = 1120.6825396825398, y = 91.03147235905855},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "",
        QuestDeatil = "",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_Baozhaxianchang_152480411",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17782391587721288352",
            startPort = "QuestStart",
            endQuest = "17782391587731288360",
            endPort = "In"
          },
          {
            startQuest = "17782391587721288352",
            startPort = "QuestStart",
            endQuest = "17782391587731288363",
            endPort = "In"
          },
          {
            startQuest = "17782391587721288352",
            startPort = "QuestStart",
            endQuest = "17782391587731288366",
            endPort = "In"
          },
          {
            startQuest = "17782391587731288364",
            startPort = "Out",
            endQuest = "17782390728903657",
            endPort = "In"
          },
          {
            startQuest = "17782391587721288352",
            startPort = "QuestStart",
            endQuest = "17787396609742069",
            endPort = "In"
          },
          {
            startQuest = "17782391587721288352",
            startPort = "QuestStart",
            endQuest = "1778749680743829",
            endPort = "In"
          },
          {
            startQuest = "1778749680743829",
            startPort = "Out",
            endQuest = "17782391587721288354",
            endPort = "Fail"
          },
          {
            startQuest = "17782391587721288352",
            startPort = "QuestStart",
            endQuest = "177891722234473885575",
            endPort = "Input"
          },
          {
            startQuest = "17782391587721288352",
            startPort = "QuestStart",
            endQuest = "17782391587731288362",
            endPort = "In"
          },
          {
            startQuest = "17782391587721288352",
            startPort = "QuestStart",
            endQuest = "17791877754942280",
            endPort = "In"
          },
          {
            startQuest = "17782391587721288352",
            startPort = "QuestStart",
            endQuest = "17782391587721288357",
            endPort = "In"
          },
          {
            startQuest = "17782391587721288352",
            startPort = "QuestStart",
            endQuest = "17782391587721288356",
            endPort = "In"
          },
          {
            startQuest = "17782391587721288357",
            startPort = "Out",
            endQuest = "17782391587731288364",
            endPort = "In"
          }
        },
        nodeData = {
          ["17782390728903657"] = {
            key = "17782390728903657",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2257.2565789473683, y = 127.8520381836945},
            propsData = {}
          },
          ["17782391587721288352"] = {
            key = "17782391587721288352",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -207.9729057758511, y = 107.9423052403416},
            propsData = {ModeType = 0}
          },
          ["17782391587721288353"] = {
            key = "17782391587721288353",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2612.257294709424, y = 155.59189962986005},
            propsData = {ModeType = 0}
          },
          ["17782391587721288354"] = {
            key = "17782391587721288354",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 892.6000000000003, y = 880},
            propsData = {}
          },
          ["17782391587721288356"] = {
            key = "17782391587721288356",
            type = "TalkNode",
            name = "（可选）和希尔妲对话",
            pos = {x = 1036.1449052739376, y = -45.05704156370359},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "UI_Npc_Name_Xier",
              NpcId = 100403,
              GuideUIEnable = false,
              GuideType = "N",
              GuidePointName = "",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049901_23.10049901_23'",
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
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17782391587721288357"] = {
            key = "17782391587721288357",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1034.9521386502083, y = 118.30142829661196},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100422,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_BaozhaWeibing_272480170",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10042901.10042901'",
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
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
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
          ["17782391587731288360"] = {
            key = "17782391587731288360",
            type = "ChangeStaticCreatorNode",
            name = "放出爆炸点卫兵",
            pos = {x = 280.2234232354914, y = -0.26087765422226994},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272480170, 152480365}
            }
          },
          ["17782391587731288362"] = {
            key = "17782391587731288362",
            type = "ChangeStaticCreatorNode",
            name = "放出希尔妲",
            pos = {x = 274.26660617059883, y = -140.1302631578949},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2480176}
            }
          },
          ["17782391587731288363"] = {
            key = "17782391587731288363",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 295.68288969550315, y = 584.8308479532164},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {272480289}
            }
          },
          ["17782391587731288364"] = {
            key = "17782391587731288364",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1904.7105263157894, y = 120.57236842105243},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2480176}
            }
          },
          ["17782391587731288366"] = {
            key = "17782391587731288366",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 291.74329999206117, y = 451.9776315789473},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["17787396609742069"] = {
            key = "17787396609742069",
            type = "AtmosphereNpcHideNode",
            name = "隐藏氛围",
            pos = {x = 273.62701126217075, y = -316.0967381689516},
            propsData = {
              IsHide = true,
              AtmosphereTagList = {"Story_YT", "Story_BHCZ"}
            }
          },
          ["1778749680743829"] = {
            key = "1778749680743829",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 332.6428571428568, y = 852.1499999999995},
            propsData = {}
          },
          ["177891722234473885575"] = {
            key = "177891722234473885575",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 266.4, y = -474.6},
            propsData = {
              TargetTime = 18,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true
            }
          },
          ["17791877754942280"] = {
            key = "17791877754942280",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 291.1167048054916, y = 330.80000000000024},
            propsData = {
              NewDescription = "Content_10040301_01_02",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
