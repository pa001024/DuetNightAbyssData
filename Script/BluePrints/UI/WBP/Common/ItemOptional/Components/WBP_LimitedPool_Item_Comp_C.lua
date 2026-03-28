require("UnLua")
local Component = {}

function Component:InitSpecialView(ItemData, ...)
  self.ItemType = ItemData.StuffType
  self.IsLimitedPrizePool = true
  self.ChooseDataInfo = ItemData
  self.ChooseDataInfo.ChooseWidget = self
  self.IsForbidChoose = self:IsForbidLimitPrizeChoose()
  if ItemData.HaveCountNumber > 0 then
    self.Panel_Got:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WidgetSwitcher_Info:SetActiveWidgetIndex(3)
    self.Text_Got:SetText(GText("UI_LimitedPrizePool_AlreadyGetPrize"))
    self.IsGotLimitedPrize = true
  else
    self.Panel_Got:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WidgetSwitcher_Info:SetActiveWidgetIndex(1)
    self.Text_NotHold:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.IsGotLimitedPrize = false
  end
  self.WidgetSwitcher_Level:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.WB_Star:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function Component:IsForbidLimitPrizeChoose()
  local IsForbiddenChoose = false
  local ItemData = self.ChooseDataInfo
  if ItemData and ItemData.HaveCountNumber and ItemData.HaveCountNumber > 0 then
    IsForbiddenChoose = self.ParentWidget and self.ParentWidget:IsForbiddenChoose()
  end
  return IsForbiddenChoose
end

function Component:OnBtnCheckClicked()
  local CallbackWidget
  local ParentWidget = self.ParentWidget
  if ParentWidget then
    CallbackWidget = ParentWidget.ParentWidget
    ParentWidget:StoreChooseInfo()
  end
  if self.ItemType == CommonConst.DataType.Skin then
    if self.ParentWidget then
      self.ParentWidget:CloseDialog()
    end
    UIManager(self):LoadUINew("ArmorySkin", {
      Type = "Char",
      SkinId = self.Content.StuffId,
      OnCloseCallback = function()
        if CallbackWidget then
          CallbackWidget:RestoreSelectWidget()
        end
      end
    })
  elseif self.ItemType == CommonConst.DataType.CharAccessory then
    if self.ParentWidget then
      self.ParentWidget:CloseDialog()
    end
    UIManager(self):LoadUINew("ArmorySkin", {
      Type = "Char",
      AccessoryId = self.Content.StuffId,
      OnCloseCallback = function()
        if CallbackWidget then
          CallbackWidget:RestoreSelectWidget()
        end
      end
    })
  elseif self.ItemType == CommonConst.DataType.WeaponSkin then
    if self.ParentWidget then
      self.ParentWidget:CloseDialog()
    end
    UIManager(self):LoadUINew("ArmorySkin", {
      Type = "Weapon",
      SkinId = self.Content.StuffId,
      OnCloseCallback = function()
        if CallbackWidget then
          CallbackWidget:RestoreSelectWidget()
        end
      end
    })
  elseif self.ItemType == CommonConst.DataType.WeaponAccessory then
    if self.ParentWidget then
      self.ParentWidget:CloseDialog()
    end
    UIManager(self):LoadUINew("ArmorySkin", {
      Type = "Weapon",
      AccessoryId = self.Content.StuffId,
      OnCloseCallback = function()
        if CallbackWidget then
          CallbackWidget:RestoreSelectWidget()
        end
      end
    })
  elseif not self.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen() then
    local Content = {
      ItemType = self.Content.StuffType,
      ItemId = self.Content.StuffId,
      Uuid = self.Content.Uuid,
      MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
      UIName = self.Content.UIName
    }
    self.Item.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, Content)
  end
end

function Component:OnBtnChooseClicked()
  if UIUtils.IsGamepadInput() and self.IsSelected then
    return true
  end
  local IsGamepad = UIUtils.IsGamepadInput()
  local IsForbiddenChoose = self.IsForbidChoose
  if IsForbiddenChoose then
    if not IsGamepad then
      local UIManager = GWorld.GameInstance:GetGameUIManager()
      UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_LimitedPrizePool_AlreadyGet"))
    else
      local bNewSelectState = not self.IsSelected
      local CallbackData
      if bNewSelectState then
        CallbackData = self.ChooseDataInfo
        CallbackData.IsForbidLimitPrize = true
      end
      if type(self.ChooseCallback) == "function" then
        self.ChooseCallback(self.ParentWidget, bNewSelectState, CallbackData)
      end
    end
  else
    local bNewSelectState = not self.IsSelected
    self:SetSelected(bNewSelectState)
    local CallbackData
    if bNewSelectState then
      CallbackData = self.ChooseDataInfo
    end
    if type(self.ChooseCallback) == "function" then
      self.ChooseCallback(self.ParentWidget, bNewSelectState, CallbackData)
    end
  end
  if self.ChooseDataInfo then
    AudioManager(self):PlayItemSound(self, self.ChooseDataInfo.StuffId, "Click", self.ChooseDataInfo.StuffType)
  end
  return true
end

function Component:Event_OnMenuOpenChanged(IsOpen)
  if UIUtils.IsGamepadInput() then
    if IsOpen then
      self:HideAllGamepadShortcut()
      self.Owner:GetButtonBar():SetGamepadBtnKeyVisibility(false)
    else
      self:ShowAllGamepadShortcut()
      self.Owner:GetButtonBar():SetGamepadBtnKeyVisibility(true)
    end
  end
end

return Component
