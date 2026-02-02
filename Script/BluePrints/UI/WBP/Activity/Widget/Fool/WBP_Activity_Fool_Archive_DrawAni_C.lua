require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local HUDUIName = "AprilFoolDayHUD"

function M:Construct()
  self:BindToAnimationFinished(self.In, {
    self,
    self.StartRandom
  })
  self:BindToAnimationFinished(self.Draw, {
    self,
    self.OnRandomFinished
  })
  self:BindToAnimationFinished(self.Out, {
    self,
    self.OnOutAnimationFinished
  })
  self:AddDispatcher(EventID.OnTeamRecoveryStateChange, self, self.CloseOnPlayerDead)
  self.Avatar = GWorld:GetAvatar()
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/fools_day_transform_panel_show", nil, nil)
end

function M:Destruct()
  self:UnbindAllFromAnimationFinished(self.In)
  self:UnbindAllFromAnimationFinished(self.Draw)
  self:UnbindAllFromAnimationFinished(self.Out)
end

function M:CloseOnPlayerDead(Eid, Type, PrevType)
  local Controller = self:GetOwningPlayer()
  local Player = Controller:K2_GetPawn()
  if Player and Eid == Player:GetEid() and Type == UE4.ETeamRecoveryState.Dying then
    self.SkipOpenFoolHUD = true
    self:Close()
  end
end

function M:StartRandom()
  self:PlayAnimation(self.Draw)
  self.TransformID, self.IsUnOwned = self:GetRandomTransformData()
end

function M:GetRandomTransformData()
  if not self.Avatar or not self.Avatar.UnlockedFoolsDayTransforms then
    return
  end
  local OwnedIds = {}
  local UnownedIds = {}
  for _, Data in pairs(DataMgr.TransformAFDayEvent or {}) do
    local Id = Data.TransformID
    if self.Avatar.UnlockedFoolsDayTransforms[Id] then
      table.insert(OwnedIds, Id)
    else
      table.insert(UnownedIds, Id)
    end
  end
  if 0 == #OwnedIds and 0 == #UnownedIds then
    return
  end
  if #UnownedIds > 0 then
    local RandIndex = CommonUtils:RandomInt(1, #UnownedIds)
    return UnownedIds[RandIndex], true
  else
    local RandIndex = CommonUtils:RandomInt(1, #OwnedIds)
    return OwnedIds[RandIndex], false
  end
end

function M:OnRandomFinished()
  if not self.TransformID then
    self:Close()
    return
  end
  self.DrawItem:StartDrawAnimation(self.TransformID)
  if self.IsUnOwned then
    self.Avatar:FoolsDayUnlockTransform(self.TransformID)
  end
  self.Avatar:CallServerMethod("FoolsDayUseTransform")
  self:AddTimer(1, function()
    self:PlayAnimation(self.Out)
  end)
end

function M:OnOutAnimationFinished()
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local Avatar = GWorld:GetAvatar()
  if PlayerCharacter and IsValid(PlayerCharacter) then
    PlayerCharacter:ApplyAFDTransform(self.TransformID)
    Avatar:RegionOnlineTransformAFDay(self.TransformID)
    AudioManager(self):PlayFMODSound(PlayerCharacter, nil, "event:/ui/activity/fools_day_transform_player_3d")
  end
  self:Close()
  if not self.SkipOpenFoolHUD then
    UIManager():LoadUINew(HUDUIName, self.TransformID)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  return UE4.UWidgetBlueprintLibrary.Handled()
end

return M
