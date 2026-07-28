return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178005305056717245540",
      startPort = "StoryStart",
      endStory = "178005305056717245542",
      endPort = "In"
    },
    {
      startStory = "178005305056717245542",
      startPort = "Success",
      endStory = "178005305056717245541",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178005305056717245540"] = {
      isStoryNode = true,
      key = "178005305056717245540",
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
    ["178005305056717245541"] = {
      isStoryNode = true,
      key = "178005305056717245541",
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
    ["178005305056717245542"] = {
      isStoryNode = true,
      key = "178005305056717245542",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1266, y = 268},
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
            startQuest = "178005305056717245546",
            startPort = "Out",
            endQuest = "178005305056717245548",
            endPort = "In"
          },
          {
            startQuest = "178005305056717245543",
            startPort = "QuestStart",
            endQuest = "178005305056717245546",
            endPort = "In"
          },
          {
            startQuest = "178005305056717245543",
            startPort = "QuestStart",
            endQuest = "178005305056717245547",
            endPort = "In"
          },
          {
            startQuest = "178005303584216735549",
            startPort = "Out",
            endQuest = "178056399523015082691",
            endPort = "In"
          },
          {
            startQuest = "178056399523015082691",
            startPort = "Out",
            endQuest = "178005305056717245544",
            endPort = "Success"
          },
          {
            startQuest = "178005305056717245547",
            startPort = "Out",
            endQuest = "178005303584216735549",
            endPort = "In"
          }
        },
        nodeData = {
          ["178005303584216735549"] = {
            key = "178005303584216735549",
            type = "TalkNode",
            name = "过场-100194-神秘人",
            pos = {x = 1606.7647058823532, y = 573.830882352941},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC019/SQ_OBT0100_SC019",
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
          ["178005305056717245543"] = {
            key = "178005305056717245543",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178005305056717245544"] = {
            key = "178005305056717245544",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2252.821283979178, y = 566.5720069404281},
            propsData = {ModeType = 0}
          },
          ["178005305056717245545"] = {
            key = "178005305056717245545",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178005305056717245546"] = {
            key = "178005305056717245546",
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
          ["178005305056717245547"] = {
            key = "178005305056717245547",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101107,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178005305056717245548"] = {
            key = "178005305056717245548",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 101107,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178056399523015082691"] = {
            key = "178056399523015082691",
            type = "PlayOrStopBGMNode",
            name = "播放或暂停或关闭声音",
            pos = {x = 1921.3684210526317, y = 561.7894736842105},
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
