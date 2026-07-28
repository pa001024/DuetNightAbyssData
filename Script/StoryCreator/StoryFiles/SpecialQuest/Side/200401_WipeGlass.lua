return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17768416837971",
      startPort = "StoryStart",
      endStory = "1776841689512145",
      endPort = "In"
    },
    {
      startStory = "1776841689512145",
      startPort = "Success",
      endStory = "17768416837985",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17768416837971"] = {
      isStoryNode = true,
      key = "17768416837971",
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
    ["17768416837985"] = {
      isStoryNode = true,
      key = "17768416837985",
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
    ["1776841689512145"] = {
      isStoryNode = true,
      key = "1776841689512145",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1358, y = 342},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200401_4_1",
        QuestDeatil = "Content_200401_4_1",
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
            startQuest = "1776841689512146",
            startPort = "QuestStart",
            endQuest = "1776841836103978",
            endPort = "In"
          },
          {
            startQuest = "1776841689512146",
            startPort = "QuestStart",
            endQuest = "17768418532091308",
            endPort = "In"
          },
          {
            startQuest = "17768418532091308",
            startPort = "Out",
            endQuest = "1776841689513162",
            endPort = "Fail"
          },
          {
            startQuest = "1776841836103978",
            startPort = "Out",
            endQuest = "17768419357282421",
            endPort = "In"
          },
          {
            startQuest = "1776841836103978",
            startPort = "Out",
            endQuest = "17768419167141884",
            endPort = "In"
          },
          {
            startQuest = "17768421601874304",
            startPort = "Out",
            endQuest = "17768418723381558",
            endPort = "In"
          },
          {
            startQuest = "17768419167141884",
            startPort = "Out",
            endQuest = "1776934016540543",
            endPort = "In"
          },
          {
            startQuest = "1776934016540543",
            startPort = "Out",
            endQuest = "1777030557702926326",
            endPort = "In"
          },
          {
            startQuest = "1777030557702926326",
            startPort = "Out",
            endQuest = "1777015621630728",
            endPort = "In"
          },
          {
            startQuest = "1776934016540543",
            startPort = "Out",
            endQuest = "17768421601874304",
            endPort = "In"
          }
        },
        nodeData = {
          ["1776841689512146"] = {
            key = "1776841689512146",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1776841689513154"] = {
            key = "1776841689513154",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3133.783776901167, y = 321.6216211757841},
            propsData = {ModeType = 0}
          },
          ["1776841689513162"] = {
            key = "1776841689513162",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1776841836103978"] = {
            key = "1776841836103978",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1187.619047590214, y = 316},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                312480259,
                312480260,
                312480261,
                312480262,
                312480263,
                312480264,
                312480265,
                312480266,
                312480267,
                312480268
              }
            }
          },
          ["17768418532091308"] = {
            key = "17768418532091308",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1146, y = 596},
            propsData = {}
          },
          ["17768418723381558"] = {
            key = "17768418723381558",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2920.248887578883, y = 327.9006905099721},
            propsData = {}
          },
          ["17768419167141884"] = {
            key = "17768419167141884",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 1507.081082502188, y = 318.108107940919},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 10,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                312480259,
                312480260,
                312480261,
                312480262,
                312480263,
                312480264,
                312480265,
                312480266,
                312480267,
                312480268
              }
            }
          },
          ["17768419357282421"] = {
            key = "17768419357282421",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1594.6486486765134, y = 82.64864867651349},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51200201,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17768421601874304"] = {
            key = "17768421601874304",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 2538.497933172142, y = 318.47876017055364},
            propsData = {
              StaticCreatorId = 312480258,
              UnitId = 20040102,
              bGuideUIEnable = true,
              GuidePointName = "QuestSign_20040104",
              LongPressTime = 1,
              MontageName = "",
              bFocusEnable = false,
              SequencePath = "",
              SoundEventPath = ""
            }
          },
          ["1776934016540543"] = {
            key = "1776934016540543",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1895.3548427784233, y = 329.4838736074647},
            propsData = {
              NewDescription = "Description_200401_4",
              NewDetail = "Content_200401_4",
              SubTaskTargetIndex = 0
            }
          },
          ["1777015621630728"] = {
            key = "1777015621630728",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2413.271489744747, y = 95.54991044764407},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51200122,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1777030557702926326"] = {
            key = "1777030557702926326",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2114.6228493162275, y = 126.63099398083148},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 312480275,
              GuideType = "M",
              GuidePointName = ""
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
