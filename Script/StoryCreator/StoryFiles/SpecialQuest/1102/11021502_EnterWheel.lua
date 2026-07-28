return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17807367632561",
      startPort = "StoryStart",
      endStory = "178073676712570",
      endPort = "In"
    },
    {
      startStory = "178073676712570",
      startPort = "Success",
      endStory = "17807367632565",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17807367632561"] = {
      isStoryNode = true,
      key = "17807367632561",
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
    ["17807367632565"] = {
      isStoryNode = true,
      key = "17807367632565",
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
    ["178073676712570"] = {
      isStoryNode = true,
      key = "178073676712570",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1548, y = 352},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110215_3",
        QuestDeatil = "Content_110215_3",
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
            startQuest = "178073676712571",
            startPort = "QuestStart",
            endQuest = "1780736821071894",
            endPort = "In"
          },
          {
            startQuest = "1780736821071894",
            startPort = "Out",
            endQuest = "17807372539351685",
            endPort = "In"
          },
          {
            startQuest = "1780736821071894",
            startPort = "Out",
            endQuest = "17807372374331527",
            endPort = "In"
          },
          {
            startQuest = "178073676712571",
            startPort = "QuestStart",
            endQuest = "17807400625413789",
            endPort = "In"
          },
          {
            startQuest = "17807400625413789",
            startPort = "Out",
            endQuest = "17807400746084259",
            endPort = "In"
          },
          {
            startQuest = "17807400625413789",
            startPort = "Out",
            endQuest = "17807400746084260",
            endPort = "In"
          },
          {
            startQuest = "17807400746084259",
            startPort = "Out",
            endQuest = "17807401024254809",
            endPort = "Input_1"
          },
          {
            startQuest = "17807400746084260",
            startPort = "Out",
            endQuest = "17807401024254809",
            endPort = "Input_2"
          },
          {
            startQuest = "17807401024254809",
            startPort = "Out",
            endQuest = "178073676712587",
            endPort = "Fail"
          },
          {
            startQuest = "17807499009221017758",
            startPort = "Out",
            endQuest = "17807499009221017759",
            endPort = "In"
          },
          {
            startQuest = "1780736821071894",
            startPort = "Out",
            endQuest = "17807499009221017758",
            endPort = "In"
          },
          {
            startQuest = "17807499009221017759",
            startPort = "Out",
            endQuest = "17807500562621019306",
            endPort = "In"
          },
          {
            startQuest = "17807500562621019306",
            startPort = "Out",
            endQuest = "17807502694952031935",
            endPort = "In"
          },
          {
            startQuest = "178073676712571",
            startPort = "QuestStart",
            endQuest = "1780906266816504",
            endPort = "Input"
          },
          {
            startQuest = "17811643830651527762",
            startPort = "Out",
            endQuest = "17811643830651527764",
            endPort = "Input_1"
          },
          {
            startQuest = "17811643830651527763",
            startPort = "Out",
            endQuest = "17811643830651527764",
            endPort = "Input_2"
          },
          {
            startQuest = "17811643830651527764",
            startPort = "Out",
            endQuest = "17807400535093573",
            endPort = "In"
          },
          {
            startQuest = "17807502694952031935",
            startPort = "Out",
            endQuest = "17811643830651527762",
            endPort = "In"
          },
          {
            startQuest = "17807502694952031935",
            startPort = "Out",
            endQuest = "17811643830651527763",
            endPort = "In"
          }
        },
        nodeData = {
          ["178073676712571"] = {
            key = "178073676712571",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178073676712579"] = {
            key = "178073676712579",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3087.834096995075, y = 44.700464389628735},
            propsData = {ModeType = 0}
          },
          ["178073676712587"] = {
            key = "178073676712587",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2822.5806448834246, y = 880.645159067398},
            propsData = {}
          },
          ["1780736821071894"] = {
            key = "1780736821071894",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1221.2466973215467, y = 402.75413668031354},
            propsData = {QuestRoleId = 1040101, IsPlayFX = false}
          },
          ["17807372374331527"] = {
            key = "17807372374331527",
            type = "ForbidWeaponByWeaponTagNode",
            name = "禁用/启用武器节点",
            pos = {x = 1690.6015302555898, y = -147.85293268082614},
            propsData = {
              WeaponTags = {"Melee", "Ranged"},
              bForbid = true,
              ForbidTag = "ForbidDefault",
              bHidewhenForbid = true
            }
          },
          ["17807372539351685"] = {
            key = "17807372539351685",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 1716.4079815509324, y = 69.84030528881013},
            propsData = {
              PlayerId = 0,
              bActiveEnable = false,
              ActiveType = "Lock",
              SkillNameList = {
                "Avoid",
                "BulletJump",
                "Attack",
                "Jump",
                "Slide",
                "SecondJump",
                "Skill1",
                "Skill2",
                "Skill3",
                "Fire"
              }
            }
          },
          ["17807400535093573"] = {
            key = "17807400535093573",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 3771.307317630701, y = 398.7218544191123},
            propsData = {}
          },
          ["17807400625413789"] = {
            key = "17807400625413789",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1287.252055389352, y = 801.1642433275076},
            propsData = {}
          },
          ["17807400746084259"] = {
            key = "17807400746084259",
            type = "ForbidWeaponByWeaponTagNode",
            name = "禁用/启用武器节点",
            pos = {x = 1807.867721316738, y = 699.4974449615585},
            propsData = {
              WeaponTags = {"Melee", "Ranged"},
              bForbid = false,
              ForbidTag = "ForbidDefault",
              bHidewhenForbid = true
            }
          },
          ["17807400746084260"] = {
            key = "17807400746084260",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 1725.5660667331601, y = 898.2717644023835},
            propsData = {
              PlayerId = 0,
              bActiveEnable = true,
              ActiveType = "Lock",
              SkillNameList = {
                "Avoid",
                "BulletJump",
                "Attack",
                "Jump",
                "Slide",
                "SecondJump",
                "Skill1",
                "Skill2",
                "Skill3",
                "Fire"
              }
            }
          },
          ["17807401024254809"] = {
            key = "17807401024254809",
            type = "WaitQuestFinishedNode",
            name = "等待任务完成",
            pos = {x = 2215.365535484468, y = 832.6683908621313},
            propsData = {ListenCount = 2, NeedFinishCount = 2}
          },
          ["17807499009221017758"] = {
            key = "17807499009221017758",
            type = "ChangeStaticCreatorNode",
            name = "生成摩天轮交互点",
            pos = {x = 1720.2216003171218, y = 399.3581482804997},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780016}
            }
          },
          ["17807499009221017759"] = {
            key = "17807499009221017759",
            type = "PickUpNode",
            name = "拾取物品-与交互点交互",
            pos = {x = 2019.058505785601, y = 391.46358652035445},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {312780016},
              QuestPickupId = -1,
              UnitId = 11021501,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "QuestSign11021503",
              IsUseCount = false
            }
          },
          ["17807500562621019306"] = {
            key = "17807500562621019306",
            type = "TalkNode",
            name = "摩天轮对话",
            pos = {x = 2317.2206939355065, y = 403.47538527604286},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110215/11021502.11021502'",
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
          ["17807502199112031530"] = {
            key = "17807502199112031530",
            type = "ChangeStaticCreatorNode",
            name = "生成法露茜",
            pos = {x = 2084.9626322774234, y = 64.76571202467146},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {}
            }
          },
          ["17807502694952031935"] = {
            key = "17807502694952031935",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2603.487970455716, y = 458.2680094966396},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110215/11021503.11021503'",
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
          ["1780906266816504"] = {
            key = "1780906266816504",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1164, y = 128},
            propsData = {
              TargetTime = 12,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17811643830651527762"] = {
            key = "17811643830651527762",
            type = "ForbidWeaponByWeaponTagNode",
            name = "禁用/启用武器节点",
            pos = {x = 3093.757941470431, y = 256.4264580823362},
            propsData = {
              WeaponTags = {"Melee", "Ranged"},
              bForbid = false,
              ForbidTag = "ForbidDefault",
              bHidewhenForbid = true
            }
          },
          ["17811643830651527763"] = {
            key = "17811643830651527763",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 3129.198220921854, y = 542.2975506449425},
            propsData = {
              PlayerId = 0,
              bActiveEnable = true,
              ActiveType = "Lock",
              SkillNameList = {
                "Avoid",
                "BulletJump",
                "Attack",
                "Jump",
                "Slide",
                "SecondJump",
                "Skill1",
                "Skill2",
                "Skill3",
                "Fire"
              }
            }
          },
          ["17811643830651527764"] = {
            key = "17811643830651527764",
            type = "WaitQuestFinishedNode",
            name = "等待任务完成",
            pos = {x = 3501.255755638161, y = 389.59740398290904},
            propsData = {ListenCount = 2, NeedFinishCount = 2}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
