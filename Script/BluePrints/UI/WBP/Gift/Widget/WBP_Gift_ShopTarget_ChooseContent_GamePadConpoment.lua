require("UnLua")
local M = {}

function M:InitContent(Content)
end

function M:InitKeyboardView()
  self.IsGamePad = false
  self.Key_Qa:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:InitGamepadView()
  self.IsGamePad = true
  if not self.InitGamePad then
    self:FirstInitGamepadView()
  end
  self.Key_Qa:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self:InitOriginFocus()
end

function M:FirstInitGamepadView()
  self.Key_Qa:CreateGamepadKey("Menu")
  self.CheckItemBtnIdx = self.Owner:InitGamepadShortcut({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    },
    Desc = GText("UI_Controller_CheckDetails")
  }, 3)
  local hasFriends = false
  local ListView = self.List_FriendContent
  if ListView and ListView.GetNumItems then
    hasFriends = (ListView:GetNumItems() or 0) > 0
  end
  if hasFriends then
    self.CheckPlayerBtnIdx = self.Owner:InitGamepadShortcut({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "View"}
      },
      Desc = GText("UI_Controller_CheckPlayer")
    }, 2)
    self.ConfirmBtnIdx = self.Owner:InitGamepadShortcut({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("UI_CTL_Select")
    }, 4)
  else
    self.CheckPlayerBtnIdx = nil
    self.ConfirmBtnIdx = nil
  end
end

function M:InitOriginFocus()
  if self.IsInSelectMode then
    self:ExitSelectItemMode()
    return
  end
  local ListView = self.List_FriendContent
  if ListView and ListView:GetNumItems() > 0 then
    ListView:SetSelectedIndex(0)
    ListView:NavigateToIndex(0)
  else
    self.Owner:SetFocus()
  end
end

function M:OnGamePadDown(KeyName)
  if KeyName == UIConst.GamePadKey.SpecialRight then
    local qa = self.Com_Qa
    if qa then
      if qa.Btn_Click and qa.Btn_Click.SetChecked then
        qa.Btn_Click:SetChecked(true)
      end
      if qa.OpenMenuAnchor then
        qa:OpenMenuAnchor()
      end
      return true
    end
    return false
  elseif KeyName == UIConst.GamePadKey.LeftThumb then
    self:EnterSelectItemMode()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif KeyName == UIConst.GamePadKey.FaceButtonRight then
    if self.List_Item:HasAnyUserFocus() or self.List_Item:HasFocusedDescendants() then
      self:ExitSelectItemMode()
      return true
    end
    local qa = self.Com_Qa
    if qa and qa.IsMenuAnchorOpen and qa:IsMenuAnchorOpen() then
      if qa.Btn_Click and qa.Btn_Click.SetChecked then
        qa.Btn_Click:SetChecked(false)
      end
      if qa.CloseMenuAnchor then
        qa:CloseMenuAnchor()
      end
      self:InitOriginFocus()
      return true
    end
    return false
  end
  return false
end

function M:FocusRewardItem()
  local ListView = self.List_Item
  if ListView and ListView:GetNumItems() > 0 then
    ListView:SetSelectedIndex(0)
    ListView:SetFocus()
  else
    self.Owner:SetFocus()
  end
end

function M:EnterSelectItemMode()
  self.IsInSelectMode = true
  self:FocusRewardItem()
  if self.Owner and self.ConfirmBtnIdx then
    local ConfirmKey = self.Owner:GetGamepadShortcutByIndex(self.ConfirmBtnIdx)
    if ConfirmKey and ConfirmKey.SetDescription then
      ConfirmKey:SetDescription(GText("UI_Controller_CheckDetails"))
    end
  end
  if self.Owner and self.CheckPlayerBtnIdx then
    self.Owner:HideGamepadShortcut(self.CheckPlayerBtnIdx)
  end
  if self.Owner and self.CheckItemBtnIdx then
    self.Owner:HideGamepadShortcut(self.CheckItemBtnIdx)
  end
end

function M:ExitSelectItemMode()
  self.IsInSelectMode = false
  self:InitOriginFocus()
  if self.Owner and self.ConfirmBtnIdx then
    local ConfirmKey = self.Owner:GetGamepadShortcutByIndex(self.ConfirmBtnIdx)
    if ConfirmKey and ConfirmKey.SetDescription then
      ConfirmKey:SetDescription(GText("UI_CTL_Select"))
    end
  end
  if self.Owner and self.CheckPlayerBtnIdx then
    self.Owner:ShowGamepadShortcut(self.CheckPlayerBtnIdx)
  end
  if self.Owner and self.CheckItemBtnIdx then
    self.Owner:ShowGamepadShortcut(self.CheckItemBtnIdx)
  end
end

function M:OnContentFocusReceived(MyGeometry, InFocusEvent)
  DebugPrint("弹窗收到聚焦，恢复默认聚焦 OnContentFocusReceived")
  self:AddTimer(0.1, function()
    self:InitOriginFocus()
  end)
end

return M
