require("UnLua")
local AutoChessShareModel = require("BluePrints.UI.AutoChess.AutoChessShareModel")
local AutoChessConst = require("BluePrints.UI.AutoChess.AutoChessConst")
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self:BindEvents()
end

function M:BindEvents()
  if self.Refresh and self.Refresh.BtnArea then
    self.Refresh.BtnArea.OnClicked:Clear()
    self.Refresh.BtnArea.OnClicked:Add(self, self.OnRefreshClicked)
  end
  if self.BtnChallenge and self.BtnChallenge.BindEventOnClicked then
    self.BtnChallenge:UnBindEventOnClickedByObj(self)
    self.BtnChallenge:BindEventOnClicked(self, self.OnChallengeClicked)
    self.BtnChallenge:TryOverrideSoundFunc(function()
      AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_click_confirm", nil, nil)
    end)
  end
end

function M:UnBindEvents()
  if self.Refresh and self.Refresh.BtnArea then
    self.Refresh.BtnArea.OnClicked:Remove(self, self.OnRefreshClicked)
  end
  if self.BtnChallenge and self.BtnChallenge.UnBindEventOnClickedByObj then
    self.BtnChallenge:UnBindEventOnClickedByObj(self)
  end
end

function M:Destruct()
  self:UnBindEvents()
end

function M:InitContent()
  self:RefreshContent()
end

function M:RefreshContent()
  local Avatar = GWorld:GetAvatar()
  local TotalWinCount = 0
  if Avatar and Avatar.AutoChess then
    TotalWinCount = Avatar.AutoChess.SharedSquadTotalWinCount or 0
  end
  if self.TextTitle then
    self.TextTitle:SetText(GText("UI_AutoChess_TotalWins"))
  end
  if self.TextWinNum then
    self.TextWinNum:SetText(tostring(TotalWinCount))
  end
  self:RefreshChallengeButtonState()
end

function M:RefreshChallengeButtonState()
  if not self.BtnChallenge then
    return
  end
  local bHasMonster = false
  local OwnerPanel = self.Owner
  local Avatar = GWorld:GetAvatar()
  if OwnerPanel and Avatar and Avatar.AutoChess and Avatar.AutoChess.SharedSquads then
    local SquadIdx = OwnerPanel.SelectedSquadIdx
    local Squad = Avatar.AutoChess.SharedSquads[SquadIdx]
    if Squad and Squad.Squad then
      for _, CombatChessId in pairs(Squad.Squad) do
        if CombatChessId and 0 ~= CombatChessId then
          bHasMonster = true
          break
        end
      end
    end
  end
  if bHasMonster then
    self.BtnChallenge:SetText(GText("UI_AutoChess_InitiateChallenge"))
    self.BtnChallenge:ForbidBtn(false)
  else
    self.BtnChallenge:SetText(GText("UI_AutoChess_CreatePlease"))
    self.BtnChallenge:ForbidBtn(true)
  end
end

function M:OnRefreshClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_click_confirm", nil, nil)
  local Params = {
    UseGenaral = true,
    MultilineType = 1,
    TextLenMax = 50,
    HintText = GText("UI_AutoChess_ClickImport"),
    ExtraCheckFunc = function(bIsRightBtn, InputWidget, Text)
      local ShareCode = string.gsub(Text or "", "^%s*(.-)%s*$", "%1")
      if not ShareCode or "" == ShareCode then
        if InputWidget and InputWidget.Owner then
          InputWidget.Owner:OnClose()
        end
        return false
      end
      if InputWidget and InputWidget.Owner then
        InputWidget.Owner:OnClose()
      end
      local Avatar = GWorld:GetAvatar()
      if not Avatar then
        return false
      end
      local AutoChessLevelConf = DataMgr.AutoChessMission[AutoChessConst.BattleMissionId]
      if not AutoChessLevelConf or not AutoChessLevelConf.DungeonId then
        DebugPrint("WBP_Activity_AutoChess_RankWins: missing AutoChessMission " .. tostring(AutoChessConst.BattleMissionId) .. " config")
        return false
      end
      Avatar:EnterEventDungeon(function(Ret)
        if Ret ~= ErrorCode.RET_SUCCESS then
          UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_AutoChess_CodeFailToast"))
        end
      end, AutoChessLevelConf.DungeonId, 0, AutoChessConst.ActiveId, {
        ShareCode = ShareCode,
        MissionId = AutoChessConst.BattleMissionId,
        IsShareChallenge = true
      })
      return false
    end
  }
  UIManager(self):ShowCommonPopupUI(100405, Params, self)
end

function M:OnImportSquadResponse(Squad)
  if not Squad then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AutoChess_ImportFailed"))
    return
  end
  local OwnerPanel = self.Owner
  if not OwnerPanel then
    return
  end
  local TargetIdx = OwnerPanel.SelectedSquadIdx
  local Avatar = GWorld:GetAvatar()
  if not (Avatar and Avatar.AutoChess) or not Avatar.AutoChess.SharedSquads then
    return
  end
  Avatar.AutoChess.SharedSquads[TargetIdx] = Squad
  Avatar:AutoChessSetSharedSquad(function()
    OwnerPanel:RefreshAll()
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AutoChess_ImportSuccess"))
  end, TargetIdx, Squad.Squad, Squad.Buffs, Squad.Equips)
end

function M:OnChallengeClicked()
  local OwnerPanel = self.Owner
  if not OwnerPanel then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not (Avatar and Avatar.AutoChess) or not Avatar.AutoChess.SharedSquads then
    return
  end
  local SquadIdx = OwnerPanel.SelectedSquadIdx
  local Squad = Avatar.AutoChess.SharedSquads[SquadIdx]
  local Cost = Squad.Cost
  local CostLimit = Squad.BattleCost
  if not Squad or not Squad.Squad then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AutoChess_NoSquadData_Temp"))
    return
  end
  local bHasMonster = false
  for _, CombatChessId in pairs(Squad.Squad) do
    if CombatChessId and 0 ~= CombatChessId then
      bHasMonster = true
      break
    end
  end
  if not bHasMonster then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AutoChess_NoMonsterToast"))
    return
  end
  
  local function OpenChatWithShareCode(ShareCode)
    if not ShareCode or "" == ShareCode then
      DebugPrint("WBP_Activity_AutoChess_RankWins: empty share code")
      return
    end
    local CachedInfo = AutoChessShareModel.CacheAutoChessShareCode(ShareCode, SquadIdx, CostLimit)
    if not CachedInfo or not CachedInfo.MsgCopyed then
      return
    end
    local SquadDisplayName = GText(string.format("UI_AutoChess_Lineup%s", SquadIdx))
    local TipText = string.format(GText("UI_AutoChess_LinkCopySuccess"), SquadDisplayName)
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, TipText)
    local ChatMain = ChatController:OpenView(self, false)
    if ChatMain and ChatMain.Com_Input then
      ChatMain.Com_Input:SetText(CachedInfo.MsgCopyed)
      ChatMain.Com_Input:FocusInputField()
      ChatMain.Btn_Sent:SetNormal()
    end
  end
  
  local ShareCode = Squad.ShareCode
  if ShareCode and "" ~= ShareCode then
    OpenChatWithShareCode(ShareCode)
  else
    Avatar:AutoChessGetSharedCode(function(Ret, NewShareCode)
      OpenChatWithShareCode(NewShareCode)
    end, SquadIdx)
  end
end

return M
