return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17802976071663974915",
      startPort = "StoryStart",
      endStory = "17802976071663974918",
      endPort = "In"
    },
    {
      startStory = "17802973974322205",
      startPort = "Success",
      endStory = "17802976071663974916",
      endPort = "StoryEnd"
    },
    {
      startStory = "17802976071663974918",
      startPort = "Success",
      endStory = "17804126060521504484",
      endPort = "In"
    },
    {
      startStory = "17804126060521504484",
      startPort = "Success",
      endStory = "17804129220073009137",
      endPort = "In"
    },
    {
      startStory = "17804129220073009137",
      startPort = "Success",
      endStory = "17804136867165013958",
      endPort = "In"
    },
    {
      startStory = "17804136867165013958",
      startPort = "Success",
      endStory = "17804150346156518019",
      endPort = "In"
    },
    {
      startStory = "17804150346156518019",
      startPort = "Success",
      endStory = "17804164294298024025",
      endPort = "In"
    },
    {
      startStory = "17804164294298024025",
      startPort = "Success",
      endStory = "17804690957871474",
      endPort = "In"
    },
    {
      startStory = "17804826947144532207",
      startPort = "Success",
      endStory = "17804848452257546079",
      endPort = "In"
    },
    {
      startStory = "17804690957871474",
      startPort = "Success",
      endStory = "17804826947144532207",
      endPort = "In"
    },
    {
      startStory = "17804848452257546079",
      startPort = "Success",
      endStory = "17802973974322205",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17802973974322205"] = {
      isStoryNode = true,
      key = "17802973974322205",
      type = "StoryNode",
      name = "回沙龙对话",
      pos = {x = 2343.445021962902, y = 646.654665793443},
      propsData = {
        QuestId = 20040616,
        QuestDescriptionComment = "",
        QuestDescription = "Content_20040615",
        QuestDeatil = "Description_20040615",
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
        StoryGuidePointName = "Npc_Xidun_152480430",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17802973974322206",
            startPort = "QuestStart",
            endQuest = "17804852989779055289",
            endPort = "In"
          },
          {
            startQuest = "17804852989779055289",
            startPort = "Out",
            endQuest = "17804852955039055191",
            endPort = "In"
          },
          {
            startQuest = "17804852955039055191",
            startPort = "Out",
            endQuest = "17812553337917812519",
            endPort = "In"
          },
          {
            startQuest = "17812553337917812519",
            startPort = "Out",
            endQuest = "17802973974322209",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17802973974322206"] = {
            key = "17802973974322206",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1362, y = 296},
            propsData = {ModeType = 0}
          },
          ["17802973974322209"] = {
            key = "17802973974322209",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2506.2272727272725, y = 297.59090909090907},
            propsData = {ModeType = 0}
          },
          ["17802973974322212"] = {
            key = "17802973974322212",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17804852955039055191"] = {
            key = "17804852955039055191",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1939, y = 298.5},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700460,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Xidun_152480430",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = false,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51213224,
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
                  TalkActorId = 700450,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700457,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700460,
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
          ["17804852989779055289"] = {
            key = "17804852989779055289",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1656, y = 296.5},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480430}
            }
          },
          ["17812553337917812519"] = {
            key = "17812553337917812519",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2225, y = 310},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480430}
            }
          }
        },
        commentData = {}
      }
    },
    ["17802976071663974915"] = {
      isStoryNode = true,
      key = "17802976071663974915",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 651.2383655370957, y = 397.54510860019906},
      propsData = {QuestChainId = 200406},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17802976071663974916"] = {
      isStoryNode = true,
      key = "17802976071663974916",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2633.582431634861, y = 657.8977572299824},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17802976071663974918"] = {
      isStoryNode = true,
      key = "17802976071663974918",
      type = "StoryNode",
      name = "白和奥哥对话",
      pos = {x = 974.9862737081429, y = 395.40433614462114},
      propsData = {
        QuestId = 20040601,
        QuestDescriptionComment = "",
        QuestDescription = "Content_20040601",
        QuestDeatil = "Description_20040601",
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
        StoryGuidePointName = "Npc_Bai_152480429",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17802976071663974924",
            startPort = "QuestStart",
            endQuest = "1780412162649899",
            endPort = "In"
          },
          {
            startQuest = "1780412162649899",
            startPort = "Out",
            endQuest = "17804122730321542",
            endPort = "In"
          },
          {
            startQuest = "17804122730321542",
            startPort = "Out",
            endQuest = "17804129346793009620",
            endPort = "In"
          },
          {
            startQuest = "17804129346793009620",
            startPort = "Out",
            endQuest = "17802976071663974925",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17802976071663974924"] = {
            key = "17802976071663974924",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 381.3346774193549, y = 283.31451612903226},
            propsData = {ModeType = 0}
          },
          ["17802976071663974925"] = {
            key = "17802976071663974925",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1477.9757755530838, y = 299.3840069212705},
            propsData = {ModeType = 0}
          },
          ["17802976071663974926"] = {
            key = "17802976071663974926",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1301.7025089605734, y = 522.8897849462367},
            propsData = {}
          },
          ["1780412162649899"] = {
            key = "1780412162649899",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 674, y = 284},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480428, 152480429}
            }
          },
          ["17804122730321542"] = {
            key = "17804122730321542",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 975.0271132376397, y = 289.11503189792654},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700450,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Bai_152480429",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51213001,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200406/20040601.20040601'",
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
          ["17804129346793009620"] = {
            key = "17804129346793009620",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1217.9066145856564, y = 302.8657318180671},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480428, 152480429}
            }
          }
        },
        commentData = {}
      }
    },
    ["17804126060521504484"] = {
      isStoryNode = true,
      key = "17804126060521504484",
      type = "StoryNode",
      name = "西顿对话",
      pos = {x = 1261.6866366796035, y = 393.07937362588046},
      propsData = {
        QuestId = 20040602,
        QuestDescriptionComment = "",
        QuestDescription = "Content_20040602",
        QuestDeatil = "Description_20040602",
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
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Xidun_152480430",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17804126060521504485",
            startPort = "QuestStart",
            endQuest = "17804128045801505711",
            endPort = "In"
          },
          {
            startQuest = "17804128045801505711",
            startPort = "Out",
            endQuest = "17804128269361506229",
            endPort = "In"
          },
          {
            startQuest = "17804128269361506229",
            startPort = "Out",
            endQuest = "17804126060521504488",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17804126060521504485"] = {
            key = "17804126060521504485",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 818.9473684210526, y = 288.94736842105266},
            propsData = {ModeType = 0}
          },
          ["17804126060521504488"] = {
            key = "17804126060521504488",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1884.2105263157896, y = 307.89473684210526},
            propsData = {ModeType = 0}
          },
          ["17804126060521504491"] = {
            key = "17804126060521504491",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17804128045801505711"] = {
            key = "17804128045801505711",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1147.6842105263158, y = 288.9460784313725},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480430}
            }
          },
          ["17804128269361506229"] = {
            key = "17804128269361506229",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1527.6842105263158, y = 296.8408152734778},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700460,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Xidun_152480430",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51213023,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200406/20040602.20040602'",
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
    },
    ["17804129220073009137"] = {
      isStoryNode = true,
      key = "17804129220073009137",
      type = "StoryNode",
      name = "西顿对话",
      pos = {x = 1518.8692318621988, y = 388.575100121607},
      propsData = {
        QuestId = 20040603,
        QuestDescriptionComment = "",
        QuestDescription = "Content_20040603",
        QuestDeatil = "Description_20040603",
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
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Xidun_152480430",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17804129220073009142",
            startPort = "QuestStart",
            endQuest = "17804129519603010143",
            endPort = "In"
          },
          {
            startQuest = "17804129519603010143",
            startPort = "Out",
            endQuest = "17812553824307813808",
            endPort = "In"
          },
          {
            startQuest = "17812553824307813808",
            startPort = "Out",
            endQuest = "17804129220073009143",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17804129220073009142"] = {
            key = "17804129220073009142",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 870.8704453441295, y = 291.255060728745},
            propsData = {ModeType = 0}
          },
          ["17804129220073009143"] = {
            key = "17804129220073009143",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1884.2105263157896, y = 307.89473684210526},
            propsData = {ModeType = 0}
          },
          ["17804129220073009144"] = {
            key = "17804129220073009144",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17804129519603010143"] = {
            key = "17804129519603010143",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1241.6146805139938, y = 292.2128800508057},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700460,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Xidun_152480430",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51213034,
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
          ["17812553824307813808"] = {
            key = "17812553824307813808",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1552.113888888889, y = 298.49829059829057},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480430}
            }
          }
        },
        commentData = {}
      }
    },
    ["17804136867165013958"] = {
      isStoryNode = true,
      key = "17804136867165013958",
      type = "StoryNode",
      name = "白和奥哥对话",
      pos = {x = 1788.8692318621986, y = 383.9597155062223},
      propsData = {
        QuestId = 20040604,
        QuestDescriptionComment = "",
        QuestDescription = "Content_20040604",
        QuestDeatil = "Description_20040604",
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
        StoryGuidePointName = "Npc_Bai_152480429",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17804136867165013963",
            startPort = "QuestStart",
            endQuest = "17804136867165013966",
            endPort = "In"
          },
          {
            startQuest = "17804136867165013966",
            startPort = "Out",
            endQuest = "17804136867165013967",
            endPort = "In"
          },
          {
            startQuest = "17804136867165013967",
            startPort = "Out",
            endQuest = "17804136867165013968",
            endPort = "In"
          },
          {
            startQuest = "17804136867165013968",
            startPort = "Out",
            endQuest = "17804136867165013964",
            endPort = "Success"
          },
          {
            startQuest = "17804136867165013963",
            startPort = "QuestStart",
            endQuest = "17804137225865014740",
            endPort = "In"
          }
        },
        nodeData = {
          ["17804136867165013963"] = {
            key = "17804136867165013963",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 381.3346774193549, y = 283.31451612903226},
            propsData = {ModeType = 0}
          },
          ["17804136867165013964"] = {
            key = "17804136867165013964",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1477.9757755530838, y = 299.3840069212705},
            propsData = {ModeType = 0}
          },
          ["17804136867165013965"] = {
            key = "17804136867165013965",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1301.7025089605734, y = 522.8897849462367},
            propsData = {}
          },
          ["17804136867165013966"] = {
            key = "17804136867165013966",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 674, y = 284},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480428, 152480429}
            }
          },
          ["17804136867165013967"] = {
            key = "17804136867165013967",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 975.0271132376397, y = 289.11503189792654},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700450,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Bai_152480429",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = false,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51213065,
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
                  TalkActorId = 700450,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700457,
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
          ["17804136867165013968"] = {
            key = "17804136867165013968",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1217.9066145856564, y = 302.8657318180671},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480428, 152480429}
            }
          },
          ["17804137225865014740"] = {
            key = "17804137225865014740",
            type = "TalkNode",
            name = "开车",
            pos = {x = 672.4227436179143, y = 87.0592802051639},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51213063,
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
    ["17804150346156518019"] = {
      isStoryNode = true,
      key = "17804150346156518019",
      type = "StoryNode",
      name = "办事人对话",
      pos = {x = 2060.7923087852755, y = 375.88279242929923},
      propsData = {
        QuestId = 20040605,
        QuestDescriptionComment = "",
        QuestDescription = "Content_20040605",
        QuestDeatil = "Description_20040605",
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
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Banshiren_152480431",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17804150346156518020",
            startPort = "QuestStart",
            endQuest = "17804150535696518354",
            endPort = "In"
          },
          {
            startQuest = "17804150535696518354",
            startPort = "Out",
            endQuest = "17804154220376519690",
            endPort = "In"
          },
          {
            startQuest = "17804154220376519690",
            startPort = "Out",
            endQuest = "17804150346156518023",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17804150346156518020"] = {
            key = "17804150346156518020",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17804150346156518023"] = {
            key = "17804150346156518023",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1872, y = 314},
            propsData = {ModeType = 0}
          },
          ["17804150346156518026"] = {
            key = "17804150346156518026",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17804150535696518354"] = {
            key = "17804150535696518354",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1208, y = 314},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480431}
            }
          },
          ["17804154220376519690"] = {
            key = "17804154220376519690",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1551.0344827586207, y = 312},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700454,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Banshiren_152480431",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51213073,
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
          }
        },
        commentData = {}
      }
    },
    ["17804164294298024025"] = {
      isStoryNode = true,
      key = "17804164294298024025",
      type = "StoryNode",
      name = "白和奥哥对话",
      pos = {x = 2328.869231862199, y = 377.0366385831454},
      propsData = {
        QuestId = 20040606,
        QuestDescriptionComment = "",
        QuestDescription = "Content_20040606",
        QuestDeatil = "Description_20040606",
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
        StoryGuidePointName = "Npc_Bai_152480429",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17804164294298024030",
            startPort = "QuestStart",
            endQuest = "17804164294298024033",
            endPort = "In"
          },
          {
            startQuest = "17804164294298024033",
            startPort = "Out",
            endQuest = "17804164294298024034",
            endPort = "In"
          },
          {
            startQuest = "17804164294298024034",
            startPort = "Out",
            endQuest = "17804164294298024035",
            endPort = "In"
          },
          {
            startQuest = "17804164294298024035",
            startPort = "Out",
            endQuest = "17804164294298024031",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17804164294298024030"] = {
            key = "17804164294298024030",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 381.3346774193549, y = 283.31451612903226},
            propsData = {ModeType = 0}
          },
          ["17804164294298024031"] = {
            key = "17804164294298024031",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1502.1693239401807, y = 285.8356198244963},
            propsData = {ModeType = 0}
          },
          ["17804164294298024032"] = {
            key = "17804164294298024032",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1301.7025089605734, y = 522.8897849462367},
            propsData = {}
          },
          ["17804164294298024033"] = {
            key = "17804164294298024033",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 674, y = 284},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480432, 152480433}
            }
          },
          ["17804164294298024034"] = {
            key = "17804164294298024034",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 975.0271132376397, y = 289.11503189792654},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700450,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Bai_152480429",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = false,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51213092,
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
                  TalkActorId = 700450,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700457,
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
          ["17804164294298024035"] = {
            key = "17804164294298024035",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1236.29371135985, y = 295.12379633419613},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                152480432,
                152480433,
                152480431
              }
            }
          }
        },
        commentData = {}
      }
    },
    ["17804690957871474"] = {
      isStoryNode = true,
      key = "17804690957871474",
      type = "StoryNode",
      name = "寻找有戏剧声音的地方",
      pos = {x = 2616.8794117647058, y = 375.8430481283423},
      propsData = {
        QuestId = 20040607,
        QuestDescriptionComment = "",
        QuestDescription = "Content_20040607",
        QuestDeatil = "Description_20040607",
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
            startQuest = "17804690957871475",
            startPort = "QuestStart",
            endQuest = "17804708044382329",
            endPort = "In"
          },
          {
            startQuest = "17809029975037320",
            startPort = "Success",
            endQuest = "17804690957881478",
            endPort = "Success"
          },
          {
            startQuest = "17804708044382329",
            startPort = "Out",
            endQuest = "17809029975037320",
            endPort = "In"
          },
          {
            startQuest = "17809029975037320",
            startPort = "Fail",
            endQuest = "17811776278301025414",
            endPort = "In"
          },
          {
            startQuest = "17811776278301025414",
            startPort = "Out",
            endQuest = "17804690957881481",
            endPort = "Fail"
          },
          {
            startQuest = "17809029975037320",
            startPort = "PassiveFail",
            endQuest = "17811776278301025414",
            endPort = "In"
          }
        },
        nodeData = {
          ["17804690957871475"] = {
            key = "17804690957871475",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 278.3541353383458, y = 282.50300751879695},
            propsData = {ModeType = 0}
          },
          ["17804690957881478"] = {
            key = "17804690957881478",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1491.5800208563364, y = 330.1858360937308},
            propsData = {ModeType = 0}
          },
          ["17804690957881481"] = {
            key = "17804690957881481",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1590.4886446886455, y = 546.4380952380953},
            propsData = {}
          },
          ["17804708044382329"] = {
            key = "17804708044382329",
            type = "GoToNode",
            name = "前往任务区域",
            pos = {x = 587.5368421052633, y = 294.4631578947368},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 152480632,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_152480632"
            }
          },
          ["17809029975037320"] = {
            key = "17809029975037320",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 974.8932718038769, y = 288.4712833606019},
            propsData = {SpecialConfigId = 20040607, BlackScreenImmediately = false}
          },
          ["17811776278301025414"] = {
            key = "17811776278301025414",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1291.8939075630253, y = 534.0504201680671},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_20040607_Fail",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17804727463123018823"] = {
      isStoryNode = true,
      key = "17804727463123018823",
      type = "StoryNode",
      name = "战斗",
      pos = {x = 980.9004643962849, y = 623.0430481283422},
      propsData = {
        QuestId = 20040610,
        QuestDescriptionComment = "",
        QuestDescription = "Content_20040610",
        QuestDeatil = "Description_20040610",
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
            startQuest = "17804727463123018824",
            startPort = "QuestStart",
            endQuest = "17804728442083020628",
            endPort = "In"
          },
          {
            startQuest = "17804728442083020628",
            startPort = "Out",
            endQuest = "17804731750124525562",
            endPort = "In"
          },
          {
            startQuest = "17804731750124525562",
            startPort = "Out",
            endQuest = "17804731787754525608",
            endPort = "In"
          },
          {
            startQuest = "17804731787754525608",
            startPort = "Out",
            endQuest = "17804727463123018827",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17804727463123018824"] = {
            key = "17804727463123018824",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17804727463123018827"] = {
            key = "17804727463123018827",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2130, y = 325},
            propsData = {ModeType = 0}
          },
          ["17804727463123018830"] = {
            key = "17804727463123018830",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17804728442083020628"] = {
            key = "17804728442083020628",
            type = "GoToNode",
            name = "前往任务区域",
            pos = {x = 1114, y = 309.99999999999994},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 152480434,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestRegion_152480434"
            }
          },
          ["17804731750124525562"] = {
            key = "17804731750124525562",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1434.85, y = 308},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                152480443,
                152480444,
                152480445,
                152480446
              }
            }
          },
          ["17804731787754525608"] = {
            key = "17804731787754525608",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 1796.5, y = 308.25},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 4,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                152480443,
                152480444,
                152480445,
                152480446
              }
            }
          }
        },
        commentData = {}
      }
    },
    ["17804774798573023459"] = {
      isStoryNode = true,
      key = "17804774798573023459",
      type = "StoryNode",
      name = "阿尔西娅对话",
      pos = {x = 1251.0704714980354, y = 627.5680654428805},
      propsData = {
        QuestId = 20040611,
        QuestDescriptionComment = "",
        QuestDescription = "Content_20040611",
        QuestDeatil = "Description_20040611",
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
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Aerxiya_152480442",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17804777095893024342",
            startPort = "Out",
            endQuest = "17804774798573023465",
            endPort = "Success"
          },
          {
            startQuest = "17804774798573023464",
            startPort = "QuestStart",
            endQuest = "17804777095893024342",
            endPort = "In"
          }
        },
        nodeData = {
          ["17804774798573023464"] = {
            key = "17804774798573023464",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1080.2884615384614, y = 309.867374005305},
            propsData = {ModeType = 0}
          },
          ["17804774798573023465"] = {
            key = "17804774798573023465",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1753.6472148541113, y = 297.0689655172414},
            propsData = {ModeType = 0}
          },
          ["17804774798573023466"] = {
            key = "17804774798573023466",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17804777095893024342"] = {
            key = "17804777095893024342",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1451.0196065428822, y = 289.7353355204988},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51213145,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200406/20040611.20040611'",
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
    },
    ["17804826947144532207"] = {
      isStoryNode = true,
      key = "17804826947144532207",
      type = "StoryNode",
      name = "列维凯兰对话",
      pos = {x = 1522.6089330364969, y = 632.8757577505728},
      propsData = {
        QuestId = 20040612,
        QuestDescriptionComment = "",
        QuestDescription = "Content_20040612",
        QuestDeatil = "Description_20040612",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = false,
        bIsNotifyGameMode = true,
        bIsStartChapter = false,
        bIsEndChapter = false,
        bIsPlayBlackScreenOnComplete = true,
        bIsPlayBlackScreenOnFail = false,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Kailan_152480447",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17804845205504533698",
            startPort = "Out",
            endQuest = "17804846466864534020",
            endPort = "In"
          },
          {
            startQuest = "17804826947144532208",
            startPort = "QuestStart",
            endQuest = "178119158547913905124",
            endPort = "In"
          },
          {
            startQuest = "178119158547913905124",
            startPort = "Out",
            endQuest = "17804845205504533698",
            endPort = "In"
          },
          {
            startQuest = "17804846466864534020",
            startPort = "Out",
            endQuest = "17812545913584689244",
            endPort = "In"
          },
          {
            startQuest = "17812545913584689244",
            startPort = "Out",
            endQuest = "17804826947144532211",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17804826947144532208"] = {
            key = "17804826947144532208",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 519.7826086956521, y = 309.1847826086957},
            propsData = {ModeType = 0}
          },
          ["17804826947144532211"] = {
            key = "17804826947144532211",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1927.6315789473683, y = 313.08270676691734},
            propsData = {ModeType = 0}
          },
          ["17804826947144532214"] = {
            key = "17804826947144532214",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17804845205504533698"] = {
            key = "17804845205504533698",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1122.2266956917988, y = 310.980405559353},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 152480449,
              GuideType = "M",
              GuidePointName = "Mechanism_KailanLiewei_152480449"
            }
          },
          ["17804846466864534020"] = {
            key = "17804846466864534020",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1420.6477483233778, y = 307.8225108225108},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51213170,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200406/20040612.20040612'",
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
          ["178119158547913905124"] = {
            key = "178119158547913905124",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 821.9362967447989, y = 308.7257766644535},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "Mechanism_KailanLiewei_152480449",
              StaticCreatorIdList = {152480447, 152480448}
            }
          },
          ["17812545913584689244"] = {
            key = "17812545913584689244",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1674.5725957049485, y = 325.1671862948078},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "Mechanism_KailanLiewei_152480449",
              StaticCreatorIdList = {152480447, 152480448}
            }
          }
        },
        commentData = {}
      }
    },
    ["17804848452257546079"] = {
      isStoryNode = true,
      key = "17804848452257546079",
      type = "StoryNode",
      name = "战斗",
      pos = {x = 1799.6089330364969, y = 635.8757577505728},
      propsData = {
        QuestId = 20040613,
        QuestDescriptionComment = "",
        QuestDescription = "Content_20040613",
        QuestDeatil = "Description_20040613",
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
            startQuest = "17809034507191528519",
            startPort = "Success",
            endQuest = "17804848452257546083",
            endPort = "Success"
          },
          {
            startQuest = "17804848452257546080",
            startPort = "QuestStart",
            endQuest = "17822243945643220",
            endPort = "In"
          },
          {
            startQuest = "17822243945643220",
            startPort = "true",
            endQuest = "17809034507191528519",
            endPort = "In"
          },
          {
            startQuest = "17822243945643220",
            startPort = "false",
            endQuest = "17809034741301529386",
            endPort = "In"
          },
          {
            startQuest = "17809034741301529386",
            startPort = "Out",
            endQuest = "17809034507191528519",
            endPort = "In"
          },
          {
            startQuest = "17822243945643220",
            startPort = "true",
            endQuest = "17822244583604164",
            endPort = "In"
          },
          {
            startQuest = "17809034507191528519",
            startPort = "Fail",
            endQuest = "17823699552233217",
            endPort = "In"
          },
          {
            startQuest = "17823699552233217",
            startPort = "Out",
            endQuest = "17804848452257546086",
            endPort = "Fail"
          },
          {
            startQuest = "17809034507191528519",
            startPort = "PassiveFail",
            endQuest = "17823699552233217",
            endPort = "In"
          }
        },
        nodeData = {
          ["17804848452257546080"] = {
            key = "17804848452257546080",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 446.0769230769231, y = 324.46153846153845},
            propsData = {ModeType = 0}
          },
          ["17804848452257546083"] = {
            key = "17804848452257546083",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1871.448275862069, y = 308.13793103448273},
            propsData = {ModeType = 0}
          },
          ["17804848452257546086"] = {
            key = "17804848452257546086",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2063.2571428571428, y = 612.0571428571429},
            propsData = {}
          },
          ["17809034507191528519"] = {
            key = "17809034507191528519",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1444.987912087912, y = 313.36043956043943},
            propsData = {SpecialConfigId = 20040613, BlackScreenImmediately = true}
          },
          ["17809034741301529386"] = {
            key = "17809034741301529386",
            type = "GoToNode",
            name = "前往任务区域",
            pos = {x = 1129.6303109933542, y = 570.0683512140033},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 152480656,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_152480656"
            }
          },
          ["17822243945643220"] = {
            key = "17822243945643220",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 842.747413392732, y = 326.6989746242183},
            propsData = {
              FunctionName = "Equal",
              VarName = "First20040613",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17822244583604164"] = {
            key = "17822244583604164",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1146.254989150308, y = -12.801025375781606},
            propsData = {
              VarName = "First20040613",
              VarValue = 1
            }
          },
          ["17823699552233217"] = {
            key = "17823699552233217",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1790.7083333333335, y = 603.9912280701755},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_20040613_Fail",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17804851913739053974"] = {
      isStoryNode = true,
      key = "17804851913739053974",
      type = "StoryNode",
      name = "列维凯兰对话",
      pos = {x = 2089.9935484211123, y = 826.1834500582652},
      propsData = {
        QuestId = 20040614,
        QuestDescriptionComment = "",
        QuestDescription = "Content_20040614",
        QuestDeatil = "Description_20040614",
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
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Kailan_152480447",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17804851913739053979",
            startPort = "QuestStart",
            endQuest = "17812545145083127314",
            endPort = "In"
          },
          {
            startQuest = "17812545145083127314",
            startPort = "Out",
            endQuest = "17804851913739053983",
            endPort = "In"
          },
          {
            startQuest = "17804851913739053983",
            startPort = "Out",
            endQuest = "17815057301332736",
            endPort = "In"
          },
          {
            startQuest = "17815057301332736",
            startPort = "Out",
            endQuest = "17804851913739053980",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17804851913739053979"] = {
            key = "17804851913739053979",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 875.60989010989, y = 314.96703296703294},
            propsData = {ModeType = 0}
          },
          ["17804851913739053980"] = {
            key = "17804851913739053980",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1925.323886639676, y = 302.3684210526316},
            propsData = {ModeType = 0}
          },
          ["17804851913739053981"] = {
            key = "17804851913739053981",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17804851913739053983"] = {
            key = "17804851913739053983",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1418.076319751949, y = 307.8225108225108},
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
          ["17812545145083127314"] = {
            key = "17812545145083127314",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1147.8337912087911, y = 315.0174868609652},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480448}
            }
          },
          ["17815057301332736"] = {
            key = "17815057301332736",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1669.493488529015, y = 314.4121413483541},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480448}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
