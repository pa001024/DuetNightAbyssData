return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "179016939108942",
      startPort = "StoryStart",
      endStory = "1790169398617280",
      endPort = "In"
    },
    {
      startStory = "1790169398617280",
      startPort = "Success",
      endStory = "179016939108945",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["179016939108942"] = {
      isStoryNode = true,
      key = "179016939108942",
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
    ["179016939108945"] = {
      isStoryNode = true,
      key = "179016939108945",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1420, y = 286},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1790169398617280"] = {
      isStoryNode = true,
      key = "1790169398617280",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1100, y = 286},
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
            startQuest = "1790169398617281",
            startPort = "QuestStart",
            endQuest = "17901699117705719135",
            endPort = "In"
          },
          {
            startQuest = "17901699603905720256",
            startPort = "Out",
            endQuest = "17901699603905720257",
            endPort = "In"
          },
          {
            startQuest = "17901699603905720257",
            startPort = "Out",
            endQuest = "17901699603915720258",
            endPort = "In"
          },
          {
            startQuest = "17901699603905720257",
            startPort = "Out",
            endQuest = "17901699603915720259",
            endPort = "In"
          },
          {
            startQuest = "17901699603905720257",
            startPort = "Out",
            endQuest = "17901699603915720260",
            endPort = "In"
          },
          {
            startQuest = "17901699603915720258",
            startPort = "Out",
            endQuest = "17901699603925720263",
            endPort = "In"
          },
          {
            startQuest = "17901699603915720259",
            startPort = "Out",
            endQuest = "17901699603915720261",
            endPort = "In"
          },
          {
            startQuest = "17901699603915720260",
            startPort = "Out",
            endQuest = "17901699603925720262",
            endPort = "In"
          },
          {
            startQuest = "17901699603925720264",
            startPort = "Out",
            endQuest = "17901699603925720265",
            endPort = "In"
          },
          {
            startQuest = "17901699603925720266",
            startPort = "Out",
            endQuest = "17901699603935720267",
            endPort = "In"
          },
          {
            startQuest = "17901699603935720269",
            startPort = "Out",
            endQuest = "17901699603935720270",
            endPort = "In"
          },
          {
            startQuest = "17901699603935720268",
            startPort = "Out",
            endQuest = "17901699603935720271",
            endPort = "In"
          },
          {
            startQuest = "17901699603905720255",
            startPort = "Out",
            endQuest = "17901699603935720272",
            endPort = "In"
          },
          {
            startQuest = "17901699603945720274",
            startPort = "Out",
            endQuest = "17901699603925720264",
            endPort = "Branch_1"
          },
          {
            startQuest = "17901699603945720275",
            startPort = "Out",
            endQuest = "17901699603925720264",
            endPort = "Branch_2"
          },
          {
            startQuest = "17901699603935720273",
            startPort = "Out",
            endQuest = "17901699603925720264",
            endPort = "Branch_3"
          },
          {
            startQuest = "17901699603925720263",
            startPort = "Out",
            endQuest = "17901699603945720274",
            endPort = "In"
          },
          {
            startQuest = "17901699603915720261",
            startPort = "Out",
            endQuest = "17901699603945720275",
            endPort = "In"
          },
          {
            startQuest = "17901699603925720262",
            startPort = "Out",
            endQuest = "17901699603935720273",
            endPort = "In"
          },
          {
            startQuest = "17901699603925720264",
            startPort = "Out",
            endQuest = "17901699603945720276",
            endPort = "In"
          },
          {
            startQuest = "17901699603945720276",
            startPort = "Out",
            endQuest = "17901699603925720266",
            endPort = "In"
          },
          {
            startQuest = "17901699603945720278",
            startPort = "Out",
            endQuest = "17901699603935720269",
            endPort = "In"
          },
          {
            startQuest = "17901699603945720278",
            startPort = "Out",
            endQuest = "17901699603935720268",
            endPort = "In"
          },
          {
            startQuest = "17901699603935720271",
            startPort = "Out",
            endQuest = "17901699603945720279",
            endPort = "In"
          },
          {
            startQuest = "17901699603945720279",
            startPort = "Out",
            endQuest = "17901699603895720254",
            endPort = "In"
          },
          {
            startQuest = "17901699603935720272",
            startPort = "Out",
            endQuest = "17901699603905720256",
            endPort = "In"
          },
          {
            startQuest = "17901699603925720264",
            startPort = "Out",
            endQuest = "17901699603945720280",
            endPort = "In"
          },
          {
            startQuest = "17901699603945720278",
            startPort = "Out",
            endQuest = "17901699603945720281",
            endPort = "In"
          },
          {
            startQuest = "17901699603935720270",
            startPort = "Out",
            endQuest = "17901699603955720282",
            endPort = "In"
          },
          {
            startQuest = "1790169398617281",
            startPort = "QuestStart",
            endQuest = "17901700702265721832",
            endPort = "In"
          },
          {
            startQuest = "17901700702265721832",
            startPort = "Out",
            endQuest = "17901699603905720255",
            endPort = "In"
          },
          {
            startQuest = "1790169398617281",
            startPort = "QuestStart",
            endQuest = "17901703437426866860",
            endPort = "In"
          },
          {
            startQuest = "17901699603935720267",
            startPort = "Out",
            endQuest = "17902155199221721976",
            endPort = "In"
          },
          {
            startQuest = "17902155199221721976",
            startPort = "Out",
            endQuest = "17901699603945720278",
            endPort = "In"
          },
          {
            startQuest = "17901699603935720267",
            startPort = "Out",
            endQuest = "17901699603945720277",
            endPort = "In"
          },
          {
            startQuest = "17901699117705719135",
            startPort = "Out",
            endQuest = "1790169398617297",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["1790169398617281"] = {
            key = "1790169398617281",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -317.89473684210503, y = -14.013157894736782},
            propsData = {ModeType = 0}
          },
          ["1790169398617289"] = {
            key = "1790169398617289",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 4993.75, y = 232.5},
            propsData = {ModeType = 0}
          },
          ["1790169398617297"] = {
            key = "1790169398617297",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 356.2332535885171, y = 220.26076555023928},
            propsData = {}
          },
          ["17901699117705719135"] = {
            key = "17901699117705719135",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 32.06340885636604, y = 207.47528413279178},
            propsData = {}
          },
          ["17901699603895720254"] = {
            key = "17901699603895720254",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 4976.948695267582, y = -10.132532933107711},
            propsData = {}
          },
          ["17901699603905720255"] = {
            key = "17901699603905720255",
            type = "GoToNode",
            name = "进入基地小屋",
            pos = {x = 294.2380215243983, y = -19.68230905324981},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351940046,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351940046"
            }
          },
          ["17901699603905720256"] = {
            key = "17901699603905720256",
            type = "TalkNode",
            name = "黎瑟自言自语",
            pos = {x = 857.2312767212143, y = -17.375770648414573},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070021,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120701/12070102.12070102'",
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
          ["17901699603905720257"] = {
            key = "17901699603905720257",
            type = "BranchQuestStartNode",
            name = "基地交互子任务",
            pos = {x = 1135.8027052926423, y = -17.684594177826455},
            propsData = {
              AllQuestOptions = {
                {
                  IsNeedFinish = true,
                  BranchQuestName = "",
                  TargetBranchQuestKey = "17901699603945720274"
                },
                {
                  IsNeedFinish = true,
                  BranchQuestName = "",
                  TargetBranchQuestKey = "17901699603945720275"
                },
                {
                  IsNeedFinish = true,
                  BranchQuestName = "",
                  TargetBranchQuestKey = "17901699603935720273"
                }
              },
              IsSetCountInfo = true,
              IsDifftation = false,
              AllDiffGuideOptions = {
                {
                  OptionElements = {
                    {
                      TargetIndicatorKey = "17901699603915720258",
                      IsShowOptional = false
                    }
                  }
                },
                {
                  OptionElements = {
                    {
                      TargetIndicatorKey = "17901699603915720259",
                      IsShowOptional = false
                    }
                  }
                },
                {
                  OptionElements = {
                    {
                      TargetIndicatorKey = "17901699603915720260",
                      IsShowOptional = false
                    }
                  }
                }
              }
            }
          },
          ["17901699603915720258"] = {
            key = "17901699603915720258",
            type = "PickUpNode",
            name = "交互合照",
            pos = {x = 1441.588419578357, y = -198.14887989211198},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 120701,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "Target_Photo_120701",
              IsUseCount = false
            }
          },
          ["17901699603915720259"] = {
            key = "17901699603915720259",
            type = "PickUpNode",
            name = "交互墙面",
            pos = {x = 1443.0169910069285, y = -25.29173703496906},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 120702,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "Target_Wall_120702",
              IsUseCount = false
            }
          },
          ["17901699603915720260"] = {
            key = "17901699603915720260",
            type = "PickUpNode",
            name = "交互礼盒",
            pos = {x = 1443.016991006928, y = 150.42254867931666},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 120703,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "Target_Gift_120703",
              IsUseCount = false
            }
          },
          ["17901699603915720261"] = {
            key = "17901699603915720261",
            type = "TalkNode",
            name = "墙面对话",
            pos = {x = 1715.8741338640712, y = -26.72030846354039},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070034,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120701/12070104.12070104'",
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
          ["17901699603925720262"] = {
            key = "17901699603925720262",
            type = "TalkNode",
            name = "礼盒对话",
            pos = {x = 1713.0169910069285, y = 148.9939772507451},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070040,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120701/12070105.12070105'",
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
          ["17901699603925720263"] = {
            key = "17901699603925720263",
            type = "TalkNode",
            name = "合照对话",
            pos = {x = 1713.0169910069285, y = -199.5774513206833},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070025,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120701/12070103.12070103'",
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
          ["17901699603925720264"] = {
            key = "17901699603925720264",
            type = "CheckBranchQuestFinishedNode",
            name = "子任务结束节点",
            pos = {x = 2325.178248613419, y = -47.87504622071236},
            propsData = {
              InputBranchQuestNumber = 3,
              BranchQuestFinishOptions = {
                {IsNeedFinish = true},
                {IsNeedFinish = true},
                {IsNeedFinish = true}
              }
            }
          },
          ["17901699603925720265"] = {
            key = "17901699603925720265",
            type = "TalkNode",
            name = "打扫完开车",
            pos = {x = 2682.276094648386, y = -228.60304337568698},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 12070045,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17901699603925720266"] = {
            key = "17901699603925720266",
            type = "PickUpNode",
            name = "交互书堆",
            pos = {x = 2930.475173489409, y = -21.858161233106728},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 120704,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "Target_Books_120704",
              IsUseCount = false
            }
          },
          ["17901699603935720267"] = {
            key = "17901699603935720267",
            type = "TalkNode",
            name = "看到名单",
            pos = {x = 3226.9457617247017, y = -17.484759698579808},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070047,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120701/12070106.12070106'",
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
          ["17901699603935720268"] = {
            key = "17901699603935720268",
            type = "GoToNode",
            name = "去小屋门口",
            pos = {x = 4111.793161554202, y = -7.565748615885639},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351940046,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351940046"
            }
          },
          ["17901699603935720269"] = {
            key = "17901699603935720269",
            type = "PickUpNode",
            name = "交互名单（可选",
            pos = {x = 4113.217447945561, y = -193.78216944995347},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 120705,
              UnitCount = 1,
              bGuideUIEnable = false,
              GuideType = "P",
              GuidePointName = "Target_Namelist_120705",
              IsUseCount = false
            }
          },
          ["17901699603935720270"] = {
            key = "17901699603935720270",
            type = "TalkNode",
            name = "黎瑟不想看",
            pos = {x = 4396.260926206431, y = -196.39086510212746},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070059,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120701/12070107.12070107'",
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
          ["17901699603935720271"] = {
            key = "17901699603935720271",
            type = "TalkNode",
            name = "回来捡名单",
            pos = {x = 4390.085385634471, y = -7.511318817210338},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070063,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120701/12070108.12070108'",
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
          ["17901699603935720272"] = {
            key = "17901699603935720272",
            type = "ChangeStaticCreatorNode",
            name = "生成合照/墙面/礼盒交互",
            pos = {x = 563.3744655757041, y = -10.451160384088098},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                351940047,
                351940048,
                351940049
              }
            }
          },
          ["17901699603935720273"] = {
            key = "17901699603935720273",
            type = "ChangeStaticCreatorNode",
            name = "销毁礼盒交互",
            pos = {x = 2007.5923873598017, y = 162.50272886391855},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351940049}
            }
          },
          ["17901699603945720274"] = {
            key = "17901699603945720274",
            type = "ChangeStaticCreatorNode",
            name = "销毁合照交互",
            pos = {x = 2006.0328635502779, y = -172.93774732655757},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351940048}
            }
          },
          ["17901699603945720275"] = {
            key = "17901699603945720275",
            type = "ChangeStaticCreatorNode",
            name = "销毁墙面交互",
            pos = {x = 2003.09868988081, y = -10.388727718714449},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351940047}
            }
          },
          ["17901699603945720276"] = {
            key = "17901699603945720276",
            type = "ChangeStaticCreatorNode",
            name = "生成书堆交互",
            pos = {x = 2641.088764171396, y = -17.620611776685735},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351940050}
            }
          },
          ["17901699603945720277"] = {
            key = "17901699603945720277",
            type = "ChangeStaticCreatorNode",
            name = "销毁书堆交互",
            pos = {x = 3508.2120134711167, y = -172.38623106788046},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351940050}
            }
          },
          ["17901699603945720278"] = {
            key = "17901699603945720278",
            type = "ChangeStaticCreatorNode",
            name = "生成名单交互",
            pos = {x = 3785.6902743406818, y = -6.498763037189917},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351940051}
            }
          },
          ["17901699603945720279"] = {
            key = "17901699603945720279",
            type = "ChangeStaticCreatorNode",
            name = "销毁名单交互",
            pos = {x = 4695.022937840868, y = 3.30008150062514},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351940051, 351940052}
            }
          },
          ["17901699603945720280"] = {
            key = "17901699603945720280",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务栏-查看书堆",
            pos = {x = 2671.714449746126, y = -357.3836812448703},
            propsData = {
              NewDescription = "Description_120701_3",
              NewDetail = "Content_120701_3",
              SubTaskTargetIndex = 0
            }
          },
          ["17901699603945720281"] = {
            key = "17901699603945720281",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务栏-离开基地",
            pos = {x = 4119.07159260327, y = -348.17372453491373},
            propsData = {
              NewDescription = "Description_120701_4",
              NewDetail = "Content_120701_4",
              SubTaskTargetIndex = 0
            }
          },
          ["17901699603955720282"] = {
            key = "17901699603955720282",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 4699.178578129815, y = -187.33698289491053},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {351940052}
            }
          },
          ["17901700702265721832"] = {
            key = "17901700702265721832",
            type = "ChangeRoleNode",
            name = "切换SP黎瑟",
            pos = {x = 15.927267263178976, y = -4.909516438154546},
            propsData = {QuestRoleId = 41030101, IsPlayFX = false}
          },
          ["17901703437426866860"] = {
            key = "17901703437426866860",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 21.98469796457288, y = -187.78602898649365},
            propsData = {
              NewDescription = "Description_120701_2",
              NewDetail = "Content_120701_2",
              SubTaskTargetIndex = 0
            }
          },
          ["17902155199221721976"] = {
            key = "17902155199221721976",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "重设黎瑟位置",
            pos = {x = 3505.739130434783, y = -18.086956521739207},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_LiseReset_1207",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
