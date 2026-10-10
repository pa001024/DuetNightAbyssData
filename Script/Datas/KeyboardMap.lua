local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("KeyboardMap", {
  A = {
    ActionName = "A",
    ActionNameText = "UI_Keyboard_Map_A",
    AxisActionName = "MoveRight",
    CanChanged = true,
    IsShowInSetting = true,
    Key = "A",
    Scale = "-1",
    SortId = 44
  },
  ActiveGuide = {
    ActionName = "ActiveGuide",
    ActionNameText = "UI_Keyboard_Map_ActiveGuide",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "V",
    SortId = 38
  },
  Attack = {
    ActionName = "Attack",
    ActionNameText = "UI_Keyboard_Map_Attack",
    CanChanged = true,
    GamePadKey = "LeftMouseButton",
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "LeftMouseButton",
    SortId = 1
  },
  Avoid = {
    ActionName = "Avoid",
    ActionNameText = "UI_Keyboard_Map_Avoid",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "LeftShift",
    SortId = 9
  },
  BulletJump = {
    ActionName = "BulletJump",
    ActionNameText = "UI_CTL_BulletJump",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "Four",
    SortId = 10
  },
  ChangeCameraLengthDown = {
    ActionName = "ChangeCameraLengthDown",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "MouseScrollDown",
    SortId = 49
  },
  ChangeCameraLengthUp = {
    ActionName = "ChangeCameraLengthUp",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "MouseScrollUp",
    SortId = 50
  },
  ChangeSlideMechLeft = {
    ActionName = "ChangeSlideMechLeft",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "A",
    SortId = 72
  },
  ChangeSlideMechRight = {
    ActionName = "ChangeSlideMechRight",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "D",
    SortId = 73
  },
  ChargeBullet = {
    ActionName = "ChargeBullet",
    ActionNameText = "UI_Keyboard_Map_ChargeBullet",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "R",
    SortId = 12
  },
  D = {
    ActionName = "D",
    ActionNameText = "UI_Keyboard_Map_D",
    AxisActionName = "MoveRight",
    CanChanged = true,
    IsShowInSetting = true,
    Key = "D",
    Scale = "1",
    SortId = 46
  },
  DownSelect = {
    ActionName = "DownSelect",
    ActionNameText = "UI_Keyboard_DownSelect",
    IsShowInSetting = true,
    Key = "MouseScrollDown",
    SortId = 48
  },
  Fire = {
    ActionName = "Fire",
    ActionNameText = "UI_Keyboard_Map_Fire",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "RightMouseButton",
    SortId = 2
  },
  Interactive = {
    ActionName = "Interactive",
    ActionNameText = "UI_Keyboard_Map_Interactive",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "F",
    SortId = 13
  },
  ItemDetail = {
    ActionName = "ItemDetail",
    ActionNameText = "UI_Keyboard_Map_ItemDetail",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "Tab",
    SortId = 37
  },
  Jump = {
    ActionName = "Jump",
    ActionNameText = "UI_Keyboard_Map_Jump",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "SpaceBar",
    SortId = 7
  },
  LockMonster = {
    ActionName = "LockMonster",
    ActionNameText = "UI_Keyboard_Map_LockMonster",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "MiddleMouseButton",
    SortId = 41
  },
  OpenAppearanceGestureGruop = {
    ActionName = "OpenAppearanceGestureGruop",
    ActionNameText = "UI_Preview_GestureItem",
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "F6",
    SortId = 26
  },
  OpenArmory = {
    ActionName = "OpenArmory",
    ActionNameText = "MAIN_UI_ARMORY",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "C",
    SortId = 20
  },
  OpenBag = {
    ActionName = "OpenBag",
    ActionNameText = "MAIN_UI_BAG",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "B",
    SortId = 15
  },
  OpenBattlePass = {
    ActionName = "OpenBattlePass",
    ActionNameText = "MAIN_UI_BATTLEPASS",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "F2",
    SortId = 23
  },
  OpenBattleWheel = {
    ActionName = "OpenBattleWheel",
    ActionNameText = "MAIN_UI_BATTLEWHEEL",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "T",
    SortId = 27
  },
  OpenCamera = {
    ActionName = "OpenCamera",
    ActionNameText = "UI_CameraSystem_Camera",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "F5",
    SortId = 25
  },
  OpenChat = {
    ActionName = "OpenChat",
    ActionNameText = "MAIN_UI_CHAT",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "Enter",
    SortId = 19
  },
  OpenEvent = {
    ActionName = "OpenEvent",
    ActionNameText = "MAIN_UI_GAMEEVENT",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "F1",
    SortId = 22
  },
  OpenForge = {
    ActionName = "OpenForge",
    ActionNameText = "MAIN_UI_FORGE",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "H",
    SortId = 21
  },
  OpenGacha = {
    ActionName = "OpenGacha",
    ActionNameText = "MAIN_UI_GACHA",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "F3",
    SortId = 24
  },
  OpenGuideBook = {
    ActionName = "OpenGuideBook",
    ActionNameText = "MAIN_UI_GUIDEBOOK",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "G",
    SortId = 36
  },
  OpenMap = {
    ActionName = "OpenMap",
    ActionNameText = "MAIN_UI_MAP",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "M",
    SortId = 18
  },
  OpenMenu = {
    ActionName = "OpenMenu",
    ActionNameText = "MAIN_UI_MENU",
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "Escape",
    SortId = 42
  },
  OpenPlay = {
    ActionName = "OpenPlay",
    ActionNameText = "MAIN_UI_PLAY",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "L",
    SortId = 16
  },
  OpenTask = {
    ActionName = "OpenTask",
    ActionNameText = "MAIN_UI_QUEST",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "J",
    SortId = 17
  },
  OpenTeamHall = {
    ActionName = "OpenTeamHall",
    ActionNameText = "UI_teamLobby",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "O",
    SortId = 70
  },
  PreAim = {
    ActionName = "PreAim",
    ActionNameText = "UI_Keyboard_Map_PreAim",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "CapsLock",
    SortId = 3
  },
  QuitChallenge = {
    ActionName = "QuitChallenge",
    ActionNameText = "UI_Keyboard_Map_QuitChallenge",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "P",
    SortId = 39
  },
  Recovery = {
    ActionName = "Recovery",
    ActionNameText = "UI_Keyboard_Map_Recovery",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "X",
    SortId = 11
  },
  S = {
    ActionName = "S",
    ActionNameText = "UI_Keyboard_Map_S",
    AxisActionName = "MoveForward",
    CanChanged = true,
    IsShowInSetting = true,
    Key = "S",
    Scale = "-1",
    SortId = 45
  },
  ShowCursor = {
    ActionName = "ShowCursor",
    ActionNameText = "UI_Keyboard_Map_ShowCursor",
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "LeftAlt",
    SortId = 40
  },
  ShowTeamInfo = {
    ActionName = "ShowTeamInfo",
    ActionNameText = "UI_Keyboard_TeamInfo",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "F4",
    SortId = 57
  },
  Skill1 = {
    ActionName = "Skill1",
    ActionNameText = "UI_Keyboard_Map_Skill1",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "E",
    SortId = 4
  },
  Skill2 = {
    ActionName = "Skill2",
    ActionNameText = "UI_Keyboard_Map_Skill2",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "Q",
    SortId = 5
  },
  Skill3 = {
    ActionName = "Skill3",
    ActionNameText = "UI_Keyboard_Map_Skill3",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "Z",
    SortId = 6
  },
  Slide = {
    ActionName = "Slide",
    ActionNameText = "UI_Keyboard_Map_Slide",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "LeftControl",
    SortId = 8
  },
  SlideMechTurn = {
    ActionName = "SlideMechTurn",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "V",
    SortId = 71
  },
  StoryInteractive = {
    ActionName = "StoryInteractive",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "F",
    SortId = 63
  },
  StoryInteractiveClick = {
    ActionName = "StoryInteractiveClick",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "SpaceBar",
    SortId = 62
  },
  StoryInteractiveClose = {
    ActionName = "StoryInteractiveClose",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "Escape",
    SortId = 61
  },
  SwitchMovement = {
    ActionName = "SwitchMovement",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "K",
    SortId = 69
  },
  SwitchWalk = {
    ActionName = "SwitchWalk",
    ActionNameText = "UI_CTL_SwitchWalk",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "Tilde",
    SortId = 14
  },
  TalkAutoPlay = {
    ActionName = "TalkAutoPlay",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "Tab",
    SortId = 51
  },
  TalkClick = {
    ActionName = "TalkClick",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "SpaceBar",
    SortId = 52
  },
  TalkDownSelect = {
    ActionName = "TalkDownSelect",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "S",
    SortId = 53
  },
  TalkExit = {
    ActionName = "TalkExit",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "Escape",
    SortId = 60
  },
  TalkOption = {
    ActionName = "TalkOption",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "F",
    SortId = 54
  },
  TalkReview = {
    ActionName = "TalkReview",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "V",
    SortId = 59
  },
  TalkSkip = {
    ActionName = "TalkSkip",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "SpaceBar",
    SortId = 55
  },
  TalkUpSelect = {
    ActionName = "TalkUpSelect",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "W",
    SortId = 56
  },
  TalkWiki = {
    ActionName = "TalkWiki",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "H",
    SortId = 58
  },
  TrainingCharacterSkills = {
    ActionName = "TrainingCharacterSkills",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "F2",
    SortId = 65
  },
  TrainingInvincible = {
    ActionName = "TrainingInvincible",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "F3",
    SortId = 66
  },
  TrainingKillMonsters = {
    ActionName = "TrainingKillMonsters",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "F4",
    SortId = 67
  },
  TrainingMonstersActive = {
    ActionName = "TrainingMonstersActive",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "F5",
    SortId = 68
  },
  TrainingOpenSetup = {
    ActionName = "TrainingOpenSetup",
    IsActionMapping = true,
    IsShowInSetting = false,
    Key = "F1",
    SortId = 64
  },
  UpSelect = {
    ActionName = "UpSelect",
    ActionNameText = "UI_Keyboard_UpSelect",
    IsShowInSetting = true,
    Key = "MouseScrollUp",
    SortId = 47
  },
  UseBattleWheelSlot1 = {
    ActionName = "UseBattleWheelSlot1",
    ActionNameText = "UI_Keyboard_BattleWheel_1",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "Five",
    SortId = 28
  },
  UseBattleWheelSlot2 = {
    ActionName = "UseBattleWheelSlot2",
    ActionNameText = "UI_Keyboard_BattleWheel_2",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "Six",
    SortId = 29
  },
  UseBattleWheelSlot3 = {
    ActionName = "UseBattleWheelSlot3",
    ActionNameText = "UI_Keyboard_BattleWheel_3",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "Seven",
    SortId = 30
  },
  UseBattleWheelSlot4 = {
    ActionName = "UseBattleWheelSlot4",
    ActionNameText = "UI_Keyboard_BattleWheel_4",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "Eight",
    SortId = 31
  },
  UseBattleWheelSlot5 = {
    ActionName = "UseBattleWheelSlot5",
    ActionNameText = "UI_Keyboard_BattleWheel_5",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "Nine",
    SortId = 32
  },
  UseBattleWheelSlot6 = {
    ActionName = "UseBattleWheelSlot6",
    ActionNameText = "UI_Keyboard_BattleWheel_6",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "Zero",
    SortId = 33
  },
  UseBattleWheelSlot7 = {
    ActionName = "UseBattleWheelSlot7",
    ActionNameText = "UI_Keyboard_BattleWheel_7",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "Hyphen",
    SortId = 34
  },
  UseBattleWheelSlot8 = {
    ActionName = "UseBattleWheelSlot8",
    ActionNameText = "UI_Keyboard_BattleWheel_8",
    CanChanged = true,
    IsActionMapping = true,
    IsShowInSetting = true,
    Key = "Equals",
    SortId = 35
  },
  W = {
    ActionName = "W",
    ActionNameText = "UI_Keyboard_Map_W",
    AxisActionName = "MoveForward",
    CanChanged = true,
    IsShowInSetting = true,
    Key = "W",
    Scale = "1",
    SortId = 43
  }
})
