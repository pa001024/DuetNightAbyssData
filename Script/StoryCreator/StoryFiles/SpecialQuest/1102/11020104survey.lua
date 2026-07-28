return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17815128784221",
      startPort = "StoryStart",
      endStory = "1781515622223317",
      endPort = "In"
    },
    {
      startStory = "1781515622223317",
      startPort = "Success",
      endStory = "17815236248173151954",
      endPort = "In"
    },
    {
      startStory = "17815236248173151954",
      startPort = "Success",
      endStory = "17815239503853153168",
      endPort = "In"
    },
    {
      startStory = "17815239503853153168",
      startPort = "Success",
      endStory = "17815266096865257195",
      endPort = "In"
    },
    {
      startStory = "17815266096865257195",
      startPort = "Success",
      endStory = "17815128784235",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17815128784221"] = {
      isStoryNode = true,
      key = "17815128784221",
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
    ["17815128784235"] = {
      isStoryNode = true,
      key = "17815128784235",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2386.078296703297, y = 264.1277472527472},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1781515622223317"] = {
      isStoryNode = true,
      key = "1781515622223317",
      type = "StoryNode",
      name = "前往调查点1",
      pos = {x = 1106.9241285030762, y = 287.92207792207796},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110204_04a",
        QuestDeatil = "Content_110201_04a",
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
            startQuest = "1781515622223322",
            startPort = "QuestStart",
            endQuest = "17815198021321048694",
            endPort = "In"
          },
          {
            startQuest = "17815197762901048427",
            startPort = "Out",
            endQuest = "1781515622223325",
            endPort = "In"
          },
          {
            startQuest = "1781515622223325",
            startPort = "Out",
            endQuest = "17815205923252097297",
            endPort = "In"
          },
          {
            startQuest = "1781515622223325",
            startPort = "Out",
            endQuest = "17815213581812098375",
            endPort = "In"
          },
          {
            startQuest = "17815213581812098375",
            startPort = "Out",
            endQuest = "17815218418292099598",
            endPort = "In"
          },
          {
            startQuest = "17815198021321048694",
            startPort = "Out",
            endQuest = "17815197762901048427",
            endPort = "In"
          },
          {
            startQuest = "17815218418292099598",
            startPort = "Out",
            endQuest = "1781515622223323",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781515622223322"] = {
            key = "1781515622223322",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 233.3333333333333, y = 303.33333333333337},
            propsData = {ModeType = 0}
          },
          ["1781515622223323"] = {
            key = "1781515622223323",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2516.81432225064, y = 557.5517720131529},
            propsData = {ModeType = 0}
          },
          ["1781515622223324"] = {
            key = "1781515622223324",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1781515622223325"] = {
            key = "1781515622223325",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1359.5586297760212, y = 264.51778656126487},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790016,
              GuideType = "M",
              GuidePointName = "Mechanism_ex02_surveystart01_142790016"
            }
          },
          ["17815197762901048427"] = {
            key = "17815197762901048427",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1072.8006274647712, y = 252.36654369396348},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "04_tp_rebirth01",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17815198021321048694"] = {
            key = "17815198021321048694",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 524.5160594817523, y = 292.7873605582585},
            propsData = {QuestRoleId = 11020201, IsPlayFX = false}
          },
          ["17815201814051049431"] = {
            key = "17815201814051049431",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 795.4385518592176, y = 533.7598547307525},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020104",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17815205923252097297"] = {
            key = "17815205923252097297",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1727.0387309363457, y = 45.40363284169735},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790017}
            }
          },
          ["17815213581812098375"] = {
            key = "17815213581812098375",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1695.7312119205899, y = 286.72383370391066},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790018,
              GuideType = "M",
              GuidePointName = "Mechanism_ex02_survey1_142790018"
            }
          },
          ["17815218418292099598"] = {
            key = "17815218418292099598",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1991.1597833491612, y = 305.7095479896249},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11102301,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17815230302883148884"] = {
            key = "17815230302883148884",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2356.676216305813, y = 273.72828545795414},
            propsData = {
              VarName = "ex02_11020104",
              VarValue = 1
            }
          }
        },
        commentData = {}
      }
    },
    ["17815236248173151954"] = {
      isStoryNode = true,
      key = "17815236248173151954",
      type = "StoryNode",
      name = "前往调查点2",
      pos = {x = 1383.152222721191, y = 268.6713939916579},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110204_04c",
        QuestDeatil = "Content_110201_04c",
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
            startQuest = "17815250545113155145",
            startPort = "Out",
            endQuest = "17815251005483155494",
            endPort = "In"
          },
          {
            startQuest = "17815236248173151955",
            startPort = "QuestStart",
            endQuest = "17815250545113155145",
            endPort = "In"
          },
          {
            startQuest = "17815251005483155494",
            startPort = "Out",
            endQuest = "17815236248173151958",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17815236248173151955"] = {
            key = "17815236248173151955",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 985.8928571428571, y = 167.67857142857144},
            propsData = {ModeType = 0}
          },
          ["17815236248173151958"] = {
            key = "17815236248173151958",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2726.2605042016808, y = 325.5882352941177},
            propsData = {ModeType = 0}
          },
          ["17815236248183151961"] = {
            key = "17815236248183151961",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17815239700443153822"] = {
            key = "17815239700443153822",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1120.1552155275067, y = 373.6451819594233},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020104",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["17815239963293154247"] = {
            key = "17815239963293154247",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1478.3064760317086, y = -216.01868358679528},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17815250545113155145"] = {
            key = "17815250545113155145",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1486.7289359247566, y = 175.66580839181444},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790019,
              GuideType = "M",
              GuidePointName = "Mechanism_ex02_survey2_142790019"
            }
          },
          ["17815251005483155494"] = {
            key = "17815251005483155494",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1837.7182407375908, y = 140.0317365812721},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11102401,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17815251948943156311"] = {
            key = "17815251948943156311",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2358.4745432585987, y = 112.59476179135609},
            propsData = {
              VarName = "ex02_11020104",
              VarValue = 2
            }
          }
        },
        commentData = {}
      }
    },
    ["17815239503853153168"] = {
      isStoryNode = true,
      key = "17815239503853153168",
      type = "StoryNode",
      name = "前往调查点3",
      pos = {x = 1674.0304145776438, y = 256.6907176631555},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110204_04c",
        QuestDeatil = "Content_110201_04c",
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
            startQuest = "17815239503853153173",
            startPort = "QuestStart",
            endQuest = "17815260713085254873",
            endPort = "In"
          },
          {
            startQuest = "17815260713085254873",
            startPort = "Out",
            endQuest = "17815261489335255564",
            endPort = "In"
          },
          {
            startQuest = "17815261489335255564",
            startPort = "Out",
            endQuest = "17815239503853153174",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17815239503853153173"] = {
            key = "17815239503853153173",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 833.304347826087, y = 285.6521739130435},
            propsData = {ModeType = 0}
          },
          ["17815239503853153174"] = {
            key = "17815239503853153174",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1942.272727272727, y = 275.45454545454544},
            propsData = {ModeType = 0}
          },
          ["17815239503853153175"] = {
            key = "17815239503853153175",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17815256723045250842"] = {
            key = "17815256723045250842",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1617.695652173913, y = 485.3188405797102},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020104",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "2"}
              }
            }
          },
          ["17815260713085254873"] = {
            key = "17815260713085254873",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1158.1013502134779, y = 232.59736297264888},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790020,
              GuideType = "M",
              GuidePointName = "Mechanism_ex02_survey3_142790020"
            }
          },
          ["17815261489335255564"] = {
            key = "17815261489335255564",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1532.7261232898643, y = 216.78327640470536},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11102501,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17815266096865257195"] = {
      isStoryNode = true,
      key = "17815266096865257195",
      type = "StoryNode",
      name = "前往调查点4",
      pos = {x = 1994.4930076784701, y = 248.7208383722733},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110204_04d",
        QuestDeatil = "Content_110201_04d",
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
            startQuest = "17815266096865257196",
            startPort = "QuestStart",
            endQuest = "17815270569305258751",
            endPort = "In"
          },
          {
            startQuest = "17815270569305258751",
            startPort = "Out",
            endQuest = "17815270838635259075",
            endPort = "In"
          },
          {
            startQuest = "17815270838635259075",
            startPort = "Out",
            endQuest = "17815271313205259309",
            endPort = "In"
          },
          {
            startQuest = "17815271313205259309",
            startPort = "Out",
            endQuest = "17815271791665260078",
            endPort = "In"
          },
          {
            startQuest = "17815271791665260078",
            startPort = "Out",
            endQuest = "17815274559126307588",
            endPort = "In"
          },
          {
            startQuest = "17815274559126307588",
            startPort = "Out",
            endQuest = "17817667854397384",
            endPort = "In"
          }
        },
        nodeData = {
          ["17815266096865257196"] = {
            key = "17815266096865257196",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17815266096865257199"] = {
            key = "17815266096865257199",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2897.9326923076924, y = 352.3557692307692},
            propsData = {ModeType = 0}
          },
          ["17815266096865257202"] = {
            key = "17815266096865257202",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17815270569305258751"] = {
            key = "17815270569305258751",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1103.720893141946, y = 293.4335554796082},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790021,
              GuideType = "M",
              GuidePointName = "Mechanism_ex02_survey4_1_142790021"
            }
          },
          ["17815270838635259075"] = {
            key = "17815270838635259075",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1360.993620414673, y = 302.9790100250626},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790022,
              GuideType = "M",
              GuidePointName = "Mechanism_ex02_survey4_2_142790022"
            }
          },
          ["17815271313205259309"] = {
            key = "17815271313205259309",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1647.3572567783094, y = 300.25173729778993},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790023,
              GuideType = "M",
              GuidePointName = "Mechanism_ex02_survey4_3_142790023"
            }
          },
          ["17815271791665260078"] = {
            key = "17815271791665260078",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1914.9700367186751, y = 168.83406770993142},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11102601,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17815274559126307588"] = {
            key = "17815274559126307588",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2186.1238828725213, y = 206.9109907868546},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020128.11020128'",
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
              HideNpcs = true,
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
          ["17817667854397384"] = {
            key = "17817667854397384",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2541.4079670329666, y = 258.37912087912093},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
