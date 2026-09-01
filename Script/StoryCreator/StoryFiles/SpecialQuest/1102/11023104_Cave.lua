return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17849870748331",
      startPort = "StoryStart",
      endStory = "178498708635784",
      endPort = "In"
    },
    {
      startStory = "178498708635784",
      startPort = "Success",
      endStory = "17849870748345",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17849870748331"] = {
      isStoryNode = true,
      key = "17849870748331",
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
    ["17849870748345"] = {
      isStoryNode = true,
      key = "17849870748345",
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
    ["178498708635784"] = {
      isStoryNode = true,
      key = "178498708635784",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1190, y = 330},
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
            startQuest = "178498708635785",
            startPort = "QuestStart",
            endQuest = "1784987103229370",
            endPort = "Input"
          },
          {
            startQuest = "1784987103229370",
            startPort = "Out",
            endQuest = "1784987112510555",
            endPort = "In"
          },
          {
            startQuest = "178498708635785",
            startPort = "QuestStart",
            endQuest = "1784987126285806",
            endPort = "In"
          },
          {
            startQuest = "1784987112510555",
            startPort = "Out",
            endQuest = "17849871835811277",
            endPort = "In"
          },
          {
            startQuest = "1784987112510555",
            startPort = "Out",
            endQuest = "17849874185431910",
            endPort = "In"
          },
          {
            startQuest = "17849874185431910",
            startPort = "Out",
            endQuest = "17849874649432499",
            endPort = "In"
          },
          {
            startQuest = "17849874649432499",
            startPort = "Out",
            endQuest = "17849877910473096",
            endPort = "In"
          },
          {
            startQuest = "17849877910473096",
            startPort = "Out",
            endQuest = "17849881507584266",
            endPort = "In"
          },
          {
            startQuest = "1784987112510555",
            startPort = "Out",
            endQuest = "17850550359822226080",
            endPort = "In"
          },
          {
            startQuest = "17850550359822226080",
            startPort = "Out",
            endQuest = "17850603088433336236",
            endPort = "In"
          },
          {
            startQuest = "17850603088433336236",
            startPort = "Out",
            endQuest = "17850609425233337079",
            endPort = "In"
          },
          {
            startQuest = "17849881507584266",
            startPort = "Out",
            endQuest = "17849878632343580",
            endPort = "In"
          },
          {
            startQuest = "17849881507584266",
            startPort = "Out",
            endQuest = "178748401144824097227",
            endPort = "Input"
          },
          {
            startQuest = "17849878632343580",
            startPort = "Out",
            endQuest = "178816683631024615867",
            endPort = "In"
          },
          {
            startQuest = "178816683631024615867",
            startPort = "Out",
            endQuest = "17850681848301112433",
            endPort = "In"
          },
          {
            startQuest = "1784987126285806",
            startPort = "Out",
            endQuest = "178816684847824616307",
            endPort = "In"
          },
          {
            startQuest = "178816684847824616307",
            startPort = "Out",
            endQuest = "1784987086358101",
            endPort = "Fail"
          },
          {
            startQuest = "178498708635785",
            startPort = "QuestStart",
            endQuest = "178816685404624616503",
            endPort = "In"
          }
        },
        nodeData = {
          ["178498708635785"] = {
            key = "178498708635785",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178498708635893"] = {
            key = "178498708635893",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3188.41113160131, y = 297.50204749832875},
            propsData = {ModeType = 0}
          },
          ["1784987086358101"] = {
            key = "1784987086358101",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2794, y = 836},
            propsData = {}
          },
          ["1784987103229370"] = {
            key = "1784987103229370",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1112, y = 208},
            propsData = {
              TargetTime = 22,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["1784987112510555"] = {
            key = "1784987112510555",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1416, y = 258},
            propsData = {QuestRoleId = 22010101, IsPlayFX = false}
          },
          ["1784987126285806"] = {
            key = "1784987126285806",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1238, y = 808},
            propsData = {}
          },
          ["17849871835811277"] = {
            key = "17849871835811277",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1784.9555365596202, y = -350.42488721027473},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11118101,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17849874185431910"] = {
            key = "17849874185431910",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1810.6312117058637, y = -88.19343038319698},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312790373,
              GuideType = "P",
              GuidePointName = "QuestSign_11023104_02"
            }
          },
          ["17849874649432499"] = {
            key = "17849874649432499",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2229.550119924683, y = -84.2086795764307},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312790374,
              GuideType = "P",
              GuidePointName = "QuestSign_11023104_03"
            }
          },
          ["17849877910473096"] = {
            key = "17849877910473096",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2531.121452445107, y = -88.45129420364904},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312790375,
              GuideType = "P",
              GuidePointName = "QuestSign_11023104_04"
            }
          },
          ["17849878632343580"] = {
            key = "17849878632343580",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2213.333908238772, y = 298.1841449963398},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11118201,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17849881507584266"] = {
            key = "17849881507584266",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2840.507913998095, y = -110.58863533579617},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312790376,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_312790376"
            }
          },
          ["17850550359822226080"] = {
            key = "17850550359822226080",
            type = "ChangeStaticCreatorNode",
            name = "生成怪物",
            pos = {x = 1812.8573501058006, y = 525.5576359780514},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                312790377,
                312790378,
                312790379,
                312790380,
                312790381,
                312790382,
                312790383,
                312790384,
                312790385,
                312790386,
                312790387,
                312790388,
                312790389,
                312790390,
                312790391,
                312790392,
                312790393,
                312790394,
                312790395,
                312790396
              }
            }
          },
          ["17850603088433336236"] = {
            key = "17850603088433336236",
            type = "ChangeStaticCreatorNode",
            name = "生成怪物",
            pos = {x = 2235.9342635268504, y = 549.9166097810814},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                312790397,
                312790398,
                312790400,
                312790401,
                312790404,
                312790405,
                312790406,
                312790408,
                312790411,
                312790416,
                312790417,
                312790419,
                312790421,
                312790422,
                312790423,
                312790425,
                312790426,
                312790427,
                312790429,
                312790430
              }
            }
          },
          ["17850609425233337079"] = {
            key = "17850609425233337079",
            type = "ChangeStaticCreatorNode",
            name = "生成怪物",
            pos = {x = 2638.498356903242, y = 560.17301980341},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                312790399,
                312790402,
                312790403,
                312790407,
                312790409,
                312790410,
                312790418,
                312790420,
                312790424,
                312790428
              }
            }
          },
          ["17850681848301112433"] = {
            key = "17850681848301112433",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2808, y = 318},
            propsData = {}
          },
          ["178748401144824097227"] = {
            key = "178748401144824097227",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 3126, y = -84},
            propsData = {
              TargetTime = 22,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["178816683631024615867"] = {
            key = "178816683631024615867",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2486, y = 328},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          },
          ["178816684847824616307"] = {
            key = "178816684847824616307",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1790, y = 828},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          },
          ["178816685404624616503"] = {
            key = "178816685404624616503",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1096, y = -248},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "event:/bgm/1_6/0184_story_curse_echoes",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {107101},
              bStoreToServer = true
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
