return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17678537949071014368",
      startPort = "StoryStart",
      endStory = "17678537949071014370",
      endPort = "In"
    },
    {
      startStory = "17678537949071014370",
      startPort = "Success",
      endStory = "17678537949071014369",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17678537949071014368"] = {
      isStoryNode = true,
      key = "17678537949071014368",
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
    ["17678537949071014369"] = {
      isStoryNode = true,
      key = "17678537949071014369",
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
    ["17678537949071014370"] = {
      isStoryNode = true,
      key = "17678537949071014370",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1372, y = 352},
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
            startQuest = "17678537949071014371",
            startPort = "QuestStart",
            endQuest = "1768803857700490",
            endPort = "In"
          },
          {
            startQuest = "17688039119811183",
            startPort = "Out",
            endQuest = "1770210602992298",
            endPort = "In"
          },
          {
            startQuest = "1770210602992298",
            startPort = "Out",
            endQuest = "1770210609833554",
            endPort = "In"
          },
          {
            startQuest = "17678537949071014371",
            startPort = "QuestStart",
            endQuest = "17688039119811183",
            endPort = "In"
          },
          {
            startQuest = "1768803857700490",
            startPort = "Out",
            endQuest = "17730550603324960138",
            endPort = "In"
          },
          {
            startQuest = "17688039119811183",
            startPort = "Out",
            endQuest = "177313156223219123346",
            endPort = "In"
          },
          {
            startQuest = "1770210609833554",
            startPort = "Out",
            endQuest = "177313210297022502289",
            endPort = "In"
          },
          {
            startQuest = "17730550603324960138",
            startPort = "Out",
            endQuest = "177313211204922502578",
            endPort = "In"
          },
          {
            startQuest = "177313211204922502578",
            startPort = "Out",
            endQuest = "17678537949071014373",
            endPort = "Fail"
          },
          {
            startQuest = "17678537949071014371",
            startPort = "QuestStart",
            endQuest = "1773300783630851789",
            endPort = "In"
          },
          {
            startQuest = "17688039119811183",
            startPort = "Out",
            endQuest = "1773840453499423",
            endPort = "In"
          },
          {
            startQuest = "177313210297022502289",
            startPort = "Out",
            endQuest = "1773840461258699",
            endPort = "In"
          },
          {
            startQuest = "1773840461258699",
            startPort = "Out",
            endQuest = "1768803794819264",
            endPort = "In"
          },
          {
            startQuest = "1773840453499423",
            startPort = "Out",
            endQuest = "17738405519221310",
            endPort = "In"
          },
          {
            startQuest = "17688039119811183",
            startPort = "Out",
            endQuest = "17742800748982539176",
            endPort = "In"
          },
          {
            startQuest = "17742800748982539176",
            startPort = "Out",
            endQuest = "17742800687082538984",
            endPort = "In"
          },
          {
            startQuest = "1773300783630851789",
            startPort = "Out",
            endQuest = "1774950949517988",
            endPort = "Input"
          }
        },
        nodeData = {
          ["17678537949071014371"] = {
            key = "17678537949071014371",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17678537949071014372"] = {
            key = "17678537949071014372",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2967.5, y = 302.5},
            propsData = {ModeType = 0}
          },
          ["17678537949071014373"] = {
            key = "17678537949071014373",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2420.5194805194806, y = 727.1428571428571},
            propsData = {}
          },
          ["1768803794819264"] = {
            key = "1768803794819264",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2707.8978127136024, y = 304.6838687628161},
            propsData = {}
          },
          ["1768803857700490"] = {
            key = "1768803857700490",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1536.2203457959013, y = 685.7214510982956},
            propsData = {}
          },
          ["17688039119811183"] = {
            key = "17688039119811183",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1215.6596830748897, y = 302.326061340019},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Defense_Start",
              UnitId = -1
            }
          },
          ["1770190752480696"] = {
            key = "1770190752480696",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 2138.1593836353927, y = -27.87072798001919},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "12020402fangshou_Start",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1770210602992298"] = {
            key = "1770210602992298",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 1910.8938969527205, y = 289.87462863933456},
            propsData = {
              KillMonsterType = "Nums",
              MonsterNeedNums = 50,
              IsShow = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1770210609833554"] = {
            key = "1770210609833554",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2148.608182667006, y = 314.7317714964774},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Defense_Finish",
              UnitId = -1
            }
          },
          ["17730550603324960138"] = {
            key = "17730550603324960138",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1853.0818572556475, y = 718.2102210359162},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Defense_Finish",
              UnitId = -1
            }
          },
          ["177313156223219123346"] = {
            key = "177313156223219123346",
            type = "ChangeStaticCreatorNode",
            name = "生成空气墙",
            pos = {x = 1503.5008902835182, y = -79.9699781909134},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                162360054,
                162360015,
                162360016,
                162360017,
                162360018,
                162360019,
                162360020,
                162360021,
                162360022
              }
            }
          },
          ["177313210297022502289"] = {
            key = "177313210297022502289",
            type = "ChangeStaticCreatorNode",
            name = "生成空气墙",
            pos = {x = 2444.7026049398173, y = 306.2276430943311},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                162360054,
                162360015,
                162360016,
                162360017,
                162360018,
                162360019,
                162360020,
                162360021,
                162360022
              }
            }
          },
          ["177313211204922502578"] = {
            key = "177313211204922502578",
            type = "ChangeStaticCreatorNode",
            name = "生成空气墙",
            pos = {x = 2090.3713571021976, y = 703.0958741885743},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                162360054,
                162360015,
                162360016,
                162360017,
                162360018,
                162360019,
                162360020,
                162360021,
                162360022
              }
            }
          },
          ["1773300783630851789"] = {
            key = "1773300783630851789",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1164, y = 26.00000000000003},
            propsData = {QuestRoleId = 24010102, IsPlayFX = false}
          },
          ["1773840453499423"] = {
            key = "1773840453499423",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 1516.6362787539258, y = -245.1184377571844},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {242360068}
            }
          },
          ["1773840461258699"] = {
            key = "1773840461258699",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 2540.863636363637, y = 37.15513833992105},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {242360069}
            }
          },
          ["17738405519221310"] = {
            key = "17738405519221310",
            type = "SetPhantomStatusNode",
            name = "刻舟魅影Buff",
            pos = {x = 1807.7433089223155, y = -225.95410535755784},
            propsData = {
              PhantomRoleId = 213,
              BuffList = {
                {
                  Id = 903,
                  LastTime = -1,
                  Value = -1
                }
              }
            }
          },
          ["17742800687082538984"] = {
            key = "17742800687082538984",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1922.306364026784, y = 98.58837624998948},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 12049072,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17742800748982539176"] = {
            key = "17742800748982539176",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1640.5206497410695, y = 125.37409053570371},
            propsData = {WaitTime = 1}
          },
          ["1774950949517988"] = {
            key = "1774950949517988",
            type = "UnEquipEffectPropNode",
            name = "卸载当前装备的探索道具",
            pos = {x = 1232.4887556221888, y = -138.7263624597959},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
