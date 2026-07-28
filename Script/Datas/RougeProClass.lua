local T = {}
T.RT_1 = {9}
T.RT_2 = {8}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RougeProClass", {
  [1] = {
    BondEffect = T.RT_1,
    Desc = "RLP_Class_Desc_1",
    Effect = T.RT_2,
    Id = 1,
    Name = "RLP_Class_1",
    Weight = 500
  },
  [2] = {
    BondEffect = T.RT_1,
    Desc = "RLP_Class_Desc_2",
    Effect = T.RT_2,
    Id = 2,
    Name = "RLP_Class_2",
    Weight = 500
  },
  [3] = {
    BondEffect = T.RT_1,
    Desc = "RLP_Class_Desc_3",
    Effect = T.RT_2,
    Id = 3,
    Name = "RLP_Class_3",
    Weight = 300
  },
  [4] = {
    BondEffect = T.RT_1,
    Desc = "RLP_Class_Desc_4",
    Effect = T.RT_2,
    Id = 4,
    Name = "RLP_Class_4",
    Weight = 200
  },
  [5] = {
    BondEffect = {13, 12},
    Desc = "RLP_Class_Desc_5",
    Effect = {10, 11},
    Id = 5,
    Name = "RLP_Class_5",
    Weight = 200
  },
  [6] = {
    BondEffect = T.RT_1,
    Desc = "RLP_Class_Desc_6",
    Effect = {5, 8},
    Id = 6,
    Name = "RLP_Class_6",
    Weight = 100
  }
})
