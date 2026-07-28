return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17782434807809404322",
      startPort = "StoryStart",
      endStory = "17782434346828593027",
      endPort = "In"
    },
    {
      startStory = "17782434346828593027",
      startPort = "Success",
      endStory = "17782434807809404323",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17782434346828593027"] = {
      isStoryNode = true,
      key = "17782434346828593027",
      type = "StoryNode",
      name = "寻找史蒂芬",
      pos = {x = 1031.8857142857144, y = 81.02857142857155},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040309_01",
        QuestDeatil = "Description_10040309_01",
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
        StoryGuidePointName = "Npc_Shidifen_152480367",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17782434346838593032",
            startPort = "QuestStart",
            endQuest = "17782434346838593035",
            endPort = "In"
          },
          {
            startQuest = "17782434346838593035",
            startPort = "Out",
            endQuest = "17782434346838593036",
            endPort = "In"
          },
          {
            startQuest = "17782434346838593036",
            startPort = "Out",
            endQuest = "17782434542258593509",
            endPort = "In"
          },
          {
            startQuest = "17782434346838593032",
            startPort = "QuestStart",
            endQuest = "17783048808318589957",
            endPort = "In"
          },
          {
            startQuest = "17782434346838593032",
            startPort = "QuestStart",
            endQuest = "17787504394739725124",
            endPort = "In"
          },
          {
            startQuest = "17787504394739725124",
            startPort = "Out",
            endQuest = "17782434346838593034",
            endPort = "Fail"
          },
          {
            startQuest = "17782434346838593032",
            startPort = "QuestStart",
            endQuest = "177891744848180640207",
            endPort = "Input"
          }
        },
        nodeData = {
          ["17782434346838593032"] = {
            key = "17782434346838593032",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17782434346838593033"] = {
            key = "17782434346838593033",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1949.0526315789473, y = 319.84210526315786},
            propsData = {ModeType = 0}
          },
          ["17782434346838593034"] = {
            key = "17782434346838593034",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1397.5, y = 718},
            propsData = {}
          },
          ["17782434346838593035"] = {
            key = "17782434346838593035",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1136.6315789473683, y = 263.2443609022557},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2490001,
              GuideType = "M",
              GuidePointName = "Mechanism_Shidifen_2490001"
            }
          },
          ["17782434346838593036"] = {
            key = "17782434346838593036",
            type = "TalkNode",
            name = "史蒂芬对话",
            pos = {x = 1431.8947368421052, y = 310.1052631578948},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10044401.10044401'",
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
          ["17782434542258593509"] = {
            key = "17782434542258593509",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 1699.4583333333335, y = 311.1644385026739},
            propsData = {}
          },
          ["17783048808318589957"] = {
            key = "17783048808318589957",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1152, y = 440},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["17787504394739725124"] = {
            key = "17787504394739725124",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1143.8067354214418, y = 705.7774017262407},
            propsData = {}
          },
          ["177891744848180640207"] = {
            key = "177891744848180640207",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1156, y = 567.5},
            propsData = {
              TargetTime = 19,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          }
        },
        commentData = {}
      }
    },
    ["17782434807809404322"] = {
      isStoryNode = true,
      key = "17782434807809404322",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 777.1999999999999, y = 87.59999999999998},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17782434807809404323"] = {
      isStoryNode = true,
      key = "17782434807809404323",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1331.866851055188, y = 90.86607697013385},
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
