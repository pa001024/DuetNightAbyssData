return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17791581245183390266",
      startPort = "StoryStart",
      endStory = "17791581245183390268",
      endPort = "In"
    },
    {
      startStory = "17791581245183390268",
      startPort = "Success",
      endStory = "17791581245183390267",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17791581245183390266"] = {
      isStoryNode = true,
      key = "17791581245183390266",
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
    ["17791581245183390267"] = {
      isStoryNode = true,
      key = "17791581245183390267",
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
    ["17791581245183390268"] = {
      isStoryNode = true,
      key = "17791581245183390268",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1266, y = 270.42105263157896},
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
            startQuest = "17791581245183390272",
            startPort = "Out",
            endQuest = "17791581245183390274",
            endPort = "In"
          },
          {
            startQuest = "17791581245183390269",
            startPort = "QuestStart",
            endQuest = "17791581245183390272",
            endPort = "In"
          },
          {
            startQuest = "17791581245183390269",
            startPort = "QuestStart",
            endQuest = "17791581245183390273",
            endPort = "In"
          },
          {
            startQuest = "17791581245183390273",
            startPort = "Out",
            endQuest = "17791581245183390276",
            endPort = "In"
          },
          {
            startQuest = "17791581245183390276",
            startPort = "Out",
            endQuest = "17791581245183390277",
            endPort = "In"
          },
          {
            startQuest = "17791581245183390277",
            startPort = "Out",
            endQuest = "17791581245183390278",
            endPort = "In"
          },
          {
            startQuest = "17791581245183390278",
            startPort = "Out",
            endQuest = "17791581245183390275",
            endPort = "In"
          },
          {
            startQuest = "17791581245183390275",
            startPort = "Out",
            endQuest = "17805634402347039072",
            endPort = "In"
          },
          {
            startQuest = "17805634402347039072",
            startPort = "Out",
            endQuest = "17791581245183390270",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17791581245183390269"] = {
            key = "17791581245183390269",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17791581245183390270"] = {
            key = "17791581245183390270",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["17791581245183390271"] = {
            key = "17791581245183390271",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17791581245183390272"] = {
            key = "17791581245183390272",
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
          ["17791581245183390273"] = {
            key = "17791581245183390273",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 549.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 100104,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17791581245183390274"] = {
            key = "17791581245183390274",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 100104,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17791581245183390275"] = {
            key = "17791581245183390275",
            type = "TalkNode",
            name = "过场-沙海醒来-SC00",
            pos = {x = 1897.010332983433, y = 520.6635706914349},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC000/SQ_OBT0100_SC000",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = true,
              StartFadeOutTime = 0,
              StartScreenEffectDuration = 1,
              FinishFadeInTime = 0,
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
                  TalkActorVisible = true
                }
              },
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["17791581245183390276"] = {
            key = "17791581245183390276",
            type = "ChangeRoleNode",
            name = "切换角色-女主",
            pos = {x = 1087.8169354336808, y = 516.3778564057205},
            propsData = {QuestRoleId = 1010101, IsPlayFX = false}
          },
          ["17791581245183390277"] = {
            key = "17791581245183390277",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1366.742212002493, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestVoidPre",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17791581245183390278"] = {
            key = "17791581245183390278",
            type = "PlayOrStopBGMNode",
            name = "BGM节点1",
            pos = {x = 1607.8814098056168, y = 557.8064278342918},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 1
            }
          },
          ["17805634402347039072"] = {
            key = "17805634402347039072",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 1
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
