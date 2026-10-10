return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178703512108712320601",
      startPort = "StoryStart",
      endStory = "178703512980012320936",
      endPort = "In"
    },
    {
      startStory = "178703512980012320936",
      startPort = "Success",
      endStory = "178703512108712320604",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178703512108712320601"] = {
      isStoryNode = true,
      key = "178703512108712320601",
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
    ["178703512108712320604"] = {
      isStoryNode = true,
      key = "178703512108712320604",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1552, y = 298},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178703512980012320936"] = {
      isStoryNode = true,
      key = "178703512980012320936",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1161.4352941176471, y = 288.1569136745608},
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
            startQuest = "178703512980012320941",
            startPort = "QuestStart",
            endQuest = "178738869385719241069",
            endPort = "In"
          },
          {
            startQuest = "178703512980012320941",
            startPort = "QuestStart",
            endQuest = "178738872000919241541",
            endPort = "In"
          },
          {
            startQuest = "178738895220419244484",
            startPort = "Out",
            endQuest = "178738897881919244854",
            endPort = "In"
          },
          {
            startQuest = "178738897881919244854",
            startPort = "Out",
            endQuest = "178738875202419242255",
            endPort = "In"
          },
          {
            startQuest = "178738869385719241069",
            startPort = "Out",
            endQuest = "178738885892719243217",
            endPort = "In"
          },
          {
            startQuest = "178738885892719243217",
            startPort = "Out",
            endQuest = "178738893015819244112",
            endPort = "In"
          },
          {
            startQuest = "178738893015819244112",
            startPort = "Out",
            endQuest = "178738883356719242917",
            endPort = "In"
          },
          {
            startQuest = "178738883356719242917",
            startPort = "Out",
            endQuest = "178738895220419244484",
            endPort = "In"
          },
          {
            startQuest = "178738872000919241541",
            startPort = "Out",
            endQuest = "178703512980012320943",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["178703512980012320941"] = {
            key = "178703512980012320941",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1081.7391304347825, y = 292.1739130434783},
            propsData = {ModeType = 0}
          },
          ["178703512980012320942"] = {
            key = "178703512980012320942",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3121.6785714285716, y = 457.10714285714283},
            propsData = {ModeType = 0}
          },
          ["178703512980012320943"] = {
            key = "178703512980012320943",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1697.5573122529645, y = 504.1739130434783},
            propsData = {}
          },
          ["178738869385719241069"] = {
            key = "178738869385719241069",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1383.7391304347825, y = 292.1739130434783},
            propsData = {QuestRoleId = 41030101, IsPlayFX = false}
          },
          ["178738872000919241541"] = {
            key = "178738872000919241541",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1379.7391304347825, y = 494.1739130434783},
            propsData = {}
          },
          ["178738875202419242255"] = {
            key = "178738875202419242255",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 3124.0714285714284, y = 282.60714285714283},
            propsData = {}
          },
          ["178738883356719242917"] = {
            key = "178738883356719242917",
            type = "TalkNode",
            name = "告知蕾伊真相",
            pos = {x = 2255.6413043478265, y = 276.61956521739125},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070583,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120705/12070504.12070504'",
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
              SkipToOption = true,
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
          ["178738885892719243217"] = {
            key = "178738885892719243217",
            type = "GoToNode",
            name = "到达下水道舞台",
            pos = {x = 1686.7857142857142, y = 290.2678571428571},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351740139,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351740139"
            }
          },
          ["178738893015819244112"] = {
            key = "178738893015819244112",
            type = "ChangeStaticCreatorNode",
            name = "生成下水道舞台蕾伊",
            pos = {x = 1967.5465838509317, y = 295.10481366459624},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351740140}
            }
          },
          ["178738895220419244484"] = {
            key = "178738895220419244484",
            type = "ChangeNpcDefaultDataNode",
            name = "修改NPC默认动作/表情节点",
            pos = {x = 2550.535714285714, y = 297.71350931677017},
            propsData = {
              ChangeNpcDefaultDataList = {
                {
                  TargetNpcUnitId = 260017,
                  DefaultActionId = 2,
                  DefaultFacialId = 1
                }
              }
            }
          },
          ["178738897881919244854"] = {
            key = "178738897881919244854",
            type = "TalkNode",
            name = "安慰蕾伊",
            pos = {x = 2840.535714285714, y = 281.51785714285717},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 260017,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_ReyCry120705_351740140",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070624,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120705/12070505.12070505'",
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
