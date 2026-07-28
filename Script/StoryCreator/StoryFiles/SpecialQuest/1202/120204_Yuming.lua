return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17678537949081014512",
      startPort = "StoryStart",
      endStory = "17678537949081014514",
      endPort = "In"
    },
    {
      startStory = "17678537949081014514",
      startPort = "Success",
      endStory = "17678537949081014513",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17678537949081014512"] = {
      isStoryNode = true,
      key = "17678537949081014512",
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
    ["17678537949081014513"] = {
      isStoryNode = true,
      key = "17678537949081014513",
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
    ["17678537949081014514"] = {
      isStoryNode = true,
      key = "17678537949081014514",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1426.4444444444443, y = 350.8888888888889},
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
            startQuest = "17678537949081014515",
            startPort = "QuestStart",
            endQuest = "1767962210862728205",
            endPort = "In"
          },
          {
            startQuest = "17678537949081014515",
            startPort = "QuestStart",
            endQuest = "1770192777622845",
            endPort = "In"
          },
          {
            startQuest = "1770192777622845",
            startPort = "Out",
            endQuest = "1770192753871689",
            endPort = "In"
          },
          {
            startQuest = "1770192753871689",
            startPort = "Out",
            endQuest = "1772442106668794921",
            endPort = "In"
          },
          {
            startQuest = "1772442106668794921",
            startPort = "Out",
            endQuest = "17725191337011137",
            endPort = "In"
          },
          {
            startQuest = "1770192777622845",
            startPort = "Out",
            endQuest = "177313190777819968417",
            endPort = "In"
          },
          {
            startQuest = "17725191337011137",
            startPort = "Out",
            endQuest = "177313205953721657238",
            endPort = "In"
          },
          {
            startQuest = "1767962210862728205",
            startPort = "Out",
            endQuest = "177313207349521657723",
            endPort = "In"
          },
          {
            startQuest = "17678537949081014515",
            startPort = "QuestStart",
            endQuest = "17733008049981701563",
            endPort = "In"
          },
          {
            startQuest = "1770192777622845",
            startPort = "Out",
            endQuest = "17738406568401775",
            endPort = "In"
          },
          {
            startQuest = "17738406568401775",
            startPort = "Out",
            endQuest = "17738406468951613",
            endPort = "In"
          },
          {
            startQuest = "1770192753871689",
            startPort = "Out",
            endQuest = "17739916088481057",
            endPort = "In"
          },
          {
            startQuest = "17739916088481057",
            startPort = "Out",
            endQuest = "17725191337011137",
            endPort = "In"
          },
          {
            startQuest = "17742799429681693940",
            startPort = "Out",
            endQuest = "17742799291441693538",
            endPort = "In"
          },
          {
            startQuest = "1770192753871689",
            startPort = "Out",
            endQuest = "17742799429681693940",
            endPort = "In"
          },
          {
            startQuest = "17678537949081014515",
            startPort = "QuestStart",
            endQuest = "17746776799071282954",
            endPort = "In"
          },
          {
            startQuest = "177313205953721657238",
            startPort = "Out",
            endQuest = "17746777114031283198",
            endPort = "In"
          },
          {
            startQuest = "17746777114031283198",
            startPort = "Out",
            endQuest = "1767962203750727967",
            endPort = "In"
          },
          {
            startQuest = "17746777211451283480",
            startPort = "Out",
            endQuest = "17678537949081014517",
            endPort = "Fail"
          },
          {
            startQuest = "177313207349521657723",
            startPort = "Out",
            endQuest = "17746777211451283480",
            endPort = "In"
          },
          {
            startQuest = "17733008049981701563",
            startPort = "Out",
            endQuest = "1774950985008854293",
            endPort = "Input"
          }
        },
        nodeData = {
          ["17678537949081014515"] = {
            key = "17678537949081014515",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17678537949081014516"] = {
            key = "17678537949081014516",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17678537949081014517"] = {
            key = "17678537949081014517",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2133.9, y = 745.9115384615384},
            propsData = {}
          },
          ["1767962203750727967"] = {
            key = "1767962203750727967",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2945.5111505815935, y = 755.9734572013662},
            propsData = {}
          },
          ["1767962210862728205"] = {
            key = "1767962210862728205",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1329.0258483837913, y = 825.0320431047103},
            propsData = {}
          },
          ["1770192753871689"] = {
            key = "1770192753871689",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1527.2212854136458, y = 346.9489007949005},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {242360082}
            }
          },
          ["1770192777622845"] = {
            key = "1770192777622845",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1267.023916992593, y = 305.3893912255226},
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
          ["17701927963481127"] = {
            key = "17701927963481127",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 2256.2789479523453, y = -22.494791155563945},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 1,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {162360055}
            }
          },
          ["1772442106668794921"] = {
            key = "1772442106668794921",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = 1829.3523018845026, y = 513.2118230100637},
            propsData = {
              SendMessage = "",
              FinishCondition = "Yuming_HalfHealth"
            }
          },
          ["17725191337011137"] = {
            key = "17725191337011137",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2228.8259550715866, y = 344.29674642181214},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {242360082}
            }
          },
          ["177313190777819968417"] = {
            key = "177313190777819968417",
            type = "ChangeStaticCreatorNode",
            name = "生成空气墙",
            pos = {x = 1611.154616240267, y = 145.64627363737486},
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
          ["177313202957421656802"] = {
            key = "177313202957421656802",
            type = "ChangeStaticCreatorNode",
            name = "生成钩锁点",
            pos = {x = 1973.6336546580355, y = -363.86630288078413},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                162360008,
                162360009,
                162360011,
                162360012,
                162360013
              }
            }
          },
          ["177313205953721657238"] = {
            key = "177313205953721657238",
            type = "ChangeStaticCreatorNode",
            name = "生成空气墙",
            pos = {x = 2387.3561390006507, y = 462.65117054068253},
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
          ["177313205953721657239"] = {
            key = "177313205953721657239",
            type = "ChangeStaticCreatorNode",
            name = "生成钩锁点",
            pos = {x = 2515.706088116916, y = 270.5789123249109},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                162360008,
                162360009,
                162360011,
                162360012,
                162360013
              }
            }
          },
          ["177313207349521657723"] = {
            key = "177313207349521657723",
            type = "ChangeStaticCreatorNode",
            name = "生成空气墙",
            pos = {x = 1624.2506561214607, y = 852.8905755322427},
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
          ["177313207349521657724"] = {
            key = "177313207349521657724",
            type = "ChangeStaticCreatorNode",
            name = "生成钩锁点",
            pos = {x = 1166.5566491937702, y = 1002.6864491846029},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                162360008,
                162360009,
                162360011,
                162360012,
                162360013
              }
            }
          },
          ["17733008049981701563"] = {
            key = "17733008049981701563",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1060.1962864721486, y = 105.24137931034485},
            propsData = {QuestRoleId = 24010102, IsPlayFX = false}
          },
          ["17738406468951613"] = {
            key = "17738406468951613",
            type = "SetPhantomStatusNode",
            name = "刻舟魅影Buff",
            pos = {x = 1872.8051320276825, y = -148.10589692622358},
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
          ["17738406568401775"] = {
            key = "17738406568401775",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 1573.3244785815114, y = -158.5492466799181},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {242360068}
            }
          },
          ["17739916088481057"] = {
            key = "17739916088481057",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1836.4150326797385, y = 311.5262297901619},
            propsData = {WaitTime = 120}
          },
          ["17742799291441693538"] = {
            key = "17742799291441693538",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2242.883460249088, y = 120.99439096447436},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 12049076,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17742799429681693940"] = {
            key = "17742799429681693940",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1909.572549192181, y = 144.07903401021588},
            propsData = {WaitTime = 5}
          },
          ["17746776799071282954"] = {
            key = "17746776799071282954",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 970.8195052906445, y = -56.57207462286179},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "YuMingBoss_Start",
              UnitId = -1
            }
          },
          ["17746777114031283198"] = {
            key = "17746777114031283198",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2653.5101183174647, y = 581.5725024475774},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "YuMingBoss_Finish",
              UnitId = -1
            }
          },
          ["17746777211451283480"] = {
            key = "17746777211451283480",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1927.2601183174645, y = 942.8225024475773},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "YuMingBoss_Finish",
              UnitId = -1
            }
          },
          ["1774950985008854293"] = {
            key = "1774950985008854293",
            type = "UnEquipEffectPropNode",
            name = "卸载当前装备的探索道具",
            pos = {x = 1323.4927878884403, y = 93.43977086964333},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
