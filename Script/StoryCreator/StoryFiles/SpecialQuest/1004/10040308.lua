return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17782433981458448387",
      startPort = "StoryStart",
      endStory = "17782432476267637068",
      endPort = "In"
    },
    {
      startStory = "17782432476267637068",
      startPort = "Success",
      endStory = "17782433981458448388",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17782432476267637068"] = {
      isStoryNode = true,
      key = "17782432476267637068",
      type = "StoryNode",
      name = "前往站长办公室",
      pos = {x = 1046.2857142857147, y = 82.22857142857143},
      propsData = {
        QuestId = 10040308,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040308_01",
        QuestDeatil = "Description_10040308_01",
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
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17782432476267637073",
            startPort = "QuestStart",
            endQuest = "17782432476267637076",
            endPort = "In"
          },
          {
            startQuest = "17782432476267637076",
            startPort = "Out",
            endQuest = "17782432476267637077",
            endPort = "In"
          },
          {
            startQuest = "17782432476267637077",
            startPort = "Out",
            endQuest = "17782433019377637721",
            endPort = "In"
          },
          {
            startQuest = "17782432476267637073",
            startPort = "QuestStart",
            endQuest = "17783048642697636117",
            endPort = "In"
          },
          {
            startQuest = "17782432476267637073",
            startPort = "QuestStart",
            endQuest = "1778740660958358",
            endPort = "In"
          },
          {
            startQuest = "17782432476267637073",
            startPort = "QuestStart",
            endQuest = "1778743643288586",
            endPort = "In"
          },
          {
            startQuest = "17782432476267637073",
            startPort = "QuestStart",
            endQuest = "17787503559707780942",
            endPort = "In"
          },
          {
            startQuest = "17787503559707780942",
            startPort = "Out",
            endQuest = "17782432476267637075",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17782432476267637073"] = {
            key = "17782432476267637073",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1012, y = 358},
            propsData = {ModeType = 0}
          },
          ["17782432476267637074"] = {
            key = "17782432476267637074",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2226.7342995169083, y = 383.28985507246375},
            propsData = {ModeType = 0}
          },
          ["17782432476267637075"] = {
            key = "17782432476267637075",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1648.4615384615383, y = 801.5384615384615},
            propsData = {}
          },
          ["17782432476267637076"] = {
            key = "17782432476267637076",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1314, y = 364.85714285714283},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 152480274,
              GuideType = "M",
              GuidePointName = "Npc_Aisenbaen_152480366"
            }
          },
          ["17782432476267637077"] = {
            key = "17782432476267637077",
            type = "TalkNode",
            name = "调查结论",
            pos = {x = 1662.5001102205788, y = 377.41213802986863},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10044301.10044301'",
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
          ["17782433019377637721"] = {
            key = "17782433019377637721",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 1942.7187679470287, y = 375.4633095662506},
            propsData = {}
          },
          ["17783048642697636117"] = {
            key = "17783048642697636117",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1309.75, y = 502.7575187969925},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["1778740660958358"] = {
            key = "1778740660958358",
            type = "AtmosphereNpcHideNode",
            name = "隐藏氛围",
            pos = {x = 1316, y = 256},
            propsData = {
              IsHide = true,
              AtmosphereTagList = {"Story_YT", "Story_BHCZ"}
            }
          },
          ["1778743643288586"] = {
            key = "1778743643288586",
            type = "ChangeStaticCreatorNode",
            name = "放出艾森巴恩",
            pos = {x = 1319.2631826190886, y = 140.96456911210228},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480366}
            }
          },
          ["17787503559707780942"] = {
            key = "17787503559707780942",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1311.2122583299054, y = 783.2087985543867},
            propsData = {}
          }
        },
        commentData = {}
      }
    },
    ["17782433981458448387"] = {
      isStoryNode = true,
      key = "17782433981458448387",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 808.4, y = 93.59999999999998},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17782433981458448388"] = {
      isStoryNode = true,
      key = "17782433981458448388",
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
