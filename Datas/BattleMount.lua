local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("BattleMount", {
  [1000] = {
    CharAnimInstance = "ABP_Mount_",
    CharMeshSocket = "socket_spine2",
    MonsterId = 1000,
    MountId = 1000,
    MountPrefix = "Mnt01"
  }
})
