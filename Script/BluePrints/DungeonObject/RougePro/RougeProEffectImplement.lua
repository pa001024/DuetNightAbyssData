local OverLayRulesConst = {NoOverlay = 0, OverlayBySource = 1}
local EffectImplement = DungeonClass.Class()

function EffectImplement:BeginPlay()
  self:InitRougeProEffect()
end

function EffectImplement:PostOnInit()
  self:InitRougeProEffect()
end

function EffectImplement:GetDungeonInstance()
  if self.__Class__ == "Player" then
    return self.DungeonObject
  else
    return self
  end
end

function EffectImplement:InitRougeProEffect()
  self.bRandomChoice = {}
  self.BlockEffect = {}
  self.BuffList = {}
  self.RebornFree = 0
  self.OreExtraRate = 0
  self.TimberExtraRate = 0
  self.LanternRange = 0
  self.EffectInstanceList = {}
  self:InitReplicatedProperties(self, "TokenExtraRate", 0, "OnRep_TokenExtraRate")
  self:InitReplicatedProperties(self, "OreExtraRate", 0, "OnRep_OreExtraRate")
  self:InitReplicatedProperties(self, "TimberExtraRate", 0, "OnRep_TimberExtraRate")
  self:InitReplicatedProperties(self, "ChoiceNumber", 3, "OnRep_ChoiceNumber")
  self:InitReplicatedProperties(self, "ShopDiscount", 1, "OnRep_ShopDiscount")
  self:InitReplicatedProperties(self, "RecoverTimeAdd", 0, "OnRep_RecoverTimeAdd")
  self:InitReplicatedProperties(self, "RebornFree", 0, "OnRep_RebornFree")
  self:InitReplicatedProperties(self, "LanternRange", 0, "OnRep_LanternRange")
  self:InitReplicatedProperties(self, "EndPointsExtraRate", 0, "OnRep_EndPointsExtraRate")
end

function EffectImplement:ApplyRougeProEffect(Source, EffectId)
  local EffectInfo = DataMgr.RougeProEffect[EffectId]
  if EffectInfo.bNotRecordInBuffList then
    self:RealEffect(EffectInfo)
    return
  end
  if not self.BuffList[EffectId] then
    self.BuffList[EffectId] = {Source}
    self:RealEffect(EffectInfo)
  else
    local OverlayRules = EffectInfo.OverlayRules or 0
    if OverlayRules == OverLayRulesConst.NoOverlay then
      return
    elseif OverlayRules == OverLayRulesConst.OverlayBySource then
      if CommonUtils.HasValue(self.BuffList[EffectId], Source) then
        return
      else
        table.insert(self.BuffList[EffectId], Source)
        self:RealEffect(EffectInfo)
      end
    end
  end
end

function EffectImplement:RealEffect(EffectInfo)
  if self.BlockEffect[EffectInfo.Id] then
    return
  end
  local Name = EffectInfo.Name
  local EffectFunc = "RougeProEffect_" .. Name
  local Func = self[EffectFunc]
  if Func then
    Func(self, EffectInfo.Id, EffectInfo.Param)
  else
    print("ApplyRougeProEffect but cannot find EffectFunc", Name)
  end
end

function EffectImplement:RemoveEffect(EffectId)
  if self.BuffList[EffectId] then
    self.BuffList[EffectId] = nil
  end
  local EffectInfo = DataMgr.RougeProEffect[EffectId]
  local EffectFunc = "RougeProRemoveEffect_" .. EffectInfo.Name
  local Func = self[EffectFunc]
  if Func then
    Func(self, EffectInfo.Id, EffectInfo.Param)
  end
end

function EffectImplement:RougeProEffect_RandomChoice(Id, Param)
  self.bRandomChoice[Id] = true
end

function EffectImplement:RougeProRemoveEffect_RandomChoice(Id, Param)
  self.bRandomChoice[Id] = nil
end

function EffectImplement:RougeProEffect_ChoiceNumber(Id, Param)
  self.ChoiceNumber = Param[1]
end

function EffectImplement:RougeProRemoveEffect_ChoiceNumber(Id, Param)
  self.ChoiceNumber = 3
end

function EffectImplement:RougeProEffect_ShopDiscount(Id, Param)
  self.ShopDiscount = self.ShopDiscount * Param[1]
end

