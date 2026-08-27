require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local FSM = require("Blueprints.UI.FocusStateMachine")
local FocusStates = {
  MasteryWidget = "MasteryWidget",
  ResourceWidget = "ResourceWidget"
}
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.KeyInputComponent"
}

function M:Construct()
  self.Target = nil
  self.CachedConsumeData = {}
  self.SelectedWeaponTag = nil
  self.Text_Title:SetText(GText("UI_Armory_ExtraExcelWeponTitle"))
  self.Text_Hint:SetText(GText("UI_Armory_ExtraExcelWeponDes"))
  self.Text_Consume:SetText(GText("UI_Armory_ExtraExcelResource"))
  self.FSM = FSM:New(self, {
    StateNames = FocusStates,
    OnStateChanged = self.OnFocusStateChanged
  })
  self.Btn_Unlock:SetGamePadImg("Y")
  self.Btn_Unlock:BindEventOnClicked(self, self.OnEquipOrUnlockBtnClicked)
  self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonTop, self.OnConfirmKeyDown)
  self:AddKeyDownEvent(UIConst.GamePadKey.LeftThumb, self.OnFocusToResourceKeyDown)
  self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonRight, self.OnFaceButtonRightKeyDown)
end

function M:ReceiveEnterState(StackAction)
  self:UpdateConsumePanel()
  self:UpdateUnlockButton()
  self:UpdateRedDot()
end

