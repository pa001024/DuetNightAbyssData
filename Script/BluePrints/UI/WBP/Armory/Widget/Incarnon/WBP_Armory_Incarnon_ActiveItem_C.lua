require("UnLua")
local ControllerFSM = require("Blueprints.UI.ControllerFSM")
local HyperWeaponUtils = require("Utils.HyperWeaponUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}
local FSMState = {
  Normal = 1,
  CheckItem = 2,
  ShowTip = 3
}

function M:Construct()
  self.ControllerFSM = ControllerFSM.New(self, {
    [FSMState.Normal] = {
      OnEnter = self.OnEnterState_Normal
    },
    [FSMState.CheckItem] = {
      OnEnter = self.OnEnterState_CheckItem
    },
    [FSMState.ShowTip] = {
      OnEnter = self.OnEnterState_ShowTip
    }
  })
  self.Key_Consume:CreateGamepadKey(UIConst.GamePadImgKey.LeftThumb)
  self.Key_Qa:CreateGamepadKey(UIConst.GamePadImgKey.SpecialRight)
  self:AddInputMethodChangedListen()
end

function M:Destruct()
  self:RemoveInputMethodChangedListen()
end

function M:InitContent(Content)
  self.Parent = Content.Parent
  self.TalentId = Content.TalentId
  self.CallbackObj = Content.CallbackObj
  self.Callback = Content.Callback
  self:InitPage()
  self:SetFreeState(false)
  self:PlayNormalAnimation()
  self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

function M:InitPage()
  local TalentInfo = DataMgr.HyperWeaponSkillTree[self.TalentId]
  if not TalentInfo then
    return
  end
  if TalentInfo.SkillIcon then
    local Texture = LoadObject(TalentInfo.SkillIcon)
    self.Icon_Talent:SetBrushFromTexture(Texture)
  end
  self.TalentName = HyperWeaponUtils.GetTalentName(self.TalentId)
  self.TalentDesc = HyperWeaponUtils.GetSkillDesc(self.TalentId)
  self.Text_Talent:SetText(self.TalentName)
  self.Text_TalentDesc:SetText(self.TalentDesc)
  self.Key_Consume:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Text_Consume:SetText(GText("Draft_Resource_Consume"))
  local Contents = {}
  for i, Id in pairs(TalentInfo.ResourceId) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.UnitId = Id
    Content.Count = TalentInfo.ResourceNum[i]
    Content.IsShowDetails = true
    Content.IsSelect = false
    Content.ItemType = "Resource"
    Content.Icon = ItemUtils.GetItemIconPath(Id, Content.ItemType)
    Content.OnAddedToFocusPathEvent = {
      Obj = self,
      Callback = self.OnItemAddToFocusPath,
      Params = Content
    }
    Content.OnMenuOpenChangedEvents = {
      Obj = self,
      Callback = self.OnMenuOpenChange
    }
    table.insert(Contents, Content)
  end
  local Panel = self.WB_Item
  local WidgetCount = 0
  local Widget = Panel:GetChildAt(0)
  local WidgetClass = UGameplayStatics.GetObjectClass(Widget)
  for _, Content in ipairs(Contents) do
    Widget = Panel:GetChildAt(WidgetCount)
    if not Widget then
      Widget = UIManager(self):CreateWidget(WidgetClass)
      Panel:AddChild(Widget)
    end
    Widget:SetVisibility(UIConst.VisibilityOp.Visible)
    Widget:Init(Content)
    WidgetCount = WidgetCount + 1
  end
  local Start, End = WidgetCount, Panel:GetChildrenCount() - 1
  for i = Start, End do
    Widget = Panel:GetChildAt(i)
    Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:UpdateFocusItem(Panel:GetChildAt(0))
end

function M:SetFreeState(IsFree)
  if IsFree then
    self.Panel_FreeHint:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Text_FreeHint:SetText(GText("UI_HyperWeapon_ResourceFree"))
    local Params = {
      OwnerWidget = self,
      TextContent = GText("UI_HyperWeapon_ResourceFreeTips"),
      SoundFunc = function(Obj)
        AudioManager(Obj):PlayUISound(Obj, "event:/ui/common/click_btn_small", nil, nil)
      end,
      MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight
    }
    self.Com_BtnQa:Init(Params)
  else
    self.Panel_FreeHint:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:IsStopProcessEvent()
  return self.StopProcess
end

function M:PlayNormalAnimation()
  self.StopProcess = false
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
  self:SetFreeState(false)
end

function M:OnButtonClicked()
  if self:IsStopProcessEvent() then
    return
  end
  if self.CallbackObj and self.Callback and type(self.Callback) == "function" then
    self.Callback(self.CallbackObj, self, self.TalentId)
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Click)
  self:SetFreeState(true)
  self.StopProcess = true
