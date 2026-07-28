return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178005290245414288787",
      startPort = "StoryStart",
      endStory = "178005290245414288789",
      endPort = "In"
    },
    {
      startStory = "178005290245414288789",
      startPort = "Success",
      endStory = "178005290245414288788",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178005290245414288787"] = {
      isStoryNode = true,
      key = "178005290245414288787",
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
    ["178005290245414288788"] = {
      isStoryNode = true,
      key = "178005290245414288788",
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
    ["178005290245414288789"] = {
      isStoryNode = true,
      key = "178005290245414288789",
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
            startQuest = "178005290245414288794",
            startPort = "Out",
            endQuest = "178005290245414288796",
            endPort = "In"
          },
          {
            startQuest = "178005290245414288791",
            startPort = "QuestStart",
            endQuest = "178005290245414288794",
            endPort = "In"
          },
          {
            startQuest = "178005290245414288791",
            startPort = "QuestStart",
            endQuest = "178005290245414288795",
            endPort = "In"
          },
          {
            startQuest = "178005290245414288795",
            startPort = "Out",
            endQuest = "178005290245414288797",
            endPort = "In"
          },
          {
            startQuest = "178005290245414288797",
            startPort = "Out",
            endQuest = "178005290245414288790",
            endPort = "In"
          },
          {
            startQuest = "178005290245414288790",
            startPort = "Out",
            endQuest = "178005289037513779623",
            endPort = "In"
          },
          {
            startQuest = "178005289037513779623",
            startPort = "Out",
            endQuest = "178056389629013071924",
            endPort = "In"
          },
          {
            startQuest = "178056389629013071924",
            startPort = "Out",
            endQuest = "178005290245414288792",
            endPort = "Success"
          }
        },
        nodeData = {
          ["178005289037513779623"] = {
            key = "178005289037513779623",
            type = "TalkNode",
            name = "过场-100117-赫卡蒂兰迪哔哔-SC14",
            pos = {x = 1771.2631578947369, y = 585.0526315789473},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC014/SQ_OBT0100_SC014",
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
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["178005290245414288790"] = {
            key = "178005290245414288790",
            type = "PlayOrStopBGMNode",
            name = "BGM - shendianyiji - Stop(MUTE)",
            pos = {x = 1501.212637207993, y = 577.0778014555104},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["178005290245414288791"] = {
            key = "178005290245414288791",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178005290245414288792"] = {
            key = "178005290245414288792",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2378.505494505494, y = 590.835164835165},
            propsData = {ModeType = 0}
          },
          ["178005290245414288793"] = {
            key = "178005290245414288793",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178005290245414288794"] = {
            key = "178005290245414288794",
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
          ["178005290245414288795"] = {
            key = "178005290245414288795",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 100103,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178005290245414288796"] = {
            key = "178005290245414288796",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 100103,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178005290245414288797"] = {
            key = "178005290245414288797",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint10504",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178056389629013071924"] = {
            key = "178056389629013071924",
            type = "PlayOrStopBGMNode",
            name = "BGM - shendianyiji - Stop(MUTE)",
            pos = {x = 2044, y = 596},
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
