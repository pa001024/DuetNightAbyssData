require("UnLua")
local M = Class("BluePrints/Item/Chest/BP_MechanismBase_C")
local SHOOT_TARGET_INTERACTIVE_COMPONENT_CLASS = "/Game/BluePrints/Item/BP_ShootTargetInteractiveComponent.BP_ShootTargetInteractiveComponent_C"
local SHOOT_TARGET_READY_STATE_ID = 950001
local SHOOT_TARGET_ACTIVE_STATE_ID = 950002

function M:BeginInitInfo()
  if self.InitSuccess then
    return
  end
  local Info = self.InfoForInitNew
  if not Info or Info.UnitId == nil or Info.UnitId <= 0 then
    GWorld.logger.error("BP_ShootTarget_C BeginInitInfo invalid registered UnitId: " .. tostring(Info and Info.UnitId))
    return
  end
  self:InitActorInfo_New(Info)
end

local function ToBool(Value)
  if type(Value) == "boolean" then
    return Value
  end
  if type(Value) == "number" then
    if 1 == Value then
      return true
    end
    if 0 == Value then
      return false
    end
  end
  if type(Value) == "string" then
    local Lower = string.lower(Value)
    if "true" == Lower or "1" == Lower then
      return true
    end
    if "false" == Lower or "0" == Lower then
      return false
    end
  end
  return nil
end

local function AppendValue(List, Value)
  if nil == Value or "" == Value then
    return
  end
  if type(Value) == "string" then
    for Token in string.gmatch(Value, "[^,;|%s]+") do
      table.insert(List, tonumber(Token) or Token)
    end
    return
  end
  table.insert(List, Value)
end

local function ToList(Value)
  local Result = {}
  if nil == Value then
    return Result
  end
  if type(Value) == "table" then
    if #Value > 0 then
      for _, Item in ipairs(Value) do
        AppendValue(Result, Item)
      end
    else
      for _, Item in pairs(Value) do
        AppendValue(Result, Item)
      end
    end
    return Result
  end
  if type(Value) == "userdata" then
    local Ok, Length = pcall(function()
      return Value:Length()
    end)
    if Ok and Length and Length > 0 then
      for i = 1, Length do
        local Item = Value:GetRef(i)
        AppendValue(Result, Item)
      end
      return Result
    end
  end
  AppendValue(Result, Value)
  return Result
end

local function CopyOption(Item, Index)
  if type(Item) == "table" then
    local GameId = Item.GameId or Item.GameID or Item.ID or Item.Id or Item.ShootTargetGameId or Item.ShootTargetId or Item.ExploreShootingID or Item.ExploreShootingId or Item.TargetId or Item[1]
    if not GameId then
      return nil
    end
    local Option = {}
    for Key, Value in pairs(Item) do
      Option[Key] = Value
    end
    Option.GameId = tonumber(GameId) or GameId
    Option.Index = Option.Index or Index
    return Option
  end
  local GameId = tonumber(Item) or Item
  if not GameId then
    return nil
  end
  return {GameId = GameId, Index = Index}
end

local function SyncInteractiveComponentFromDefault(Component, DefaultComponent)
  if not Component or not DefaultComponent then
    return
  end
  if Component.K2_SetWorldTransform and DefaultComponent.K2_GetComponentToWorld then
    Component:K2_SetWorldTransform(DefaultComponent:K2_GetComponentToWorld(), false, nil, false)
  elseif Component.K2_SetWorldLocationAndRotation and DefaultComponent.K2_GetComponentLocation and DefaultComponent.K2_GetComponentRotation then
    Component:K2_SetWorldLocationAndRotation(DefaultComponent:K2_GetComponentLocation(), DefaultComponent:K2_GetComponentRotation(), false, nil, false)
  end
  if Component.SetSphereRadius and DefaultComponent.GetUnscaledSphereRadius then
    local Radius = DefaultComponent:GetUnscaledSphereRadius()
    if Radius and Radius > 0 then
      Component:SetSphereRadius(Radius, true)
    end
  end
  if Component.SyncInteractiveComponentLocationInfo then
    Component:SyncInteractiveComponentLocationInfo()
  end
end

