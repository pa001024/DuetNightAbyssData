local EffectHelper = require("BluePrints.DungeonObject.RougePro.RougeProEffectImplement")
local RougeTreasure = require("BluePrints.DungeonObject.Entity.RougeTreasure")
local RougeProPlayer = DungeonClass.Class()
RougeProPlayer.__Component__ = {
  "BluePrints.DungeonObject.RougePro.RougeProEffectImplement"
}

function RougeProPlayer:PostOnInit()
  self:InitReplicatedProperties(self, "Token", 0, "OnRep_Token")
  self:InitReplicatedProperties(self, "Ore", 0, "OnRep_Ore")
  self:InitReplicatedProperties(self, "Timber", 0, "OnRep_Timber")
  self:InitReplicatedProperties(self, "RougeProProfession", 1, "OnRep_RougeProProfession")
  self:InitReplicatedProperties(self, "RougeProTreasureList", {}, "OnRep_RougeProTreasureList")
  self:InitReplicatedProperties(self, "PlayerDeadNum", 0, "OnRep_PlayerDeadNum")
  self:InitReplicatedProperties(self, "ActiviteCowMechanismFlag", false, "OnRep_ActiviteCowMechanismFlag")
  self:InitReplicatedProperties(self, "ShopItemBoughtList", {})
end

function RougeProPlayer:OnRoundFinish()
  print(string.format("RougeProPlayer:OnRoundFinish() AvatarEid=%s", tostring(self.AvatarEid)))
  self.ShopItemBoughtList = {}
end

function RougeProPlayer:SetAvatarEid(AvatarEid)
  self.AvatarEid = AvatarEid
end

function RougeProPlayer:GetAvatarEid()
  return self.AvatarEid
end

function RougeProPlayer:AddToken(Value)
  print(string.format("RougeProPlayer:AddToken(%s)", tostring(Value)))
  if Value >= 0 then
    self.Token = self.Token + Value * (1 + self:GetRougeProEffect("TokenExtraRate", self) or 0)
  else
    self.Token = math.max(0, self.Token + Value)
  end
end

function RougeProPlayer:AddOre(Value)
  print(string.format("RougeProPlayer:AddOre(%s)", tostring(Value)))
  if Value >= 0 then
    self.Ore = self.Ore + Value * (1 + self:GetRougeProEffect("OreExtraRate", self) or 0)
  else
    self.Ore = math.max(0, self.Ore + Value)
  end
end

function RougeProPlayer:AddTimber(Value)
  print(string.format("RougeProPlayer:AddTimber(%s)", tostring(Value)))
  if Value >= 0 then
    self.Timber = self.Timber + Value * (1 + self:GetRougeProEffect("TimberExtraRate", self) or 0)
  else
    self.Timber = math.max(0, self.Timber + Value)
  end
end

function RougeProPlayer:SetRougeProProfession(ProfessionId)
  self.RougeProProfession = ProfessionId
end

function RougeProPlayer:GetRougeProProfession()
  return self.RougeProProfession
end

function RougeProPlayer:GetPlayerDeadNum()
  return math.max(0, self.PlayerDeadNum - self:GetRougeProEffect("RebornFree", self))
end

function RougeProPlayer:GetRougeProEffect(EffectType, TargetPlayer)
  if not self.DungeonObject or not self.DungeonObject.GetRougeProEffect then
    return
  end
  return self.DungeonObject:GetRougeProEffect(EffectType, TargetPlayer or self)
end

function RougeProPlayer:OnRep_Token()
  print("RougeProPlayer OnRep_Token " .. CommonUtils.TableToString3(self.Token))
  self:NotifyRougeProPlayerBriefDirty()
end

function RougeProPlayer:OnRep_Ore()
  print("RougeProPlayer OnRep_Ore " .. CommonUtils.TableToString3(self.Ore))
end

function RougeProPlayer:OnRep_Timber()
  print("RougeProPlayer OnRep_Timber " .. CommonUtils.TableToString3(self.Timber))
end

