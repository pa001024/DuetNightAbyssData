local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("BuffSpecialEffect", {
  Breakable = {SpecialEffect = "Breakable"},
  Invincible = {SpecialEffect = "Invincible"},
  Invisible = {SpecialEffect = "Invisible"},
  Stealth = {SpecialEffect = "Stealth"},
  Taunt = {SpecialEffect = "Taunt"},
  Translucency = {
    SpecialEffect = "Translucency"
  }
})
