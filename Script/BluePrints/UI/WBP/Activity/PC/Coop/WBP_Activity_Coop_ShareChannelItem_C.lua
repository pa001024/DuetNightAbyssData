require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")

function M:Initialize()
  self.CooldownTime = 5
  self.CurChannel = nil
  self.RoomUid = nil
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
end

function M:OnClick()
  if self.BtnShare:IsBtnForbidden() then
    self:HandleClickForbiddenButton()
    return
  end
  self:ShareWithChannel()
  self.BtnShare:ForbidBtn(true)
  self.Cd_Node:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  local TimeStr = self:GetTimeStr(self.CooldownTime)
  self.TextTime:SetText("(" .. TimeStr .. ")")
  self:AddTimer(1, self.UpdateCooldown, true, 0, "CoopShareCooldownTimer")
end

function M:HandleClickForbiddenButton()
  UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_AsyncCombat_OperationCoolDown")
end

function M:UpdateCooldown()
  self.CooldownTime = self.CooldownTime - 1
  local TimeStr = self:GetTimeStr(self.CooldownTime)
  self.TextTime:SetText("(" .. TimeStr .. ")")
  if self.CooldownTime <= 0 then
    self:CleanTimer()
    self.BtnShare:ForbidBtn(false)
    self.Cd_Node:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.CooldownTime = 5
  end
end

function M:ShareWithChannel()
  local RoomData = self.Owner:GetCurrentAsyncCombatRoomInfo()
  local MsgText = ChatCommon.AsyncCombatRoomCopyHeader .. Json.encode(RoomData)
  
  local function Func(Obj, Ret, ChannelType, RoomUid)
    DebugPrint("clx: WBP_Activity_Coop_ShareChannelItem_C:ShareWithChannel " .. "Ret: " .. Ret .. "ChannelType: " .. ChannelType .. "RoomUid: " .. RoomUid)
    if ErrorCode:Check(Ret) then
      ChatController:RecvChatToWorld(ChannelType, MsgText)
      UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_AsyncCombat_Sharesuccessful")
    end
  end
  
  local CallbackInfo = {Obj = nil, Func = Func}
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if self.CurChannel == ChatCommon.ChannelDef.TeamUp then
    Avatar:SendAsyncCombatRoomToWorld(CallbackInfo, self.CurChannel, self.RoomUid)
    self.Owner.bShareToOpen = true
  elseif self.CurChannel == ChatCommon.ChannelDef.Public then
    Avatar:SendAsyncCombatRoomToWorld(CallbackInfo, self.CurChannel, self.RoomUid)
    self.Owner.bShareToOpen = true
  elseif self.CurChannel == ChatCommon.ChannelDef.Region then
    Avatar:SendAsyncCombatRoomToWorld(CallbackInfo, self.CurChannel, self.RoomUid)
    self.Owner.bShareToOpen = true
  elseif self.CurChannel == ChatCommon.ChannelDef.InGuild then
    Avatar:SendAsyncCombatRoomToWorld(CallbackInfo, self.CurChannel, self.RoomUid)
    self.bShareToGuild = true
  end
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
