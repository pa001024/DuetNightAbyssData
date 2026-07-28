local AutoChessConst = {}
AutoChessConst.LevelSelectType = {
  Linear = 1,
  Random = 2,
  Battle = 3,
  Editor = 4
}
AutoChessConst.FSMStates = {
  MainPage = 1,
  MonsterPage_Main = 2,
  MonsterPage_FocusRight = 3,
  EquipsPage_Main = 4,
  EquipsPage_FocusSort = 5
}
AutoChessConst.ActiveId = CommonConst.AutoChessEventId
AutoChessConst.EditorMissionId = 94001
AutoChessConst.BattleMissionId = 93001
AutoChessConst.AutoChessCoin = 219
AutoChessConst.BuffType = {
  Weather = 1,
  Challenge = 2,
  Field = 3
}
_G.AutoChessConst = AutoChessConst
return AutoChessConst
