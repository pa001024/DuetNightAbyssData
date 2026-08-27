return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17815295931231",
      startPort = "StoryStart",
      endStory = "1781529668304371",
      endPort = "In"
    },
    {
      startStory = "1781529668304371",
      startPort = "Success",
      endStory = "17816847675225244141",
      endPort = "In"
    },
    {
      startStory = "17816847675225244141",
      startPort = "Success",
      endStory = "17815295931235",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17815295931231"] = {
      isStoryNode = true,
      key = "17815295931231",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 110202},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17815295931235"] = {
      isStoryNode = true,
      key = "17815295931235",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2209.1428571428573, y = 305.42857142857144},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1781529668304371"] = {
      isStoryNode = true,
      key = "1781529668304371",
      type = "StoryNode",
      name = "山谷逃脱特殊任务",
      pos = {x = 1185.8879120879121, y = 289.5984737484737},
      propsData = {
        QuestId = 11020201,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110202_01",
        QuestDeatil = "Content_110202_01",
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
        StoryGuidePointName = "Drop_entrance_ddtt01_142800297",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17815305819993146684",
            startPort = "Success",
            endQuest = "1781529668305380",
            endPort = "Success"
          },
          {
            startQuest = "17816849709086296288",
            startPort = "Out",
            endQuest = "1781529668305388",
            endPort = "Fail"
          },
          {
            startQuest = "1782960059673921",
            startPort = "Out",
            endQuest = "1782960059673922",
            endPort = "In"
          },
          {
            startQuest = "1782960059673922",
            startPort = "Out",
            endQuest = "1782960059673923",
            endPort = "In"
          },
          {
            startQuest = "1782960059673923",
            startPort = "Out",
            endQuest = "1782960059673924",
            endPort = "In"
          },
          {
            startQuest = "17829887277536476136",
            startPort = "Out",
            endQuest = "17829887277536476135",
            endPort = "In"
          },
          {
            startQuest = "17829887277536476135",
            startPort = "Out",
            endQuest = "17829887277536476134",
            endPort = "In"
          },
          {
            startQuest = "17829887277536476134",
            startPort = "Out",
            endQuest = "17829887277536476133",
            endPort = "In"
          },
          {
            startQuest = "17829887277536476133",
            startPort = "Out",
            endQuest = "17829887277536476132",
            endPort = "In"
          },
          {
            startQuest = "17829887277536476132",
            startPort = "Out",
            endQuest = "17829887277536476131",
            endPort = "In"
          },
          {
            startQuest = "17829887277536476131",
            startPort = "Out",
            endQuest = "17829887277536476130",
            endPort = "In"
          },
          {
            startQuest = "17829887277536476130",
            startPort = "Out",
            endQuest = "17829887277536476129",
            endPort = "In"
          },
          {
            startQuest = "17829887277536476128",
            startPort = "Out",
            endQuest = "17829887277536476127",
            endPort = "In"
          },
          {
            startQuest = "17829887277536476129",
            startPort = "Out",
            endQuest = "17829887277536476128",
            endPort = "In"
          },
          {
            startQuest = "17829887608016477243",
            startPort = "Out",
            endQuest = "17829887779156477344",
            endPort = "In"
          },
          {
            startQuest = "17829887779156477344",
            startPort = "Out",
            endQuest = "17816849709086296288",
            endPort = "In"
          },
          {
            startQuest = "17829887277536476127",
            startPort = "Out",
            endQuest = "17830488956206684",
            endPort = "In"
          },
          {
            startQuest = "178550843422014928532",
            startPort = "Out",
            endQuest = "178550843422014928533",
            endPort = "In"
          },
          {
            startQuest = "178550843422014928533",
            startPort = "Out",
            endQuest = "178550846230314929090",
            endPort = "In"
          },
          {
            startQuest = "17815305819993146684",
            startPort = "Fail",
            endQuest = "17857419618865532731",
            endPort = "Input"
          },
          {
            startQuest = "17857419618865532731",
            startPort = "Out",
            endQuest = "17829887277536476136",
            endPort = "In"
          },
          {
            startQuest = "178550851574316585196",
            startPort = "Out",
            endQuest = "17815305819993146684",
            endPort = "In"
          },
          {
            startQuest = "1781529668304372",
            startPort = "QuestStart",
            endQuest = "178550851574316585196",
            endPort = "In"
          },
          {
            startQuest = "17830488956206684",
            startPort = "Out",
            endQuest = "17863659237539083",
            endPort = "In"
          },
          {
            startQuest = "17863659237539083",
            startPort = "Out",
            endQuest = "17829887608016477243",
            endPort = "In"
          },
          {
            startQuest = "17815305819993146684",
            startPort = "PassiveFail",
            endQuest = "17857419618865532731",
            endPort = "Input"
          }
        },
        nodeData = {
          ["1781529668304372"] = {
            key = "1781529668304372",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 978.125, y = 228.625},
            propsData = {ModeType = 0}
          },
          ["1781529668305380"] = {
            key = "1781529668305380",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2273.508361204013, y = 126.37290969899661},
            propsData = {
              ModeType = 1,
              Id = 107301,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["1781529668305388"] = {
            key = "1781529668305388",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3597.9734970911445, y = 659.4313725490197},
            propsData = {}
          },
          ["17815304607143144186"] = {
            key = "17815304607143144186",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 287.97176044330786, y = -166.67188186209916},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_110202",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17815305819993146684"] = {
            key = "17815305819993146684",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1650.777017923821, y = 135.3216910398499},
            propsData = {SpecialConfigId = 11020201, BlackScreenImmediately = false}
          },
          ["17815307771823148109"] = {
            key = "17815307771823148109",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 910.8712208223717, y = -98.06236693116469},
            propsData = {
              VarName = "ex02_110202",
              VarValue = 1
            }
          },
          ["17816849709086296288"] = {
            key = "17816849709086296288",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 3165.599800806192, y = 626.4315571935812},
            propsData = {
              ModeType = 1,
              Id = 107101,
              StartIndex = 3,
              IsWhite = false
            }
          },
          ["1782960059673921"] = {
            key = "1782960059673921",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 434.14210229383184, y = 1354.303136333599},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 107101,
              bGuideUIEnable = false,
              GuideType = "M",
              GuideName = "Drop_entrance_diditaosheng_142790127"
            }
          },
          ["1782960059673922"] = {
            key = "1782960059673922",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 701.385495108766, y = 1361.8741745907705},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790127}
            }
          },
          ["1782960059673923"] = {
            key = "1782960059673923",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 982.5114691347399, y = 1369.345603162199},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 11020104,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "M",
              GuidePointName = "Drop_entrance_diditaosheng_142790127",
              IsUseCount = false
            }
          },
          ["1782960059673924"] = {
            key = "1782960059673924",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1234.4828977061684, y = 1381.402746019342},
            propsData = {
              ModeType = 1,
              Id = 107201,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17829600811931678"] = {
            key = "17829600811931678",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 456.33333333333337, y = 1168.1666666666665},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 107201,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17829887277536476127"] = {
            key = "17829887277536476127",
            type = "ForbidWeaponByWeaponTagNode",
            name = "禁用/启用武器节点",
            pos = {x = 2251.5439596316673, y = 573.619805402935},
            propsData = {
              WeaponTags = {"Melee", "Ranged"},
              bForbid = false,
              ForbidTag = "ForbidDefault",
              bHidewhenForbid = true
            }
          },
          ["17829887277536476128"] = {
            key = "17829887277536476128",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 2240.984802756826, y = 699.2153282542212},
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
          ["17829887277536476129"] = {
            key = "17829887277536476129",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2238.0000010758913, y = 822.7968930460871},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Task",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["17829887277536476130"] = {
            key = "17829887277536476130",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2230.2511232374827, y = 944.0885215739289},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "BloodBar",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["17829887277536476131"] = {
            key = "17829887277536476131",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2219.039943113259, y = 1060.5626416567443},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "EnergySkill",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["17829887277536476132"] = {
            key = "17829887277536476132",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2220.8991563637765, y = 1175.3266168120235},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Map",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["17829887277536476133"] = {
            key = "17829887277536476133",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2211.1087382896053, y = 1305.2288788075916},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "GuideBook",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["17829887277536476134"] = {
            key = "17829887277536476134",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2207.6857691019304, y = 1426.778481982195},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Entrance",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["17829887277536476135"] = {
            key = "17829887277536476135",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2214.540110838625, y = 1543.437212140925},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "BattleWheel",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["17829887277536476136"] = {
            key = "17829887277536476136",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2214.7623330608476, y = 1656.4372121409247},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "AimIndicator",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["17829887608016477243"] = {
            key = "17829887608016477243",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2876.360376207899, y = 411.69132389798045},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Hurt01_destory",
              UnitId = -1
            }
          },
          ["17829887779156477344"] = {
            key = "17829887779156477344",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2839.5032333507565, y = 603.9770381836947},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Hurt02_destory",
              UnitId = -1
            }
          },
          ["17830488956206684"] = {
            key = "17830488956206684",
            type = "CameraControlClearNode",
            name = "镜头恢复",
            pos = {x = 2258, y = 426},
            propsData = {Duration = 1}
          },
          ["178550843422014928532"] = {
            key = "178550843422014928532",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 944.8398143909757, y = 493.9699880356997},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142800297}
            }
          },
          ["178550843422014928533"] = {
            key = "178550843422014928533",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1227.7304942993026, y = 504.7747499404616},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 11020104,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "M",
              GuidePointName = "Drop_entrance_ddtt01_142800297",
              IsUseCount = false
            }
          },
          ["178550846230314929090"] = {
            key = "178550846230314929090",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1502.0694680706292, y = 527.7057023214139},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142800297}
            }
          },
          ["178550851574316585196"] = {
            key = "178550851574316585196",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1359.2558233819846, y = 223.52535325871196},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 107201,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17857419618865532731"] = {
            key = "17857419618865532731",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2015.1263749066693, y = 488.6373626373628},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17863659237539083"] = {
            key = "17863659237539083",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2581.285714285714, y = 424.8571428571429},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Stealth_destory",
              UnitId = -1
            }
          }
        },
        commentData = {}
      }
    },
    ["17816847675225244141"] = {
      isStoryNode = true,
      key = "17816847675225244141",
      type = "StoryNode",
      name = "噩梦游乐园特殊任务",
      pos = {x = 1723.8725310828995, y = 276.21920110715945},
      propsData = {
        QuestId = 11020202,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110202_02",
        QuestDeatil = "Content_110202_02",
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
        IsFairyLand = true,
        SubRegionId = 107301,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0,
        IsBacktrack = false,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17816847675225244151",
            startPort = "Success",
            endQuest = "17816847675225244147",
            endPort = "Success"
          },
          {
            startQuest = "17816851202587346930",
            startPort = "Out",
            endQuest = "17816847675225244148",
            endPort = "Fail"
          },
          {
            startQuest = "17816847675225244146",
            startPort = "QuestStart",
            endQuest = "17816847675225244151",
            endPort = "In"
          },
          {
            startQuest = "17816847675225244151",
            startPort = "Fail",
            endQuest = "17865447907101308",
            endPort = "In"
          },
          {
            startQuest = "17865447907101308",
            startPort = "Out",
            endQuest = "17816851202587346930",
            endPort = "In"
          },
          {
            startQuest = "17816847675225244151",
            startPort = "PassiveFail",
            endQuest = "17865447907101308",
            endPort = "In"
          }
        },
        nodeData = {
          ["17816847675225244146"] = {
            key = "17816847675225244146",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 708.625, y = 279.625},
            propsData = {ModeType = 0}
          },
          ["17816847675225244147"] = {
            key = "17816847675225244147",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2069.7198996655516, y = 112.79682274247486},
            propsData = {
              ModeType = 1,
              Id = 107201,
              StartIndex = 3,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17816847675225244148"] = {
            key = "17816847675225244148",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2373.2, y = 479.93333333333334},
            propsData = {}
          },
          ["17816847675225244151"] = {
            key = "17816847675225244151",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1440.3841607809638, y = 130.73835770651658},
            propsData = {SpecialConfigId = 11020202, BlackScreenImmediately = false}
          },
          ["17816851202587346930"] = {
            key = "17816851202587346930",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 2051.673254236147, y = 370.1799754677733},
            propsData = {
              ModeType = 1,
              Id = 107201,
              StartIndex = 2,
              IsWhite = false
            }
          },
          ["17865447907101308"] = {
            key = "17865447907101308",
            type = "ForbidWeaponByWeaponTagNode",
            name = "禁用/启用武器节点",
            pos = {x = 1749.2, y = 279.6},
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
    }
  },
  commentData = {
    ["17815297314071382"] = {
      key = "17815297314071382",
      name = "山谷潜行特殊任务",
      position = {x = 1084.3039599988113, y = 191.07855439754735},
      size = {width = 416.5384615384617, height = 266.53846153846155}
    },
    ["17816847717635244268"] = {
      key = "17816847717635244268",
      name = "噩梦游乐园特殊任务",
      position = {x = 1589.515388225757, y = 195.67158205954053},
      size = {width = 538.4127753888623, height = 261.4461100493709}
    }
  }
}
