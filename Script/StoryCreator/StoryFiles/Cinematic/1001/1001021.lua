return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178056431285016608145",
      startPort = "StoryStart",
      endStory = "178056431285016608147",
      endPort = "In"
    },
    {
      startStory = "178056431285016608147",
      startPort = "Success",
      endStory = "178056431285016608146",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178056431285016608145"] = {
      isStoryNode = true,
      key = "178056431285016608145",
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
    ["178056431285016608146"] = {
      isStoryNode = true,
      key = "178056431285016608146",
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
    ["178056431285016608147"] = {
      isStoryNode = true,
      key = "178056431285016608147",
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
            startQuest = "178056431285016608154",
            startPort = "Out",
            endQuest = "178056431285016608156",
            endPort = "In"
          },
          {
            startQuest = "178056431285016608151",
            startPort = "QuestStart",
            endQuest = "178056431285016608154",
            endPort = "In"
          },
          {
            startQuest = "178056431285016608151",
            startPort = "QuestStart",
            endQuest = "178056431285016608155",
            endPort = "In"
          },
          {
            startQuest = "178056431285016608155",
            startPort = "Out",
            endQuest = "178056431285016608157",
            endPort = "In"
          },
          {
            startQuest = "178056431285016608157",
            startPort = "Out",
            endQuest = "178056431285016608149",
            endPort = "In"
          },
          {
            startQuest = "178056431285016608149",
            startPort = "Out",
            endQuest = "178056431285016608148",
            endPort = "In"
          },
          {
            startQuest = "178056431285016608148",
            startPort = "Out",
            endQuest = "178056431285016608150",
            endPort = "In"
          },
          {
            startQuest = "178056431285016608150",
            startPort = "Out",
            endQuest = "178056431285016608152",
            endPort = "Success"
          }
        },
        nodeData = {
          ["178056431285016608148"] = {
            key = "178056431285016608148",
            type = "TalkNode",
            name = "过场-100102-出山洞进村区域介绍",
            pos = {x = 1876, y = 572},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC021/SQ_OBT0100_SC021",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = true,
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
          ["178056431285016608149"] = {
            key = "178056431285016608149",
            type = "PlayOrStopBGMNode",
            name = "暂时关闭任务提示音",
            pos = {x = 1558.3333333333335, y = 568},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 2,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/snapshot/story/0_1_mute_mission_event.0_1_mute_mission_event'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["178056431285016608150"] = {
            key = "178056431285016608150",
            type = "PlayOrStopBGMNode",
            name = "开启任务提示音",
            pos = {x = 2198.3333333333335, y = 564.6666666666669},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 2
            }
          },
          ["178056431285016608151"] = {
            key = "178056431285016608151",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178056431285016608152"] = {
            key = "178056431285016608152",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2540.9523809523803, y = 536.904761904762},
            propsData = {ModeType = 0}
          },
          ["178056431285016608153"] = {
            key = "178056431285016608153",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178056431285016608154"] = {
            key = "178056431285016608154",
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
          ["178056431285016608155"] = {
            key = "178056431285016608155",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 910.3478529475288, y = 542.6907120531213},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 100101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178056431285016608156"] = {
            key = "178056431285016608156",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 100101,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178056431285016608157"] = {
            key = "178056431285016608157",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1262.2701623130522, y = 549.7318936728011},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint3",
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
    }
  },
  commentData = {}
}
