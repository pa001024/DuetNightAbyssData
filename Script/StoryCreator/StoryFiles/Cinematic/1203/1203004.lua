return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178116180100410705102",
      startPort = "Success",
      endStory = "178116180100410705101",
      endPort = "StoryEnd"
    },
    {
      startStory = "178116180100410705100",
      startPort = "StoryStart",
      endStory = "178116180100410705102",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["178116180100410705100"] = {
      isStoryNode = true,
      key = "178116180100410705100",
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
    ["178116180100410705101"] = {
      isStoryNode = true,
      key = "178116180100410705101",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1604, y = 302},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178116180100410705102"] = {
      isStoryNode = true,
      key = "178116180100410705102",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1201.4782608695652, y = 292.69565217391306},
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
            startQuest = "178116180100410705109",
            startPort = "Out",
            endQuest = "178116180100410705104",
            endPort = "Success"
          },
          {
            startQuest = "17811611084667124436",
            startPort = "Out",
            endQuest = "178116180100410705109",
            endPort = "In"
          },
          {
            startQuest = "178116180100410705103",
            startPort = "QuestStart",
            endQuest = "17811611084667124436",
            endPort = "In"
          },
          {
            startQuest = "178116180100410705103",
            startPort = "QuestStart",
            endQuest = "17811611084667124437",
            endPort = "In"
          },
          {
            startQuest = "17811611084667124437",
            startPort = "Out",
            endQuest = "17821109146576934670",
            endPort = "In"
          },
          {
            startQuest = "17821109146576934670",
            startPort = "Out",
            endQuest = "17821108934986934472",
            endPort = "In"
          }
        },
        nodeData = {
          ["17811611084667124436"] = {
            key = "17811611084667124436",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1326.9645151321959, y = 409.44856082973445},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0103/Ver0103_SC003/SQ_Ver0103_SC003_Cinematic",
              BlendInTime = 0,
              InType = "FadeIn",
              OutType = "BlendOut",
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
          ["17811611084667124437"] = {
            key = "17811611084667124437",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1324.9293658684805, y = 630.2868606115694},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/mute",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {210101}
            }
          },
          ["178116180100410705103"] = {
            key = "178116180100410705103",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1000.4545454545455, y = 406.3636363636364},
            propsData = {ModeType = 0}
          },
          ["178116180100410705104"] = {
            key = "178116180100410705104",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1879.0194805194806, y = 407.76623376623377},
            propsData = {ModeType = 0}
          },
          ["178116180100410705105"] = {
            key = "178116180100410705105",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["178116180100410705109"] = {
            key = "178116180100410705109",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1600.4018915866743, y = 406.9284005468216},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17821108934986934472"] = {
            key = "17821108934986934472",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1890.0862068965516, y = 645.1333333333334},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/1_1/0135_login_theme",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {210101}
            }
          },
          ["17821109146576934670"] = {
            key = "17821109146576934670",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1624.6433497536943, y = 612.8310344827586},
            propsData = {WaitTime = 9}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
