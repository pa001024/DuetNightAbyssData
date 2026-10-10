return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17870348019387840722",
      startPort = "StoryStart",
      endStory = "17870348058767840921",
      endPort = "In"
    },
    {
      startStory = "17870348058767840921",
      startPort = "Success",
      endStory = "17870348019387840725",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17870348019387840722"] = {
      isStoryNode = true,
      key = "17870348019387840722",
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
    ["17870348019387840725"] = {
      isStoryNode = true,
      key = "17870348019387840725",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1554, y = 298},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17870348058767840921"] = {
      isStoryNode = true,
      key = "17870348058767840921",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1173.7692307692307, y = 276.61538461538464},
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
            startQuest = "17870348058777840926",
            startPort = "QuestStart",
            endQuest = "17873020239255692113",
            endPort = "In"
          },
          {
            startQuest = "17870348058777840926",
            startPort = "QuestStart",
            endQuest = "17873020366045692317",
            endPort = "In"
          },
          {
            startQuest = "17873049992345707105",
            startPort = "Out",
            endQuest = "17873050903325707808",
            endPort = "In"
          },
          {
            startQuest = "17873050903325707808",
            startPort = "Out",
            endQuest = "17873874593792265534",
            endPort = "In"
          },
          {
            startQuest = "17873022663985694729",
            startPort = "Out",
            endQuest = "178774469990912467681",
            endPort = "In"
          },
          {
            startQuest = "178774469990912467681",
            startPort = "Out",
            endQuest = "178774480279112469493",
            endPort = "In"
          },
          {
            startQuest = "178774480279112469493",
            startPort = "Out",
            endQuest = "17873048713275706053",
            endPort = "In"
          },
          {
            startQuest = "17873048713275706053",
            startPort = "Out",
            endQuest = "17873049992345707105",
            endPort = "In"
          },
          {
            startQuest = "17870348058777840926",
            startPort = "QuestStart",
            endQuest = "17873022427645694373",
            endPort = "In"
          },
          {
            startQuest = "17873020239255692113",
            startPort = "Out",
            endQuest = "17873022663985694729",
            endPort = "In"
          },
          {
            startQuest = "17873020366045692317",
            startPort = "Out",
            endQuest = "17870348058777840928",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17870348058777840926"] = {
            key = "17870348058777840926",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1675.5637254901962, y = 286.22549019607845},
            propsData = {ModeType = 0}
          },
          ["17870348058777840927"] = {
            key = "17870348058777840927",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 4103.283824534599, y = 435.8070842212482},
            propsData = {ModeType = 0}
          },
          ["17870348058777840928"] = {
            key = "17870348058777840928",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2297.0075757575755, y = 474.30035650623887},
            propsData = {}
          },
          ["17873020239255692113"] = {
            key = "17873020239255692113",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1980.8792335115863, y = 289.11853832442057},
            propsData = {QuestRoleId = 41030101, IsPlayFX = false}
          },
          ["17873020366045692317"] = {
            key = "17873020366045692317",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1979.6813725490197, y = 465.7549019607842},
            propsData = {}
          },
          ["17873022427645694373"] = {
            key = "17873022427645694373",
            type = "ChangeStaticCreatorNode",
            name = "卫兵卡戎民/中校随从",
            pos = {x = 1974.7033358798071, y = 128.32938629997435},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                351192112,
                351192113,
                351192114,
                351192115,
                351192117,
                351192116,
                351192109,
                351192110,
                351192111
              }
            }
          },
          ["17873022663985694729"] = {
            key = "17873022663985694729",
            type = "TalkNode",
            name = "门口盯梢站桩",
            pos = {x = 2295.9956709956714, y = 275.84848484848453},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070388,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120703/12070310.12070310'",
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
              HideNpcs = true,
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
          ["17873048713275706053"] = {
            key = "17873048713275706053",
            type = "GoToNode",
            name = "前往终点",
            pos = {x = 3221.746948107307, y = 266.16865118212854},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351192120,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351192120"
            }
          },
          ["17873049992345707105"] = {
            key = "17873049992345707105",
            type = "TalkNode",
            name = "终点对话",
            pos = {x = 3510.55647191683, y = 268.78769880117613},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070411,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120703/12070311.12070311'",
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
          ["17873050903325707808"] = {
            key = "17873050903325707808",
            type = "ChangeStaticCreatorNode",
            name = "销毁三段军官及随从",
            pos = {x = 3807.3985771799885, y = 284.18243564328145},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                351192124,
                351192125,
                351192126
              }
            }
          },
          ["17873874593792265534"] = {
            key = "17873874593792265534",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 4102.1881307546955, y = 268.4922516853631},
            propsData = {}
          },
          ["178774469990912467681"] = {
            key = "178774469990912467681",
            type = "ChangeStaticCreatorNode",
            name = "销毁一段军官及随从",
            pos = {x = 2614.955478053025, y = 295.86645541102854},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                351192109,
                351192110,
                351192111
              }
            }
          },
          ["178774480279112469493"] = {
            key = "178774480279112469493",
            type = "ChangeStaticCreatorNode",
            name = "生成终点军官及随从",
            pos = {x = 2917.543883850129, y = 297.47142435512797},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                351192124,
                351192125,
                351192126
              }
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
