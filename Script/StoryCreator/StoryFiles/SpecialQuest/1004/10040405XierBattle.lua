return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177874151457611686858",
      startPort = "StoryStart",
      endStory = "177874151835511686898",
      endPort = "In"
    },
    {
      startStory = "177874151835511686898",
      startPort = "Success",
      endStory = "177874151457611686861",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177874151457611686858"] = {
      isStoryNode = true,
      key = "177874151457611686858",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1067.5, y = 167.5},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874151457611686861"] = {
      isStoryNode = true,
      key = "177874151457611686861",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1816.25, y = 177.5},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874151835511686898"] = {
      isStoryNode = true,
      key = "177874151835511686898",
      type = "StoryNode",
      name = "希尔妲战斗",
      pos = {x = 1412, y = 164},
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
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177874151835511686906",
            startPort = "Out",
            endQuest = "177874151835511686907",
            endPort = "In"
          },
          {
            startQuest = "177874151835511686907",
            startPort = "Out",
            endQuest = "177874151835511686908",
            endPort = "In"
          },
          {
            startQuest = "177874151835511686908",
            startPort = "Out",
            endQuest = "177874151835511686909",
            endPort = "In"
          },
          {
            startQuest = "177874151835511686903",
            startPort = "QuestStart",
            endQuest = "177874151835511686910",
            endPort = "In"
          },
          {
            startQuest = "177874151835511686910",
            startPort = "Out",
            endQuest = "177874151835511686906",
            endPort = "In"
          },
          {
            startQuest = "177874151835511686903",
            startPort = "QuestStart",
            endQuest = "177874153356811687360",
            endPort = "In"
          },
          {
            startQuest = "177874153356811687360",
            startPort = "Out",
            endQuest = "177874151835511686905",
            endPort = "Fail"
          },
          {
            startQuest = "177874151835511686909",
            startPort = "Out",
            endQuest = "177874154354411687702",
            endPort = "In"
          },
          {
            startQuest = "177874151835511686903",
            startPort = "QuestStart",
            endQuest = "177874155000811687872",
            endPort = "In"
          }
        },
        nodeData = {
          ["177874151835511686903"] = {
            key = "177874151835511686903",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 368.9473684210526, y = 287.3684210526316},
            propsData = {ModeType = 0}
          },
          ["177874151835511686904"] = {
            key = "177874151835511686904",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2597.3636363636365, y = 264.4965034965035},
            propsData = {ModeType = 0}
          },
          ["177874151835511686905"] = {
            key = "177874151835511686905",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1130, y = 602},
            propsData = {}
          },
          ["177874151835511686906"] = {
            key = "177874151835511686906",
            type = "TalkNode",
            name = "帝国军士长剧情",
            pos = {x = 1107, y = 281.57894736842104},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10045801.10045801'",
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
          ["177874151835511686907"] = {
            key = "177874151835511686907",
            type = "ChangeStaticCreatorNode",
            name = "生成军士怪",
            pos = {x = 1446.6065101479187, y = 293.28694418270726},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                172640013,
                172640014,
                172640015,
                172640016,
                172640017,
                172640018,
                172640019,
                172640153,
                172640154,
                172640155
              }
            }
          },
          ["177874151835511686908"] = {
            key = "177874151835511686908",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 1738.774829497016, y = 314.88190985776447},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 10,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                172640013,
                172640014,
                172640015,
                172640016,
                172640017,
                172640018,
                172640019,
                172640153,
                172640154,
                172640155
              }
            }
          },
          ["177874151835511686909"] = {
            key = "177874151835511686909",
            type = "TalkNode",
            name = "战斗后剧情",
            pos = {x = 2067.9429177017178, y = 323.4413024102921},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10045901.10045901'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 2,
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
              HideMechanismsFX = true,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
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
          ["177874151835511686910"] = {
            key = "177874151835511686910",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 764.142857142857, y = 288.0000000000002},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_XierBattle",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177874153356811687360"] = {
            key = "177874153356811687360",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 756, y = 562},
            propsData = {}
          },
          ["177874154354411687702"] = {
            key = "177874154354411687702",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2344, y = 350},
            propsData = {}
          },
          ["177874155000811687872"] = {
            key = "177874155000811687872",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 740, y = 134},
            propsData = {QuestRoleId = 31020201, IsPlayFX = false}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
