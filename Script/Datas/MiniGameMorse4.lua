local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("MiniGameMorse4", {
  [1] = {
    Id = 1,
    Password = {1124},
    PasswordLen = {4},
    Turn = 1
  }
})
