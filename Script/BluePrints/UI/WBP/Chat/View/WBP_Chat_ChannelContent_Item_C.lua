require("UnLua")
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local ChatModel = ChatController:GetModel()
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.DelayFrameComponent"
})

function M:Construct()
  self.Com_List03:BindEventOnClicked(self, self.OnClickCellItem)
  self.Com_List03:SetAutoSelectWhenHoverInGamePadMod(true)
  self.Com_List03:SetCanCancelSelection(true)
  EventManager:AddEvent(EventID.OnChannelIndexSelect, self, self.OnOtherCellItemClick)
  EventManager:AddEvent(EventID.OnSelectChannelSuccess, self, self.OnSelectChannelSuccess)
  EventManager:AddEvent(EventID.OnChatUpdateInput, self, self.OnChatUpdateInput)
end

function M:Destruct()
  EventManager:RemoveEvent(EventID.OnChatUpdateInput, self)
  EventManager:RemoveEvent(EventID.OnChannelIndexSelect, self)
  EventManager:RemoveEvent(EventID.OnSelectChannelSuccess, self)
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Content.SelfWidget = self
  self.ChannelIndex = Content.ChannelIndex
  self.State = Content.State
  self.IsEmpty = Content.IsEmpty
  self:InitUI()
end

function M:OnSelectChannelSuccess(ChannelType, SelectIndex)
  if SelectIndex ~= self.ChannelIndex then
    self:PlayAnimation(self.Normal)
    self.WS_Sign:SetActiveWidgetIndex(1)
  else
    self:PlayAnimation(self.Forbidden)
    self.Com_List03:OnCellUnSelect()
    self.WS_Sign:SetActiveWidgetIndex(0)
  end
end

function M:OnOtherCellItemClick(SelectIndex)
  local CurChannelIndex = ChatModel:GetChannelIndex(ChatModel:GetCurrentChannel())
  if CurChannelIndex ~= self.ChannelIndex and SelectIndex ~= self.ChannelIndex then
    self.Com_List03:OnCellUnSelect()
    self:PlayAnimation(self.Normal)
  end
end

function M:OnClickCellItem()
  local CurIndex
  if self.ChannelIndex == ChatModel:GetChannelIndex(ChatModel:GetCurrentChannel()) then
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("AlreadyInChannel"))
    self.Com_List03:OnCellUnSelect()
    CurIndex = self.ChannelIndex
    ChatModel:SetSelectChannelIndex(self.ChannelIndex)
  elseif not self.Com_List03.IsSelect then
    self:PlayAnimation(self.Normal)
    ChatModel:SetSelectChannelIndex()
  else
    ChatModel:SetSelectChannelIndex(self.ChannelIndex)
    self:PlayAnimation(self.Select)
    CurIndex = self.ChannelIndex
  end
  EventManager:FireEvent(EventID.OnChannelIndexSelect, CurIndex)
end

function M:InitUI()
  self.WS_Item:SetActiveWidgetIndex(self.IsEmpty and 1 or 0)
  if self.IsEmpty then
    EventManager:RemoveEvent(EventID.OnChatUpdateInput, self)
    return
  end
  self.Text_ChannelSign01:SetText(GText("Process"))
  self.Text_ChannelSign02:SetText(GText("Busy"))
  self.Text_ChannelSign03:SetText(GText("Full"))
  if ChatModel:IsInRegionOnlineChannelType() then
    self.Text_ChatChannel:SetText(string.format(GText(DataMgr.RegionOnline[ChatModel:GetRegionId()].RegionChannelName) .. "(%d)", self.ChannelIndex))
  else
    self.Text_ChatChannel:SetText(string.format(GText("WorldChannelWithParam"), self.ChannelIndex))
  end
  self.Text_Now:SetText(GText("Current"))
  local CurChannelIndex = ChatModel:GetChannelIndex(ChatModel:GetCurrentChannel())
  if CurChannelIndex == self.ChannelIndex then
    self:PlayAnimation(self.Forbidden, self.Forbidden:GetEndTime())
    self.WS_Sign:SetActiveWidgetIndex(0)
  else
    self.WS_Sign:SetActiveWidgetIndex(1)
    if ChatModel:GetSelectChannelIndex() and ChatModel:GetSelectChannelIndex() == self.ChannelIndex then
      if UIUtils.IsGamepadInput() then
        self.Com_List03:OnCellUnhovered()
      else
        self.Com_List03:SelectCell()
      end
      self:PlayAnimation(self.Select)
    else
      self:PlayAnimation(self.Normal)
      self.Com_List03:OnCellUnSelect()
    end
  end
  local Type = self.State
  if 1 == Type then
    self.WS_ChannelSign:SetActiveWidgetIndex(0)
  elseif 2 == Type then
    self.WS_ChannelSign:SetActiveWidgetIndex(1)
  else
    self.WS_ChannelSign:SetActiveWidgetIndex(2)
  end
  self:OnChatUpdateInput()
end

function M:OnChatUpdateInput()
  self.Com_List03:SetButtonState(UIUtils.IsGamepadInput() and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.Visible)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.IsGamepadInput() then
    self.Com_List03:OnCellHovered()
  end
  return UIUtils.Handled
end

function M:OnFocusLost(MyGeometry, InFocusEvent)
  if UIUtils.IsGamepadInput() then
    self.Com_List03:OnCellUnhovered()
  end
  return UIUtils.Handled
end

return M
