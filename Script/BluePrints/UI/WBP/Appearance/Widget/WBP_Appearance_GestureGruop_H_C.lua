require("UnLua")
local TempKeyMap = {
  One = 1,
  Two = 2,
  Three = 3,
  Four = 4,
  Five = 5,
  Six = 6,
  Seven = 7,
  Eight = 8,
  Nine = 9,
  Zero = 0
}
local ForbidKeyMap = {
  UIConst.GamePadKey.LeftShoulder,
  UIConst.GamePadKey.RightShoulder,
  UIConst.GamePadKey.LeftThumb,
  UIConst.GamePadKey.LeftTriggerThreshold,
  UIConst.GamePadKey.RightTriggerThreshold,
  UIConst.GamePadKey.FaceButtonBottom,
  UIConst.GamePadKey.FaceButtonRight
}
local M = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Destruct()
  self:UnBindInputMethodChangedDelegate()
  EventManager:RemoveEvent(EventID.GameViewportInputKeyReleased, self)
  EventManager:RemoveEvent(EventID.GameViewportInputKeyPressed, self)
  local PlayerChar = GWorld:GetMainPlayer()
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if GameInputModeSubsystem then
    GameInputModeSubsystem:SetMouseCursorVisable(true)
    GameInputModeSubsystem:SetMouseCursorOpacity(1.0)
  end
  self:SetInputModeEnabled(false)
end

function M:Construct()
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/common/sub_bar_expand_no_filter", "sub_bar_expand_no_filter", nil)
  local PlayerChar = GWorld:GetMainPlayer()
  EventManager:AddEvent(EventID.GameViewportInputKeyReleased, self, self.OnInputKeyReleased)
  EventManager:AddEvent(EventID.GameViewportInputKeyPressed, self, self.OnInputKeyPressed)
  EventManager:AddEvent(EventID.CharDie, self, self.CharDie)
  EventManager:AddEvent(EventID.OnNotifyClientToCloseLoading, self, self.EnterRegion)
  EventManager:AddEvent(EventID.InLoading, self, self.EnterRegion)
  EventManager:AddEvent(EventID.LoadUI, self, self.LoadUIEvent)
  local InputSetting = UE4.UInputSettings.GetInputSettings()
  local ActionMappings = InputSetting.ActionMappings:ToTable()
  for _, UserData in ipairs(ActionMappings) do
    if TempKeyMap[UserData.Key.KeyName] then
      self:ListenForInputAction(UserData.ActionName, EInputEvent.IE_Pressed, true, {
        self,
        self.OnQuickClick
      })
    end
  end
  self.Btn_Close:Init("Close", self, self.PlayOut)
  self.Btn_L.Btn.OnClicked:Add(self, self.OnBtnLeftClick)
  self.Btn_R.Btn.OnClicked:Add(self, self.OnBtnRightClick)
  for Index = 0, 3 do
    local Item = self["GesturePoint_" .. Index]
    Item.Btn_Area:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  self:BindInputMethodChangedDelegate()
  self:InitData()
  self:UpdateSelectInfo()
  self:SetQuickSwitchPageIcon()
  self.CurFocusGestureBtnIndex = 1
  if UIUtils.IsMobileInput() then
    self.Panel_Close:SetVisibility(UIConst.VisibilityOp.Visible)
  else
    self.Panel_Close:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.GestureBtn_0:SetFocus()
  self.GamePadForbid = {}
  for _, v in ipairs(ForbidKeyMap) do
    self.GamePadForbid[v] = true
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.IsGamepadInput() then
    self.GestureBtn_0:SetFocus()
    local Subsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    local Params = FGameInputModeParams()
    Params.WidgetToFocus = self
    Subsystem:EnableInputMode("AppearanceGestureGruop_H", EGameInputMode.GameAndUI, Params)
  end
  return UIUtils.Unandled
end

function M:InitData()
  local Avatar = GWorld:GetAvatar()
  local GestureItemPanel = Avatar.GestureItemPanel
  local CurGestureItemPanel = {}
  self.CurGestureItemPanel = CurGestureItemPanel
  for CurPageIndex = 1, 8 do
    CurGestureItemPanel[CurPageIndex] = {}
    local PageGestureData = GestureItemPanel[CurPageIndex] or {}
    for Slot = 1, 8 do
      local ResourceId = PageGestureData[Slot] or -1
      CurGestureItemPanel[CurPageIndex][Slot] = ResourceId
    end
  end
  self.CurSelectPage = 1
  self.CurSelectSlot = 1
  self.CurSelectGesture = -1
  self:UpdatePageSwitchBtnState()
end

function M:OnQuickClick()
end

