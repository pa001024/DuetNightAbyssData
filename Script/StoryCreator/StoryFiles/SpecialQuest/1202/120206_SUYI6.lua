return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1772421504262707508",
      startPort = "StoryStart",
      endStory = "1772421504262707510",
      endPort = "In"
    },
    {
      startStory = "1772421504262707510",
      startPort = "Success",
      endStory = "1772421504262707509",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1772421504262707508"] = {
      isStoryNode = true,
      key = "1772421504262707508",
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
    ["1772421504262707509"] = {
      isStoryNode = true,
      key = "1772421504262707509",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2800, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1772421504262707510"] = {
      isStoryNode = true,
      key = "1772421504262707510",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1372, y = 352},
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
            startQuest = "17724338985675546978",
            startPort = "Out",
            endQuest = "17724338985675546977",
            endPort = "In"
          },
          {
            startQuest = "1772421504262707511",
            startPort = "QuestStart",
            endQuest = "1772421504262707516",
            endPort = "In"
          },
          {
            startQuest = "1772421504262707516",
            startPort = "Out",
            endQuest = "17724338985675546978",
            endPort = "In"
          },
          {
            startQuest = "1772421504262707511",
            startPort = "QuestStart",
            endQuest = "17724339183595547575",
            endPort = "In"
          },
          {
            startQuest = "17748545743218947837",
            startPort = "Out",
            endQuest = "17748545743218947838",
            endPort = "Input_1"
          },
          {
            startQuest = "17724339183595547575",
            startPort = "Out",
            endQuest = "17748545743218947837",
            endPort = "In"
          },
          {
            startQuest = "17724339183595547575",
            startPort = "Out",
            endQuest = "17748545743218947836",
            endPort = "In"
          },
          {
            startQuest = "17748545743218947838",
            startPort = "Out",
            endQuest = "1772421504262707513",
            endPort = "Fail"
          },
          {
            startQuest = "1772421504262707511",
            startPort = "QuestStart",
            endQuest = "17748546553368948472",
            endPort = "In"
          },
          {
            startQuest = "1772421504262707511",
            startPort = "QuestStart",
            endQuest = "17748546553368948471",
            endPort = "In"
          },
          {
            startQuest = "1772421504262707511",
            startPort = "QuestStart",
            endQuest = "17748603404054694486",
            endPort = "In"
          },
          {
            startQuest = "17748545743218947836",
            startPort = "Out",
            endQuest = "17748603451504694705",
            endPort = "In"
          },
          {
            startQuest = "17748603451504694705",
            startPort = "Out",
            endQuest = "17748545743218947838",
            endPort = "Input_2"
          },
          {
            startQuest = "17724338985675546977",
            startPort = "Out",
            endQuest = "17748603505664694944",
            endPort = "In"
          },
          {
            startQuest = "17748603505664694944",
            startPort = "Out",
            endQuest = "17724339133915547433",
            endPort = "In"
          }
        },
        nodeData = {
          ["1772421504262707511"] = {
            key = "1772421504262707511",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1772421504262707512"] = {
            key = "1772421504262707512",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1772421504262707513"] = {
            key = "1772421504262707513",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2273.6760461760464, y = 645.1659451659451},
            propsData = {}
          },
          ["1772421504262707516"] = {
            key = "1772421504262707516",
            type = "ChangeRoleNode",
            name = "切换苏乙",
            pos = {x = 1139.2599333598187, y = 287.4808786096661},
            propsData = {QuestRoleId = 15040101, IsPlayFX = false}
          },
          ["17724338985675546977"] = {
            key = "17724338985675546977",
            type = "TalkNode",
            name = "与朱朴对话",
            pos = {x = 1799.678442715039, y = 282.96345856210803},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 240034,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_12020608zhupu_242410149",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1202/12047301.12047301'",
              TalkType = "FixSimple",
              TalkStageName = "East02_12020608",
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
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
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
          ["17724338985675546978"] = {
            key = "17724338985675546978",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1454.3658659175048, y = 287.2229432713526},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {242410149}
            }
          },
          ["17724339133915547433"] = {
            key = "17724339133915547433",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2383.6489686783807, y = 280.664629488159},
            propsData = {}
          },
          ["17724339183595547575"] = {
            key = "17724339183595547575",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1141.7203972498091, y = 585.0932009167304},
            propsData = {}
          },
          ["17748545743218947836"] = {
            key = "17748545743218947836",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1426.3958997524212, y = 740.9665557482313},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "JuezhanLightEnd",
              UnitId = -1
            }
          },
          ["17748545743218947837"] = {
            key = "17748545743218947837",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1427.9105597472046, y = 582.8077699260944},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "LigntningEnd",
              UnitId = -1
            }
          },
          ["17748545743218947838"] = {
            key = "17748545743218947838",
            type = "WaitQuestFinishedNode",
            name = "等待任务完成",
            pos = {x = 1879.7018358453147, y = 645.2221419494697},
            propsData = {ListenCount = 2, NeedFinishCount = 2}
          },
          ["17748546553368948471"] = {
            key = "17748546553368948471",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1079.5201213002688, y = -83.84855144855146},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "JuezhanLight",
              UnitId = -1
            }
          },
          ["17748546553368948472"] = {
            key = "17748546553368948472",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1153.4823762022295, y = 70.30144855144853},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "LigntningStart",
              UnitId = -1
            }
          },
          ["17748603404054694486"] = {
            key = "17748603404054694486",
            type = "SetGlobalSoundParamNode",
            name = "设置全局音效参数",
            pos = {x = 1055.2811942958997, y = -280.0621657754011},
            propsData = {
              ParamName = "story_1_3_final_disaste",
              ParamValue = 1
            }
          },
          ["17748603451504694705"] = {
            key = "17748603451504694705",
            type = "SetGlobalSoundParamNode",
            name = "设置全局音效参数",
            pos = {x = 1665.33567218516, y = 876.4820320557534},
            propsData = {
              ParamName = "parameter:/story/story_1_3_final_disaste",
              ParamValue = 0
            }
          },
          ["17748603505664694944"] = {
            key = "17748603505664694944",
            type = "SetGlobalSoundParamNode",
            name = "设置全局音效参数",
            pos = {x = 2083.6869266654467, y = 314.1164406579038},
            propsData = {
              ParamName = "story_1_3_final_disaste",
              ParamValue = 0
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
