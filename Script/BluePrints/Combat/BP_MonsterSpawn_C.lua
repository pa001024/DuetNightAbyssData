require("UnLua")
local BP_MonsterSpawn_C = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.Combat.Components.MonsterSpawnComponent",
  "BluePrints.Common.DelayFrameComponent"
})

function BP_MonsterSpawn_C:CheckDungeonReachable(LevelLoader, PresetTarget, SpawnPointInfo)
  if not LevelLoader.LevelId2Doors then
    local IsHasPath = UE4.UNavigationFunctionLibrary.CheckTwoPosHasPath(SpawnPointInfo.Loc, PresetTarget:K2_GetActorLocation(), self.GameMode)
    return IsHasPath
  end
  local LevelId = LevelLoader:GetLevelIdByLocation(PresetTarget:K2_GetActorLocation())
  local LevelReachable = false
  for DoorIndex, BPArrow in pairs(LevelLoader.LevelId2Doors[LevelId]) do
    local IsHasPath = UE4.UNavigationFunctionLibrary.CheckTwoPosHasPath(SpawnPointInfo.Loc, BPArrow:K2_GetActorLocation(), self.GameMode)
    if IsHasPath == UE4.EPathConnectType.HasPath then
      LevelReachable = true
      break
    end
  end
  return LevelReachable
end

function BP_MonsterSpawn_C:GetAroundDivisionInfos(Loc)
  return self.GameMode:GetAroundDivisionInfos(Loc)
end

function BP_MonsterSpawn_C:AddHostageInfo(Res)
  local HostageEid = self.GameMode:TriggerDungeonComponentFun("GetHostageEid")
  if nil == HostageEid then
    DebugPrint("BP_MonsterSpawn_C  当前预设目标为人质，但不应该在非捕获玩法使用  MonsterSpawnId:", self.UnitSpawnId)
    self:AddPlayerInfo(Res)
    return
  end
  local Hostage = Battle(self):Getentity(HostageEid)
  if not IsValid(Hostage) then
    DebugPrint("BP_MonsterSpawn_C  当前预设目标为人质，人质不存在  MonsterSpawnId:", self.UnitSpawnId)
    self:AddPlayerInfo(Res)
    return
  end
  DebugPrint("BP_MonsterSpawn_C  当前预设目标为人质  MonsterSpawnId:", self.UnitSpawnId, "人质Eid:", HostageEid)
  Res:Add(Hostage)
end

function BP_MonsterSpawn_C:DebugPrintMonsterSpawn(Info)
  if self.GameMode.DebugPrintMonsterSpawn then
    DebugPrint("WARNING:  " .. Info)
  end
end

function BP_MonsterSpawn_C:GetSpawnPointLocations(PresetTarget, CheckInfo)
  if not IsValid(PresetTarget) then
    DebugPrint("BP_MonsterSpawn_C  没有找到预设目标，所有没有合适点位")
    return {}
  end
  local SpawnPoints, PersetLoc = {}, PresetTarget:K2_GetActorLocation()
  self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  开始过滤预设目标周围的点位 ====================================================  MonsterSpawnId:", self.UnitSpawnId)
  local DivisionInfos = self:GetAroundDivisionInfos(PersetLoc):ToTable()
  for SpawnIndex, SpawnPointInfo in pairs(DivisionInfos) do
    self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  开始过滤预设目标周围的点位，当前点位Index :" .. SpawnIndex)
    local LevelLoader = self.GameMode:GetLevelLoader()
    if self:CheckPointEnable(SpawnPointInfo, LevelLoader) then
      local SpawnDis = UE4.UKismetMathLibrary.Vector_Distance(SpawnPointInfo.Loc, PersetLoc)
      if self:CheckSpawnPointIsValidOrNot_Lua(SpawnDis, SpawnPointInfo, PresetTarget, LevelLoader, CheckInfo) then
        self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  当前点位检测通过，点位Index :" .. SpawnIndex)
        table.insert(SpawnPoints, {
          [1] = SpawnDis,
          [2] = SpawnPointInfo.Loc
        })
      end
    end
  end
  self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  结束过滤预设目标周围的点位 ====================================================  MonsterSpawnId:", self.UnitSpawnId)
  self:DebugPrintMonsterSpawn("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t ")
  self:DebugPrintMonsterSpawn("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t ")
  if CheckInfo.RandomSpawn then
    for i = #SpawnPoints, 2, -1 do
      local j = math.random(i)
      SpawnPoints[i], SpawnPoints[j] = SpawnPoints[j], SpawnPoints[i]
    end
  else
    table.sort(SpawnPoints, function(t1, t2)
      if not t1[1] then
        return false
      end
      if not t2[1] then
        return false
      end
      return t1[1] < t2[1]
    end)
  end
  local Locations = {}
  for _, SpawnPoints in ipairs(SpawnPoints) do
    table.insert(Locations, SpawnPoints[2])
  end
  return Locations
end

function BP_MonsterSpawn_C:CheckSpawnPointIsValidOrNot_Lua(SpawnDis, SpawnPointInfo, PresetTarget, LevelLoader, CheckInfo)
  if self.GameMode.DebugMonsterSpawn then
    return true
  end
  if SpawnDis < CheckInfo.UnitSpawnRadiusMin then
    self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  此点位不满足要求，原因：距离小于导表数据最小刷怪范围   Dis:" .. SpawnDis .. "  UnitSpawnRadiusMin:" .. CheckInfo.UnitSpawnRadiusMin .. "  MonsterSpawnId:" .. self.UnitSpawnId)
    return false
  end
  if CheckInfo.RandomSpawn == true and SpawnDis > CheckInfo.UnitSpawnRadiusMax then
    self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  此点位不满足要求，原因：距离大于导表数据最大刷怪范围（此规则只有RandomSpawn为true生效）   Dis:" .. SpawnDis .. "  UnitSpawnRadiusMax:" .. CheckInfo.UnitSpawnRadiusMax .. "  MonsterSpawnId:" .. self.UnitSpawnId)
    return false
  end
  if true == CheckInfo.LineTraceable and self:CheckVisionEnable(SpawnDis, SpawnPointInfo) == false then
    self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  此点位不满足要求，原因：打射线检测视野失败  MonsterSpawnId:", self.UnitSpawnId)
    return false
  end
  if true == CheckInfo.FilterReachable and self.GameMode:IsInDungeon() then
    if not IsValid(LevelLoader) then
      self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  此点位不满足要求，原因：导航可达性只在拼接本生效，当前环境下找不到LevelLoader  MonsterSpawnId:", self.UnitSpawnId)
      return false
    end
    local LevelReachable = self:CheckDungeonReachable(LevelLoader, PresetTarget, SpawnPointInfo)
    if false == LevelReachable then
      self:DebugPrintMonsterSpawn("DebugPrintMonsterSpawn  此点位不满足要求，原因：导航可达性 检测失败  MonsterSpawnId:", self.UnitSpawnId)
      return false
    end
  end
  return true
end

return BP_MonsterSpawn_C
