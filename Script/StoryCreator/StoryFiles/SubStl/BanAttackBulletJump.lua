return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17817661833101",
      startPort = "StoryStart",
      endStory = "1781766203334232",
      endPort = "In"
    },
    {
      startStory = "1781766203334232",
      startPort = "Success",
      endStory = "17817661833105",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17817661833101"] = {
      isStoryNode = true,
      key = "17817661833101",
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
    ["17817661833105"] = {
      isStoryNode = true,
      key = "17817661833105",
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
    ["1781766203334232"] = {
      isStoryNode = true,
      key = "1781766203334232",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1788, y = 282},
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
            startQuest = "1781766238623749",
            startPort = "Out",
            endQuest = "17817662594411164",
            endPort = "Input_1"
          },
          {
            startQuest = "1781766238623750",
            startPort = "Out",
            endQuest = "17817662594411164",
            endPort = "Input_2"
          },
          {
            startQuest = "17817662594411164",
            startPort = "Out",
            endQuest = "1781766203335241",
            endPort = "Success"
          },
          {
            startQuest = "1781766203334233",
            startPort = "QuestStart",
            endQuest = "1781766238623749",
            endPort = "In"
          },
          {
            startQuest = "1781766203334233",
            startPort = "QuestStart",
            endQuest = "1781766238623750",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781766203334233"] = {
            key = "1781766203334233",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781766203335241"] = {
            key = "1781766203335241",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2723.684208483357, y = 405.2631607126112},
            propsData = {ModeType = 0}
          },
          ["1781766203335249"] = {
            key = "1781766203335249",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1781766238623749"] = {
            key = "1781766238623749",
            type = "ForbidWeaponByWeaponTagNode",
            name = "禁用/启用武器节点",
            pos = {x = 1795.3025217655127, y = 311.1533414884814},
            propsData = {
              WeaponTags = {"Melee", "Ranged"},
              bForbid = true,
              ForbidTag = "ForbidDefault",
              bHidewhenForbid = true
            }
          },
          ["1781766238623750"] = {
            key = "1781766238623750",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 1814.9363473468115, y = 457.2050046906445},
            propsData = {
              PlayerId = 0,
              bActiveEnable = false,
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
          ["17817662594411164"] = {
            key = "17817662594411164",
            type = "WaitQuestFinishedNode",
            name = "等待任务完成",
            pos = {x = 2347.3684196436943, y = 396.10526562353476},
            propsData = {ListenCount = 2, NeedFinishCount = 2}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
