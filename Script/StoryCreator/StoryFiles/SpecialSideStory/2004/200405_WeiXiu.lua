return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1779435453676222",
      startPort = "StoryStart",
      endStory = "17796792997106700",
      endPort = "In"
    },
    {
      startStory = "17796792997106700",
      startPort = "Success",
      endStory = "17796794002448030",
      endPort = "In"
    },
    {
      startStory = "177968924957310126",
      startPort = "Success",
      endStory = "177968929281610883",
      endPort = "In"
    },
    {
      startStory = "177968940268512344",
      startPort = "Success",
      endStory = "177968942367712677",
      endPort = "In"
    },
    {
      startStory = "177968942367712677",
      startPort = "Success",
      endStory = "1779435453676225",
      endPort = "StoryEnd"
    },
    {
      startStory = "17796902806901464844",
      startPort = "Success",
      endStory = "17796794364578710",
      endPort = "In"
    },
    {
      startStory = "17796903240821465320",
      startPort = "Success",
      endStory = "17796794364578710",
      endPort = "In"
    },
    {
      startStory = "17796794002448030",
      startPort = "【分支1】自己想办法",
      endStory = "17796902806901464844",
      endPort = "In"
    },
    {
      startStory = "17796794002448030",
      startPort = "【分支2】听听克罗格的主意",
      endStory = "17796903240821465320",
      endPort = "In"
    },
    {
      startStory = "177968929281610883",
      startPort = "Success",
      endStory = "17797758392075897829",
      endPort = "In"
    },
    {
      startStory = "17797758392075897829",
      startPort = "Success",
      endStory = "177968932650311436",
      endPort = "In"
    },
    {
      startStory = "177968932650311436",
      startPort = "Success",
      endStory = "17797772222135920286",
      endPort = "In"
    },
    {
      startStory = "17797772222135920286",
      startPort = "Success",
      endStory = "177968940268512344",
      endPort = "In"
    },
    {
      startStory = "17796794364578710",
      startPort = "Success",
      endStory = "17811712821886150808",
      endPort = "In"
    },
    {
      startStory = "17811712821886150808",
      startPort = "Success",
      endStory = "177968924957310126",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["1779435453676222"] = {
      isStoryNode = true,
      key = "1779435453676222",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 200405},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1779435453676225"] = {
      isStoryNode = true,
      key = "1779435453676225",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2260.822885859149, y = 745.7928977346968},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17796792997106700"] = {
      isStoryNode = true,
      key = "17796792997106700",
      type = "StoryNode",
      name = "到行会了解情况",
      pos = {x = 1088.7331002331, y = 293.3420745920744},
      propsData = {
        QuestId = 20040501,
        QuestDescriptionComment = "到行会了解情况",
        QuestDescription = "Description_200405_1",
        QuestDeatil = "Content_200405_1",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestTrigger_352890216",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17796792997106701",
            startPort = "QuestStart",
            endQuest = "17796898632101462061",
            endPort = "In"
          },
          {
            startQuest = "17796792997106701",
            startPort = "QuestStart",
            endQuest = "17796900680221463712",
            endPort = "In"
          },
          {
            startQuest = "17796899057061462681",
            startPort = "Out",
            endQuest = "17796906055971467750",
            endPort = "In"
          },
          {
            startQuest = "17796899057061462681",
            startPort = "Out",
            endQuest = "17796906528441468682",
            endPort = "In"
          },
          {
            startQuest = "17796912649381470138",
            startPort = "Out",
            endQuest = "17796914983911472185",
            endPort = "In"
          },
          {
            startQuest = "17796914983911472185",
            startPort = "Out",
            endQuest = "17796792997106704",
            endPort = "Success"
          },
          {
            startQuest = "17796906055971467750",
            startPort = "Out",
            endQuest = "17796926419231477430",
            endPort = "In"
          },
          {
            startQuest = "17796926419231477430",
            startPort = "Out",
            endQuest = "17796912649381470138",
            endPort = "In"
          },
          {
            startQuest = "17822996530613731",
            startPort = "Out",
            endQuest = "17822996825434023",
            endPort = "In"
          },
          {
            startQuest = "17796898632101462061",
            startPort = "Out",
            endQuest = "17822996530613731",
            endPort = "In"
          },
          {
            startQuest = "17822996825434023",
            startPort = "Out",
            endQuest = "17796899057061462681",
            endPort = "In"
          }
        },
        nodeData = {
          ["17796792997106701"] = {
            key = "17796792997106701",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17796792997106704"] = {
            key = "17796792997106704",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2105.555555555555, y = 555.0793650793652},
            propsData = {ModeType = 0}
          },
          ["17796792997106707"] = {
            key = "17796792997106707",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2102.1804511278197, y = 709.2063492063493},
            propsData = {}
          },
          ["17796898632101462061"] = {
            key = "17796898632101462061",
            type = "ChangeStaticCreatorNode",
            name = "生成屋外克罗格",
            pos = {x = 1084.762987012987, y = 298.47240259740255},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890145}
            }
          },
          ["17796899057061462681"] = {
            key = "17796899057061462681",
            type = "TalkNode",
            name = "克罗格对话",
            pos = {x = 1438.584487734488, y = 279.7963564213563},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700429,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Keluoge_352890145",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51209901,
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
                  TalkActorId = 700449,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700429,
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
          ["17796900680221463712"] = {
            key = "17796900680221463712",
            type = "ChangeStaticCreatorNode",
            name = "生成罗连特和玛吉",
            pos = {x = 1056.2452004517224, y = 121.37754093732349},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890146, 352890147}
            }
          },
          ["17796906055971467750"] = {
            key = "17796906055971467750",
            type = "ChangeStaticCreatorNode",
            name = "销毁屋外克罗格",
            pos = {x = 1783.9243256743255, y = 380.5445859695858},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890145}
            }
          },
          ["17796906528441468682"] = {
            key = "17796906528441468682",
            type = "ChangeStaticCreatorNode",
            name = "生成屋内克罗格",
            pos = {x = 1783.9243256743255, y = 242.08304750804726},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890149}
            }
          },
          ["17796912649381470138"] = {
            key = "17796912649381470138",
            type = "TalkNode",
            name = "触发玛吉罗连特对话",
            pos = {x = 1429.7480019980019, y = 543.8380980130979},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51210001,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200405/20040501.20040501'",
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
              SkipToOption = true,
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
              SwitchToMaster = "Player",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17796914983911472185"] = {
            key = "17796914983911472185",
            type = "ChangeStaticCreatorNode",
            name = "销毁屋内克罗格",
            pos = {x = 1769.8072205572207, y = 554.9092213342211},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890149}
            }
          },
          ["17796926419231477430"] = {
            key = "17796926419231477430",
            type = "GoToNode",
            name = "前往工会屋内",
            pos = {x = 1083.413381917427, y = 538.4701717526146},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 352890150,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_352890150"
            }
          },
          ["17822996530613731"] = {
            key = "17822996530613731",
            type = "GoToNode",
            name = "前往地下工厂某处",
            pos = {x = 1309.8524027459955, y = -28.837528604118898},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 352890216,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_352890216"
            }
          },
          ["17822996825434023"] = {
            key = "17822996825434023",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "传送玩家到工会附近",
            pos = {x = 1568.1132723112132, y = -24.924485125858048},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestSign_20040500",
              FadeIn = true,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17796794002448030"] = {
      isStoryNode = true,
      key = "17796794002448030",
      type = "StoryNode",
      name = "工厂找工头分支",
      pos = {x = 1381.045482295482, y = 262.1492396492394},
      propsData = {
        QuestId = 20040502,
        QuestDescriptionComment = "工厂找工头分支",
        QuestDescription = "Description_200405_2",
        QuestDeatil = "Content_200405_2",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestTrigger_352890151",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17796794002448031",
            startPort = "QuestStart",
            endQuest = "17796928927211480030",
            endPort = "In"
          },
          {
            startQuest = "17796928927211480030",
            startPort = "Out",
            endQuest = "17796930161731480984",
            endPort = "In"
          },
          {
            startQuest = "17796930161731480984",
            startPort = "Option_1",
            endQuest = "17796935400241483444",
            endPort = "In"
          },
          {
            startQuest = "17796930161731480984",
            startPort = "Option_2",
            endQuest = "17796935451521483605",
            endPort = "In"
          },
          {
            startQuest = "17796928927211480030",
            startPort = "Out",
            endQuest = "17796947261884385871",
            endPort = "In"
          },
          {
            startQuest = "17796794002448031",
            startPort = "QuestStart",
            endQuest = "17796947523324386447",
            endPort = "In"
          }
        },
        nodeData = {
          ["17796794002448031"] = {
            key = "17796794002448031",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 797.5, y = 297.5},
            propsData = {ModeType = 0}
          },
          ["17796794002448034"] = {
            key = "17796794002448034",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2061.0054347826085, y = 66.60326086956519},
            propsData = {ModeType = 0}
          },
          ["17796794002448037"] = {
            key = "17796794002448037",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2061.536835748792, y = 175.00905797101444},
            propsData = {}
          },
          ["17796928927211480030"] = {
            key = "17796928927211480030",
            type = "GoToNode",
            name = "前往工厂区",
            pos = {x = 1153.5, y = 289.5},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 352890151,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_352890151"
            }
          },
          ["17796930161731480984"] = {
            key = "17796930161731480984",
            type = "TalkNode",
            name = "触发工厂对话",
            pos = {x = 1482.5946969696972, y = 262.1250595895334},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51210101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200405/20040502.20040502'",
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
              SkipToOption = true,
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
              OptionType = "branch",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              BranchOptions = {"", ""},
              OverrideFailBlend = false
            }
          },
          ["17796935400241483444"] = {
            key = "17796935400241483444",
            type = "QuestConditionNode",
            name = "QuestCondition",
            pos = {x = 1807.708051006964, y = 222.54897263301166},
            propsData = {
              PortName = "【分支1】自己想办法"
            }
          },
          ["17796935451521483605"] = {
            key = "17796935451521483605",
            type = "QuestConditionNode",
            name = "QuestCondition",
            pos = {x = 1806.725131752306, y = 370.8859291547508},
            propsData = {
              PortName = "【分支2】听听克罗格的主意"
            }
          },
          ["17796947261884385871"] = {
            key = "17796947261884385871",
            type = "ChangeStaticCreatorNode",
            name = "销毁罗连特和玛吉",
            pos = {x = 1485.3534569295437, y = 92.09722222222221},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890146, 352890147}
            }
          },
          ["17796947523324386447"] = {
            key = "17796947523324386447",
            type = "ChangeStaticCreatorNode",
            name = "生成npc工头",
            pos = {x = 1157.9078047556307, y = 94.70591787439612},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890152}
            }
          }
        },
        commentData = {}
      }
    },
    ["17796794364578710"] = {
      isStoryNode = true,
      key = "17796794364578710",
      type = "StoryNode",
      name = "医务室找休",
      pos = {x = 1994.2395104895104, y = 290.17482517482506},
      propsData = {
        QuestId = 20040505,
        QuestDescriptionComment = "医务室找休",
        QuestDescription = "Description_200405_5",
        QuestDeatil = "Content_200405_5",
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
        StoryGuidePointName = "BP_GotoYWS",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17796794364578711",
            startPort = "QuestStart",
            endQuest = "17796997348224400654",
            endPort = "In"
          },
          {
            startQuest = "17797032914834405068",
            startPort = "Out",
            endQuest = "17796996459484399043",
            endPort = "In"
          },
          {
            startQuest = "17796996459484399043",
            startPort = "Out",
            endQuest = "17797035254804408173",
            endPort = "In"
          },
          {
            startQuest = "17797035254804408173",
            startPort = "Out",
            endQuest = "17797037139064409419",
            endPort = "In"
          },
          {
            startQuest = "17797037139064409419",
            startPort = "Out",
            endQuest = "17797036867134408951",
            endPort = "Input"
          },
          {
            startQuest = "17797036867134408951",
            startPort = "EndOverlap",
            endQuest = "17797041387544411828",
            endPort = "In"
          },
          {
            startQuest = "17796794364578711",
            startPort = "QuestStart",
            endQuest = "17797044456174417813",
            endPort = "In"
          },
          {
            startQuest = "17797044456174417813",
            startPort = "Out",
            endQuest = "17797032914834405068",
            endPort = "In"
          },
          {
            startQuest = "17797044456174417813",
            startPort = "Out",
            endQuest = "17797044901284418825",
            endPort = "In"
          },
          {
            startQuest = "17797041387544411828",
            startPort = "Out",
            endQuest = "17797032914834405068",
            endPort = "In"
          },
          {
            startQuest = "17797044901284418825",
            startPort = "Out",
            endQuest = "17796794364578714",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17796794364578711"] = {
            key = "17796794364578711",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 505.7222222222222, y = 483.27777777777777},
            propsData = {ModeType = 0}
          },
          ["17796794364578714"] = {
            key = "17796794364578714",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1430.9683257918548, y = 487.37583778450653},
            propsData = {ModeType = 0}
          },
          ["17796794364578717"] = {
            key = "17796794364578717",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1435.2826693430409, y = 628.5742183513081},
            propsData = {}
          },
          ["17796996459484399043"] = {
            key = "17796996459484399043",
            type = "GoToNode",
            name = "到达医务室",
            pos = {x = 1378.3290198363727, y = 141.18302367567077},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 352480424,
              GuideType = "M",
              GuidePointName = ""
            }
          },
          ["17796997348224400654"] = {
            key = "17796997348224400654",
            type = "TalkNode",
            name = "前往医务室开车",
            pos = {x = 805.8741281097414, y = 297.5700736330868},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51210701,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17797032914834405068"] = {
            key = "17797032914834405068",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示医务室指引点",
            pos = {x = 1124.4033500954854, y = 142.12889543675993},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_GotoYWS"
            }
          },
          ["17797035254804408173"] = {
            key = "17797035254804408173",
            type = "ShowOrHideTaskIndicatorNode",
            name = "隐藏医务室指引点",
            pos = {x = 1649.1497269070799, y = 143.02537968759322},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_GotoYWS"
            }
          },
          ["17797036867134408951"] = {
            key = "17797036867134408951",
            type = "CollisionBoxNode",
            name = "进入/离开医务室trigger",
            pos = {x = 2193.1219491293027, y = 150.13251862516563},
            propsData = {StaticCreatorId = 352480425}
          },
          ["17797037139064409419"] = {
            key = "17797037139064409419",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示【克罗格】指引点",
            pos = {x = 1922.4287124143261, y = 142.38251862516557},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "N",
              GuideName = "Npc_Keluoge_352480423"
            }
          },
          ["17797041264374411531"] = {
            key = "17797041264374411531",
            type = "TestPrintNode",
            name = "测试打印",
            pos = {x = 2420.701439687054, y = -9.812051297665107},
            propsData = {Text = ""}
          },
          ["17797041387544411828"] = {
            key = "17797041387544411828",
            type = "ShowOrHideTaskIndicatorNode",
            name = "隐藏【克罗格】指引点",
            pos = {x = 2469.0823920680064, y = 141.74350425789044},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "N",
              GuideName = "Npc_Keluoge_352480423"
            }
          },
          ["17797044456174417813"] = {
            key = "17797044456174417813",
            type = "ChangeStaticCreatorNode",
            name = "生成倒地的休和克罗格",
            pos = {x = 810.4979091192671, y = 482.8153595626641},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352480422, 352480423}
            }
          },
          ["17797044901284418825"] = {
            key = "17797044901284418825",
            type = "TalkNode",
            name = "对话克罗格嘲笑休",
            pos = {x = 1098.6621603269966, y = 472.03758178488636},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700429,
              GuideUIEnable = false,
              GuideType = "N",
              GuidePointName = "Npc_Keluoge_352480423",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51210801,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200405/20040504.20040504'",
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
              SwitchToMaster = "Player",
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
    },
    ["177968924957310126"] = {
      isStoryNode = true,
      key = "177968924957310126",
      type = "StoryNode",
      name = "找地方喝酒",
      pos = {x = 1394.103265660171, y = 515.4394390775464},
      propsData = {
        QuestId = 20040506,
        QuestDescriptionComment = "找地方喝酒",
        QuestDescription = "Description_200405_6",
        QuestDeatil = "Content_200405_6",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestTrigger_352890217",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177968924957310127",
            startPort = "QuestStart",
            endQuest = "17797631848875882048",
            endPort = "In"
          },
          {
            startQuest = "17797631282295881186",
            startPort = "Out",
            endQuest = "17797634539585883653",
            endPort = "In"
          },
          {
            startQuest = "17797642646155885269",
            startPort = "Out",
            endQuest = "177968924957310130",
            endPort = "Success"
          },
          {
            startQuest = "17797644550285887625",
            startPort = "Out",
            endQuest = "17797642646155885269",
            endPort = "In"
          },
          {
            startQuest = "17797634539585883653",
            startPort = "Out",
            endQuest = "17821909994046929",
            endPort = "In"
          },
          {
            startQuest = "17821909994046929",
            startPort = "Out",
            endQuest = "17821909127516479",
            endPort = "In"
          },
          {
            startQuest = "17821909127516479",
            startPort = "Out",
            endQuest = "17797644550285887625",
            endPort = "In"
          },
          {
            startQuest = "17823546050241619938",
            startPort = "Out",
            endQuest = "17823546190081620226",
            endPort = "In"
          },
          {
            startQuest = "17797631848875882048",
            startPort = "Out",
            endQuest = "17823546050241619938",
            endPort = "In"
          },
          {
            startQuest = "17823546190081620226",
            startPort = "Out",
            endQuest = "17797631282295881186",
            endPort = "In"
          },
          {
            startQuest = "177968924957310127",
            startPort = "QuestStart",
            endQuest = "17833911874975002",
            endPort = "In"
          }
        },
        nodeData = {
          ["177968924957310127"] = {
            key = "177968924957310127",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 456.66666666666663, y = 300},
            propsData = {ModeType = 0}
          },
          ["177968924957310130"] = {
            key = "177968924957310130",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1886.0416666666665, y = 515.8333333333334},
            propsData = {ModeType = 0}
          },
          ["177968924957310133"] = {
            key = "177968924957310133",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1888.4090909090908, y = 645.6818181818182},
            propsData = {}
          },
          ["17797631282295881186"] = {
            key = "17797631282295881186",
            type = "GoToNode",
            name = "前往喝酒点",
            pos = {x = 1595.3939393939395, y = 271.0719696969697},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 352890158,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_352890158"
            }
          },
          ["17797631848875882048"] = {
            key = "17797631848875882048",
            type = "ChangeStaticCreatorNode",
            name = "生成喝酒的休和克罗格",
            pos = {x = 731.2485700517911, y = 288.2859833272574},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890156, 352890157}
            }
          },
          ["17797634539585883653"] = {
            key = "17797634539585883653",
            type = "TalkNode",
            name = "对话克罗格休喝酒",
            pos = {x = 1886.0402367184581, y = 274.6252690415432},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700429,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Keluoge_352890156",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51211101,
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
              SkipToOption = true,
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
                  TalkActorId = 700449,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700429,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700444,
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
          ["17797642646155885269"] = {
            key = "17797642646155885269",
            type = "ChangeStaticCreatorNode",
            name = "销毁喝酒的休",
            pos = {x = 1594.7207922740133, y = 516.6193166605909},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890157}
            }
          },
          ["17797644550285887625"] = {
            key = "17797644550285887625",
            type = "ChangeStaticCreatorNode",
            name = "生成围观&看笑话工友",
            pos = {x = 1312.4478751326747, y = 517.7156654872028},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890171, 352890172}
            }
          },
          ["17821909127516479"] = {
            key = "17821909127516479",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1021.4242424242428, y = 509.36363636363643},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700444,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Xiu_352890157",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51211142,
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
              SkipToOption = true,
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
                  TalkActorId = 700444,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700449,
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
          ["17821909994046929"] = {
            key = "17821909994046929",
            type = "ChangeStaticCreatorNode",
            name = "销毁喝酒克罗格",
            pos = {x = 732.1385281385283, y = 524.5800865800868},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890156}
            }
          },
          ["17823546050241619938"] = {
            key = "17823546050241619938",
            type = "GoToNode",
            name = "前往地下工厂",
            pos = {x = 1024.042735042735, y = 277.8534798534796},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 352890217,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_352890217"
            }
          },
          ["17823546190081620226"] = {
            key = "17823546190081620226",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "传送玩家到喝酒点楼下",
            pos = {x = 1312.931623931624, y = 271.1868131868129},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestSign20040504",
              FadeIn = true,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17833911874975002"] = {
            key = "17833911874975002",
            type = "TalkNode",
            name = "前往喝酒点开车",
            pos = {x = 729.3999461308308, y = 59.971522355705105},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51211001,
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
    ["177968929281610883"] = {
      isStoryNode = true,
      key = "177968929281610883",
      type = "StoryNode",
      name = "情景还原跟踪A",
      pos = {x = 1692.1702390690475, y = 517.7630462820258},
      propsData = {
        QuestId = 20040507,
        QuestDescriptionComment = "情景还原跟踪A",
        QuestDescription = "Description_200405_7",
        QuestDeatil = "Content_200405_7",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_XiuMove_352890161",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17797756546925895622",
            startPort = "Out",
            endQuest = "177968929281610887",
            endPort = "Success"
          },
          {
            startQuest = "177968929281610884",
            startPort = "QuestStart",
            endQuest = "17797755431235894134",
            endPort = "In"
          },
          {
            startQuest = "177968929281610884",
            startPort = "QuestStart",
            endQuest = "17797643684695886662",
            endPort = "In"
          },
          {
            startQuest = "178116140165919615",
            startPort = "Out",
            endQuest = "17797756150125894750",
            endPort = "In"
          },
          {
            startQuest = "17797648825905889233",
            startPort = "Out",
            endQuest = "17797649350165890396",
            endPort = "In"
          },
          {
            startQuest = "17797649350165890396",
            startPort = "Out",
            endQuest = "17811660683533085527",
            endPort = "In"
          },
          {
            startQuest = "17797643684695886662",
            startPort = "Out",
            endQuest = "17812539741363658515",
            endPort = "In"
          },
          {
            startQuest = "17812539741363658515",
            startPort = "Out",
            endQuest = "178030115373711381",
            endPort = "In"
          },
          {
            startQuest = "178030115373711381",
            startPort = "Out",
            endQuest = "17797648825905889233",
            endPort = "In"
          },
          {
            startQuest = "17811660683533085527",
            startPort = "Out",
            endQuest = "178116140165919615",
            endPort = "In"
          },
          {
            startQuest = "17797756150125894750",
            startPort = "Out",
            endQuest = "17811660959283086051",
            endPort = "In"
          },
          {
            startQuest = "17811660959283086051",
            startPort = "Out",
            endQuest = "17797756546925895622",
            endPort = "In"
          }
        },
        nodeData = {
          ["177968929281610884"] = {
            key = "177968929281610884",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177968929281610887"] = {
            key = "177968929281610887",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1729.6272474664922, y = 518.4243793627292},
            propsData = {ModeType = 0}
          },
          ["177968929281610890"] = {
            key = "177968929281610890",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1729.6295031055895, y = 659.2388198757764},
            propsData = {}
          },
          ["17797643684695886662"] = {
            key = "17797643684695886662",
            type = "ChangeStaticCreatorNode",
            name = "生成移动休01",
            pos = {x = 1165.304347826087, y = 115.84949832775914},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890161}
            }
          },
          ["17797648825905889233"] = {
            key = "17797648825905889233",
            type = "WaitOfTimeNode",
            name = "等休走到交互点1",
            pos = {x = 1974.4043478260865, y = 105.8099378881987},
            propsData = {WaitTime = 13}
          },
          ["17797649350165890396"] = {
            key = "17797649350165890396",
            type = "ChangeStaticCreatorNode",
            name = "生成交互1",
            pos = {x = 1158.9458124624325, y = 335.1130434782606},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890173}
            }
          },
          ["17797755431235894134"] = {
            key = "17797755431235894134",
            type = "TalkNode",
            name = "跟踪开车A",
            pos = {x = 1165.2697563306263, y = -80.7722408026759},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51211201,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17797756150125894750"] = {
            key = "17797756150125894750",
            type = "TalkNode",
            name = "触发查看对话A",
            pos = {x = 1987.4060984130413, y = 323.2819020931332},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51211301,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200405/20040506.20040506'",
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
              SwitchToMaster = "Player",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17797756546925895622"] = {
            key = "17797756546925895622",
            type = "ChangeStaticCreatorNode",
            name = "销毁交互点1",
            pos = {x = 1442.632162345664, y = 541.2967994450022},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890173}
            }
          },
          ["178030115373711381"] = {
            key = "178030115373711381",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1693.4778651300396, y = 118.67781011259285},
            propsData = {
              MessageType = "BehaviorTree",
              MessageContent = "Quest20040507Start",
              UnitId = 700444
            }
          },
          ["178116140165919615"] = {
            key = "178116140165919615",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1705.7539276580194, y = 327.154457435148},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 20040503,
              UnitCount = 1,
              bGuideUIEnable = false,
              GuideType = "P",
              GuidePointName = "",
              IsUseCount = false
            }
          },
          ["17811660683533085527"] = {
            key = "17811660683533085527",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1435.0777371818294, y = 322.1979356960177},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "Target_Trytofind_352890173"
            }
          },
          ["17811660959283086051"] = {
            key = "17811660959283086051",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1165.2495798319324, y = 532.4289915966388},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "Target_Trytofind_352890173"
            }
          },
          ["17812539741363658515"] = {
            key = "17812539741363658515",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1434.541941257095, y = 108.83053708865734},
            propsData = {WaitTime = 0.5}
          }
        },
        commentData = {}
      }
    },
    ["177968932650311436"] = {
      isStoryNode = true,
      key = "177968932650311436",
      type = "StoryNode",
      name = "跟踪终点对话",
      pos = {x = 1089.8648432265, y = 735.0755570987094},
      propsData = {
        QuestId = 20040509,
        QuestDescriptionComment = "跟踪终点对话",
        QuestDescription = "Description_200405_9",
        QuestDeatil = "Content_200405_9",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_XiuMove03_352890186",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17797767859345911260",
            startPort = "Out",
            endQuest = "17797768765445913326",
            endPort = "In"
          },
          {
            startQuest = "17797765366285907537",
            startPort = "Out",
            endQuest = "17797766703335909260",
            endPort = "In"
          },
          {
            startQuest = "17797766897095909626",
            startPort = "Out",
            endQuest = "17797767859345911260",
            endPort = "In"
          },
          {
            startQuest = "17811774500992056750",
            startPort = "Out",
            endQuest = "17797765366285907537",
            endPort = "In"
          },
          {
            startQuest = "178030168117020564",
            startPort = "Out",
            endQuest = "17811774500992056750",
            endPort = "In"
          },
          {
            startQuest = "17812564342638355172",
            startPort = "Out",
            endQuest = "17812564342648355173",
            endPort = "In"
          },
          {
            startQuest = "17812564342648355173",
            startPort = "Out",
            endQuest = "17812564342648355174",
            endPort = "In"
          },
          {
            startQuest = "177968932650311437",
            startPort = "QuestStart",
            endQuest = "17812564342638355172",
            endPort = "In"
          },
          {
            startQuest = "17812564342648355174",
            startPort = "Out",
            endQuest = "178030168117020564",
            endPort = "In"
          },
          {
            startQuest = "17797766703335909260",
            startPort = "Out",
            endQuest = "17797766897095909626",
            endPort = "In"
          },
          {
            startQuest = "17797767859345911260",
            startPort = "Out",
            endQuest = "17797768415135912460",
            endPort = "In"
          },
          {
            startQuest = "17797768765445913326",
            startPort = "Out",
            endQuest = "177968932650411440",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177968932650311437"] = {
            key = "177968932650311437",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 92.14958954089396, y = -42.186074794770434},
            propsData = {ModeType = 0}
          },
          ["177968932650411440"] = {
            key = "177968932650411440",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 933.3366560340244, y = 340.94345712766756},
            propsData = {ModeType = 0}
          },
          ["177968932650411443"] = {
            key = "177968932650411443",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 932.6470008616109, y = 483.6528167335789},
            propsData = {}
          },
          ["17797765366285907537"] = {
            key = "17797765366285907537",
            type = "WaitOfTimeNode",
            name = "等休走到终点",
            pos = {x = 629.3814077227122, y = 149.5265953852911},
            propsData = {WaitTime = 9.5}
          },
          ["17797766703335909260"] = {
            key = "17797766703335909260",
            type = "ChangeStaticCreatorNode",
            name = "销毁休03",
            pos = {x = 899.4241097026215, y = 164.20801331285185},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890186}
            }
          },
          ["17797766897095909626"] = {
            key = "17797766897095909626",
            type = "ChangeStaticCreatorNode",
            name = "生成倒地休",
            pos = {x = 1167.652306821071, y = 162.32674771526524},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890164}
            }
          },
          ["17797767859345911260"] = {
            key = "17797767859345911260",
            type = "TalkNode",
            name = "终点对话",
            pos = {x = 350.50888915305393, y = 340.2748199550257},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700484,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_XiuLay_352890164",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51211601,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200405/20040510.20040510'",
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
              SwitchToMaster = "Player",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17797768415135912460"] = {
            key = "17797768415135912460",
            type = "ChangeStaticCreatorNode",
            name = "销毁围观&看笑话工友",
            pos = {x = 630.6921986454062, y = 482.9111902152223},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890171, 352890172}
            }
          },
          ["17797768765445913326"] = {
            key = "17797768765445913326",
            type = "ChangeStaticCreatorNode",
            name = "生成终点克罗格",
            pos = {x = 634.0176214581254, y = 353.21815160430685},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890166}
            }
          },
          ["178030168117020564"] = {
            key = "178030168117020564",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1171.1604604374463, y = -33.36934184422938},
            propsData = {
              MessageType = "BehaviorTree",
              MessageContent = "Quest20040509Start",
              UnitId = 700444
            }
          },
          ["17811774500992056750"] = {
            key = "17811774500992056750",
            type = "AtmosphereNpcHideNode",
            name = "氛围NPC显示/隐藏节点",
            pos = {x = 357.4432958346001, y = 161.94175872436736},
            propsData = {
              IsHide = true,
              AtmosphereTagList = {"Story_YLQ"}
            }
          },
          ["17812564342638355172"] = {
            key = "17812564342638355172",
            type = "ChangeStaticCreatorNode",
            name = "销毁休02",
            pos = {x = 372.74009504987777, y = -38.78985507246375},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890185}
            }
          },
          ["17812564342648355173"] = {
            key = "17812564342648355173",
            type = "ChangeStaticCreatorNode",
            name = "生成休03",
            pos = {x = 637.5227037455302, y = -38.789855072463794},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890186}
            }
          },
          ["17812564342648355174"] = {
            key = "17812564342648355174",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 894.7690805571243, y = -44.2971014492753},
            propsData = {WaitTime = 0.5}
          }
        },
        commentData = {}
      }
    },
    ["177968940268512344"] = {
      isStoryNode = true,
      key = "177968940268512344",
      type = "StoryNode",
      name = "回去找克罗格",
      pos = {x = 1696.5175822633114, y = 739.3223444951047},
      propsData = {
        QuestId = 20040511,
        QuestDescriptionComment = "回去找克罗格",
        QuestDescription = "Description_200405_11",
        QuestDeatil = "Content_200405_11",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Keluoge_352890166",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177968940268512345",
            startPort = "QuestStart",
            endQuest = "17797787957135933080",
            endPort = "In"
          },
          {
            startQuest = "17797787957135933080",
            startPort = "Out",
            endQuest = "17797789389785935872",
            endPort = "In"
          },
          {
            startQuest = "17823559361781623869",
            startPort = "Out",
            endQuest = "177968940268512348",
            endPort = "Success"
          },
          {
            startQuest = "17797787957135933080",
            startPort = "Out",
            endQuest = "17823559361781623869",
            endPort = "In"
          }
        },
        nodeData = {
          ["177968940268512345"] = {
            key = "177968940268512345",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177968940268512348"] = {
            key = "177968940268512348",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1713.611111111111, y = 290.4166666666667},
            propsData = {ModeType = 0}
          },
          ["177968940268512351"] = {
            key = "177968940268512351",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1707.638888888889, y = 437.63888888888886},
            propsData = {}
          },
          ["17797787957135933080"] = {
            key = "17797787957135933080",
            type = "TalkNode",
            name = "对话克罗格",
            pos = {x = 1120.8461538461538, y = 288.5},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700429,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Keluoge_352890166",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51211901,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200405/20040511.20040511'",
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
              SkipToOption = true,
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
              SwitchToMaster = "Player",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17797789389785935872"] = {
            key = "17797789389785935872",
            type = "ChangeStaticCreatorNode",
            name = "销毁克罗格、休、桌子",
            pos = {x = 1408.7207792207794, y = 292.0064935064935},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890166, 352890168}
            }
          },
          ["17823559361781623869"] = {
            key = "17823559361781623869",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "传送玩家回行会",
            pos = {x = 1418.7711744776961, y = 64.30590062111798},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestSign_20040500",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["177968942367712677"] = {
      isStoryNode = true,
      key = "177968942367712677",
      type = "StoryNode",
      name = "回螺丝刀行会",
      pos = {x = 2004.3564753963224, y = 739.6556441522533},
      propsData = {
        QuestId = 20040512,
        QuestDescriptionComment = "回螺丝刀行会",
        QuestDescription = "Description_200405_12",
        QuestDeatil = "Content_200405_12",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestTrigger_352890148",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177968942367712678",
            startPort = "QuestStart",
            endQuest = "17797807171195940239",
            endPort = "In"
          },
          {
            startQuest = "17797807171195940239",
            startPort = "Out",
            endQuest = "17797807357515940604",
            endPort = "In"
          },
          {
            startQuest = "17797807357515940604",
            startPort = "Out",
            endQuest = "17797813277975941798",
            endPort = "In"
          },
          {
            startQuest = "17797813277975941798",
            startPort = "Out",
            endQuest = "17797812125005941122",
            endPort = "In"
          },
          {
            startQuest = "17797812125005941122",
            startPort = "Out",
            endQuest = "17797820469805943781",
            endPort = "In"
          },
          {
            startQuest = "17797820469805943781",
            startPort = "Out",
            endQuest = "17797821062855944339",
            endPort = "In"
          },
          {
            startQuest = "177968942367712678",
            startPort = "QuestStart",
            endQuest = "17799694975102007908",
            endPort = "In"
          },
          {
            startQuest = "17797807357515940604",
            startPort = "Out",
            endQuest = "17799695535552008648",
            endPort = "In"
          },
          {
            startQuest = "17797820469805943781",
            startPort = "Out",
            endQuest = "17799695827312009221",
            endPort = "In"
          },
          {
            startQuest = "17797821062855944339",
            startPort = "Out",
            endQuest = "1781249397322529715",
            endPort = "In"
          },
          {
            startQuest = "1781249397322529715",
            startPort = "Out",
            endQuest = "177968942367712681",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177968942367712678"] = {
            key = "177968942367712678",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177968942367712681"] = {
            key = "177968942367712681",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2287.366258741258, y = 536.9449300699301},
            propsData = {ModeType = 0}
          },
          ["177968942367712684"] = {
            key = "177968942367712684",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2287.536713286713, y = 705.6381118881119},
            propsData = {}
          },
          ["17797807171195940239"] = {
            key = "17797807171195940239",
            type = "GoToNode",
            name = "前往螺丝刀行会",
            pos = {x = 1118.2779720279718, y = 281.6870629370629},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 352890148,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_352890148"
            }
          },
          ["17797807357515940604"] = {
            key = "17797807357515940604",
            type = "TalkNode",
            name = "触发门口对话",
            pos = {x = 1446.8181818181815, y = 282.7272727272727},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51212001,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200405/20040508.20040508'",
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
              SwitchToMaster = "Player",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17797812125005941122"] = {
            key = "17797812125005941122",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "传送玩家进入行会屋内",
            pos = {x = 1110.8522727272725, y = 538.5795454545455},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestSign_20040502",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17797813277975941798"] = {
            key = "17797813277975941798",
            type = "TalkNode",
            name = "玩家被推进屋内",
            pos = {x = 1767.272727272727, y = 285.4545454545454},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51212007,
              FlowAssetPath = "",
              TalkType = "Black",
              BlendInTime = 0,
              BlendOutTime = 0,
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              ForceAutoPlay = false,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              OverrideFailBlend = false
            }
          },
          ["17797820469805943781"] = {
            key = "17797820469805943781",
            type = "TalkNode",
            name = "触发完成对话",
            pos = {x = 1440.4464285714284, y = 536.5616883116883},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51212008,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200405/20040509.20040509'",
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
              SwitchToMaster = "Player",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17797821062855944339"] = {
            key = "17797821062855944339",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "传送玩家离开行会",
            pos = {x = 1767.0941558441557, y = 536.6988989271597},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestSign_20040503",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17799694975102007908"] = {
            key = "17799694975102007908",
            type = "ChangeStaticCreatorNode",
            name = "生成玛吉和罗连特",
            pos = {x = 1121.5324675324673, y = 134.6318681318681},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890146, 352890147}
            }
          },
          ["17799695535552008648"] = {
            key = "17799695535552008648",
            type = "ChangeStaticCreatorNode",
            name = "生成屋内克罗格和休",
            pos = {x = 1770.8181818181818, y = 131.41758241758237},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890149, 352890169}
            }
          },
          ["17799695827312009221"] = {
            key = "17799695827312009221",
            type = "ChangeStaticCreatorNode",
            name = "销毁玛吉罗连特克罗格休",
            pos = {x = 1769.7467532467533, y = 689.6318681318681},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                352890146,
                352890147,
                352890149,
                352890169
              }
            }
          },
          ["1781249397322529715"] = {
            key = "1781249397322529715",
            type = "AtmosphereNpcHideNode",
            name = "氛围NPC显示/隐藏节点",
            pos = {x = 2032.9510489510494, y = 543.4615384615385},
            propsData = {
              IsHide = false,
              AtmosphereTagList = {"Story_YLQ"}
            }
          }
        },
        commentData = {}
      }
    },
    ["17796902806901464844"] = {
      isStoryNode = true,
      key = "17796902806901464844",
      type = "StoryNode",
      name = "影帝任务",
      pos = {x = 1697.428457928534, y = 169.84907847258012},
      propsData = {
        QuestId = 20040503,
        QuestDescriptionComment = "影帝任务",
        QuestDescription = "Description_200405_3",
        QuestDeatil = "Content_200405_3",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Gongtou_352890152",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17796902806901464845",
            startPort = "QuestStart",
            endQuest = "17796949056624387885",
            endPort = "In"
          },
          {
            startQuest = "17796949056624387885",
            startPort = "Out",
            endQuest = "17796902806901464848",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17796902806901464845"] = {
            key = "17796902806901464845",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17796902806901464848"] = {
            key = "17796902806901464848",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1552.828947368421, y = 304.7368421052632},
            propsData = {ModeType = 0}
          },
          ["17796902806901464851"] = {
            key = "17796902806901464851",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1706.907894736842, y = 480.92105263157896},
            propsData = {}
          },
          ["17796949056624387885"] = {
            key = "17796949056624387885",
            type = "TalkNode",
            name = "对话奥拉夫",
            pos = {x = 1180.75, y = 294.5},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700443,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Gongtou_352890152",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51210601,
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
              SkipToOption = true,
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
                  TalkActorId = 700449,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700443,
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
          }
        },
        commentData = {}
      }
    },
    ["17796903240821465320"] = {
      isStoryNode = true,
      key = "17796903240821465320",
      type = "StoryNode",
      name = "揍工头任务",
      pos = {x = 1696.909282796434, y = 321.729024222316},
      propsData = {
        QuestId = 20040504,
        QuestDescriptionComment = "揍工头任务",
        QuestDescription = "Description_200405_4",
        QuestDeatil = "Content_200405_4",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestTrigger_352890153",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17797829977825956130",
            startPort = "Out",
            endQuest = "17797832081655957882",
            endPort = "In"
          },
          {
            startQuest = "17797832081655957882",
            startPort = "Out",
            endQuest = "17797831260855956919",
            endPort = "In"
          },
          {
            startQuest = "17797833071125959430",
            startPort = "Out",
            endQuest = "17797834500135961456",
            endPort = "In"
          },
          {
            startQuest = "17796903240821465321",
            startPort = "QuestStart",
            endQuest = "17796966937604396312",
            endPort = "In"
          },
          {
            startQuest = "17796903240821465321",
            startPort = "QuestStart",
            endQuest = "17797829977825956130",
            endPort = "In"
          },
          {
            startQuest = "17797832081655957882",
            startPort = "Out",
            endQuest = "17797833071125959430",
            endPort = "In"
          },
          {
            startQuest = "17797832081655957882",
            startPort = "Out",
            endQuest = "17810101123022879460",
            endPort = "In"
          },
          {
            startQuest = "17810101123022879460",
            startPort = "Out",
            endQuest = "17797831725095957205",
            endPort = "In"
          },
          {
            startQuest = "17797835188985962708",
            startPort = "Out",
            endQuest = "17816787608241579673",
            endPort = "In"
          },
          {
            startQuest = "17816787608241579673",
            startPort = "Out",
            endQuest = "17796903240821465324",
            endPort = "Success"
          },
          {
            startQuest = "17797833071125959430",
            startPort = "Out",
            endQuest = "17798038420541488973",
            endPort = "In"
          },
          {
            startQuest = "17797834500135961456",
            startPort = "Out",
            endQuest = "17797835188985962708",
            endPort = "In"
          }
        },
        nodeData = {
          ["17796903240821465321"] = {
            key = "17796903240821465321",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17796903240821465324"] = {
            key = "17796903240821465324",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2965.0424242424247, y = 252.06262626262628},
            propsData = {ModeType = 0}
          },
          ["17796903240821465327"] = {
            key = "17796903240821465327",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2761.709090909091, y = 391.90389610389593},
            propsData = {}
          },
          ["17796966937604396312"] = {
            key = "17796966937604396312",
            type = "TalkNode",
            name = "战斗1开车",
            pos = {x = 1167.5142857142857, y = 117.18571428571427},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51210201,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17797829977825956130"] = {
            key = "17797829977825956130",
            type = "GoToNode",
            name = "前往工头附近",
            pos = {x = 1166.881646688216, y = 277.5500235126292},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 352890153,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_352890153"
            }
          },
          ["17797831260855956919"] = {
            key = "17797831260855956919",
            type = "ChangeStaticCreatorNode",
            name = "销毁npc工头",
            pos = {x = 1805.453075259645, y = -46.10077013816451},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890152}
            }
          },
          ["17797831725095957205"] = {
            key = "17797831725095957205",
            type = "ChangeStaticCreatorNode",
            name = "生成怪物工头",
            pos = {x = 2090.8865306930993, y = 91.49385745646295},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890144}
            }
          },
          ["17797832081655957882"] = {
            key = "17797832081655957882",
            type = "TalkNode",
            name = "触发工头警觉",
            pos = {x = 1497.0058702907002, y = 260.24233120493676},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51210401,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200405/20040503.20040503'",
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
              SwitchToMaster = "Player",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17797833071125959430"] = {
            key = "17797833071125959430",
            type = "KillMonsterNode",
            name = "击败工头",
            pos = {x = 1805.8995038310727, y = 262.7285949412004},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 1,
              IsShow = false,
              GuideType = "P",
              GuideName = "Monster_Gongtou_352890144",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {352890144}
            }
          },
          ["17797834500135961456"] = {
            key = "17797834500135961456",
            type = "ChangeStaticCreatorNode",
            name = "销毁怪物工头",
            pos = {x = 2103.472277110425, y = 276.5586456113541},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = true,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890144}
            }
          },
          ["17797835188985962708"] = {
            key = "17797835188985962708",
            type = "TalkNode",
            name = "触发揍人结尾对话",
            pos = {x = 2416.9250243631723, y = 260.731125305573},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700443,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Gongtou_352890154",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51210501,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200405/20040512.20040512'",
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
              SwitchToMaster = "Player",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17798038420541488973"] = {
            key = "17798038420541488973",
            type = "ChangeStaticCreatorNode",
            name = "生成npc工头",
            pos = {x = 2101.664333492594, y = 448.18647873865245},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890154}
            }
          },
          ["17810101123022879460"] = {
            key = "17810101123022879460",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1808.8648018648016, y = 80.02930402930397},
            propsData = {WaitTime = 0.2}
          },
          ["17816787608241579673"] = {
            key = "17816787608241579673",
            type = "ChangeStaticCreatorNode",
            name = "销毁npc工头",
            pos = {x = 2689.8584970584957, y = 269.6825646575644},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890154}
            }
          }
        },
        commentData = {}
      }
    },
    ["17797758392075897829"] = {
      isStoryNode = true,
      key = "17797758392075897829",
      type = "StoryNode",
      name = "情景还原跟踪B",
      pos = {x = 1996.9382527640469, y = 519.725268483853},
      propsData = {
        QuestId = 20040508,
        QuestDescriptionComment = "情景还原跟踪B",
        QuestDescription = "Description_200405_8",
        QuestDeatil = "Content_200405_8",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_XiuMove02_352890185",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17797758392075897830",
            startPort = "QuestStart",
            endQuest = "17797759998105901047",
            endPort = "In"
          },
          {
            startQuest = "17797759998105901049",
            startPort = "Out",
            endQuest = "17797758392075897833",
            endPort = "Success"
          },
          {
            startQuest = "17811659401663083620",
            startPort = "Out",
            endQuest = "17797759998105901048",
            endPort = "In"
          },
          {
            startQuest = "17797759998105901044",
            startPort = "Out",
            endQuest = "17797759998105901045",
            endPort = "In"
          },
          {
            startQuest = "17797759998105901045",
            startPort = "Out",
            endQuest = "17811661452503086634",
            endPort = "In"
          },
          {
            startQuest = "17797758392075897830",
            startPort = "QuestStart",
            endQuest = "17812557473298345250",
            endPort = "In"
          },
          {
            startQuest = "17812557473298345250",
            startPort = "Out",
            endQuest = "17812557525548345352",
            endPort = "In"
          },
          {
            startQuest = "17812557525548345352",
            startPort = "Out",
            endQuest = "17812557938428346266",
            endPort = "In"
          },
          {
            startQuest = "17812557938428346266",
            startPort = "Out",
            endQuest = "178030152465817646",
            endPort = "In"
          },
          {
            startQuest = "17811661452503086634",
            startPort = "Out",
            endQuest = "17811659401663083620",
            endPort = "In"
          },
          {
            startQuest = "17797759998105901048",
            startPort = "Out",
            endQuest = "17811661505413086796",
            endPort = "In"
          },
          {
            startQuest = "17811661505413086796",
            startPort = "Out",
            endQuest = "17797759998105901049",
            endPort = "In"
          },
          {
            startQuest = "178030152465817646",
            startPort = "Out",
            endQuest = "17797759998105901044",
            endPort = "In"
          }
        },
        nodeData = {
          ["17797758392075897830"] = {
            key = "17797758392075897830",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1090.4545454545455, y = 289.09090909090907},
            propsData = {ModeType = 0}
          },
          ["17797758392075897833"] = {
            key = "17797758392075897833",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2238.90051214994, y = 509.90519777705134},
            propsData = {ModeType = 0}
          },
          ["17797758392075897836"] = {
            key = "17797758392075897836",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2241.353519668737, y = 632.5931677018634},
            propsData = {}
          },
          ["17797759998105901044"] = {
            key = "17797759998105901044",
            type = "WaitOfTimeNode",
            name = "等休走到交互点2",
            pos = {x = 1420.9729457422816, y = 281.4588947284599},
            propsData = {WaitTime = 9}
          },
          ["17797759998105901045"] = {
            key = "17797759998105901045",
            type = "ChangeStaticCreatorNode",
            name = "生成交互点2",
            pos = {x = 1677.9348505041867, y = 289.5749120444771},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890163}
            }
          },
          ["17797759998105901047"] = {
            key = "17797759998105901047",
            type = "TalkNode",
            name = "跟踪开车B",
            pos = {x = 1414.0795550749779, y = -82.9690396559963},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51211401,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17797759998105901048"] = {
            key = "17797759998105901048",
            type = "TalkNode",
            name = "触发查看对话B",
            pos = {x = 1422.6459394152753, y = 497.77260893187685},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51211501,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200405/20040507.20040507'",
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
              SwitchToMaster = "Player",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17797759998105901049"] = {
            key = "17797759998105901049",
            type = "ChangeStaticCreatorNode",
            name = "销毁交互点2",
            pos = {x = 1949.5191831306254, y = 512.7268394279027},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890163}
            }
          },
          ["178030152465817646"] = {
            key = "178030152465817646",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2227.0415490306796, y = 95.42772444946341},
            propsData = {
              MessageType = "BehaviorTree",
              MessageContent = "Quest20040508Start",
              UnitId = 700444
            }
          },
          ["17811659401663083620"] = {
            key = "17811659401663083620",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 2226.8847117794485, y = 276.11278195488734},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 20040504,
              UnitCount = 1,
              bGuideUIEnable = false,
              GuideType = "P",
              GuidePointName = "",
              IsUseCount = false
            }
          },
          ["17811661452503086634"] = {
            key = "17811661452503086634",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1937.3609022556388, y = 276.827067669173},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "Target_Trytofindagain_352890163"
            }
          },
          ["17811661505413086796"] = {
            key = "17811661505413086796",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1684.9799498746868, y = 500.6365914786968},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "Target_Trytofindagain_352890163"
            }
          },
          ["17812557473298345250"] = {
            key = "17812557473298345250",
            type = "ChangeStaticCreatorNode",
            name = "销毁休01",
            pos = {x = 1416.608695652174, y = 100.17391304347828},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890161}
            }
          },
          ["17812557525548345352"] = {
            key = "17812557525548345352",
            type = "ChangeStaticCreatorNode",
            name = "生成休02",
            pos = {x = 1680.0869565217395, y = 98.86956521739128},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890185}
            }
          },
          ["17812557938428346266"] = {
            key = "17812557938428346266",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1934.0000000000002, y = 93.36231884057977},
            propsData = {WaitTime = 0.5}
          }
        },
        commentData = {}
      }
    },
    ["17797772222135920286"] = {
      isStoryNode = true,
      key = "17797772222135920286",
      type = "StoryNode",
      name = "检修测控仪",
      pos = {x = 1397.5200219135943, y = 739.4252130136803},
      propsData = {
        QuestId = 20040510,
        QuestDescriptionComment = "检修测控仪",
        QuestDescription = "Description_200405_10",
        QuestDeatil = "Content_200405_10",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Gongchanggongren_352890167",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17797772222135920287",
            startPort = "QuestStart",
            endQuest = "17797773177985922202",
            endPort = "In"
          },
          {
            startQuest = "17797773177985922202",
            startPort = "Out",
            endQuest = "17797774274955922936",
            endPort = "In"
          },
          {
            startQuest = "17797780721365928144",
            startPort = "Out",
            endQuest = "17797781387385929063",
            endPort = "In"
          },
          {
            startQuest = "17797781387385929063",
            startPort = "Out",
            endQuest = "17797772222135920290",
            endPort = "Success"
          },
          {
            startQuest = "17797774274955922936",
            startPort = "Out",
            endQuest = "1779961776938511577",
            endPort = "In"
          },
          {
            startQuest = "1779961776938511577",
            startPort = "Out",
            endQuest = "1779961801930511959",
            endPort = "In"
          },
          {
            startQuest = "1779961801930511959",
            startPort = "Out",
            endQuest = "1779961818594512289",
            endPort = "In"
          },
          {
            startQuest = "1779961818594512289",
            startPort = "Out",
            endQuest = "17797780721365928144",
            endPort = "In"
          },
          {
            startQuest = "1779961818594512289",
            startPort = "Out",
            endQuest = "17797784652055932163",
            endPort = "In"
          },
          {
            startQuest = "1779961818594512289",
            startPort = "Out",
            endQuest = "17797784091805931077",
            endPort = "In"
          },
          {
            startQuest = "17797780721365928144",
            startPort = "Out",
            endQuest = "17803008015597168",
            endPort = "In"
          }
        },
        nodeData = {
          ["17797772222135920287"] = {
            key = "17797772222135920287",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17797772222135920290"] = {
            key = "17797772222135920290",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2034.8509881422929, y = 490.5600790513834},
            propsData = {ModeType = 0}
          },
          ["17797772222135920293"] = {
            key = "17797772222135920293",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2037.250988142293, y = 631.5782608695653},
            propsData = {}
          },
          ["17797773177985922202"] = {
            key = "17797773177985922202",
            type = "ChangeStaticCreatorNode",
            name = "生成工厂工人",
            pos = {x = 1122.8269867387512, y = 297.03183483183494},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890167}
            }
          },
          ["17797774274955922936"] = {
            key = "17797774274955922936",
            type = "TalkNode",
            name = "对话工厂工人",
            pos = {x = 1439.190623102388, y = 283.3954711954713},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700447,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Gongchanggongren_352890167",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51211701,
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
              SkipToOption = true,
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
                  TalkActorId = 700449,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700447,
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
          ["17797780369355927553"] = {
            key = "17797780369355927553",
            type = "MiniGameOpenGateNode",
            name = "完成调频小游戏",
            pos = {x = 1733.5155242881583, y = 119.81602455515511},
            propsData = {
              StaticCreatorId = 352890170,
              bGuideUIEnable = true,
              GuideType = "M",
              GuidePointName = "Mechanism_Minigame_Jianxiu_352890170"
            }
          },
          ["17797780721365928144"] = {
            key = "17797780721365928144",
            type = "TalkNode",
            name = "触发检修后对话",
            pos = {x = 1445.9684887150365, y = 479.3606885867758},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700447,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Gongchanggongren_352890167",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51211801,
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
                  TalkActorId = 700449,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700447,
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
          ["17797781387385929063"] = {
            key = "17797781387385929063",
            type = "ChangeStaticCreatorNode",
            name = "销毁工厂工人",
            pos = {x = 1721.8403125433815, y = 490.3906151819196},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890167}
            }
          },
          ["17797784091805931077"] = {
            key = "17797784091805931077",
            type = "ChangeStaticCreatorNode",
            name = "销毁倒地休",
            pos = {x = 1447.6878563039688, y = 781.732230088752},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890164}
            }
          },
          ["17797784652055932163"] = {
            key = "17797784652055932163",
            type = "ChangeStaticCreatorNode",
            name = "生成坐姿休",
            pos = {x = 1447.6878563039688, y = 644.0049573614792},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890168}
            }
          },
          ["1779961776938511577"] = {
            key = "1779961776938511577",
            type = "ChangeStaticCreatorNode",
            name = "生成调频小游戏",
            pos = {x = 1738.3045930042492, y = 292.9252206603464},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890170}
            }
          },
          ["1779961801930511959"] = {
            key = "1779961801930511959",
            type = "SwitchMechanismStateNode",
            name = "切换机关状态",
            pos = {x = 2030.4285060477278, y = 292.87087283425944},
            propsData = {
              StaticCreatorIdList = {352890170},
              ManualItemIdList = {},
              StateId = 552,
              QuestId = 0
            }
          },
          ["1779961818594512289"] = {
            key = "1779961818594512289",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 1125.3154625694665, y = 476.7839163125202},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 352890170,
              StateId = 572,
              IsGuideEnable = true,
              GuidePointName = "Mechanism_Minigame_Jianxiu_352890170"
            }
          },
          ["17803008015597168"] = {
            key = "17803008015597168",
            type = "ChangeStaticCreatorNode",
            name = "销毁调频小游戏",
            pos = {x = 1728.4578947368423, y = 638.2075187969924},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352890170}
            }
          }
        },
        commentData = {}
      }
    },
    ["17811712821886150808"] = {
      isStoryNode = true,
      key = "17811712821886150808",
      type = "StoryNode",
      name = "医务室调频",
      pos = {x = 1091.606068615816, y = 513.5589645978146},
      propsData = {
        QuestId = 20040513,
        QuestDescriptionComment = "医务室完成调频&对话",
        QuestDescription = "Description_200405_13",
        QuestDeatil = "Content_200405_13",
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
        StoryGuidePointName = "BP_GotoYWS",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17811719221036155011",
            startPort = "Out",
            endQuest = "17811719221036155012",
            endPort = "In"
          },
          {
            startQuest = "17811719221036155013",
            startPort = "Out",
            endQuest = "17811719221036155014",
            endPort = "In"
          },
          {
            startQuest = "17811719221036155014",
            startPort = "Out",
            endQuest = "17811719221036155015",
            endPort = "In"
          },
          {
            startQuest = "17811719221036155011",
            startPort = "Out",
            endQuest = "17811719221036155016",
            endPort = "In"
          },
          {
            startQuest = "17811719221036155015",
            startPort = "Out",
            endQuest = "17811719221036155017",
            endPort = "In"
          },
          {
            startQuest = "17811719221036155015",
            startPort = "Out",
            endQuest = "17811719221036155018",
            endPort = "In"
          },
          {
            startQuest = "17811719221036155018",
            startPort = "Out",
            endQuest = "17811719221036155011",
            endPort = "In"
          },
          {
            startQuest = "17811712821886150809",
            startPort = "QuestStart",
            endQuest = "17811719221036155013",
            endPort = "In"
          },
          {
            startQuest = "17811719221036155012",
            startPort = "Out",
            endQuest = "17811712821896150812",
            endPort = "Success"
          },
          {
            startQuest = "17811719882876156715",
            startPort = "Out",
            endQuest = "17811719882876156714",
            endPort = "In"
          },
          {
            startQuest = "17811719882876156714",
            startPort = "Out",
            endQuest = "17811719882876156716",
            endPort = "In"
          },
          {
            startQuest = "17811719882876156716",
            startPort = "Out",
            endQuest = "17811719882876156718",
            endPort = "In"
          },
          {
            startQuest = "17811719882876156718",
            startPort = "Out",
            endQuest = "17811719882876156717",
            endPort = "Input"
          },
          {
            startQuest = "17811719882876156717",
            startPort = "EndOverlap",
            endQuest = "17811719882876156720",
            endPort = "In"
          },
          {
            startQuest = "17811719882876156720",
            startPort = "Out",
            endQuest = "17811719882876156715",
            endPort = "In"
          },
          {
            startQuest = "17811719221036155013",
            startPort = "Out",
            endQuest = "17811719882876156715",
            endPort = "In"
          }
        },
        nodeData = {
          ["17811712821886150809"] = {
            key = "17811712821886150809",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17811712821896150812"] = {
            key = "17811712821896150812",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17811712821896150815"] = {
            key = "17811712821896150815",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2798, y = 444},
            propsData = {}
          },
          ["17811719221036155010"] = {
            key = "17811719221036155010",
            type = "MiniGameOpenGateNode",
            name = "完成迷宫小游戏",
            pos = {x = 1400.699273672346, y = 151.03419399872558},
            propsData = {
              StaticCreatorId = 352480426,
              bGuideUIEnable = false,
              GuideType = "M",
              GuidePointName = "Mechanism_Minigame_Songbang_352480426"
            }
          },
          ["17811719221036155011"] = {
            key = "17811719221036155011",
            type = "TalkNode",
            name = "触发和二人对话",
            pos = {x = 2187.3329524935248, y = 294.656821371353},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51210901,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200405/20040505.20040505'",
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
              SwitchToMaster = "Player",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17811719221036155012"] = {
            key = "17811719221036155012",
            type = "ChangeStaticCreatorNode",
            name = "销毁休和克罗格",
            pos = {x = 2458.549517494571, y = 312.9658060012745},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352480427, 352480423}
            }
          },
          ["17811719221036155013"] = {
            key = "17811719221036155013",
            type = "ChangeStaticCreatorNode",
            name = "生成迷宫小游戏",
            pos = {x = 1091.450482505429, y = 296.32447514038637},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352480426}
            }
          },
          ["17811719221036155014"] = {
            key = "17811719221036155014",
            type = "SwitchMechanismStateNode",
            name = "切换机关状态",
            pos = {x = 1402.620522991259, y = 297.53095287317984},
            propsData = {
              StaticCreatorIdList = {352480426},
              ManualItemIdList = {},
              StateId = 552,
              QuestId = 0
            }
          },
          ["17811719221036155015"] = {
            key = "17811719221036155015",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 1658.4282152989508, y = 284.03095287317984},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 352480426,
              StateId = 572,
              IsGuideEnable = false,
              GuidePointName = "Mechanism_Minigame_Songbang_352480426"
            }
          },
          ["17811719221036155016"] = {
            key = "17811719221036155016",
            type = "ChangeStaticCreatorNode",
            name = "销毁迷宫小游戏",
            pos = {x = 2452.0340476760684, y = 180.5574189251878},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352480426}
            }
          },
          ["17811719221036155017"] = {
            key = "17811719221036155017",
            type = "ChangeStaticCreatorNode",
            name = "销毁蹲地休",
            pos = {x = 1933.721925536082, y = 171.82952140990648},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352480422}
            }
          },
          ["17811719221036155018"] = {
            key = "17811719221036155018",
            type = "ChangeStaticCreatorNode",
            name = "生成站姿休",
            pos = {x = 1932.221925536082, y = 311.3295214099065},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {352480427}
            }
          },
          ["17811719882876156714"] = {
            key = "17811719882876156714",
            type = "GoToNode",
            name = "到达医务室",
            pos = {x = 1655.586148754627, y = -108.97720998807944},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 352480424,
              GuideType = "M",
              GuidePointName = ""
            }
          },
          ["17811719882876156715"] = {
            key = "17811719882876156715",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示医务室指引点",
            pos = {x = 1401.6604790137396, y = -108.03133822699027},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_GotoYWS"
            }
          },
          ["17811719882876156716"] = {
            key = "17811719882876156716",
            type = "ShowOrHideTaskIndicatorNode",
            name = "隐藏医务室指引点",
            pos = {x = 1926.406855825334, y = -107.13485397615699},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_GotoYWS"
            }
          },
          ["17811719882876156717"] = {
            key = "17811719882876156717",
            type = "CollisionBoxNode",
            name = "进入/离开医务室trigger",
            pos = {x = 2460.8336235021025, y = -115.02771503858457},
            propsData = {StaticCreatorId = 352480425}
          },
          ["17811719882876156718"] = {
            key = "17811719882876156718",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示调频指引点",
            pos = {x = 2199.6858413325804, y = -107.77771503858463},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Mechanism_Minigame_Songbang_352480426"
            }
          },
          ["17811719882876156719"] = {
            key = "17811719882876156719",
            type = "TestPrintNode",
            name = "测试打印",
            pos = {x = 2697.9585686053083, y = -259.9722849614153},
            propsData = {Text = ""}
          },
          ["17811719882876156720"] = {
            key = "17811719882876156720",
            type = "ShowOrHideTaskIndicatorNode",
            name = "隐藏调频指引点",
            pos = {x = 2744.975884622624, y = -108.41672940585977},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Mechanism_Minigame_Songbang_352480426"
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
