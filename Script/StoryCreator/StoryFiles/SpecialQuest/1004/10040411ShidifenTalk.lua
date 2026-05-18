return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177874666780819473139",
      startPort = "StoryStart",
      endStory = "177874667103519473179",
      endPort = "In"
    },
    {
      startStory = "177874667103519473179",
      startPort = "Success",
      endStory = "177874666780819473142",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177874666780819473139"] = {
      isStoryNode = true,
      key = "177874666780819473139",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1118, y = 276},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874666780819473142"] = {
      isStoryNode = true,
      key = "177874666780819473142",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1998, y = 276},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874667103519473179"] = {
      isStoryNode = true,
      key = "177874667103519473179",
      type = "StoryNode",
      name = "再次与史蒂芬交谈",
      pos = {x = 1502, y = 266.0000000000001},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040409_02",
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
            startQuest = "177874667103519473187",
            startPort = "Out",
            endQuest = "177874667103519473189",
            endPort = "In"
          },
          {
            startQuest = "177874667103519473189",
            startPort = "Out",
            endQuest = "177874667103519473188",
            endPort = "In"
          },
          {
            startQuest = "177874667103519473188",
            startPort = "Out",
            endQuest = "177874667103519473190",
            endPort = "In"
          },
          {
            startQuest = "177874667103519473184",
            startPort = "QuestStart",
            endQuest = "177874667103519473191",
            endPort = "In"
          },
          {
            startQuest = "177874667103519473184",
            startPort = "QuestStart",
            endQuest = "177874668348719473542",
            endPort = "In"
          },
          {
            startQuest = "177874667103519473190",
            startPort = "Out",
            endQuest = "177874669819819473852",
            endPort = "In"
          },
          {
            startQuest = "177874667103519473184",
            startPort = "QuestStart",
            endQuest = "177874671843919474382",
            endPort = "In"
          },
          {
            startQuest = "177874671843919474382",
            startPort = "Out",
            endQuest = "177874667103519473186",
            endPort = "Fail"
          },
          {
            startQuest = "177874667103519473184",
            startPort = "QuestStart",
            endQuest = "17787548727631116",
            endPort = "In"
          },
          {
            startQuest = "17787548727631116",
            startPort = "Out",
            endQuest = "177874667103519473187",
            endPort = "In"
          }
        },
        nodeData = {
          ["177874667103519473184"] = {
            key = "177874667103519473184",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 600.494021282042, y = 304.36940066552097},
            propsData = {ModeType = 0}
          },
          ["177874667103519473185"] = {
            key = "177874667103519473185",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2693.294314381271, y = 281.68896321070235},
            propsData = {ModeType = 0}
          },
          ["177874667103519473186"] = {
            key = "177874667103519473186",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1661.392572944297, y = 695.7427055702917},
            propsData = {}
          },
          ["177874667103519473187"] = {
            key = "177874667103519473187",
            type = "ChangeStaticCreatorNode",
            name = "销毁史蒂芬/芙罗拉",
            pos = {x = 1345.0303741857292, y = 302.6450958608965},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {272640019, 272640017}
            }
          },
          ["177874667103519473188"] = {
            key = "177874667103519473188",
            type = "TalkNode",
            name = "与史蒂芬交谈",
            pos = {x = 1909.6521739130433, y = 295.7608695652174},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100415,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Shidifen_272640020",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10046501.10046501'",
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
          ["177874667103519473189"] = {
            key = "177874667103519473189",
            type = "ChangeStaticCreatorNode",
            name = "生成史蒂芬",
            pos = {x = 1609.7370095440085, y = 295.601802757158},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272640020}
            }
          },
          ["177874667103519473190"] = {
            key = "177874667103519473190",
            type = "ChangeStaticCreatorNode",
            name = "销毁",
            pos = {x = 2168.034825334639, y = 303.8362487517589},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {272640020}
            }
          },
          ["177874667103519473191"] = {
            key = "177874667103519473191",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 1339.9807451494764, y = 465.3735302992268},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = true,
              IsSync = false,
              StaticCreatorIdList = {272640052}
            }
          },
          ["177874668348719473542"] = {
            key = "177874668348719473542",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1323.578947368421, y = 125.36842105263156},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177874669819819473852"] = {
            key = "177874669819819473852",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2462.587713430734, y = 277.12191515578263},
            propsData = {}
          },
          ["177874671843919474382"] = {
            key = "177874671843919474382",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1321.1951404864367, y = 703.6073262963662},
            propsData = {}
          },
          ["17787548727631116"] = {
            key = "17787548727631116",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1075.5862068965516, y = 295.58620689655174},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_ShidifenRE",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
