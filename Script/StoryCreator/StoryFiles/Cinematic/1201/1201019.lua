return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742441535492",
      startPort = "StoryStart",
      endStory = "1781144742441535494",
      endPort = "In"
    },
    {
      startStory = "1781144742441535494",
      startPort = "Success",
      endStory = "1781144742441535493",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742441535492"] = {
      isStoryNode = true,
      key = "1781144742441535492",
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
    ["1781144742441535493"] = {
      isStoryNode = true,
      key = "1781144742441535493",
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
    ["1781144742441535494"] = {
      isStoryNode = true,
      key = "1781144742441535494",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1266, y = 272},
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
            startQuest = "1781144742441535500",
            startPort = "Out",
            endQuest = "1781144742441535502",
            endPort = "In"
          },
          {
            startQuest = "1781144742441535497",
            startPort = "QuestStart",
            endQuest = "1781144742441535500",
            endPort = "In"
          },
          {
            startQuest = "1781144742441535497",
            startPort = "QuestStart",
            endQuest = "1781144742441535501",
            endPort = "In"
          },
          {
            startQuest = "1781144742441535501",
            startPort = "Out",
            endQuest = "1781144742441535503",
            endPort = "In"
          },
          {
            startQuest = "1781144742441535503",
            startPort = "Out",
            endQuest = "178118368547521868544",
            endPort = "In"
          },
          {
            startQuest = "178118368547521868544",
            startPort = "Out",
            endQuest = "1781144742441535495",
            endPort = "In"
          },
          {
            startQuest = "1781144742441535495",
            startPort = "Out",
            endQuest = "178118369003521868652",
            endPort = "In"
          },
          {
            startQuest = "178118369003521868652",
            startPort = "Out",
            endQuest = "1781144742441535498",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781144742441535495"] = {
            key = "1781144742441535495",
            type = "TalkNode",
            name = "主角被止流催眠",
            pos = {x = 1614.1739130434785, y = 891.5652173913044},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC019/SQ_Ver0101_SC019",
              InType = "BlendIn",
              OutType = "BlendOut",
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = true,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["1781144742441535497"] = {
            key = "1781144742441535497",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742441535498"] = {
            key = "1781144742441535498",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2126.505494505494, y = 561.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781144742441535499"] = {
            key = "1781144742441535499",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742441535500"] = {
            key = "1781144742441535500",
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
          ["1781144742441535501"] = {
            key = "1781144742441535501",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104105,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742441535502"] = {
            key = "1781144742441535502",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 104105,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742441535503"] = {
            key = "1781144742441535503",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1122.242212002493, y = 548.8778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint_12010608",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178118368547521868544"] = {
            key = "178118368547521868544",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1537.1304347826085, y = 594.695652173913},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/mute",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {104105}
            }
          },
          ["178118369003521868652"] = {
            key = "178118369003521868652",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1941.4782608695652, y = 815.1304347826086},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
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
