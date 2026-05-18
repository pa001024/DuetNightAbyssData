return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177874559414014606116",
      startPort = "StoryStart",
      endStory = "177874559521014606156",
      endPort = "In"
    },
    {
      startStory = "177874559521014606156",
      startPort = "Success",
      endStory = "177874559414014606119",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177874559414014606116"] = {
      isStoryNode = true,
      key = "177874559414014606116",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1295.7894736842106, y = 236.84210526315792},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874559414014606119"] = {
      isStoryNode = true,
      key = "177874559414014606119",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1941.0526315789473, y = 233.68421052631578},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874559521014606156"] = {
      isStoryNode = true,
      key = "177874559521014606156",
      type = "StoryNode",
      name = "前往普通车厢",
      pos = {x = 1614, y = 226.0000000000001},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040408_01",
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
        IsBacktrack = false,
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177874559521014606164",
            startPort = "Out",
            endQuest = "177874559521014606165",
            endPort = "In"
          },
          {
            startQuest = "177874559521014606161",
            startPort = "QuestStart",
            endQuest = "177874559521014606166",
            endPort = "In"
          },
          {
            startQuest = "177874559521014606161",
            startPort = "QuestStart",
            endQuest = "177874559521014606167",
            endPort = "In"
          },
          {
            startQuest = "177874559521014606167",
            startPort = "Out",
            endQuest = "177874559521014606168",
            endPort = "In"
          },
          {
            startQuest = "177874559521014606168",
            startPort = "Out",
            endQuest = "177874559521014606169",
            endPort = "In"
          },
          {
            startQuest = "177874559521014606165",
            startPort = "Out",
            endQuest = "177874559521014606170",
            endPort = "In"
          },
          {
            startQuest = "177874559521114606176",
            startPort = "Out",
            endQuest = "177874559521114606172",
            endPort = "In"
          },
          {
            startQuest = "177874559521114606172",
            startPort = "Out",
            endQuest = "177874559521114606174",
            endPort = "In"
          },
          {
            startQuest = "177874559521114606174",
            startPort = "Out",
            endQuest = "177874559521114606175",
            endPort = "In"
          },
          {
            startQuest = "177874559521114606175",
            startPort = "Out",
            endQuest = "177874559521114606173",
            endPort = "In"
          },
          {
            startQuest = "177874559521114606171",
            startPort = "Out",
            endQuest = "177874559521114606176",
            endPort = "In"
          },
          {
            startQuest = "177874559521014606161",
            startPort = "QuestStart",
            endQuest = "177874559521114606171",
            endPort = "In"
          },
          {
            startQuest = "177874559521014606161",
            startPort = "QuestStart",
            endQuest = "177874559521114606177",
            endPort = "In"
          },
          {
            startQuest = "177874559521114606177",
            startPort = "Out",
            endQuest = "177874559521014606164",
            endPort = "In"
          },
          {
            startQuest = "177874559521014606170",
            startPort = "Out",
            endQuest = "17787611012345851744",
            endPort = "In"
          }
        },
        nodeData = {
          ["177874559521014606161"] = {
            key = "177874559521014606161",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 448.6117647058823, y = 170.29411764705884},
            propsData = {ModeType = 0}
          },
          ["177874559521014606162"] = {
            key = "177874559521014606162",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2742.7715428276574, y = 263.39976780185754},
            propsData = {ModeType = 0}
          },
          ["177874559521014606163"] = {
            key = "177874559521014606163",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["177874559521014606164"] = {
            key = "177874559521014606164",
            type = "GoToNode",
            name = "前往普通车厢",
            pos = {x = 1177.8823529411766, y = 289.95588235294116},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272730005,
              GuideType = "M",
              GuidePointName = "Mechanism_GetPingmin_272730005"
            }
          },
          ["177874559521014606165"] = {
            key = "177874559521014606165",
            type = "TalkNode",
            name = "普通列车对话",
            pos = {x = 1533.514153029633, y = 293.69327731092443},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10046201.10046201'",
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
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "BP_PTPre01",
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
          ["177874559521014606166"] = {
            key = "177874559521014606166",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 743.1789473684212, y = -277.69999999999993},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = true,
              IsSync = false,
              StaticCreatorIdList = {272640050}
            }
          },
          ["177874559521014606167"] = {
            key = "177874559521014606167",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1188, y = 104},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "OpenGate01Front",
              UnitId = -1
            }
          },
          ["177874559521014606168"] = {
            key = "177874559521014606168",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1496, y = 96},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "OpenGate02Behind",
              UnitId = -1
            }
          },
          ["177874559521014606169"] = {
            key = "177874559521014606169",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1800.2858777378228, y = 108.5416802876756},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272640076}
            }
          },
          ["177874559521014606170"] = {
            key = "177874559521014606170",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1930.6367549308054, y = 289.4188732701317},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272640076}
            }
          },
          ["177874559521114606171"] = {
            key = "177874559521114606171",
            type = "ChangeRoleNode",
            name = "切换为主角",
            pos = {x = 772.1040595560046, y = -103.61741062141532},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177874559521114606172"] = {
            key = "177874559521114606172",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1654.5465599376864, y = -136.6349910875357},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "BloodBar",
              ActionParam = "None",
              ShowOrHide = true
            }
          },
          ["177874559521114606173"] = {
            key = "177874559521114606173",
            type = "CameraControlNode",
            name = "镜头控制节点",
            pos = {x = 2736.361439965023, y = -205.5977348027865},
            propsData = {
              Duration = 3,
              CameraName = "StoryEast01Nai01",
              LockRotate = false,
              FocalLength = 0,
              LensAperture = 0,
              FOV = 70,
              PPMaterialPath = ""
            }
          },
          ["177874559521114606174"] = {
            key = "177874559521114606174",
            type = "ForbidWeaponByWeaponTagNode",
            name = "禁用/启用武器节点",
            pos = {x = 2039.7231392955648, y = -131.49317428812267},
            propsData = {
              WeaponTags = {"Melee"},
              bForbid = true,
              ForbidTag = "ForbidDefault",
              bHidewhenForbid = true
            }
          },
          ["177874559521114606175"] = {
            key = "177874559521114606175",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 2370.276901958023, y = -142.4650200751857},
            propsData = {
              PlayerId = 0,
              bActiveEnable = false,
              ActiveType = "Lock",
              SkillNameList = {
                "Attack",
                "Jump",
                "Slide",
                "BulletJump",
                "Fire",
                "Skill1",
                "Skill2",
                "Avoid",
                "Skill3"
              }
            }
          },
          ["177874559521114606176"] = {
            key = "177874559521114606176",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1302.89573706847, y = -142.74877568815387},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "EnergySkill",
              ActionParam = "None",
              ShowOrHide = true
            }
          },
          ["177874559521114606177"] = {
            key = "177874559521114606177",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "将玩家设置在车尾车厢",
            pos = {x = 812.3104066985649, y = 268.8225296442688},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_PTStart",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17787611012345851744"] = {
            key = "17787611012345851744",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2357.304217840983, y = 307.390994454462},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
