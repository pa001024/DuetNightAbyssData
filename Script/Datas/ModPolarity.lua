local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ModPolarity", {
  [-1] = {Char = "E", Id = -1},
  [1] = {
    Char = "C",
    HideInPolarityEditUI = true,
    Id = 1,
    Name = "Polarity_1_Name",
    SlotChar = "F"
  },
  [2] = {
    Char = "B",
    HideInPolarityEditUI = true,
    Id = 2,
    Name = "Polarity_2_Name",
    SlotChar = "F"
  },
  [3] = {
    Char = "D",
    HideInPolarityEditUI = true,
    Id = 3,
    Name = "Polarity_3_Name",
    SlotChar = "F"
  },
  [4] = {
    Char = "A",
    HideInPolarityEditUI = true,
    Id = 4,
    Name = "Polarity_4_Name",
    SlotChar = "F"
  },
  [5] = {
    Char = "F",
    HideInModPolarity = true,
    Id = 5,
    Name = "Polarity_5_Name",
    SlotChar = "F"
  }
})
