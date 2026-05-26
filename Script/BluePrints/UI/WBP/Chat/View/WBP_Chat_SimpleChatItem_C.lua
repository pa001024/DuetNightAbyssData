require("UnLua")
local ChatCommon = require("BluePrints.UI.WBP.Chat.ChatCommon")
local StringUtils = require("Utils.StringUtils")
local M = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C"
})
local SimpleChatTextEdgeReserve = 2

function M:OnListItemObjectSet(Content)
  if not GWorld.NetworkMgr:CheckIsConnected(true) then
    return
  end
  self.Content = Content
  self.Content.UI = self
  self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self:Open(Content.MsgWrap, Content.bSound)
end

function M:BP_OnEntryReleased()
  self:ResetTranslation()
  self:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Content.UI = nil
end

function M:GetChatBubbleTargetWidth()
  local RootWidth = 0
  if self.SizeBox_Root then
    RootWidth = self.SizeBox_Root.WidthOverride or 0
    if RootWidth <= 0 and self.SizeBox_Root.GetDesiredSize then
      RootWidth = self.SizeBox_Root:GetDesiredSize().X or 0
    end
  end
  local DialogWidth = RootWidth
  if self.SizeBox_Dialog then
    local DialogSlot = UWidgetLayoutLibrary.SlotAsOverlaySlot(self.SizeBox_Dialog)
    if DialogSlot then
      local Padding = DialogSlot.Padding
      DialogWidth = DialogWidth - Padding.Left - Padding.Right
    end
  end
  local SingleWidth = RootWidth
  if self.Text_DialogSingle then
    local SingleSlot = UWidgetLayoutLibrary.SlotAsOverlaySlot(self.Text_DialogSingle)
    if SingleSlot then
      local Padding = SingleSlot.Padding
      SingleWidth = SingleWidth - Padding.Left - Padding.Right
    end
  end
  return math.max(math.min(DialogWidth, SingleWidth) - SimpleChatTextEdgeReserve, 0)
end

