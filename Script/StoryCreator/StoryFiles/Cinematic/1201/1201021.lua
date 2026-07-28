return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742443535767",
      startPort = "StoryStart",
      endStory = "1781144742443535769",
      endPort = "In"
    },
    {
      startStory = "1781144742443535769",
      startPort = "Success",
      endStory = "1781144742443535768",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742443535767"] = {
      isStoryNode = true,
      key = "1781144742443535767",
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
    ["1781144742443535768"] = {
      isStoryNode = true,
      key = "1781144742443535768",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1976, y = 342},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1781144742443535769"] = {
      isStoryNode = true,
      key = "1781144742443535769",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1266, y = 268},
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
            startQuest = "1781144742443535775",
            startPort = "Out",
            endQuest = "1781144742443535777",
            endPort = "In"
          },
          {
            startQuest = "1781144742443535772",
            startPort = "QuestStart",
            endQuest = "1781144742443535775",
            endPort = "In"
          },
          {
            startQuest = "1781144742443535772",
            startPort = "QuestStart",
            endQuest = "1781144742443535776",
            endPort = "In"
          },
          {
            startQuest = "1781144742443535778",
            startPort = "Out",
            endQuest = "1781144742443535773",
            endPort = "Success"
          },
          {
            startQuest = "1781144742443535776",
            startPort = "Out",
            endQuest = "178118383647223951430",
            endPort = "In"
          },
          {
            startQuest = "178118383647223951430",
            startPort = "Out",
            endQuest = "178118381232023950995",
            endPort = "In"
          },
          {
            startQuest = "178118381232023950995",
            startPort = "Out",
            endQuest = "1782220154715795",
            endPort = "In"
          },
          {
            startQuest = "1782220154715795",
            startPort = "Out",
            endQuest = "1781144742443535778",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742443535772"] = {
            key = "1781144742443535772",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742443535773"] = {
            key = "1781144742443535773",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2252.821283979178, y = 566.5720069404281},
            propsData = {ModeType = 0}
          },
          ["1781144742443535774"] = {
            key = "1781144742443535774",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742443535775"] = {
            key = "1781144742443535775",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1207.6839468053622, y = 303.4843628467721},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742443535776"] = {
            key = "1781144742443535776",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 685.5093436307587, y = 792.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 105701,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742443535777"] = {
            key = "1781144742443535777",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 105701,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742443535778"] = {
            key = "1781144742443535778",
            type = "PlayOrStopBGMNode",
            name = "播放或暂停或关闭声音",
            pos = {x = 1921.3684210526317, y = 561.7894736842105},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178118381232023950995"] = {
            key = "178118381232023950995",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1350.5, y = 807.125},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/1_1/0102_story_dafengjiuzhang",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {105701}
            }
          },
          ["178118383647223951430"] = {
            key = "178118383647223951430",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 950.875, y = 832.625},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "RegionPoint_Alt_01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1782220154715795"] = {
            key = "1782220154715795",
            type = "TalkNode",
            name = "大风九章CG",
            pos = {x = 1678.664185090272, y = 838.0600334448159},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = false,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1201/120106/SQ_Ver0101_SC021.SQ_Ver0101_SC021'",
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
              HideMechanismsFX = true,
              ShowSkipButton = true,
              ShowAutoPlayButton = false,
              ShowReviewButton = false,
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
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100001,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
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