function EffectImplement:RougeProRemoveEffect_ShopDiscount(Id, Param)
  self.ShopDiscount = self.ShopDiscount / Param[1]
end

function EffectImplement:RougeProEffect_OreExtraRate(Id, Param)
  self.OreExtraRate = self.OreExtraRate + Param[1]
end

function EffectImplement:RougeProRemoveEffect_OreExtraRate(Id, Param)
  self.OreExtraRate = self.OreExtraRate - Param[1]
end

function EffectImplement:RougeProEffect_TimberExtraRate(Id, Param)
  self.TimberExtraRate = self.TimberExtraRate + Param[1]
end

function EffectImplement:RougeProRemoveEffect_TimberExtraRate(Id, Param)
  self.TimberExtraRate = self.TimberExtraRate - Param[1]
end

function EffectImplement:RougeProEffect_LanternRange(Id, Param)
  self.LanternRange = self.LanternRange + Param[1]
end

function EffectImplement:RougeProRemoveEffect_LanternRange(Id, Param)
  self.LanternRange = self.LanternRange - Param[1]
end

function EffectImplement:RougeProEffect_GetToken(Id, Param)
  self:AddToken(Param[1])
end

function EffectImplement:RougeProEffect_RecoverTimeAdd(Id, Param)
  self.RecoverTimeAdd = self.RecoverTimeAdd + Param[1]
end

function EffectImplement:RougeProEffect_GetTreasure(Id, Param)
  for i = 1, #Param do
    self:GetDungeonInstance():AddTreasureForPlayer(self, Param[i])
  end
end

function EffectImplement:RougeProEffect_TokenExtraRate(Id, Param)
  self.TokenExtraRate = self.TokenExtraRate + Param[1]
end

function EffectImplement:RougeProRemoveEffect_TokenExtraRate(Id, Param)
  self.TokenExtraRate = self.TokenExtraRate - Param[1]
end

function EffectImplement:RougeProEffect_EndPointsExtraRate(Id, Param)
  self.EndPointsExtraRate = math.max(0, self.EndPointsExtraRate + Param[1])
end

function EffectImplement:RougeProRemoveEffect_EndPointsExtraRate(Id, Param)
  self.EndPointsExtraRate = math.max(0, self.EndPointsExtraRate - Param[1])
end

function EffectImplement:RougeProEffect_BlockEffect(Id, Param)
  local EffectList = Param[1]
  for i = 1, #EffectList do
    local EffectId = EffectList[i]
    self:RemoveEffect(EffectId)
    if not self.BlockEffect[EffectId] then
      self.BlockEffect[EffectId] = {}
    end
    self.BlockEffect[EffectId][Id] = true
  end
end

function EffectImplement:RougeProRemoveEffect_BlockEffect(Id, Param)
  local EffectList = Param[1]
  for i = 1, #EffectList do
    local EffectId = EffectList[i]
    local BlockInfo = self.BlockEffect[EffectId]
    if BlockInfo then
      BlockInfo[Id] = nil
      if not next(BlockInfo) then
        self.BlockEffect[EffectId] = nil
        local Buffs = self.BuffList[EffectId]
        if Buffs then
          self.BuffList[EffectId] = nil
          for i = 1, #Buffs do
            self:ApplyRougeProEffect(Buffs[i], EffectId)
          end
        end
      end
    end
  end
end

function EffectImplement:RougeProEffect_AddBuff()
end

function EffectImplement:RougeProRemoveEffect_AddBuff()
end

function EffectImplement:RougeProEffect_AddMod()
end

function EffectImplement:RougeProRemoveEffect_AddMod()
end

function EffectImplement:RougeProEffect_RebornFree(Id, Param)
  self.RebornFree = self.RebornFree + Param[1]
end

function EffectImplement:RougeProRemoveEffect_RebornFree(Id, Param)
  self.RebornFree = self.RebornFree - Param[1]
end

function EffectImplement:RougeProEffect_GetTokenByTime(Id, Param)
  self.GetTokenByTime = self.GetTokenByTime or {}
  self.GetTokenByTime[Id] = self.GetTokenByTime[Id] or {}
  local Handler = self:GetDungeonInstance():AddLoopTimer(Param[1], Param[1], function()
    self:AddToken(Param[2])
  end)
  table.insert(self.GetTokenByTime[Id], Handler)
end

