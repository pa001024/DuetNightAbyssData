require("UnLua")
local FSM = require("Blueprints.UI.FocusStateMachine")
local FocusStates = {PhotoList = "PhotoList", RewardList = "RewardList"}
local M = Class({
  "BluePrints.UI.WBP.Activity.PC.CameraGame.WBP_Activity_CameraGame_Base_C"
})

function M:Initialize(Initializer)
  rawset(self, "FSM", FSM:New(self, {
    StateNames = FocusStates,
    OnStateChanged = self.OnFocusChanged,
    CheckFunction = self.IsFocusStateValid
  }))
  rawset(self, "ESCKeyInfoList", {
    KeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetKeyText("Escape"),
        ClickCallback = self.OnBackKeyDown,
        Owner = self
      }
    },
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = "B",
        ClickCallback = self.OnBackKeyDown,
        Owner = self
      }
    },
    Desc = GText("UI_BACK")
  })
  rawset(self, "TabConfigData", {
    TitleName = GText("姣姣摄影展（未配）"),
    DynamicNode = {
      "Back",
      "ResourceBar",
      "BottomKey"
    },
    StyleName = "TextImage",
    OwnerPanel = self,
    BackCallback = self.CloseSelf,
    BottomKeyInfo = {
      self.ESCKeyInfoList
    }
  })
end

function M:Construct()
  self.Super.Construct(self)
  self.Key_Go:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    }
  })
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if IsValid(self.GameInputModeSubsystem) then
    self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
    rawset(self, "IsGamepadInput", self.CurInputDeviceType == ECommonInputType.Gamepad)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:Destruct()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
  self.Super:Destruct(self)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  rawset(self, "CurInputDeviceType", CurInputDevice)
  rawset(self, "IsGamepadInput", self.CurInputDeviceType == ECommonInputType.Gamepad)
  if self.IsGamepadInput and self.IsInFocusPath and not self:IsFocusStateWidgetHasAnyFocus(self.FSM:Peak()) then
    self.FSM:Clear()
    local Widget = self:GetDesiredFocusTarget()
    if Widget then
      Widget:SetFocus()
    end
  end
  self:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  M.Super.OnUpdateUIStyleByInputTypeChange(self, CurInputDevice, CurGamepadName)
  rawset(self, "CurInputDeviceType", CurInputDevice)
  rawset(self, "IsGamepadInput", self.CurInputDeviceType == ECommonInputType.Gamepad)
  self:OnFocusChanged()
end

function M:OnFocusChanged(NewState, OladState, Operation)
  self:UpdateKeyStyle()
  self:UpdateBottomKeyInfo()
end

function M:UpdateKeyStyle()
  local State = self.FSM:Peak()
  local StateName = State.Name
  if StateName == FocusStates.PhotoList then
    if self.IsGamepadInput then
      self.Key_Go:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  elseif StateName == FocusStates.RewardList and self.IsGamepadInput then
    self.Key_Go:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:UpdateBottomKeyInfo(NewState)
  local BottomKeyInfo = {}
  if self.IsGamepadInput then
    local State = self.FSM:Peak()
    local StateName = State.Name
    if StateName == FocusStates.PhotoList then
      table.insert(BottomKeyInfo, {
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "LS"}
        },
        Desc = GText("UI_Controller_CheckReward")
      })
      local ScrolOffsetEnd = self.ScrollBox_Message:GetScrollOffsetOfEnd()
      if ScrolOffsetEnd > 0 then
        table.insert(BottomKeyInfo, {
          GamePadInfoList = {
            {Type = "Img", ImgShortPath = "RV"}
          },
          Desc = GText("UI_Controller_Slide")
        })
      end
    elseif StateName == FocusStates.RewardList then
      table.insert(BottomKeyInfo, {
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "A"}
        },
        Desc = GText("UI_Controller_CheckDetails")
      })
    end
  end
  table.insert(BottomKeyInfo, self.ESCKeyInfoList)
  self.Tab:UpdateBottomKeyInfo(BottomKeyInfo)
end

function M:IsFocusStateValid(State)
  local StateName = State.Name
  if StateName == FocusStates.PhotoList then
    return self.ListView_Left:GetIndexForItem(State.Content) >= 0
  elseif StateName == FocusStates.RewardList then
    return self.List_Reward:GetIndexForItem(State.Content) >= 0
  end