end

function M:OnButonHovered()
  if self:IsStopProcessEvent() then
    return
  end
  self:StopAnimation(self.UnHover)
  self:PlayAnimation(self.Hover)
end

function M:OnButonUnhovered()
  if self:IsStopProcessEvent() then
    return
  end
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.UnHover)
end

function M:OnButonPressed()
  if self:IsStopProcessEvent() then
    return
  end
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.Press)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  if self.IsGamepadInput then
    self:InitGamepadView()
  else
    self:InitKeyboardView()
  end
end

function M:InitGamepadView()
  if self.Parent and self.Parent.FocusWidget ~= self then
    return
  end
  if self.IsShowingTip then
    self.ControllerFSM:Enter(FSMState.ShowTip)
  else
    self.ControllerFSM:Enter(FSMState.Normal)
  end
  self.Key_Qa:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Key_Consume:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.EMScrollBox_Text:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function M:InitKeyboardView()
  self.ControllerFSM:Reset()
  self.Key_Qa:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Key_Consume:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.EMScrollBox_Text:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:OnItemAddToFocusPath(Content)
  self:UpdateFocusItem(Content.SelfWidget)
end

function M:OnMenuOpenChange(IsOpen)
  if UIUtils.IsGamepadInput() then
    if IsOpen then
      self.ControllerFSM:Enter(FSMState.ShowTip)
    else
      self.ControllerFSM:Enter(FSMState.CheckItem)
    end
  end
  self.IsShowingTip = IsOpen
end

function M:UpdateFocusItem(ItemWidget)
  if not ItemWidget then
    return
  end
  self.Item = ItemWidget
end

function M:OnEnterState_Normal()
  if self.IsGamepadInput then
    self.Key_Consume:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  self:_CallParentFunction("OnEnterState_Normal")
end

function M:OnEnterState_CheckItem()
  if self.IsGamepadInput then
    self.Key_Consume:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:_CallParentFunction("OnEnterState_CheckItem")
end

function M:OnEnterState_ShowTip()
  self:_CallParentFunction("OnEnterState_ShowTip")
end

function M:_CallParentFunction(FuncName, ...)
  if self.Parent and self.Parent[FuncName] then
    self.Parent[FuncName](self.Parent, ...)
  end
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.SpecialRight and self.Panel_FreeHint:IsVisible() then
    self.Com_BtnQa:OnViewInfoClick(false)
    if self.ControllerFSM:Current() == FSMState.Normal then
      self:SetFocus()
    elseif self.ControllerFSM:Current() == FSMState.CheckItem then
      self.Item:SetFocus()
    end
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if InKeyName == Const.GamepadLeftThumbstick then
    if self.ControllerFSM:Current() == FSMState.Normal then
      self.ControllerFSM:Enter(FSMState.CheckItem)
      self.Item:SetFocus()
    end
    IsEventHandled = true
  elseif InKeyName == Const.GamepadFaceButtonRight then
    if self.ControllerFSM:Current() == FSMState.CheckItem then
      self.ControllerFSM:Enter(FSMState.Normal)
      self:SetFocus()
      self:UpdateFocusItem(self.WB_Item:GetChildAt(0))
      IsEventHandled = true
    elseif self.ControllerFSM:Current() == FSMState.ShowTip then
      self.ControllerFSM:Enter(FSMState.CheckItem)
      self.Item:SetFocus()
      IsEventHandled = true
    end
  elseif InKeyName == UIConst.GamePadKey.SpecialRight and self.Panel_FreeHint:IsVisible() then
    self.Com_BtnQa:OnViewInfoClick(true)
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:OnAddedToFocusPath()
  self:_CallParentFunction("OnSubWidgetFocus", self)
  if self.IsGamepadInput then
    self:InitGamepadView()
  end
end

function M:OnRemovedFromFocusPath()
  self:InitKeyboardView()
end

AssembleComponents(M)
return M
