require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self.Btn_Close.OnClicked:Add(self, self.Close)
  AudioManager(self):PlayUISound(self, "event:/ui/common/title_setting_panel_expand", "CheckGuildPagekToEnd", nil)
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
  local GuildId = (...)
  self.GuildId = GuildId
  GuildController:RegisterEvent(self, function(self, EventId, ...)
    local Info = (...)
    if EventId == GuildCommon.EventID.OnGetGuildInfo and self.GuildId == Info.GuildId then
      self:BlockAllUIInput(false)
      self:SetData(...)
    end
  end)
  GuildController:SendGetGuildInfo(GuildId)
  self:PlayAnimation(self.In)
end

function M:SetData(Info)
  self.GuildInfo:SetData(Info, true, "CheckGuildPage")
  self.GuildInfo:OnGetGuildFullInfo(Info)
  self.GuildInfo.ParentWidget = self
  self:AddTimer(0.03, function()
    self:SetFocus()
  end)
  self:SetFocus()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsDo = false
  if UIUtils.IsGamepadInput() then
  elseif "Escape" == InKeyName then
    self:Close()
  end
  if IsDo then
    return UIUtils.Handled
  else
    return UIUtils.Unhandled
  end
end

function M:Close()
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  self:BindToAnimationFinished(self.Out, {
    self,
    function()
      self:BlockAllUIInput(false)
      M.Super.Close(self)
    end
  })
  self:PlayAnimation(self.Out)
  AudioManager(self):SetEventSoundParam(self, "CheckGuildPagekToEnd", {ToEnd = 1})
  AudioManager(self):StopSound(self, "CheckGuildPagekToEnd")
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  IsHandled = self.GuildInfo:OnContentKeyDown(MyGeometry, InKeyEvent)
  if not IsHandled and InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:Close()
    IsHandled = true
  elseif "Escape" == InKeyName then
    self:Close()
    IsHandled = true
  end
  if IsHandled then
    return UIUtils.Handled
  else
    return UIUtils.UnHandled
  end
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  IsHandled = self.GuildInfo:OnContentKeyUp(MyGeometry, InKeyEvent)
  if IsHandled then
    return UIUtils.Handled
  else
    return UIUtils.UnHandled
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  self:SetFocus()
  self:AddTimer(0.03, function()
    self:SetFocus()
  end)
  self.GuildInfo:RefreshDeviceUI()
end

return M
