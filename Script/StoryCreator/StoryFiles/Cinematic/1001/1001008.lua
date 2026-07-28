return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17800510648932475484",
      startPort = "StoryStart",
      endStory = "17800510648942475486",
      endPort = "In"
    },
    {
      startStory = "17800510648942475486",
      startPort = "Success",
      endStory = "17800510648942475485",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17800510648932475484"] = {
      isStoryNode = true,
      key = "17800510648932475484",
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
    ["17800510648942475485"] = {
      isStoryNode = true,
      key = "17800510648942475485",
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
    ["17800510648942475486"] = {
      isStoryNode = true,
      key = "17800510648942475486",
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
            startQuest = "17800510648942475490",
            startPort = "Out",
            endQuest = "17800510648942475492",
            endPort = "In"
          },
          {
            startQuest = "17800510648942475487",
            startPort = "QuestStart",
            endQuest = "17800510648942475490",
            endPort = "In"
          },
          {
            startQuest = "17800510648942475487",
            startPort = "QuestStart",
            endQuest = "17800510648942475491",
            endPort = "In"
          },
          {
            startQuest = "17800510648942475491",
            startPort = "Out",
            endQuest = "17800510648942475493",
            endPort = "In"
          },
          {
            startQuest = "17800510648942475493",
            startPort = "Out",
            endQuest = "178005263125110824834",
            endPort = "In"
          },
          {
            startQuest = "178005263125110824834",
            startPort = "Out",
            endQuest = "178005261310110824613",
            endPort = "In"
          },
          {
            startQuest = "178005261310110824613",
            startPort = "Out",
            endQuest = "178056370680610055788",
            endPort = "In"
          },
          {
            startQuest = "178056370680610055788",
            startPort = "Out",
            endQuest = "17800510648942475488",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17800510648942475487"] = {
            key = "17800510648942475487",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17800510648942475488"] = {
            key = "17800510648942475488",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2245.242336610757, y = 583.5807788702526},
            propsData = {ModeType = 0}
          },
          ["17800510648942475489"] = {
            key = "17800510648942475489",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17800510648942475490"] = {
            key = "17800510648942475490",
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
          ["17800510648942475491"] = {
            key = "17800510648942475491",
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
          ["17800510648942475492"] = {
            key = "17800510648942475492",
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
          ["17800510648942475493"] = {
            key = "17800510648942475493",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1122.242212002493, y = 548.8778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint100105",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178005261310110824613"] = {
            key = "178005261310110824613",
            type = "TalkNode",
            name = "过场-100103-炮击-SC08",
            pos = {x = 1682.8123566639379, y = 582.145933014354},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC008/SQ_OBT0100_SC008",
              BlendOutTime = 0,
              InType = "BlendIn",
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
              EndNewTargetPointName = "QuestPoint0205",
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
          ["178005263125110824834"] = {
            key = "178005263125110824834",
            type = "PlayOrStopBGMNode",
            name = "bgm - zhuizhuzhan  - start",
            pos = {x = 1412.30963773069, y = 578.7234051157532},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "/Game/Asset/Audio/FMOD/Events/bgm/cbt01/0008_combat_zhuizhuzhan",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["178056370680610055788"] = {
            key = "178056370680610055788",
            type = "PlayOrStopBGMNode",
            name = "bgm - zhuizhuzhan  - start",
            pos = {x = 1968.5, y = 582},
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
