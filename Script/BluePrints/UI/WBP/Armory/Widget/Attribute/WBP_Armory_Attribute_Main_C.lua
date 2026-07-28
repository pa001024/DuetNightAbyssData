require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:Construct()
  self.Attr2Widget = {
    Light = self.AttributeBgLight,
    Dark = self.AttributeBgDark
  }
  self.Attr2Img = {
    Light = self.Image_IconLight,
    Dark = self.Image_IconDark
  }
  self.Btn.Btn.OnClicked:Add(self, self.OnBtnClick)
  self:AddDispatcher(EventID.OnCharAttributeSwitched, self, self.OnCharAttributeSwitched)
  self:AddInputMethodChangedListen()
  self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:Init(Params)
  rawset(self, "Params", Params)
  rawset(self, "Parent", Params.Parent)
  rawset(self, "Avatar", Params.Avatar)
  local GroupData = DataMgr.CharacterAttributeSwitch[Params.CharId]
  if not GroupData then
    return
  end
  rawset(self, "CharGroupId", GroupData.CharGroupId or 1)
  local GroupCurrentCharId = AvatarUtils:GetCurrentCharIdByGroupId(self.Avatar, self.CharGroupId)
  if not GroupCurrentCharId or GroupCurrentCharId <= 0 then
    return
  end
  local CharGroup = ArmoryUtils:GetCharGroup(GroupCurrentCharId)
  if not CharGroup then
    return
  end
  rawset(self, "SelectedCharId", GroupCurrentCharId)
  for key, Widget in pairs(self.Attr2Widget) do
    local CharId = CharGroup[key]
    if CharId then
      local Content = {
        Attr = key,
        CharId = CharId,
        IsSelected = CharId == GroupCurrentCharId,
        OnClicked = self.OnAttrBtnClick,
        Owner = self
      }
      Widget:Init(Content)
      if CharId == GroupCurrentCharId then
        rawset(self, "SelectedContent", Content)
      end
    end
    Widget.BP_OnAddedToFocusPath:Clear()
    Widget.BP_OnAddedToFocusPath:Add(self, self.OnAttrWidgetAddedToFocusPath)
  end
  self.Btn.TextConfirm:SetText(GText("UI_Armory_CurrentAttr"))
  self.Btn.Btn:SetForbidden(true)
  self:UpdateGamepadKeyVisibility()
  self:UpdateConfirmBtnAttrIcon(self.SelectedContent)
  local ArmoryUI = UIManager(self):GetArmoryUIObj()
  if ArmoryUI.ActorController then
    ArmoryUI.ActorController:BindViewUI(self.Parent)
    ArmoryUI.ActorController:SetCurrentViewUI(self.Parent)
    ArmoryUI.ActorController:SetArmoryMontageTag("Armory_ChangeAttr")
  end
end

function M:OnAttrBtnClick(Content)
  AudioManager(self):PlayUISound(self, "event:/ui/common/special_content_01_click", "", nil)
  ArmoryUtils:SetContentIsSelected(self.SelectedContent, false)
  self.SelectedContent = Content
  ArmoryUtils:SetContentIsSelected(Content, true)
  local CurCharId = AvatarUtils:GetCurrentCharIdByCharId(self.Avatar, self.SelectedContent.CharId)
  self:CheckNeedForbidConfirmBtn(CurCharId)
  self:UpdateConfirmBtnAttrIcon(Content)
  self:ChangeCharModelByCharId(Content.CharId)
  local ArmoryUI = UIManager(self):GetArmoryUIObj()
  if ArmoryUI.ActorController then
    ArmoryUI:UpdateMontageAndCamera()
    ArmoryUI.ActorController:SetArmoryMontageTag("Armory_ChangeAttr")
  end
end

function M:CheckNeedForbidConfirmBtn(CurCharId)
  if CurCharId == self.SelectedContent.CharId then
    self.Btn.TextConfirm:SetText(GText("UI_Armory_CurrentAttr"))
    self.Btn.Btn:SetForbidden(true)
  else
    self.Btn.TextConfirm:SetText(GText("UI_Armory_SwitchAttr"))
    self.Btn.Btn:SetForbidden(false)
  end
  self:UpdateGamepadKeyVisibility()
