local BP_SkillCreature_C = Class({
  "BluePrints.Combat.Components.EffectSourceInterface",
  "BluePrints.Combat.Components.SkillLevelInterface",
  "BluePrints.Combat.Components.ActorTypeComponent",
  "BluePrints.Common.TimerMgr"
})

function BP_SkillCreature_C:InitCreature_Lua()
  local ConfigData = DataMgr.SkillCreature[self.CreatureId]
  self.ConfigData = ConfigData
  if ConfigData.Tags then
    for _, Tag in pairs(ConfigData.Tags) do
      if "Grenade" == Tag then
        local UIManager = UGameplayStatics.GetGameInstance(self):GetGameUIManager()
        UIManager:LoadUI(UIConst.GRENADESTIPS, "GrenadesTips" .. self.Eid, UIConst.ZORDER_FOR_DAMAGETIPS, self)
        break
      end
    end
  end
  if ConfigData.EffectCreatureID then
    self.DirectSource = self:GetDirectSource()
    if self.DirectSource then
      self.AttachEffectCreature = self.DirectSource:CreateEffectCreature(ConfigData.EffectCreatureID, self:GetTransform(), false)
      if self.AttachEffectCreature then
        self.AttachEffectCreature:K2_AttachToActor(self, "", UE4.EAttachmentRule.KeepWorld, UE4.EAttachmentRule.KeepWorld, UE4.EAttachmentRule.KeepWorld)
      end
    end
  end
end

function BP_SkillCreature_C:DestroyAttachEffectCreature_Lua()
  local EffectCreature = self.AttachEffectCreature
  if not EffectCreature then
    return
  end
  if EffectCreature.IsDestroy then
    self.AttachEffectCreature = nil
    return
  end
  local Owner = EffectCreature:GetOwner()
  if Owner then
    Owner:RemoveEffectCreatureByRef(EffectCreature)
  else
    EffectCreature:DestroyEffectCreature()
  end
  self.AttachEffectCreature = nil
end

function BP_SkillCreature_C:ReceiveEndPlay(EndPlayReason)
  self:DestroyAttachEffectCreature_Lua()
  self.Overridden.ReceiveEndPlay(self, EndPlayReason)
end

function BP_SkillCreature_C:ClearCreature_Lua()
  local UIManager = UGameplayStatics.GetGameInstance(self):GetGameUIManager()
  local ConfigData = DataMgr.SkillCreature[self.CreatureId]
  if UIManager and ConfigData.Tags then
    for _, Tag in pairs(ConfigData.Tags) do
      if "Grenade" == Tag then
        UIManager:UnLoadUI("GrenadesTips", "GrenadesTips" .. self.Eid)
        break
      end
    end
  end
end

function BP_SkillCreature_C:GetControlRotation()
  return nil
end

function BP_SkillCreature_C:ClearPauseRemovableCreature()
  local ConfigData = DataMgr.SkillCreature[self.CreatureId]
  if not ConfigData or not ConfigData.Tags then
    return
  end
  for _, Tag in pairs(ConfigData.Tags) do
    if "PauseRemovable" == Tag then
      self:DisableAndDestroy(EDeathReason.CreaturePause)
      return
    end
    if "PauseInvisible" == Tag then
      self:SetCreatureHideByTag(true, "PauseInvisible")
      return
    end
  end
end

function BP_SkillCreature_C:ResetPauseCreature()
  local ConfigData = DataMgr.SkillCreature[self.CreatureId]
  if not ConfigData or not ConfigData.Tags then
    return
  end
  for _, Tag in pairs(ConfigData.Tags) do
    if "PauseInvisible" == Tag then
      self:SetCreatureHideByTag(false, "PauseInvisible")
      return
    end
  end
end

local DEFAULT_TARGET_FILTER_KEYS = {
  "Saiqi_Skill01_Search_S",
  "Saiqi_Skill01_Search_M",
  "Saiqi_Skill01_Search_L"
}
local EMPTY_OPTS = {}
local EmptyEids = {}
local FilterCache = {}
local FilterCacheOwners = 0
local FILTER_CACHE_MAX = 128
local FILTER_CACHE_MAX_OWNERS = 64

local function CacheGet(Owner, Sid, Now)
  local Slots = Owner and FilterCache[Owner]
  local Slot = Slots and Sid and Slots[Sid]
  if Slot and Now < Slot.Expire then
    return Slot
  end
  return nil
end

local function CacheSet(Owner, Sid, Eids, Key, TTL, Now)
  if not Owner or not Sid then
    return
  end
  local Slots = FilterCache[Owner]
  if not Slots then
    if FilterCacheOwners >= FILTER_CACHE_MAX_OWNERS then
      FilterCache, FilterCacheOwners = {}, 0
    end
    Slots = {Count = 0}
    FilterCache[Owner] = Slots
    FilterCacheOwners = FilterCacheOwners + 1
  end
  if not Slots[Sid] then
    if Slots.Count >= FILTER_CACHE_MAX then
      Slots = {Count = 0}
      FilterCache[Owner] = Slots
    end
    Slots.Count = Slots.Count + 1
  end
  Slots[Sid] = {
    Eids = Eids,
    Key = Key,
    Expire = Now + TTL
  }
