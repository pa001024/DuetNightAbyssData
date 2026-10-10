return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17901695303192288073",
      startPort = "StoryStart",
      endStory = "17901695328322288163",
      endPort = "In"
    },
    {
      startStory = "17901695328322288163",
      startPort = "Success",
      endStory = "17901695303202288076",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17901695303192288073"] = {
      isStoryNode = true,
      key = "17901695303192288073",
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
    ["17901695303202288076"] = {
      isStoryNode = true,
      key = "17901695303202288076",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1548, y = 270},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17901695328322288163"] = {
      isStoryNode = true,
      key = "17901695328322288163",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1206, y = 270},
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
            startQuest = "17901695328322288164",
            startPort = "QuestStart",
            endQuest = "1790173706284456",
            endPort = "In"
          },
          {
            startQuest = "17901695328322288164",
            startPort = "QuestStart",
            endQuest = "1790173706284457",
            endPort = "In"
          },
          {
            startQuest = "1790173744869854",
            startPort = "Out",
            endQuest = "1790173744869855",
            endPort = "In"
          },
          {
            startQuest = "1790173744869855",
            startPort = "Out",
            endQuest = "1790173744869853",
            endPort = "In"
          },
          {
            startQuest = "1790173744869853",
            startPort = "Out",
            endQuest = "1790173744869856",
            endPort = "In"
          },
          {
            startQuest = "1790173744869856",
            startPort = "Out",
            endQuest = "1790173744869857",
            endPort = "In"
          },
          {
            startQuest = "1790173744869853",
            startPort = "Out",
            endQuest = "1790173744869859",
            endPort = "In"
          },
          {
            startQuest = "1790173706284456",
            startPort = "Out",
            endQuest = "1790173744869854",
            endPort = "In"
          },
          {
            startQuest = "1790173706284457",
            startPort = "Out",
            endQuest = "17901695328322288170",
            endPort = "Fail"
          },
          {
            startQuest = "1790173744869857",
            startPort = "Out",
            endQuest = "17902368892839165700",
            endPort = "In"
          },
          {
            startQuest = "17902368892839165700",
            startPort = "Out",
            endQuest = "17901739111622304",
            endPort = "In"
          },
          {
            startQuest = "1790173744869857",
            startPort = "Out",
            endQuest = "17902369116419166079",
            endPort = "In"
          },
          {
            startQuest = "1790173744869859",
            startPort = "Out",
            endQuest = "1790173744869861",
            endPort = "In"
          },
          {
            startQuest = "17904786862072439",
            startPort = "Out",
            endQuest = "1790173744869860",
            endPort = "In"
          },
          {
            startQuest = "1790173744869861",
            startPort = "Out",
            endQuest = "17904786862072439",
            endPort = "In"
          }
        },
        nodeData = {
          ["17901695328322288164"] = {
            key = "17901695328322288164",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17901695328322288167"] = {
            key = "17901695328322288167",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3100.210622710623, y = 425.9299034299034},
            propsData = {ModeType = 0}
          },
          ["17901695328322288170"] = {
            key = "17901695328322288170",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1399.448717948718, y = 578.5641025641027},
            propsData = {}
          },
          ["1790173706284456"] = {
            key = "1790173706284456",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1107.5483629642667, y = 304.9171779783909},
            propsData = {QuestRoleId = 41030101, IsPlayFX = false}
          },
          ["1790173706284457"] = {
            key = "1790173706284457",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1110.4610983981693, y = 566.4944090996723},
            propsData = {}
          },
          ["1790173744869853"] = {
            key = "1790173744869853",
            type = "TalkNode",
            name = "城门口开车",
            pos = {x = 1951.820356862481, y = 281.2369631516385},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 12070318,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1790173744869854"] = {
            key = "1790173744869854",
            type = "ChangeStaticCreatorNode",
            name = "生成卡森和两只",
            pos = {x = 1387.7852925583195, y = 294.89061462759145},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                351192092,
                351192093,
                351192095
              }
            }
          },
          ["1790173744869855"] = {
            key = "1790173744869855",
            type = "GoToNode",
            name = "前往城门口",
            pos = {x = 1663.4334996144205, y = 283.9937089017384},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351192091,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351192091"
            }
          },
          ["1790173744869856"] = {
            key = "1790173744869856",
            type = "KillMonsterNode",
            name = "帮卡森击杀秽兽",
            pos = {x = 2240.850604877579, y = 281.200287849107},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 4,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                351192094,
                351192096,
                351192097,
                351192098
              }
            }
          },
          ["1790173744869857"] = {
            key = "1790173744869857",
            type = "TalkNode",
            name = "对话卡森",
            pos = {x = 2535.150604877578, y = 276.25028784910694},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070321,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120703/12070305.12070305'",
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
          ["1790173744869859"] = {
            key = "1790173744869859",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 2234.2458418959104, y = 100.61252636252618},
            propsData = {WaitTime = 0.1}
          },
          ["1790173744869860"] = {
            key = "1790173744869860",
            type = "ChangeStaticCreatorNode",
            name = "生成目标四只",
            pos = {x = 3084.067270467339, y = 112.75538350538312},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                351192096,
                351192097,
                351192098,
                351192094
              }
            }
          },
          ["1790173744869861"] = {
            key = "1790173744869861",
            type = "ChangeStaticCreatorNode",
            name = "销毁看到的两只",
            pos = {x = 2517.339123614192, y = 112.76159951159957},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351192093, 351192095}
            }
          },
          ["17901739111622304"] = {
            key = "17901739111622304",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 3102.5210622710615, y = 273.2005494505496},
            propsData = {}
          },
          ["17902368892839165700"] = {
            key = "17902368892839165700",
            type = "GoToNode",
            name = "前往城门口",
            pos = {x = 2821.1932773109243, y = 276.05042016806715},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351192091,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351192091"
            }
          },
          ["17902369116419166079"] = {
            key = "17902369116419166079",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 2823.9854851031323, y = 429.94652406417106},
            propsData = {
              NewDescription = "Description_120703_4",
              NewDetail = "Content_120703_4",
              SubTaskTargetIndex = 0
            }
          },
          ["17904786862072439"] = {
            key = "17904786862072439",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 2815.6651609260307, y = 102.42941840767918},
            propsData = {WaitTime = 0.1}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