end

function M:IsFocusStateWidgetHasAnyFocus(State)
  local StateName = State.Name
  if StateName == FocusStates.PhotoList then
    return UIUtils.HasAnyFocus(self.ListView_Left)
  elseif StateName == FocusStates.RewardList then
    return UIUtils.HasAnyFocus(self.List_Reward)
  end
end

function M:GetDesiredFocusTarget()
  local State = self.FSM:Peak()
  local StateName = State.Name
  if StateName == FocusStates.RewardList then
    self.List_Reward:BP_CancelScrollIntoView()
    self.List_Reward:BP_SetSelectedItem(State.Content)
    self.List_Reward:BP_NavigateToItem(State.Content)
    if rawget(State.Content, "SelfWidget") then
      return State.Content.SelfWidget
    end
    return self.List_Reward
  end
  if StateName == FocusStates.PhotoList then
    self.ListView_Left:BP_CancelScrollIntoView()
    self.ListView_Left:BP_SetSelectedItem(State.Content)
    self.ListView_Left:BP_NavigateToItem(State.Content)
    if rawget(State.Content, "SelfWidget") then
      return State.Content.Widget
    end
    return self.ListView_Left
  else
    self.ListView_Left:BP_CancelScrollIntoView()
    local Content = self.ListView_Left:GetItemAt(0)
    if Content then
      self.ListView_Left:BP_SetSelectedItem(Content)
      self.ListView_Left:BP_NavigateToItem(Content)
    end
    return self.ListView_Left
  end
end

function M:OnPhotoListContentCreated(Content)
  rawset(Content, "OnAddedToFocusPath", self.OnPhotoListItemAddedToFocusPath)
  rawset(Content, "OnRemovedFromFocusPath", self.OnPhotoListItemRemovedFromFocusPath)
end

function M:OnPhotoListItemAddedToFocusPath(Content)
  if self.FSM:Peak().Name == FocusStates.RewardList then
    self.FSM:Pop()
  end
  self.FSM:Push({
    Name = FocusStates.PhotoList,
    Content = Content
  })
end

function M:OnRewardListContentCreated(Content)
  rawset(Content, "OnAddedToFocusPathEvent", {
    Obj = self,
    Callback = self.OnRewardListItemAddedToFocusPath,
    Params = Content
  })
  rawset(Content, "OnRemovedFromFocusPathEvent", {
    Obj = self,
    Callback = self.OnRewardListItemRemovedFromFocusPath,
    Params = Content
  })
end

function M:OnRewardListItemAddedToFocusPath(Content)
  self.FSM:Push({
    Name = FocusStates.RewardList,
    Content = Content
  })
end

function M:OnRewardListItemRemovedFromFocusPath(Content)
end

function M:OnAddedToFocusPath()
  rawset(self, "IsInFocusPath", true)
end

function M:OnRemovedFromFocusPath()
  rawset(self, "IsInFocusPath", false)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if not self.IsGamepadInput then
    return UIUtils.Handled
  end
  return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self:GetDesiredFocusTarget())
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:OnBackKeyDown()
    return UIUtils.Handled
  end
  local StateName = self.FSM:Peak().Name
  if StateName == FocusStates.PhotoList then
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
      self:OnRewardAndPhotoButtonClicked()
    elseif InKeyName == UIConst.GamePadKey.LeftThumb then
      self.FSM:Push({
        Name = FocusStates.RewardList,
        Content = self.List_Reward:GetItemAt(0)
      })
      UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self:GetDesiredFocusTarget())
    end
  end
  return UIUtils.Handled
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local StateName = self.FSM:Peak().Name
  if StateName == FocusStates.PhotoList and InKeyName == UIConst.GamePadKey.RightAnalogY then
    UIUtils.ScrollBoxByGamepad(self.ScrollBox_Message, InAnalogInputEvent)
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnBackKeyDown()
  local StateName = self.FSM:Peak().Name
  if StateName == FocusStates.RewardList then
    self.FSM:Pop()
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self:GetDesiredFocusTarget()), true
  else
    self:CloseSelf()
  end
end

return M
