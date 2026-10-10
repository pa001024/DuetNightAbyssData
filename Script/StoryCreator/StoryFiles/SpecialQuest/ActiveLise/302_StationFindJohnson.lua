return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17870347357056720930",
      startPort = "StoryStart",
      endStory = "17870347424896721224",
      endPort = "In"
    },
    {
      startStory = "17870347424896721224",
      startPort = "Success",
      endStory = "17870347357056720933",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17870347357056720930"] = {
      isStoryNode = true,
      key = "17870347357056720930",
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
    ["17870347357056720933"] = {
      isStoryNode = true,
      key = "17870347357056720933",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1626, y = 298},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17870347424896721224"] = {
      isStoryNode = true,
      key = "17870347424896721224",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1224, y = 274.00000000000017},
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
            startQuest = "17870347424896721229",
            startPort = "QuestStart",
            endQuest = "17872996502274555650",
            endPort = "In"
          },
          {
            startQuest = "17870347424896721229",
            startPort = "QuestStart",
            endQuest = "17872996408514555498",
            endPort = "In"
          },
          {
            startQuest = "17872996408514555498",
            startPort = "Out",
            endQuest = "17872997089024556950",
            endPort = "In"
          },
          {
            startQuest = "17872997089024556950",
            startPort = "Out",
            endQuest = "17872998376434558145",
            endPort = "In"
          },
          {
            startQuest = "17872999320374559409",
            startPort = "Out",
            endQuest = "17872999762804559914",
            endPort = "In"
          },
          {
            startQuest = "17872999762804559914",
            startPort = "Out",
            endQuest = "17873001989544561443",
            endPort = "In"
          },
          {
            startQuest = "17873001989544561443",
            startPort = "Out",
            endQuest = "17873004785574562934",
            endPort = "In"
          },
          {
            startQuest = "17873004785574562934",
            startPort = "Out",
            endQuest = "17873001231094560543",
            endPort = "In"
          },
          {
            startQuest = "17873001231094560543",
            startPort = "Out",
            endQuest = "17873874278911136251",
            endPort = "In"
          },
          {
            startQuest = "17872998376434558145",
            startPort = "Out",
            endQuest = "17880710595202269518",
            endPort = "In"
          },
          {
            startQuest = "17880710595202269518",
            startPort = "Out",
            endQuest = "17872999320374559409",
            endPort = "In"
          },
          {
            startQuest = "17872996502274555650",
            startPort = "Out",
            endQuest = "17870347424896721231",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17870347424896721229"] = {
            key = "17870347424896721229",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 517.7272727272727, y = 294.54545454545456},
            propsData = {ModeType = 0}
          },
          ["17870347424896721230"] = {
            key = "17870347424896721230",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3384.318181818182, y = 470.31818181818187},
            propsData = {ModeType = 0}
          },
          ["17870347424896721231"] = {
            key = "17870347424896721231",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1126.1599650349651, y = 516.4877622377624},
            propsData = {}
          },
          ["17872996408514555498"] = {
            key = "17872996408514555498",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 820.8976023976022, y = 297.8516158763838},
            propsData = {QuestRoleId = 41030101, IsPlayFX = false}
          },
          ["17872996502274555650"] = {
            key = "17872996502274555650",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 823.637987012987, y = 498.04392356869147},
            propsData = {}
          },
          ["17872997089024556950"] = {
            key = "17872997089024556950",
            type = "GoToNode",
            name = "前往车站大厅",
            pos = {x = 1100.9073565753129, y = 285.9241192244289},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 352480711,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_352480711"
            }
          },
          ["17872998376434558145"] = {
            key = "17872998376434558145",
            type = "ChangeStaticCreatorNode",
            name = "生成中校和队列",
            pos = {x = 1380.368895036851, y = 297.4625807628904},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                352480715,
                352480716,
                352480717,
                352480718,
                352480719,
                352480720,
                352480721,
                352480722
              }
            }
          },
          ["17872999320374559409"] = {
            key = "17872999320374559409",
            type = "TalkNode",
            name = "闸机前感慨",
            pos = {x = 1944.8723915403477, y = 288.1478954482051},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070347,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120703/12070307.12070307'",
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
          ["17872999762804559914"] = {
            key = "17872999762804559914",
            type = "GoToNode",
            name = "前往队列附近",
            pos = {x = 2228.372391540348, y = 286.6478954482051},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 352480713,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_352480713"
            }
          },
          ["17873001231094560543"] = {
            key = "17873001231094560543",
            type = "TalkNode",
            name = "站台附近再对话",
            pos = {x = 3093.872391540348, y = 286.6478954482051},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070370,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120703/12070309.12070309'",
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
          ["17873001989544561443"] = {
            key = "17873001989544561443",
            type = "TalkNode",
            name = "列队整兵",
            pos = {x = 2510.372391540348, y = 285.1478954482051},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070351,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120703/12070308.12070308'",
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
          ["17873004785574562934"] = {
            key = "17873004785574562934",
            type = "GoToNode",
            name = "前往站台附近",
            pos = {x = 2805.872391540348, y = 285.1478954482051},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 352480714,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_352480714"
            }
          },
          ["17873874278911136251"] = {
            key = "17873874278911136251",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 3384.4166666666665, y = 280.3598484848484},
            propsData = {}
          },
          ["17880710595202269518"] = {
            key = "17880710595202269518",
            type = "GoToNode",
            name = "前往闸机前",
            pos = {x = 1665.0000000000002, y = 288.2370414673043},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 352480712,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_352480712"
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
