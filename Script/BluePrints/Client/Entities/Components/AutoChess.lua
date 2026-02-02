local AutoChessModel = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local Component = {}

function Component:EnterWorld()
  AutoChessModel:InitModel()
end

function Component:RefreshRandomMission(Callback)
  local function cb(Ret)
    DebugPrint("RefreshRandomMission Result", Ret)
    
    if Callback then
      Callback(Ret)
    end
  end
  
  self:CallServer("RefreshRandomMission", cb)
end

function Component:AutoChessAddEquip(Callback, MonsterId, EquipId, ReplaceEquipIndex)
  DebugPrint("AutoChessAddEquip", MonsterId, EquipId, ReplaceEquipIndex)
  assert(MonsterId)
  assert(EquipId)
  ReplaceEquipIndex = ReplaceEquipIndex or 0
  
  local function cb(Ret)
    if Callback then
      Callback(Ret)
    end
    EventManager:FireEvent(EventID.OnAutoChessEquipChange, MonsterId, EquipId, ReplaceEquipIndex)
  end
  
  self:CallServer("AutoChessAddEquip", cb, MonsterId, EquipId, ReplaceEquipIndex)
end

function Component:AutoChessRemoveEquip(Callback, MonsterId, EquipIdx)
  DebugPrint("AutoChessRemoveEquip", MonsterId, EquipIdx)
  assert(MonsterId)
  assert(EquipIdx)
  
  local function cb(Ret)
    if Callback then
      Callback(Ret)
    end
    EventManager:FireEvent(EventID.OnAutoChessEquipChange, MonsterId, EquipId)
  end
  
  self:CallServer("AutoChessRemoveEquip", cb, MonsterId, EquipIdx)
end

function Component:AutoChessAddSquad(Callback, Squad, SquadIndex)
  DebugPrint("AutoChessAddSquad", SquadIndex)
  assert(Squad)
  assert(SquadIndex)
  
  local function cb(Ret)
    if ErrorCode:Check(Ret) and Callback then
      Callback(Ret)
    end
  end
  
  self:CallServer("AutoChessAddSquad", cb, Squad, SquadIndex)
end

function Component:AutoChessRemoveSquad(Callback, SquadId)
  DebugPrint("AutoChessRemoveSquad", SquadId)
  assert(SquadId)
  
  local function cb(Ret)
    if ErrorCode:Check(Ret) and Callback then
      Callback(Ret)
    end
  end
  
  self:CallServer("AutoChessRemoveSquad", cb, SquadId)
end

function Component:AutoChessCombatStart(Callback, Squad)
  assert(Squad)
  
  local function cb(Ret)
    if Callback then
      Callback(Ret)
    end
  end
  
  self:CallServer("AutoChessCombatStart", cb, Squad)
end

function Component:AutoChessUnlock(UnlockType, UnlockId)
  AutoChessModel:InitReddotTree()
  if "Card" == UnlockType then
    ReddotManager.IncreaseLeafNodeCount("AutoChessMonster", 1, {Id = UnlockId})
  elseif "Equip" == UnlockType then
    ReddotManager.IncreaseLeafNodeCount("AutoChessEquip", 1, {Id = UnlockId})
  end
end

function Component:ttac()
  self:AutoChessAddSquad()
end

return Component
