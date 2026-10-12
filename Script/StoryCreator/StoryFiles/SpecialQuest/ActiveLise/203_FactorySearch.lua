return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17870345165493361686",
      startPort = "StoryStart",
      endStory = "17870345233493361945",
      endPort = "In"
    },
    {
      startStory = "17870345233493361945",
      startPort = "Success",
      endStory = "17870345165493361689",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17870345165493361686"] = {
      isStoryNode = true,
      key = "17870345165493361686",
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
    ["17870345165493361689"] = {
      isStoryNode = true,
      key = "17870345165493361689",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1618, y = 298},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17870345233493361945"] = {
      isStoryNode = true,
      key = "17870345233493361945",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1208, y = 277.4090909090909},
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
            startQuest = "17870345233493361946",
            startPort = "QuestStart",
            endQuest = "17872194100845636751",
            endPort = "In"
          },
          {
            startQuest = "17870345233493361946",
            startPort = "QuestStart",
            endQuest = "17872193968615636421",
            endPort = "In"
          },
          {
            startQuest = "17872194572845638067",
            startPort = "Out",
            endQuest = "17872194731405638366",
            endPort = "In"
          },
          {
            startQuest = "17872194731405638366",
            startPort = "Out",
            endQuest = "17872194971655638746",
            endPort = "In"
          },
          {
            startQuest = "17872194971655638746",
            startPort = "Out",
            endQuest = "17872196106545640357",
            endPort = "In"
          },
          {
            startQuest = "17872196720075641335",
            startPort = "Out",
            endQuest = "17872195194295639160",
            endPort = "In"
          },
          {
            startQuest = "17872195900945639811",
            startPort = "Out",
            endQuest = "17872197187525642163",
            endPort = "In"
          },
          {
            startQuest = "17872197187525642163",
            startPort = "Out",
            endQuest = "17872198265145642746",
            endPort = "In"
          },
          {
            startQuest = "17872198265145642746",
            startPort = "Out",
            endQuest = "17872275400665645099",
            endPort = "In"
          },
          {
            startQuest = "17872275674185645578",
            startPort = "Out",
            endQuest = "17872276287355646333",
            endPort = "In"
          },
          {
            startQuest = "17872275400665645099",
            startPort = "Out",
            endQuest = "17872275674185645578",
            endPort = "In"
          },
          {
            startQuest = "17872193968615636421",
            startPort = "Out",
            endQuest = "17880719094546795203",
            endPort = "In"
          },
          {
            startQuest = "17880719094546795203",
            startPort = "Out",
            endQuest = "17872194572845638067",
            endPort = "In"
          },
          {
            startQuest = "17872196106545640357",
            startPort = "Out",
            endQuest = "17880789413181435",
            endPort = "In"
          },
          {
            startQuest = "17880789413181435",
            startPort = "Out",
            endQuest = "17872195900945639811",
            endPort = "In"
          },
          {
            startQuest = "17880789413181435",
            startPort = "Out",
            endQuest = "17872196720075641335",
            endPort = "In"
          },
          {
            startQuest = "17872194971655638746",
            startPort = "Out",
            endQuest = "17884912675512141",
            endPort = "In"
          },
          {
            startQuest = "17872198265145642746",
            startPort = "Out",
            endQuest = "17884913097192850",
            endPort = "In"
          },
          {
            startQuest = "17872194100845636751",
            startPort = "Out",
            endQuest = "17870345233493361952",
            endPort = "Fail"
          },
          {
            startQuest = "17872275674185645578",
            startPort = "Out",
            endQuest = "17917818690721143922",
            endPort = "In"
          }
        },
        nodeData = {
          ["17870345233493361946"] = {
            key = "17870345233493361946",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 520, y = 286.6666666666667},
            propsData = {ModeType = 0}
          },
          ["17870345233493361949"] = {
            key = "17870345233493361949",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 4177.812136712392, y = 438.07225063938614},
            propsData = {ModeType = 0}
          },
          ["17870345233493361952"] = {
            key = "17870345233493361952",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1129.370986755426, y = 468.2545593232091},
            propsData = {}
          },
          ["17872193968615636421"] = {
            key = "17872193968615636421",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 830.3478260869565, y = 283.536231884058},
            propsData = {QuestRoleId = 41030101, IsPlayFX = false}
          },
          ["17872194100845636751"] = {
            key = "17872194100845636751",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 837.363081617086, y = 447.93440122044234},
            propsData = {}
          },
          ["17872194572845638067"] = {
            key = "17872194572845638067",
            type = "ChangeStaticCreatorNode",
            name = "生成npc道吉",
            pos = {x = 1376.826463391681, y = 297.6071899115378},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890224}
            }
          },
          ["17872194731405638366"] = {
            key = "17872194731405638366",
            type = "GoToNode",
            name = "前往道吉附近",
            pos = {x = 1657.3337097684926, y = 286.17108977978546},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 352890223,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_352890223"
            }
          },
          ["17872194971655638746"] = {
            key = "17872194971655638746",
            type = "TalkNode",
            name = "触发道吉站桩",
            pos = {x = 1934.2704686617737, y = 288.8390739695087},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070147,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120702/12070207.12070207'",
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
          ["17872195194295639160"] = {
            key = "17872195194295639160",
            type = "ChangeStaticCreatorNode",
            name = "生成怪物催债人",
            pos = {x = 3043.697927392301, y = 127.64487494602575},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890225}
            }
          },
          ["17872195900945639811"] = {
            key = "17872195900945639811",
            type = "KillMonsterNode",
            name = "击杀怪物催债人",
            pos = {x = 2757.9451954694923, y = 283.3217524163815},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 1,
              IsShow = false,
              GuideType = "P",
              GuideName = "Monster_Cuizhai120702_352890225",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {352890225}
            }
          },
          ["17872196106545640357"] = {
            key = "17872196106545640357",
            type = "ChangeNpcDefaultDataNode",
            name = "修改npc道吉动作",
            pos = {x = 2217.6935330654005, y = 302.9851795263558},
            propsData = {
              ChangeNpcDefaultDataList = {
                {
                  TargetNpcUnitId = 260013,
                  DefaultActionId = 2,
                  DefaultFacialId = 1
                }
              }
            }
          },
          ["17872196720075641335"] = {
            key = "17872196720075641335",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 2764.543660942639, y = 114.79101778369774},
            propsData = {WaitTime = 0.2}
          },
          ["17872197187525642163"] = {
            key = "17872197187525642163",
            type = "ChangeStaticCreatorNode",
            name = "销毁怪物催债人",
            pos = {x = 3044.907008680535, y = 302.3346122966017},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890225}
            }
          },
          ["17872198265145642746"] = {
            key = "17872198265145642746",
            type = "TalkNode",
            name = "触发催债人对话",
            pos = {x = 3310.2772112797693, y = 281.72096190254746},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070189,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120702/12070208.12070208'",
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
          ["17872275400665645099"] = {
            key = "17872275400665645099",
            type = "ChangeNpcDefaultDataNode",
            name = "修改npc道吉动作",
            pos = {x = 3600.532988111634, y = 292.86418888017323},
            propsData = {
              ChangeNpcDefaultDataList = {
                {
                  TargetNpcUnitId = 260013,
                  DefaultActionId = 1,
                  DefaultFacialId = 1
                }
              }
            }
          },
          ["17872275674185645578"] = {
            key = "17872275674185645578",
            type = "TalkNode",
            name = "对话道吉",
            pos = {x = 3887.150635170458, y = 284.5553653507615},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 260013,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Daoji120702_352890224",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070198,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120702/12070209.12070209'",
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
          ["17872276287355646333"] = {
            key = "17872276287355646333",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 4175.9006351704575, y = 284.5553653507615},
            propsData = {}
          },
          ["17880719094546795203"] = {
            key = "17880719094546795203",
            type = "GoToNode",
            name = "前往工厂附近触发盒",
            pos = {x = 1107.898348813209, y = 289.6682146542827},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 352890222,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_352890222"
            }
          },
          ["17880789413181435"] = {
            key = "17880789413181435",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "传送到战斗地点",
            pos = {x = 2487.1176691729324, y = 277.5952675807166},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_FactoryBattle_1207",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17884912675512141"] = {
            key = "17884912675512141",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务栏-赶催债人",
            pos = {x = 2221.7171717171705, y = 121.23232323232318},
            propsData = {
              NewDescription = "Description_120702_3_2",
              NewDetail = "Content_120702_3_2",
              SubTaskTargetIndex = 0
            }
          },
          ["17884913097192850"] = {
            key = "17884913097192850",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务栏-查看道吉",
            pos = {x = 3600.6060606060596, y = 127.8989898989899},
            propsData = {
              NewDescription = "Description_120702_3_3",
              NewDetail = "Content_120702_3_3",
              SubTaskTargetIndex = 0
            }
          },
          ["17917818690721143922"] = {
            key = "17917818690721143922",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 4173.660732714139, y = 138.68361411550268},
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
