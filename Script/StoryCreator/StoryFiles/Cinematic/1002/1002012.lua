return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17817665697952135533",
      startPort = "StoryStart",
      endStory = "17817665711812135587",
      endPort = "In"
    },
    {
      startStory = "17817665711812135587",
      startPort = "Success",
      endStory = "17817665697952135536",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17817665697952135533"] = {
      isStoryNode = true,
      key = "17817665697952135533",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 923.3333333333334, y = 338.3333333333333},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17817665697952135536"] = {
      isStoryNode = true,
      key = "17817665697952135536",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1675, y = 370},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17817665711812135587"] = {
      isStoryNode = true,
      key = "17817665711812135587",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1311.9166666666665, y = 381},
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
            startQuest = "17817665711812135595",
            startPort = "Out",
            endQuest = "17817665711812135597",
            endPort = "In"
          },
          {
            startQuest = "17817665711812135592",
            startPort = "QuestStart",
            endQuest = "17817665711812135595",
            endPort = "In"
          },
          {
            startQuest = "17817665711812135592",
            startPort = "QuestStart",
            endQuest = "17817665711812135596",
            endPort = "In"
          },
          {
            startQuest = "17817665711812135600",
            startPort = "Out",
            endQuest = "17817665711812135593",
            endPort = "Success"
          },
          {
            startQuest = "17817665711812135599",
            startPort = "Out",
            endQuest = "17817669058972136096",
            endPort = "In"
          },
          {
            startQuest = "17817669058972136096",
            startPort = "Out",
            endQuest = "17817669042792136060",
            endPort = "In"
          },
          {
            startQuest = "17817669042792136060",
            startPort = "Out",
            endQuest = "17817665711812135600",
            endPort = "In"
          },
          {
            startQuest = "17817665711812135596",
            startPort = "Out",
            endQuest = "17817665711812135599",
            endPort = "In"
          }
        },
        nodeData = {
          ["17817665711812135592"] = {
            key = "17817665711812135592",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17817665711812135593"] = {
            key = "17817665711812135593",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["17817665711812135594"] = {
            key = "17817665711812135594",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17817665711812135595"] = {
            key = "17817665711812135595",
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
          ["17817665711812135596"] = {
            key = "17817665711812135596",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 547.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17817665711812135597"] = {
            key = "17817665711812135597",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 101101,
              StartIndex = 3,
              IsWhite = false
            }
          },
          ["17817665711812135599"] = {
            key = "17817665711812135599",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1306.742212002493, y = 666.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "TargetPoint_Chapter01_10020107",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17817665711812135600"] = {
            key = "17817665711812135600",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17817669042792136060"] = {
            key = "17817669042792136060",
            type = "TalkNode",
            name = "小白敲门",
            pos = {x = 1948.0461262247195, y = 558.648795420848},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC012/SQ_OBT0101_SC012",
              BlendInTime = 0,
              InType = "FadeIn",
              OutType = "BlendOut",
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
          ["17817669058972136096"] = {
            key = "17817669058972136096",
            type = "PlayOrStopBGMNode",
            name = "播放疗养院剧情音乐",
            pos = {x = 1672.7520085776607, y = 562.1782071855538},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt01/0020_story_sanatorium.0020_story_sanatorium'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
