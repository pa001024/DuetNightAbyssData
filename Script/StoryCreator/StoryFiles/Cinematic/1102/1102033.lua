return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "110203300001",
      startPort = "StoryStart",
      endStory = "110203300003",
      endPort = "In"
    },
    {
      startStory = "110203300003",
      startPort = "Success",
      endStory = "110203300002",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["110203300001"] = {
      isStoryNode = true,
      key = "110203300001",
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
    ["110203300002"] = {
      isStoryNode = true,
      key = "110203300002",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1700, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["110203300003"] = {
      isStoryNode = true,
      key = "110203300003",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1250, y = 300},
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
            startQuest = "110203310007",
            startPort = "Out",
            endQuest = "17859171300142976",
            endPort = "In"
          },
          {
            startQuest = "17859171300142976",
            startPort = "Out",
            endQuest = "110203310008",
            endPort = "In"
          },
          {
            startQuest = "110203310008",
            startPort = "Out",
            endQuest = "110203310002",
            endPort = "Success"
          },
          {
            startQuest = "110203310001",
            startPort = "QuestStart",
            endQuest = "17889569710691147159",
            endPort = "In"
          },
          {
            startQuest = "17889569710691147159",
            startPort = "Out",
            endQuest = "17889569643491146972",
            endPort = "In"
          },
          {
            startQuest = "110203310001",
            startPort = "QuestStart",
            endQuest = "17889569827201147509",
            endPort = "In"
          },
          {
            startQuest = "17889569827201147509",
            startPort = "Out",
            endQuest = "110203310007",
            endPort = "In"
          }
        },
        nodeData = {
          ["110203310001"] = {
            key = "110203310001",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 332.47706422018354, y = 480.1834862385321},
            propsData = {ModeType = 0}
          },
          ["110203310002"] = {
            key = "110203310002",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2400, y = 700},
            propsData = {ModeType = 0}
          },
          ["110203310007"] = {
            key = "110203310007",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 900, y = 650},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/1_6/0176_story_horror",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["17859171300142976"] = {
            key = "17859171300142976",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1220, y = 652},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0105/Ver0105_SC033/SQ_Ver0105_SC033.SQ_Ver0105_SC033",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = false,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = false,
              HideMonsters = true,
              bHidePickup = true,
              bHideSkillCreature = true,
              bHideSceneEffects = true,
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
          ["110203310008"] = {
            key = "110203310008",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 1540, y = 650},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17889569643491146972"] = {
            key = "17889569643491146972",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1460, y = 400},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17889569710691147159"] = {
            key = "17889569710691147159",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1038, y = 396},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17889569827201147509"] = {
            key = "17889569827201147509",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 600.5871559633028, y = 633.1926605504588},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 107001,
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
