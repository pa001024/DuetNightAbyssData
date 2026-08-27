local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("Facial2D", {
  Afraid = {
    FacialId = "Afraid",
    NpcEye = "Afraid",
    NpcMouth = "Afraid"
  },
  Angry = {
    FacialId = "Angry",
    NpcEye = "Angry",
    NpcMouth = "Angry"
  },
  Happy = {
    FacialId = "Happy",
    NpcEye = "Happy",
    NpcMouth = "Happy"
  },
  Idle = {
    FacialId = "Idle",
    NpcEye = "Idle",
    NpcMouth = "Idle"
  },
  Sad = {
    FacialId = "Sad",
    NpcEye = "Sad",
    NpcMouth = "Sad"
  },
  Shock = {
    FacialId = "Shock",
    NpcEye = "Shock",
    NpcMouth = "Shock"
  }
})
