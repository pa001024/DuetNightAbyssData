return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17809034147862963253",
      startPort = "StoryStart",
      endStory = "17809034147862963255",
      endPort = "In"
    },
    {
      startStory = "17809034147862963255",
      startPort = "Success",
      endStory = "17809034147862963254",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17809034147862963253"] = {
      isStoryNode = true,
      key = "17809034147862963253",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1670.7857142857142, y = 326.15714285714284},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17809034147862963254"] = {
      isStoryNode = true,
      key = "17809034147862963254",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2353.4285714285716, y = 306.3},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17809034147862963255"] = {
      isStoryNode = true,
      key = "17809034147862963255",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 2013.9853174603174, y = 312.43571428571425},
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestRegion_152480434",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17809033421972038638",
            startPort = "Out",
            endQuest = "17809033440342038688",
            endPort = "In"
          },
          {
            startQuest = "17809034147862963256",
            startPort = "QuestStart",
            endQuest = "17809035275073053780",
            endPort = "In"
          },
          {
            startQuest = "17809035275073053780",
            startPort = "Out",
            endQuest = "17809034147862963258",
            endPort = "Fail"
          },
          {
            startQuest = "17809033440342038688",
            startPort = "Out",
            endQuest = "1781768418055595",
            endPort = "In"
          },
          {
            startQuest = "1782197711479673",
            startPort = "Out",
            endQuest = "1782197711479674",
            endPort = "In"
          },
          {
            startQuest = "1782197711479674",
            startPort = "Out",
            endQuest = "1782197711479675",
            endPort = "In"
          },
          {
            startQuest = "1781768418055595",
            startPort = "Out",
            endQuest = "1782197711479673",
            endPort = "In"
          },
          {
            startQuest = "1782197711479675",
            startPort = "Out",
            endQuest = "17809033638442039322",
            endPort = "In"
          },
          {
            startQuest = "17809034147862963256",
            startPort = "QuestStart",
            endQuest = "1782224664727572",
            endPort = "In"
          },
          {
            startQuest = "17809034147862963256",
            startPort = "QuestStart",
            endQuest = "1782185843379457",
            endPort = "In"
          },
          {
            startQuest = "1782224664727572",
            startPort = "Out",
            endQuest = "17809033421972038638",
            endPort = "In"
          },
          {
            startQuest = "1781768418055595",
            startPort = "Out",
            endQuest = "1782298934509548",
            endPort = "In"
          },
          {
            startQuest = "1781768418055595",
            startPort = "Out",
            endQuest = "17827869213511021",
            endPort = "Input"
          }
        },
        nodeData = {
          ["17809033421972038638"] = {
            key = "17809033421972038638",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2166.8934379861626, y = -39.94208054587548},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480450}
            }
          },
          ["17809033440342038688"] = {
            key = "17809033440342038688",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 2543.8934379861626, y = -41.560262364057294},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 1,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {152480450}
            }
          },
          ["17809033638442039322"] = {
            key = "17809033638442039322",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 3999.400494981454, y = -66.34327329017974},
            propsData = {}
          },
          ["17809034147862963256"] = {
            key = "17809034147862963256",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1309.5307060130638, y = -45.934550558076076},
            propsData = {ModeType = 0}
          },
          ["17809034147862963257"] = {
            key = "17809034147862963257",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 4236.991656178618, y = -75.95344740176243},
            propsData = {ModeType = 0}
          },
          ["17809034147862963258"] = {
            key = "17809034147862963258",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3223.920290236078, y = 333.2188863767813},
            propsData = {}
          },
          ["17809035275073053780"] = {
            key = "17809035275073053780",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1705.0618854829381, y = 336.2244794679006},
            propsData = {}
          },
          ["1781768418055595"] = {
            key = "1781768418055595",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 2891.1934822573357, y = -49.885135074763596},
            propsData = {WaitTime = 2}
          },
          ["1782185843379457"] = {
            key = "1782185843379457",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1738.9901283768054, y = -220.21540649073683},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["1782197711479673"] = {
            key = "1782197711479673",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 3138.460043158685, y = -41.91983787664842},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480448}
            }
          },
          ["1782197711479674"] = {
            key = "1782197711479674",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 3416.7025717018428, y = -75.11481391510283},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700462,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Liewei_152480448",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = false,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51213184,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700461,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700462,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700458,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1782197711479675"] = {
            key = "1782197711479675",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 3706.1197404789086, y = -62.52518338925954},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480448}
            }
          },
          ["1782224664727572"] = {
            key = "1782224664727572",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1715.4710383404451, y = -40.36429805331732},
            propsData = {
              VarName = "First20040613",
              VarValue = 1
            }
          },
          ["1782298934509548"] = {
            key = "1782298934509548",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 3134.055481283423, y = -429.47503395297514},
            propsData = {
              NewDescription = "Content_20040614",
              NewDetail = "Description_20040614",
              SubTaskTargetIndex = 0
            }
          },
          ["17827869213511021"] = {
            key = "17827869213511021",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 3143.268274853799, y = -228.7682748538011},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 2,
              IsStandAlone = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