function M:UpdateSelectInfo()
  for Index = 0, 7 do
    local Item = self["GestureBtn_" .. Index]
    Item:SetIndex(Index + 1)
    Item:SetKeyNumVisible(Index + 1)
    Item:SetSelectCallback({
      Func = self.OnSelectGesture,
      Obj = self,
      SlotIndex = Index + 1
    })
    Item:SetData(self.CurGestureItemPanel[self.CurSelectPage][Index + 1])
  end
  for Index = 0, 3 do
    local Item = self["GesturePoint_" .. Index]
    local PageIndex = Index + 1
    if self.CurSelectPage == PageIndex then
      Item.WS_State:SetActiveWidgetIndex(1)
    else
      Item.WS_State:SetActiveWidgetIndex(0)
    end
  end
  self.GestureBtn_0:SetFocus()
  self.CurFocusGestureBtnIndex = 1
  self:OnSelectGesture(self.CurSelectGesture, self.CurSelectSlot)
end

function M:OnSelectGesture(ResourceId, SlotIndex)
  self.CurSelectGesture = ResourceId
  self.CurSelectSlot = SlotIndex
  for Index = 0, 7 do
    local Item = self["GestureBtn_" .. Index]
    Item:SelectResource(SlotIndex, ResourceId)
  end
end

function M:OnBtnLeftClick()
  if self.CurSelectPage > 1 then
    self.CurSelectPage = self.CurSelectPage - 1
    self:UpdatePageSwitchBtnState()
    self:PlayAnimation(self.Change_L)
    return true
  end
  return false
end

function M:OnBtnRightClick()
  if self.CurSelectPage < 4 then
    self.CurSelectPage = self.CurSelectPage + 1
    self:UpdatePageSwitchBtnState()
    self:PlayAnimation(self.Change_R)
    return true
  end
  return false
end

function M:OnKeyLeftClick()
  self:OnBtnLeftClick()
end

function M:OnKeyRightClick()
  self:OnBtnRightClick()
end

function M:UpdatePageSwitchBtnState()
  AudioManager(self):PlayUISound(nil, "event:/ui/common/sub_bar_content_scroll", nil, nil)
  if UIUtils.IsMobileInput() then
    if 1 == self.CurSelectPage then
      self.Btn_L:ForbidBtn(true)
    elseif 4 == self.CurSelectPage then
      self.Btn_R:ForbidBtn(true)
    else
      self.Btn_L:ForbidBtn(false)
      self.Btn_R:ForbidBtn(false)
    end
  else
    self.Btn_L:ForbidBtn(false)
    self.Btn_R:ForbidBtn(false)
  end
end

function M:Change_List()
  self:UpdateSelectInfo()
  for Index = 0, 7 do
    local Item = self["GestureBtn_" .. Index]
    Item:UpdateSelectResource(self.CurSelectGesture)
  end
end

function M:CharDie()
  self:PlayOut()
end

function M:EnterRegion()
  self:PlayOut()
end

function M:LoadUIEvent()
  self:PlayOut()
end

function M:OnInputKeyPressed(Key, EventType)
  local IsHandle = false
  if UIUtils.IsPCInput() then
    if TempKeyMap[Key.KeyName] then
      return
    end
    if Key.KeyName == "Q" or Key.KeyName == "E" then
      return
    end
    self:OnSelectGesture(-1, -1)
    if Key.KeyName == "LeftAlt" then
      IsHandle = true
      local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
      if GameInputModeSubsystem then
        GameInputModeSubsystem:SetMouseCursorVisable(true)
        GameInputModeSubsystem:SetMouseCursorOpacity(1.0)
        self:SetInputModeEnabled(true)
      end
    end
  end
end

function M:OnInputKeyReleased(Key, EventType)
  local IsHandle = false
  if UIUtils.IsPCInput() then
    for KeyName, _ in pairs(TempKeyMap) do
      if KeyName == Key.KeyName then
        local Item = self["GestureBtn_" .. TempKeyMap[Key.KeyName] - 1]
        if Item and self.CurSelectGesture ~= Item.ResourceId then
          Item:OnBtnClick()
        end
        IsHandle = true
        break
      end
    end
    if not IsHandle then
      if Key.KeyName == "Q" then
        IsHandle = self:OnBtnLeftClick()
        IsHandle = true
      elseif Key.KeyName == "E" then
        IsHandle = self:OnBtnRightClick()
        IsHandle = true
      elseif Key.KeyName == "Escape" or Key.KeyName == "F6" then
        self:PlayOut()
        IsHandle = true
      elseif Key.KeyName == "LeftAlt" then
        IsHandle = true
        local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
        if GameInputModeSubsystem then
          GameInputModeSubsystem:SetMouseCursorVisable(false)
          GameInputModeSubsystem:SetMouseCursorOpacity(0.0)
          self:SetInputModeEnabled(false)
        end
      end
    end
  end
end

function M:BindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  self.GameInputModeSubsystem = GameInputModeSubsystem
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
  end
end

function M:UnBindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.PlayerController = PlayerController
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
  end
end