function M:Open(MsgWrap, bSound)
  local ChannelName = ChatController:ParseChannelHeader(MsgWrap)
  local Spacker, RawSpacker = ChatController:ParseSpeakerHeader(MsgWrap)
  local Content = ChatController:ParseEmojiToText(MsgWrap)
  local ModSuitContent = ChatController:ParseModSuitText(MsgWrap)
  if ModSuitContent then
    Content = ModSuitContent
  end
  local DyePlanContent = ChatController:ParseDyePlanText(MsgWrap)
  if DyePlanContent then
    Content = DyePlanContent
  end
  local AppearancePlanContent = ChatController:ParseAppearancePlanText(MsgWrap)
  if AppearancePlanContent then
    Content = AppearancePlanContent
  end
  local AsyncCombatRoomInfoContent = ChatController:ParseAsyncCombatRoomInfoText(MsgWrap)
  if AsyncCombatRoomInfoContent then
    Content = AsyncCombatRoomInfoContent
  end
  local GuildRecruitContent = ChatController:ParseGuildRecruitText(MsgWrap)
  if nil ~= GuildRecruitContent then
    Content = GuildRecruitContent
  end
  local RawContent = ChannelName .. RawSpacker .. Content
  local RawContentTable = StringUtils.Utf8ToTable(RawContent)
  local HalfLength = #RawContentTable
  local LeftHalf, RightHalf = nil, RawContentTable
  self.SizeBox_Dialog:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Text_DialogSingle:SetVisibility(UIConst.VisibilityOp.Visible)
  if self.Text_DialogSingle and self.Text_DialogSingle.SetWrapTextAt then
    self.Text_DialogSingle:SetWrapTextAt(0)
  end
  self:SetRenderOpacity(0)
  local TargetLineWidth = self:GetChatBubbleTargetWidth()
  self.Text_DialogSingle:SetText(RawContent)
  local _, Key = self:AddTimer(0.01, function()
    self.Text_DialogSingle:ForceLayoutPrepass()
    local NowLineWidth = self.Text_DialogSingle:GetDesiredSize().X
    HalfLength = math.floor(#RightHalf / 2)
    if 0 == HalfLength then
      local Splited = StringUtils.Utf8ToTable(table.concat(RawContent:split(ChatCommon.Spliter), "", 2))
      if NowLineWidth > TargetLineWidth then
        Splited = table.slice(Splited, 1, #Splited - 2)
      end
      local InsertPos = string.len(table.concat(Splited))
      Content = Content:insert(InsertPos, "\n")
      self.Text_DialogSingle:SetVisibility(UIConst.VisibilityOp.Collapsed)
      if self.Text_Dialog and self.Text_Dialog.SetWrapTextAt then
        self.Text_Dialog:SetWrapTextAt(TargetLineWidth)
      end
      self.Text_Dialog:SetText(ChannelName .. Spacker .. Content)
      self:RemoveTicker()
      return
    end
    if NowLineWidth > TargetLineWidth then
      LeftHalf = table.slice(RawContentTable, 1, #RawContentTable - HalfLength)
      RightHalf = table.slice(RawContentTable, #RawContentTable - HalfLength + 1)
      RawContentTable = LeftHalf
    elseif NowLineWidth < TargetLineWidth and HalfLength > 0 then
      if not RightHalf or not LeftHalf then
        self.SizeBox_Dialog:SetVisibility(UIConst.VisibilityOp.Collapsed)
        if self.Text_DialogSingle and self.Text_DialogSingle.SetWrapTextAt then
          self.Text_DialogSingle:SetWrapTextAt(0)
        end
        self.Text_DialogSingle:SetText(ChannelName .. Spacker .. Content)
        self:RemoveTicker()
        return
      else
        for i, Val in ipairs(table.slice(RightHalf, 1, HalfLength)) do
          table.insert(LeftHalf, Val)
        end
        RightHalf = table.slice(RightHalf, HalfLength + 1)
        RawContentTable = LeftHalf
      end
    end
    RawContent = table.concat(RawContentTable)
    if self.Text_Dialog and self.Text_Dialog.SetWrapTextAt then
      self.Text_Dialog:SetWrapTextAt(TargetLineWidth)
    end
    self.Text_DialogSingle:SetText(RawContent)
  end, true, 0, nil, true)
  self._TickForTextSize = Key
  self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  local _, Key = self:AddTimer(self.AutoCloseCd, self.Close, false, 0, nil, true)
  self._TimerForAutoClose = Key
  if bSound then
    AudioManager(self):PlayUISound(self, "event:/ui/common/team_simple_msg_show", nil, nil)
  end
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.In)
end

function M:ResetTranslation()
  self.RenderSizeCache = nil
  self.TranslateCache.Y = 0
  self:SetRenderTranslation(self.TranslateCache)
end

function M:DoMove(ProgressTime)
  local Curve = ChatController:GetModel().SimpleChatOutAnimCurve
  if not Curve then
    return
  end
  if not self.RenderSizeCache then
    self.RenderSizeCache = UIManager(self):GetWidgetRenderSize(self)
  end
  local MovePos = self.RenderSizeCache.Y * Curve:GetFloatValue(ProgressTime)
  self.TranslateCache.Y = -MovePos
  self:SetRenderTranslation(self.TranslateCache)
end

function M:Close()
  self:RemoveTicker()
  self:RemoveCloseTimer()
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Out)
  local BattleUI = UIManager(self):GetUIObj("BattleMain")
  if BattleUI then
    BattleUI:OnSimpleChatClose(self)
  end
end

function M:RemoveTicker()
  if not self:IsExistTimer(self._TickForTextSize) then
    return
  end
  self:RemoveTimer(self._TickForTextSize, true)
  self:SetRenderOpacity(1)
  self._TickForTextSize = nil
end

function M:RemoveCloseTimer()
  if not self:IsExistTimer(self._TimerForAutoClose) then
    return
  end
  self:RemoveTimer(self._TimerForAutoClose, true)
  self._TimerForAutoClose = nil
end

function M:Construct()
  self._TickForTextSize = nil
  self._TimerForAutoClose = nil
  self.TranslateCache = FVector2D(0, 0)
end

function M:Destruct()
  self:StopAllAnimations()
  self:RemoveTicker()
  self:RemoveCloseTimer()
  self:ResetTranslation()
end

return M
