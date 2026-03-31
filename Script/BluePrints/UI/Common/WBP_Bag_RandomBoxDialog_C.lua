require("UnLua")
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function M:Destruct()
  self:RemoveInputMethodChangedListen()
  if self.WaitFocusTimer then
    self:RemoveTimer(self.WaitFocusTimer)
  end
end

function M:InitContent(Params, PopupData, Owner)
  self.Params = Params
  self.Text_Title:SetText(GText("UI_RandomBox_Title"))
  self.Text_Exchange:SetText(GText("UI_RandomBox_Num"))
  self:ShowItemList(self.Params.UseParam)
  if Params.ChooseCallbackFunction then
    self.Panel_Exchange:SetVisibility(UIConst.VisibilityOp.Visible)
    self:SetSlider()
    self.RandomBoxType = "Open"
    self:InitTab()
  else
    self.Panel_Exchange:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.RandomBoxType = "Preview"
    self:InitTab()
  end
  self:AddInputMethodChangedListen()
end

function M:ShowItemList(PackId)
  local PackDetail = DataMgr.Reward[PackId].Id
  local Types = DataMgr.Reward[PackId].Type
  local Counts = DataMgr.Reward[PackId].Count
  local Rates = DataMgr.Reward[PackId].Param
  self.List_Item:ClearListItems()
  for key, value in pairs(PackDetail) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    local Type = Types[key]
    local ResourceConfig = DataMgr[Type][value]
    Content.Id = value
    Content.Type = Type
    Content.Count = Counts[key][1]
    Content.Owner = self
    Content.Icon = ResourceConfig.Icon
    Content.Rarity = ResourceConfig.Rarity
    Content.UseEffectType = ResourceConfig.UseEffectType
    Content.IsShowDetails = true
    self.List_Item:AddItem(Content)
  end
  self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.IsEmpty = true
    return Obj
  end)
  self.List_Item:RequestFillEmptyContent()
end

function M:SetSlider()
  local MaxCount = self:GetMaxCount()
  self.Num_Limit:SetText(GText(tostring(MaxCount)))
  local ConfigData = {
    InitValue = 1,
    MinValue = 1,
    MaxValue = MaxCount,
    EnableMiniBtn = true,
    EnableMaxBtn = true,
    ClickInterval = 1,
    MinusBtnCallback = self.MinusBtnCallback,
    AddBtnCallback = self.AddBtnCallback,
    MaxBtnCallback = self.AddBtnCallback,
    SliderChangeCallback = self.SliderChangeCallback,
    SoundResPath = {
      Minus = "event:/ui/common/click_btn_minus"
    },
    OwnerPanel = self
  }
  self.Com_Slider:Init(ConfigData)
  self:ChangeCountClickCallback()
end

function M:GetMaxCount()
  local Avatar = GWorld:GetAvatar()
  local ResourceData = Avatar.Resources[self.Params.ResourceId]
  return ResourceData and ResourceData.Count or 0
end

function M:MinusBtnCallback()
  self.CurrentCount = self.Com_Slider.CurrentCount
  self:UpdateOpenCount()
  self:ChangeCountClickCallback()
end

function M:AddBtnCallback()
  self.CurrentCount = self.Com_Slider.CurrentCount
  self:UpdateOpenCount()
  self:ChangeCountClickCallback()
end

function M:SliderChangeCallback(Value)
  self.CurrentCount = Value
  self:UpdateOpenCount()
  self:ChangeCountClickCallback()
end

function M:UpdateOpenCount()
  self.Num_Exchange:SetText(GText(tostring(self.CurrentCount)))
end

function M:ChangeCountClickCallback()
  local ConsumeInfo = {
    ResourceId = self.Params.ResourceId,
    ConsumeCount = self.CurrentCount or 1
  }
  if type(self.Params.ChooseCallbackFunction) == "function" then
    self.Params.ChooseCallbackFunction(self.Params.FunctionCallbackObj, ConsumeInfo)
  end
end

function M:InitTab(Type)
  if self.RandomBoxType == "Preview" then
    self.GamePadKeyBack = self:ShowGamepadShortcutBtn({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK")
    })
    self.GamePadKeyA = self:ShowGamepadShortcutBtn({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("UI_Controller_CheckDetails")
    })
    self.GamePadKeyLS = self:ShowGamepadShortcutBtn({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      },
      Desc = GText("UI_Controller_CheckItems")
    })
  elseif self.RandomBoxType == "Open" then
    self.GamePadKeyBack = self:ShowGamepadShortcutBtn({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK")
    })
    self.GamePadKeyA = self:ShowGamepadShortcutBtn({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("UI_Controller_CheckDetails")
    })
    self.GamePadKeyLS = self:ShowGamepadShortcutBtn({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      },
      Desc = GText("UI_Controller_CheckItems")
    })
  end
  self:SetGamepadBtnState(UIUtils.IsGamepadInput() and UE4.ECommonInputType.Gamepad or nil)
