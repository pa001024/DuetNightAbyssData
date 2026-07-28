return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178211133617425649440",
      startPort = "StoryStart",
      endStory = "178211133660525649467",
      endPort = "In"
    },
    {
      startStory = "178211133660525649467",
      startPort = "Success",
      endStory = "178211133617525649443",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178211133617425649440"] = {
      isStoryNode = true,
      key = "178211133617425649440",
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
    ["178211133617525649443"] = {
      isStoryNode = true,
      key = "178211133617525649443",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2172, y = 344},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178211133660525649467"] = {
      isStoryNode = true,
      key = "178211133660525649467",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1604, y = 336},
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
            startQuest = "178211133660525649480",
            startPort = "Out",
            endQuest = "178211133660525649473",
            endPort = "Success"
          },
          {
            startQuest = "178211135095925649854",
            startPort = "Out",
            endQuest = "178211134843025649787",
            endPort = "In"
          },
          {
            startQuest = "178211134843025649787",
            startPort = "Out",
            endQuest = "178211133660525649480",
            endPort = "In"
          },
          {
            startQuest = "178211133660525649472",
            startPort = "QuestStart",
            endQuest = "17829061450669550291",
            endPort = "In"
          },
          {
            startQuest = "17829061450669550291",
            startPort = "Out",
            endQuest = "17829061405859550243",
            endPort = "In"
          },
          {
            startQuest = "178211133660525649472",
            startPort = "QuestStart",
            endQuest = "17829061692159550597",
            endPort = "In"
          },
          {
            startQuest = "17829061692159550597",
            startPort = "Out",
            endQuest = "178211135095925649854",
            endPort = "In"
          }
        },
        nodeData = {
          ["178211133660525649472"] = {
            key = "178211133660525649472",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178211133660525649473"] = {
            key = "178211133660525649473",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["178211133660525649474"] = {
            key = "178211133660525649474",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178211133660525649480"] = {
            key = "178211133660525649480",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2217.163515406163, y = 434.6532091097308},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178211134843025649787"] = {
            key = "178211134843025649787",
            type = "TalkNode",
            name = "过场动画 布鲁斯袭击主角",
            pos = {x = 1867.7561214910183, y = 440.68376794829896},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC010/SQ_OBT0101_SC010",
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
          ["178211135095925649854"] = {
            key = "178211135095925649854",
            type = "PlayOrStopBGMNode",
            name = "播放暂停音乐",
            pos = {x = 1585.7561214910188, y = 420.32662509115613},
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
          ["17829061405859550243"] = {
            key = "17829061405859550243",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1636, y = 194},
            propsData = {
              ModeType = 1,
              Id = 101101,
              StartIndex = 9,
              IsWhite = false
            }
          },
          ["17829061450669550291"] = {
            key = "17829061450669550291",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1240, y = 180},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17829061692159550597"] = {
            key = "17829061692159550597",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1234.0271370420626, y = 412.54545454545456},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
