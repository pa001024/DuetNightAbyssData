return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17817716789451",
      startPort = "StoryStart",
      endStory = "17817718282371062361",
      endPort = "In"
    },
    {
      startStory = "17817718282371062361",
      startPort = "Success",
      endStory = "17821366728231604993",
      endPort = "In"
    },
    {
      startStory = "17821366728231604993",
      startPort = "Success",
      endStory = "17817716789455",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17817716789451"] = {
      isStoryNode = true,
      key = "17817716789451",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1725, y = 346.25},
      propsData = {QuestChainId = 110203},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17817716789455"] = {
      isStoryNode = true,
      key = "17817716789455",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2760.857142857143, y = 321.42857142857144},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17817718282371062361"] = {
      isStoryNode = true,
      key = "17817718282371062361",
      type = "StoryNode",
      name = "山洞苏醒",
      pos = {x = 2023.8140614535753, y = 339.655939971438},
      propsData = {
        QuestId = 11020301,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110203_01",
        QuestDeatil = "Content_110203_01",
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
        SubRegionId = 107201,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_entrance_tcst01_142800298",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17817718550791063008",
            startPort = "Success",
            endQuest = "17817718282381062365",
            endPort = "Success"
          },
          {
            startQuest = "17817718913821063565",
            startPort = "Out",
            endQuest = "17817718282381062368",
            endPort = "Fail"
          },
          {
            startQuest = "17831630463466494543",
            startPort = "Out",
            endQuest = "17817718913821063565",
            endPort = "In"
          },
          {
            startQuest = "17817718282371062362",
            startPort = "QuestStart",
            endQuest = "178550984056418244279",
            endPort = "In"
          },
          {
            startQuest = "178550984056418244279",
            startPort = "false",
            endQuest = "178550988097718245109",
            endPort = "In"
          },
          {
            startQuest = "178550988097718245109",
            startPort = "Out",
            endQuest = "17817718550791063008",
            endPort = "In"
          },
          {
            startQuest = "178550984056418244279",
            startPort = "true",
            endQuest = "178551013984618247295",
            endPort = "In"
          },
          {
            startQuest = "178551090150823217526",
            startPort = "Out",
            endQuest = "178551090150823217527",
            endPort = "In"
          },
          {
            startQuest = "178551090150823217527",
            startPort = "Out",
            endQuest = "178551090150823217528",
            endPort = "In"
          },
          {
            startQuest = "17817718550791063008",
            startPort = "Fail",
            endQuest = "178551090150823217526",
            endPort = "In"
          },
          {
            startQuest = "178551090150823217528",
            startPort = "Out",
            endQuest = "17831630463466494543",
            endPort = "Input"
          },
          {
            startQuest = "178550984056418244279",
            startPort = "true",
            endQuest = "17817718550791063008",
            endPort = "In"
          },
          {
            startQuest = "17817718550791063008",
            startPort = "PassiveFail",
            endQuest = "178551090150823217526",
            endPort = "In"
          }
        },
        nodeData = {
          ["17817718282371062362"] = {
            key = "17817718282371062362",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 60.799999999999955, y = 194.8},
            propsData = {ModeType = 0}
          },
          ["17817718282381062365"] = {
            key = "17817718282381062365",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2725, y = 164.87499999999994},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 7,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17817718282381062368"] = {
            key = "17817718282381062368",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3095.7142857142862, y = 586.4285714285713},
            propsData = {}
          },
          ["17817718550791063008"] = {
            key = "17817718550791063008",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1418.3151525893463, y = 119.83294930875577},
            propsData = {SpecialConfigId = 11020301, BlackScreenImmediately = true}
          },
          ["17817718913821063565"] = {
            key = "17817718913821063565",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 2774.22077922078, y = 584.6571428571431},
            propsData = {
              ModeType = 1,
              Id = 107201,
              StartIndex = 3,
              IsWhite = false
            }
          },
          ["17831630463466494543"] = {
            key = "17831630463466494543",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2501.52582033404, y = 571.3882545800657},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["178550984056418244279"] = {
            key = "178550984056418244279",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 442, y = 187.99999999999994},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_110203_1",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["178550988097718245109"] = {
            key = "178550988097718245109",
            type = "GoToNode",
            name = "前往",
            pos = {x = 898, y = 390},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142800298,
              GuideType = "M",
              GuidePointName = "Mechanism_entrance_tcst01_142800298"
            }
          },
          ["178551013984618247295"] = {
            key = "178551013984618247295",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 959.2058823529412, y = -164.20588235294116},
            propsData = {
              VarName = "ex02_110203_1",
              VarValue = 1
            }
          },
          ["178551090150823217526"] = {
            key = "178551090150823217526",
            type = "PlayerSwitchWalkRunNode",
            name = "玩家走跑切换",
            pos = {x = 1738.8230546541315, y = 260.4766421122958},
            propsData = {Rate = 1, Mode = "ToRun"}
          },
          ["178551090150823217527"] = {
            key = "178551090150823217527",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 1993.9517932160518, y = 334.8473116326265},
            propsData = {
              PlayerId = 0,
              bActiveEnable = true,
              ActiveType = "Lock",
              SkillNameList = {
                "Avoid",
                "BulletJump",
                "Attack",
                "Slide",
                "Skill1",
                "Skill2",
                "Skill3",
                "Fire",
                "Jump"
              }
            }
          },
          ["178551090150823217528"] = {
            key = "178551090150823217528",
            type = "ForbidWeaponByWeaponTagNode",
            name = "禁用/启用武器节点",
            pos = {x = 2233.6475335811624, y = 452.23233621587747},
            propsData = {
              WeaponTags = {"Melee", "Ranged"},
              bForbid = false,
              ForbidTag = "ForbidDefault",
              bHidewhenForbid = true
            }
          }
        },
        commentData = {}
      }
    },
    ["17821366728231604993"] = {
      isStoryNode = true,
      key = "17821366728231604993",
      type = "StoryNode",
      name = "到达村庄",
      pos = {x = 2372.6317948410315, y = 321.24705687529837},
      propsData = {
        QuestId = 11020302,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110203_02",
        QuestDeatil = "Content_110203_02",
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
        SubRegionId = 107001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Drop_entrance_tcst01_142780647",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17821366728231605001",
            startPort = "Success",
            endQuest = "17821366728231604999",
            endPort = "Success"
          },
          {
            startQuest = "17821366728231605002",
            startPort = "Out",
            endQuest = "17821366728231605000",
            endPort = "Fail"
          },
          {
            startQuest = "178351846506820807948",
            startPort = "Out",
            endQuest = "178351846506820807947",
            endPort = "In"
          },
          {
            startQuest = "178351846506820807947",
            startPort = "Out",
            endQuest = "178351846506820807946",
            endPort = "In"
          },
          {
            startQuest = "178351846506820807946",
            startPort = "Out",
            endQuest = "178351846506820807945",
            endPort = "In"
          },
          {
            startQuest = "178351846506820807945",
            startPort = "Out",
            endQuest = "178351846506820807944",
            endPort = "In"
          },
          {
            startQuest = "178351846506820807944",
            startPort = "Out",
            endQuest = "178351846506820807943",
            endPort = "In"
          },
          {
            startQuest = "178351846506820807943",
            startPort = "Out",
            endQuest = "178351846506820807942",
            endPort = "In"
          },
          {
            startQuest = "178351846506820807942",
            startPort = "Out",
            endQuest = "178351846506820807941",
            endPort = "In"
          },
          {
            startQuest = "178351846506820807941",
            startPort = "Out",
            endQuest = "178351846506820807940",
            endPort = "In"
          },
          {
            startQuest = "178351846506820807949",
            startPort = "Out",
            endQuest = "178351846506820807948",
            endPort = "In"
          },
          {
            startQuest = "178351846506820807940",
            startPort = "Out",
            endQuest = "178351851871422447447",
            endPort = "In"
          },
          {
            startQuest = "17821366728231605001",
            startPort = "Fail",
            endQuest = "178351858612524086371",
            endPort = "In"
          },
          {
            startQuest = "178351858612524086371",
            startPort = "Out",
            endQuest = "178351846506820807949",
            endPort = "In"
          },
          {
            startQuest = "178551074905621559953",
            startPort = "Out",
            endQuest = "178551077395221560546",
            endPort = "In"
          },
          {
            startQuest = "178551077395221560546",
            startPort = "Out",
            endQuest = "178551080886021561394",
            endPort = "In"
          },
          {
            startQuest = "17833284821345977479",
            startPort = "Out",
            endQuest = "17821366728231605001",
            endPort = "In"
          },
          {
            startQuest = "17821366728231604998",
            startPort = "QuestStart",
            endQuest = "17833284821345977479",
            endPort = "In"
          },
          {
            startQuest = "178351851871422447447",
            startPort = "Out",
            endQuest = "17864392545943358231",
            endPort = "Input"
          },
          {
            startQuest = "17864392545943358231",
            startPort = "Out",
            endQuest = "17821366728231605002",
            endPort = "In"
          },
          {
            startQuest = "17821366728231605001",
            startPort = "PassiveFail",
            endQuest = "178351858612524086371",
            endPort = "In"
          }
        },
        nodeData = {
          ["17821366728231604998"] = {
            key = "17821366728231604998",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 85.22303348825073, y = 194.17312687312688},
            propsData = {ModeType = 0}
          },
          ["17821366728231604999"] = {
            key = "17821366728231604999",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17821366728231605000"] = {
            key = "17821366728231605000",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2717.777777777778, y = 547.2777777777777},
            propsData = {}
          },
          ["17821366728231605001"] = {
            key = "17821366728231605001",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1195.3811855069532, y = 283.0217036710704},
            propsData = {SpecialConfigId = 11020302, BlackScreenImmediately = true}
          },
          ["17821366728231605002"] = {
            key = "17821366728231605002",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 2199.6825396825398, y = 521.0079365079366},
            propsData = {
              ModeType = 1,
              Id = 107201,
              StartIndex = 3,
              IsWhite = false
            }
          },
          ["17833284821345977479"] = {
            key = "17833284821345977479",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 627.701029694305, y = 170.40333614765296},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 107001,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178351846506820807940"] = {
            key = "178351846506820807940",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 1781.3184533579092, y = 752.9337402095931},
            propsData = {
              PlayerId = 0,
              bActiveEnable = true,
              ActiveType = "Lock",
              SkillNameList = {
                "Avoid",
                "BulletJump",
                "Attack",
                "Slide",
                "Skill1",
                "Skill2",
                "Skill3",
                "Fire"
              }
            }
          },
          ["178351846506820807941"] = {
            key = "178351846506820807941",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1778.3336516769746, y = 878.0942523698801},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Task",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178351846506820807942"] = {
            key = "178351846506820807942",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1770.584773838566, y = 999.3858808977218},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "BloodBar",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178351846506820807943"] = {
            key = "178351846506820807943",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1759.3735937143424, y = 1115.8600009805373},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "EnergySkill",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178351846506820807944"] = {
            key = "178351846506820807944",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1761.2328069648606, y = 1228.1239761358165},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Map",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178351846506820807945"] = {
            key = "178351846506820807945",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1751.442388890689, y = 1355.5262381313844},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "GuideBook",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178351846506820807946"] = {
            key = "178351846506820807946",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1748.754713820661, y = 1459.5758413059878},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Entrance",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178351846506820807947"] = {
            key = "178351846506820807947",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1755.609055557356, y = 1568.734571464718},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "BattleWheel",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178351846506820807948"] = {
            key = "178351846506820807948",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1753.3312777795777, y = 1674.2345714647176},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "AimIndicator",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178351846506820807949"] = {
            key = "178351846506820807949",
            type = "PlayerSwitchWalkRunNode",
            name = "玩家走跑切换",
            pos = {x = 1474.59247781618, y = 719.0852665919626},
            propsData = {Rate = 1, Mode = "ToRun"}
          },
          ["178351851871422447447"] = {
            key = "178351851871422447447",
            type = "ForbidWeaponByWeaponTagNode",
            name = "禁用/启用武器节点",
            pos = {x = 1796.0960618329036, y = 620.9966875230039},
            propsData = {
              WeaponTags = {"Melee", "Ranged"},
              bForbid = false,
              ForbidTag = "ForbidDefault",
              bHidewhenForbid = true
            }
          },
          ["178351858612524086371"] = {
            key = "178351858612524086371",
            type = "CameraControlClearNode",
            name = "镜头恢复",
            pos = {x = 1521.8287759711905, y = 410.2381735911151},
            propsData = {Duration = 1}
          },
          ["178551036395621558566"] = {
            key = "178551036395621558566",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 104.58612040133777, y = 505.24999999999994},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_110203_2",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["178551036395621558567"] = {
            key = "178551036395621558567",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 704.3928571428571, y = -381.81493506493507},
            propsData = {
              VarName = "ex02_110203_2",
              VarValue = 1
            }
          },
          ["178551074905621559953"] = {
            key = "178551074905621559953",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 562.5681159420291, y = 612.7876811594203},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {11020107}
            }
          },
          ["178551077395221560546"] = {
            key = "178551077395221560546",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 844.7420289855071, y = 592.0630434782609},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 11020107,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "M",
              GuidePointName = "Drop_entrance_tcst01_142780647",
              IsUseCount = false
            }
          },
          ["178551080886021561394"] = {
            key = "178551080886021561394",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1103.075362318841, y = 529.2369565217391},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {11020107}
            }
          },
          ["17864392545943358231"] = {
            key = "17864392545943358231",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1951.7889676113364, y = 466},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = true,
              ForceWeatherType = -1
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
