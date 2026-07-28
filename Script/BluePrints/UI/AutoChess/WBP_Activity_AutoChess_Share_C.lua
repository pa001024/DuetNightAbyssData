require("UnLua")
local AutoChessShareModel = require("BluePrints.UI.AutoChess.AutoChessShareModel")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self:BindEvents()
  self:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Text_DyeCode:SetText(GText("UI_AutoChess_CodeDone"))
  self.Btn_ShareChat:SetNavigationRuleCustom(EUINavigation.Down, {
    self,
    function()
      local ActiveIdx = self.WidgetSwitcher_State:GetActiveWidgetIndex()
      if 0 == ActiveIdx then
        return self.Btn_ShareCommunity
      elseif 1 == ActiveIdx then
        return self.Btn_CopyCode
      end
    end
  })
  self.Btn_ShareChat:SetGamepadIconVisibility(false)
  self.Btn_ShareCommunity:SetGamepadIconVisibility(false)
  self.Btn_CopyCode:SetGamepadIconVisibility(false)
end

function M:BindEvents()
  if self.Btn_ShareCommunity then
    self.Btn_ShareCommunity:UnBindEventOnClickedByObj(self)
    self.Btn_ShareCommunity:BindEventOnClicked(self, self.OnShareCommunityClicked)
  end
  if self.Btn_CopyCode then
    self.Btn_CopyCode:UnBindEventOnClickedByObj(self)
    self.Btn_CopyCode:BindEventOnClicked(self, self.OnCopyCodeClicked)
  end
  if self.Btn_ShareChat then
    self.Btn_ShareChat:UnBindEventOnClickedByObj(self)
    self.Btn_ShareChat:BindEventOnClicked(self, self.OnShareChatClicked)
  end
end

function M:UnBindEvents()
  if self.Btn_ShareCommunity then
    self.Btn_ShareCommunity:UnBindEventOnClickedByObj(self)
  end
  if self.Btn_CopyCode then
    self.Btn_CopyCode:UnBindEventOnClickedByObj(self)
  end
  if self.Btn_ShareChat then
    self.Btn_ShareChat:UnBindEventOnClickedByObj(self)
  end
end

function M:OnMouseButtonUp(Mygeo, InFocusEvent)
  self.bClicked = false
  self.Owner.BtnShare:SetFocus()
  return UIUtils.Unhandled
end

function M:OnPreviewMouseButtonDown(Mygeo, InFocusEvent)
  self.bClicked = true
  return UIUtils.Unhandled
end

function M:Destruct()
  self:UnBindEvents()
end

function M:ShowPanel(SquadIdx)
  self.SquadIdx = SquadIdx
  self:RefreshShareCode()
  if self.WidgetSwitcher_State then
    self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
  end
  if self.Btn_ShareChat and self.Btn_ShareChat.SetText then
    self.Btn_ShareChat:SetText(GText("UI_AutoChess_CopyLink"))
  end
  if self.Btn_ShareCommunity and self.Btn_ShareCommunity.SetText then
    self.Btn_ShareCommunity:SetText(GText("UI_AutoChess_CopyCode"))
  end
  self:SetVisibility(UE4.ESlateVisibility.Visible)
  if UIUtils.IsGamepadInput() then
    self.Btn_ShareChat:SetFocus()
  end
end

function M:HidePanel()
  self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:RefreshShareCode(ShareCode)
  if self.Btn_CopyCode and self.Btn_CopyCode.SetText then
    self.Btn_CopyCode:SetText(ShareCode)
  end
end

function M:OnShareCommunityClicked()
  self:RequestShareCode()
  self.Owner.BtnShare:SetFocus()
end

function M:RequestShareCode()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  Avatar:AutoChessGetSharedCode(function(Ret, ShareCode)
    if not ErrorCode:Check(Ret) then
      self:HidePanel()
      return
    end
    if self.WidgetSwitcher_State then
      self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    end
    self:RefreshShareCode(ShareCode)
    if UIUtils.IsGamepadInput() then
      self.Btn_CopyCode:SetFocus()
    end
  end, self.SquadIdx)
  if UIUtils.IsGamepadInput() then
    self.Btn_ShareChat:SetFocus()
  end
end

function M:GetSquadDisplayName()
  return GText(string.format("UI_AutoChess_Lineup%s", self.SquadIdx or 1))
end

function M:OnCopyCodeClicked()
  local Code = self.Btn_CopyCode:GetText()
  if Code and "" ~= Code then
    ULowEntryExtendedStandardLibrary.ClipboardSet(Code)
    local TipText = string.format(GText("UI_AutoChess_CodeCopySuccess"), self:GetSquadDisplayName())
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, TipText)
  end
  self:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnShareChatClicked()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Squad = Avatar.AutoChess.SharedSquads and Avatar.AutoChess.SharedSquads[self.SquadIdx]
  if not Squad then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AutoChess_NoSquadData_Temp"))
    return
  end
  Avatar:AutoChessGetSharedCode(function(Ret, ShareCode)
    if not ErrorCode:Check(Ret) then
      self:HidePanel()
      return
    end
    if not ShareCode or "" == ShareCode then
      return
    end
    AutoChessShareModel.CacheAutoChessShareCode(ShareCode, self.SquadIdx, Squad.BattleCost)
    local TipText = string.format(GText("UI_AutoChess_LinkCopySuccess"), self:GetSquadDisplayName())
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, TipText)
  end, self.SquadIdx)
  self:HidePanel()
end

return M
