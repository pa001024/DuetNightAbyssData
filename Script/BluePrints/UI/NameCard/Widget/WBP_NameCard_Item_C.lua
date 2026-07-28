require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  self.ItemData = nil
  self.ParentWidget = nil
  self.ListenedReddot = false
  self.CurrentReddotName = nil
  self.IsSelected = false
  self.IsClicked = false
  self.IsHovered = false
  self.IsForbidden = false
  if self.Btn_Click then
    if self.Btn_Click.OnClicked then
      self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
    end
    if self.Btn_Click.OnPressed then
      self.Btn_Click.OnPressed:Add(self, self.OnBtnPressed)
    end
    if self.Btn_Click.OnReleased then
      self.Btn_Click.OnReleased:Add(self, self.OnBtnReleased)
    end
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
      if self.Btn_Click.OnHovered then
        self.Btn_Click.OnHovered:Add(self, self.OnBtnHovered)
      end
      if self.Btn_Click.OnUnhovered then
        self.Btn_Click.OnUnhovered:Add(self, self.OnBtnUnhovered)
      end
    end
  end
end

function M:OnListItemObjectSet(Content)
  self:RemoveReddotListener()
  self:SetNewVisible(false)
  self:SetSelected(false)
  self.ItemData = nil
  self.ParentWidget = nil
  self.IsClicked = false
  self.IsHovered = false
  self.IsForbidden = false
  if not Content then
    self.IsForbidden = true
    self:PlayAnimation(self.Forbidden)
    return
  end
  self.ItemData = Content.ItemData
  self.ParentWidget = Content.ParentWidget
  if not self.ItemData then
    self.IsForbidden = true
    self:PlayAnimation(self.Forbidden)
    return
  end
  self.IsClicked = self.ItemData.BgId == self.ParentWidget.SelectedBgId
  local isCurrentEffective = self.ItemData.BgId == self.ParentWidget.CurrentEffectiveBgId
  self.IsSelected = isCurrentEffective
  self.WS_Item:SetActiveWidgetIndex(0)
  self.IsForbidden = false
  self.IsHovered = false
  if self.IsClicked then
    self:PlayAnimation(self.Click)
  else
    self:PlayAnimation(self.Normal)
  end
  if self.ItemData.Icon then
    local IconImage = LoadObject(self.ItemData.Icon)
    if IconImage and self.Image_ItemIcon then
      self.Image_ItemIcon:SetBrushFromTexture(IconImage)
    end
  else
    local DefaultIcon = LoadObject("Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_Original.T_Menu_Original'")
    if DefaultIcon and self.Image_ItemIcon then
      self.Image_ItemIcon:SetBrushFromTexture(DefaultIcon)
    end
  end
  if self.ItemData.IsOwned then
    self.Group_Lock:SetRenderOpacity(0.0)
  else
    self.Group_Lock:SetRenderOpacity(1.0)
  end
  self:SetSelected(self.IsSelected)
  if -1 ~= self.ItemData.BgId and self.ParentWidget then
    local ReddotName = self.ParentWidget:GetReddotName()
    if ReddotName and "" ~= ReddotName then
      self:AddReddotListener(ReddotName, self.OnBgItemReddotChange)
    end
  else
    self:SetNewVisible(false)
  end
end

function M:OnAddedToFocusPath(InFocusEvent)
  if not (self.ItemData and self.ParentWidget) or not UIUtils.IsGamepadInput() then
    return
  end
  self:OnBtnClicked()
end

function M:SetSelected(Selected)
  self.IsSelected = Selected
  if Selected then
    self.Group_Select:SetRenderOpacity(1.0)
  else
    self.Group_Select:SetRenderOpacity(0.0)
  end
end

function M:SetNewVisible(Show)
  if self.New then
    if Show then
      self.New:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
      self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:OnBtnClicked()
  if not (self.ItemData and self.ParentWidget) or self.IsClicked == true then
    return
  end
  self.IsClicked = true
  if self.ParentWidget.OnListItemClicked then
    self.ParentWidget:OnListItemClicked(self.ItemData.BgId)
  end
  self:PlayAnimation(self.Click)
  AudioManager(self):PlayUISound(self, "event:/ui/common/gacha_pool_click", nil, nil)
end

function M:OnBtnHovered()
  if self.IsClicked or UIUtils.IsGamepadInput() or UIUtils.IsMobileInput() then
    return
  end
  self.IsHovered = true
  self:StopAnimation(self.UnHover)
  self:PlayAnimation(self.Hover)
end

function M:OnBtnUnhovered()
  if self.IsClicked or UIUtils.IsGamepadInput() or UIUtils.IsMobileInput() then
    return
  end
  self.IsHovered = false
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.UnHover)
end

function M:OnBtnPressed()
  if self.IsClicked or UIUtils.IsMobileInput() then
    return
  end
  self:PlayAnimation(self.Press)
end

function M:OnBtnReleased()
  if self.IsForbidden then
    return
  end
end

function M:AddReddotListener(ReddotNodeName, func)
  if self.ListenedReddot then
    local RootNode = ReddotManager.GetTreeNode(ReddotNodeName)
    if RootNode then
      func(self, RootNode.Count)
    end
    return
  end
  self.CurrentReddotName = ReddotNodeName
  self:RemoveReddotListener(ReddotNodeName)
  ReddotManager.AddListener(ReddotNodeName, self, func)
  self.ListenedReddot = true
end

function M:RemoveReddotListener(ReddotNodeName)
  if not self.ListenedReddot then
    return
  end
  local nameToRemove = ReddotNodeName or self.CurrentReddotName
  if nameToRemove and "" ~= nameToRemove then
    ReddotManager.RemoveListener(nameToRemove, self)
    self.ListenedReddot = false
    self.CurrentReddotName = nil
  end
end

function M:OnBgItemReddotChange(Count)
  if not (self.ItemData and self.New) or not self.ParentWidget then
    return
  end
  local ReddotName = self.ParentWidget:GetReddotName()
  if not ReddotName or "" == ReddotName then
    return
  end
  local CacheKey = self.ItemData.BgId
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotName)
  local shouldShow = CacheDetail and CacheDetail[CacheKey] and Count > 0
  self:SetNewVisible(shouldShow)
end

function M:ResetClickState()
  if not self.IsClicked then
    return
  end
  self.IsClicked = false
  if self.Click then
    self:StopAnimation(self.Click)
  end
  if self.Normal then
    self:PlayAnimation(self.Normal)
  end
end

function M:BP_OnEntryReleased()
  self:RemoveReddotListener()
  self:SetNewVisible(false)
  self:SetSelected(false)
  self.ItemData = nil
  self.ParentWidget = nil
  self.IsClicked = false
  self.IsHovered = false
  self.IsForbidden = false
end

function M:Destruct()
  self:RemoveReddotListener()
  if self.Btn_Click and self.Btn_Click.OnClicked then
    self.Btn_Click.OnClicked:Remove(self, self.OnBtnClicked)
  end
  if self.Btn_Click and self.Btn_Click.OnPressed then
    self.Btn_Click.OnPressed:Remove(self, self.OnBtnPressed)
  end
  if self.Btn_Click and self.Btn_Click.OnReleased then
    self.Btn_Click.OnReleased:Remove(self, self.OnBtnReleased)
  end
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
    if self.Btn_Click and self.Btn_Click.OnHovered then
      self.Btn_Click.OnHovered:Remove(self, self.OnBtnHovered)
    end
    if self.Btn_Click and self.Btn_Click.OnUnhovered then
      self.Btn_Click.OnUnhovered:Remove(self, self.OnBtnUnhovered)
    end
  end
end

return M
