require("UnLua")
local UIUtils = require("Utils.UIUtils")
local Model = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local SQUAD_TAB_NAMES = {
  "UI_AutoChess_Lineup1",
  "UI_AutoChess_Lineup2",
  "UI_AutoChess_Lineup3"
}

function M:Construct()
  self.SharePanel = self.WBP_Activity_AutoChess_Share
  self.SharePanel:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.SharePanel.Owner = self
  self.ListMonster:DisableScroll(true)
  self.List_Tab:DisableScroll(true)
  if self.SearchBuff then
    self.SearchBuff.Owner = self
  end
  if self.SearchWeather then
    self.SearchWeather.Owner = self
  end
  self:BindEvents()
  self.TextTips02:SetText(GText("UI_AutoChess_WinRate"))
  self.TextTips01:SetText(GText("UI_AutoChess_SuccessfulDefense"))
  self.TextEmpty:SetText(GText("UI_AutoChess_NoRecord"))
  self.TextCost:SetText(GText("UI_AutoChess_Cost"))
end

function M:InitContent(SquadIdx)
  self.SelectedSquadIdx = SquadIdx or 1
  self:RefreshTabList()
  self:RefreshAll(self.SelectedSquadIdx)
end

function M:BindEvents()
  if self.BtnConfirm then
    self.BtnConfirm:UnBindEventOnClickedByObj(self)
    self.BtnConfirm:BindEventOnClicked(self, self.OnBtnConfirmClicked)
  end
  if self.BtnShare then
    self.BtnShare:BindEventOnClicked(self, self.OnBtnShareClicked)
    self.BtnShare:BindEventOnRemovedFromFocusPath(self, function()
      if not self.SharePanel.bClicked and self.SharePanel:IsVisible() then
        self.SharePanel:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
      self.SharePanel.bClicked = false
    end)
    self.SharePanel.OnVisibilityChanged:Add(self, function(self, Visibility)
      if not self.SharePanel:IsVisible() and UIUtils.IsGamepadInput() then
        self.List_Tab:SetFocus()
      end
    end)
  end
end

function M:UnBindEvents()
  if self.BtnConfirm then
    self.BtnConfirm:UnBindEventOnClickedByObj(self)
  end
  if self.BtnShare then
    self.BtnShare:UnBindEventOnClickedByObj(self)
    self.BtnShare:BindEventOnRemovedFromFocusPath(nil, nil)
  end
end

function M:Destruct()
  self:UnBindEvents()
end

function M:RefreshAll(SquadIdx)
  SquadIdx = SquadIdx or self.SelectedSquadIdx or 1
  self.SelectedSquadIdx = SquadIdx
  Model:SetEditingSquadIndex(SquadIdx)
  self:RefreshMonsterList()
  self:RefreshCost()
  self:RefreshWinState()
  self:RefreshButtons()
  self:RefreshBuffs()
end

function M:RefreshBuffs()
  local Squad = self:GetCurrentSquad()
  local Buffs = Squad and Squad.Buffs or {}
  local ChallengeBuffs = {}
  local WeatherBuffs = {}
  for _, BuffId in ipairs(Buffs) do
    local BuffData = DataMgr.ChallengeBuff[BuffId]
    if Model:IsWeatherBuff(BuffId) then
      table.insert(WeatherBuffs, BuffId)
    else
      table.insert(ChallengeBuffs, BuffId)
    end
  end
  if self.SearchBuff and self.SearchBuff.Refresh then
    self.SearchBuff:SetSquadIdx(self.SelectedSquadIdx)
    local SizeBoxSizeX = self.SearchBuff:GetParent().WidthOverride
    self.SearchBuff:Refresh(ChallengeBuffs, SizeBoxSizeX)
  end
  if self.SearchWeather and self.SearchWeather.Refresh then
    self.SearchWeather:SetSquadIdx(self.SelectedSquadIdx)
    self.SearchWeather:Refresh(WeatherBuffs)
  end
  self:RefreshWinState()
end

function M:GetSharedSquad(SquadIdx)
  local Avatar = GWorld:GetAvatar()
  if not (Avatar and Avatar.AutoChess) or not Avatar.AutoChess.SharedSquads then
    return nil
  end
  return Avatar.AutoChess.SharedSquads[SquadIdx]
end