function M:Init(Params)
  self.Parent = Params.Parent
  self.Target = Params.Target
  self:UpdateCharInfo()
  local Data = DataMgr.BattleChar[self.Target.CharId]
  local ExcelWeaponTagsExpand = Data and Data.ExcelWeaponTagsExpand or {}
  UIUtils.CreateWidgetsInPanel(self.WB_Item, #ExcelWeaponTagsExpand)
  self:RefreshMasteryWidgets()
  self:UpdateEquippedWeaponTag()
  local InitWeaponTag = ExcelWeaponTagsExpand[1]
  for _, WeaponTag in ipairs(ExcelWeaponTagsExpand) do
    if self.Target.CurrentExcelWeaponExpand[WeaponTag] then
      InitWeaponTag = WeaponTag
      break
    end
  end
  self:OnMasteryItemClicked(InitWeaponTag)
  self:UpdateRedDot()
end

function M:UpdateCharInfo()
  if not self.Target then
    return
  end
  local CharId = self.Target.CharId
  local Data = DataMgr.Char[CharId]
  if Data then
    self.Text_RoleName:SetText(GText(Data.CharName))
    local AttrName = DataMgr.BattleChar[CharId].Attribute
    local IconName = "Armory_" .. AttrName
    local AttributeIcon = LoadObject("/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName)
    self.Image_Attribute:SetBrushResourceObject(AttributeIcon or LoadObject("/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_Default.T_Armory_Default"))
  end
end

function M:RefreshMasteryWidgets()
  local Data = DataMgr.BattleChar[self.Target.CharId]
  local ExcelWeaponTagsExpand = Data and Data.ExcelWeaponTagsExpand or {}
  local AllChildren = self.WB_Item:GetAllChildren():ToTable()
  self.MasteryWidgets = {}
  for i, WeaponTag in ipairs(ExcelWeaponTagsExpand) do
    local Widget = AllChildren[i]
    if Widget then
      self.MasteryWidgets[WeaponTag] = Widget
      Widget:Init({
        Owner = self,
        OnAddedToFocusPath = self.OnMasteryWidgetAddedToFocusPath,
        WeaponTag = WeaponTag,
        IsUnlocked = self.Target.UnlockedExcelWeaponExpand[WeaponTag],
        IsSelected = self.SelectedWeaponTag == WeaponTag
      })
      Widget:SetVisibility(UIConst.VisibilityOp.Visible)
      Widget:BindEventOnClicked(self, function()
        self:OnMasteryItemClicked(WeaponTag)
      end)
    end
  end
end

function M:UpdateEquippedWeaponTag()
  for WeaponTag, Widget in pairs(self.MasteryWidgets) do
    if self.Target.CurrentExcelWeaponExpand[WeaponTag] then
      Widget:SetIsEquipped(true)
    else
      Widget:SetIsEquipped(false)
    end
  end
end

function M:OnMasteryItemClicked(WeaponTag)
  if self.SelectedWeaponTag == WeaponTag then
    return
  end
  local Widget = self.MasteryWidgets[self.SelectedWeaponTag]
  if Widget then
    Widget:SetIsSelected(false)
  end
  self.SelectedWeaponTag = WeaponTag
  local Widget = self.MasteryWidgets[self.SelectedWeaponTag]
  if Widget then
    Widget:SetIsSelected(true)
  end
  self:UpdateConsumePanel()
  self:UpdateUnlockButton()
end

function M:UpdateConsumePanel()
  if not self.SelectedWeaponTag then
    self.Panel_Consume:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  if self.Target.UnlockedExcelWeaponExpand[self.SelectedWeaponTag] then
    self.Panel_Consume:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  local ConsumeData = ArmoryUtils:GetExcelWeaponConsumeData(self.SelectedWeaponTag)
  if not ConsumeData or 0 == #ConsumeData then
    self.Panel_Consume:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  self.Panel_Consume:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  UIUtils.CreateWidgetsInPanel(self.HB_Item, #ConsumeData)
  local AllChildren = self.HB_Item:GetAllChildren():ToTable()
  self.ResourceWidgets = {}
  local Avatar = GWorld:GetAvatar()
  for i, Widget in ipairs(AllChildren) do
    if Widget then
      local Data = ConsumeData[i]
      local ResourceData = DataMgr.Resource[Data.ResourceId] or {}
      local ServerData = Avatar.Resources[Data.ResourceId] or {}
      self.ResourceWidgets[i] = Widget
      local Content = {
        Owner = self,
        Id = Data.ResourceId,
        Icon = ResourceData.Icon,
        Count = ServerData.Count or 0,
        NeedCount = Data.NeedCount,
        ItemType = "Resource",
        Rarity = ResourceData.Rarity,
        IsShowDetails = true
      }
      Content.OnAddedToFocusPathEvent = {
        Obj = self,
        Callback = self.OnResourceWidgetAddedToFocusPath,
        Params = Content
      }
      Widget:OnListItemObjectSet(Content)
    end
  end
end

function M:UpdateUnlockButton()
  if not self.SelectedWeaponTag then
    self.Btn_Unlock:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  self.Btn_Unlock:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  local IsTagUnlocked = self.Target.UnlockedExcelWeaponExpand[self.SelectedWeaponTag]
  local IsTagEquipped = self.Target.CurrentExcelWeaponExpand[self.SelectedWeaponTag]
  if IsTagEquipped then
    self.WS_Btn:SetActiveWidgetIndex(1)
    self.Com_Hint.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    self.Com_Hint.WS_Positive:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Com_Hint.Text_Hint_Positive:SetText(GText("UI_Armory_ExtraExcelWeapon_HaveEquiped"))
  elseif IsTagUnlocked then
    self.WS_Btn:SetActiveWidgetIndex(0)
    self.Btn_Unlock:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn_Unlock:ForbidBtn(false)
    self.Btn_Unlock:SetText(GText("UI_Armory_ExtraExcelWeapon_Equip"))
  else
    self.WS_Btn:SetActiveWidgetIndex(0)
    local IsEnough = ArmoryUtils:IsExcelWeaponUnlockResourceEnough(self.SelectedWeaponTag)
    self.Btn_Unlock:ForbidBtn(not IsEnough)
    if IsEnough then
      self.Btn_Unlock:SetText(GText("UI_Armory_ExtraExcelWeapon_Unlock"))
    else
      self.Btn_Unlock:SetText(GText("UI_Armory_ExtraExcelWeapon_LackofResource"))
    end
  end
end

function M:UpdateRedDot()
  if not self.MasteryWidgets then
    return
  end
  for WeaponTag, Widget in pairs(self.MasteryWidgets) do
    local IsTagUnlocked = self.Target.UnlockedExcelWeaponExpand[WeaponTag]
    local RedDotType
    if not IsTagUnlocked then
      local IsEnough = ArmoryUtils:IsExcelWeaponUnlockResourceEnough(WeaponTag)
      RedDotType = IsEnough and UIConst.RedDotType.CommonRedDot
    end
    Widget:SetRedDot(RedDotType)
  end
end

function M:OnEquipOrUnlockBtnClicked()
  if not self.SelectedWeaponTag then
    return
  end
  local IsTagUnlocked = self.Target.UnlockedExcelWeaponExpand[self.SelectedWeaponTag]
  local IsTagEquipped = self.Target.CurrentExcelWeaponExpand[self.SelectedWeaponTag]
  if IsTagUnlocked then
    if not IsTagEquipped then
      self:EquipWeaponMastery()
    end
  else
    local IsEnough = ArmoryUtils:IsExcelWeaponUnlockResourceEnough(self.SelectedWeaponTag)
    if IsEnough then
      self:ShowUnlockConfirmDialog()
    end
  end
end

function M:ShowUnlockConfirmDialog()
  local Data = DataMgr.Char[self.Target.CharId]
  local CharName = Data and GText(Data.CharName) or ""
  local WeaponTagData = DataMgr.WeaponTag[self.SelectedWeaponTag]
  local WeaponTagName = WeaponTagData and GText(WeaponTagData.WeaponTagTextmap) or ""
  local ConsumeData = ArmoryUtils:GetExcelWeaponConsumeData(self.SelectedWeaponTag)
  local ItemList = {}
  local Avatar = GWorld:GetAvatar()
  for _, Item in ipairs(ConsumeData) do
    local ResourceId = Item.ResourceId
    if ResourceId then
      table.insert(ItemList, {
        ItemId = ResourceId,
        ItemType = CommonConst.ItemType.Resource,
        ItemNum = Avatar.Resources[ResourceId] and Avatar.Resources[ResourceId].Count or 0,
        ItemNeed = Item.NeedCount
      })
    end
  end
  local Params = {
    RightCallbackObj = self,
    RightCallbackFunction = self.ConfirmUnlock,
    ItemList = ItemList,
    ShortText = string.format(GText("UI_PopUp_ExtraExcelWeapon_ResourceConsume"), CharName, WeaponTagName)
  }
  if #ItemList > 0 then
    UIManager(self):ShowCommonPopupUI(100433, Params, self)
  end
end

function M:ConfirmUnlock()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.Parent:BlockAllUIInput(true)
  Avatar:UnlockExcelWeaponExpand(self.Target.Uuid, {
    self.SelectedWeaponTag
  }, function(Ret, CharUuid, ExcelWeaponTags)
    self.Parent:BlockAllUIInput(false)
    if not ErrorCode:Check(Ret) then
      return
    end
    self.Target = Avatar.Chars[self.Target.Uuid]
    for index, WeaponTag in ipairs(ExcelWeaponTags or {}) do
      local Widget = self.MasteryWidgets[WeaponTag]
      if Widget then
        Widget:PlayUnLockAnim()
      end
    end
    self:UpdateConsumePanel()
    self:UpdateUnlockButton()
    self:UpdateRedDot()
    self.Parent.Armory_Mastery:RefreshExtraMasterRedDot()
  end)
end

function M:EquipWeaponMastery()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.Parent:BlockAllUIInput(true)
  Avatar:SwitchExcelWeaponExpand(self.Target.Uuid, {
    self.SelectedWeaponTag
  }, function(Ret, CharUuid, ExcelWeaponTags)
    self.Parent:BlockAllUIInput(false)
    if not ErrorCode:Check(Ret) then
      return
    end
    self.Target = Avatar.Chars[self.Target.Uuid]
    self:UpdateEquippedWeaponTag()
    self:UpdateUnlockButton()
    AudioManager(self):PlayUISound(self, "event:/ui/common/weapon_replace", nil, nil)
  end)
end

function M:Destruct()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  if self.IsGamepadInput then
    if not self.IsGamepadKeyCreated then
      self.IsGamepadKeyCreated = true
      self.Key_Consume:CreateCommonKey({
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "LS"}
        }
      })
    end
    self.Key_Consume:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.Key_Consume:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local Reply, IsHandled = self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
  if IsHandled then
    return Reply
  end
  return UIUtils.Unhandled
end

function M:OnConfirmKeyDown()
  if self.Btn_Unlock:IsVisible() and not self.Btn_Unlock:IsBtnForbidden() then
    self:OnEquipOrUnlockBtnClicked()
    return UIUtils.Handled, true
  end
end

function M:OnFocusToResourceKeyDown()
  if self.Panel_Consume:IsVisible() then
    local Widget = self.HB_Item:GetChildAt(0)
    if Widget then
      return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), Widget), true
    end
  end
end

function M:OnFaceButtonRightKeyDown()
  local StateName = self.FSM:Peak().Name
  if StateName == FocusStates.ResourceWidget then
    self.FSM:Pop()
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self:GetDesiredFocusTarget()), true
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  local Widget = self:GetDesiredFocusTarget()
  if Widget and Widget ~= self then
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), Widget)
  end
  return UIUtils.Handled
end

function M:OnFocusStateChanged()
end

function M:GetDesiredFocusTarget()
  local State = self.FSM:Peak()
  local Widget = not State.Widget and State.Content and State.Content.SelfWidget
  Widget = Widget or self.MasteryWidgets[self.SelectedWeaponTag]
  return Widget or self
end

function M:OnMasteryWidgetAddedToFocusPath(Widget)
  self.FSM:Clear()
  self.FSM:Push({
    Name = FocusStates.MasteryWidget,
    Widget = Widget
  })
  if self.IsGamepadInput then
    Widget:OnBtnClicked()
  end
end

function M:OnResourceWidgetAddedToFocusPath(Content)
  self.FSM:Push({
    Name = FocusStates.ResourceWidget,
    Content = Content
  })
end

AssembleComponents(M)
return M
