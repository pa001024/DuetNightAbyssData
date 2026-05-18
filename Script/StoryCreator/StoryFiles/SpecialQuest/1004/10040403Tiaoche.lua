return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17787396282518766011",
      startPort = "StoryStart",
      endStory = "17787396290488766039",
      endPort = "In"
    },
    {
      startStory = "17787396290488766039",
      startPort = "Success",
      endStory = "17787396282518766014",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17787396282518766011"] = {
      isStoryNode = true,
      key = "17787396282518766011",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1314, y = 302},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17787396282518766014"] = {
      isStoryNode = true,
      key = "17787396282518766014",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2042, y = 272},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17787396290488766039"] = {
      isStoryNode = true,
      key = "17787396290488766039",
      type = "StoryNode",
      name = "开始行动",
      pos = {x = 1686, y = 266.00000000000006},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040403_01",
        QuestDeatil = "",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = false,
        bIsNotifyGameMode = true,
        bIsStartChapter = false,
        bIsEndChapter = false,
        bIsPlayBlackScreenOnComplete = true,
        bIsPlayBlackScreenOnFail = false,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        IsBacktrack = false,
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17787396290498766047",
            startPort = "Out",
            endQuest = "17787396290498766052",
            endPort = "In"
          },
          {
            startQuest = "17787396290498766049",
            startPort = "Out",
            endQuest = "17787396290498766051",
            endPort = "In"
          },
          {
            startQuest = "17787396290498766048",
            startPort = "Out",
            endQuest = "17787396290498766054",
            endPort = "In"
          },
          {
            startQuest = "17787396290498766048",
            startPort = "Out",
            endQuest = "17787396290498766049",
            endPort = "In"
          },
          {
            startQuest = "17787396290498766051",
            startPort = "Out",
            endQuest = "17787396290498766050",
            endPort = "In"
          },
          {
            startQuest = "17787396290498766049",
            startPort = "Out",
            endQuest = "17787396290498766056",
            endPort = "In"
          },
          {
            startQuest = "17787396290498766047",
            startPort = "Out",
            endQuest = "17787396290498766053",
            endPort = "In"
          },
          {
            startQuest = "17787396290498766053",
            startPort = "Out",
            endQuest = "17787396290498766048",
            endPort = "In"
          },
          {
            startQuest = "17787396290498766044",
            startPort = "QuestStart",
            endQuest = "17787396290498766058",
            endPort = "In"
          },
          {
            startQuest = "17787396290498766058",
            startPort = "Out",
            endQuest = "17787396290498766059",
            endPort = "In"
          },
          {
            startQuest = "17787396290498766044",
            startPort = "QuestStart",
            endQuest = "17787396290498766057",
            endPort = "In"
          },
          {
            startQuest = "17787396290498766057",
            startPort = "Out",
            endQuest = "17787396290498766047",
            endPort = "In"
          },
          {
            startQuest = "17787396290498766044",
            startPort = "QuestStart",
            endQuest = "17787396290508766060",
            endPort = "In"
          },
          {
            startQuest = "17787396290498766057",
            startPort = "Out",
            endQuest = "17787396290508766062",
            endPort = "In"
          },
          {
            startQuest = "17787396290498766050",
            startPort = "Out",
            endQuest = "17787398497178767690",
            endPort = "In"
          },
          {
            startQuest = "17787396290498766044",
            startPort = "QuestStart",
            endQuest = "17787398595318767994",
            endPort = "In"
          },
          {
            startQuest = "17787398595318767994",
            startPort = "Out",
            endQuest = "17787396290498766046",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17787396290498766044"] = {
            key = "17787396290498766044",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 302.6315789473684, y = 360},
            propsData = {ModeType = 0}
          },
          ["17787396290498766045"] = {
            key = "17787396290498766045",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3617.7825441346313, y = 640.4924643439844},
            propsData = {ModeType = 0}
          },
          ["17787396290498766046"] = {
            key = "17787396290498766046",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1363, y = 836},
            propsData = {}
          },
          ["17787396290498766047"] = {
            key = "17787396290498766047",
            type = "GoToNode",
            name = "前往车尾",
            pos = {x = 1193.0454545454545, y = 298.45454545454544},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272640029,
              GuideType = "M",
              GuidePointName = "Mechanism_OpenDoor_272640029"
            }
          },
          ["17787396290498766048"] = {
            key = "17787396290498766048",
            type = "TalkNode",
            name = "过场-爬上列车",
            pos = {x = 1899.3988473444117, y = 535.9896670066727},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC012/SQ_Ver0104_SC012",
              BlendInTime = 0,
              BlendOutTime = 2,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "BP_PaokuStart",
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
          ["17787396290498766049"] = {
            key = "17787396290498766049",
            type = "SendMessageNode",
            name = "开始跳车",
            pos = {x = 2336.293963913179, y = 564.3937638010569},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "FirstJumpStart",
              UnitId = -1
            }
          },
          ["17787396290498766050"] = {
            key = "17787396290498766050",
            type = "TalkNode",
            name = "过场-跳车",
            pos = {x = 3039.389102702276, y = 563.7996768661125},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC112/SQ_Ver0104_SC112",
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
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
          ["17787396290498766051"] = {
            key = "17787396290498766051",
            type = "BossBattleFinishNode",
            name = "跳车完成",
            pos = {x = 2731.416066125345, y = 589.2278904905602},
            propsData = {
              SendMessage = "",
              FinishCondition = "FirstJumpSuccess"
            }
          },
          ["17787396290498766052"] = {
            key = "17787396290498766052",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1479.3923981191226, y = 163.32733990147784},
            propsData = {
              NewDescription = "Content_10040403_02",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["17787396290498766053"] = {
            key = "17787396290498766053",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 1549.522174140203, y = 536.9301066998968},
            propsData = {
              StaticCreatorId = 272640025,
              UnitId = 10073,
              bGuideUIEnable = true,
              GuidePointName = "BP_OpenDoorTrain",
              LongPressTime = 0,
              MontageName = "",
              bFocusEnable = false,
              SequencePath = ""
            }
          },
          ["17787396290498766054"] = {
            key = "17787396290498766054",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 2270.4435208097457, y = 167.0304445616181},
            propsData = {
              NewDescription = "Content_10040403_03",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["17787396290498766056"] = {
            key = "17787396290498766056",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2768.6457917741754, y = 221.69152603517253},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 172640031,
              GuideType = "M",
              GuidePointName = "Mechanism_triggerbox_172640031"
            }
          },
          ["17787396290498766057"] = {
            key = "17787396290498766057",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 855.3941871724764, y = 325.06688193838846},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_Tiaoche01Start",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17787396290498766058"] = {
            key = "17787396290498766058",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 857.2440191387558, y = 29.779904306220086},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "OpenGate02Behind",
              UnitId = -1
            }
          },
          ["17787396290498766059"] = {
            key = "17787396290498766059",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1182.1961722488038, y = 20.593301435406698},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "OpenGate01Front",
              UnitId = -1
            }
          },
          ["17787396290508766060"] = {
            key = "17787396290508766060",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 882.5958579604095, y = 592.0574162679426},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["17787396290508766062"] = {
            key = "17787396290508766062",
            type = "AtmosphereNpcHideNode",
            name = "氛围NPC显示/隐藏节点",
            pos = {x = 1241.621384619316, y = 618.4057261704593},
            propsData = {
              IsHide = true,
              AtmosphereTagList = {"Story_HXQ"}
            }
          },
          ["17787398497178767690"] = {
            key = "17787398497178767690",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 3407.995215311005, y = 597.7987012987014},
            propsData = {}
          },
          ["17787398595318767994"] = {
            key = "17787398595318767994",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 973.1706539074962, y = 832.7460697197541},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
