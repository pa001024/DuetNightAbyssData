require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Button_Area.OnClicked:Add(self, self.OnClicked)
  self.Button_Area.OnHovered:Add(self, self.OnHovered)
  self.Button_Area.OnUnhovered:Add(self, self.OnUnhovered)
  self.Button_Area.OnPressed:Add(self, self.OnPressed)
  self.Button_Area.OnReleased:Add(self, self.OnReleased)
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Owner = Content.Owner
  self.Parent = Content.Parent
  self.ItemId = Content.ItemId
  self.ItemIdx = Content.ItemIdx
  self:InitItemInfo(self.ItemId, self.Owner)
end

function M:InitItemInfo(ItemId, Owner)
  local ItemContent = {}
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local IsEnough = self.Content and self.Content.IsEnough
  if IsEnough then
    self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
  else
    self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
  end
  if -1 ~= ItemId then
    self.WidgetSwitcher_Item:SetActiveWidgetIndex(0)
    local ItemData = DataMgr.Resource[ItemId]
    ItemContent.Id = ItemId
    ItemContent.Icon = ItemUtils.GetItemIconPath(ItemId, "Resource")
    ItemContent.ParentWidget = self
    ItemContent.ItemType = "Resource"
    ItemContent.Rarity = ItemData.Rarity or 1
    ItemContent.IsShowDetails = true
    ItemContent.HandleMouseDown = true
    ItemContent.bShadow = not IsEnough
    ItemContent.ItemDetailKeyDownEvent = {
      Obj = self,
      Callback = self.OnItemDetailKeyDown,
      Params = ItemContent
    }
  else
    self.WidgetSwitcher_Item:SetActiveWidgetIndex(1)
  end
  self.bNotInteractive = false
  if -1 ~= self.ItemId and not IsEnough then
    self.bNotInteractive = true
  end
  self.Item_Ticket:Init(ItemContent)
  self.Item_Ticket:BindEvents(self, {
    OnMenuOpenChanged = self.OnStuffMenuOpenChanged
  })
  self.OnClickCallback = self.Content and self.Content.OnClicked
  local ShouldSelected = self.Parent and self.Parent.ItemIdx == self.ItemIdx and not self.bNotInteractive
  if ShouldSelected then
    self:StopAllAnimations()
    self.IsSelected = true
    self:PlayAnimation(self.Click)
  else
    self:OnCellUnSelect()
  end
end

function M:OnClicked()
  self:RealClicked()
end

function M:RealClicked(bInit)
  if not bInit and self:IsAnimationPlaying(self.Click) then
    if self.OnClickCallback then
      self.OnClickCallback(self, false, bInit)
    end
    return
  end
  if self.bNotInteractive then
    if self.OnClickCallback then
      self.OnClickCallback(self, false, bInit)
    end
    return
  end
  self:StopAllAnimations()
  self.IsSelected = true
  self:PlayAnimation(self.Click)
  if self.OnClickCallback then
    self.OnClickCallback(self, true, bInit)
  end
end

function M:OnHovered()
  if self:IsAnimationPlaying(self.Click) or self.IsSelected or self.bNotInteractive then
    return
  end
  if not self.Button_Area:HasMouseCapture() then
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
  end
end

function M:OnUnhovered()
  if self:IsAnimationPlaying(self.Click) or self.IsSelected or self.bNotInteractive then
    return
  end
  if not self.Button_Area:HasMouseCapture() then
    self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
  end
end

function M:OnPressed()
  if self:IsAnimationPlaying(self.Click) or self.IsSelected or self.bNotInteractive then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Press)
end

function M:OnReleased()
  if self:IsAnimationPlaying(self.Click) or self.IsSelected or self.bNotInteractive then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
end

function M:OnCellUnSelect()
  self:StopAllAnimations()
  if self.bNotInteractive then
    self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
  else
    self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
  end
  self:PlayAnimation(self.Normal)
  self.IsSelected = false
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.UnHover then
    self:PlayAnimation(self.Normal)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  if self.Parent and self.Parent.ScrollTicketIntoView then
    self.Parent:ScrollTicketIntoView(self.ItemIdx, self)
  end
  self:RealClicked()
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and InKeyName == Const.GamepadLeftThumbstick then
    if -1 ~= self.ItemId then
      self.Item_Ticket:OpenItemMenu()
    end
    return UWidgetBlueprintLibrary.Handled()
  end
  return UWidgetBlueprintLibrary.UnHandled()
end

function M:OnStuffMenuOpenChanged(bIsOpen)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  self.IsTipsOpen = bIsOpen
  if self.Parent and self.Parent.OnItemMenuOpenChanged then
    self.Parent:OnItemMenuOpenChanged(bIsOpen)
  end
end

function M:OnItemDetailKeyDown(MyGeometry, InKeyEvent, Content)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self), true
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if not IsUseKeyAndMouse then
    self.Parent:SetGamepadBtnKeyVisibility(not self.IsTipsOpen)
  end
  self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

return M
