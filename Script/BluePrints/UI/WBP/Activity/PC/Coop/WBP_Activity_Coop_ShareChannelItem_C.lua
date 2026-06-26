require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local TimerKeyPrefix = "CoopShareCooldownTimer"

function M:Initialize()
  self.CooldownTime = 60
  self.CurChannel = nil
  self.RoomUid = nil
  self.TimerKey = nil
  self.RemainingTimeSecs = nil
end

function M:Construct()
  self.BtnShare:BindEventOnClicked(self, self.OnClick)
  self.BtnShare:BindForbidStateExecuteEvent(self, self.HandleClickForbiddenButton)
  self.Cd_Node:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.TextCd:SetText(GText("UI_AsyncCombat_RoomCoolDown"))
  self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.WBP_Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    }
  })
  self.Bg.Button_Area.OnClicked:Add(self, self.HandleGamepadClick)
end

function M:EMDestruct()
  self.Super.EMDestruct(self)
  self.Bg.Button_Area.OnClicked:Remove(self, self.HandleGamepadClick)
end

function M:InitShareChannel(InChannel)
  self.CurChannel = InChannel
  self:InitTimerKey()
  self:CheckTimer()
end

function M:InitTimerKey()
  self.TimerKey = TimerKeyPrefix .. tostring(self.CurChannel)
end

function M:CheckTimer()
  if not self.TimerKey then
    DebugPrint("lxc: WBP_Activity_Coop_ShareChannelItem_C:CheckTimer: no self.TimerKey")
    return
  end
  local GameInstance = GWorld.GameInstance
  GameInstance.CoopShareTimers = GameInstance.CoopShareTimers or {}
  local TimerInfo = GameInstance.CoopShareTimers[self.TimerKey]
  local NowMs = TimeUtils.NowTimeMs()
  if TimerInfo and TimerInfo.EndTime and NowMs <= TimerInfo.EndTime then
    self.BtnShare:ForbidBtn(true)
    self:ResetTimer(TimerInfo.EndTime)
  else
    GameInstance.CoopShareTimers[self.TimerKey] = nil
  end
end

function M:OnClick()
  if self.BtnShare:IsBtnForbidden() then
    self:HandleClickForbiddenButton()
    return
  end
  self:ShareWithChannel()
  self.BtnShare:ForbidBtn(true)
  local NowMs = TimeUtils.NowTimeMs()
  local EndMs = NowMs + self.CooldownTime * 1000
  self:ResetTimer(EndMs)
  self:ResetTimerInfo()
end

function M:ResetTimerInfo()
  if not GWorld.GameInstance then
    DebugPrint("lxc: WBP_Activity_Coop_ShareChannelItem_C:ResetTimerInfo GameInstance为nil")
    return
  end
  if not self.TimerKey then
    DebugPrint("lxc: WBP_Activity_Coop_ShareChannelItem_C:ResetTimerInfo TimerKey为nil, 频道: " .. tostring(self.CurChannel))
    return
  end
  local NowMs = TimeUtils.NowTimeMs()
  local EndMs = NowMs + self.CooldownTime * 1000
  local GameInstance = GWorld.GameInstance
  GameInstance.CoopShareTimers = GameInstance.CoopShareTimers or {}
  DebugPrint(string.format("lxc: WBP_Activity_Coop_ShareChannelItem_C:ResetTimerInfo 定时器: %s, 原到期时间: %s, 新到期时间: %s", self.TimerKey, tostring(GameInstance.CoopShareTimers[self.TimerKey] and GameInstance.CoopShareTimers[self.TimerKey].EndTime), tostring(EndMs)))
  local TimerInfo = GameInstance.CoopShareTimers[self.TimerKey]
  if TimerInfo then
    GameInstance.CoopShareTimers[self.TimerKey].EndTime = EndMs
  else
    GameInstance.CoopShareTimers[self.TimerKey] = {EndTime = EndMs}
  end
end

function M:ResetTimer(EndTimeMs)
  local NowMs = TimeUtils.NowTimeMs()
  if not EndTimeMs or EndTimeMs <= NowMs then
    return
  end
  local RemainingTimeSecs = math.floor((EndTimeMs - NowMs) / 1000 + 0.5)
  self:UpdateCountDownShow(RemainingTimeSecs)
  if RemainingTimeSecs <= 0 then
    self.BtnShare:ForbidBtn(false)
    return
  end
  self.RemainingTimeSecs = RemainingTimeSecs
  self:AddTimer(1, self.UpdateCooldown, true, 0, self.TimerKey)
end

function M:UpdateCountDownShow(RemainingTimeSecs)
  if not RemainingTimeSecs or RemainingTimeSecs <= 0 then
    self.Cd_Node:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Cd_Node:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    local TimeStr = self:GetTimeStr(RemainingTimeSecs)
    self.TextTime:SetText("(" .. TimeStr .. ")")
  end
end

function M:HandleClickForbiddenButton()
  UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_AsyncCombat_OperationCoolDown")
end

function M:UpdateCooldown()
  self.RemainingTimeSecs = self.RemainingTimeSecs - 1
  self:UpdateCountDownShow(self.RemainingTimeSecs)
  if self.RemainingTimeSecs <= 0 then
    self:CleanTimer()
    self.BtnShare:ForbidBtn(false)
    self.RemainingTimeSecs = nil
    GWorld.GameInstance.CoopShareTimers[self.TimerKey] = nil
  end
end

function M:ShareWithChannel()
  local RoomData = self.Owner:GetCurrentAsyncCombatRoomInfo()
  local MsgText = ChatCommon.AsyncCombatRoomCopyHeader .. Json.encode(RoomData)
  
  local function Func(Obj, Ret, ChannelType, RoomUid)
    DebugPrint("clx: WBP_Activity_Coop_ShareChannelItem_C:ShareWithChannel " .. "Ret: " .. Ret .. "ChannelType: " .. ChannelType .. "RoomUid: " .. RoomUid)
    if ErrorCode:Check(Ret) then
      UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_AsyncCombat_Sharesuccessful")
      self.Owner.bShareClick = true
      if ChannelType == ChatCommon.ChannelDef.InGuild then
        return
      end
      ChatController:RecvChatToWorld(ChannelType, MsgText)
    end
  end
  
  local CallbackInfo = {Obj = nil, Func = Func}
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  Avatar:SendAsyncCombatRoomToWorld(CallbackInfo, self.CurChannel, self.RoomUid)
end

function M:HandleGamepadClick()
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  self:OnClick()
end

function M:OnRemovedFromFocusPath()
  self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnAddedToFocusPath()
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

AssembleComponents(M)
return M
