require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self.Owner = (...)
  self.IsPvPMode = self.Owner:IsPvPMode()
  if self.IsPvPMode then
    self.WS_State:SetActiveWidgetIndex(0)
    self.TextName:SetText(self.Owner.ShareOwnerName or "")
  else
    self.WS_State:SetActiveWidgetIndex(1)
    self.Text_Edit:SetText(GText("UI_AutoChess_EditMode"))
  end
  self.Text:SetText(GText("UI_AutoChess_BattleShareTitle"))
  self:HideAllUIWithOutSelf(true, "AutoChessMatchStatus")
  self:BindToAnimationFinished(self.In, {
    self,
    self.OnInAnimFinished
  })
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_game_start_edit_team", nil, nil)
end

function M:OnInAnimFinished()
  self:HideAllUIWithOutSelf(false, "AutoChessMatchStatus")
  local BattlePage = self.Owner and self.Owner.InGameUI
  self:Close()
  if BattlePage and BattlePage.OnMatchStatusClosed then
    BattlePage:AddTimer(0.1, function()
      if IsValid(BattlePage) then
        BattlePage:OnMatchStatusClosed()
      end
    end, false, 0, "WBP_AutoChessBattlePage_OnMatchStatusClosed", true)
  end
end

return M
