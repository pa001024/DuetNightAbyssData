return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17752924885471",
      startPort = "StoryStart",
      endStory = "1775292542510207",
      endPort = "In"
    },
    {
      startStory = "1775292542510207",
      startPort = "Success",
      endStory = "1775292593008782",
      endPort = "In"
    },
    {
      startStory = "1775292593008782",
      startPort = "Success",
      endStory = "17752926222601296",
      endPort = "In"
    },
    {
      startStory = "17752927299802316",
      startPort = "Success",
      endStory = "17752924885475",
      endPort = "StoryEnd"
    },
    {
      startStory = "17753777728481327766",
      startPort = "Success",
      endStory = "17752927299802316",
      endPort = "In"
    },
    {
      startStory = "17752926457461586",
      startPort = "Success",
      endStory = "17753777728481327766",
      endPort = "In"
    },
    {
      startStory = "17752926222601296",
      startPort = "Success",
      endStory = "17755506832576636746",
      endPort = "In"
    },
    {
      startStory = "17755506832576636746",
      startPort = "Success",
      endStory = "17752926457461586",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17752924885471"] = {
      isStoryNode = true,
      key = "17752924885471",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 200403},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17752924885475"] = {
      isStoryNode = true,
      key = "17752924885475",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2104, y = 676},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1775292542510207"] = {
      isStoryNode = true,
      key = "1775292542510207",
      type = "PreStoryNode",
      name = "任务前置节点",
      pos = {x = 1244, y = 295.5609756702708},
      propsData = {
        QuestId = 20040300,
        QuestDescriptionComment = "站台旁看见尸体",
        SubRegionId = 106001,
        StoryGuideType = "Npc",
        StoryGuidePointName = "",
        bIsPlayBlackScreenOnComplete = true,
        SubRegionIdList = {}
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1775292542510208",
            startPort = "QuestStart",
            endQuest = "17753787719545297704",
            endPort = "In"
          },
          {
            startQuest = "17753787719545297704",
            startPort = "Out",
            endQuest = "17753787820075297839",
            endPort = "In"
          },
          {
            startQuest = "17753787820075297839",
            startPort = "Out",
            endQuest = "17753787900495297986",
            endPort = "In"
          },
          {
            startQuest = "17753787900495297986",
            startPort = "Out",
            endQuest = "17755476934582655671",
            endPort = "In"
          },
          {
            startQuest = "17755476934582655671",
            startPort = "Out",
            endQuest = "177555419366314603047",
            endPort = "In"
          },
          {
            startQuest = "177555419366314603047",
            startPort = "Out",
            endQuest = "1775292542510216",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1775292542510208"] = {
            key = "1775292542510208",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1775292542510216"] = {
            key = "1775292542510216",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1775292542511236"] = {
            key = "1775292542511236",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17753787719545297704"] = {
            key = "17753787719545297704",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1202, y = 306},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "Npc_Box_312480060",
              StaticCreatorIdList = {312480060}
            }
          },
          ["17753787820075297839"] = {
            key = "17753787820075297839",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1550, y = 270.32558133345543},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 312480057,
              GuideType = "M",
              GuidePointName = ""
            }
          },
          ["17753787900495297986"] = {
            key = "17753787900495297986",
            type = "TalkNode",
            name = "前置对话",
            pos = {x = 1895.4747065442532, y = 291.135135492734},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200403/20040301.20040301'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = true,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = false,
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
          ["17755476934582655671"] = {
            key = "17755476934582655671",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2178.289966848365, y = 275.035683263586},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312480060}
            }
          },
          ["177555419366314603047"] = {
            key = "177555419366314603047",
            type = "TalkNode",
            name = "老奶出现",
            pos = {x = 2506.731647748454, y = 298.14499167494415},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200403/20040302.20040302'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = true,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = false,
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
          }
        },
        commentData = {}
      }
    },
    ["1775292593008782"] = {
      isStoryNode = true,
      key = "1775292593008782",
      type = "StoryNode",
      name = "货运区商量处理尸体",
      pos = {x = 1574.8352489956292, y = 316.86918449107714},
      propsData = {
        QuestId = 20040301,
        QuestDescriptionComment = "货运区商量处理尸体",
        QuestDescription = "Description_200403_1",
        QuestDeatil = "Content_200403_1",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = true,
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Laofuren_312480061",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17753789192116622620",
            startPort = "Out",
            endQuest = "1775292593008786",
            endPort = "Success"
          },
          {
            startQuest = "1775292593008783",
            startPort = "QuestStart",
            endQuest = "177555859506018587143",
            endPort = "In"
          },
          {
            startQuest = "177555859506018587143",
            startPort = "Out",
            endQuest = "17753788582846621556",
            endPort = "In"
          },
          {
            startQuest = "17753788582846621556",
            startPort = "Out",
            endQuest = "177556132243122570065",
            endPort = "In"
          },
          {
            startQuest = "177556132243122570065",
            startPort = "Out",
            endQuest = "17753789192116622620",
            endPort = "Input"
          }
        },
        nodeData = {
          ["1775292593008783"] = {
            key = "1775292593008783",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1775292593008786"] = {
            key = "1775292593008786",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1775292593008789"] = {
            key = "1775292593008789",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17753788582846621556"] = {
            key = "17753788582846621556",
            type = "TalkNode",
            name = "询问老奶",
            pos = {x = 1765.9944098453304, y = 315.89748324474965},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700410,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Laofuren_312480061",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200403/20040303.20040303'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = true,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = false,
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
          ["17753789192116622620"] = {
            key = "17753789192116622620",
            type = "UnlockDetectiveQuestionNode",
            name = "开启推理问题",
            pos = {x = 2422.9767409366423, y = 328.5581398959286},
            propsData = {
              QuestionIds = {2005},
              OpenToast = true
            }
          },
          ["177555859506018587143"] = {
            key = "177555859506018587143",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1283.1199624875314, y = 381.56453974373534},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "Npc_Laofuren_312480061",
              StaticCreatorIdList = {312480061}
            }
          },
          ["177556132243122570065"] = {
            key = "177556132243122570065",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2085.886605720921, y = 341.909372504919},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "Npc_Laofuren_312530100",
              StaticCreatorIdList = {312480061}
            }
          }
        },
        commentData = {}
      }
    },
    ["17752926222601296"] = {
      isStoryNode = true,
      key = "17752926222601296",
      type = "StoryNode",
      name = "去医务室尸检",
      pos = {x = 1912, y = 312.93617024442557},
      propsData = {
        QuestId = 20040302,
        QuestDescriptionComment = "去医务室尸检",
        QuestDescription = "Description_200403_2",
        QuestDeatil = "Content_200403_2",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_GotoYWS",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17753788810506622093",
            startPort = "Out",
            endQuest = "177537944634610598713",
            endPort = "In"
          },
          {
            startQuest = "177537944634610598713",
            startPort = "Out",
            endQuest = "177537943619910598294",
            endPort = "In"
          },
          {
            startQuest = "177537943619910598294",
            startPort = "Out",
            endQuest = "17753789376446623047",
            endPort = "Input"
          },
          {
            startQuest = "17752926222601301",
            startPort = "QuestStart",
            endQuest = "177556001595122569001",
            endPort = "In"
          },
          {
            startQuest = "17753789376446623047",
            startPort = "Out",
            endQuest = "17752926222601302",
            endPort = "Success"
          },
          {
            startQuest = "177556001595122569001",
            startPort = "Out",
            endQuest = "17792011482141452553",
            endPort = "In"
          },
          {
            startQuest = "17792021937692909174",
            startPort = "Out",
            endQuest = "17792021937692909175",
            endPort = "In"
          },
          {
            startQuest = "17792021937702909177",
            startPort = "Out",
            endQuest = "17792021937692909174",
            endPort = "In"
          },
          {
            startQuest = "17792021937692909175",
            startPort = "Out",
            endQuest = "17792021937702909176",
            endPort = "Input"
          },
          {
            startQuest = "17792011482141452553",
            startPort = "Out",
            endQuest = "17792021937702909177",
            endPort = "In"
          },
          {
            startQuest = "17792021937702909178",
            startPort = "Out",
            endQuest = "17792011482141452553",
            endPort = "In"
          },
          {
            startQuest = "177556001595122569001",
            startPort = "Out",
            endQuest = "17753788810506622093",
            endPort = "In"
          },
          {
            startQuest = "17792021937702909176",
            startPort = "BeginOverlap",
            endQuest = "17792806933744347706",
            endPort = "Input"
          },
          {
            startQuest = "17792021937702909176",
            startPort = "EndOverlap",
            endQuest = "17792021937702909178",
            endPort = "In"
          }
        },
        nodeData = {
          ["17752926222601301"] = {
            key = "17752926222601301",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 109.50917550632786, y = 353.9487169941181},
            propsData = {ModeType = 0}
          },
          ["17752926222601302"] = {
            key = "17752926222601302",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17752926222601303"] = {
            key = "17752926222601303",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17753788810506622093"] = {
            key = "17753788810506622093",
            type = "TalkNode",
            name = "医生对话",
            pos = {x = 1275.963366721548, y = 381.9577173255732},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700411,
              GuideUIEnable = false,
              GuideType = "N",
              GuidePointName = "Npc_Yisheng_312480058",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200403/20040304.20040304'",
              TalkType = "FixSimple",
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
              HideAllBattleEntity = true,
              HideMechanismsFX = false,
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
          ["17753789376446623047"] = {
            key = "17753789376446623047",
            type = "UnlockDetectiveAnswerNode",
            name = "开启推理线索",
            pos = {x = 2158.19354747411, y = 411.29032305698615},
            propsData = {
              AnswerIds = {200501, 200502}
            }
          },
          ["177537943619910598294"] = {
            key = "177537943619910598294",
            type = "TalkNode",
            name = "医生对话",
            pos = {x = 1861.614619463058, y = 420.2857102157382},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200403/20040306.20040306'",
              TalkType = "FixSimple",
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
              HideAllBattleEntity = true,
              HideMechanismsFX = false,
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
          ["177537944634610598713"] = {
            key = "177537944634610598713",
            type = "TalkNode",
            name = "黑屏",
            pos = {x = 1614.8372173808893, y = 398.1926875479117},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200403/20040305.20040305'",
              TalkType = "Black",
              BlendInTime = 0,
              BlendOutTime = 0,
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              ForceAutoPlay = false,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["177556001595122569001"] = {
            key = "177556001595122569001",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 368.421496904439, y = 357.3835128130725},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "Npc_Yisheng_312480058",
              StaticCreatorIdList = {312480058}
            }
          },
          ["17792011482141452553"] = {
            key = "17792011482141452553",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 660.0433113722141, y = 122.36363848391326},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_GotoYWS"
            }
          },
          ["17792021937692909174"] = {
            key = "17792021937692909174",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 983.6049990379536, y = -391.2142778751447},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_GotoYWS"
            }
          },
          ["17792021937692909175"] = {
            key = "17792021937692909175",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1368.5677858901217, y = -359.11357578797265},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "N",
              GuideName = "Npc_Yisheng_312480058"
            }
          },
          ["17792021937702909176"] = {
            key = "17792021937702909176",
            type = "CollisionBoxNode",
            name = "进入/离开判定盒节点",
            pos = {x = 1734.7855746287523, y = -318.79478810058094},
            propsData = {StaticCreatorId = 312480416}
          },
          ["17792021937702909177"] = {
            key = "17792021937702909177",
            type = "GoToNode",
            name = "前往",
            pos = {x = 662.2049438966235, y = -365.5689792275682},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 312480415,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["17792021937702909178"] = {
            key = "17792021937702909178",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2106.3523904333965, y = -215.0427959399354},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "N",
              GuideName = "Npc_Yisheng_312480058"
            }
          },
          ["17792806933744347706"] = {
            key = "17792806933744347706",
            type = "TestPrintNode",
            name = "测试打印",
            pos = {x = 2151.121694436225, y = -421.3271739209589},
            propsData = {Text = "In"}
          }
        },
        commentData = {}
      }
    },
    ["17752926457461586"] = {
      isStoryNode = true,
      key = "17752926457461586",
      type = "StoryNode",
      name = "工厂打听信息",
      pos = {x = 2478.0100906548346, y = 361.32260034642593},
      propsData = {
        QuestId = 20040304,
        QuestDescriptionComment = "打听信息",
        QuestDescription = "Description_200403_4",
        QuestDeatil = "Content_200403_4",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "QuestSign_20040304",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17753790683059270277",
            startPort = "Out",
            endQuest = "17753790818169270514",
            endPort = "In"
          },
          {
            startQuest = "17753790683059270277",
            startPort = "Out",
            endQuest = "177537916702710594659",
            endPort = "In"
          },
          {
            startQuest = "17752926457461591",
            startPort = "QuestStart",
            endQuest = "177537928860410595759",
            endPort = "In"
          },
          {
            startQuest = "17753790818169270514",
            startPort = "Out",
            endQuest = "177537931918810596274",
            endPort = "Input"
          },
          {
            startQuest = "177537916702710594659",
            startPort = "Out",
            endQuest = "177537933658210596702",
            endPort = "Input"
          },
          {
            startQuest = "177537928860410595759",
            startPort = "Out",
            endQuest = "17753790683059270277",
            endPort = "In"
          },
          {
            startQuest = "177537940023710597619",
            startPort = "Out",
            endQuest = "17752926457461592",
            endPort = "Success"
          },
          {
            startQuest = "177537934463710596921",
            startPort = "Out",
            endQuest = "177537940023710597619",
            endPort = "In"
          },
          {
            startQuest = "177537931918810596274",
            startPort = "Out",
            endQuest = "177537934463710596921",
            endPort = "Branch_1"
          },
          {
            startQuest = "177537933658210596702",
            startPort = "Out",
            endQuest = "177537934463710596921",
            endPort = "Branch_2"
          }
        },
        nodeData = {
          ["17752926457461591"] = {
            key = "17752926457461591",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 708, y = 242},
            propsData = {ModeType = 0}
          },
          ["17752926457461592"] = {
            key = "17752926457461592",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3828.571424237725, y = 348},
            propsData = {ModeType = 0}
          },
          ["17752926457461593"] = {
            key = "17752926457461593",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17753790683059270277"] = {
            key = "17753790683059270277",
            type = "BranchQuestStartNode",
            name = "子任务开始节点",
            pos = {x = 1560, y = 288},
            propsData = {
              AllQuestOptions = {
                {
                  IsNeedFinish = true,
                  BranchQuestName = "Description_200403_4_1",
                  TargetBranchQuestKey = ""
                },
                {
                  IsNeedFinish = true,
                  BranchQuestName = "Description_200403_4_2",
                  TargetBranchQuestKey = ""
                }
              },
              IsSetCountInfo = false,
              IsDifftation = true,
              AllDiffGuideOptions = {
                {
                  OptionElements = {
                    {
                      TargetIndicatorKey = "17753790818169270514",
                      IsShowOptional = false
                    }
                  }
                },
                {
                  OptionElements = {
                    {
                      TargetIndicatorKey = "177537916702710594659",
                      IsShowOptional = false
                    }
                  }
                }
              }
            }
          },
          ["17753790818169270514"] = {
            key = "17753790818169270514",
            type = "TalkNode",
            name = "认真工人对话",
            pos = {x = 1892, y = 40},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700412,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_RenzhenGongren_312480062",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200403/20040308.20040308'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = true,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = false,
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
          ["177537916702710594659"] = {
            key = "177537916702710594659",
            type = "TalkNode",
            name = "忧郁工人对话",
            pos = {x = 1892, y = 368},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700413,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_QiaocuiGongren_312480063",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200403/20040309.20040309'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = true,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = false,
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
          ["177537928860410595759"] = {
            key = "177537928860410595759",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1200.8571428052421, y = 304.8571386272405},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312480062, 312480063}
            }
          },
          ["177537931918810596274"] = {
            key = "177537931918810596274",
            type = "UnlockDetectiveAnswerNode",
            name = "开启推理线索",
            pos = {x = 2276, y = 74},
            propsData = {
              AnswerIds = {200503, 200504}
            }
          },
          ["177537933658210596702"] = {
            key = "177537933658210596702",
            type = "UnlockDetectiveAnswerNode",
            name = "开启推理线索",
            pos = {x = 2218.0344820479954, y = 405},
            propsData = {
              AnswerIds = {200505, 200506}
            }
          },
          ["177537934463710596921"] = {
            key = "177537934463710596921",
            type = "CheckBranchQuestFinishedNode",
            name = "子任务结束节点",
            pos = {x = 3004, y = 318},
            propsData = {
              InputBranchQuestNumber = 2,
              BranchQuestFinishOptions = {
                {IsNeedFinish = true},
                {IsNeedFinish = true}
              }
            }
          },
          ["177537940023710597619"] = {
            key = "177537940023710597619",
            type = "TalkNode",
            name = "开车",
            pos = {x = 3496.5714255092907, y = 334.5714300505968},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200403/20040310.20040310'",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17752927299802316"] = {
      isStoryNode = true,
      key = "17752927299802316",
      type = "StoryNode",
      name = "取货",
      pos = {x = 1460.8453823713412, y = 692.8320350185908},
      propsData = {
        QuestId = 20040306,
        QuestDescriptionComment = "取货",
        QuestDescription = "Description_200403_6",
        QuestDeatil = "Content_200403_6",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = true,
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Fuwuyuan_312480065",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17752927299812321",
            startPort = "QuestStart",
            endQuest = "177557034111139834622",
            endPort = "In"
          },
          {
            startQuest = "177557034111139834622",
            startPort = "Out",
            endQuest = "177537983649711924754",
            endPort = "In"
          },
          {
            startQuest = "177537983649711924754",
            startPort = "Out",
            endQuest = "177557036327039834986",
            endPort = "In"
          },
          {
            startQuest = "177557036327039834986",
            startPort = "Out",
            endQuest = "17752927299812322",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17752927299812321"] = {
            key = "17752927299812321",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17752927299812322"] = {
            key = "17752927299812322",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17752927299812323"] = {
            key = "17752927299812323",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["177537983649711924754"] = {
            key = "177537983649711924754",
            type = "TalkNode",
            name = "与工作人员对话",
            pos = {x = 1660, y = 362},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700414,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Fuwuyuan_312480065",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200403/20040312.20040312'",
              TalkType = "FixSimple",
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
              HideAllBattleEntity = true,
              HideMechanismsFX = false,
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
          ["177557034111139834622"] = {
            key = "177557034111139834622",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1228, y = 296},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "Npc_Fuwuyuan_312480065",
              StaticCreatorIdList = {312480065}
            }
          },
          ["177557036327039834986"] = {
            key = "177557036327039834986",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2148, y = 412},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "Npc_Fuwuyuan_312480065",
              StaticCreatorIdList = {312480065}
            }
          }
        },
        commentData = {}
      }
    },
    ["17753777728481327766"] = {
      isStoryNode = true,
      key = "17753777728481327766",
      type = "StoryNode",
      name = "完成推理",
      pos = {x = 1170.4034888165993, y = 686.3234437954932},
      propsData = {
        QuestId = 20040305,
        QuestDescriptionComment = "与奥特赛德对话",
        QuestDescription = "Description_200403_5",
        QuestDeatil = "Content_200403_5",
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
        SubRegionId = 106001,
        SubRegionIdList = {106301},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Aote_312480064",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177537970165511923509",
            startPort = "Out",
            endQuest = "177556827663838504963",
            endPort = "In"
          },
          {
            startQuest = "177556628149735849166",
            startPort = "Out",
            endQuest = "177556829255838505223",
            endPort = "In"
          },
          {
            startQuest = "177556829255838505223",
            startPort = "Out",
            endQuest = "177537970165511923509",
            endPort = "In"
          },
          {
            startQuest = "17753777728481327771",
            startPort = "QuestStart",
            endQuest = "17787456647634612",
            endPort = "In"
          },
          {
            startQuest = "177556826723038504690",
            startPort = "Out",
            endQuest = "177556628149735849166",
            endPort = "In"
          },
          {
            startQuest = "17787456647634612",
            startPort = "Region_1",
            endQuest = "177556826723038504690",
            endPort = "In"
          },
          {
            startQuest = "17787456647634612",
            startPort = "Region_2",
            endQuest = "17787457547096531",
            endPort = "In"
          },
          {
            startQuest = "17787457547096531",
            startPort = "Out",
            endQuest = "17787457847407096",
            endPort = "In"
          },
          {
            startQuest = "17787457847407096",
            startPort = "Out",
            endQuest = "17787457930147317",
            endPort = "In"
          },
          {
            startQuest = "17787457930147317",
            startPort = "Out",
            endQuest = "177537970165511923509",
            endPort = "In"
          },
          {
            startQuest = "177556827663838504963",
            startPort = "Out",
            endQuest = "17753777728481327772",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17753777728481327771"] = {
            key = "17753777728481327771",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17753777728481327772"] = {
            key = "17753777728481327772",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3042.857138445588, y = 442.85714026211076},
            propsData = {ModeType = 0}
          },
          ["17753777728481327773"] = {
            key = "17753777728481327773",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2959.999997093564, y = 791.4285697677509},
            propsData = {}
          },
          ["177537970165511923509"] = {
            key = "177537970165511923509",
            type = "TalkNode",
            name = "与奥特赛德对话",
            pos = {x = 2344.3386193280407, y = 241.56613285848587},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700409,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Aote_312480064",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200403/20040311.20040311'",
              TalkType = "FixSimple",
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
              HideAllBattleEntity = true,
              HideMechanismsFX = false,
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
          ["177556628149735849166"] = {
            key = "177556628149735849166",
            type = "HasDetectiveResultNode",
            name = "检测是否获取过推理结果",
            pos = {x = 1734.2751283814807, y = 162.71957361233714},
            propsData = {
              ResultIds = {20050101}
            }
          },
          ["177556826723038504690"] = {
            key = "177556826723038504690",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1456.2116389688726, y = 163.4920606201212},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312480064}
            }
          },
          ["177556827663838504963"] = {
            key = "177556827663838504963",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2699.227505679031, y = 241.64020729013342},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {312480064}
            }
          },
          ["177556829255838505223"] = {
            key = "177556829255838505223",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1991.5555530602664, y = 213.4920610574321},
            propsData = {
              NewDescription = "Description_200403_5_1",
              NewDetail = "Content_200403_5_1",
              SubTaskTargetIndex = 0
            }
          },
          ["17787456647634612"] = {
            key = "17787456647634612",
            type = "JudgeRegionNode",
            name = "判断位于区域",
            pos = {x = 1130.5714298689445, y = 365.4285717659256},
            propsData = {
              IsWaitingEnterRegion = false,
              RegionIds = {106001, 106301}
            }
          },
          ["17787457547096531"] = {
            key = "17787457547096531",
            type = "HasDetectiveResultNode",
            name = "检测是否获取过推理结果",
            pos = {x = 1506.3405386411428, y = 488.4343252794061},
            propsData = {
              ResultIds = {20050101}
            }
          },
          ["17787457847407096"] = {
            key = "17787457847407096",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1803.4833903863328, y = 525.5771817475551},
            propsData = {
              NewDescription = "Description_200403_5_1",
              NewDetail = "Content_200403_5_1",
              SubTaskTargetIndex = 0
            }
          },
          ["17787457930147317"] = {
            key = "17787457930147317",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 2082.0548157139715, y = 512.7200418487489},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 106001,
              bGuideUIEnable = true,
              GuideType = "N",
              GuideName = "Npc_Aote_312480064"
            }
          }
        },
        commentData = {}
      }
    },
    ["17755506832576636746"] = {
      isStoryNode = true,
      key = "17755506832576636746",
      type = "StoryNode",
      name = "与老妇人对话",
      pos = {x = 2188.7451661959353, y = 318.8191733895577},
      propsData = {
        QuestId = 20040303,
        QuestDescriptionComment = "与老妇人对话",
        QuestDescription = "Description_200403_3",
        QuestDeatil = "Content_200403_3",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Laofuren_312480059",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17755506832576636751",
            startPort = "QuestStart",
            endQuest = "177556226938131862845",
            endPort = "In"
          },
          {
            startQuest = "177556226938131862845",
            startPort = "Out",
            endQuest = "17755509335556637866",
            endPort = "In"
          },
          {
            startQuest = "17755509335556637866",
            startPort = "Out",
            endQuest = "177556227808431863143",
            endPort = "In"
          },
          {
            startQuest = "177556227808431863143",
            startPort = "Out",
            endQuest = "17755506832576636752",
            endPort = "Success"
          },
          {
            startQuest = "177933237345510142587",
            startPort = "Out",
            endQuest = "177933237345510142588",
            endPort = "In"
          },
          {
            startQuest = "177933237345510142590",
            startPort = "Out",
            endQuest = "177933237345510142587",
            endPort = "In"
          },
          {
            startQuest = "177933237345510142588",
            startPort = "Out",
            endQuest = "177933237345510142589",
            endPort = "Input"
          },
          {
            startQuest = "177933237345510142586",
            startPort = "Out",
            endQuest = "177933237345510142590",
            endPort = "In"
          },
          {
            startQuest = "177933237345610142591",
            startPort = "Out",
            endQuest = "177933237345510142586",
            endPort = "In"
          },
          {
            startQuest = "177933237345510142589",
            startPort = "BeginOverlap",
            endQuest = "177933237345610142592",
            endPort = "Input"
          },
          {
            startQuest = "177933237345510142589",
            startPort = "EndOverlap",
            endQuest = "177933237345610142591",
            endPort = "In"
          },
          {
            startQuest = "177556226938131862845",
            startPort = "Out",
            endQuest = "177933237345510142586",
            endPort = "In"
          }
        },
        nodeData = {
          ["17755506832576636751"] = {
            key = "17755506832576636751",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1198, y = 464},
            propsData = {ModeType = 0}
          },
          ["17755506832576636752"] = {
            key = "17755506832576636752",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2500, y = 458},
            propsData = {ModeType = 0}
          },
          ["17755506832576636753"] = {
            key = "17755506832576636753",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17755509335556637866"] = {
            key = "17755509335556637866",
            type = "TalkNode",
            name = "与老妇人对话",
            pos = {x = 1857.548385330343, y = 470.6451615284931},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700410,
              GuideUIEnable = false,
              GuideType = "N",
              GuidePointName = "Npc_Laofuren_312480059",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200403/20040307.20040307'",
              TalkType = "FixSimple",
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
              HideAllBattleEntity = true,
              HideMechanismsFX = false,
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
          ["177556226938131862845"] = {
            key = "177556226938131862845",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1539.761059361387, y = 475.0322583225342},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "Npc_Laofuren_312480059",
              StaticCreatorIdList = {312480059}
            }
          },
          ["177556227808431863143"] = {
            key = "177556227808431863143",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2183.3094342320765, y = 475.7419334197267},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {312480059, 312480058}
            }
          },
          ["177933237345510142586"] = {
            key = "177933237345510142586",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1766.4608084679944, y = 229.84540620243607},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_GotoYWS"
            }
          },
          ["177933237345510142587"] = {
            key = "177933237345510142587",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2090.022496133734, y = -283.7325101566219},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_GotoYWS"
            }
          },
          ["177933237345510142588"] = {
            key = "177933237345510142588",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2474.985282985902, y = -253.63180806944985},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "N",
              GuideName = "Npc_Laofuren_312480059"
            }
          },
          ["177933237345510142589"] = {
            key = "177933237345510142589",
            type = "CollisionBoxNode",
            name = "进入/离开判定盒节点",
            pos = {x = 2841.2030717245325, y = -211.31302038205814},
            propsData = {StaticCreatorId = 312480416}
          },
          ["177933237345510142590"] = {
            key = "177933237345510142590",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1768.6224409924039, y = -258.0872115090454},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 312480415,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["177933237345610142591"] = {
            key = "177933237345610142591",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 3214.769887529177, y = -107.56102822141258},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "N",
              GuideName = "Npc_Laofuren_312480059"
            }
          },
          ["177933237345610142592"] = {
            key = "177933237345610142592",
            type = "TestPrintNode",
            name = "测试打印",
            pos = {x = 3257.539191532005, y = -313.8454062024361},
            propsData = {Text = "In"}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