function EffectImplement:RougeProRemoveEffect_GetTokenByTime(Id, Param)
  local HandlerList = self.GetTokenByTime and self.GetTokenByTime[Id]
  if HandlerList then
    for i = 1, #HandlerList do
      local Handler = HandlerList[i]
      self:GetDungeonInstance():RemoveTimer(Handler)
    end
    self.GetTokenByTime[Id] = nil
  end
end

function EffectImplement:RegisterEffectEvent(EffectId, EffectInstance)
  self.EffectInstanceList[EffectId] = self.EffectInstanceList[EffectId] or {}
  table.insert(self.EffectInstanceList[EffectId], EffectInstance)
  if EffectInstance.OnChangeRound then
    EffectInstance.OnChangeRound(EffectInstance)
  end
  print(string.format("EffectImplement:RegisterEffectEvent EffectId = %s EffectInstance = %s", tostring(EffectId), CommonUtils.TableToString3(EffectInstance)))
end

function EffectImplement:RemoveEffectEvent(EffectId)
  if self.EffectInstanceList[EffectId] then
    self.EffectInstanceList[EffectId] = nil
  end
end

function EffectImplement:DispatchRougeProEffectEvent(EventName, EventParam)
  local IsExistSuccess = false
  for EffectId, EffectList in pairs(self.EffectInstanceList) do
    for i = 1, #EffectList do
      local EffectInstance = EffectList[i]
      IsExistSuccess = EffectInstance[EventName] and type(EffectInstance[EventName]) == "function" and EffectInstance[EventName](EffectInstance, EventParam) or IsExistSuccess
    end
  end
  if self.__Class__ ~= "Player" then
    for AvatarEid, Player in self:GetDungeonInstance():PlayerIterator() do
      IsExistSuccess = Player:DispatchRougeProEffectEvent(EventName, EventParam) or IsExistSuccess
    end
  end
  return IsExistSuccess
end

function EffectImplement:EffectGlobalCacheCallFunc(EffectId, Func)
  self:GetDungeonInstance().StaticSingleCache = self:GetDungeonInstance().StaticSingleCache or {}
  self:GetDungeonInstance().StaticSingleCache[EffectId] = self:GetDungeonInstance().StaticSingleCache[EffectId] or {}
  return Func(self:GetDungeonInstance().StaticSingleCache[EffectId])
end

function EffectImplement:RougeProEffect_PayForRebornGetBuff(Id, Param)
  local EffectInstance = {
    OnPlayerReborn = function(EffectInstance, EventParam)
      if self.Token >= Param[1] then
        self:AddToken(-Param[1])
        return true
      end
      return false
    end
  }
  self:RegisterEffectEvent(Id, EffectInstance)
end

function EffectImplement:RougeProRemoveEffect_PayForRebornGetBuff(Id, Param)
  self:RemoveEffectEvent(Id)
end

function EffectImplement:RougeProEffect_KillGetToken(Id, Param)
  local EffectInstance = {
    OnKillMonster = function(EffectInstance, EventParam)
      EffectInstance.KillCount = EffectInstance.KillCount or 0
      if EventParam.MonsterTag ~= Param[1] then
        return
      end
      EffectInstance.KillCount = EffectInstance.KillCount + 1
      if EffectInstance.KillCount >= Param[2] then
        self:AddToken(Param[3])
        EffectInstance.KillCount = 0
      end
      return true
    end
  }
  self:RegisterEffectEvent(Id, EffectInstance)
end

function EffectImplement:RougeProRemoveEffect_KillGetToken(Id, Param)
  self:RemoveEffectEvent(Id)
end

local RougeProSceneObjAttr = require("BluePrints.DungeonObject.RougePro.ObjSpawn.RougeProSceneObjAttr")

function EffectImplement:RougeProEffect_ActiveStaticPoint(Id, Param)
  local EffectInstance = {
    OnChangeRound = function(EffectInstance, EventParam)
      if Param.RoomIndex and Param.RoomIndex ~= self:GetDungeonInstance().Round then
        return
      end
      local StaticPointId = Param.Point
      local SceneObjAttr = RougeProSceneObjAttr()
      SceneObjAttr:SetEffectId(Id)
      SceneObjAttr:SetCreateByAvatarEid(self.GetAvatarEid and self:GetAvatarEid())
      self:GetDungeonInstance():SceneObjManagerStaticCreatorActive({StaticPointId}, SceneObjAttr)
      return
    end
  }
  self:RegisterEffectEvent(Id, EffectInstance)