end

function M:SetGamepadBtnState(CurInputDevice)
  if self.RandomBoxType == "Preview" then
    if CurInputDevice == UE4.ECommonInputType.Gamepad then
      self:ShowGamepadShortcut(self.GamePadKeyLS)
      self:HideGamepadShortcut(self.GamePadKeyA)
      self:HideGamepadShortcut(self.GamePadKeyBack)
      if self.Owner.GamepadCloseBtnIndex then
        self:ShowGamepadShortcut(self.Owner.GamepadCloseBtnIndex)
      end
      self:SetRandomBoxFocus()
    else
      self:HideGamepadShortcut(self.GamePadKeyLS)
      self:HideGamepadShortcut(self.GamePadKeyA)
      self:HideGamepadShortcut(self.GamePadKeyBack)
      if self.Owner.GamepadCloseBtnIndex then
        self:HideGamepadShortcut(self.Owner.GamepadCloseBtnIndex)
      end
    end
  elseif self.RandomBoxType == "Open" then
    if CurInputDevice == UE4.ECommonInputType.Gamepad then
      self:ShowGamepadShortcut(self.GamePadKeyLS)
      self:HideGamepadShortcut(self.GamePadKeyA)
      self:HideGamepadShortcut(self.GamePadKeyBack)
      if self.Owner.GamepadCloseBtnIndex then
        self:ShowGamepadShortcut(self.Owner.GamepadCloseBtnIndex)
      end
      self:SetRandomBoxFocus()
      if self.RandomBoxType == "Open" then
        self.Com_Slider:UpdateUIStyleInPlatform(true, UIUtils.UtilsGetCurrentGamepadName())
        self.Owner.ButtonBar:SetGamepadBtnKeyVisibility(true)
        self:SetSliderState(true)
      end
    else
      self:HideGamepadShortcut(self.GamePadKeyLS)
      self:HideGamepadShortcut(self.GamePadKeyA)
      self:HideGamepadShortcut(self.GamePadKeyBack)
      if self.Owner.GamepadCloseBtnIndex then
        self:HideGamepadShortcut(self.Owner.GamepadCloseBtnIndex)
      end
    end
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  self:SetGamepadBtnState(CurInputDevice)
end

function M:SetRandomBoxFocus()
  if self.WaitFocusTimer then
    self:RemoveTimer(self.WaitFocusTimer)
  end
  self.WaitFocusTimer = self:AddTimer(0.01, function()
    self:SetFocus()
  end, false, 0, "RandomBox_WaitFocusTimer")
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if InKeyName == UIConst.GamePadKey.LeftThumb then
    local Item = self.List_Item:GetItemAt(0)
    self.List_Item:NavigateToIndex(0)
    Item.SelfWidget:SetFocus()
    self:HideGamepadShortcut(self.GamePadKeyLS)
    self:ShowGamepadShortcut(self.GamePadKeyA)
    self:ShowGamepadShortcut(self.GamePadKeyBack)
    if self.Owner.GamepadCloseBtnIndex then
      self:HideGamepadShortcut(self.Owner.GamepadCloseBtnIndex)
    end
    if self.RandomBoxType == "Open" then
      self.Com_Slider:UpdateUIStyleInPlatform(false)
      self.Owner.ButtonBar:SetGamepadBtnKeyVisibility(false)
      self:SetSliderState(false)
    end
    return UIUtils.Handled
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
    if self.List_Item:HasFocusedDescendants() then
      self:SetGamepadBtnState(UIUtils.IsGamepadInput() and UE4.ECommonInputType.Gamepad or nil)
      self:SetRandomBoxFocus()
      if self.RandomBoxType == "Open" then
        self.Com_Slider:UpdateUIStyleInPlatform(true, UIUtils.UtilsGetCurrentGamepadName())
        self.Owner.ButtonBar:SetGamepadBtnKeyVisibility(true)
        self:SetSliderState(true)
      end
      return UIUtils.Handled
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
  elseif self.RandomBoxType == "Open" and not self.List_Item:HasFocusedDescendants() then
    IsEventHandled = self.Com_Slider:Handle_KeyDownEventOnGamePad(InKeyName)
  end
  if IsEventHandled then
    return UIUtils.Handled
  else
    return UIUtils.UnHandled
  end
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if self.RandomBoxType == "Open" and not self.List_Item:HasFocusedDescendants() then
    IsEventHandled = self.Com_Slider:Handle_KeyUpEventOnGamePad(InKeyName)
  end
  if IsEventHandled then
    return UIUtils.Handled
  else
    return UIUtils.UnHandled
  end
end

function M:SetSliderState(enabled)
  self.Com_Slider:SetEnabled(enabled)
  self.Com_Slider:ForbidMinOperation(not enabled)
  self.Com_Slider:ForbidAddOperation(not enabled)
end

return M