function RougeProPlayer:OnRep_RougeProProfession()
  print("RougeProPlayer OnRep_RougeProProfession", self.RougeProProfession)
  self:NotifyRougeProPlayerBriefDirty()
end

function RougeProPlayer:OnRep_RougeProTreasureList()
  print("RougeProPlayer OnRep_RougeProTreasureList", CommonUtils.TableToString3(self.RougeProTreasureList))
  self:NotifyRougeProPlayerBriefDirty()
  self:NotifyRougeProGetTreasureDirty()
end

function RougeProPlayer:OnRep_PlayerDeadNum()
  print("RougeProPlayer OnRep_PlayerDeadNum " .. tostring(self.PlayerDeadNum))
  self:NotifyRougeProPlayerBriefDirty()
end

function RougeProPlayer:OnRep_ActiviteCowMechanismFlag()
  print("RougeProPlayer OnRep_ActiviteCowMechanismFlag " .. tostring(self.ActiviteCowMechanismFlag))
end

function RougeProPlayer:OnRep_TokenExtraRate()
  print("RougeProPlayer OnRep_TokenExtraRate " .. tostring(self.TokenExtraRate))
end

function RougeProPlayer:OnRep_OreExtraRate()
  print("RougeProPlayer OnRep_OreExtraRate " .. tostring(self.OreExtraRate))
end

function RougeProPlayer:OnRep_TimberExtraRate()
  print("RougeProPlayer OnRep_TimberExtraRate " .. tostring(self.TimberExtraRate))
end

function RougeProPlayer:OnRep_ChoiceNumber()
  print("RougeProPlayer OnRep_ChoiceNumber " .. CommonUtils.TableToString3(self.ChoiceNumber))
end

function RougeProPlayer:OnRep_ShopDiscount()
  print("RougeProPlayer OnRep_ShopDiscount " .. tostring(self.ShopDiscount))
end

function RougeProPlayer:OnRep_RecoverTimeAdd()
  print("RougeProPlayer OnRep_RecoverTimeAdd " .. tostring(self.RecoverTimeAdd))
end

function RougeProPlayer:OnRep_RebornFree()
  print("RougeProPlayer OnRep_RebornFree " .. tostring(self.RebornFree))
end

function RougeProPlayer:OnRep_LanternRange()
  print("RougeProPlayer OnRep_LanternRange " .. tostring(self.LanternRange))
end

function RougeProPlayer:OnRep_EndPointsExtraRate()
  print("RougeProPlayer OnRep_EndPointsExtraRate " .. tostring(self.EndPointsExtraRate))
end

function RougeProPlayer:AddNewTreasure(TreasureId)
  self.RougeProTreasureList[#self.RougeProTreasureList + 1] = RougeTreasure(self.DungeonObject, TreasureId)
  self.RougeProTreasureList = self.RougeProTreasureList
end

function RougeProPlayer:HasRougeProTreasure(TreasureId)
  for i = 1, #self.RougeProTreasureList do
    local Treasure = self.RougeProTreasureList[i]
    if Treasure.TreasureId == TreasureId then
      return true
    end
  end
  return false
end

function RougeProPlayer:NotifyRougeProPlayerBriefDirty()
  if not self.DungeonObject or not self.DungeonObject.SyncRougeProPlayerBrief then
    print("RougeProPlayer:NotifyRougeProPlayerBriefDirty() but (not self.DungeonObject or not self.DungeonObject.SyncRougeProPlayerBrief)")
    return
  end
  self.DungeonObject:SyncRougeProPlayerBrief(self)
end

function RougeProPlayer:NotifyRougeProGetTreasureDirty()
  if not self.DungeonObject or not self.DungeonObject.SyncRougeProGetTreasureNotify then
    print("RougeProPlayer:NotifyRougeProGetTreasureDirty() but (not self.DungeonObject or not self.DungeonObject.SyncRougeProGetTreasureNotify)")
    return
  end
  self.DungeonObject:SyncRougeProGetTreasureNotify(self)
end

DungeonClass.AssembleComponents(RougeProPlayer)
return RougeProPlayer