function M:OnInputMethodChanged(NewGameInputType, NewGamepadName)
  self:RefreshIconAndGamePadVisibility(NewGameInputType)
  if NewGameInputType == ECommonInputType.Gamepad then
    self:SetInputModeEnabled(true)
    self.CurFocusGestureBtnIndex = 1
  else
    self:SetInputModeEnabled(false)
  end
end

function M:RefreshIconAndGamePadVisibility(GameInputType)
  if GameInputType == ECommonInputType.Gamepad then
  end
  self:UpdatePageSwitchBtnState()
  self:SetQuickSwitchPageIcon()
  for Index = 0, 7 do
    local Item = self["GestureBtn_" .. Index]
    Item:SetKeyNumVisible()
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local InputEvent = UWidgetBlueprintLibrary.GetInputEventFromKeyEvent(InKeyEvent)
  return UIUtils.UnHandled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local InputEvent = UWidgetBlueprintLibrary.GetInputEventFromKeyEvent(InKeyEvent)
  if UIUtils.IsGamepadInput() and self.GamePadForbid[InKeyName] then
    return UIUtils.Handled
  end
  if UIUtils.IsPCInput() and ("Q" == InKeyName or "E" == InKeyName or "Four" == InKeyName) then
    return UIUtils.Handled
  end
  return UIUtils.UnHandled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local InputEvent = UWidgetBlueprintLibrary.GetInputEventFromKeyEvent(InKeyEvent)
  local IsHandle = false
  if UIUtils.IsGamepadInput() then
    if InKeyName == UIConst.GamePadKey.LeftShoulder then
      IsHandle = self:OnBtnLeftClick()
    elseif InKeyName == UIConst.GamePadKey.RightShoulder then
      IsHandle = self:OnBtnRightClick()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
      self:PlayOut()
      IsHandle = true
    elseif InKeyName == UIConst.GamePadKey.DPadLeft then
      if self.CurFocusGestureBtnIndex > 1 then
        self.CurFocusGestureBtnIndex = self.CurFocusGestureBtnIndex - 1
        local Item = self["GestureBtn_" .. self.CurFocusGestureBtnIndex - 1]
        Item:SetFocus()
        IsHandle = true
      end
    elseif InKeyName == UIConst.GamePadKey.DPadRight then
      if self.CurFocusGestureBtnIndex < 8 then
        self.CurFocusGestureBtnIndex = self.CurFocusGestureBtnIndex + 1
        local Item = self["GestureBtn_" .. self.CurFocusGestureBtnIndex - 1]
        Item:SetFocus()
        IsHandle = true
      end
    elseif InKeyName == UIConst.GamePadKey.LeftThumb then
      IsHandle = true
    end
  end
  if IsHandle then
    return UE4.UWidgetBlueprintLibrary.Handled
  else
    return UE4.UWidgetBlueprintLibrary.Unhandled
  end
end

function M:SetInputModeEnabled(bIsEnable)
  local Subsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if bIsEnable then
    local Params = FGameInputModeParams()
    Params.WidgetToFocus = self
    Params.MouseLockMode = EMouseLockMode.LockOnCapture
    Params.bHideCursorDuringCapture = true
    Params.bShowMouseCursor = true
    Subsystem:EnableInputMode("AppearanceGestureGruop_H", EGameInputMode.GameAndUI, Params)
    UIManager(self):SetUIInputEnable(false, self.GameInputModeTag)
  else
    Subsystem:DisableInputMode("AppearanceGestureGruop_H")
    UIManager(self):SetUIInputEnable(true, self.GameInputModeTag)
  end
end

function M:SetQuickSwitchPageIcon()
  if UIUtils.IsGamepadInput() then
    self.Key_L:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LB"}
      },
      bAllowForbid = false
    })
    self.Key_R:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "RB"}
      },
      bAllowForbid = false
    })
  elseif UIUtils.IsPCInput() then
    self.Key_L:CreateCommonKey({
      KeyInfoList = {
        {Type = "Text", ImgShortPath = "Q"}
      },
      bAllowForbid = false
    })
    self.Key_R:CreateCommonKey({
      KeyInfoList = {
        {Type = "Text", ImgShortPath = "E"}
      },
      bAllowForbid = false
    })
  else
    self.Key_L:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Key_R:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Key_L.Button_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Key_R.Button_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:PlayOut()
  AudioManager(self):SetEventSoundParam(self, "sub_bar_expand_no_filter", {ToEnd = 1})
  self:BindToAnimationFinished(self.Out, function()
    self:RemoveFromParent()
  end)
  self:PlayAnimation(self.Out)
end

function M:RemoveFromParent()
  local BattleMainUI = UIManager():GetUIObj("BattleMain")
  if not BattleMainUI then
    return
  end
  BattleMainUI:CloseAppearanceGestureGruop(self)
  self:SetInputModeEnabled(false)
end

return M
