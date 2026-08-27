return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17697590104521328851",
      startPort = "StoryStart",
      endStory = "17697590104521328853",
      endPort = "In"
    },
    {
      startStory = "17697590104521328853",
      startPort = "Success",
      endStory = "17808881563561521392",
      endPort = "In"
    },
    {
      startStory = "178092626829814184852",
      startPort = "Success",
      endStory = "17697590104521328852",
      endPort = "StoryEnd"
    },
    {
      startStory = "17864421677532795416",
      startPort = "Transport",
      endStory = "17864421677532795415",
      endPort = "In"
    },
    {
      startStory = "17864421677532795416",
      startPort = "Distransport",
      endStory = "17864421677532795417",
      endPort = "In"
    },
    {
      startStory = "17808881563561521392",
      startPort = "Success",
      endStory = "17864421677532795416",
      endPort = "In"
    },
    {
      startStory = "17864421677532795415",
      startPort = "Success",
      endStory = "178092626829814184852",
      endPort = "In"
    },
    {
      startStory = "17864421677532795417",
      startPort = "Success",
      endStory = "178092626829814184852",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17697590104521328851"] = {
      isStoryNode = true,
      key = "17697590104521328851",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 814, y = 322},
      propsData = {QuestChainId = 110214},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17697590104521328852"] = {
      isStoryNode = true,
      key = "17697590104521328852",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2706.1602525893686, y = 398.8262806061869},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17697590104521328853"] = {
      isStoryNode = true,
      key = "17697590104521328853",
      type = "StoryNode",
      name = "和教皇桑图克斯聊聊",
      pos = {x = 1220, y = 320},
      propsData = {
        QuestId = 11021401,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110214_1",
        QuestDeatil = "Content_110214_1",
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
        SubRegionId = 107001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Sangtukesi_312780017",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17697590104521328854",
            startPort = "QuestStart",
            endQuest = "17809091631635064424",
            endPort = "In"
          },
          {
            startQuest = "17809091631635064424",
            startPort = "Out",
            endQuest = "17809093618085065692",
            endPort = "In"
          },
          {
            startQuest = "17809093618085065692",
            startPort = "Out",
            endQuest = "17697590104521328855",
            endPort = "Success"
          },
          {
            startQuest = "17809091631635064424",
            startPort = "Out",
            endQuest = "178098738156313225643",
            endPort = "In"
          },
          {
            startQuest = "178098738156313225643",
            startPort = "Out",
            endQuest = "1780974999547512278",
            endPort = "In"
          }
        },
        nodeData = {
          ["17697590104521328854"] = {
            key = "17697590104521328854",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17697590104521328855"] = {
            key = "17697590104521328855",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2068, y = 292},
            propsData = {ModeType = 0}
          },
          ["17697590104521328856"] = {
            key = "17697590104521328856",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17809091631635064424"] = {
            key = "17809091631635064424",
            type = "ChangeStaticCreatorNode",
            name = "生成桑图克斯",
            pos = {x = 1062.5029140815864, y = 292.4743697804251},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780017}
            }
          },
          ["17809093618085065692"] = {
            key = "17809093618085065692",
            type = "TalkNode",
            name = "与桑图克斯交谈",
            pos = {x = 1598.359137145258, y = 270.2967806162406},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 111167,
              GuideUIEnable = true,
              GuideType = "NpcBubble",
              GuidePointName = "Npc_Sangtukesi_312780017",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110214/11021401.11021401'",
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 111001,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 111110,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "EXPlayer",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1780974999547512278"] = {
            key = "1780974999547512278",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1695.8095648498972, y = 66.72409538232343},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11109018,
              FlowAssetPath = "",
              TalkType = "Bubble",
              BubblePlayType = "StayOnLast",
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              ShowSkipButton = true,
              ShowReviewButton = true,
              bBubblePlayCDEnable = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 111167,
                  TalkActorVisible = true
                }
              },
              OverrideFailBlend = false
            }
          },
          ["178098738156313225643"] = {
            key = "178098738156313225643",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1398.8069079529926, y = 81.95636892274908},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 312780026,
              GuideType = "N",
              GuidePointName = ""
            }
          }
        },
        commentData = {}
      }
    },
    ["17808881563561521392"] = {
      isStoryNode = true,
      key = "17808881563561521392",
      type = "StoryNode",
      name = "去树林",
      pos = {x = 1593.4285635915744, y = 334.79653847291803},
      propsData = {
        QuestId = 11021402,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110214_2",
        QuestDeatil = "Content_110214_2",
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
        SubRegionId = 107001,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "Npc_Eve_312780020",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17808881563561521397",
            startPort = "QuestStart",
            endQuest = "17809174547085071931",
            endPort = "In"
          },
          {
            startQuest = "17809174547085071931",
            startPort = "Out",
            endQuest = "17809174597345072066",
            endPort = "In"
          },
          {
            startQuest = "17809174597345072066",
            startPort = "Out",
            endQuest = "178092179863111147555",
            endPort = "In"
          },
          {
            startQuest = "178092179863111147555",
            startPort = "Out",
            endQuest = "17809148592175069185",
            endPort = "In"
          },
          {
            startQuest = "17809148592175069185",
            startPort = "Success",
            endQuest = "178092640839215705392",
            endPort = "Input"
          },
          {
            startQuest = "17809148592175069185",
            startPort = "Fail",
            endQuest = "178092641359215705503",
            endPort = "Input"
          },
          {
            startQuest = "17809148592175069185",
            startPort = "PassiveFail",
            endQuest = "178092641359215705503",
            endPort = "Input"
          },
          {
            startQuest = "178092641359215705503",
            startPort = "Out",
            endQuest = "17808881563561521399",
            endPort = "Fail"
          },
          {
            startQuest = "178092640839215705392",
            startPort = "Out",
            endQuest = "17808881563561521398",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17808881563561521397"] = {
            key = "17808881563561521397",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 691.1111141879862, y = 342.2222210291482},
            propsData = {ModeType = 0}
          },
          ["17808881563561521398"] = {
            key = "17808881563561521398",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2431.61567067255, y = 341.621225154233},
            propsData = {ModeType = 0}
          },
          ["17808881563561521399"] = {
            key = "17808881563561521399",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2271.111126055933, y = 607.7777803837026},
            propsData = {}
          },
          ["17809100668895068029"] = {
            key = "17809100668895068029",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1203.1817047949396, y = 120.55914982358689},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312780018,
              GuideType = "P",
              GuidePointName = "QuestSign1102140200"
            }
          },
          ["17809148592175069185"] = {
            key = "17809148592175069185",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1727.0717515383185, y = 489.09331753156175},
            propsData = {SpecialConfigId = 11021402, BlackScreenImmediately = true}
          },
          ["17809174547085071931"] = {
            key = "17809174547085071931",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 870.9594919603264, y = 602.7813584196481},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780020}
            }
          },
          ["17809174597345072066"] = {
            key = "17809174597345072066",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1106.515040859785, y = 559.4480263107854},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 111001,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Eve_312780020",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 11109101,
              FlowAssetPath = "",
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
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "EXPlayer",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["178092179863111147555"] = {
            key = "178092179863111147555",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1378.333213572669, y = 488.5019587765979},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780020}
            }
          },
          ["178092640839215705392"] = {
            key = "178092640839215705392",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2006.7687144365334, y = 301.9903397449487},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["178092641359215705503"] = {
            key = "178092641359215705503",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2007.9315024418445, y = 736.8740451089888},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          }
        },
        commentData = {}
      }
    },
    ["178092626829814184852"] = {
      isStoryNode = true,
      key = "178092626829814184852",
      type = "StoryNode",
      name = "和教皇桑图克斯交任务",
      pos = {x = 2331.821235218066, y = 348.78139552994764},
      propsData = {
        QuestId = 11021406,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110214_8",
        QuestDeatil = "Content_110214_8",
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
        SubRegionId = 107001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Sangtukesi_312780017",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "178092626829914184857",
            startPort = "QuestStart",
            endQuest = "178092626829914184861",
            endPort = "In"
          },
          {
            startQuest = "178092626829914184861",
            startPort = "Out",
            endQuest = "178106164245726959508",
            endPort = "In"
          },
          {
            startQuest = "178106164245726959508",
            startPort = "Out",
            endQuest = "178092626829914184858",
            endPort = "Success"
          }
        },
        nodeData = {
          ["178092626829914184857"] = {
            key = "178092626829914184857",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178092626829914184858"] = {
            key = "178092626829914184858",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2342.324318667761, y = 314.9729724992706},
            propsData = {ModeType = 0}
          },
          ["178092626829914184859"] = {
            key = "178092626829914184859",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["178092626829914184861"] = {
            key = "178092626829914184861",
            type = "TalkNode",
            name = "与桑图克斯交谈",
            pos = {x = 1487.6825285677592, y = 301.5737908729557},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 111167,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Sangtukesi_312780017",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110214/11021403.11021403'",
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 111001,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 111110,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "EXPlayer",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["178106164245726959508"] = {
            key = "178106164245726959508",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1932.7480407096057, y = 295.1284216123979},
            propsData = {
              VarName = "ex02_110214",
              VarValue = 1
            }
          }
        },
        commentData = {}
      }
    },
    ["17864421677532795415"] = {
      isStoryNode = true,
      key = "17864421677532795415",
      type = "StoryNode",
      name = "传送",
      pos = {x = 2192.8902530205933, y = -0.062024371591888894},
      propsData = {
        QuestId = 11021404,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110214_8",
        QuestDeatil = "Content_110214_8",
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
            startQuest = "17864421677542795434",
            startPort = "QuestStart",
            endQuest = "17864421677542795437",
            endPort = "In"
          },
          {
            startQuest = "17864421677542795437",
            startPort = "Out",
            endQuest = "17864421677542795435",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17864421677542795434"] = {
            key = "17864421677542795434",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17864421677542795435"] = {
            key = "17864421677542795435",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 3,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17864421677542795436"] = {
            key = "17864421677542795436",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17864421677542795437"] = {
            key = "17864421677542795437",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1680, y = 284},
            propsData = {WaitTime = 1}
          }
        },
        commentData = {}
      }
    },
    ["17864421677532795416"] = {
      isStoryNode = true,
      key = "17864421677532795416",
      type = "StoryNode",
      name = "弹窗传送",
      pos = {x = 1818.5594149199371, y = -10.895940372742928},
      propsData = {
        QuestId = 11021403,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110214_8",
        QuestDeatil = "Content_110214_8",
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
            startQuest = "17864421677542795450",
            startPort = "True",
            endQuest = "17864421677542795451",
            endPort = "In"
          },
          {
            startQuest = "17864421677542795450",
            startPort = "False",
            endQuest = "17864421677542795452",
            endPort = "In"
          },
          {
            startQuest = "17864421677542795447",
            startPort = "QuestStart",
            endQuest = "17864421677542795450",
            endPort = "Input"
          }
        },
        nodeData = {
          ["17864421677542795447"] = {
            key = "17864421677542795447",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17864421677542795448"] = {
            key = "17864421677542795448",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17864421677542795449"] = {
            key = "17864421677542795449",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17864421677542795450"] = {
            key = "17864421677542795450",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 1413.0625, y = 242.875},
            propsData = {PopupId = 100422}
          },
          ["17864421677542795451"] = {
            key = "17864421677542795451",
            type = "QuestConditionNode",
            name = "传送",
            pos = {x = 1774.9375, y = 107},
            propsData = {PortName = "Transport"}
          },
          ["17864421677542795452"] = {
            key = "17864421677542795452",
            type = "QuestConditionNode",
            name = "不传送",
            pos = {x = 1784.9375, y = 317},
            propsData = {
              PortName = "Distransport"
            }
          }
        },
        commentData = {}
      }
    },
    ["17864421677532795417"] = {
      isStoryNode = true,
      key = "17864421677532795417",
      type = "StoryNode",
      name = "传送",
      pos = {x = 2036.5609909509108, y = 241.32719364497817},
      propsData = {
        QuestId = 11021405,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110214_8",
        QuestDeatil = "Content_110214_8",
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
            startQuest = "17864421677552795466",
            startPort = "QuestStart",
            endQuest = "17864421677552795469",
            endPort = "In"
          },
          {
            startQuest = "17864421677552795469",
            startPort = "Out",
            endQuest = "17864421677552795467",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17864421677552795466"] = {
            key = "17864421677552795466",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17864421677552795467"] = {
            key = "17864421677552795467",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17864421677552795468"] = {
            key = "17864421677552795468",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17864421677552795469"] = {
            key = "17864421677552795469",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1680, y = 284},
            propsData = {WaitTime = 1}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
