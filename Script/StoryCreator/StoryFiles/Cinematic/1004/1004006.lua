return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178115887848369",
      startPort = "StoryStart",
      endStory = "1781158882152149",
      endPort = "In"
    },
    {
      startStory = "1781158882152149",
      startPort = "Success",
      endStory = "178115887848372",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178115887848369"] = {
      isStoryNode = true,
      key = "178115887848369",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 840, y = 304},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178115887848372"] = {
      isStoryNode = true,
      key = "178115887848372",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1962, y = 284},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1781158882152149"] = {
      isStoryNode = true,
      key = "1781158882152149",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1276, y = 226},
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
            startQuest = "1781158882152157",
            startPort = "Out",
            endQuest = "1781158882152159",
            endPort = "In"
          },
          {
            startQuest = "1781158882152154",
            startPort = "QuestStart",
            endQuest = "1781158882152157",
            endPort = "In"
          },
          {
            startQuest = "1781158882152154",
            startPort = "QuestStart",
            endQuest = "1781158882152158",
            endPort = "In"
          },
          {
            startQuest = "1781158882152158",
            startPort = "Out",
            endQuest = "1781158882152161",
            endPort = "In"
          },
          {
            startQuest = "1781158882152161",
            startPort = "Out",
            endQuest = "1781158882152162",
            endPort = "In"
          },
          {
            startQuest = "1781158882153164",
            startPort = "Out",
            endQuest = "1781158882152155",
            endPort = "Success"
          },
          {
            startQuest = "17811602099911257",
            startPort = "Out",
            endQuest = "1781158882153164",
            endPort = "In"
          },
          {
            startQuest = "1781158882152162",
            startPort = "Out",
            endQuest = "17811602194941466",
            endPort = "In"
          },
          {
            startQuest = "17811602194941466",
            startPort = "Out",
            endQuest = "17811602099911257",
            endPort = "In"
          },
          {
            startQuest = "1781158882152158",
            startPort = "Out",
            endQuest = "178125276480314360081",
            endPort = "Input"
          }
        },
        nodeData = {
          ["1781158882152154"] = {
            key = "1781158882152154",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 788.6206896551724, y = 172.75862068965517},
            propsData = {ModeType = 0}
          },
          ["1781158882152155"] = {
            key = "1781158882152155",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["1781158882152156"] = {
            key = "1781158882152156",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781158882152157"] = {
            key = "1781158882152157",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1154.925326115707, y = 182.44988008815142},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781158882152158"] = {
            key = "1781158882152158",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 822.7852056997242, y = 489.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 106001,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781158882152159"] = {
            key = "1781158882152159",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1523.5618660025189, y = 192.29511170166796},
            propsData = {
              ModeType = 1,
              Id = 106001,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781158882152161"] = {
            key = "1781158882152161",
            type = "ChangeRoleNode",
            name = "切换角色-女主",
            pos = {x = 1090.9203837095429, y = 513.2744081298584},
            propsData = {QuestRoleId = 1010101, IsPlayFX = false}
          },
          ["1781158882152162"] = {
            key = "1781158882152162",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1373.983591312838, y = 511.89509778503066},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_MTEnd",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1781158882153164"] = {
            key = "1781158882153164",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 1
            }
          },
          ["17811602099911257"] = {
            key = "17811602099911257",
            type = "TalkNode",
            name = "希尔妲出场动画",
            pos = {x = 1892.2175587140753, y = 579.5472203235362},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC006/SQ_Ver0104_SC006",
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
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["17811602194941466"] = {
            key = "17811602194941466",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1653.3286698251864, y = 569.5472203235364},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0164_cs_xier_show.0164_cs_xier_show'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["178125276480314360081"] = {
            key = "178125276480314360081",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1108.9522293798154, y = 372.00861542671885},
            propsData = {
              TargetTime = 17,
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
    }
  },
  commentData = {}
}
