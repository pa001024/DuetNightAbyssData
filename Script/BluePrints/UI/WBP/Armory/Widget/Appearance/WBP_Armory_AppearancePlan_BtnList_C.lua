require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.bIsFocusable = true
  self.BtnList = {
    self.Btn_CopyLink,
    self.Btn_CopyCommunity,
    self.Btn_Import,
    self.Btn_ReName
  }
  for index, value in ipairs(self.BtnList) do
    value.BP_OnAddedToFocusPath:Add(self, self.OnBtnAddedToFocusPath)
    value.BP_OnRemovedFromFocusPath:Add(self, self.OnBtnRemovedFromFocusPath)
    value:SetGamepadIconVisibility(false)
  end
  self.Btn_CopyCode.BP_OnAddedToFocusPath:Add(self, self.OnBtnAddedToFocusPath)
  self.Btn_CopyCode.BP_OnRemovedFromFocusPath:Add(self, self.OnBtnRemovedFromFocusPath)
  self.Btn_CopyCode:SetGamepadIconVisibility(false)
  self.CommunityShareCode = ""
  self:ResetCommunityCodeState()
  self:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Text_DyeCode:SetText(GText("UI_Dye_Output_Build"))
end

function M:OnBtnAddedToFocusPath(Widget)
  Widget:SetGamepadIconVisibility(true)
end

function M:OnBtnRemovedFromFocusPath(Widget)
  Widget:SetGamepadIconVisibility(false)
end

function M:ResetCommunityCodeState()
  self.CommunityShareCode = ""
  if self.WS_State then
    self.WS_State:SetActiveWidgetIndex(0)
  end
end

function M:OnBtnCopyCommunityClicked()
  if not self._OnBuildCommunityCode then
    return
  end
  local CommunityCode = self._OnBuildCommunityCode(self.Owner)
  if not CommunityCode or "" == CommunityCode then
    return
  end
  self.CommunityShareCode = CommunityCode
  if self.Btn_CopyCode then
    self.Btn_CopyCode:SetText(GText("UI_AppearanceScore_CodeGenerated"))
    self.Btn_CopyCode:SetFocus()
  end
  if self.WS_State then
    self.WS_State:SetActiveWidgetIndex(1)
  end
end

function M:OnBtnCopyCodeClicked()
  if not self.CommunityShareCode or self.CommunityShareCode == "" then
    return
  end
  ULowEntryExtendedStandardLibrary.ClipboardSet(self.CommunityShareCode)
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Dye_Output_Copy"))
end

function M:GetDesiredFocusTarget()
  if self.WS_State and self.WS_State.GetActiveWidgetIndex and 1 == self.WS_State:GetActiveWidgetIndex() and self.Btn_CopyCode then
    return self.Btn_CopyCode
  end
  if self.Btn_CopyLink and self.Btn_CopyLink:IsVisible() then
    return self.Btn_CopyLink
  end
  for _, Btn in ipairs(self.BtnList or {}) do
    if Btn and Btn:IsVisible() then
      return Btn
    end
  end
  return nil
end

function M:Init(Params)
  Params = Params or {}
  rawset(self, "_OnAddToFocusPath", Params.OnAddedToFocusPath)
  rawset(self, "Owner", Params.Owner)
  rawset(self, "_OnBuildCommunityCode", Params.OnBuildCommunityCode)
  self:ResetCommunityCodeState()
  if self.Btn_CopyCode then
    self.Btn_CopyCode:UnBindEventOnClickedByObj(self)
    self.Btn_CopyCode:BindEventOnClicked(self, self.OnBtnCopyCodeClicked)
  end
  local BtnListParams = Params.BtnListParams or {}
  for index, Btn in ipairs(self.BtnList) do
    if BtnListParams[index] then
      Btn:SetText(BtnListParams[index].Text)
      Btn:UnBindEventOnClickedByObj(self.Owner)
      Btn:UnBindEventOnClickedByObj(self)
      if 2 == index and self.Btn_CopyCode then
        Btn:BindEventOnClicked(self, self.OnBtnCopyCommunityClicked)
      else
        Btn:BindEventOnClicked(self.Owner, BtnListParams[index].Func)
      end
      Btn:SetVisibility(UIConst.VisibilityOp.Visible)
    else
      Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:OnAddedToFocusPath()
  self.IsInFocusPath = true
  if self._OnAddToFocusPath then
    self._OnAddToFocusPath(self.Owner)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  local Target = self:GetDesiredFocusTarget()
  if Target then
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), Target)
  end
  return UIUtils.Handled
end

function M:OnRemovedFromFocusPath()
  self.IsInFocusPath = false
  self:ResetCommunityCodeState()
  self:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

return M
