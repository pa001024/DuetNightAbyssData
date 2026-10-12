return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178703526904214561383",
      startPort = "StoryStart",
      endStory = "178703527277414561569",
      endPort = "In"
    },
    {
      startStory = "178703527277414561569",
      startPort = "Success",
      endStory = "178703526904214561386",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178703526904214561383"] = {
      isStoryNode = true,
      key = "178703526904214561383",
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
    ["178703526904214561386"] = {
      isStoryNode = true,
      key = "178703526904214561386",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1600, y = 294},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178703527277414561569"] = {
      isStoryNode = true,
      key = "178703527277414561569",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1203.4782608695652, y = 288.43478260869557},
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
            startQuest = "178703527277414561574",
            startPort = "QuestStart",
            endQuest = "178738981635422641332",
            endPort = "In"
          },
          {
            startQuest = "178703527277414561574",
            startPort = "QuestStart",
            endQuest = "178739006918022641706",
            endPort = "In"
          },
          {
            startQuest = "178738981635422641332",
            startPort = "Out",
            endQuest = "178739013583322643017",
            endPort = "In"
          },
          {
            startQuest = "178739018299922644013",
            startPort = "Out",
            endQuest = "178739021547922644447",
            endPort = "In"
          },
          {
            startQuest = "178739021547922644447",
            startPort = "Out",
            endQuest = "178739023979622644773",
            endPort = "In"
          },
          {
            startQuest = "178739023979622644773",
            startPort = "Out",
            endQuest = "178739006374922641611",
            endPort = "In"
          },
          {
            startQuest = "178739013583322643017",
            startPort = "Out",
            endQuest = "178739018299922644013",
            endPort = "In"
          },
          {
            startQuest = "178739006918022641706",
            startPort = "Out",
            endQuest = "178703527277414561576",
            endPort = "Fail"
          },
          {
            startQuest = "178739023979622644773",
            startPort = "Out",
            endQuest = "179178533322913691574",
            endPort = "In"
          }
        },
        nodeData = {
          ["178703527277414561574"] = {
            key = "178703527277414561574",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1107.7777777777778, y = 297.7777777777778},
            propsData = {ModeType = 0}
          },
          ["178703527277414561575"] = {
            key = "178703527277414561575",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2894.285714285714, y = 472.8571428571429},
            propsData = {ModeType = 0}
          },
          ["178703527277414561576"] = {
            key = "178703527277414561576",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1727.063492063492, y = 505.0634920634921},
            propsData = {}
          },
          ["178738981635422641332"] = {
            key = "178738981635422641332",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1415.7777777777778, y = 299.7777777777778},
            propsData = {QuestRoleId = 41030101, IsPlayFX = false}
          },
          ["178739006374922641611"] = {
            key = "178739006374922641611",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2895.714285714286, y = 289.7142857142857},
            propsData = {}
          },
          ["178739006918022641706"] = {
            key = "178739006918022641706",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1413.7777777777778, y = 489.7777777777778},
            propsData = {}
          },
          ["178739013583322643017"] = {
            key = "178739013583322643017",
            type = "ChangeStaticCreatorNode",
            name = "生成工作人员和苏珊娜",
            pos = {x = 1707.777777777778, y = 298.3492063492064},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351970006, 351970008}
            }
          },
          ["178739018299922644013"] = {
            key = "178739018299922644013",
            type = "TalkNode",
            name = "对话剧院票务员",
            pos = {x = 2002.8571428571431, y = 292},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 260026,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_TheaWoman120706_351970006",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070678,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120706/12070601.12070601'",
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
          ["178739021547922644447"] = {
            key = "178739021547922644447",
            type = "GoToNode",
            name = "到达苏珊娜附近",
            pos = {x = 2301.428571428572, y = 293.4285714285714},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351970007,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351970007"
            }
          },
          ["178739023979622644773"] = {
            key = "178739023979622644773",
            type = "TalkNode",
            name = "对话苏珊娜",
            pos = {x = 2597.7142857142862, y = 288.5714285714286},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070687,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120706/12070602.12070602'",
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
          ["179178533322913691574"] = {
            key = "179178533322913691574",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2896.5750000000003, y = 135.2999999999999},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
