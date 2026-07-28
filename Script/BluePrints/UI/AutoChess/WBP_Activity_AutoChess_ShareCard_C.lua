require("UnLua")
local Model = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local ChatCommon = require("BluePrints.UI.WBP.Chat.ChatCommon")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local AutoChessDataModel = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.bClickable = false
  self.Button_Area.OnClicked:Add(self, self.OnBtnClick)
  self.Text_Avatar:SetText(GText("UI_AutoChess_ChallengeTitle"))
end

function M:InitAutoChessShare(ShareCodeStr, bSelfMsg, SenderName)
  self.ShareCodeStr = ShareCodeStr
  self.bSelfMsg = bSelfMsg
  self.ShareCode, self.SquadIdx, self.CostLimit = self:ParseShareCode(ShareCodeStr)
  self.SenderName = SenderName
  self.Text_Plan:SetText(string.format(GText("UI_AutoChess_ChallengeDes"), self.CostLimit))
end

function M:ParseShareCode(ShareCodeStr)
  local SquadIdx, CostLimit
  if not ShareCodeStr or "" == ShareCodeStr then
    return nil
  end
  if string.startswith(ShareCodeStr, ChatCommon.AutoChessShareHeader) then
    return string.sub(ShareCodeStr, #ChatCommon.AutoChessShareHeader + 1)
  end
  ShareCodeStr, SquadIdx, CostLimit = table.unpack(string.split(ShareCodeStr, "|"))
  return ShareCodeStr, SquadIdx, CostLimit
end

function M:OnBtnClick()
  if ActivityUtils.CheckEventIsExpired(AutoChessConst.ActiveId) then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_GameEvent_EventEnd"))
    return
  end
  if not AutoChessDataModel:IsAutoChessUnlock() then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Locked_Des_GameEvent"))
    return
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if GameState and GameState:IsInDungeon() then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_COMMONPOP_TITLE_100059"))
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/special_content_01_click", nil, nil)
  local ShareCode = self.ShareCode
  if not ShareCode or "" == ShareCode then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local AutoChessLevelConf = DataMgr.AutoChessMission[AutoChessConst.BattleMissionId]
  if not AutoChessLevelConf or not AutoChessLevelConf.DungeonId then
    DebugPrint("WBP_Activity_AutoChess_ShareCard: missing AutoChessMission 93001 config")
    return
  end
  local Params = {
    RightCallbackFunction = function()
      Avatar:EnterEventDungeon(nil, AutoChessLevelConf.DungeonId, 0, AutoChessConst.ActiveId, {
        ShareCode = ShareCode,
        MissionId = AutoChessConst.BattleMissionId,
        IsShareChallenge = true
      })
    end,
    ShortText = string.format(GText("UI_AutoChess_IfAccept"), self.SenderName)
  }
  UIManager():ShowCommonPopupUI(100406, Params, self)
end

return M
