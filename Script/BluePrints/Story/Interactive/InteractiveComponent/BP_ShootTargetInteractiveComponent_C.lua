require("UnLua")
require("DataMgr")
local LuaConst = require("EMLuaConst")
local BP_ShootTargetInteractiveComponent_C = Class("BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C")

local function GetShootTargetOwner(self)
  return self.Owner or self:GetOwner()
end

local function CallOwner(self, FuncName, ...)
  local Owner = GetShootTargetOwner(self)
  if Owner and Owner[FuncName] then
    return Owner[FuncName](Owner, ...)
  end
  return nil
end

local function IsValidShootTargetGameId(GameId)
  local NumberGameId = tonumber(GameId)
  return nil ~= NumberGameId and NumberGameId > 0
end

local function EnsureInteractiveDefaults(self)
  if not self.InteractiveDistance or self.InteractiveDistance <= 0 then
    self:SetInteractiveDistance(300)
  end
  if not self.InteractiveFaceAngle or self.InteractiveFaceAngle <= 0 then
    self.InteractiveFaceAngle = 360
  end
  if not self.InteractiveAngle or self.InteractiveAngle <= 0 then
    self.InteractiveAngle = 360
  end
  if self.SyncInteractiveComponentLocationInfo then
    self:SyncInteractiveComponentLocationInfo()
  end
end

function BP_ShootTargetInteractiveComponent_C:ReceiveBeginPlay()
  self.Super.ReceiveBeginPlay(self)
  self.Owner = self:GetOwner()
  self.ShootTargetGameId = 0
  self.ShootTargetOptionInfo = nil
end

function BP_ShootTargetInteractiveComponent_C:TriggerTick(PlayerActor)
  if not IsValidShootTargetGameId(self.ShootTargetGameId) then
    if self:IsBtnDisplayed(PlayerActor) then
      self:NotDisplayInteractiveBtn(PlayerActor)
    end
    return
  end
  EnsureInteractiveDefaults(self)
  self.Overridden.TriggerTick(self, PlayerActor)
end

function BP_ShootTargetInteractiveComponent_C:IsCanInteractive(PlayerActor)
  if self.bCanUsed == false then
    return false
  end
  if not PlayerActor then
    return false
  end
  if not IsValidShootTargetGameId(self.ShootTargetGameId) then
    return false
  end
  EnsureInteractiveDefaults(self)
  local bVisible = CallOwner(self, "IsShootTargetOptionVisible", self.ShootTargetGameId, PlayerActor, self)
  if false == bVisible then
    return false
  end
  local InteractiveName = self:GetInteractiveName()
  local DistanceCheckResult = self:GetDistanceCheckResult()
  DistanceCheckResult = LuaConst.OpenComputeInteractive and DistanceCheckResult or self.DistanceCheckComponent(self, PlayerActor, self.InteractiveDistance, false)
  local FaceToACheckResult = self.CFaceToACheckComponent(self, PlayerActor, self.InteractiveFaceAngle, false)
  local FaceToCCheckResult = self.AFaceToCCheckComponent(PlayerActor, self, self.InteractiveAngle, false)
  local PlayerTagCheckResult = self:CheckPlayerTag(PlayerActor)
  if LuaConst.OpenComputeInteractive then
    return "" ~= InteractiveName and DistanceCheckResult and FaceToACheckResult and FaceToCCheckResult and PlayerTagCheckResult
  end
  return "" ~= InteractiveName and DistanceCheckResult and FaceToACheckResult and FaceToCCheckResult and PlayerTagCheckResult
end

function BP_ShootTargetInteractiveComponent_C:UpdateDisplayInteractiveBtn(PlayerActor)
  if not PlayerActor or not PlayerActor:IsMainPlayer() then
    return
  end
  local bCanInteractive = self:IsCanInteractive(PlayerActor)
  if bCanInteractive and not self:IsBtnDisplayed(PlayerActor) then
    local Owner = GetShootTargetOwner(self)
    if Owner and Owner.RefreshShootTargetInteractiveOptions then
      Owner:RefreshShootTargetInteractiveOptions(PlayerActor)
    else
      self:DisplayInteractiveBtn(PlayerActor)
    end
  elseif bCanInteractive and self:IsBtnDisplayed(PlayerActor) then
    self:RefreshInteractiveBtn(PlayerActor)
  elseif false == bCanInteractive and self:IsBtnDisplayed(PlayerActor) then
    self:NotDisplayInteractiveBtn(PlayerActor)
  end
