return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17901696436434574962",
      startPort = "StoryStart",
      endStory = "17901696458054575045",
      endPort = "In"
    },
    {
      startStory = "17901696458054575045",
      startPort = "Success",
      endStory = "17901696436434574965",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17901696436434574962"] = {
      isStoryNode = true,
      key = "17901696436434574962",
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
    ["17901696436434574965"] = {
      isStoryNode = true,
      key = "17901696436434574965",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1574, y = 302},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17901696458054575045"] = {
      isStoryNode = true,
      key = "17901696458054575045",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1198, y = 278},
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
            startQuest = "1790176046292519",
            startPort = "Out",
            endQuest = "1790176046292518",
            endPort = "In"
          },
          {
            startQuest = "1790176046292518",
            startPort = "Out",
            endQuest = "1790176046292520",
            endPort = "In"
          },
          {
            startQuest = "17901696458054575046",
            startPort = "QuestStart",
            endQuest = "1790176046292521",
            endPort = "In"
          },
          {
            startQuest = "1790176046292521",
            startPort = "Out",
            endQuest = "1790176046292519",
            endPort = "In"
          },
          {
            startQuest = "17901696458054575046",
            startPort = "QuestStart",
            endQuest = "1790176046292522",
            endPort = "In"
          },
          {
            startQuest = "1790176046292520",
            startPort = "Out",
            endQuest = "17901760801951449",
            endPort = "In"
          },
          {
            startQuest = "1790176046292522",
            startPort = "Out",
            endQuest = "17901696458054575052",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17901696458054575046"] = {
            key = "17901696458054575046",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17901696458054575049"] = {
            key = "17901696458054575049",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2218.5403726708073, y = 515.4037267080745},
            propsData = {ModeType = 0}
          },
          ["17901696458054575052"] = {
            key = "17901696458054575052",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1368.0632411067193, y = 516.120835686053},
            propsData = {}
          },
          ["1790176046292518"] = {
            key = "1790176046292518",
            type = "GoToNode",
            name = "前往蕾伊家附近",
            pos = {x = 1648.2453438808946, y = 294.43038921248046},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351192101,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351192101"
            }
          },
          ["1790176046292519"] = {
            key = "1790176046292519",
            type = "ChangeStaticCreatorNode",
            name = "生成芙蕾达",
            pos = {x = 1363.545343880894, y = 303.7303892124804},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351192100}
            }
          },
          ["1790176046292520"] = {
            key = "1790176046292520",
            type = "TalkNode",
            name = "对话芙蕾达",
            pos = {x = 1938.6453438808953, y = 295.6303892124805},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 260025,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Fryda120704_351192100",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070440,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120704/12070402.12070402'",
              TalkType = "FixSimpleNew",
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
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = false,
              ShowSkipButton = true,
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
          ["1790176046292521"] = {
            key = "1790176046292521",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1084.9431065609815, y = 302.88451761981776},
            propsData = {QuestRoleId = 41030101, IsPlayFX = false}
          },
          ["1790176046292522"] = {
            key = "1790176046292522",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1083.5037244420857, y = 499.31453790379345},
            propsData = {}
          },
          ["17901760801951449"] = {
            key = "17901760801951449",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2228.0465838509317, y = 296.8788819875777},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
