return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17782426680326535893",
      startPort = "StoryStart",
      endStory = "17782426165635725206",
      endPort = "In"
    },
    {
      startStory = "17782426165635725206",
      startPort = "Success",
      endStory = "17782426680326535894",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17782426165635725206"] = {
      isStoryNode = true,
      key = "17782426165635725206",
      type = "StoryNode",
      name = "炸弹调查后对话",
      pos = {x = 1087.0857142857144, y = 103.82857142857154},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040313_01",
        QuestDeatil = "Description_10040313_01",
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
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_Storeroom_2480211",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17782426165635725214",
            startPort = "Out",
            endQuest = "17782426165635725215",
            endPort = "In"
          },
          {
            startQuest = "17782426165635725215",
            startPort = "Out",
            endQuest = "17782426165635725216",
            endPort = "In"
          },
          {
            startQuest = "17782426165635725216",
            startPort = "Out",
            endQuest = "17782426442745725902",
            endPort = "In"
          },
          {
            startQuest = "17782426165635725211",
            startPort = "QuestStart",
            endQuest = "177830495976912405977",
            endPort = "In"
          },
          {
            startQuest = "17782426165635725211",
            startPort = "QuestStart",
            endQuest = "17787402535981243",
            endPort = "In"
          },
          {
            startQuest = "17782426165635725211",
            startPort = "QuestStart",
            endQuest = "177875057838313615049",
            endPort = "In"
          },
          {
            startQuest = "177875057838313615049",
            startPort = "Out",
            endQuest = "17782426165635725213",
            endPort = "Fail"
          },
          {
            startQuest = "17782426165635725211",
            startPort = "QuestStart",
            endQuest = "177891762413884499952",
            endPort = "Input"
          },
          {
            startQuest = "17793478925671146",
            startPort = "Out",
            endQuest = "17782426165635725214",
            endPort = "In"
          },
          {
            startQuest = "17793478925671146",
            startPort = "Out",
            endQuest = "1779348445926968922",
            endPort = "In"
          },
          {
            startQuest = "17782426165635725211",
            startPort = "QuestStart",
            endQuest = "17794210458931934918",
            endPort = "In"
          },
          {
            startQuest = "17794210458931934918",
            startPort = "Out",
            endQuest = "17793478925671146",
            endPort = "In"
          }
        },
        nodeData = {
          ["17782426165635725211"] = {
            key = "17782426165635725211",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 243.5, y = 306.40000000000003},
            propsData = {ModeType = 0}
          },
          ["17782426165635725212"] = {
            key = "17782426165635725212",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2560.5538461538467, y = 276.13846153846157},
            propsData = {ModeType = 0}
          },
          ["17782426165635725213"] = {
            key = "17782426165635725213",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1380.5714285714287, y = 632.7142857142856},
            propsData = {}
          },
          ["17782426165635725214"] = {
            key = "17782426165635725214",
            type = "TalkNode",
            name = "管理员出场",
            pos = {x = 1381.6894009216587, y = 279.4297950103289},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "UI_Npc_Name_CangkuGuanli",
              NpcId = 100419,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Guanliyuan_152480417",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 10043601,
              FlowAssetPath = "",
              TalkType = "Impression",
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100403,
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
          ["17782426165635725215"] = {
            key = "17782426165635725215",
            type = "TalkNode",
            name = "艾森巴恩仓库出场",
            pos = {x = 1698.3057029926595, y = 277.27408243929983},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10043701.10043701'",
              TalkType = "FixSimple",
              TalkStageName = "",
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
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17782426165635725216"] = {
            key = "17782426165635725216",
            type = "TalkNode",
            name = "炸弹调查后对话",
            pos = {x = 2002.2057029926596, y = 275.1312252964428},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10043801.10043801'",
              TalkType = "FixSimple",
              TalkStageName = "",
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
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17782426442745725902"] = {
            key = "17782426442745725902",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2279.688837478311, y = 274.2750709435493},
            propsData = {}
          },
          ["177830495976912405977"] = {
            key = "177830495976912405977",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1059.6995073891626, y = 466.7832512315271},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["17787402535981243"] = {
            key = "17787402535981243",
            type = "AtmosphereNpcHideNode",
            name = "隐藏氛围",
            pos = {x = 1066.6134212305615, y = -90.20834540712836},
            propsData = {
              IsHide = true,
              AtmosphereTagList = {"Story_YT", "Story_BHCZ"}
            }
          },
          ["177875057838313615049"] = {
            key = "177875057838313615049",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1063.546052631579, y = 623.4078947368422},
            propsData = {}
          },
          ["177891762413884499952"] = {
            key = "177891762413884499952",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1053.3357142857144, y = -272.97857142857146},
            propsData = {
              TargetTime = 19,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true
            }
          },
          ["17793478925671146"] = {
            key = "17793478925671146",
            type = "ChangeStaticCreatorNode",
            name = "生成管理员",
            pos = {x = 1063.8308913308915, y = 286.53296703296706},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480417}
            }
          },
          ["1779348445926968922"] = {
            key = "1779348445926968922",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1383.2865563555222, y = 111.62902614626752},
            propsData = {
              NewDescription = "Content_10040313_01",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["17794210458931934918"] = {
            key = "17794210458931934918",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 741, y = 275.5},
            propsData = {
              VarName = "First10040313",
              VarValue = 1
            }
          }
        },
        commentData = {}
      }
    },
    ["17782426680326535893"] = {
      isStoryNode = true,
      key = "17782426680326535893",
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
    ["17782426680326535894"] = {
      isStoryNode = true,
      key = "17782426680326535894",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1353.4668510551878, y = 102.86607697013386},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    }
  },
  commentData = {}
}
