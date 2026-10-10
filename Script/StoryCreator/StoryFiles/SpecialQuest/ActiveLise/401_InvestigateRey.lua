return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17870348898998960557",
      startPort = "StoryStart",
      endStory = "17870348927358960696",
      endPort = "In"
    },
    {
      startStory = "17870348927358960696",
      startPort = "Success",
      endStory = "17870348898998960560",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17870348898998960557"] = {
      isStoryNode = true,
      key = "17870348898998960557",
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
    ["17870348898998960560"] = {
      isStoryNode = true,
      key = "17870348898998960560",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1574, y = 296},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17870348927358960696"] = {
      isStoryNode = true,
      key = "17870348927358960696",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1188, y = 286.00000000000006},
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
            startQuest = "17870348927358960701",
            startPort = "QuestStart",
            endQuest = "17873671292101139",
            endPort = "In"
          },
          {
            startQuest = "17870348927358960701",
            startPort = "QuestStart",
            endQuest = "1787366279795489",
            endPort = "In"
          },
          {
            startQuest = "1787366279795489",
            startPort = "Out",
            endQuest = "17873672142452135",
            endPort = "In"
          },
          {
            startQuest = "17873672142452135",
            startPort = "Out",
            endQuest = "17885783934881158052",
            endPort = "In"
          },
          {
            startQuest = "17885783934881158052",
            startPort = "Out",
            endQuest = "17884182006116790043",
            endPort = "In"
          },
          {
            startQuest = "17884182006116790043",
            startPort = "Out",
            endQuest = "17873874950263394682",
            endPort = "In"
          },
          {
            startQuest = "17873671292101139",
            startPort = "Out",
            endQuest = "17870348927358960703",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17870348927358960701"] = {
            key = "17870348927358960701",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1080.5, y = 278.3076923076923},
            propsData = {ModeType = 0}
          },
          ["17870348927358960702"] = {
            key = "17870348927358960702",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2546.8786967418546, y = 457.9652207441681},
            propsData = {ModeType = 0}
          },
          ["17870348927358960703"] = {
            key = "17870348927358960703",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1672.2199803459616, y = 486.7491018550195},
            propsData = {}
          },
          ["1787366279795489"] = {
            key = "1787366279795489",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1379.3917147760965, y = 279.20018723669835},
            propsData = {QuestRoleId = 41030101, IsPlayFX = false}
          },
          ["17873671292101139"] = {
            key = "17873671292101139",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1377.9523326572007, y = 475.63020752067405},
            propsData = {}
          },
          ["17873672142452135"] = {
            key = "17873672142452135",
            type = "TalkNode",
            name = "向卡米拉打听蕾伊",
            pos = {x = 1653.0590705778334, y = 277.99481198314845},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 200003,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Kamila120704_351220221",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070424,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120704/12070401.12070401'",
              TalkType = "FixSimpleNew",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17873874950263394682"] = {
            key = "17873874950263394682",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2533.312186821569, y = 277.2121641897384},
            propsData = {}
          },
          ["17884182006116790043"] = {
            key = "17884182006116790043",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 2240.8534082241176, y = 272.87975868525064},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_OutBar_1207",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17885783934881158052"] = {
            key = "17885783934881158052",
            type = "GoToNode",
            name = "前往酒馆门口",
            pos = {x = 1952.695652173913, y = 274.52173913043475},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351220222,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351220222"
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
