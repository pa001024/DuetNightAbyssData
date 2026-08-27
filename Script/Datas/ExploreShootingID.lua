local T = {}
T.RT_1 = {
  0,
  15,
  25
}
T.RT_2 = {11303, 11403}
T.RT_3 = {0}
T.RT_4 = {
  5,
  15,
  25
}
T.RT_5 = {-1}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ExploreShootingID", {
  [1] = {
    CountDown = 45,
    ID = 1,
    RatingRange = T.RT_1,
    RoleID = T.RT_2,
    StoryMode = false,
    TextHint = "UI_ExpShootDes_1",
    TextHint2 = "-1",
    TextName = "UI_ExpShootName_1",
    Unlock = T.RT_3
  },
  [2] = {
    CountDown = 45,
    ID = 2,
    RatingRange = T.RT_1,
    RoleID = T.RT_2,
    StoryMode = false,
    TextHint = "UI_ExplShootDes_2",
    TextHint2 = "-1",
    TextName = "UI_ExpShootName_2",
    Unlock = {1, 1}
  },
  [91] = {
    CountDown = -1,
    ID = 91,
    RatingRange = T.RT_5,
    RoleID = T.RT_2,
    StoryMode = true,
    TextHint = "UI_ExpShootDes_91",
    TextHint2 = "UI_ExpShootDetail_91_1,UI_ExpShootDetail_91_2,UI_ExpShootDetail_91_3",
    TextName = "UI_ExpShootName_91",
    Unlock = T.RT_3
  },
  [92] = {
    CountDown = -1,
    ExploreGroupId = 7086048,
    ID = 92,
    RatingRange = T.RT_5,
    RoleID = T.RT_2,
    StoryMode = true,
    TextHint = "UI_ExpShootDes_92",
    TextHint2 = "UI_ExpShootDetail_92_1",
    TextName = "UI_ExpShootName_92",
    Unlock = T.RT_3
  },
  [100] = {
    CountDown = 45,
    ExploreGroupId = 7086046,
    ID = 100,
    RatingRange = T.RT_4,
    RoleID = T.RT_2,
    StoryMode = false,
    TextHint = "UI_ExpShootDes_1",
    TextHint2 = "-1",
    TextName = "UI_ExpShootName_1",
    Unlock = T.RT_3
  },
  [101] = {
    CountDown = 45,
    ExploreGroupId = 7086047,
    ID = 101,
    RatingRange = T.RT_4,
    RoleID = T.RT_2,
    StoryMode = false,
    TextHint = "UI_ExpShootDes_1",
    TextHint2 = "-1",
    TextName = "UI_ExpShootName_1",
    Unlock = {20526, 1}
  },
  [102] = {
    CountDown = 45,
    ExploreGroupId = 7086051,
    ID = 102,
    RatingRange = T.RT_4,
    RoleID = T.RT_2,
    StoryMode = false,
    TextHint = "UI_ExpShootDes_1",
    TextHint2 = "-1",
    TextName = "UI_ExpShootName_1",
    Unlock = {20526, 2}
  }
})
