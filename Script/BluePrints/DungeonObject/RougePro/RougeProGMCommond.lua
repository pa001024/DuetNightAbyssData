local RougeProGMCommond = DungeonClass.Class()
local CommandMap = {
  HELLO = "GMHello",
  STARTGAME = "GMStartGame",
  FINISHROUND = "GMFinishRound",
  ADDTREASURE = "GMAddTreasure",
  SETPROFESSION = "GMSetProfession",
  APPLYEFFECT = "GMApplyEffect",
  REMOVEEFFECT = "GMRemoveEffect",
  APPLYMONSTERSP = "GMApplyMonsterSP",
  REMOVEMONSTERSP = "GMRemoveMonsterSP",
  ADDRANDOM = "GMAddRandom",
  ADDTOKEN = "GMAddToken",
  SHOPBUY = "GMShopBuy"
}

local function ToBoolean(Value)
  if type(Value) == "boolean" then
    return Value
  end
  if type(Value) == "number" then
    return 0 ~= Value
  end
  if type(Value) == "string" then
    local LowerValue = string.lower(Value)
    return "1" == LowerValue or "true" == LowerValue or "yes" == LowerValue
  end
  return false
end

function RougeProGMCommond:LogGM(...)
  if self.Log then
    self:Log(...)
    return
  end
  print(...)
end

function RougeProGMCommond:OnNotifyServerDungeonEvent_RougeProCmd(AvatarEid, Cmd, ...)
  if not Cmd or "" == Cmd then
    self:LogGM("RougeProGMCommond empty cmd")
    return
  end
  local Args = {
    ...
  }
  local CmdName = string.upper(tostring(Cmd))
  local FuncName = CommandMap[CmdName]
  if not FuncName then
    self:LogGM("RougeProGMCommond unknown cmd", Cmd)
    return
  end
  local Func = self[FuncName]
  if not Func then
    self:LogGM("RougeProGMCommond missing handler", Cmd, FuncName)
    return
  end
  local Player = self:GetPlayer(AvatarEid)
  if nil == Player then
    self:LogGM("RougeProGMCommond  OnNotifyServerDungeonEvent_RougeProCmd Player == null AvatarEid = " .. tostring(AvatarEid))
  end
  self:LogGM("RougeProGMCommond exec", CmdName, table.unpack(Args))
  return Func(self, AvatarEid, table.unpack(Args))
end

function RougeProGMCommond:GMHello(AvatarEid, Arg1, Arg2)
  self:LogGM("RougeProGMCommond:Hello arg1 =", tostring(Arg1))
  self:LogGM("RougeProGMCommond:Hello arg2 =", tostring(Arg2))
end

function RougeProGMCommond:GMSetProfession(AvatarEid, ProfessionId)
  ProfessionId = tonumber(ProfessionId)
  AvatarEid = AvatarEid and tostring(AvatarEid) or nil
  if not AvatarEid or not ProfessionId then
    self:LogGM("RougeProGMCommond:SetProfession invalid args", AvatarEid, ProfessionId)
    return
  end
  self:SelectProfession(AvatarEid, ProfessionId)
end

function RougeProGMCommond:GMStartGame(AvatarEid)
  self:OnNotifyServerDungeonEvent_GMRougeProStartGame()
end

function RougeProGMCommond:GMFinishRound(AvatarEid, RoundEndReason)
  self:OnRoundEnd(RoundEndReason)
end

function RougeProGMCommond:GMAddTreasure(AvatarEid, TreasureId)
  TreasureId = tonumber(TreasureId)
  local Player = self:GetPlayer(AvatarEid)
  if not Player or not TreasureId then
    self:LogGM("RougeProGMCommond:AddTreasure invalid args", AvatarEid, TreasureId)
    return
  end
  self:AddTreasureForPlayer(Player, TreasureId)
end

function RougeProGMCommond:GMApplyEffect(AvatarEid, EffectId)
  local Player = self:GetPlayer(AvatarEid)
  if Player then
    Player:ApplyRougeProEffect(Player, tonumber(EffectId))
  end
end

function RougeProGMCommond:GMRemoveEffect(AvatarEid, EffectId)
  local Player = self:GetPlayer(AvatarEid)
  if Player then
    Player:RemoveEffect(tonumber(EffectId))
  end
end

function RougeProGMCommond:GMApplyMonsterSP(AvatarEid, MonsterSPId)
  self:TriggerRougeProMonsterSpecialSpawn(tonumber(MonsterSPId))
end

function RougeProGMCommond:GMRemoveMonsterSP(AvatarEid, MonsterSPId)
  self:StopRougeProMonsterSpecialSpawn(tonumber(MonsterSPId))
end

function RougeProGMCommond:GMAddRandom(AvatarEid, RandomId)
  local Player = self:GetPlayer(AvatarEid)
  self:GetTreasureByRandomId(Player, tonumber(RandomId))
end

function RougeProGMCommond:GMAddToken(AvatarEid, AddToken)
  local Player = self:GetPlayer(AvatarEid)
  Player:AddToken(tonumber(AddToken))
end

function RougeProGMCommond:GMShopBuy(AvatarEid, ShopItemId)
  self:OnNotifyServerDungeonEvent_RougeProShopBuyItem(AvatarEid, tonumber(ShopItemId))
end

return RougeProGMCommond
