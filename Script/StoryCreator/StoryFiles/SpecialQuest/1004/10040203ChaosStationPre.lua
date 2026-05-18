return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177847742045418822130",
      startPort = "StoryStart",
      endStory = "177847742045518822132",
      endPort = "In"
    },
    {
      startStory = "177847742045518822132",
      startPort = "Success",
      endStory = "177847742045518822131",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177847742045418822130"] = {
      isStoryNode = true,
      key = "177847742045418822130",
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
    ["177847742045518822131"] = {
      isStoryNode = true,
      key = "177847742045518822131",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1752.353846153846, y = 285.83076923076925},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177847742045518822132"] = {
      isStoryNode = true,
      key = "177847742045518822132",
      type = "StoryNode",
      name = "靠近芙罗拉专列",
      pos = {x = 1264.5901894639396, y = 281.48688937837017},
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
            startQuest = "177847742045618822136",
            startPort = "Out",
            endQuest = "177847742045618822137",
            endPort = "In"
          },
          {
            startQuest = "177847742045618822137",
            startPort = "Out",
            endQuest = "177847742045618822139",
            endPort = "In"
          },
          {
            startQuest = "177847742045618822139",
            startPort = "Out",
            endQuest = "177847742045618822138",
            endPort = "In"
          },
          {
            startQuest = "177847742045618822137",
            startPort = "Fail",
            endQuest = "177847742045518822135",
            endPort = "Fail"
          },
          {
            startQuest = "177847742045518822133",
            startPort = "QuestStart",
            endQuest = "177847742045618822140",
            endPort = "In"
          },
          {
            startQuest = "177847742045518822133",
            startPort = "QuestStart",
            endQuest = "177847742045618822141",
            endPort = "In"
          },
          {
            startQuest = "177847742045618822141",
            startPort = "Out",
            endQuest = "177847742045518822135",
            endPort = "Fail"
          },
          {
            startQuest = "177847742045518822133",
            startPort = "QuestStart",
            endQuest = "177847742045618822136",
            endPort = "In"
          },
          {
            startQuest = "177847742045618822138",
            startPort = "Out",
            endQuest = "17784740019714854835",
            endPort = "In"
          }
        },
        nodeData = {
          ["17784740019714854835"] = {
            key = "17784740019714854835",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2803.425696594427, y = 292.5961042311664},
            propsData = {}
          },
          ["177847742045518822133"] = {
            key = "177847742045518822133",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -249.98526473526476, y = 331.9095571095571},
            propsData = {ModeType = 0}
          },
          ["177847742045518822134"] = {
            key = "177847742045518822134",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3200.4866946778707, y = 628.7850140056022},
            propsData = {ModeType = 0}
          },
          ["177847742045518822135"] = {
            key = "177847742045518822135",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2034.229691876751, y = 752.7608543417365},
            propsData = {}
          },
          ["177847742045618822136"] = {
            key = "177847742045618822136",
            type = "GoToNode",
            name = "前往",
            pos = {x = 725.9016233292326, y = 237.6991402019865},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2530011,
              GuideType = "M",
              GuidePointName = "Mechanism_KaojinZhuanlie_2530011"
            }
          },
          ["177847742045618822137"] = {
            key = "177847742045618822137",
            type = "TalkNode",
            name = "初遇史蒂芬",
            pos = {x = 1571.6108038408527, y = 248.13977802647258},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10041801.10041801'",
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
          ["177847742045618822138"] = {
            key = "177847742045618822138",
            type = "TalkNode",
            name = "与史蒂芬对话",
            pos = {x = 2402.761904761905, y = 330.095238095238},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10041443,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10041901.10041901'",
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
          ["177847742045618822139"] = {
            key = "177847742045618822139",
            type = "TalkNode",
            name = "站桩过场-帮助史蒂芬",
            pos = {x = 2054.7781385281387, y = 276.1645021645021},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/Chapter03_Fix_SEQ_04.Chapter03_Fix_SEQ_04'",
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
          ["177847742045618822140"] = {
            key = "177847742045618822140",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 751.0709586466165, y = 6.79801777170205},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177847742045618822141"] = {
            key = "177847742045618822141",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1271.4857313738894, y = 685.2525632262475},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
