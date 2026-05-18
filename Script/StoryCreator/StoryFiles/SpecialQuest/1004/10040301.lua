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
            startQuest = "17782391587721288356",
            startPort = "Out",
            endQuest = "17782391587731288359",
            endPort = "Branch_2"
          },
          {
            startQuest = "17782391587721288357",
            startPort = "Out",
            endQuest = "17782391587731288359",
            endPort = "Branch_1"
          },
          {
            startQuest = "17782391587721288355",
            startPort = "Out",
            endQuest = "17782391587731288361",
            endPort = "In"
          },
          {
            startQuest = "17782391587721288355",
            startPort = "Out",
            endQuest = "17782391587731288358",
            endPort = "In"
          },
          {
            startQuest = "17782391587731288358",
            startPort = "Out",
            endQuest = "17782391587721288357",
            endPort = "In"
          },
          {
            startQuest = "17782391587731288358",
            startPort = "Out",
            endQuest = "17782391587721288356",
            endPort = "In"
          },
          {
            startQuest = "17782391587721288352",
            startPort = "QuestStart",
            endQuest = "17782391587731288363",
            endPort = "In"
          },
          {
            startQuest = "17782391587731288361",
            startPort = "Out",
            endQuest = "17782391587731288362",
            endPort = "In"
          },
          {
            startQuest = "17782391587731288359",
            startPort = "Out",
            endQuest = "17782391587731288364",
            endPort = "In"
          },
          {
            startQuest = "17782391587721288352",
            startPort = "QuestStart",
            endQuest = "17782391587731288365",
            endPort = "In"
          },
          {
            startQuest = "17782391587731288365",
            startPort = "Out",
            endQuest = "17782391587721288355",
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
            pos = {x = 1057.0000000000002, y = 1012},
            propsData = {}
          },
          ["17782391587721288355"] = {
            key = "17782391587721288355",
            type = "GoToNode",
            name = "前往爆炸现场",
            pos = {x = 552.7084520335836, y = 125.55865631281553},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2530031,
              GuideType = "M",
              GuidePointName = "Mechanism_BaozhaStart_2530031"
            }
          },
          ["17782391587721288356"] = {
            key = "17782391587721288356",
            type = "TalkNode",
            name = "（可选）和希尔妲对话",
            pos = {x = 1204.773476702509, y = 202.20010129343927},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "UI_Npc_Name_Xier",
              NpcId = 100403,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Xierda_2480176",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049901_23.10049901_23'",
              TalkType = "FreeSimple",
              BlendInTime = 2,
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
            pos = {x = 1203.523567221637, y = 35.444285439469084},
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
              IsNPCTurnToPlayer = true,
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
          ["17782391587731288358"] = {
            key = "17782391587731288358",
            type = "BranchQuestStartNode",
            name = "子任务开始节点",
            pos = {x = 836.5472105877772, y = 137.3999065676006},
            propsData = {
              AllQuestOptions = {
                {
                  IsNeedFinish = true,
                  BranchQuestName = "Content_10040301_01_02",
                  TargetBranchQuestKey = ""
                },
                {
                  IsNeedFinish = false,
                  BranchQuestName = "Content_10040301_01_01",
                  TargetBranchQuestKey = ""
                }
              },
              IsSetCountInfo = false,
              IsDifftation = false,
              AllDiffGuideOptions = {
                {
                  OptionElements = {
                    {
                      TargetIndicatorKey = "176493378386320787291",
                      IsShowOptional = false
                    }
                  }
                },
                {
                  OptionElements = {
                    {
                      TargetIndicatorKey = "176526811857818836816",
                      IsShowOptional = true
                    }
                  }
                }
              }
            }
          },
          ["17782391587731288359"] = {
            key = "17782391587731288359",
            type = "CheckBranchQuestFinishedNode",
            name = "子任务结束节点",
            pos = {x = 1576.0595724350615, y = 108.95016116729403},
            propsData = {
              InputBranchQuestNumber = 2,
              BranchQuestFinishOptions = {
                {IsNeedFinish = true},
                {IsNeedFinish = false}
              }
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
          ["17782391587731288361"] = {
            key = "17782391587731288361",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 845.463157894737, y = 392.6697368421053},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {272480289}
            }
          },
          ["17782391587731288362"] = {
            key = "17782391587731288362",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1321.866606170599, y = 396.2697368421052},
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
            pos = {x = 278.88288969550314, y = 391.6308479532164},
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
          ["17782391587731288365"] = {
            key = "17782391587731288365",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "设置玩家到芙罗拉专列外",
            pos = {x = 276.98126483317054, y = 116.01556261343003},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Point_Teleport_10040312",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17782391587731288366"] = {
            key = "17782391587731288366",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 278.5432999920612, y = 262.3776315789473},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["17787396609742069"] = {
            key = "17787396609742069",
            type = "AtmosphereNpcHideNode",
            name = "隐藏氛围",
            pos = {x = 279.62701126217075, y = -143.2967381689516},
            propsData = {
              IsHide = true,
              AtmosphereTagList = {"Story_YT", "Story_BHCZ"}
            }
          },
          ["1778749680743829"] = {
            key = "1778749680743829",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 674.6428571428569, y = 999.7499999999995},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
