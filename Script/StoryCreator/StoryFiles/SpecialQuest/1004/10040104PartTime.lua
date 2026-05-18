return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177795502784655",
      startPort = "Success",
      endStory = "177795502784656",
      endPort = "In"
    },
    {
      startStory = "177795502784654",
      startPort = "Success",
      endStory = "177795502784655",
      endPort = "In"
    },
    {
      startStory = "17779549950421",
      startPort = "StoryStart",
      endStory = "177795502784654",
      endPort = "In"
    },
    {
      startStory = "177795502784656",
      startPort = "Success",
      endStory = "17779549950435",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17779549950421"] = {
      isStoryNode = true,
      key = "17779549950421",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 978.2352941176471, y = 157.05882352941177},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17779549950435"] = {
      isStoryNode = true,
      key = "17779549950435",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2129.4117647058824, y = 135.02846299810244},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177795502784654"] = {
      isStoryNode = true,
      key = "177795502784654",
      type = "StoryNode",
      name = "准备打工",
      pos = {x = 1300.4704384702698, y = 134.73283337512808},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040105_01",
        QuestDeatil = "Description_10040105_01",
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
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_Zhaogong_2480019",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177795502785277",
            startPort = "QuestStart",
            endQuest = "1777955179847775",
            endPort = "In"
          },
          {
            startQuest = "1777955179847775",
            startPort = "Out",
            endQuest = "177795502785279",
            endPort = "Fail"
          },
          {
            startQuest = "1777955179847774",
            startPort = "true",
            endQuest = "177795502785281",
            endPort = "In"
          },
          {
            startQuest = "177795502785281",
            startPort = "Out",
            endQuest = "1777955179847776",
            endPort = "In"
          },
          {
            startQuest = "1777955179847776",
            startPort = "Out",
            endQuest = "177795502785278",
            endPort = "Success"
          },
          {
            startQuest = "177795502785277",
            startPort = "QuestStart",
            endQuest = "17779777685614679009",
            endPort = "Input"
          },
          {
            startQuest = "1777955179847774",
            startPort = "false",
            endQuest = "177795502785278",
            endPort = "Success"
          },
          {
            startQuest = "1777955179847773",
            startPort = "Out",
            endQuest = "1777955179847774",
            endPort = "In"
          },
          {
            startQuest = "17779777685614679009",
            startPort = "Out",
            endQuest = "1777955179847773",
            endPort = "In"
          }
        },
        nodeData = {
          ["177795502785277"] = {
            key = "177795502785277",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -183.932733932734, y = 251.33449883449885},
            propsData = {ModeType = 0}
          },
          ["177795502785278"] = {
            key = "177795502785278",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1792.6082251082257, y = 192.1012321012322},
            propsData = {ModeType = 0}
          },
          ["177795502785279"] = {
            key = "177795502785279",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1222.9166666666665, y = 541.6666666666666},
            propsData = {}
          },
          ["177795502785281"] = {
            key = "177795502785281",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1147.640459898524, y = 180.96849691055976},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100407,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Gongtou_132480155",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 10040701,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10040801.10040801'",
              TalkType = "FreeSimple",
              BlendInTime = 1,
              BlendOutTime = 1,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100402,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100401,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100001,
                  TalkActorVisible = false
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1777955179847773"] = {
            key = "1777955179847773",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 464.3167628597537, y = 171.08132542688682},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["1777955179847774"] = {
            key = "1777955179847774",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 780.4152346821138, y = 209.76627502015953},
            propsData = {
              FunctionName = "Equal",
              VarName = "PartTime100401",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["1777955179847775"] = {
            key = "1777955179847775",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 825.3130752953, y = 510.4341568089301},
            propsData = {}
          },
          ["1777955179847776"] = {
            key = "1777955179847776",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1469.0266878072262, y = 216.05295135902355},
            propsData = {
              VarName = "PartTime100401",
              VarValue = 1
            }
          },
          ["17779777685614679009"] = {
            key = "17779777685614679009",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 121.58046301524564, y = 178.46616541353376},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false
            }
          }
        },
        commentData = {}
      }
    },
    ["177795502784655"] = {
      isStoryNode = true,
      key = "177795502784655",
      type = "StoryNode",
      name = "修理幕墙特殊任务",
      pos = {x = 1590.9075463693061, y = 122.29682504223439},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040106_01",
        QuestDeatil = "Description_10040106_01",
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
        StoryGuidePointName = "Mechanism_MuqiangGuizu_2480021",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1777955027858107",
            startPort = "Out",
            endQuest = "1777955027857105",
            endPort = "In"
          },
          {
            startQuest = "1777955027856100",
            startPort = "Out",
            endQuest = "1777955027858108",
            endPort = "In"
          },
          {
            startQuest = "1777955027859110",
            startPort = "Out",
            endQuest = "1777955027859111",
            endPort = "In"
          },
          {
            startQuest = "1777955027859113",
            startPort = "Out",
            endQuest = "1777955027859114",
            endPort = "In"
          },
          {
            startQuest = "1777955027859115",
            startPort = "Out",
            endQuest = "1777955027859116",
            endPort = "In"
          },
          {
            startQuest = "1777955027859116",
            startPort = "Out",
            endQuest = "1777955027860117",
            endPort = "Branch_1"
          },
          {
            startQuest = "1777955027860118",
            startPort = "Out",
            endQuest = "1777955027860119",
            endPort = "In"
          },
          {
            startQuest = "1777955027860119",
            startPort = "Out",
            endQuest = "1777955027859115",
            endPort = "In"
          },
          {
            startQuest = "1777955027860117",
            startPort = "Out",
            endQuest = "1777955027858107",
            endPort = "In"
          },
          {
            startQuest = "1777955027859115",
            startPort = "Out",
            endQuest = "1777955027856101",
            endPort = "In"
          },
          {
            startQuest = "1777955027856101",
            startPort = "Out",
            endQuest = "1777955027860120",
            endPort = "In"
          },
          {
            startQuest = "1777955027857102",
            startPort = "Out",
            endQuest = "1777955027861121",
            endPort = "In"
          },
          {
            startQuest = "1777955027861122",
            startPort = "Out",
            endQuest = "1777955027861123",
            endPort = "In"
          },
          {
            startQuest = "1777955027861123",
            startPort = "Out",
            endQuest = "1777955027861124",
            endPort = "Branch_1"
          },
          {
            startQuest = "1777955027860117",
            startPort = "Out",
            endQuest = "1777955027861122",
            endPort = "In"
          },
          {
            startQuest = "1777955027860117",
            startPort = "Out",
            endQuest = "1777955027859110",
            endPort = "In"
          },
          {
            startQuest = "1777955027861122",
            startPort = "Out",
            endQuest = "1777955027857102",
            endPort = "In"
          },
          {
            startQuest = "1777955027861124",
            startPort = "Out",
            endQuest = "1777955027859113",
            endPort = "In"
          },
          {
            startQuest = "1777955027861124",
            startPort = "Out",
            endQuest = "1777955027861125",
            endPort = "In"
          },
          {
            startQuest = "1777955027861125",
            startPort = "Out",
            endQuest = "1777955027857104",
            endPort = "In"
          },
          {
            startQuest = "1777955027857104",
            startPort = "Out",
            endQuest = "1777955027857103",
            endPort = "In"
          },
          {
            startQuest = "1777955027862129",
            startPort = "Out",
            endQuest = "1777955027861127",
            endPort = "In"
          },
          {
            startQuest = "1777955027861125",
            startPort = "Out",
            endQuest = "1777955027862130",
            endPort = "In"
          },
          {
            startQuest = "1777955027862130",
            startPort = "Out",
            endQuest = "1777955027862128",
            endPort = "In"
          },
          {
            startQuest = "1777955027861121",
            startPort = "Out",
            endQuest = "1777955027857102",
            endPort = "In"
          },
          {
            startQuest = "1777955027861125",
            startPort = "Out",
            endQuest = "1777955027862129",
            endPort = "In"
          },
          {
            startQuest = "1777955027861125",
            startPort = "Out",
            endQuest = "1777955027863135",
            endPort = "In"
          },
          {
            startQuest = "1777955027863135",
            startPort = "Out",
            endQuest = "1777955027861126",
            endPort = "Branch_1"
          },
          {
            startQuest = "1777955027864139",
            startPort = "Out",
            endQuest = "1777955027860118",
            endPort = "In"
          },
          {
            startQuest = "1777955027861127",
            startPort = "Out",
            endQuest = "1777955027863132",
            endPort = "In"
          },
          {
            startQuest = "1777955027863132",
            startPort = "Out",
            endQuest = "1777955027863136",
            endPort = "In"
          },
          {
            startQuest = "1777955027857103",
            startPort = "Out",
            endQuest = "1777955027863133",
            endPort = "In"
          },
          {
            startQuest = "1777955027863133",
            startPort = "Out",
            endQuest = "1777955027863137",
            endPort = "In"
          },
          {
            startQuest = "1777955027862128",
            startPort = "Out",
            endQuest = "1777955027862131",
            endPort = "In"
          },
          {
            startQuest = "1777955027862131",
            startPort = "Out",
            endQuest = "1777955027864138",
            endPort = "In"
          },
          {
            startQuest = "1777955027859116",
            startPort = "Out",
            endQuest = "1777955027858109",
            endPort = "In"
          },
          {
            startQuest = "1777955027861123",
            startPort = "Out",
            endQuest = "1777955027863134",
            endPort = "In"
          },
          {
            startQuest = "1777955027861123",
            startPort = "Out",
            endQuest = "1777955027859112",
            endPort = "In"
          },
          {
            startQuest = "177795502785596",
            startPort = "QuestStart",
            endQuest = "17779552361602671",
            endPort = "In"
          },
          {
            startQuest = "17779552361602671",
            startPort = "Out",
            endQuest = "177795502785698",
            endPort = "Fail"
          },
          {
            startQuest = "1777955027861126",
            startPort = "Out",
            endQuest = "17779552361602673",
            endPort = "In"
          },
          {
            startQuest = "17779552361602673",
            startPort = "Out",
            endQuest = "177795502785697",
            endPort = "Success"
          },
          {
            startQuest = "17779552361602672",
            startPort = "true",
            endQuest = "1777955027864139",
            endPort = "In"
          },
          {
            startQuest = "177795502785596",
            startPort = "QuestStart",
            endQuest = "17779552361602672",
            endPort = "In"
          },
          {
            startQuest = "17779552361602672",
            startPort = "true",
            endQuest = "1777955027858106",
            endPort = "In"
          },
          {
            startQuest = "17779552361602672",
            startPort = "true",
            endQuest = "1777955027856100",
            endPort = "In"
          },
          {
            startQuest = "17779552361602672",
            startPort = "true",
            endQuest = "177795502785699",
            endPort = "In"
          },
          {
            startQuest = "17779552361602672",
            startPort = "false",
            endQuest = "177795502785697",
            endPort = "Success"
          },
          {
            startQuest = "1777955027859115",
            startPort = "Out",
            endQuest = "177858897710812672122",
            endPort = "In"
          },
          {
            startQuest = "1777955027859115",
            startPort = "Out",
            endQuest = "177858897732412672133",
            endPort = "In"
          },
          {
            startQuest = "177858897710812672122",
            startPort = "Out",
            endQuest = "177858899058012672487",
            endPort = "In"
          },
          {
            startQuest = "177858897732412672133",
            startPort = "Out",
            endQuest = "177858899076712672497",
            endPort = "In"
          }
        },
        nodeData = {
          ["177795502785596"] = {
            key = "177795502785596",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -1872.6954963355497, y = 520.9075597254109},
            propsData = {ModeType = 0}
          },
          ["177795502785697"] = {
            key = "177795502785697",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 170.49214768503765, y = -542.9029650185098},
            propsData = {ModeType = 0}
          },
          ["177795502785698"] = {
            key = "177795502785698",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 72.57142857142877, y = 1658.9285714285713},
            propsData = {}
          },
          ["177795502785699"] = {
            key = "177795502785699",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = -878.5514567977541, y = 672.9560156691991},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "GlassQuestStart",
              UnitId = -1
            }
          },
          ["1777955027856100"] = {
            key = "1777955027856100",
            type = "GoToNode",
            name = "前往",
            pos = {x = -668.7888851687895, y = -135.92794953349176},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 2480021,
              GuideType = "M",
              GuidePointName = "Mechanism_MuqiangGuizu_2480021"
            }
          },
          ["1777955027856101"] = {
            key = "1777955027856101",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = -62.95355044198783, y = 725.510694668317},
            propsData = {
              SendMessage = "",
              FinishCondition = "CleanGlassFirst"
            }
          },
          ["1777955027857102"] = {
            key = "1777955027857102",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = 668.4692594185718, y = 816.8435583412007},
            propsData = {
              SendMessage = "",
              FinishCondition = "CleanGlassSecond"
            }
          },
          ["1777955027857103"] = {
            key = "1777955027857103",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = 2115.5286241340254, y = 1253.1895154079564},
            propsData = {
              SendMessage = "",
              FinishCondition = "CleanGlassThird01"
            }
          },
          ["1777955027857104"] = {
            key = "1777955027857104",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1831.6588925987467, y = 1230.4188908827718},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_Glass0301"
            }
          },
          ["1777955027857105"] = {
            key = "1777955027857105",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 805.5667943178537, y = 206.04408987732515},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_Glass02"
            }
          },
          ["1777955027858106"] = {
            key = "1777955027858106",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = -709.8756999129508, y = 250.8450996108477},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_Glass01"
            }
          },
          ["1777955027858107"] = {
            key = "1777955027858107",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 483.35215016373195, y = 203.50956808898326},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_Glass01"
            }
          },
          ["1777955027858108"] = {
            key = "1777955027858108",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = -355.8523770547557, y = -118.85948974125841},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 100499183,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1777955027858109"] = {
            key = "1777955027858109",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 237.2150919743233, y = 251.08199051910734},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 100499184,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1777955027859110"] = {
            key = "1777955027859110",
            type = "GoToNode",
            name = "前往",
            pos = {x = 469.551344370019, y = -202.75592780611726},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 272480261,
              GuideType = "M",
              GuidePointName = "Mechanism_Huichen_272480261"
            }
          },
          ["1777955027859111"] = {
            key = "1777955027859111",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 739.0039759489666, y = -219.53487517453848},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 100499186,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1777955027859112"] = {
            key = "1777955027859112",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1283.2881864752821, y = 197.77038798335644},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 100499187,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1777955027859113"] = {
            key = "1777955027859113",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1506.035554896335, y = -200.18750675348588},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 272480262,
              GuideType = "M",
              GuidePointName = "Mechanism_GlassTalk_272480262"
            }
          },
          ["1777955027859114"] = {
            key = "1777955027859114",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1801.3165265562543, y = -195.6547132312186},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 100499188,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1777955027859115"] = {
            key = "1777955027859115",
            type = "BranchQuestStartNode",
            name = "子任务开始节点",
            pos = {x = -206.71627128796655, y = 507.1088820566577},
            propsData = {
              AllQuestOptions = {
                {
                  IsNeedFinish = true,
                  BranchQuestName = "Content_10040106_01_01",
                  TargetBranchQuestKey = "1777955027859116"
                }
              },
              IsSetCountInfo = false,
              IsDifftation = false,
              AllDiffGuideOptions = {}
            }
          },
          ["1777955027859116"] = {
            key = "1777955027859116",
            type = "CalculateVarCountNode",
            name = "变量计数节点",
            pos = {x = 47.694561511874156, y = 515.9447549111461},
            propsData = {
              VarName = "GlassFirst10040106",
              VarValue = 3,
              IsOpen = true
            }
          },
          ["1777955027860117"] = {
            key = "1777955027860117",
            type = "CheckBranchQuestFinishedNode",
            name = "子任务结束节点",
            pos = {x = 294.74363366279584, y = 520.0770848134541},
            propsData = {
              InputBranchQuestNumber = 1,
              BranchQuestFinishOptions = {
                {IsNeedFinish = true}
              }
            }
          },
          ["1777955027860118"] = {
            key = "1777955027860118",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = -719.3277949086327, y = 504.50565624202557},
            propsData = {
              VarName = "GlassFirst10040106",
              VarValue = 0
            }
          },
          ["1777955027860119"] = {
            key = "1777955027860119",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = -463.1702637915205, y = 502.96994195631123},
            propsData = {
              VarName = "GlassSecond10040106",
              VarValue = 0
            }
          },
          ["1777955027860120"] = {
            key = "1777955027860120",
            type = "ExecuteBlueprintFunctionSetVarNode",
            name = "通过蓝图函数设置变量",
            pos = {x = 191.69269256257158, y = 952.009548163807},
            propsData = {
              FunctionName = "Plus",
              VarName = "GlassFirst10040106",
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["1777955027861121"] = {
            key = "1777955027861121",
            type = "ExecuteBlueprintFunctionSetVarNode",
            name = "通过蓝图函数设置变量",
            pos = {x = 1012.8318165964325, y = 839.2473104015692},
            propsData = {
              FunctionName = "Plus",
              VarName = "GlassSecond10040106",
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["1777955027861122"] = {
            key = "1777955027861122",
            type = "BranchQuestStartNode",
            name = "子任务开始节点",
            pos = {x = 714.5067224206464, y = 535.8218209254696},
            propsData = {
              AllQuestOptions = {
                {
                  IsNeedFinish = true,
                  BranchQuestName = "Content_10040106_01_02",
                  TargetBranchQuestKey = "1777955027861123"
                }
              },
              IsSetCountInfo = false,
              IsDifftation = false,
              AllDiffGuideOptions = {}
            }
          },
          ["1777955027861123"] = {
            key = "1777955027861123",
            type = "CalculateVarCountNode",
            name = "变量计数节点",
            pos = {x = 995.1280815362763, y = 550.8682200957475},
            propsData = {
              VarName = "GlassSecond10040106",
              VarValue = 3,
              IsOpen = true
            }
          },
          ["1777955027861124"] = {
            key = "1777955027861124",
            type = "CheckBranchQuestFinishedNode",
            name = "子任务结束节点",
            pos = {x = 1231.7178235436577, y = 579.1775834908785},
            propsData = {
              InputBranchQuestNumber = 1,
              BranchQuestFinishOptions = {
                {IsNeedFinish = true}
              }
            }
          },
          ["1777955027861125"] = {
            key = "1777955027861125",
            type = "BranchQuestStartNode",
            name = "子任务开始节点",
            pos = {x = 1541.8415320868328, y = 610.7668639682154},
            propsData = {
              AllQuestOptions = {
                {
                  IsNeedFinish = true,
                  BranchQuestName = "Content_10040106_01_03",
                  TargetBranchQuestKey = "1777955027863135"
                }
              },
              IsSetCountInfo = false,
              IsDifftation = false,
              AllDiffGuideOptions = {}
            }
          },
          ["1777955027861126"] = {
            key = "1777955027861126",
            type = "CheckBranchQuestFinishedNode",
            name = "子任务结束节点",
            pos = {x = 2257.9411760425523, y = 634.1731712088828},
            propsData = {
              InputBranchQuestNumber = 1,
              BranchQuestFinishOptions = {
                {IsNeedFinish = true}
              }
            }
          },
          ["1777955027861127"] = {
            key = "1777955027861127",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = 2127.196744021798, y = 1012.1679037401188},
            propsData = {
              SendMessage = "",
              FinishCondition = "CleanGlassThird02"
            }
          },
          ["1777955027862128"] = {
            key = "1777955027862128",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = 2147.0474754160086, y = 1432.3335569275112},
            propsData = {
              SendMessage = "",
              FinishCondition = "CleanGlassThird03"
            }
          },
          ["1777955027862129"] = {
            key = "1777955027862129",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1838.8502736258606, y = 1011.9880468622039},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_Glass0302"
            }
          },
          ["1777955027862130"] = {
            key = "1777955027862130",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1832.0371423127292, y = 1415.200168074325},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_Glass0303"
            }
          },
          ["1777955027862131"] = {
            key = "1777955027862131",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2410.0421928177802, y = 1433.93987281403},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_Glass0303"
            }
          },
          ["1777955027863132"] = {
            key = "1777955027863132",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2469.9058291814163, y = 1001.058753932911},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_Glass0302"
            }
          },
          ["1777955027863133"] = {
            key = "1777955027863133",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2445.9512837268708, y = 1228.2860266601838},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_Glass0301"
            }
          },
          ["1777955027863134"] = {
            key = "1777955027863134",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1081.8770943871075, y = -14.28374939092032},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_Glass02"
            }
          },
          ["1777955027863135"] = {
            key = "1777955027863135",
            type = "CalculateVarCountNode",
            name = "变量计数节点",
            pos = {x = 1889.520107895338, y = 579.8875228151348},
            propsData = {
              VarName = "GlassThird10040106",
              VarValue = 3,
              IsOpen = true
            }
          },
          ["1777955027863136"] = {
            key = "1777955027863136",
            type = "ExecuteBlueprintFunctionSetVarNode",
            name = "通过蓝图函数设置变量",
            pos = {x = 2764.542129352143, y = 960.3330338258631},
            propsData = {
              FunctionName = "Plus",
              VarName = "GlassThird10040106",
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["1777955027863137"] = {
            key = "1777955027863137",
            type = "ExecuteBlueprintFunctionSetVarNode",
            name = "通过蓝图函数设置变量",
            pos = {x = 2707.542129352143, y = 1209.3330338258634},
            propsData = {
              FunctionName = "Plus",
              VarName = "GlassThird10040106",
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["1777955027864138"] = {
            key = "1777955027864138",
            type = "ExecuteBlueprintFunctionSetVarNode",
            name = "通过蓝图函数设置变量",
            pos = {x = 2751.042129352143, y = 1425.3330338258634},
            propsData = {
              FunctionName = "Plus",
              VarName = "GlassThird10040106",
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["1777955027864139"] = {
            key = "1777955027864139",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = -965.5430025436183, y = 502.8330338258631},
            propsData = {
              VarName = "GlassThird10040106",
              VarValue = 0
            }
          },
          ["17779552361602671"] = {
            key = "17779552361602671",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = -493.27152231300647, y = 1631.0612136216578},
            propsData = {}
          },
          ["17779552361602672"] = {
            key = "17779552361602672",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = -1275.912678434214, y = 536.4946687312832},
            propsData = {
              FunctionName = "Equal",
              VarName = "PartTime100401",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["17779552361602673"] = {
            key = "17779552361602673",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2720.4420901989192, y = 565.7276272193707},
            propsData = {
              VarName = "PartTime100401",
              VarValue = 2
            }
          },
          ["177858897710812672122"] = {
            key = "177858897710812672122",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = -360.48529411764724, y = 854.7549019607843},
            propsData = {
              SendMessage = "",
              FinishCondition = "CleanGlassFirst2"
            }
          },
          ["177858897732412672133"] = {
            key = "177858897732412672133",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = -590.4852941176473, y = 1109.7549019607843},
            propsData = {
              SendMessage = "",
              FinishCondition = "CleanGlassFirst3"
            }
          },
          ["177858899058012672487"] = {
            key = "177858899058012672487",
            type = "ExecuteBlueprintFunctionSetVarNode",
            name = "通过蓝图函数设置变量",
            pos = {x = 71.18137254901947, y = 993.0882352941178},
            propsData = {
              FunctionName = "Plus",
              VarName = "GlassFirst10040106",
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["177858899076712672497"] = {
            key = "177858899076712672497",
            type = "ExecuteBlueprintFunctionSetVarNode",
            name = "通过蓝图函数设置变量",
            pos = {x = -133.81862745098047, y = 1199.7549019607845},
            propsData = {
              FunctionName = "Plus",
              VarName = "GlassFirst10040106",
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          }
        },
        commentData = {}
      }
    },
    ["177795502784656"] = {
      isStoryNode = true,
      key = "177795502784656",
      type = "StoryNode",
      name = "修理幕墙任务完成",
      pos = {x = 1863.2648106592912, y = 125.70317495776558},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040107_01",
        QuestDeatil = "Description_10040107_01",
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
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Gongtou_132480155",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1777955027906324",
            startPort = "Out",
            endQuest = "1777955027906325",
            endPort = "In"
          },
          {
            startQuest = "1777955027905321",
            startPort = "QuestStart",
            endQuest = "17779553139645013",
            endPort = "In"
          },
          {
            startQuest = "17779553139645013",
            startPort = "Out",
            endQuest = "1777955027906323",
            endPort = "Fail"
          },
          {
            startQuest = "1777955027905321",
            startPort = "QuestStart",
            endQuest = "1777955027906324",
            endPort = "In"
          },
          {
            startQuest = "1777955027906325",
            startPort = "Out",
            endQuest = "17779554728351877841",
            endPort = "In"
          }
        },
        nodeData = {
          ["1777955027905321"] = {
            key = "1777955027905321",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 727.2222222222222, y = 338.8888888888889},
            propsData = {ModeType = 0}
          },
          ["1777955027906322"] = {
            key = "1777955027906322",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2415.2339181286548, y = 333.8070175438597},
            propsData = {ModeType = 0}
          },
          ["1777955027906323"] = {
            key = "1777955027906323",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1670, y = 866.6666666666667},
            propsData = {}
          },
          ["1777955027906324"] = {
            key = "1777955027906324",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1253.311543215164, y = 329.7261931469766},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100407,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Gongtou_132480155",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 10040701,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049901_53.10049901_53'",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100001,
                  TalkActorVisible = false
                },
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
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1777955027906325"] = {
            key = "1777955027906325",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1611.707690972441, y = 336.8713533639344},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = false,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049401.10049401'",
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
              TalkActors = {},
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
          ["17779553139645013"] = {
            key = "17779553139645013",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1262.39514435366, y = 916.5612136216581},
            propsData = {}
          },
          ["17779554728351877841"] = {
            key = "17779554728351877841",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2026.5845410628017, y = 380.1164994425863},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
