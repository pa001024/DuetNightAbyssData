return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17798653768173634",
      startPort = "Success",
      endStory = "17798695637332930886",
      endPort = "In"
    },
    {
      startStory = "17798695637332930886",
      startPort = "Success",
      endStory = "17798719336867317658",
      endPort = "In"
    },
    {
      startStory = "17798719336867317658",
      startPort = "Success",
      endStory = "17798719529697317875",
      endPort = "In"
    },
    {
      startStory = "17798719529697317875",
      startPort = "Success",
      endStory = "17798719698287318124",
      endPort = "In"
    },
    {
      startStory = "17798719698287318124",
      startPort = "Success",
      endStory = "177988339838217542611",
      endPort = "StoryEnd"
    },
    {
      startStory = "177988339838217542610",
      startPort = "StoryStart",
      endStory = "178062921858312129407",
      endPort = "In"
    },
    {
      startStory = "178062921858312129407",
      startPort = "Success",
      endStory = "17798653768173634",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17798653768173634"] = {
      isStoryNode = true,
      key = "17798653768173634",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1360.3165554252516, y = 273.40511239967776},
      propsData = {
        QuestId = 20040701,
        QuestDescriptionComment = "",
        QuestDescription = "Content_20040701",
        QuestDeatil = "Description_20040701",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = true,
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
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Xudun_200407_132480427",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17798656457786037",
            startPort = "Out",
            endQuest = "17798655834755419",
            endPort = "In"
          },
          {
            startQuest = "17798656457786037",
            startPort = "Out",
            endQuest = "17798656139715749",
            endPort = "In"
          },
          {
            startQuest = "17798656457786037",
            startPort = "Out",
            endQuest = "17798656987026906",
            endPort = "In"
          },
          {
            startQuest = "17798656987026906",
            startPort = "Out",
            endQuest = "17798655834755419",
            endPort = "Stop"
          },
          {
            startQuest = "17798656987026906",
            startPort = "Out",
            endQuest = "17798656139715749",
            endPort = "Stop"
          },
          {
            startQuest = "17798692068108018",
            startPort = "Out",
            endQuest = "17798692068108019",
            endPort = "In"
          },
          {
            startQuest = "17798656987026906",
            startPort = "Out",
            endQuest = "17798692068108018",
            endPort = "In"
          },
          {
            startQuest = "17798692068108019",
            startPort = "Out",
            endQuest = "17803852793956010785",
            endPort = "In"
          },
          {
            startQuest = "17803852793956010785",
            startPort = "Out",
            endQuest = "17798653768183638",
            endPort = "Success"
          },
          {
            startQuest = "17798653768173635",
            startPort = "QuestStart",
            endQuest = "17798656457786037",
            endPort = "In"
          },
          {
            startQuest = "17798656987026906",
            startPort = "Out",
            endQuest = "17810734964861924",
            endPort = "In"
          },
          {
            startQuest = "17810734964861924",
            startPort = "Out",
            endQuest = "178211454832513335810",
            endPort = "In"
          },
          {
            startQuest = "17798692068108019",
            startPort = "Out",
            endQuest = "178211777404434148920",
            endPort = "In"
          }
        },
        nodeData = {
          ["17798653768173635"] = {
            key = "17798653768173635",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1401.430769230769, y = 295.96923076923076},
            propsData = {ModeType = 0}
          },
          ["17798653768183638"] = {
            key = "17798653768183638",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3203.8618421052633, y = 295.625},
            propsData = {ModeType = 0}
          },
          ["17798653768183641"] = {
            key = "17798653768183641",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3177.1964285714284, y = 486.23214285714283},
            propsData = {}
          },
          ["17798655834755419"] = {
            key = "17798655834755419",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2241.3072787427623, y = -30.68107287449388},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100401,
              GuideUIEnable = false,
              GuideType = "N",
              GuidePointName = "",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51214008,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = true,
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
              TalkActors = {},
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
          ["17798656139715749"] = {
            key = "17798656139715749",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2240.7543859649118, y = 109.82972334682864},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100402,
              GuideUIEnable = false,
              GuideType = "N",
              GuidePointName = "",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51214011,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = true,
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
              TalkActors = {},
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
          ["17798656457786037"] = {
            key = "17798656457786037",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1679.4641025641026, y = 298.96508097166},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                132480427,
                132480428,
                132480429
              }
            }
          },
          ["17798656987026906"] = {
            key = "17798656987026906",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1999.214652014652, y = 272.109037015616},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700400,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Xudun_200407_132480427",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51214014,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = true,
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
              TalkActors = {},
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
          ["17798692068108018"] = {
            key = "17798692068108018",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2320.3239671760043, y = 275.8749999999999},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 132480426,
              GuideType = "M",
              GuidePointName = "Mechanism_20040701_132480426"
            }
          },
          ["17798692068108019"] = {
            key = "17798692068108019",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2601.4462406015036, y = 272.3120199692779},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51214036,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200407/51214036.51214036'",
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
          ["17803852793956010785"] = {
            key = "17803852793956010785",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2880.230590805076, y = 297.59003685102084},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                132480427,
                132480428,
                132480429
              }
            }
          },
          ["17810734964861924"] = {
            key = "17810734964861924",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 2319.415207373272, y = 441.8781954887218},
            propsData = {
              NewDescription = "Content_20040706",
              NewDetail = "Description_20040706",
              SubTaskTargetIndex = 0
            }
          },
          ["178211454832513335810"] = {
            key = "178211454832513335810",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2601.350689223057, y = 446.02395762132596},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_NewTargetPoint_20040701"
            }
          },
          ["178211777404434148920"] = {
            key = "178211777404434148920",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2880.9388995658464, y = 444.921668950328},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_NewTargetPoint_20040701"
            }
          }
        },
        commentData = {}
      }
    },
    ["17798695637332930886"] = {
      isStoryNode = true,
      key = "17798695637332930886",
      type = "StoryNode",
      name = "客运区",
      pos = {x = 1640.3832095907833, y = 272.9751882642837},
      propsData = {
        QuestId = 20040702,
        QuestDescriptionComment = "",
        QuestDescription = "Content_20040702",
        QuestDeatil = "Description_20040702",
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
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_NewTargetPoint_20040702",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17798695637332930891",
            startPort = "QuestStart",
            endQuest = "17798695637332930898",
            endPort = "In"
          },
          {
            startQuest = "17798695637332930898",
            startPort = "Out",
            endQuest = "17798740842708785509",
            endPort = "In"
          },
          {
            startQuest = "17798740842708785509",
            startPort = "Out",
            endQuest = "177988305818611715021",
            endPort = "In"
          },
          {
            startQuest = "17798740842708785509",
            startPort = "Out",
            endQuest = "177988304017511714591",
            endPort = "In"
          },
          {
            startQuest = "177988304017511714591",
            startPort = "Out",
            endQuest = "177988307708011715348",
            endPort = "Branch_1"
          },
          {
            startQuest = "177988305818611715021",
            startPort = "Out",
            endQuest = "177988307708011715348",
            endPort = "Branch_2"
          },
          {
            startQuest = "177988304017511714591",
            startPort = "Out",
            endQuest = "17800415155751483369",
            endPort = "Stop"
          },
          {
            startQuest = "177988305818611715021",
            startPort = "Out",
            endQuest = "17800415443431483869",
            endPort = "Stop"
          },
          {
            startQuest = "177988307708011715348",
            startPort = "Out",
            endQuest = "17800437873877392044",
            endPort = "In"
          },
          {
            startQuest = "177988304017511714591",
            startPort = "Out",
            endQuest = "178064412094218228607",
            endPort = "Stop"
          },
          {
            startQuest = "17800415155751483369",
            startPort = "Out",
            endQuest = "178064412094218228607",
            endPort = "In"
          },
          {
            startQuest = "178064412094218228607",
            startPort = "Out",
            endQuest = "17800415155751483369",
            endPort = "In"
          },
          {
            startQuest = "178064413145318228960",
            startPort = "Out",
            endQuest = "17800415443431483869",
            endPort = "In"
          },
          {
            startQuest = "177988305818611715021",
            startPort = "Out",
            endQuest = "178064413145318228960",
            endPort = "Stop"
          },
          {
            startQuest = "17800415443431483869",
            startPort = "Out",
            endQuest = "178064413145318228960",
            endPort = "In"
          },
          {
            startQuest = "17800437873877392044",
            startPort = "Out",
            endQuest = "17798695637332930892",
            endPort = "Success"
          },
          {
            startQuest = "17798740842708785509",
            startPort = "Out",
            endQuest = "178064412094218228607",
            endPort = "In"
          },
          {
            startQuest = "17798740842708785509",
            startPort = "Out",
            endQuest = "178064413145318228960",
            endPort = "In"
          },
          {
            startQuest = "17798695637332930898",
            startPort = "Out",
            endQuest = "178090321424313664593",
            endPort = "In"
          },
          {
            startQuest = "177988307708011715348",
            startPort = "Out",
            endQuest = "178090413197913665222",
            endPort = "In"
          }
        },
        nodeData = {
          ["17798695637332930891"] = {
            key = "17798695637332930891",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1603.092105263158, y = 297.1381578947369},
            propsData = {ModeType = 0}
          },
          ["17798695637332930892"] = {
            key = "17798695637332930892",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3213.2104152839283, y = 295.5188853544116},
            propsData = {ModeType = 0}
          },
          ["17798695637332930893"] = {
            key = "17798695637332930893",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3200.5138888888887, y = 489.09722222222223},
            propsData = {}
          },
          ["17798695637332930898"] = {
            key = "17798695637332930898",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1880.7672578184593, y = 294.227897909736},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {132480451, 132480452}
            }
          },
          ["17798696034014392608"] = {
            key = "17798696034014392608",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 3185.815473936184, y = 68.24613386232363},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {132480451, 132480452}
            }
          },
          ["17798740842708785509"] = {
            key = "17798740842708785509",
            type = "BranchQuestStartNode",
            name = "子任务开始节点",
            pos = {x = 2117.5633324849564, y = 295.8567751279992},
            propsData = {
              AllQuestOptions = {
                {
                  IsNeedFinish = true,
                  BranchQuestName = "",
                  TargetBranchQuestKey = ""
                },
                {
                  IsNeedFinish = true,
                  BranchQuestName = "",
                  TargetBranchQuestKey = ""
                }
              },
              IsSetCountInfo = true,
              IsDifftation = false,
              AllDiffGuideOptions = {}
            }
          },
          ["177988304017511714591"] = {
            key = "177988304017511714591",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2400.895262114755, y = 203.4571472342436},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700464,
              GuideUIEnable = false,
              GuideType = "N",
              GuidePointName = "Npc_Qingnian_200407_132480451",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51214051,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = true,
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
              TalkActors = {},
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
          ["177988305818611715021"] = {
            key = "177988305818611715021",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2402.3333892050564, y = 373.27320074594934},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700465,
              GuideUIEnable = false,
              GuideType = "N",
              GuidePointName = "Npc_Nvxing_200407_132480452",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51214062,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = true,
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
              TalkActors = {},
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
          ["177988307708011715348"] = {
            key = "177988307708011715348",
            type = "CheckBranchQuestFinishedNode",
            name = "子任务结束节点",
            pos = {x = 2641.045763786996, y = 270.5307258295613},
            propsData = {
              InputBranchQuestNumber = 2,
              BranchQuestFinishOptions = {
                {IsNeedFinish = true},
                {IsNeedFinish = true}
              }
            }
          },
          ["17800415155751483369"] = {
            key = "17800415155751483369",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2404.308468800459, y = 7.745078110295607},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51214049,
              FlowAssetPath = "",
              TalkType = "Bubble",
              BubblePlayType = "Once",
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              bBubblePlayCDEnable = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700464,
                  TalkActorVisible = true
                }
              },
              OverrideFailBlend = false
            }
          },
          ["17800415443431483869"] = {
            key = "17800415443431483869",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2406.498752201269, y = 557.0365760860043},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51214060,
              FlowAssetPath = "",
              TalkType = "Bubble",
              BubblePlayType = "Once",
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              bBubblePlayCDEnable = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700465,
                  TalkActorVisible = true
                }
              },
              OverrideFailBlend = false
            }
          },
          ["17800437873877392044"] = {
            key = "17800437873877392044",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2921.1546226466126, y = 274.2835396487572},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51214073,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["178064412094218228607"] = {
            key = "178064412094218228607",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 2395.8947368421054, y = -162.3157894736842},
            propsData = {WaitTime = 5}
          },
          ["178064413145318228960"] = {
            key = "178064413145318228960",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 2403.7894736842104, y = 721.8947368421051},
            propsData = {WaitTime = 5}
          },
          ["178090321424313664593"] = {
            key = "178090321424313664593",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2133.894736842105, y = 96.61184210526298},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_NewTargetPoint_20040702"
            }
          },
          ["178090413197913665222"] = {
            key = "178090413197913665222",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2924.4210526315787, y = 82.40131578947374},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_NewTargetPoint_20040702"
            }
          }
        },
        commentData = {}
      }
    },
    ["17798719336867317658"] = {
      isStoryNode = true,
      key = "17798719336867317658",
      type = "StoryNode",
      name = "货运区",
      pos = {x = 800.4986318029797, y = 472.46423685010643},
      propsData = {
        QuestId = 20040703,
        QuestDescriptionComment = "",
        QuestDescription = "Content_20040703",
        QuestDeatil = "Description_20040703",
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
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_NewTargetPoint_20040703",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17798719336877317663",
            startPort = "QuestStart",
            endQuest = "17798719336877317670",
            endPort = "In"
          },
          {
            startQuest = "17798719336877317670",
            startPort = "Out",
            endQuest = "17800414090495400",
            endPort = "In"
          },
          {
            startQuest = "17800414090495400",
            startPort = "Out",
            endQuest = "17800414500575682",
            endPort = "Stop"
          },
          {
            startQuest = "17800414090495400",
            startPort = "Out",
            endQuest = "17800444776118868860",
            endPort = "In"
          },
          {
            startQuest = "17800414500575682",
            startPort = "Out",
            endQuest = "178064409280818227913",
            endPort = "In"
          },
          {
            startQuest = "178064409280818227913",
            startPort = "Out",
            endQuest = "17800414500575682",
            endPort = "In"
          },
          {
            startQuest = "17800414090495400",
            startPort = "Out",
            endQuest = "178064409280818227913",
            endPort = "Stop"
          },
          {
            startQuest = "17800444776118868860",
            startPort = "Out",
            endQuest = "17798719336877317664",
            endPort = "Success"
          },
          {
            startQuest = "17798719336877317670",
            startPort = "Out",
            endQuest = "178064409280818227913",
            endPort = "In"
          },
          {
            startQuest = "17798719336877317663",
            startPort = "QuestStart",
            endQuest = "178090413932413665419",
            endPort = "In"
          },
          {
            startQuest = "17800414090495400",
            startPort = "Out",
            endQuest = "178090415339713665694",
            endPort = "In"
          }
        },
        nodeData = {
          ["17798719336877317663"] = {
            key = "17798719336877317663",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17798719336877317664"] = {
            key = "17798719336877317664",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2001.6210971610349, y = 295.3184505804742},
            propsData = {ModeType = 0}
          },
          ["17798719336877317665"] = {
            key = "17798719336877317665",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3200.5138888888887, y = 489.09722222222223},
            propsData = {}
          },
          ["17798719336877317670"] = {
            key = "17798719336877317670",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1123.6116138763198, y = 291.98169983536457},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {132480453}
            }
          },
          ["17798719336877317674"] = {
            key = "17798719336877317674",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2295.4305943164745, y = 100.28439103638124},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {132480453}
            }
          },
          ["17800414090495400"] = {
            key = "17800414090495400",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1435.5955079936612, y = 277.00805008544927},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700466,
              GuideUIEnable = false,
              GuideType = "N",
              GuidePointName = "Npc_Shangren_200407_132480453",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51214079,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = true,
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
                  TalkActorId = 100401,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100402,
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
          ["17800414500575682"] = {
            key = "17800414500575682",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1437.1299907522819, y = 70.86519294259217},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51214077,
              FlowAssetPath = "",
              TalkType = "Bubble",
              BubblePlayType = "StayOnLast",
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              bBubblePlayCDEnable = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700466,
                  TalkActorVisible = true
                }
              },
              OverrideFailBlend = false
            }
          },
          ["17800444776118868860"] = {
            key = "17800444776118868860",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1719.4132419838088, y = 274.86519294259216},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51214090,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["178064409280818227913"] = {
            key = "178064409280818227913",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1438, y = -102},
            propsData = {WaitTime = 5}
          },
          ["178090413932413665419"] = {
            key = "178090413932413665419",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1137.304347826087, y = 70.69565217391302},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_NewTargetPoint_20040703"
            }
          },
          ["178090415339713665694"] = {
            key = "178090415339713665694",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1732, y = 63.99999999999997},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_NewTargetPoint_20040703"
            }
          }
        },
        commentData = {}
      }
    },
    ["17798719529697317875"] = {
      isStoryNode = true,
      key = "17798719529697317875",
      type = "StoryNode",
      name = "站前大厅",
      pos = {x = 1079.5377926421404, y = 472.62607501194464},
      propsData = {
        QuestId = 20040704,
        QuestDescriptionComment = "",
        QuestDescription = "Content_20040704",
        QuestDeatil = "Description_20040704",
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
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_NewTargetPoint_20040704",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17800431095975915142",
            startPort = "Out",
            endQuest = "17800431095975915144",
            endPort = "In"
          },
          {
            startQuest = "17800431095975915144",
            startPort = "Out",
            endQuest = "17800431095975915143",
            endPort = "In"
          },
          {
            startQuest = "17800431095975915144",
            startPort = "Out",
            endQuest = "17800431095985915145",
            endPort = "Stop"
          },
          {
            startQuest = "17798719529697317880",
            startPort = "QuestStart",
            endQuest = "17800431095975915142",
            endPort = "In"
          },
          {
            startQuest = "17800431095975915143",
            startPort = "Out",
            endQuest = "178004459993110345484",
            endPort = "In"
          },
          {
            startQuest = "178004459993110345484",
            startPort = "Out",
            endQuest = "178004462341810345732",
            endPort = "In"
          },
          {
            startQuest = "178004462341810345732",
            startPort = "Out",
            endQuest = "178004491486313298663",
            endPort = "In"
          },
          {
            startQuest = "178004491486313298663",
            startPort = "Out",
            endQuest = "178004463604210345927",
            endPort = "In"
          },
          {
            startQuest = "178004463604210345927",
            startPort = "Out",
            endQuest = "17798719529697317881",
            endPort = "Success"
          },
          {
            startQuest = "17800431095985915145",
            startPort = "Out",
            endQuest = "178064407135718227258",
            endPort = "In"
          },
          {
            startQuest = "178064407135718227258",
            startPort = "Out",
            endQuest = "17800431095985915145",
            endPort = "In"
          },
          {
            startQuest = "17800431095975915144",
            startPort = "Out",
            endQuest = "178064407135718227258",
            endPort = "Stop"
          },
          {
            startQuest = "17800431095975915142",
            startPort = "Out",
            endQuest = "178064407135718227258",
            endPort = "In"
          },
          {
            startQuest = "17798719529697317880",
            startPort = "QuestStart",
            endQuest = "178090416353613665916",
            endPort = "In"
          },
          {
            startQuest = "178004459993110345484",
            startPort = "Out",
            endQuest = "17810631716851783",
            endPort = "In"
          },
          {
            startQuest = "17800431095975915144",
            startPort = "Out",
            endQuest = "17821098147672012",
            endPort = "Input"
          },
          {
            startQuest = "17800431095975915143",
            startPort = "Out",
            endQuest = "178211616623330933915",
            endPort = "In"
          }
        },
        nodeData = {
          ["17798719529697317880"] = {
            key = "17798719529697317880",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1604.4545454545455, y = 300.8181818181818},
            propsData = {ModeType = 0}
          },
          ["17798719529697317881"] = {
            key = "17798719529697317881",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2801.4672210915505, y = 494.9677894448765},
            propsData = {ModeType = 0}
          },
          ["17798719529697317882"] = {
            key = "17798719529697317882",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3431.2831196581196, y = 609.0972222222223},
            propsData = {}
          },
          ["17800431095975915142"] = {
            key = "17800431095975915142",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1919.2955266323986, y = 296.4784571815305},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {132480454}
            }
          },
          ["17800431095975915143"] = {
            key = "17800431095975915143",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2481.773503433996, y = 296.4015141124791},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {132480454}
            }
          },
          ["17800431095975915144"] = {
            key = "17800431095975915144",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2201.828073548847, y = 273.9591339012218},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700467,
              GuideUIEnable = false,
              GuideType = "N",
              GuidePointName = "Npc_Kangyi_200407_132480454",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51214096,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = true,
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
              TalkActors = {},
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
          ["17800431095985915145"] = {
            key = "17800431095985915145",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2201.7964539705376, y = 68.9417465536138},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51214094,
              FlowAssetPath = "",
              TalkType = "Bubble",
              BubblePlayType = "Once",
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              bBubblePlayCDEnable = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700467,
                  TalkActorVisible = true
                }
              },
              OverrideFailBlend = false
            }
          },
          ["178004459993110345484"] = {
            key = "178004459993110345484",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1601.7413975014697, y = 495.31993271398875},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {132480455}
            }
          },
          ["178004462341810345732"] = {
            key = "178004462341810345732",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 1920.0691042774522, y = 471.48101301300017},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 1,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {132480455}
            }
          },
          ["178004463604210345927"] = {
            key = "178004463604210345927",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2478.534765423871, y = 472.14725444676105},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51214141,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200407/51214141.51214141'",
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
          ["178004491486313298663"] = {
            key = "178004491486313298663",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2201.4601992781136, y = 471.31902261185513},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51214113,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200407/51214113.51214113'",
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
          ["178064407135718227258"] = {
            key = "178064407135718227258",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 2206.486111111111, y = -103.07189542483658},
            propsData = {WaitTime = 5}
          },
          ["178090416353613665916"] = {
            key = "178090416353613665916",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1934, y = 89.99999999999997},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_NewTargetPoint_20040704"
            }
          },
          ["17810631716851783"] = {
            key = "17810631716851783",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1907.4912280701753, y = 668.7368421052631},
            propsData = {
              NewDescription = "Content_20040707",
              NewDetail = "Description_20040707",
              SubTaskTargetIndex = 0
            }
          },
          ["17821098147672012"] = {
            key = "17821098147672012",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 2484.454789775442, y = 174.4220706205337},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 2,
              IsStandAlone = true
            }
          },
          ["178211616623330933915"] = {
            key = "178211616623330933915",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2748.200464396285, y = 278.4999999999999},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_NewTargetPoint_20040704"
            }
          }
        },
        commentData = {}
      }
    },
    ["17798719698287318124"] = {
      isStoryNode = true,
      key = "17798719698287318124",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1360.345236810875, y = 472.40558582371364},
      propsData = {
        QuestId = 20040705,
        QuestDescriptionComment = "",
        QuestDescription = "Content_20040705",
        QuestDeatil = "Description_20040705",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = true,
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
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Xudun_200407_132480427",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17798719698297318136",
            startPort = "Out",
            endQuest = "17798719698297318137",
            endPort = "In"
          },
          {
            startQuest = "17798719698297318140",
            startPort = "Out",
            endQuest = "17798719698287318130",
            endPort = "Success"
          },
          {
            startQuest = "17798719698297318137",
            startPort = "Out",
            endQuest = "17798719698297318140",
            endPort = "In"
          },
          {
            startQuest = "17798719698287318129",
            startPort = "QuestStart",
            endQuest = "17798719698297318136",
            endPort = "In"
          }
        },
        nodeData = {
          ["17798719698287318129"] = {
            key = "17798719698287318129",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1000.1315789473684, y = 295.92105263157896},
            propsData = {ModeType = 0}
          },
          ["17798719698287318130"] = {
            key = "17798719698287318130",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2204.789362652349, y = 297.3670634920635},
            propsData = {ModeType = 0}
          },
          ["17798719698287318131"] = {
            key = "17798719698287318131",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3200.5138888888887, y = 489.09722222222223},
            propsData = {}
          },
          ["17798719698297318136"] = {
            key = "17798719698297318136",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1281.8333333333333, y = 295.15989702517163},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {132480427}
            }
          },
          ["17798719698297318137"] = {
            key = "17798719698297318137",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1599.9389233954448, y = 273.32604609349465},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700400,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Xudun_200407_132480427",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51214153,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = true,
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
                  TalkActorId = 100401,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100402,
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
          ["17798719698297318140"] = {
            key = "17798719698297318140",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1919.8619823476804, y = 297.9984410517018},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {132480427}
            }
          }
        },
        commentData = {}
      }
    },
    ["177988339838217542610"] = {
      isStoryNode = true,
      key = "177988339838217542610",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800.4515050167224, y = 287.5652173913044},
      propsData = {QuestChainId = 200407},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177988339838217542611"] = {
      isStoryNode = true,
      key = "177988339838217542611",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1639.0911062990306, y = 497.93140901485924},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178062921858312129407"] = {
      isStoryNode = true,
      key = "178062921858312129407",
      type = "PreStoryNode",
      name = "任务前置节点",
      pos = {x = 1078.87360446571, y = 273.74082934609254},
      propsData = {
        QuestId = 20040700,
        QuestDescriptionComment = "",
        SubRegionId = 106001,
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        bIsPlayBlackScreenOnComplete = false,
        SubRegionIdList = {}
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "178062924055212129935",
            startPort = "Out",
            endQuest = "178062924055212129936",
            endPort = "In"
          },
          {
            startQuest = "178062921858312129408",
            startPort = "QuestStart",
            endQuest = "178062924055212129935",
            endPort = "In"
          },
          {
            startQuest = "178062924055212129936",
            startPort = "Out",
            endQuest = "178062921858312129411",
            endPort = "Success"
          }
        },
        nodeData = {
          ["178062921858312129408"] = {
            key = "178062921858312129408",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178062921858312129411"] = {
            key = "178062921858312129411",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1648, y = 292},
            propsData = {ModeType = 0}
          },
          ["178062921858312129422"] = {
            key = "178062921858312129422",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1696, y = 504},
            propsData = {}
          },
          ["178062924055212129935"] = {
            key = "178062924055212129935",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1084.25, y = 288.25},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 132480426,
              GuideType = "M",
              GuidePointName = "Mechanism_20040701_132480426"
            }
          },
          ["178062924055212129936"] = {
            key = "178062924055212129936",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1360.95, y = 283.75},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51214001,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200407/51214001.51214001'",
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