function M:GetCurrentSquad()
  return self:GetSharedSquad(self.SelectedSquadIdx)
end

function M:RefreshTabList()
  if not self.List_Tab then
    return
  end
  self.List_Tab:ClearListItems()
  for Idx = 1, 3 do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.TabName = GText(SQUAD_TAB_NAMES[Idx] or "UI_AutoChess_Lineup" .. tostring(Idx))
    Content.SquadIdx = Idx
    Content.IsSelected = Idx == self.SelectedSquadIdx
    Content.Parent = self
    self.List_Tab:AddItem(Content)
  end
end

function M:OnTabItemClicked(Item)
  if not Item or not Item.SquadIdx then
    return
  end
  if Item.SquadIdx == self.SelectedSquadIdx then
    return
  end
  local LastContent = self.List_Tab:GetItemAt(self.SelectedSquadIdx - 1)
  if LastContent and IsValid(LastContent.UI) then
    LastContent.UI:RefreshSelect(false)
  end
  self.SelectedSquadIdx = Item.SquadIdx
  if self.Owner and self.Owner.OnSquadTabChanged then
    self.Owner:OnSquadTabChanged(self.SelectedSquadIdx)
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small_crystal", nil, nil)
end

function M:RefreshMonsterList()
  if not self.ListMonster then
    return
  end
  self.ListMonster:ClearListItems()
  local Squad = self:GetCurrentSquad()
  local SquadData = Squad and Squad.Squad
  for ChessIndex = 1, CommonConst.AutoChess.MaxChessNum do
    local Item = NewObject(UIUtils.GetCommonItemContentClass())
    local DataIndex = ChessIndex
    local CombatChessId = SquadData and SquadData[DataIndex]
    if CombatChessId then
      Item.CombatChessId = CombatChessId
      Item.IsEmpty = false
    else
      Item.IsEmpty = true
    end
    Item.ChessIndex = ChessIndex
    self.ListMonster:AddItem(Item)
  end
end

function M:RefreshCost()
  local Squad = self:GetCurrentSquad()
  local SquadData = Squad and Squad.Squad
  local Num = Squad.Cost
  local CostLimit = Squad.BattleCost
  if self.TextNumNow then
    self.TextNumNow:SetText(tostring(Num))
  end
  if self.TextNumTotal then
    self.TextNumTotal:SetText("/" .. tostring(CostLimit))
  end
end

function M:RefreshWinState()
  local Squad = self:GetCurrentSquad()
  local ChallengeCount = Squad and Squad.ChallengeCount or 0
  local WinCount = Squad and Squad.WinCount or 0
  if 0 == ChallengeCount then
    self.Ws_WinState:SetActiveWidgetIndex(1)
    return
  else
    self.Ws_WinState:SetActiveWidgetIndex(0)
  end
  self.TextWinNow:SetText(tostring(WinCount))
  self.TextWinTotal:SetText(string.format("/%s", ChallengeCount))
  local Rate = ChallengeCount > 0 and math.floor(WinCount * 100 / ChallengeCount) or 0
  if self.TextTips02Num then
    self.TextTips02Num:SetText(tostring(Rate) .. "%")
  end
end

function M:RefreshButtons()
  if self.BtnConfirm and self.BtnConfirm.Text_Button then
    self.BtnConfirm.Text_Button:SetText(GText("UI_AutoChess_EditBattle"))
  end
  if self.BtnShare then
  end
end

function M:OnBtnConfirmClicked()
  local Squad = self:GetCurrentSquad()
  if not Squad then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AutoChess_NoSquadData_Temp"))
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local AutoChessLevelConf = DataMgr.AutoChessMission[AutoChessConst.EditorMissionId]
  Avatar:EnterEventDungeon(nil, AutoChessLevelConf.DungeonId, 0, AutoChessConst.ActiveId, {
    MissionId = AutoChessConst.EditorMissionId,
    IsShareChallenge = false
  })
end

function M:OnBtnShareClicked()
  if self.SharePanel and not self.SharePanel:IsVisible() then
    self.SharePanel:SetVisibility(UE4.ESlateVisibility.Visible)
    if self.SharePanel then
      self.SharePanel.Owner = self
    end
    self.SharePanel:ShowPanel(self.SelectedSquadIdx)
  end
end

return M
