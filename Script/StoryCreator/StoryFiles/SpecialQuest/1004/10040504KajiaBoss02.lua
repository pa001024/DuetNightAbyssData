return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177772052941215887715",
      startPort = "StoryStart",
      endStory = "177772053087715887749",
      endPort = "In"
    },
    {
      startStory = "177772053087715887749",
      startPort = "Success",
      endStory = "177772052941215887718",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177772052941215887715"] = {
      isStoryNode = true,
      key = "177772052941215887715",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 972, y = 244},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177772052941215887718"] = {
      isStoryNode = true,
      key = "177772052941215887718",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1802, y = 262},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177772053087715887749"] = {
      isStoryNode = true,
      key = "177772053087715887749",
      type = "StoryNode",
      name = "卡嘉Boss战二阶段",
      pos = {x = 1380, y = 223.99999999999994},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040505_02",
        QuestDeatil = "",
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
        IsBacktrack = false,
        SubRegionId = 106101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177772053087715887758",
            startPort = "Out",
            endQuest = "177772053087715887759",
            endPort = "In"
          },
          {
            startQuest = "177772053087715887760",
            startPort = "Out",
            endQuest = "177772053087715887761",
            endPort = "In"
          },
          {
            startQuest = "177772053087715887761",
            startPort = "Out",
            endQuest = "177772053087715887758",
            endPort = "In"
          },
          {
            startQuest = "177772053087715887757",
            startPort = "Out",
            endQuest = "177772053087715887760",
            endPort = "In"
          },
          {
            startQuest = "177772053087715887761",
            startPort = "Out",
            endQuest = "177772053087715887762",
            endPort = "In"
          },
          {
            startQuest = "177772053087715887759",
            startPort = "Out",
            endQuest = "177772053087715887763",
            endPort = "In"
          },
          {
            startQuest = "177772053087715887754",
            startPort = "QuestStart",
            endQuest = "177772184824025234657",
            endPort = "In"
          },
          {
            startQuest = "177772184824025234657",
            startPort = "Out",
            endQuest = "177772053087715887757",
            endPort = "In"
          },
          {
            startQuest = "177772053087715887754",
            startPort = "QuestStart",
            endQuest = "177772189505226168257",
            endPort = "In"
          },
          {
            startQuest = "177772189505226168257",
            startPort = "Out",
            endQuest = "177772053087715887756",
            endPort = "Fail"
          },
          {
            startQuest = "177772053087715887763",
            startPort = "Out",
            endQuest = "177772190469426168609",
            endPort = "In"
          },
          {
            startQuest = "177772053087715887754",
            startPort = "QuestStart",
            endQuest = "177772191166226168807",
            endPort = "In"
          }
        },
        nodeData = {
          ["177772053087715887754"] = {
            key = "177772053087715887754",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 121.13043478260875, y = 244.43478260869563},
            propsData = {ModeType = 0}
          },
          ["177772053087715887755"] = {
            key = "177772053087715887755",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3217.3909423909417, y = 338.28071928071927},
            propsData = {ModeType = 0}
          },
          ["177772053087715887756"] = {
            key = "177772053087715887756",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1376, y = 736},
            propsData = {}
          },
          ["177772053087715887757"] = {
            key = "177772053087715887757",
            type = "TalkNode",
            name = "过场-卡嘉最后一击后跳车",
            pos = {x = 952.1030317920239, y = 304.3880944077622},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC022/SQ_Ver0104_SC022",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["177772053087715887758"] = {
            key = "177772053087715887758",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1829.0380913601418, y = 342.98459510846084},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "TrainBoss02Start",
              UnitId = -1
            }
          },
          ["177772053087715887759"] = {
            key = "177772053087715887759",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = 2231.5808558753197, y = 345.31007403566383},
            propsData = {
              SendMessage = "",
              FinishCondition = "TrainBoss02Success"
            }
          },
          ["177772053087715887760"] = {
            key = "177772053087715887760",
            type = "TalkNode",
            name = "boss战一阶段结束对话",
            pos = {x = 1184.4497099764078, y = 322.68458007268873},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10048701.10048701'",
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
          ["177772053087715887761"] = {
            key = "177772053087715887761",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "设置玩家至二阶段boss战场景",
            pos = {x = 1493.01458230215, y = 327.19303417896884},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_TrainBoss02Start",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177772053087715887762"] = {
            key = "177772053087715887762",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 1786, y = 519.5714285714284},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = true,
              IsSync = false,
              StaticCreatorIdList = {272640059}
            }
          },
          ["177772053087715887763"] = {
            key = "177772053087715887763",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 2498, y = 371.57142857142856},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = true,
              IsSync = false,
              StaticCreatorIdList = {272640059}
            }
          },
          ["177772184824025234657"] = {
            key = "177772184824025234657",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 632, y = 296},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_HaluojiEnd",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177772189505226168257"] = {
            key = "177772189505226168257",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 692, y = 580},
            propsData = {}
          },
          ["177772190469426168609"] = {
            key = "177772190469426168609",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2814.6666666666665, y = 334.66666666666674},
            propsData = {}
          },
          ["177772191166226168807"] = {
            key = "177772191166226168807",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 676.5714285714286, y = 93.47619047619047},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