end

function M:UpdateConfirmBtnAttrIcon(Content)
  if not Content then
    return
  end
  if self.Attr2Img[Content.Attr] then
    self.Btn.Img_Icon:SetBrushResourceObject(self.Attr2Img[Content.Attr].Brush.ResourceObject)
  end
end

function M:OnBtnClick()
  if self.Btn.Btn:GetForbidden() then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/role_prop_change_click_confirm", "", nil)
  local Avatar = GWorld:GetAvatar()
  self.Parent:BlockAllUIInput(true)
  Avatar:SwitchCharacterAttribute(self.SelectedContent.CharId)
end

function M:OnCharAttributeSwitched(Ret)
  self.Parent:BlockAllUIInput(false)
  if not ErrorCode:Check(Ret) then
    return
  end
  local CharInfo = DataMgr.BattleChar[self.SelectedContent.CharId]
  local PlayerInfo = DataMgr.Model[CharInfo.ModelId]
  local ArmoryUI = UIManager(self):GetArmoryUIObj()
  if ArmoryUI.ActorController and ArmoryUI.ActorController.ArmoryPlayer.FXComponent and PlayerInfo.AttrConfimEffect then
    ArmoryUI.ActorController.ArmoryPlayer.FXComponent:PlayEffectByIDParams(PlayerInfo.AttrConfimEffect, {bTickEvenWhenPaused = true, NotAttached = true})
  end
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Char_AttrChanged"))
  local CurCharId = AvatarUtils:GetCurrentCharIdByGroupId(self.Avatar, self.CharGroupId)
  self:CheckNeedForbidConfirmBtn(CurCharId)
end

function M:PlayInAnim()
  self:StopAnimation(self.Out)
  self:PlayAnimation(self.In)
end

function M:PlayOutAnim()
  self:StopAnimation(self.In)
  self:PlayAnimation(self.Out)
end

function M:ChangeCharModelByCharId(CharId)
  local CharUuid = self.Avatar:GetCharUuidByCharId(CharId)
  local Char = self.Avatar.Chars[CharUuid]
  local CharInfo = DataMgr.BattleChar[CharId]
  local PlayerInfo = DataMgr.Model[CharInfo.ModelId]
  local ArmoryUI = UIManager(self):GetArmoryUIObj()
  if ArmoryUI.ActorController and Char then
    ArmoryUI.ActorController:ChangeCharModel(Char)
  end
end

function M:Destruct()
  local ArmoryUI = UIManager(self):GetArmoryUIObj()
  local CurCharId = AvatarUtils:GetCurrentCharIdByGroupId(self.Avatar, self.CharGroupId)
  if CurCharId and CurCharId > 0 and self.SelectedContent and CurCharId ~= self.SelectedContent.CharId then
    self:ChangeCharModelByCharId(CurCharId)
  end
  if ArmoryUI then
    if ArmoryUI.ActorController then
      ArmoryUI.ActorController:UnBindViewUI(self.Parent)
      ArmoryUI.ActorController:ResetCurrentViewUI()
    end
    ArmoryUI:UpdateMontageAndCamera()
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.SelectedContent then
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.SelectedContent.Widget)
  end
  return UIUtils.Handled
end

function M:OnAttrWidgetAddedToFocusPath(Widget)
  if UIUtils.IsGamepadInput() then
    local Content = Widget.Content
    if Content and self.SelectedContent ~= Content then
      self:OnAttrBtnClick(Content)
    end
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  self:UpdateGamepadKeyVisibility()
end

function M:UpdateGamepadKeyVisibility()
  if self.IsGamepadInput then
    if self.Btn.Btn:GetForbidden() then
      self.Btn.KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
      self.Btn.KeyImg:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
  else
    self.Btn.KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

AssembleComponents(M)
return M