local function GetArrayLength(Array)
  if not Array then
    return 0
  end
  if type(Array) == "table" then
    return #Array
  end
  local Ok, Length = pcall(function()
    return Array:Length()
  end)
  if Ok and Length then
    return Length
  end
  return 0
end

local function GetArrayItem(Array, Index)
  if type(Array) == "table" then
    return Array[Index]
  end
  local Ok, Item = pcall(function()
    return Array:GetRef(Index)
  end)
  if Ok then
    return Item
  end
  return nil
end

local function AddUniqueComponent(Result, Added, Component)
  if Component and not Added[Component] then
    Added[Component] = true
    table.insert(Result, Component)
  end
end

local function GetShootTargetInteractiveComponents(Owner, ComponentClass)
  local Result = {}
  local Added = {}
  AddUniqueComponent(Result, Added, Owner.BP_ShootTargetInteractiveComponent)
  AddUniqueComponent(Result, Added, Owner.ShootTargetInteractiveComponent)
  local CachedComponents = Owner.ShootTargetInteractiveComponents
  if CachedComponents then
    for i = 1, #CachedComponents do
      AddUniqueComponent(Result, Added, CachedComponents[i])
    end
  end
  if ComponentClass and Owner.K2_GetComponentsByClass then
    local Ok, Components = pcall(function()
      return Owner:K2_GetComponentsByClass(ComponentClass)
    end)
    if Ok and Components then
      for i = 1, GetArrayLength(Components) do
        AddUniqueComponent(Result, Added, GetArrayItem(Components, i))
      end
    end
  end
  return Result
end

local function ApplyInteractiveDefaults(Component)
  if not Component then
    return
  end
  if not Component.InteractiveDistance or Component.InteractiveDistance <= 0 then
    Component:SetInteractiveDistance(300)
  end
  if not Component.InteractiveFaceAngle or Component.InteractiveFaceAngle <= 0 then
    Component.InteractiveFaceAngle = 360
  end
  if not Component.InteractiveAngle or Component.InteractiveAngle <= 0 then
    Component.InteractiveAngle = 360
  end
end

