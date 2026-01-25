require("UnLua")
local SettingUtils = require("Utils.SettingUtils")
local M = Class("BluePrints.UI.UI_PC.Setting.Setting_Switch_OptionBase_PC_C")

function M:InitSubOption(Parent, CacheName, CacheInfo, UpOption)
  rawset(self, "Parent", Parent)
  rawset(self, "CacheName", CacheName)
  rawset(self, "CacheInfo", CacheInfo)
  rawset(self, "HasBeenForbidden", false)
  rawset(self, "DefaultValue", UpOption and 2 == CacheInfo.SubOptionDefaultValue[UpOption:GetDefaultValue()] or false)
  rawset(self, "SubListOffset", 15)
  rawset(self, "NowValue", true)
  rawset(self, "OldValue", true)
  rawset(self, "UpOption", UpOption)
  rawset(self, "UpOptionValue", UpOption:GetOptionValue())
  self.Text_Option:SetText(GText(self.CacheInfo.CacheText))
  self:SetOldValue()
  self:SetHoverVisibility()
  self:PlaySwitchAnimation(self.OldValue)
  self:RefreshSubOptionState()
  self.NowValue = self.OldValue
  self.Text_Close:SetText(GText(self.CacheInfo.SwitchText[1]))
  self.Text_Open:SetText(GText(self.CacheInfo.SwitchText[2]))
end

function M:GetOptionValueByUpOption()
  return self.CacheInfo.SubOptionDefaultValue[self.UpOptionValue]
end

function M:IsCloseOption()
  return 0 == self:GetOptionValueByUpOption()
end

function M:RefreshSubOptionState()
  if 0 == self:GetOptionValueByUpOption() then
    if not self.HasBeenForbidden then
      self:PlayAnimation(self.Forbidden)
      self.Button_Area:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self.Bg_Set.Bg_Hover:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self.Bg_Set.Bg_Outline:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self.HasBeenForbidden = true
    end
  elseif self.HasBeenForbidden then
    self:PlayAnimationReverse(self.Forbidden)
    self.Button_Area:SetVisibility(UE4.ESlateVisibility.Visible)
    self.Bg_Set.Bg_Hover:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Bg_Set.Bg_Outline:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.HasBeenForbidden = false
  end
end

function M:RefreshSubOptionList(UpOptionValue)
  self.UpOptionValue = UpOptionValue
  self:RestoreDefaultOptionSet()
  self:RefreshSubOptionState()
end

function M:SetRayTracingReflectOldValue()
  if not SettingUtils.IsOpenRayTracing() then
    return
  end
  if self:IsCloseOption() then
    self.OldValue = false
  else
    self.OldValue = UE4.URuntimeCommonFunctionLibrary.GetRayTracingReflectionsEnabled()
  end
end

function M:RestoreDefaultRayTracingReflectOptionSet()
  self:SaveRayTracingReflectOptionSetting()
end

function M:SaveRayTracingReflectOptionSetting()
  if not SettingUtils.IsOpenRayTracing() then
    return
  end
  UE4.URuntimeCommonFunctionLibrary.SetRayTracingReflectionsEnabled(self.NowValue)
end

function M:SetRayTracingGlobalLightOldValue()
  if not SettingUtils.IsOpenRayTracing() then
    return
  end
  if self:IsCloseOption() then
    self.OldValue = false
  else
    self.OldValue = UE4.URuntimeCommonFunctionLibrary.GetRayTracingGIEnabled()
  end
end

function M:RestoreDefaultRayTracingGlobalLightOptionSet()
  self:SaveRayTracingGlobalLightOptionSetting()
end

function M:SaveRayTracingGlobalLightOptionSetting()
  if not SettingUtils.IsOpenRayTracing() then
    return
  end
  UE4.URuntimeCommonFunctionLibrary.SetRayTracingGIEnabled(self.NowValue)
end

function M:SetRayTracingShadowOldValue()
  if not SettingUtils.IsOpenRayTracing() then
    return
  end
  if self:IsCloseOption() then
    self.OldValue = false
  else
    self.OldValue = UE4.URuntimeCommonFunctionLibrary.GetRayTracingShadowsEnabled()
  end
end

function M:RestoreDefaultRayTracingShadowOptionSet()
  self:SaveRayTracingShadowOptionSetting()
end

function M:SaveRayTracingShadowOptionSetting()
  if not SettingUtils.IsOpenRayTracing() then
    return
  end
  UE4.URuntimeCommonFunctionLibrary.SetRayTracingShadowsEnabled(self.NowValue)
end

return M
