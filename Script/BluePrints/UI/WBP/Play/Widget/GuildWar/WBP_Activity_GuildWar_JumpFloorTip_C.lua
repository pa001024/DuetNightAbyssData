require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self.Super.Construct(self)
  self.List_Reward.OnCreateEmptyContent:Bind(self, self.CreateAndAddEmptyItem)
  self.Btn_Click.OnClicked:Add(self, function()
    self:RequestClose()
  end)
  self.Btn_Get:BindEventOnClicked(self, function()
    self:RequestClose()
  end)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self:AddInputMethodChangedListen()
  self:RefreshControllerRewardVisible()
end

function M:Init(InParams)
  InParams = InParams or {}
  self.FloorNum = InParams.FloorNum or 0
  self.RewardList = InParams.RewardList or {}
  self:RefreshTitleAndTip()
  self:RefreshRewardList(self.RewardList)
  self.List_Reward:NavigateToIndex(0)
  self:PlayAnimation(self.In)
end

function M:RefreshTitleAndTip()
  if self.Text_Title then
    self.Text_Title:SetText(GText("UI_COMMONPOP_TITLE_100010"))
  end
  if self.Text_Tip then
    local tip = GText("Raid_Season_Floor_JumpReward") or ""
    tip = tip:gsub("(</?[^><]*>)", "")
    self.Text_Tip:SetText(string.format(tip, tostring(self.FloorNum)))
  end
  if self.Btn_Get and self.Btn_Get.SetText then
    self.Btn_Get:SetText(GText("UI_Achievement_GetReward"))
  end
end

function M:RefreshRewardList(RewardList)
  self.List_Reward:ClearListItems()
  for _, ItemInfo in ipairs(RewardList or {}) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = ItemInfo.Id or 0
    Content.Icon = not ItemInfo.Icon and ItemUtils and ItemUtils.GetItemIconPath(ItemInfo.Id, ItemInfo.Type)
    Content.ParentWidget = self
    Content.ItemType = ItemInfo.Type
    Content.Count = ItemInfo.ItemCount
    Content.Rarity = ItemInfo.Rarity or ItemUtils and ItemUtils.GetItemRarity(ItemInfo.Id, ItemInfo.Type) or 1
    Content.IsShowDetails = true
    Content.OnMenuOpenChangedEvents = {
      Obj = self,
      Callback = self.OnStuffMenuOpenChanged
    }
    if ItemInfo.Quantity then
      Content.Count = ItemInfo.Quantity[1]
      Content.MaxCount = ItemInfo.Quantity[2] or nil
    end
    self.List_Reward:AddItem(Content)
  end
  if self.List_Reward.RequestFillEmptyContent then
    self.List_Reward:RequestFillEmptyContent()
  end
  if self:IsExistTimer(self.NextFrameBindRewardEntry) then
    self:RemoveTimer(self.NextFrameBindRewardEntry)
  end
  self.NextFrameBindRewardEntry = self:AddTimer(0.01, function()
    local len = self.List_Reward:GetNumItems()
    for idx = 1, len do
      local entryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Reward, idx - 1)
      if entryWidget then
        entryWidget:BindEvents(self, {
          OnMenuOpenChanged = self.OnStuffMenuOpenChanged
        })
      end
    end
  end, false, 0, "GuildWar_JumpFloorTip_RewardEntry")
end

function M:CreateAndAddEmptyItem()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.Id = 0
  return Content
end

function M:HasRewardListFocus()
  return self.List_Reward:HasFocusedDescendants() or self.List_Reward:HasAnyUserFocus()
end

function M:RefreshControllerRewardVisible()
  if not self.Controller_Reward then
    return
  end
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad or self.IsShowingTip then
    self.Controller_Reward:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  self.Controller_Reward:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  local TexturePath
  if self:HasRewardListFocus() then
    TexturePath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Key/XBOX/T_Key_A.T_Key_A'"
  else
    TexturePath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Key/XBOX/T_Key_L.T_Key_L'"
  end
  local Obj = LoadObject(TexturePath)
  if Obj and self.Controller_Reward.Img then
    self.Controller_Reward.Img:SetBrushResourceObject(Obj)
    local Size = FVector2D(Obj:Blueprint_GetSizeX(), Obj:Blueprint_GetSizeY())
    self.Controller_Reward.Img:SetBrushSize(Size)
  end
end

function M:OnStuffMenuOpenChanged(bIsOpen)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  self.IsShowingTip = bIsOpen
  self:RefreshControllerRewardVisible()
  if not bIsOpen then
    self.List_Reward:SetFocus()
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  self:RefreshControllerRewardVisible()
end

function M:RequestClose()
  if self._bClosing then
    return
  end
  self._bClosing = true
  if self.Out then
    self:PlayAnimation(self.Out)
  else
    self:OnOutFinished()
  end
end

function M:OnOutFinished()
  if self.CloseCallback then
    local cb = self.CloseCallback
    self.CloseCallback = nil
    cb()
  end
  if self.ParentWidget and IsValid(self.ParentWidget) then
    if type(self.ParentWidget.SetFocus_Lua) == "function" then
      self.ParentWidget:SetFocus_Lua()
    else
      self.ParentWidget:SetFocus()
    end
  end
  self.Super.Close(self)
end

function M:OnAnimationFinished(InAnimation)
  if self.Out and InAnimation == self.Out then
    self:OnOutFinished()
  end
  if self.In and InAnimation == self.In and UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self.Btn_Get.Button_Area:SetFocus()
    self:RefreshControllerRewardVisible()
  end
end

function M:OnReturnKeyDown()
  self:RequestClose()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Escape" == InKeyName or "Android_Back" == InKeyName then
    self:RequestClose()
    return UWidgetBlueprintLibrary.Handled()
  end
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadDown(InKeyName)
  end
  if IsEventHandled then
    return UWidgetBlueprintLibrary.Handled()
  else
    return UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnGamePadDown(InKeyName)
  if InKeyName == Const.GamepadLeftThumbstick then
    if not self:HasRewardListFocus() then
      self.List_Reward:SetFocus()
      self:RefreshControllerRewardVisible()
    end
    return true
  elseif "Gamepad_FaceButton_Right" == InKeyName then
    if self:HasRewardListFocus() then
      self.Btn_Get.Button_Area:SetFocus()
      self:RefreshControllerRewardVisible()
    else
      self:RequestClose()
    end
    return true
  elseif "Gamepad_FaceButton_Down" == InKeyName then
    if self:HasRewardListFocus() then
      return true
    end
    self:RequestClose()
    return true
  end
  return false
end

return M
