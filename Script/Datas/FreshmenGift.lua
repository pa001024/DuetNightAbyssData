local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("FreshmenGift", {
  [1103] = {CharId = 1103, SortPriority = 94},
  [1501] = {CharId = 1501, SortPriority = 96},
  [1502] = {CharId = 1502, SortPriority = 99},
  [2101] = {CharId = 2101, SortPriority = 95},
  [2301] = {CharId = 2301, SortPriority = 90},
  [3101] = {CharId = 3101, SortPriority = 98},
  [3103] = {CharId = 3103, SortPriority = 85},
  [3201] = {CharId = 3201, SortPriority = 86},
  [3301] = {CharId = 3301, SortPriority = 92},
  [4101] = {CharId = 4101, SortPriority = 100},
  [4202] = {CharId = 4202, SortPriority = 88},
  [4301] = {CharId = 4301, SortPriority = 91},
  [5101] = {CharId = 5101, SortPriority = 97},
  [5102] = {CharId = 5102, SortPriority = 93},
  [5401] = {CharId = 5401, SortPriority = 87}
})
