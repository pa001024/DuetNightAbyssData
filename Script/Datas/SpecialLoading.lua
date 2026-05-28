local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("SpecialLoading", {
  [1] = {
    Id = 1,
    LoadingId = 101001,
    Region = {From = "Main", To = "Fantasy"},
    TriggerCondition = {
      QuestUnstart = {QuestId = 10020802}
    }
  },
  [2] = {
    Id = 2,
    LoadingId = 102001,
    Region = {From = "Main", To = "EX"}
  },
  [3] = {
    Id = 3,
    LoadingId = 103001,
    Region = {From = "EX", To = "Main"}
  },
  [10001] = {
    Id = 10001,
    LoadingId = 10410801,
    Region = {SpawnPoint = 1, SubId = 104108}
  },
  [10002] = {
    Id = 10002,
    LoadingId = 10410802,
    Region = {SpawnPoint = 2, SubId = 104108}
  },
  [10003] = {
    Id = 10003,
    LoadingId = 10410701,
    Region = {SpawnPoint = 1, SubId = 104107}
  },
  [10004] = {
    Id = 10004,
    LoadingId = 10411001,
    Region = {SpawnPoint = 1, SubId = 104110}
  },
  [10005] = {
    Id = 10005,
    LoadingId = 10410301,
    Region = {SpawnPoint = 1, SubId = 104103}
  },
  [10006] = {
    Id = 10006,
    LoadingId = 10410901,
    Region = {SubId = 104109}
  },
  [10007] = {
    Id = 10007,
    LoadingId = 10410201,
    Region = {SpawnPoint = 1, SubId = 104102}
  },
  [10008] = {
    Id = 10008,
    LoadingId = 10410501,
    Region = {SpawnPoint = 1, SubId = 104105}
  },
  [10009] = {
    Id = 10009,
    LoadingId = 10410702,
    Region = {SpawnPoint = 2, SubId = 104107}
  },
  [10010] = {
    Id = 10010,
    LoadingId = 10410401,
    Region = {SpawnPoint = 1, SubId = 104104}
  },
  [10011] = {
    Id = 10011,
    LoadingId = 10410601,
    Region = {SpawnPoint = 1, SubId = 104106}
  },
  [10012] = {
    Id = 10012,
    LoadingId = 10570101,
    Region = {SubId = 105701}
  },
  [10013] = {
    Id = 10013,
    LoadingId = 10430101,
    Region = {SubId = 104301}
  },
  [10014] = {
    Id = 10014,
    LoadingId = 10440101,
    Region = {SubId = 104401}
  },
  [10015] = {
    Id = 10015,
    LoadingId = 10500101,
    Region = {SubId = 105001}
  },
  [10016] = {
    Id = 10016,
    LoadingId = 10420101,
    Region = {SubId = 104201}
  },
  [10017] = {
    Id = 10017,
    LoadingId = 10460101,
    Region = {SubId = 104601}
  },
  [10018] = {
    Id = 10018,
    LoadingId = 10470101,
    Region = {SubId = 104701}
  },
  [10019] = {
    Id = 10019,
    LoadingId = 10490101,
    Region = {SubId = 104901}
  },
  [10020] = {
    Id = 10020,
    LoadingId = 10410702,
    Region = {SpawnPoint = 3, SubId = 104107}
  },
  [10021] = {
    Id = 10021,
    LoadingId = 10410702,
    Region = {SpawnPoint = 4, SubId = 104107}
  },
  [10022] = {
    Id = 10022,
    LoadingId = 10450101,
    Region = {SubId = 104501}
  },
  [10023] = {
    Id = 10023,
    LoadingId = 10450201,
    Region = {SubId = 104502}
  },
  [10024] = {
    Id = 10024,
    LoadingId = 10450301,
    Region = {SubId = 104503}
  },
  [10025] = {
    Id = 10025,
    LoadingId = 10450401,
    Region = {SubId = 104504}
  },
  [10026] = {
    Id = 10026,
    LoadingId = 10450501,
    Region = {SubId = 104505}
  },
  [10027] = {
    Id = 10027,
    LoadingId = 10450601,
    Region = {SubId = 104506}
  },
  [10028] = {
    Id = 10028,
    LoadingId = 10510101,
    Region = {SubId = 105101}
  },
  [10029] = {
    Id = 10029,
    LoadingId = 10520101,
    Region = {SubId = 105201}
  },
  [10030] = {
    Id = 10030,
    LoadingId = 10530101,
    Region = {SubId = 105301}
  },
  [10031] = {
    Id = 10031,
    LoadingId = 10550101,
    Region = {SubId = 105501}
  },
  [10032] = {
    Id = 10032,
    LoadingId = 10480101,
    Region = {SubId = 104801}
  },
  [10033] = {
    Id = 10033,
    LoadingId = 10560101,
    Region = {SubId = 105601}
  },
  [10034] = {
    Id = 10034,
    LoadingId = 10560201,
    Region = {SubId = 105602}
  },
  [10035] = {
    Id = 10035,
    LoadingId = 10540101,
    Region = {SubId = 105401}
  },
  [10036] = {
    Id = 10036,
    LoadingId = 10600101,
    Region = {SpawnPoint = 1, SubId = 106001}
  },
  [10037] = {
    Id = 10037,
    LoadingId = 10600102,
    Region = {SpawnPoint = 5, SubId = 106001}
  },
  [10038] = {
    Id = 10038,
    LoadingId = 10630101,
    Region = {SubId = 106301}
  },
  [10039] = {
    Id = 10039,
    LoadingId = 10610101,
    Region = {SpawnPoint = 2, SubId = 106001}
  },
  [10040] = {
    Id = 10040,
    LoadingId = 10600103,
    Region = {SpawnPoint = 9, SubId = 106001}
  },
  [10041] = {
    Id = 10041,
    LoadingId = 10620101,
    Region = {SubId = 106201}
  },
  [10042] = {
    Id = 10042,
    LoadingId = 10610102,
    Region = {SubId = 106101}
  },
  [10043] = {
    Id = 10043,
    LoadingId = 10110701,
    Region = {SubId = 101107}
  },
  [10044] = {
    Id = 10044,
    LoadingId = 10600103,
    Region = {SpawnPoint = 10, SubId = 106001}
  }
})
