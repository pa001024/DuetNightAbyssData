require("UnLua")
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local ChatCommon = require("BluePrints.UI.WBP.Chat.ChatCommon")
local ChatModel = ChatController:GetModel()
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  if UIUtils.IsGamepadInput() and self.Key_ChangeChannel then
    self.Key_ChangeChannel:CreateGamepadKey(UIConst.GamePadImgKey.SpecialRight)
  end
  self:InitChatChannelUI()
end

function M:InitChatChannelUI()
  self.CurChannel = ChatModel:GetChannelIndex(ChatModel:GetCurrentChannel())
  if ChatModel:IsInRegionOnline() then
    self:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Text_ChatChannel:SetText(string.format(GText(DataMgr.RegionOnline[ChatModel:GetRegionId()].RegionChannelName) .. "(%d)", self.CurChannel))
    ChatController:SendQueryChatChannelBusyInfo()
    local Avatar = GWorld:GetAvatar()
    Avatar:QueryAllRegionOnlineChannelState(ChatModel:GetRegionId())
  else
    self:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Btn_ChangeChannel:BindEventOnPressed(self, self.BtnChangeChannelOnPressed)
  self.Button_ChangeChannel.OnClicked:Clear()
  self.Button_ChangeChannel.OnClicked:Add(self, self.BtnChangeChannelOnPressed)
  self.Text_ChannelSign01:SetText(GText("Process"))
  self.Text_ChannelSign02:SetText(GText("Busy"))
  self.Text_ChannelSign03:SetText(GText("Full"))
  ChatController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == ChatCommon.EventID.RecvChannelPlayerNum then
      local Channel_type, Channel_list = ...
      self:HandleChannelPlayerNum(Channel_type, Channel_list)
    end
  end)
  ChatController:StartQueryChatChannelBusyInfo()
  if self.Key_Channel then
    self.Key_Channel:CreateGamepadKey(UIConst.GamePadImgKey.SpecialRight)
  end
end

function M:HandleChannelPlayerNum(Channel_type, Channel_list)
  if Channel_list[self.CurChannel] then
    local Type = Channel_list[self.CurChannel]
    if 1 == Type then
      self.WS_ChannelSign:SetActiveWidgetIndex(0)
    elseif 2 == Type then
      self.WS_ChannelSign:SetActiveWidgetIndex(1)
    else
      self.WS_ChannelSign:SetActiveWidgetIndex(2)
    end
  end
end

function M:BtnChangeChannelOnPressed()
  ChatController:OpenChatChannelUI(self, ChatCommon.ChannelDef.Region)
end

function M:Destruct()
  ChatController:UnRegisterEvent(self)
end

return M
