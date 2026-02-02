require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.IsPC = CommonUtils.GetRuntimePlatform(self) == "PC"
  self.Text_Level:SetText(GText("ReputationLevel_Title"))
  self.Text_Limit:SetText(GText("ReputationExp_WeekLimit"))
  self.Button_Area.OnClicked:Add(self, self.OnClicked)
  self.Button_Area.OnPressed:Add(self, self.OnPressed)
  self.Button_Area.OnReleased:Add(self, self.OnReleased)
  self.Button_Area.OnHovered:Add(self, self.OnHovered)
  self.Button_Area.OnUnhovered:Add(self, self.OnUnhovered)
end

function M:Init(CurRegionTabId, AvatarReputation)
  self.CurRegionData = DataMgr.RegionReputation[CurRegionTabId]
  local Title = GText("RegionReputation_Title")
  local RegionTitle = GText(self.CurRegionData.RegionName)
  self.Text_RegioName:SetText(RegionTitle .. "·" .. Title)
  self:UpdateRegionUIIcon()
  local CurWeekScore = AvatarReputation.ReputationScore or 0
  local WeekLimit = self.CurRegionData.WeekLimit
  if CurWeekScore >= WeekLimit then
    self.WidgetSwitcher_1:SetActiveWidgetIndex(1)
    self.Text_Limit_1:SetText(GText("ReputationExp_AchievedWeekLimit"))
  else
    self.WidgetSwitcher_1:SetActiveWidgetIndex(0)
    self.Num_Now:SetText(CurWeekScore)
    self.Num_Total:SetText(WeekLimit)
  end
  local RegionLevelCfg = DataMgr.ReputationLevel[CurRegionTabId] and DataMgr.ReputationLevel[CurRegionTabId][AvatarReputation.ReputationLevel + 1]
  local CurLevel = AvatarReputation.ReputationLevel or 0
  if RegionLevelCfg then
    local CurLevelExp = AvatarReputation.ReputationExp or 0
    local MaxLevelExp = RegionLevelCfg.ReputationLevelMaxExp
    self.WidgetSwitcher_0:SetActiveWidgetIndex(0)
    self.Num_Total_1:SetText(MaxLevelExp)
    self.Num_Now_1:SetText(AvatarReputation.ReputationExp or 0)
    self.Num_Fame:SetText(CurLevel)
    self.ProgressBar_Fame:SetPercent(CurLevelExp / MaxLevelExp)
  else
    self.Num_Fame:SetText(CurLevel)
    self.WidgetSwitcher_0:SetActiveWidgetIndex(1)
    self.TextBlock_206:SetText(GText("Reputation_MaxLevel"))
    self.ProgressBar_Fame:SetPercent(1)
  end
  self:PlayAnimation(self.Normal)
end

function M:BindEventOnClicked(Obj, Func, ...)
  if not Obj or not Func then
    return
  end
  self.Obj = Obj
  self.Func = Func
  self.Params = {
    ...
  }
end

function M:OnClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
  self:StopAllAnimations()
  self:PlayAnimation(self.Click)
end

function M:OnPressed()
  self:StopAllAnimations()
  self:PlayAnimation(self.Press)
end

function M:OnReleased()
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
end

function M:OnHovered()
  if not self.IsPC then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Hover)
end

function M:OnUnhovered()
  if not self.IsPC then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.UnHover)
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Click and self.Obj and self.Func then
    self.Func(self.Obj, table.unpack(self.Params))
  end
end

function M:UpdateRegionUIIcon()
  local RegionUIIcon = self.CurRegionData and self.CurRegionData.RegionUIIcon
  if self.RegionUIIcon and self.RegionUIIcon == RegionUIIcon then
    return
  end
  self.RegionUIIcon = RegionUIIcon
  local Icon = LoadObject(self.RegionUIIcon)
  if not Icon then
    return
  end
  local DynamicMaterial = self.Image_Region:GetDynamicMaterial()
  if not IsValid(DynamicMaterial) then
    return
  end
  DynamicMaterial:SetTextureParameterValue("IconTex", Icon)
end

return M