end

function EffectImplement:RougeProRemoveEffect_ActiveStaticPoint(Id, Param)
  self:RemoveEffectEvent(Id)
end

function EffectImplement:RougeProEffect_ActiveMonsterSP(Id, Param)
  local EffectInstance = {
    OnChangeRound = function(EffectInstance, EventParam)
      if Param.RoomIndex and Param.RoomIndex ~= self:GetDungeonInstance().Round then
        return
      end
      local MonsterSPId = Param.MonsterSpId
      local SceneObjAttr = RougeProSceneObjAttr()
      SceneObjAttr:SetMonsterSpId(MonsterSPId)
      SceneObjAttr:SetEffectId(Id)
      SceneObjAttr:SetCreateByAvatarEid(self.GetAvatarEid and self:GetAvatarEid())
      self:GetDungeonInstance():TriggerRougeProMonsterSpecialSpawn(MonsterSPId, SceneObjAttr)
      return
    end
  }
  self:RegisterEffectEvent(Id, EffectInstance)
end

function EffectImplement:RougeProRemoveEffect_ActiveMonsterSP(Id, Param)
  self:RemoveEffectEvent(Id)
end

function EffectImplement:RougeProEffect_CreateCowEvent(Id, Param)
  local function ConditionCheck()
    return self:EffectGlobalCacheCallFunc(Id, function(EffectCache)
      EffectCache.AvatarUsedList = EffectCache.AvatarUsedList or {}
      
      return #EffectCache.AvatarUsedList < self:GetDungeonInstance().Round and not CommonUtils.HasValue(EffectCache.AvatarUsedList, self:GetAvatarEid())
    end)
  end
  
  local EffectInstance = {
    OnChangeRound = function(EffectInstance, EventParam)
      print(string.format("RougeProEffect_CreateCowEvent OnChangeRound Called", CommonUtils.TableToString3(EffectInstance)))
      if false == ConditionCheck() then
        print(string.format("RougeProEffect_CreateCowEvent OnChangeRound ConditionCheck() == false"))
        return
      end
      local CowEventInfo = {}
      CowEventInfo.AvatarEid = self:GetAvatarEid()
      CowEventInfo.EffectId = Id
      local NewEventId = self:GetDungeonInstance():TrySpawnCowEvent(CowEventInfo)
      if -1 == NewEventId then
        return
      end
      self:EffectGlobalCacheCallFunc(Id, function(EffectCache)
        EffectCache.AvatarUsedList = EffectCache.AvatarUsedList or {}
        table.insert(EffectCache.AvatarUsedList, self:GetAvatarEid())
      end)
    end
  }
  self:RegisterEffectEvent(Id, EffectInstance)
end

function EffectImplement:RougeProRemoveEffect_CreateCowEvent(Id, Param)
  self:RemoveEffectEvent(Id)
end

function EffectImplement:RougeProEffect_AddBuff(Id, Param)
  self.AddBuff = self.AddBuff or {}
  if self.AddBuff[Id] == nil then
    if self.__Class__ ~= "Player" then
      for AvatarEid, Player in self:GetDungeonInstance():PlayerIterator() do
        self:GetDungeonInstance():NotifyGameModeDungeonEvent("RougeProAddBuff", Param[1], AvatarEid)
      end
    else
      self:GetDungeonInstance():NotifyGameModeDungeonEvent("RougeProAddBuff", Param[1], self:GetAvatarEid())
    end
  end
  self.AddBuff[Id] = true
end

function EffectImplement:RougeProRemoveEffect_AddBuff(Id, Param)
  self:GetDungeonInstance():NotifyGameModeDungeonEvent("RougeProRemoveBuff", Param[1], self:GetAvatarEid())
end

function EffectImplement:RougeProEffect_GetModEveryone(Id, Param)
  self:GetDungeonInstance():NotifyGameModeDungeonEvent("RougeProAddMod", Param[1], self:GetAvatarEid())
end

function EffectImplement:RougeProRemoveEffect_GetModEveryOne(Id, Param)
  self:GetDungeonInstance():NotifyGameModeDungeonEvent("RougeProRemoveMod", Param[1], self:GetAvatarEid())
end

return EffectImplement