end

function BP_ShootTargetInteractiveComponent_C:GetInteractiveName()
  local Name = CallOwner(self, "GetShootTargetInteractiveName", self.ShootTargetGameId, self)
  if nil ~= Name then
    return Name
  end
  local Info = self.ShootTargetOptionInfo or {}
  local Key = Info.InteractiveName or Info.Name or Info.TextName
  if Key and "" ~= Key and "-1" ~= Key then
    return GText(Key)
  end
  return "ShootTarget " .. tostring(self.ShootTargetGameId)
end

function BP_ShootTargetInteractiveComponent_C:StartInteractive(PlayerActor)
  if self:IsForbidden(PlayerActor) then
    return
  end
  if self:IsCanInteractive(PlayerActor) then
    CallOwner(self, "StartShootTargetGame", PlayerActor, self.ShootTargetGameId, self)
  end
end

function BP_ShootTargetInteractiveComponent_C:BtnPressed(PlayerActor)
  if self:IsLocked() then
    self:LockInteractive()
    return
  end
  self:StartInteractive(PlayerActor)
end

function BP_ShootTargetInteractiveComponent_C:BtnReleased(PlayerActor, InPressTimeSeconds)
end

function BP_ShootTargetInteractiveComponent_C:BtnClicked(PlayerActor, InPressTimeSeconds)
  self:StartInteractive(PlayerActor)
end

function BP_ShootTargetInteractiveComponent_C:OnClicked_Forbidden()
  CallOwner(self, "OnShootTargetOptionForbidden", self.ShootTargetGameId, nil, self)
end

function BP_ShootTargetInteractiveComponent_C:OnClicked_Locked()
  self:LockInteractive()
end

function BP_ShootTargetInteractiveComponent_C:GetUUID()
  local Owner = GetShootTargetOwner(self)
  local OwnerName = Owner and Owner:GetName() or ""
  return self:GetClass():GetName() .. OwnerName .. "_ShootTarget_" .. tostring(self.ShootTargetGameId)
end

function BP_ShootTargetInteractiveComponent_C:IsLocked()
  return CallOwner(self, "IsShootTargetOptionLocked", self.ShootTargetGameId, self) == true
end

function BP_ShootTargetInteractiveComponent_C:IsForbidden(PlayerActor)
  return CallOwner(self, "IsShootTargetOptionForbidden", self.ShootTargetGameId, PlayerActor, self) == true
end

function BP_ShootTargetInteractiveComponent_C:LockInteractive()
  CallOwner(self, "LockShootTargetOption", self.ShootTargetGameId, self)
end

function BP_ShootTargetInteractiveComponent_C:GetInteractiveIcon(PlayerActor)
  if self:IsLocked() then
    return "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Interactive/T_Interactive_Lock.T_Interactive_Lock'"
  end
  if self:IsForbidden(PlayerActor) then
    return "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Interactive/T_Interactive_Forbidden.T_Interactive_Forbidden'"
  end
  return CallOwner(self, "GetShootTargetInteractiveIcon", self.ShootTargetGameId, PlayerActor, self)
end

function BP_ShootTargetInteractiveComponent_C:GetStars()
  return CallOwner(self, "GetShootTargetStars", self.ShootTargetGameId, self)
end

function BP_ShootTargetInteractiveComponent_C:GetShowTagNew()
  return CallOwner(self, "GetShootTargetShowTagNew", self.ShootTargetGameId, self) == true
end

function BP_ShootTargetInteractiveComponent_C:SetShootTargetInfo(GameId, OptionInfo)
  self.ShootTargetGameId = tonumber(GameId) or 0
  self.ShootTargetOptionInfo = OptionInfo or {}
  local Owner = GetShootTargetOwner(self)
  local OwnerName = Owner and Owner:GetName() or ""
  self.Content = {
    "ShootTarget",
    OwnerName,
    tostring(self.ShootTargetGameId)
  }
  rawset(self, "InteractiveNameCacheKey", nil)
  rawset(self, "InteractiveNameCacheValue", nil)
end

function BP_ShootTargetInteractiveComponent_C:SetShootTargetGameId(GameId)
  self:SetShootTargetInfo(GameId)
end

return BP_ShootTargetInteractiveComponent_C
