require("UnLua")
local M = Class({
  "BluePrints.UI.AutoChess.WBP_Activity_AutoChess_Share_Base"
})

function M:Construct()
  M.Super.Construct(self)
  self.Main.SearchBuff.Key_Buff:CreateGamepadKey(UIConst.GamePadImgKey.SpecialLeft)
  self.Main.SearchWeather.Key_Buff:CreateGamepadKey(UIConst.GamePadImgKey.SpecialRight)
  self.Main.Key_Share:CreateGamepadKey(UIConst.GamePadImgKey.LeftThumb)
  self.Main.BtnConfirm.Key_GamePad:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonTop)
  self.Right.Refresh.Controller:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonLeft)
  self.Right.BtnChallenge.Key_GamePad:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonBottom)
end

function M:OnFocusReceived(MyGeo, InFocusEvent)
  local Res = M.Super.OnFocusReceived(self, MyGeo, InFocusEvent)
  self:RefreshOpInfoByInputDevice()
  return Res
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
  self:RefreshOpInfoByInputDevice()
end

function M:Close()
  M.Super.Close(self)
end

function M:OnKeyDown(MyGeo, InKeyEvent)
  local Handle = M.Super.OnKeyDown(self, MyGeo, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  return Handle
end

function M:OnPreviewKeyDown(MyGeo, InKeyEvent)
  local Handle = M.Super.OnPreviewKeyDown(self, MyGeo, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  return Handle
end

function M:OnKeyUp(MyGeo, InKeyEvent)
  local Handle = M.Super.OnKeyUp(self, MyGeo, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.SpecialLeft then
    self.Main.SearchBuff.Btn_Cancel.OnClicked:Broadcast()
  elseif InKeyName == UIConst.GamePadKey.SpecialRight then
    self.Main.SearchWeather.Btn_Cancel.OnClicked:Broadcast()
  elseif InKeyName == UIConst.GamePadKey.LeftThumb then
    self.Main.BtnShare:OnBtnClicked()
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
    self.Main.BtnConfirm:OnBtnClicked()
    self.Main.BtnConfirm:OnBtnReleased()
  elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    self.Right.Refresh.BtnArea.OnClicked:Broadcast()
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
    if self.Main.SharePanel:IsVisible() then
      self.Main.SharePanel:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Main.List_Tab:SetFocus()
    else
      self:Close()
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    self.Right.BtnChallenge:OnBtnClicked()
    self.Right.BtnChallenge:OnBtnReleased()
  end
  return Handle
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if UIUtils.IsGamepadInput() then
    self:InitGamepadView()
  else
    self:InitKeyboardView()
  end
  if self.Main.SharePanel:IsVisible() then
    self.Main.SharePanel:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:InitGamepadView()
  local Tab = self:GetTabWidget()
  if Tab then
    Tab:UpdateBottomKeyInfo_Quick({
      {
        UIConst.GamePadImgKey.FaceButtonRight,
        GText("UI_Tips_Close")
      }
    })
  end
  self.Main.SearchBuff.WS_Buff:SetActiveWidgetIndex(1)
  self.Main.SearchWeather.WS_Buff:SetActiveWidgetIndex(1)
  self.Main.Key_Share:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.Right.Refresh.WS_Type:SetActiveWidgetIndex(1)
  if self:HasFocusedDescendants() or self:HasAnyUserFocus() then
    self.Main.List_Tab:SetFocus()
  end
end

function M:InitKeyboardView()
  local Tab = self:GetTabWidget()
  if Tab then
    Tab:UpdateBottomKeyInfo({
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnClickReturn,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    })
  end
  self.Main.SearchBuff.WS_Buff:SetActiveWidgetIndex(0)
  self.Main.SearchWeather.WS_Buff:SetActiveWidgetIndex(0)
  self.Main.Key_Share:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Right.Refresh.WS_Type:SetActiveWidgetIndex(0)
end

return M