local function NormalizeOptions(Options)
  local Result = {}
  local Added = {}
  if type(Options) == "table" and 0 == #Options then
    for Key, Item in pairs(Options) do
      local Option = CopyOption(Item, #Result + 1)
      if not Option and type(Item) == "table" and nil ~= Key then
        Option = {}
        for ItemKey, ItemValue in pairs(Item) do
          Option[ItemKey] = ItemValue
        end
        Option.GameId = tonumber(Key) or Key
        Option.Index = Option.Index or #Result + 1
      elseif not Option and nil ~= Key then
        Option = CopyOption(Key, #Result + 1)
      elseif Option and type(Item) == "table" and not Item.GameId and not Item.GameID and not Item.ID and not Item.Id and not Item.ShootTargetGameId and not Item.ShootTargetId and not Item.ExploreShootingID and not Item.ExploreShootingId and not Item.TargetId and not Item[1] then
        Option.GameId = tonumber(Key) or Key
      end
      if Option and Option.GameId then
        local IdKey = tostring(Option.GameId)
        if not Added[IdKey] then
          Added[IdKey] = true
          table.insert(Result, Option)
        end
      end
    end
    return Result
  end
  local List = ToList(Options)
  for i = 1, #List do
    local Option = CopyOption(List[i], i)
    if Option and Option.GameId then
      local Key = tostring(Option.GameId)
      if not Added[Key] then
        Added[Key] = true
        table.insert(Result, Option)
      end
    end
  end
  return Result
end

local function GetOptionBool(Option, Config, Key)
  if Option and nil ~= Option[Key] then
    return ToBool(Option[Key])
  end
  if Config and nil ~= Config[Key] then
    return ToBool(Config[Key])
  end
  return nil
end

local function IsUnlockRuleSatisfied(UnlockRule, Avatar)
  local Rule = ToList(UnlockRule)
  if 0 == #Rule then
    return true
  end
  local ItemId = tonumber(Rule[1])
  if nil == ItemId then
    return false
  end
  if ItemId <= 0 then
    return true
  end
  local NeedCount = 1
  if 2 == #Rule then
    NeedCount = tonumber(Rule[2])
    if nil == NeedCount or NeedCount <= 0 then
      return false
    end
  elseif #Rule > 2 then
    return false
  end
  if not Avatar then
    return false
  end
  local OwnedCount = tonumber(Avatar:GetResourceNum(ItemId)) or 0
  return NeedCount <= OwnedCount
end

function M:_GetShootTargetConfig(GameId)
  if DataMgr and DataMgr.ExploreShootingID then
    return DataMgr.ExploreShootingID[tonumber(GameId) or GameId]
  end
  return nil
end

function M:_GetShootTargetOptionsFromParams()
  local UnitParams = self.UnitParams or {}
  return NormalizeOptions(UnitParams.GameIds)
end

function M:_GetShootTargetOptions()
  if not self.ShootTargetResolvedOptions then
    self.ShootTargetResolvedOptions = self:_GetShootTargetOptionsFromParams()
    self:_RebuildShootTargetOptionMap()
  end
  return self.ShootTargetResolvedOptions
end

function M:_RebuildShootTargetOptionMap()
  self.ShootTargetOptionMap = {}
  local Options = self.ShootTargetResolvedOptions or {}
  for _, Option in ipairs(Options) do
    self.ShootTargetOptionMap[tostring(Option.GameId)] = Option
  end
end

function M:GetShootTargetOptionInfo(GameId)
  self:_GetShootTargetOptions()
  return self.ShootTargetOptionMap and self.ShootTargetOptionMap[tostring(GameId)]
end

function M:IsShootTargetInteractionEnabled()
  local StateId = self.ShootTargetMechanismStateId or self.StateId
  return StateId == SHOOT_TARGET_READY_STATE_ID
end

function M:_EnsureShootTargetInteractiveComponents()
  local Options = self:_GetShootTargetOptions()
  local bInteractionEnabled = self:IsShootTargetInteractionEnabled()
  local UnitParams = self.UnitParams or {}
  local ComponentClass = self.ShootTargetInteractiveComponentClass
  local ComponentClassPath = self.ShootTargetInteractiveComponentClassPath or UnitParams.ShootTargetInteractiveComponentClassPath or SHOOT_TARGET_INTERACTIVE_COMPONENT_CLASS
  ComponentClass = ComponentClass or LoadClass(ComponentClassPath)
  if not ComponentClass then
    GWorld.logger.error("BP_ShootTarget_C missing interactive component class: " .. tostring(ComponentClassPath))
    return
  end
  local ExistingComponents = GetShootTargetInteractiveComponents(self, ComponentClass)
  self.ShootTargetInteractiveComponents = {}
  self.TempleInteractiveComponents = self.ShootTargetInteractiveComponents
  if self.DefaultInteractiveComponent then
    self.DefaultInteractiveComponent.bCanUsed = false
  end
  for i = 1, #Options do
    local Component = ExistingComponents[i]
    Component = Component or self:AddComponentByClass(ComponentClass, false, FTransform(), false)
    self.ShootTargetInteractiveComponents[i] = Component
    Component.bCanUsed = bInteractionEnabled
    Component.Owner = self
    Component:SetShootTargetInfo(Options[i].GameId, Options[i])
    if self.DefaultInteractiveComponent then
      SyncInteractiveComponentFromDefault(Component, self.DefaultInteractiveComponent)
      if self.DefaultInteractiveComponent.InteractiveDistance and self.DefaultInteractiveComponent.InteractiveDistance > 0 then
        Component:SetInteractiveDistance(self.DefaultInteractiveComponent.InteractiveDistance)
      end
      if self.DefaultInteractiveComponent.InteractiveAngle and self.DefaultInteractiveComponent.InteractiveAngle > 0 then
        Component.InteractiveAngle = self.DefaultInteractiveComponent.InteractiveAngle
      end
      if self.DefaultInteractiveComponent.InteractiveFaceAngle and self.DefaultInteractiveComponent.InteractiveFaceAngle > 0 then
        Component.InteractiveFaceAngle = self.DefaultInteractiveComponent.InteractiveFaceAngle
      end
    end
    ApplyInteractiveDefaults(Component)
    local CommonUIConfirmID = self.Data and self.Data.InteractiveId
    if CommonUIConfirmID then
      Component:InitCommonUIConfirmID(CommonUIConfirmID)
    elseif self.DefaultInteractiveComponent and self.DefaultInteractiveComponent.CommonUIConfirmID then
      Component:InitCommonUIConfirmID(self.DefaultInteractiveComponent.CommonUIConfirmID)
    end
  end
  for i = #Options + 1, #self.ShootTargetInteractiveComponents do
    local Component = self.ShootTargetInteractiveComponents[i]
    if Component then
      Component.bCanUsed = false
      Component:SetShootTargetInfo(0)
      if self.CurrentShootTargetInteractPlayer and Component:IsBtnDisplayed(self.CurrentShootTargetInteractPlayer) then
        Component:NotDisplayInteractiveBtn(self.CurrentShootTargetInteractPlayer)
      end
    end
  end
  for i = #Options + 1, #ExistingComponents do
    local Component = ExistingComponents[i]
    if Component then
      Component.bCanUsed = false
      Component:SetShootTargetInfo(0)
      if self.CurrentShootTargetInteractPlayer and Component:IsBtnDisplayed(self.CurrentShootTargetInteractPlayer) then
        Component:NotDisplayInteractiveBtn(self.CurrentShootTargetInteractPlayer)
      end
    end
  end
end

function M:MovePlayerToShootTargetPoint(PlayerEid)
  local PlayerPoint = self.ShootTargetPlayerPoint
  if not PlayerPoint or not IsValid(PlayerPoint) then
    GWorld.logger.error("BP_ShootTarget_C MovePlayerToShootTargetPoint failed: ShootTargetPlayerPoint is invalid")
    return false
  end
  local BattleInstance = Battle(self)
  local Player = BattleInstance and BattleInstance:GetEntity(PlayerEid) or nil
  if not Player or not IsValid(Player) then
    GWorld.logger.error("BP_ShootTarget_C MovePlayerToShootTargetPoint failed: player not found, PlayerEid " .. tostring(PlayerEid))
    return false
  end
  local PlayerLocation = PlayerPoint:K2_GetComponentLocation()
  local PointRotation = PlayerPoint:K2_GetComponentRotation()
  local PlayerRotation = FRotator(0, PointRotation.Yaw, 0)
  Player:K2_SetActorLocationAndRotation(PlayerLocation, PlayerRotation, false, nil, false)
  local Controller = Player:GetController()
  if Controller then
    Controller:SetControlRotation(PointRotation)
  end
  return true
end

function M:RestoreShootTargetReadyState(PlayerEid)
  self.bShootTargetOpening = false
  self.CurrentShootTargetGameId = nil
  local RealPlayerEid = tonumber(PlayerEid) or 0
  local BattleInstance = Battle(self)
  local PlayerActor = RealPlayerEid > 0 and BattleInstance and BattleInstance:GetEntity(RealPlayerEid) or nil
  if not PlayerActor or not IsValid(PlayerActor) then
    PlayerActor = self.ShootTargetLastInteractPlayer
  end
  self.ShootTargetLastInteractPlayer = nil
  if PlayerActor and IsValid(PlayerActor) then
    self.CurrentShootTargetInteractPlayer = PlayerActor
  end
  local StateId = self.ShootTargetMechanismStateId or self.StateId
  if StateId == SHOOT_TARGET_ACTIVE_STATE_ID then
    self:ChangeState("Manual", RealPlayerEid, SHOOT_TARGET_READY_STATE_ID)
  elseif StateId ~= SHOOT_TARGET_READY_STATE_ID then
    return false
  end
  if PlayerActor and IsValid(PlayerActor) then
    self:AddTimer(0.05, function()
      if PlayerActor and IsValid(PlayerActor) and self:IsShootTargetInteractionEnabled() then
        self:DisplayInteractiveBtn(PlayerActor)
      end
    end, false, 0, "ShootTargetRestoreInteractiveBtn", true)
  end
  return true
end

function M:OpenMechanism(PlayerEid, ShootTargetGameId)
  if not self:IsShootTargetInteractionEnabled() then
    return false
  end
  if type(PlayerEid) == "table" then
    ShootTargetGameId = ShootTargetGameId or PlayerEid.ShootTargetGameId
    PlayerEid = PlayerEid.Eid
  elseif type(PlayerEid) == "userdata" then
    local Ok, ParamsGameId = pcall(function()
      return PlayerEid.ShootTargetGameId
    end)
    if Ok and not ShootTargetGameId then
      ShootTargetGameId = ParamsGameId
    end
    local OkEid, ParamsEid = pcall(function()
      return PlayerEid.Eid
    end)
    if OkEid then
      PlayerEid = ParamsEid
    end
  end
  self.CurrentShootTargetGameId = ShootTargetGameId or self.CurrentShootTargetGameId
  local GameId = tonumber(self.CurrentShootTargetGameId) or self.CurrentShootTargetGameId
  local Config = self:_GetShootTargetConfig(GameId)
  if not Config then
    GWorld.logger.error("BP_ShootTarget_C OpenMechanism failed: ExploreShootingID config not found, GameId " .. tostring(GameId))
    return false
  end
  local ExploreGroupId = tonumber(Config.ExploreGroupId)
  if not ExploreGroupId or ExploreGroupId <= 0 then
    return false
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local ExploreGroup = GameState and GameState.ExploreGroupMap and GameState.ExploreGroupMap:FindRef(ExploreGroupId)
  if not ExploreGroup or not IsValid(ExploreGroup) then
    GWorld.logger.error("BP_ShootTarget_C OpenMechanism failed: ExploreGroup not found, ExploreGroupId " .. tostring(ExploreGroupId) .. ", GameId " .. tostring(GameId))
    return false
  end
  local ExploreGroupStatus = ExploreGroup:GetStatus()
  if ExploreGroupStatus ~= EExploreGroupStatus.EGS_Deactive and ExploreGroupStatus ~= EExploreGroupStatus.EGS_Complete and ExploreGroupStatus ~= EExploreGroupStatus.EGS_LimitComplete then
    GWorld.logger.error("BP_ShootTarget_C OpenMechanism failed: ExploreGroup cannot be activated, E xploreGroupId " .. tostring(ExploreGroupId) .. ", GameId " .. tostring(GameId) .. ", Status " .. tostring(ExploreGroupStatus))
    return false
  end
  local IsCompleted = ExploreGroupStatus == EExploreGroupStatus.EGS_Complete or ExploreGroupStatus == EExploreGroupStatus.EGS_LimitComplete
  if IsCompleted then
    local Avatar = GWorld:GetAvatar()
    local Explore = Avatar and Avatar.Explores and Avatar.Explores[ExploreGroupId]
    if Explore and Explore.StarBonusList and 0 == Explore.StarBonusList:Length() then
      GWorld.logger.info("BP_ShootTarget_C OpenMechanism skipped: completed ExploreGroup has empty StarBonusList, ExploreGroupId " .. tostring(ExploreGroupId) .. ", GameId " .. tostring(GameId))
      return false
    end
    ExploreGroup:TryDeactive()
    ExploreGroup:ReceiveOnExploreGroupReset()
  end
  if not ExploreGroup.SetSelectedShootTargetGameId or not ExploreGroup:SetSelectedShootTargetGameId(GameId) then
    GWorld.logger.error("BP_ShootTarget_C OpenMechanism failed: invalid ShootTarget ExploreGroup, ExploreGroupId " .. tostring(ExploreGroupId) .. ", GameId " .. tostring(GameId))
    return false
  end
  if not ExploreGroup.SetShootTargetSourceMechanism or not ExploreGroup:SetShootTargetSourceMechanism(self, PlayerEid) then
    GWorld.logger.error("BP_ShootTarget_C OpenMechanism failed: cannot bind source mechanism, ExploreGroupId " .. tostring(ExploreGroupId) .. ", GameId " .. tostring(GameId))
    return false
  end
  self:ChangeState("Manual", PlayerEid, SHOOT_TARGET_ACTIVE_STATE_ID)
  ExploreGroup:SetExploreGroupStatus(EExploreGroupStatus.EGS_Active)
  return true
end

function M:OnActorReady(Info)
  M.Super.OnActorReady(self, Info)
  self:InitTargetInteractiveComponent()
end

function M:ShowToast(ToastText)
  if ToastText and "" ~= ToastText then
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText(ToastText))
  end
end

function M:InitTargetInteractiveComponent()
  self.ShootTargetResolvedOptions = self:_GetShootTargetOptionsFromParams()
  self:_RebuildShootTargetOptionMap()
  self:_EnsureShootTargetInteractiveComponents()
end

function M:SetShootTargetGameIds(GameIds)
  local Options = NormalizeOptions(GameIds)
  self:SetShootTargetGameOptions(Options)
end

function M:SetShootTargetGameOptions(Options)
  local PlayerActor = self.CurrentShootTargetInteractPlayer
  if PlayerActor then
    self:NotDisplayInteractiveBtn(PlayerActor)
  end
  self.ShootTargetResolvedOptions = NormalizeOptions(Options)
  self:_RebuildShootTargetOptionMap()
  self:_EnsureShootTargetInteractiveComponents()
  if PlayerActor and IsValid(PlayerActor) then
    self:DisplayInteractiveBtn(PlayerActor)
  end
end

function M:IsShootTargetPlayerInStoryMode(PlayerActor)
  local Avatar = GWorld:GetAvatar()
  if Avatar and (Avatar.InSpecialQuest or Avatar.IsInSpecialQuest and Avatar:IsInSpecialQuest()) then
    return true
  end
  local Controller = PlayerActor and PlayerActor:GetController()
  if Controller and Controller.GetStoryModeState and Controller:GetStoryModeState() then
    return true
  end
  return false
end

function M:IsShootTargetPlayerStateAllowed(PlayerActor, GameId, Component)
  if not PlayerActor or not PlayerActor:IsMainPlayer() then
    return false
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if GameState and GameState.ActiveLimitTimeExploreGroup and 0 ~= GameState.ActiveLimitTimeExploreGroup then
    return false
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.InExploreChanllenge and Avatar:InExploreChanllenge() then
    return false
  end
  return self:CheckShootTargetPlayerState(PlayerActor, GameId, Component)
end

function M:CheckShootTargetPlayerState(PlayerActor, GameId, Component)
  return true
end

function M:IsShootTargetOptionVisible(GameId, PlayerActor, Component)
  if not self:IsShootTargetInteractionEnabled() then
    return false
  end
  if not self:IsShootTargetPlayerStateAllowed(PlayerActor, GameId, Component) then
    return false
  end
  local Option = self:GetShootTargetOptionInfo(GameId)
  local Config = self:_GetShootTargetConfig(GameId)
  local bStoryOption = GetOptionBool(Option, Config, "StoryMode")
  if nil ~= bStoryOption and bStoryOption ~= self:IsShootTargetPlayerInStoryMode(PlayerActor) then
    return false
  end
  local Avatar = GWorld:GetAvatar()
  local ShowConditionId = Option and (Option.ShowConditionId or Option.ShowCondition)
  if ShowConditionId and 0 ~= tonumber(ShowConditionId) and Avatar and not ConditionUtils.CheckCondition(Avatar, ShowConditionId) then
    return false
  end
  if Option and ToBool(Option.Locked) == true then
    return false
  end
  local UnlockConditionId = Option and (Option.UnlockConditionId or Option.ConditionId)
  if UnlockConditionId and 0 ~= tonumber(UnlockConditionId) and (not Avatar or not ConditionUtils.CheckCondition(Avatar, UnlockConditionId)) then
    return false
  end
  if Option and true == ToBool(Option.HideWhenComplete) and self:IsShootTargetGameComplete(GameId) then
    return false
  end
  return self:CheckShootTargetOptionVisible(GameId, PlayerActor, Component)
end

function M:CheckShootTargetOptionVisible(GameId, PlayerActor, Component)
  local Config = self:_GetShootTargetConfig(GameId)
  return IsUnlockRuleSatisfied(Config and Config.Unlock, GWorld:GetAvatar())
end

function M:IsShootTargetGameComplete(GameId)
  local Option = self:GetShootTargetOptionInfo(GameId)
  if Option and Option.Completed ~= nil then
    return ToBool(Option.Completed) == true
  end
  return false
end

function M:IsShootTargetOptionLocked(GameId, Component)
  return false
end

function M:IsShootTargetOptionForbidden(GameId, PlayerActor, Component)
  local Option = self:GetShootTargetOptionInfo(GameId)
  if Option and Option.Forbidden ~= nil then
    return ToBool(Option.Forbidden) == true
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.IsInTeam and Avatar:IsInTeam() and (not Option or true ~= ToBool(Option.AllowTeam)) then
    return true
  end
  return false
end

function M:LockShootTargetOption(GameId, Component)
  local Option = self:GetShootTargetOptionInfo(GameId)
  local ToastText = Option and (Option.LockToast or Option.LockToastText)
  self:ShowToast(ToastText or "UI_Tosat_Temple_Locked")
end

function M:OnShootTargetOptionForbidden(GameId, PlayerActor, Component)
  local Option = self:GetShootTargetOptionInfo(GameId)
  local ToastText = Option and (Option.ForbiddenToast or Option.ForbiddenToastText)
  if ToastText then
    self:ShowToast(ToastText)
  end
end

function M:GetShootTargetInteractiveName(GameId, Component)
  local Option = self:GetShootTargetOptionInfo(GameId)
  local Name = Option and (Option.InteractiveName or Option.Name or Option.TextName)
  if Name and "" ~= Name and "-1" ~= Name then
    return GText(Name)
  end
  local Config = self:_GetShootTargetConfig(GameId)
  if Config and Config.TextName and Config.TextName ~= "" and Config.TextName ~= "-1" then
    return GText(Config.TextName)
  end
  return "ShootTarget " .. tostring(GameId)
end

function M:GetShootTargetInteractiveIcon(GameId, PlayerActor, Component)
  local Option = self:GetShootTargetOptionInfo(GameId)
  return Option and Option.Icon
end

function M:GetShootTargetStars(GameId, Component)
  local Option = self:GetShootTargetOptionInfo(GameId)
  if Option and Option.Stars ~= nil then
    return tonumber(Option.Stars) or Option.Stars
  end
  local Config = self:_GetShootTargetConfig(GameId)
  local ExploreGroupId = Config and tonumber(Config.ExploreGroupId)
  if not ExploreGroupId or ExploreGroupId <= 0 then
    return nil
  end
  local ExploreGroupReward = DataMgr and DataMgr.ExploreGroupReward and DataMgr.ExploreGroupReward[ExploreGroupId]
  local StarRewardCount = GetArrayLength(ExploreGroupReward and ExploreGroupReward.RewardIdList)
  if StarRewardCount <= 0 then
    return nil
  end
  local Avatar = GWorld:GetAvatar()
  local Explore = Avatar and Avatar.Explores and Avatar.Explores[ExploreGroupId]
  local StarBonusList = Explore and Explore.StarBonusList
  local Stars = 0
  for i = 1, math.min(StarRewardCount, 3) do
    if StarBonusList and 0 ~= (tonumber(StarBonusList[i]) or 0) then
      Stars = i
    end
  end
  return Stars
end

function M:GetShootTargetShowTagNew(GameId, Component)
  local Option = self:GetShootTargetOptionInfo(GameId)
  if Option and Option.ShowTagNew ~= nil then
    return ToBool(Option.ShowTagNew) == true
  end
  return false
end

function M:OpenShootTargetGame(PlayerActor, GameId, Component)
  return self:OpenMechanism(PlayerActor and PlayerActor.Eid or 0, GameId)
end

function M:_CloseResidualInteractiveUI()
  local UIManagerComp = UIManager(self)
  if not UIManagerComp or not UIManagerComp.GetUIObj then
    return
  end
  local InteractiveUI = UIManagerComp:GetUIObj(UIConst.InteractiveUIName)
  if InteractiveUI and not InteractiveUI.IsMarkToRemove then
    InteractiveUI:Close()
  end
end

function M:_RestoreShootTargetInteractionAfterOpenFailed(PlayerActor)
  self.bShootTargetOpening = false
  self.CurrentShootTargetGameId = nil
  self.ShootTargetLastInteractPlayer = nil
  if PlayerActor and IsValid(PlayerActor) then
    self:DisplayInteractiveBtn(PlayerActor)
  end
end

function M:StartShootTargetGame(PlayerActor, GameId, Component)
  if self.bShootTargetOpening then
    return
  end
  if not self:IsShootTargetOptionVisible(GameId, PlayerActor, Component) then
    self:RefreshShootTargetInteractiveOptions(PlayerActor)
    return
  end
  if self:IsShootTargetOptionForbidden(GameId, PlayerActor, Component) then
    self:OnShootTargetOptionForbidden(GameId, PlayerActor, Component)
    return
  end
  self.bShootTargetOpening = true
  self.CurrentShootTargetGameId = GameId
  self.ShootTargetLastInteractPlayer = PlayerActor
  self:NotDisplayInteractiveBtn(PlayerActor)
  self:AddTimer(0.01, function()
    self:_CloseResidualInteractiveUI()
    self:AddTimer(0.01, function()
      if not (PlayerActor and IsValid(PlayerActor)) or not self:IsShootTargetInteractionEnabled() then
        self:_RestoreShootTargetInteractionAfterOpenFailed(PlayerActor)
        return
      end
      self.bShootTargetOpening = false
      if not self:OpenShootTargetGame(PlayerActor, GameId, Component) then
        self:_RestoreShootTargetInteractionAfterOpenFailed(PlayerActor)
      end
    end, false, 0, "ShootTargetOpenAfterInteractiveUIClose", true)
  end, false, 0, "ShootTargetCloseResidualInteractiveUI", true)
end

function M:RefreshShootTargetInteractiveOptions(PlayerActor)
  self:_EnsureShootTargetInteractiveComponents()
  PlayerActor = PlayerActor or self.CurrentShootTargetInteractPlayer
  if not PlayerActor or not IsValid(PlayerActor) then
    return
  end
  if not self:IsShootTargetInteractionEnabled() then
    self:NotDisplayInteractiveBtn(PlayerActor)
    return
  end
  for i = 1, #self.ShootTargetInteractiveComponents do
    local Component = self.ShootTargetInteractiveComponents[i]
    if Component and Component.bCanUsed ~= false and Component:IsCanInteractive(PlayerActor) then
      Component:DisplayInteractiveBtn(PlayerActor)
    elseif Component and Component:IsBtnDisplayed(PlayerActor) then
      Component:NotDisplayInteractiveBtn(PlayerActor)
    end
  end
end

function M:DisplayInteractiveBtn(PlayerActor)
  if not self:IsShootTargetInteractionEnabled() then
    return
  end
  self.CurrentShootTargetInteractPlayer = PlayerActor
  self:RefreshShootTargetInteractiveOptions(PlayerActor)
end

function M:NotDisplayInteractiveBtn(PlayerActor)
  local Components = self.ShootTargetInteractiveComponents or self.TempleInteractiveComponents
  if Components then
    for i = 1, #Components do
      Components[i]:NotDisplayInteractiveBtn(PlayerActor)
    end
  end
  if self.CurrentShootTargetInteractPlayer == PlayerActor then
    self.CurrentShootTargetInteractPlayer = nil
  end
end

function M:OnEnterState(NowStateId)
  self.Overridden.OnEnterState(self, NowStateId)
  self.ShootTargetMechanismStateId = NowStateId
  local InteractPlayer = self.CurrentShootTargetInteractPlayer
  self:InitTargetInteractiveComponent()
  if self:IsShootTargetInteractionEnabled() then
    if InteractPlayer and IsValid(InteractPlayer) then
      self:RefreshShootTargetInteractiveOptions(InteractPlayer)
    end
  elseif InteractPlayer and IsValid(InteractPlayer) then
    self:NotDisplayInteractiveBtn(InteractPlayer)
  end
  if NowStateId == SHOOT_TARGET_ACTIVE_STATE_ID then
    local PlayerEid = self.CombatStateChangeComponent and self.CombatStateChangeComponent.PlayerEid or 0
    if PlayerEid > 0 then
      self:MovePlayerToShootTargetPoint(PlayerEid)
    end
  end
end

return M
