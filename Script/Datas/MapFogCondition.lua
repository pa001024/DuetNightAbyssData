local T = {}
T.RT_1 = {
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("MapFogCondition", {
  [110201024] = {
    Block = {
      {
        Big = 34,
        FloorId = 0,
        Small = {
          4,
          7,
          8,
          11,
          12,
          15,
          16
        }
      },
      {
        Big = 35,
        FloorId = 0,
        Small = T.RT_1
      },
      {
        Big = 36,
        FloorId = 0,
        Small = T.RT_1
      },
      {
        Big = 37,
        FloorId = 0,
        Small = T.RT_1
      },
      {
        Big = 38,
        FloorId = 0,
        Small = T.RT_1
      },
      {
        Big = 39,
        FloorId = 0,
        Small = {
          1,
          2,
          3,
          5,
          6,
          7,
          9,
          10,
          11,
          13,
          14,
          15
        }
      },
      {
        Big = 43,
        FloorId = 0,
        Small = {4}
      },
      {
        Big = 44,
        FloorId = 0,
        Small = {
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          11,
          12
        }
      },
      {
        Big = 45,
        FloorId = 0,
        Small = {
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          16
        }
      },
      {
        Big = 46,
        FloorId = 0,
        Small = T.RT_1
      },
      {
        Big = 47,
        FloorId = 0,
        Small = {
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10
        }
      },
      {
        Big = 48,
        FloorId = 0,
        Small = {
          1,
          2,
          3,
          5,
          6
        }
      },
      {
        Big = 26,
        FloorId = 0,
        Small = {
          12,
          13,
          14,
          15,
          16
        }
      },
      {
        Big = 27,
        FloorId = 0,
        Small = {
          5,
          6,
          7,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16
        }
      },
      {
        Big = 28,
        FloorId = 0,
        Small = {
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16
        }
      },
      {
        Big = 29,
        FloorId = 0,
        Small = {
          2,
          3,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16
        }
      },
      {
        Big = 30,
        FloorId = 0,
        Small = {
          5,
          6,
          9,
          10,
          11,
          13,
          14,
          15
        }
      }
    },
    ConditionId = 110201024,
    RegionId = 1070
  }
})
