return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17854880065221",
      startPort = "StoryStart",
      endStory = "1785490062784375",
      endPort = "In"
    },
    {
      startStory = "1785490062784375",
      startPort = "Success",
      endStory = "17854880065225",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17854880065221"] = {
      isStoryNode = true,
      key = "17854880065221",
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
    ["17854880065225"] = {
      isStoryNode = true,
      key = "17854880065225",
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
    ["1785490062784375"] = {
      isStoryNode = true,
      key = "1785490062784375",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1398, y = 384},
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
            startQuest = "17854903023401105082",
            startPort = "Out",
            endQuest = "1785490062784392",
            endPort = "Fail"
          },
          {
            startQuest = "1785490062784376",
            startPort = "QuestStart",
            endQuest = "17854903023401105082",
            endPort = "In"
          },
          {
            startQuest = "1785490062784376",
            startPort = "QuestStart",
            endQuest = "17854903050691105135",
            endPort = "Input"
          },
          {
            startQuest = "17854903050691105135",
            startPort = "Out",
            endQuest = "17854903169881105495",
            endPort = "In"
          },
          {
            startQuest = "17854903169881105495",
            startPort = "Out",
            endQuest = "17854933367641106404",
            endPort = "In"
          },
          {
            startQuest = "17854933367641106404",
            startPort = "Out",
            endQuest = "17854933830281107148",
            endPort = "In"
          },
          {
            startQuest = "17854903169881105495",
            startPort = "Out",
            endQuest = "17854903267151105779",
            endPort = "In"
          },
          {
            startQuest = "17854933830281107148",
            startPort = "Out",
            endQuest = "17859247645146681323",
            endPort = "In"
          },
          {
            startQuest = "17859247645146681323",
            startPort = "Out",
            endQuest = "17854908754711106009",
            endPort = "In"
          }
        },
        nodeData = {
          ["1785490062784376"] = {
            key = "1785490062784376",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1785490062784384"] = {
            key = "1785490062784384",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1785490062784392"] = {
            key = "1785490062784392",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2612, y = 912},
            propsData = {}
          },
          ["17854903023401105082"] = {
            key = "17854903023401105082",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1279.4880001376778, y = 980},
            propsData = {}
          },
          ["17854903050691105135"] = {
            key = "17854903050691105135",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1188, y = 154},
            propsData = {
              TargetTime = 22,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17854903169881105495"] = {
            key = "17854903169881105495",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1516, y = 140},
            propsData = {QuestRoleId = 22010101, IsPlayFX = false}
          },
          ["17854903267151105779"] = {
            key = "17854903267151105779",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 1858.5567772428647, y = 62.72527961319941},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = true,
              IsSync = false,
              StaticCreatorIdList = {312790453}
            }
          },
          ["17854908754711106009"] = {
            key = "17854908754711106009",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2610.695969773156, y = 475.31134550334525},
            propsData = {}
          },
          ["17854933367641106404"] = {
            key = "17854933367641106404",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1538.0000185285292, y = 474.85715079794113},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "FuerBossStart",
              UnitId = -1
            }
          },
          ["17854933830281107148"] = {
            key = "17854933830281107148",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = 1936.5714398598182, y = 523.4285784870588},
            propsData = {
              SendMessage = "",
              FinishCondition = "FuerBossEnd"
            }
          },
          ["17859247645146681323"] = {
            key = "17859247645146681323",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 2257.351928542847, y = 513.0180681563971},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = true,
              IsSync = false,
              StaticCreatorIdList = {312790453}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