end

local function IsEntityUsable(Entity)
  if not IsValid(Entity) then
    return false
  end
  local DeadFn = Entity.IsDead
  if DeadFn then
    local Ok, Dead = pcall(DeadFn, Entity)
    if Ok and Dead then
      return false
    end
  end
  return true
end

local function NormalizeKeys(Keys)
  if not Keys then
    return nil
  end
  if Keys.Num then
    local Out = {}
    local n = Keys:Num()
    for i = 1, n do
      Out[i] = Keys:Get(i)
    end
    return Out
  end
  return Keys
end

local function GetBattleForFilter(self)
  local B = Battle(self)
  if not B or not IsValid(B) then
    return nil
  end
  return B
end

function BP_SkillCreature_C:ResetSharedTargetQuery()
  self.FilterNextAt = nil
end

function BP_SkillCreature_C:QuerySharedTargetEids(Keys, Opts)
  Opts = Opts or EMPTY_OPTS
  local B = GetBattleForFilter(self)
  if not B then
    return nil
  end
  local List = NormalizeKeys(Keys)
  if not List or 0 == #List then
    List = DEFAULT_TARGET_FILTER_KEYS
  end
  local Source = Opts.Source or self:GetDirectSource() or self
  local Sid = Source and Source.Eid or tostring(Source)
  local Owner = Opts.OwnerKey or self.CreatureId or 0
  local Now = UE4.UGameplayStatics.GetTimeSeconds(self)
  local Share = Opts.Share ~= false
  if Share then
    local Slot = CacheGet(Owner, Sid, Now)
    if Slot then
      if Slot.Eids.AllDead then
        return EmptyEids, Slot.Key, true
      end
      return Slot.Eids, Slot.Key, true
    end
  end
  local Chosen, ChosenKey
  for i = 1, #List do
    local Key = List[i]
    local Ok, EidArr = pcall(function()
      return B:DoTargetFilter(Source, Opts.PreTarget, Key, Opts.AllowSkillRangeModify or false, Opts.AttackRangeType or "", Opts.Debug or false, Opts.ExtraEffectId or 0)
    end)
    local Eids = {}
    if Ok and EidArr then
      local Count = EidArr:Num()
      for j = 1, Count do
        Eids[j] = EidArr:Get(j)
      end
    end
    if #Eids > 0 then
      Chosen, ChosenKey = Eids, Key
      break
    end
  end
  if Share then
    CacheSet(Owner, Sid, Chosen or EmptyEids, ChosenKey, Opts.TTL or 0.2, Now)
  end
  return Chosen, ChosenKey, false
end

function BP_SkillCreature_C:PickUsableEntity(Eids)
  local n = Eids and #Eids or 0
  if n <= 0 then
    return nil
  end
  local B = GetBattleForFilter(self)
  if not B then
    return nil
  end
  local Start = math.random(1, n)
  for i = 0, n - 1 do
    local Entity = B:GetEntity(Eids[(Start + i - 1) % n + 1])
    if IsEntityUsable(Entity) then
      return Entity
    end
  end
  Eids.AllDead = true
  return nil
end

function BP_SkillCreature_C:AcquireSharedTarget(Keys, Opts)
  Opts = Opts or EMPTY_OPTS
  local Interval = Opts.Interval or 0.15
  local Throttled = not Opts.NoThrottle
  local Now
  if Throttled then
    Now = UE4.UGameplayStatics.GetTimeSeconds(self)
    if not self.FilterNextAt then
      self.FilterNextAt = Now + (Opts.Stagger == false and 0 or math.random() * Interval)
    end
    if Now < self.FilterNextAt then
      return nil
    end
  end
  local Eids, Key = self:QuerySharedTargetEids(Keys, Opts)
  local Entity = self:PickUsableEntity(Eids)
  if Throttled then
    self.FilterNextAt = Now + Interval
  end
  return Entity, Eids, Key
end

function BP_SkillCreature_C:GetFilterRandomTarget(FilterKeys, AllowSkillRangeModify, CacheTTL)
  if not self.InitSuccess then
    return -1
  end
  local TTL, Share = CacheTTL, true
  if nil == TTL then
    TTL = 0.2
  elseif TTL <= 0 then
    TTL, Share = 0, false
  end
  local Keys = NormalizeKeys(FilterKeys)
  local Allow = false
  if Keys and #Keys > 0 then
    Allow = AllowSkillRangeModify or false
  end
  local Entity = self:AcquireSharedTarget(Keys, {
    NoThrottle = true,
    TTL = TTL,
    Share = Share,
    AllowSkillRangeModify = Allow
  })
  return Entity and Entity.Eid or -1
end

AssembleComponents(BP_SkillCreature_C)
return BP_SkillCreature_C
