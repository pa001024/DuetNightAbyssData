require("UnLua")
local NumberModel = require("BluePrints.UI.WBP.Appearance.WBP_AppearanceArchive_Number_Model")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Area.OnClicked:Add(self, self.OnCellClicked)
  self.Btn_Area.OnHovered:Add(self, self.OnCellHovered)
  self.Btn_Area.OnUnhovered:Add(self, self.OnCellUnhovered)
  self.Btn_Area.OnPressed:Add(self, self.OnCellPressed)
  self.Btn_Area.OnReleased:Add(self, self.OnCellReleased)
  self.IsHovering = false
  self.IsPressing = false
  self.ShowNew = false
  self.ShowReddot = false
  if self.New then
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Reddot then
    self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:Destruct()
  ReddotManager.RemoveListener("AppearanceArchiveReward", self)
  ReddotManager.RemoveListener("AppearanceArchiveNew", self)
end

function M:Init(EntranceId, Type, Info)
  self.EntranceId = EntranceId
  self.Type = Type
  self.Info = Info
  self:RefreshInfo()
  if self.Info then
    if self.Info.EntranceName then
      self.Text_Type:SetText(GText(self.Info.EntranceName))
    end
    if self.Info.EntranceIcon then
      local Image = LoadObject(self.Info.EntranceIcon)
      self.Img_Type:SetBrushFromTexture(Image)
    end
  end
  if not ReddotManager.GetTreeNode("AppearanceArchiveReward") then
    ReddotManager.AddNode("AppearanceArchiveReward")
  end
  ReddotManager.AddListener("AppearanceArchiveReward", self, self.RefreshRewardReddot)
  if not ReddotManager.GetTreeNode("AppearanceArchiveNew") then
    ReddotManager.AddNode("AppearanceArchiveNew")
  end
  ReddotManager.AddListener("AppearanceArchiveNew", self, self.RefreshReddotNew)
  self.Btn_Area.OnClicked:Add(self, self.OnCellClicked)
end

function M:RefreshInfo()
  local CurrentNumber = NumberModel:GetCurrentNumber(self.EntranceId)
  local SumNumber = NumberModel["Get" .. self.Type .. "SumNumber"](NumberModel)
  if CurrentNumber > SumNumber then
    CurrentNumber = SumNumber
  end
  self.Num_Now:SetText(CurrentNumber)
  self.Num_Max:SetText(SumNumber)
end

function M:OnCellClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/common/special_content_01_click", nil, nil)
  if self.Type == "Skin" or self.Type == "WeaponSkin" then
    UIManager(self):LoadUINew("AppearanceArchivePageSkin", self.EntranceId, self.Type, self.Info)
  else
    UIManager(self):LoadUINew("AppearanceArchivePageItem", self.EntranceId, self.Type, self.Info)
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Click)
end

function M:OnCellHovered()
  self.IsHovering = true
  if self.IsPressing then
    return
  end
  if self:IsAnimationPlaying(self.Click) then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Hover)
end

function M:OnCellUnhovered()
  self.IsHovering = false
  if self:IsAnimationPlaying(self.Click) then
    return
  end
  if not self.IsPressing then
    self:StopAllAnimations()
    self:PlayAnimation(self.Unhover)
  end
end

function M:OnCellPressed()
  self.IsPressing = true
  if self:IsAnimationPlaying(self.Click) then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Press)
end

function M:OnCellReleased()
  self.IsPressing = false
  if self:IsAnimationPlaying(self.Click) then
    return
  end
  if not self.IsHovering then
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
  end
end

function M:RefreshReddotNew()
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AppearanceArchiveNew")
  if CacheDetail[self.EntranceId] and CacheDetail[self.EntranceId].Num and CacheDetail[self.EntranceId].Num > 0 then
    self.ShowNew = true
  else
    self.ShowNew = false
  end
  self:TryShowReddotOrNew()
end

function M:RefreshRewardReddot()
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AppearanceArchiveReward")
  if CacheDetail[self.EntranceId] then
    self.ShowReddot = true
  else
    self.ShowReddot = false
  end
  self:TryShowReddotOrNew()
end

function M:TryShowReddotOrNew()
  if self.ShowReddot then
    self.Reddot:SetVisibility(ESlateVisibility.HitTestInvisible)
    self.New:SetVisibility(ESlateVisibility.Collapsed)
  else
    self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
    if self.ShowNew then
      self.New:SetVisibility(ESlateVisibility.HitTestInvisible)
    else
      self.New:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
end

return M
