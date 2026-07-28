local AutoChessConst = require("BluePrints.UI.AutoChess.AutoChessConst")
local AutoChessModel = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local Component = {}

function Component:OnLoginSuccess()
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
    EventManager:FireEvent(EventID.OnAutoChessEquipChange, MonsterId, ReplaceEquipIndex, EquipId)
  end
  
  self:CallServer("AutoChessAddEquip", cb, MonsterId, EquipId, ReplaceEquipIndex)
end

function Component:AutoChessRemoveEquip(Callback, MonsterId, EquipIdx)
  DebugPrint("AutoChessRemoveEquip", MonsterId, EquipIdx)
  assert(MonsterId)
  assert(EquipIdx)
  
  local function cb(Ret)
    if Callback then
      local ok, err = pcall(Callback, Ret)
      if not ok then
        DebugPrint(ErrorTag, "AutoChessRemoveEquip callback error: " .. tostring(err))
      end
    end
    EventManager:FireEvent(EventID.OnAutoChessEquipChange, MonsterId, EquipIdx)
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

function Component:AutoChessSetChallengeBuff(Callback, ChallengeBuffs)
  DebugPrint("AutoChessSetChallengeBuff", ChallengeBuffs)
  assert(ChallengeBuffs)
  
  local function cb(Ret)
    if ErrorCode:Check(Ret) then
      EventManager:FireEvent(EventID.OnChallengeBuffChange, ChallengeBuffs)
      if Callback then
        Callback(Ret)
      end
    end
  end
  
  self:CallServer("AutoChessSetChallengeBuff", cb, ChallengeBuffs)
end

function Component:AutoChessSetSharedSquad(Callback, SquadIdx, Squad, Buffs, Equips)
  DebugPrint("AutoChessSetSharedSquad", SquadIdx)
  assert(SquadIdx)
  assert(Squad)
  assert(Buffs)
  assert(Equips)
  
  local function cb(Ret)
    EventManager:FireEvent(EventID.OnAutoChessSetSharedSquad, SquadIdx)
    if ErrorCode:Check(Ret) and Callback then
      Callback(Ret)
    end
  end
  
  self:CallServer("AutoChessSetSharedSquad", cb, SquadIdx, Squad, Buffs, Equips)
end

function Component:AutoChessGetSharedCode(Callback, SquadIdx)
  DebugPrint("AutoChessGetSharedCode", SquadIdx)
  assert(SquadIdx)
  
  local function cb(Ret, ShareCode)
    if Callback then
      Callback(Ret, ShareCode)
    end
  end
  
  self:CallServer("AutoChessGetSharedCode", cb, SquadIdx)
end

function Component:AutoChessGetSharedSquadByShareCode(Callback, ShareCode)
  DebugPrint("AutoChessGetSharedSquadByShareCode", ShareCode)
  assert(ShareCode)
  
  local function cb(Ret, ShareData)
    ErrorCode:Check(Ret)
    if Callback then
      Callback(Ret, ShareData)
    end
  end
  
  self:CallServer("AutoChessGetSharedSquadByShareCode", cb, ShareCode)
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
