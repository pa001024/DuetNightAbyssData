return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "110202000001",
      startPort = "StoryStart",
      endStory = "110202000003",
      endPort = "In"
    },
    {
      startStory = "110202000003",
      startPort = "Success",
      endStory = "110202000002",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["110202000001"] = {
      isStoryNode = true,
      key = "110202000001",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 0}
    },
    ["110202000002"] = {
      isStoryNode = true,
      key = "110202000002",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1700, y = 300},
      propsData = {}
    },
    ["110202000003"] = {
      isStoryNode = true,
      key = "110202000003",
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
            startQuest = "110202010001",
            startPort = "QuestStart",
            endQuest = "110202010003",
            endPort = "In"
          },
          {
            startQuest = "110202010003",
            startPort = "Out",
            endQuest = "110202010004",
            endPort = "In"
          },
          {
            startQuest = "110202010001",
            startPort = "QuestStart",
            endQuest = "110202010005",
            endPort = "In"
          },
          {
            startQuest = "110202010005",
            startPort = "Out",
            endQuest = "110202010007",
            endPort = "In"
          },
          {
            startQuest = "110202010007",
            startPort = "Out",
            endQuest = "17835268661291102165",
            endPort = "In"
          },
          {
            startQuest = "17835268661291102165",
            startPort = "Out",
            endQuest = "110202010008",
            endPort = "In"
          },
          {
            startQuest = "110202010008",
            startPort = "Out",
            endQuest = "110202010002",
            endPort = "Success"
          }
        },
        nodeData = {
          ["110202010001"] = {
            key = "110202010001",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 600, y = 500},
            propsData = {ModeType = 0}
          },
          ["110202010002"] = {
            key = "110202010002",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2400, y = 700},
            propsData = {ModeType = 0}
          },
          ["110202010003"] = {
            key = "110202010003",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 900, y = 320},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["110202010004"] = {
            key = "110202010004",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1250, y = 320},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["110202010005"] = {
            key = "110202010005",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 900, y = 650},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 107001,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["110202010007"] = {
            key = "110202010007",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1200, y = 650},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/mute",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {107001}
            }
          },
          ["17835268661291102165"] = {
            key = "17835268661291102165",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1520, y = 650},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0105/Ver0105_SC020/SQ_Ver0105_SC020",
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
              HideNpcs = true,
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
          ["110202010008"] = {
            key = "110202010008",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 1840, y = 650},
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
