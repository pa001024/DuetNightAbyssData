local T = {}
T.RT_1 = {"LB", "RS"}
T.RT_2 = {"B", "LS"}
T.RT_3 = {"X"}
T.RT_4 = {"RB"}
T.RT_5 = {"B"}
T.RT_6 = {"A"}
T.RT_7 = {"LS"}
T.RT_8 = {
  [1] = "DownSelect",
  [2] = "DownSelect",
  [3] = "DownSelect",
  [4] = "DownSelect"
}
T.RT_9 = {"LB", "Down"}
T.RT_10 = {"B", "Down"}
T.RT_11 = {
  [1] = T.RT_9,
  [2] = T.RT_9,
  [3] = T.RT_10,
  [4] = T.RT_10
}
T.RT_12 = {
  [1] = "UpSelect",
  [2] = "UpSelect",
  [3] = "UpSelect",
  [4] = "UpSelect"
}
T.RT_13 = {"LB", "Up"}
T.RT_14 = {"B", "Up"}
T.RT_15 = {
  [1] = T.RT_13,
  [2] = T.RT_13,
  [3] = T.RT_14,
  [4] = T.RT_14
}
T.RT_16 = {"LT"}
T.RT_17 = {
  [1] = T.RT_16,
  [2] = T.RT_16,
  [3] = T.RT_16,
  [4] = T.RT_16
}
T.RT_18 = {
  [1] = "LeftTrigger",
  [2] = "LeftTrigger",
  [3] = "LeftTrigger",
  [4] = "LeftTrigger"
}
T.RT_19 = {"RT"}
T.RT_20 = {
  [1] = T.RT_19,
  [2] = T.RT_19,
  [3] = T.RT_19,
  [4] = T.RT_19
}
T.RT_21 = {
  [1] = "RightTrigger",
  [2] = "RightTrigger",
  [3] = "RightTrigger",
  [4] = "RightTrigger"
}
T.RT_22 = {
  [1] = "Fire",
  [2] = "Fire",
  [3] = "Fire",
  [4] = "Fire"
}
T.RT_23 = {"LB", "RT"}
T.RT_24 = {"B", "RT"}
T.RT_25 = {"Down"}
T.RT_26 = {
  [1] = T.RT_25,
  [2] = T.RT_25,
  [3] = T.RT_25,
  [4] = T.RT_25
}
T.RT_27 = {
  [1] = "DPad_Down",
  [2] = "DPad_Down",
  [3] = "DPad_Down",
  [4] = "DPad_Down"
}
T.RT_28 = {"Right"}
T.RT_29 = {
  [1] = T.RT_28,
  [2] = T.RT_28,
  [3] = T.RT_28,
  [4] = T.RT_28
}
T.RT_30 = {
  [1] = "DPad_Right",
  [2] = "DPad_Right",
  [3] = "DPad_Right",
  [4] = "DPad_Right"
}
T.RT_31 = {"LB"}
T.RT_32 = {"Y"}
T.RT_33 = {
  [1] = T.RT_32,
  [2] = T.RT_32,
  [3] = T.RT_32,
  [4] = T.RT_32
}
T.RT_34 = {
  [1] = "FaceButton_Top",
  [2] = "FaceButton_Top",
  [3] = "FaceButton_Top",
  [4] = "FaceButton_Top"
}
T.RT_35 = {"LB", "Right"}
T.RT_36 = {"B", "Right"}
T.RT_37 = {"RS"}
T.RT_38 = {"Right", "X"}
T.RT_39 = {"Right", "B"}
T.RT_40 = {
  [1] = T.RT_39,
  [2] = T.RT_39,
  [3] = T.RT_39,
  [4] = T.RT_39
}
T.RT_41 = {"Right", "LB"}
T.RT_42 = {"Right", "Menu"}
T.RT_43 = {"View"}
T.RT_44 = {
  [1] = T.RT_43,
  [2] = T.RT_43,
  [3] = T.RT_43,
  [4] = T.RT_43
}
T.RT_45 = {"Right", "Y"}
T.RT_46 = {"Right", "RT"}
T.RT_47 = {"Right", "RB"}
T.RT_48 = {"LB", "Left"}
T.RT_49 = {"B", "Left"}
T.RT_50 = {
  [1] = "Special_Left",
  [2] = "Special_Left",
  [3] = "Special_Left",
  [4] = "Special_Left"
}
T.RT_51 = {"Menu"}
T.RT_52 = {"Right", "A"}
T.RT_53 = {
  [1] = T.RT_52,
  [2] = T.RT_52,
  [3] = T.RT_52,
  [4] = T.RT_52
}
T.RT_54 = {
  [1] = "Jump",
  [2] = "Jump",
  [3] = "Avoid",
  [4] = "Jump"
}
T.RT_55 = {"Right", "LT"}
T.RT_56 = {
  [1] = "OpenBattleWheel",
  [2] = "OpenBattleWheel",
  [3] = "OpenBattleWheel",
  [4] = "OpenBattleWheel"
}
T.RT_57 = {"Right", "RS"}
T.RT_58 = {"LB", "A"}
T.RT_59 = {"B", "A"}
T.RT_60 = {"Left"}
T.RT_61 = {
  [1] = T.RT_60,
  [2] = T.RT_60,
  [3] = T.RT_60,
  [4] = T.RT_60
}
T.RT_62 = {
  [1] = "DPad_Left",
  [2] = "DPad_Left",
  [3] = "DPad_Left",
  [4] = "DPad_Left"
}
T.RT_63 = {"LB", "X"}
T.RT_64 = {"B", "LB"}
T.RT_65 = {"LB", "Y"}
T.RT_66 = {"B", "RB"}
T.RT_67 = {"LB", "B"}
T.RT_68 = {"B", "Y"}
T.RT_69 = {
  [1] = T.RT_6,
  [2] = T.RT_6,
  [3] = T.RT_6,
  [4] = T.RT_6
}
T.RT_70 = {
  [1] = "FaceButton_Bottom",
  [2] = "FaceButton_Bottom",
  [3] = "FaceButton_Bottom",
  [4] = "FaceButton_Bottom"
}
T.RT_71 = {
  [1] = T.RT_5,
  [2] = T.RT_5,
  [3] = T.RT_5,
  [4] = T.RT_5
}
T.RT_72 = {
  [1] = "FaceButton_Right",
  [2] = "FaceButton_Right",
  [3] = "FaceButton_Right",
  [4] = "FaceButton_Right"
}
T.RT_73 = {"LB", "LT"}
T.RT_74 = {"B", "LT"}
T.RT_75 = {"Up"}
T.RT_76 = {
  [1] = T.RT_75,
  [2] = T.RT_75,
  [3] = T.RT_75,
  [4] = T.RT_75
}
T.RT_77 = {
  [1] = "DPad_Up",
  [2] = "DPad_Up",
  [3] = "DPad_Up",
  [4] = "DPad_Up"
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GamepadMap", {
  ActiveGuide = {
    ActionName = "ActiveGuide",
    BattleInput = {
      [1] = "LockMonster",
      [2] = "LockMonster",
      [3] = "BulletJump",
      [4] = "BulletJump"
    },
    GamepadIcon = {
      [1] = T.RT_1,
      [2] = T.RT_1,
      [3] = T.RT_2,
      [4] = T.RT_2
    }
  },
  Attack = {
    ActionName = "Attack",
    GamepadIcon = {
      [1] = T.RT_3,
      [2] = T.RT_4,
      [3] = T.RT_3,
      [4] = T.RT_3
    },
    GamepadKey = {
      [1] = "FaceButton_Left",
      [2] = "RightShoulder",
      [3] = "FaceButton_Left",
      [4] = "FaceButton_Left"
    }
  },
  Avoid = {
    ActionName = "Avoid",
    GamepadIcon = {
      [1] = T.RT_5,
      [2] = T.RT_5,
      [3] = T.RT_6,
      [4] = T.RT_4
    },
    GamepadKey = {
      [1] = "FaceButton_Right",
      [2] = "FaceButton_Right",
      [3] = "FaceButton_Bottom",
      [4] = "RightShoulder"
    }
  },
  BulletJump = {
    ActionName = "BulletJump",
    GamepadIcon = {
      [1] = T.RT_7,
      [2] = T.RT_7,
      [3] = T.RT_7,
      [4] = T.RT_7
    },
    GamepadKey = {
      [1] = "LeftThumbstick",
      [2] = "LeftThumbstick",
      [3] = "LeftThumbstick",
      [4] = "LeftThumbstick"
    }
  },
  ChangeCameraLengthDown = {
    ActionName = "ChangeCameraLengthDown",
    BattleInput = T.RT_8,
    GamepadIcon = T.RT_11
  },
  ChangeCameraLengthUp = {
    ActionName = "ChangeCameraLengthUp",
    BattleInput = T.RT_12,
    GamepadIcon = T.RT_15
  },
  ChangeSlideMechLeft = {
    ActionName = "ChangeSlideMechLeft",
    GamepadIcon = T.RT_17,
    GamepadKey = T.RT_18
  },
  ChangeSlideMechRight = {
    ActionName = "ChangeSlideMechRight",
    GamepadIcon = T.RT_20,
    GamepadKey = T.RT_21
  },
  ChargeBullet = {
    ActionName = "ChargeBullet",
    BattleInput = T.RT_22,
    GamepadIcon = {
      [1] = T.RT_23,
      [2] = T.RT_23,
      [3] = T.RT_24,
      [4] = T.RT_24
    }
  },
  DownSelect = {
    ActionName = "DownSelect",
    GamepadIcon = T.RT_26,
    GamepadKey = T.RT_27
  },
  Fire = {
    ActionName = "Fire",
    GamepadIcon = T.RT_20,
    GamepadKey = T.RT_21
  },
  GamepadOpenSystem = {
    ActionName = "GamepadOpenSystem",
    GamepadIcon = T.RT_29,
    GamepadKey = T.RT_30
  },
  GamepadUseSkill = {
    ActionName = "GamepadUseSkill",
    GamepadIcon = {
      [1] = T.RT_31,
      [2] = T.RT_31,
      [3] = T.RT_5,
      [4] = T.RT_5
    },
    GamepadKey = {
      [1] = "LeftShoulder",
      [2] = "LeftShoulder",
      [3] = "FaceButton_Right",
      [4] = "FaceButton_Right"
    }
  },
  Interactive = {
    ActionName = "Interactive",
    GamepadIcon = T.RT_33,
    GamepadKey = T.RT_34
  },
  ItemDetail = {
    ActionName = "ItemDetail",
    BattleInput = {
      [1] = "GamepadOpenSystem",
      [2] = "GamepadOpenSystem",
      [3] = "GamepadOpenSystem",
      [4] = "GamepadOpenSystem"
    },
    GamepadIcon = {
      [1] = T.RT_35,
      [2] = T.RT_35,
      [3] = T.RT_36,
      [4] = T.RT_36
    }
  },
  Jump = {
    ActionName = "Jump",
    GamepadIcon = {
      [1] = T.RT_6,
      [2] = T.RT_6,
      [3] = T.RT_4,
      [4] = T.RT_6
    },
    GamepadKey = {
      [1] = "FaceButton_Bottom",
      [2] = "FaceButton_Bottom",
      [3] = "RightShoulder",
      [4] = "FaceButton_Bottom"
    }
  },
  LeaveCannon = {
    ActionName = "LeaveCannon",
    GamepadIcon = T.RT_33,
    GamepadKey = T.RT_34
  },
  LockMonster = {
    ActionName = "LockMonster",
    GamepadIcon = {
      [1] = T.RT_37,
      [2] = T.RT_37,
      [3] = T.RT_37,
      [4] = T.RT_37
    },
    GamepadKey = {
      [1] = "RightThumbstick",
      [2] = "RightThumbstick",
      [3] = "RightThumbstick",
      [4] = "RightThumbstick"
    }
  },
  OpenArmory = {
    ActionName = "OpenArmory",
    GamepadIcon = {
      [1] = T.RT_38,
      [2] = T.RT_38,
      [3] = T.RT_38,
      [4] = T.RT_38
    },
    SystemInput = {
      [1] = "Attack",
      [2] = "Slide",
      [3] = "Attack",
      [4] = "Attack"
    }
  },
  OpenBag = {
    ActionName = "OpenBag",
    GamepadIcon = T.RT_40,
    SystemInput = {
      [1] = "Avoid",
      [2] = "Avoid",
      [3] = "GamepadUseSkill",
      [4] = "GamepadUseSkill"
    }
  },
  OpenBattlePass = {
    ActionName = "OpenBattlePass",
    GamepadIcon = {
      [1] = T.RT_41,
      [2] = T.RT_41,
      [3] = T.RT_41,
      [4] = T.RT_41
    },
    SystemInput = {
      [1] = "GamepadUseSkill",
      [2] = "GamepadUseSkill",
      [3] = "Slide",
      [4] = "Slide"
    }
  },
  OpenBattleWheel = {
    ActionName = "OpenBattleWheel",
    GamepadIcon = T.RT_17,
    GamepadKey = T.RT_18
  },
  OpenCamera = {
    ActionName = "OpenCamera",
    GamepadIcon = {
      [1] = T.RT_42,
      [2] = T.RT_42,
      [3] = T.RT_42,
      [4] = T.RT_42
    },
    SystemInput = {
      [1] = "OpenMenu",
      [2] = "OpenMenu",
      [3] = "OpenMenu",
      [4] = "OpenMenu"
    }
  },
  OpenChat = {
    ActionName = "OpenChat",
    GamepadIcon = T.RT_44
  },
  OpenEvent = {
    ActionName = "OpenEvent",
    GamepadIcon = {
      [1] = T.RT_45,
      [2] = T.RT_45,
      [3] = T.RT_45,
      [4] = T.RT_45
    },
    SystemInput = {
      [1] = "Interactive",
      [2] = "Interactive",
      [3] = "Interactive",
      [4] = "Interactive"
    }
  },
  OpenForge = {
    ActionName = "OpenForge",
    GamepadIcon = {
      [1] = T.RT_46,
      [2] = T.RT_46,
      [3] = T.RT_46,
      [4] = T.RT_46
    },
    SystemInput = T.RT_22
  },
  OpenGacha = {
    ActionName = "OpenGacha",
    GamepadIcon = {
      [1] = T.RT_47,
      [2] = T.RT_47,
      [3] = T.RT_47,
      [4] = T.RT_47
    },
    SystemInput = {
      [1] = "Slide",
      [2] = "Attack",
      [3] = "Jump",
      [4] = "Avoid"
    }
  },
  OpenGuideBook = {
    ActionName = "OpenGuideBook",
    BattleInput = {
      [1] = "ShowTeamInfo",
      [2] = "ShowTeamInfo",
      [3] = "ShowTeamInfo",
      [4] = "ShowTeamInfo"
    },
    GamepadIcon = {
      [1] = T.RT_48,
      [2] = T.RT_48,
      [3] = T.RT_49,
      [4] = T.RT_49
    }
  },
  OpenMap = {
    ActionName = "OpenMap",
    GamepadIcon = T.RT_44,
    GamepadKey = T.RT_50
  },
  OpenMenu = {
    ActionName = "OpenMenu",
    GamepadIcon = {
      [1] = T.RT_51,
      [2] = T.RT_51,
      [3] = T.RT_51,
      [4] = T.RT_51
    },
    GamepadKey = {
      [1] = "Special_Right",
      [2] = "Special_Right",
      [3] = "Special_Right",
      [4] = "Special_Right"
    }
  },
  OpenPlay = {
    ActionName = "OpenPlay",
    GamepadIcon = T.RT_53,
    SystemInput = T.RT_54
  },
  OpenTask = {
    ActionName = "OpenTask",
    GamepadIcon = {
      [1] = T.RT_55,
      [2] = T.RT_55,
      [3] = T.RT_55,
      [4] = T.RT_55
    },
    SystemInput = T.RT_56
  },
  OpenTeamHall = {
    ActionName = "OpenTeamHall",
    GamepadIcon = {
      [1] = T.RT_57,
      [2] = T.RT_57,
      [3] = T.RT_57,
      [4] = T.RT_57
    },
    SystemInput = {
      [1] = "LockMonster",
      [2] = "LockMonster",
      [3] = "LockMonster",
      [4] = "LockMonster"
    }
  },
  PreAim = {
    ActionName = "PreAim",
    BattleInput = T.RT_54,
    GamepadIcon = {
      [1] = T.RT_58,
      [2] = T.RT_58,
      [3] = T.RT_59,
      [4] = T.RT_59
    }
  },
  Recovery = {
    ActionName = "Recovery",
    GamepadIcon = T.RT_33,
    GamepadKey = T.RT_34
  },
  RougeOpenBag = {
    ActionName = "RougeOpenBag",
    GamepadIcon = T.RT_29,
    GamepadKey = T.RT_30
  },
  ShowTeamInfo = {
    ActionName = "ShowTeamInfo",
    GamepadIcon = T.RT_61,
    GamepadKey = T.RT_62
  },
  Skill1 = {
    ActionName = "Skill1",
    BattleInput = {
      [1] = "Attack",
      [2] = "Slide",
      [3] = "Slide",
      [4] = "Slide"
    },
    GamepadIcon = {
      [1] = T.RT_63,
      [2] = T.RT_63,
      [3] = T.RT_64,
      [4] = T.RT_64
    }
  },
  Skill2 = {
    ActionName = "Skill2",
    BattleInput = {
      [1] = "Interactive",
      [2] = "Interactive",
      [3] = "Jump",
      [4] = "Avoid"
    },
    GamepadIcon = {
      [1] = T.RT_65,
      [2] = T.RT_65,
      [3] = T.RT_66,
      [4] = T.RT_66
    }
  },
  Skill3 = {
    ActionName = "Skill3",
    BattleInput = {
      [1] = "Avoid",
      [2] = "Avoid",
      [3] = "Interactive",
      [4] = "Interactive"
    },
    GamepadIcon = {
      [1] = T.RT_67,
      [2] = T.RT_67,
      [3] = T.RT_68,
      [4] = T.RT_68
    }
  },
  Slide = {
    ActionName = "Slide",
    GamepadIcon = {
      [1] = T.RT_4,
      [2] = T.RT_3,
      [3] = T.RT_31,
      [4] = T.RT_31
    },
    GamepadKey = {
      [1] = "RightShoulder",
      [2] = "FaceButton_Left",
      [3] = "LeftShoulder",
      [4] = "LeftShoulder"
    }
  },
  SlideMechTurn = {
    ActionName = "SlideMechTurn",
    GamepadIcon = T.RT_26,
    GamepadKey = T.RT_27
  },
  StoryInteractive = {
    ActionName = "StoryInteractive",
    GamepadIcon = T.RT_69,
    GamepadKey = T.RT_70
  },
  StoryInteractiveClose = {
    ActionName = "StoryInteractiveClose",
    GamepadIcon = T.RT_71,
    GamepadKey = T.RT_72
  },
  SwitchWalk = {
    ActionName = "SwitchWalk",
    BattleInput = T.RT_56,
    GamepadIcon = {
      [1] = T.RT_73,
      [2] = T.RT_73,
      [3] = T.RT_74,
      [4] = T.RT_74
    }
  },
  TalkAutoPlay = {
    ActionName = "TalkAutoPlay",
    GamepadIcon = T.RT_33,
    GamepadKey = T.RT_34
  },
  TalkClick = {
    ActionName = "TalkClick",
    GamepadIcon = T.RT_69,
    GamepadKey = T.RT_70
  },
  TalkDownSelect = {
    ActionName = "TalkDownSelect",
    GamepadIcon = T.RT_26,
    GamepadKey = T.RT_27
  },
  TalkExit = {
    ActionName = "TalkExit",
    GamepadIcon = T.RT_71,
    GamepadKey = T.RT_72
  },
  TalkOption = {
    ActionName = "TalkOption",
    GamepadIcon = T.RT_69,
    GamepadKey = T.RT_70
  },
  TalkReview = {
    ActionName = "TalkReview",
    GamepadIcon = T.RT_44,
    GamepadKey = T.RT_50
  },
  TalkSkip = {
    ActionName = "TalkSkip",
    GamepadIcon = T.RT_69,
    GamepadKey = T.RT_70
  },
  TalkUpSelect = {
    ActionName = "TalkUpSelect",
    GamepadIcon = T.RT_76,
    GamepadKey = T.RT_77
  },
  TalkWiki = {
    ActionName = "TalkWiki",
    GamepadIcon = T.RT_29,
    GamepadKey = T.RT_30
  },
  TrainingCharacterSkills = {
    ActionName = "TrainingCharacterSkills",
    GamepadIcon = T.RT_76,
    GamepadKey = T.RT_77
  },
  TrainingInvincible = {
    ActionName = "TrainingInvincible",
    GamepadIcon = T.RT_26,
    GamepadKey = T.RT_27
  },
  TrainingKillMonsters = {
    ActionName = "TrainingKillMonsters",
    GamepadIcon = T.RT_40,
    SystemInput = {
      [1] = "StoryInteractiveClose",
      [2] = "StoryInteractiveClose",
      [3] = "StoryInteractiveClose",
      [4] = "StoryInteractiveClose"
    }
  },
  TrainingMonstersActive = {
    ActionName = "TrainingMonstersActive",
    GamepadIcon = T.RT_53,
    SystemInput = {
      [1] = "StoryInteractive",
      [2] = "StoryInteractive",
      [3] = "StoryInteractive",
      [4] = "StoryInteractive"
    }
  },
  TrainingOpenSetup = {
    ActionName = "TrainingOpenSetup",
    GamepadIcon = T.RT_61,
    GamepadKey = T.RT_62
  },
  UpSelect = {
    ActionName = "UpSelect",
    GamepadIcon = T.RT_76,
    GamepadKey = T.RT_77
  },
  ZoomInputDown = {
    ActionName = "ZoomInputDown",
    BattleInput = T.RT_8,
    GamepadIcon = T.RT_11
  },
  ZoomInputUp = {
    ActionName = "ZoomInputUp",
    BattleInput = T.RT_12,
    GamepadIcon = T.RT_15
  }
})
