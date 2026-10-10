local T = {}
T.RT_1 = {
  0,
  0,
  0
}
T.RT_2 = {
  0,
  0,
  120
}
T.RT_3 = {
  0,
  0,
  -180
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CustomDisplayPoint", {
  [10101] = {
    DisplayGroupId = 101,
    OffsetPosition = T.RT_1,
    OffsetRotation = {
      0,
      0,
      80
    },
    PointId = 10101,
    PointIndex = 1
  },
  [10102] = {
    DisplayGroupId = 101,
    OffsetPosition = {
      0,
      -65,
      0
    },
    OffsetRotation = {
      0,
      0,
      60
    },
    PointId = 10102,
    PointIndex = 2
  },
  [10103] = {
    DisplayGroupId = 101,
    OffsetPosition = {
      60,
      60,
      0
    },
    OffsetRotation = {
      0,
      0,
      90
    },
    PointId = 10103,
    PointIndex = 3
  },
  [10104] = {
    DisplayGroupId = 101,
    OffsetPosition = {
      30,
      130,
      0
    },
    OffsetRotation = T.RT_2,
    PointId = 10104,
    PointIndex = 4
  },
  [10105] = {
    DisplayGroupId = 101,
    OffsetPosition = {
      240,
      0,
      0
    },
    OffsetRotation = T.RT_1,
    PointId = 10105,
    PointIndex = 5
  },
  [10201] = {
    DisplayGroupId = 102,
    OffsetPosition = T.RT_2,
    OffsetRotation = T.RT_3,
    PointId = 10201,
    PointIndex = 1
  },
  [10202] = {
    DisplayGroupId = 102,
    OffsetPosition = {
      0,
      -65,
      120
    },
    OffsetRotation = T.RT_3,
    PointId = 10202,
    PointIndex = 2
  },
  [10203] = {
    DisplayGroupId = 102,
    OffsetPosition = {
      60,
      60,
      120
    },
    OffsetRotation = T.RT_3,
    PointId = 10203,
    PointIndex = 3
  },
  [10204] = {
    DisplayGroupId = 102,
    OffsetPosition = {
      30,
      130,
      120
    },
    OffsetRotation = T.RT_3,
    PointId = 10204,
    PointIndex = 4
  },
  [10301] = {
    DisplayGroupId = 103,
    OffsetPosition = {
      10,
      10,
      0
    },
    OffsetRotation = T.RT_1,
    PointId = 10301,
    PointIndex = 1
  },
  [10302] = {
    DisplayGroupId = 103,
    OffsetPosition = {
      10,
      -55,
      0
    },
    OffsetRotation = T.RT_1,
    PointId = 10302,
    PointIndex = 2
  },
  [10303] = {
    DisplayGroupId = 103,
    OffsetPosition = {
      10,
      70,
      0
    },
    OffsetRotation = T.RT_1,
    PointId = 10303,
    PointIndex = 3
  },
  [10304] = {
    DisplayGroupId = 103,
    OffsetPosition = {
      10,
      140,
      0
    },
    OffsetRotation = T.RT_1,
    PointId = 10304,
    PointIndex = 4
  },
  [10305] = {
    DisplayGroupId = 103,
    OffsetPosition = {
      10,
      -90,
      0
    },
    OffsetRotation = T.RT_1,
    PointId = 10305,
    PointIndex = 5
  },
  [20101] = {
    DisplayGroupId = 201,
    OffsetPosition = {
      -10,
      -10,
      0
    },
    OffsetRotation = T.RT_1,
    PointId = 20101,
    PointIndex = 1
  }
})
