return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17821853924271",
      startPort = "StoryStart",
      endStory = "1782185399080174",
      endPort = "In"
    },
    {
      startStory = "17834067192936530619",
      startPort = "Success",
      endStory = "17821853924275",
      endPort = "StoryEnd"
    },
    {
      startStory = "1782185399080174",
      startPort = "Success",
      endStory = "17834067275906530910",
      endPort = "In"
    },
    {
      startStory = "17834067275906530910",
      startPort = "Success",
      endStory = "17834354376376561432",
      endPort = "In"
    },
    {
      startStory = "17834354376376561432",
      startPort = "Transport",
      endStory = "17834067192936530619",
      endPort = "In"
    },
    {
      startStory = "17834354376376561432",
      startPort = "Distransport",
      endStory = "17859145471382786959",
      endPort = "In"
    },
    {
      startStory = "17859145471382786959",
      startPort = "Success",
      endStory = "17821853924275",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17821853924271"] = {
      isStoryNode = true,
      key = "17821853924271",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 362.85714285714283, y = 311.42857142857144},
      propsData = {QuestChainId = 110221},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17821853924275"] = {
      isStoryNode = true,
      key = "17821853924275",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1910.625, y = 264.375},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1782185399080174"] = {
      isStoryNode = true,
      key = "1782185399080174",
      type = "StoryNode",
      name = "吊桥调查",
      pos = {x = 653.7351712614869, y = 260.6984126984128},
      propsData = {
        QuestId = 11022101,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110221_01",
        QuestDeatil = "Content_110221_01",
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
        StoryGuidePointName = "Mechanism_goto_aidahome_142780382",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17821954331753168",
            startPort = "Out",
            endQuest = "1782185399081191",
            endPort = "Fail"
          },
          {
            startQuest = "17821974738123209387",
            startPort = "false",
            endQuest = "17821975051713209987",
            endPort = "In"
          },
          {
            startQuest = "17821975051713209987",
            startPort = "Out",
            endQuest = "17821974980033209882",
            endPort = "In"
          },
          {
            startQuest = "1782185399080175",
            startPort = "QuestStart",
            endQuest = "17832477409061328",
            endPort = "In"
          },
          {
            startQuest = "17832477409061328",
            startPort = "Out",
            endQuest = "17821953834732475",
            endPort = "In"
          },
          {
            startQuest = "17821953834732475",
            startPort = "Success",
            endQuest = "1782185399081183",
            endPort = "Success"
          },
          {
            startQuest = "17821953834732475",
            startPort = "Fail",
            endQuest = "178343819290916386228",
            endPort = "Input"
          },
          {
            startQuest = "178343819290916386228",
            startPort = "Out",
            endQuest = "17821954331753168",
            endPort = "In"
          },
          {
            startQuest = "17821953834732475",
            startPort = "PassiveFail",
            endQuest = "178343819290916386228",
            endPort = "Input"
          }
        },
        nodeData = {
          ["1782185399080175"] = {
            key = "1782185399080175",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 458.57142857142856, y = 304.2857142857143},
            propsData = {ModeType = 0}
          },
          ["1782185399081183"] = {
            key = "1782185399081183",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2094.230769230769, y = 149.9230769230769},
            propsData = {
              ModeType = 1,
              Id = 107101,
              StartIndex = 2,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["1782185399081191"] = {
            key = "1782185399081191",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2154, y = 478.1428571428571},
            propsData = {}
          },
          ["17821953569822172"] = {
            key = "17821953569822172",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1386.857142857143, y = -81.07142857142856},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142780195,
              GuideType = "M",
              GuidePointName = "Mechanism_goto_diaoqiaokaiche_142780195"
            }
          },
          ["17821953834732475"] = {
            key = "17821953834732475",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1239, y = 216.61029411764707},
            propsData = {SpecialConfigId = 11022101, BlackScreenImmediately = true}
          },
          ["17821954331753168"] = {
            key = "17821954331753168",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1806.3342490842492, y = 428.12919317524575},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 3,
              IsWhite = false
            }
          },
          ["17821974738123209387"] = {
            key = "17821974738123209387",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1048.9179393037077, y = 622.5470269287405},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11022101",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17821974980033209882"] = {
            key = "17821974980033209882",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1643.6401260044752, y = 629.7684372319925},
            propsData = {SpecialConfigId = 11022102, BlackScreenImmediately = false}
          },
          ["17821975051713209987"] = {
            key = "17821975051713209987",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1344.278233421355, y = 636.6741277690768},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "21_tp_rebirth01",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17832477409061328"] = {
            key = "17832477409061328",
            type = "GoToNode",
            name = "前往",
            pos = {x = 841.3677944862154, y = 273.4786967418547},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142780382,
              GuideType = "M",
              GuidePointName = "Mechanism_goto_aidahome_142780382"
            }
          },
          ["178343819290916386228"] = {
            key = "178343819290916386228",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1606.3078914119935, y = 305.46938649921907},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          }
        },
        commentData = {}
      }
    },
    ["17834067192936530619"] = {
      isStoryNode = true,
      key = "17834067192936530619",
      type = "StoryNode",
      name = "传送",
      pos = {x = 1539.0463657899352, y = 148.4731368863335},
      propsData = {
        QuestId = 11022104,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110221_01",
        QuestDeatil = "Content_110221_01",
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
            startQuest = "17834067192936530620",
            startPort = "QuestStart",
            endQuest = "178671657580418399708",
            endPort = "Input"
          },
          {
            startQuest = "178671657580418399708",
            startPort = "Out",
            endQuest = "17834067192946530623",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17834067192936530620"] = {
            key = "17834067192936530620",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 302},
            propsData = {ModeType = 0}
          },
          ["17834067192946530623"] = {
            key = "17834067192946530623",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 298},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 3,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17834067192946530626"] = {
            key = "17834067192946530626",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["178671657580418399708"] = {
            key = "178671657580418399708",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 1366, y = 306},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 1,
              IsStandAlone = true
            }
          }
        },
        commentData = {}
      }
    },
    ["17834067275906530910"] = {
      isStoryNode = true,
      key = "17834067275906530910",
      type = "StoryNode",
      name = "桥下调查",
      pos = {x = 952.7816126337347, y = 240.15525885792908},
      propsData = {
        QuestId = 11022102,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110221_02",
        QuestDeatil = "Content_110221_01",
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
        SubRegionId = 107101,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Drop_entrance_die02_142790155",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17834345879384558",
            startPort = "Out",
            endQuest = "17834345815604400",
            endPort = "In"
          },
          {
            startQuest = "17834067275906530915",
            startPort = "QuestStart",
            endQuest = "17834349070611641377",
            endPort = "In"
          },
          {
            startQuest = "17834349070611641377",
            startPort = "false",
            endQuest = "17834345879384558",
            endPort = "In"
          },
          {
            startQuest = "17834349070611641377",
            startPort = "true",
            endQuest = "17834349529451642655",
            endPort = "In"
          },
          {
            startQuest = "17834350022571643768",
            startPort = "Out",
            endQuest = "17834067275906530917",
            endPort = "Fail"
          },
          {
            startQuest = "17834351364331647754",
            startPort = "Out",
            endQuest = "17834351364331647755",
            endPort = "In"
          },
          {
            startQuest = "17834351364331647755",
            startPort = "Out",
            endQuest = "17834350022571643768",
            endPort = "In"
          },
          {
            startQuest = "17834349298941641747",
            startPort = "Success",
            endQuest = "17834067275906530916",
            endPort = "Success"
          },
          {
            startQuest = "17834349298941641747",
            startPort = "Fail",
            endQuest = "178343815011114749899",
            endPort = "Input"
          },
          {
            startQuest = "17834345815604400",
            startPort = "Out",
            endQuest = "17834349298941641747",
            endPort = "In"
          },
          {
            startQuest = "178344068998024567279",
            startPort = "Out",
            endQuest = "178344068998024567278",
            endPort = "In"
          },
          {
            startQuest = "178344068998024567278",
            startPort = "Out",
            endQuest = "178344068998024567277",
            endPort = "In"
          },
          {
            startQuest = "178344068998024567277",
            startPort = "Out",
            endQuest = "178344068998024567276",
            endPort = "In"
          },
          {
            startQuest = "178344068998024567276",
            startPort = "Out",
            endQuest = "178344068998024567275",
            endPort = "In"
          },
          {
            startQuest = "178344068998024567275",
            startPort = "Out",
            endQuest = "178344068998024567274",
            endPort = "In"
          },
          {
            startQuest = "178344068998024567274",
            startPort = "Out",
            endQuest = "178344068998024567273",
            endPort = "In"
          },
          {
            startQuest = "178344068998024567273",
            startPort = "Out",
            endQuest = "178344068998024567272",
            endPort = "In"
          },
          {
            startQuest = "178344068998024567271",
            startPort = "Out",
            endQuest = "178344068998024567270",
            endPort = "In"
          },
          {
            startQuest = "178344068998024567272",
            startPort = "Out",
            endQuest = "178344068998024567271",
            endPort = "In"
          },
          {
            startQuest = "178344068998024567270",
            startPort = "Out",
            endQuest = "17834351364331647754",
            endPort = "In"
          },
          {
            startQuest = "178343815011114749899",
            startPort = "Out",
            endQuest = "178352051239013666997",
            endPort = "In"
          },
          {
            startQuest = "178352051239013666997",
            startPort = "Out",
            endQuest = "178352051239013666996",
            endPort = "In"
          },
          {
            startQuest = "178352051239013666996",
            startPort = "Out",
            endQuest = "178344068998024567270",
            endPort = "In"
          },
          {
            startQuest = "17834349298941641747",
            startPort = "PassiveFail",
            endQuest = "178343815011114749899",
            endPort = "Input"
          },
          {
            startQuest = "17834349070611641377",
            startPort = "true",
            endQuest = "17834349298941641747",
            endPort = "In"
          }
        },
        nodeData = {
          ["17834067275906530915"] = {
            key = "17834067275906530915",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 365.7894736842105, y = 247.89473684210526},
            propsData = {ModeType = 0}
          },
          ["17834067275906530916"] = {
            key = "17834067275906530916",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2661.441102756892, y = 0.2631578947368425},
            propsData = {ModeType = 0}
          },
          ["17834067275906530917"] = {
            key = "17834067275906530917",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2785, y = 631.4285714285714},
            propsData = {}
          },
          ["17834345815604400"] = {
            key = "17834345815604400",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1340.9589358010414, y = 275.72479842139285},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 11022103,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "M",
              GuidePointName = "Drop_entrance_die02_142790155",
              IsUseCount = false
            }
          },
          ["17834345879384558"] = {
            key = "17834345879384558",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1080.4326200115677, y = 266.06535569693466},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790155}
            }
          },
          ["17834349070611641377"] = {
            key = "17834349070611641377",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 663.0641989589359, y = 199.7495662232506},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_110221",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17834349298941641747"] = {
            key = "17834349298941641747",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1641.5698749135283, y = 36.5844475442},
            propsData = {SpecialConfigId = 11022102, BlackScreenImmediately = true}
          },
          ["17834349529451642655"] = {
            key = "17834349529451642655",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1012.7484094852518, y = -86.56622325043361},
            propsData = {
              VarName = "ex02_110221",
              VarValue = 1
            }
          },
          ["17834350022571643768"] = {
            key = "17834350022571643768",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 2607.2644053572853, y = 340.3532813935291},
            propsData = {
              ModeType = 1,
              Id = 107101,
              StartIndex = 2,
              IsWhite = false
            }
          },
          ["17834351364331647754"] = {
            key = "17834351364331647754",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2276.151873861433, y = 198.90519539295437},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Die_Destory",
              UnitId = -1
            }
          },
          ["17834351364331647755"] = {
            key = "17834351364331647755",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2528.457988412517, y = 196.06347712670055},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Die_NPCDestory",
              UnitId = -1
            }
          },
          ["178343815011114749899"] = {
            key = "178343815011114749899",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1992.667178667566, y = 106.49653587651619},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["178344068998024567270"] = {
            key = "178344068998024567270",
            type = "ForbidWeaponByWeaponTagNode",
            name = "禁用/启用武器节点",
            pos = {x = 2305.999782704365, y = 412.6822597521031},
            propsData = {
              WeaponTags = {"Melee", "Ranged"},
              bForbid = false,
              ForbidTag = "ForbidDefault",
              bHidewhenForbid = true
            }
          },
          ["178344068998024567271"] = {
            key = "178344068998024567271",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 2299.068076809915, y = 568.2777826033893},
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
          ["178344068998024567272"] = {
            key = "178344068998024567272",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2296.0832751289804, y = 691.859347395255},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Task",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178344068998024567273"] = {
            key = "178344068998024567273",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2288.334397290572, y = 813.150975923097},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "BloodBar",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178344068998024567274"] = {
            key = "178344068998024567274",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2277.1232171663482, y = 929.6250960059123},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "EnergySkill",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178344068998024567275"] = {
            key = "178344068998024567275",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2278.9824304168665, y = 1044.3890711611916},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Map",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178344068998024567276"] = {
            key = "178344068998024567276",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2269.192012342695, y = 1174.2913331567597},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "GuideBook",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178344068998024567277"] = {
            key = "178344068998024567277",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2264.004337272667, y = 1295.840936331363},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Entrance",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178344068998024567278"] = {
            key = "178344068998024567278",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2270.858679009362, y = 1412.4996664900934},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "BattleWheel",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178344068998024567279"] = {
            key = "178344068998024567279",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2271.0809012315835, y = 1523.499666490093},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "AimIndicator",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178352051239013666996"] = {
            key = "178352051239013666996",
            type = "PlayerSwitchWalkRunNode",
            name = "玩家走跑切换",
            pos = {x = 1979.3824333561176, y = 495.1404647983597},
            propsData = {Rate = 1, Mode = "ToRun"}
          },
          ["178352051239013666997"] = {
            key = "178352051239013666997",
            type = "CameraControlClearNode",
            name = "镜头恢复",
            pos = {x = 1934.0967190704034, y = 291.8547505126452},
            propsData = {Duration = 1}
          }
        },
        commentData = {}
      }
    },
    ["17834354376376561432"] = {
      isStoryNode = true,
      key = "17834354376376561432",
      type = "StoryNode",
      name = "弹窗",
      pos = {x = 1215.079323303567, y = 205.5512355168487},
      propsData = {
        QuestId = 11022103,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110221_01",
        QuestDeatil = "Content_110221_01",
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
            startQuest = "17834354376376561433",
            startPort = "QuestStart",
            endQuest = "17834354962826562720",
            endPort = "Input"
          },
          {
            startQuest = "17834354962826562720",
            startPort = "True",
            endQuest = "17834354865226562382",
            endPort = "In"
          },
          {
            startQuest = "17834354962826562720",
            startPort = "False",
            endQuest = "17834354865226562383",
            endPort = "In"
          }
        },
        nodeData = {
          ["17834354376376561433"] = {
            key = "17834354376376561433",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17834354376376561436"] = {
            key = "17834354376376561436",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17834354376376561439"] = {
            key = "17834354376376561439",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17834354865226562382"] = {
            key = "17834354865226562382",
            type = "QuestConditionNode",
            name = "QuestCondition",
            pos = {x = 1527.5037593984962, y = 214.27443609022552},
            propsData = {PortName = "Transport"}
          },
          ["17834354865226562383"] = {
            key = "17834354865226562383",
            type = "QuestConditionNode",
            name = "QuestCondition",
            pos = {x = 1528.2105263157894, y = 354.29699248120306},
            propsData = {
              PortName = "Distransport"
            }
          },
          ["17834354962826562720"] = {
            key = "17834354962826562720",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 1173.4285714285713, y = 272.4107142857143},
            propsData = {PopupId = 100422}
          }
        },
        commentData = {}
      }
    },
    ["17859145471382786959"] = {
      isStoryNode = true,
      key = "17859145471382786959",
      type = "StoryNode",
      name = "传送",
      pos = {x = 1533.142857142857, y = 309.3179723502305},
      propsData = {
        QuestId = 11022105,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110221_01",
        QuestDeatil = "Content_110221_01",
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
            startQuest = "17859145471382786964",
            startPort = "QuestStart",
            endQuest = "17859145613012787210",
            endPort = "In"
          },
          {
            startQuest = "17859145613012787210",
            startPort = "Out",
            endQuest = "17859145471382786965",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17859145471382786964"] = {
            key = "17859145471382786964",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 302},
            propsData = {ModeType = 0}
          },
          ["17859145471382786965"] = {
            key = "17859145471382786965",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 298},
            propsData = {ModeType = 0}
          },
          ["17859145471382786966"] = {
            key = "17859145471382786966",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17859145613012787210"] = {
            key = "17859145613012787210",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1754, y = 338},
            propsData = {WaitTime = 1}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
