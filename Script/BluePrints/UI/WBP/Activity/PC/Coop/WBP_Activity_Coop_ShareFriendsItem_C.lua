require("UnLua")
local TimerKeyPrefix = "CoopShareCooldownTimer"
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:Initialize()
  self.CooldownTime = 5
  self.PlayerOffline = FLinearColor(0.318547, 0.318547, 0.318547, 1.0)
  self.PlayerOnline = FLinearColor(0.181164, 0.665387, 0.462077, 1.0)
  self.PlayerBusy = FLinearColor(0.752942, 0.533277, 0.258183, 1.0)
  self.PlayerOfflineSlateColor = FSlateColor()
  self.PlayerOnlineSlateColor = FSlateColor()
  self.PlayerBusySlateColor = FSlateColor()
  self.PlayerOfflineSlateColor.SpecifiedColor = self.PlayerOffline
  self.PlayerOnlineSlateColor.SpecifiedColor = self.PlayerOnline
  self.PlayerBusySlateColor.SpecifiedColor = self.PlayerBusy
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
end

function M:OnListItemObjectSet(Content)
  Content.UI = self
  self.Owner = Content.Owner
  self.Type = Content.Type
  self.FriendData = Content.Data
  self:SetHeadIcon(self.FriendData.Info)
  self.TextFriendName:SetText(self.FriendData.Info.Nickname)
  self:SetOnlineState(self.FriendData.Info)
  self.bIsFocusable = true
  self.TimerKey = TimerKeyPrefix .. tostring(self.FriendData.Uid)
  self:CheckTimer()
  if type(self.Owner.FriendListItemObjectSetNum) == "number" and type(self.Owner.FriendList) == "table" then
    self.Owner.FriendListItemObjectSetNum = self.Owner.FriendListItemObjectSetNum + 1
    if self.Owner.FriendListItemObjectSetNum == #self.Owner.FriendList then
      local NumItems = self.Owner.ListFriend:GetNumItems()
      for I = 1, NumItems do
        local CPPIndex = I - 1
        local NextCPPIndex = (CPPIndex + 1) % NumItems
        local PrevCPPIndex = (CPPIndex - 1) % NumItems
        local NextItem = self.Owner.ListFriend:GetItemAt(NextCPPIndex)
        local PrevItem = self.Owner.ListFriend:GetItemAt(PrevCPPIndex)
        self:SetNavigationRuleCustom(EUINavigation.Up, {
          self,
          function()
            self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
            PrevItem.UI.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self.Owner.ListFriend:BP_CancelScrollIntoView()
            self.Owner.ListFriend:BP_SetSelectedItem(PrevItem)
            self.Owner.ListFriend:BP_NavigateToItem(PrevItem)
            return self.Owner.ListFriend
          end
        })
        self:SetNavigationRuleCustom(EUINavigation.Down, {
          self,
          function()
            self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
            NextItem.UI.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self.Owner.ListFriend:BP_CancelScrollIntoView()
            self.Owner.ListFriend:BP_SetSelectedItem(NextItem)
            self.Owner.ListFriend:BP_NavigateToItem(NextItem)
            return self.Owner.ListFriend
          end
        })
      end
    end
  end
end

function M:SetHeadIcon(AvatarInfo)
  self.WBP_Com_ItemHead:SetHeadIconById(AvatarInfo.HeadIconId)
  self.WBP_Com_ItemHead:SetHeadFrame(AvatarInfo.HeadFrameId)
end

function M:SetOnlineState(AvatarInfo)
  if not AvatarInfo.IsOnline then
    self.Text_Loca:SetText(GText("UI_Friend_State_Offline"))
    self.Text_Loca:SetColorAndOpacity(self.PlayerOfflineSlateColor)
    self.Img_Point:SetColorAndOpacity(self.PlayerOffline)
  elseif not AvatarInfo.IsInDungeon and not AvatarInfo.IsInSpecialQuest then
    self.Text_Loca:SetText(GText("UI_Friend_Online"))
    self.Text_Loca:SetColorAndOpacity(self.PlayerOnlineSlateColor)
    self.Img_Point:SetColorAndOpacity(self.PlayerOnline)
  else
    self.Text_Loca:SetText(GText("UI_Chat_InDungeon"))
    self.Text_Loca:SetColorAndOpacity(self.PlayerBusySlateColor)
    self.Img_Point:SetColorAndOpacity(self.PlayerBusy)
  end
end

function M:CheckTimer()
  if not self.TimerKey then
    DebugPrint("lxc: WBP_Activity_Coop_ShareFriendsItem_C:CheckTimer: no self.TimerKey")
    return
  end
  local GameInstance = GWorld.GameInstance
  GameInstance.CoopShareTimers = GameInstance.CoopShareTimers or {}
  local TimerInfo = GameInstance.CoopShareTimers[self.TimerKey]
  local NowMs = TimeUtils.NowTimeMs()
  if TimerInfo and TimerInfo.EndTime and NowMs <= TimerInfo.EndTime then
    self.BtnShare:ForbidBtn(true)
    self:ResetTimer(TimerInfo.EndTime)
    DebugPrint(string.format("lxc: WBP_Activity_Coop_ShareFriendsItem_C:CheckTimer: 恢复计时, self: %s, Name: %s", tostring(self), self.FriendData.Info.Nickname))
  else
    GameInstance.CoopShareTimers[self.TimerKey] = nil
    self:CleanTimer()
    self:UpdateCountDownShow()
    self.BtnShare:ForbidBtn(false)
  end
end

function M:OnClick()
  if self.BtnShare:IsBtnForbidden() then
    self:HandleClickForbiddenButton()
    return
  end
  self:ShareWithFriend()
  self.BtnShare:ForbidBtn(true)
  local NowMs = TimeUtils.NowTimeMs()
  local EndMs = NowMs + self.CooldownTime * 1000
  self:ResetTimer(EndMs)
  self:ResetTimerInfo()
end

function M:ResetTimerInfo()
  if not GWorld.GameInstance then
    DebugPrint("lxc: WBP_Activity_Coop_ShareFriendsItem_C:ResetTimerInfo GameInstance为nil")
    return
  end
  if not self.TimerKey then
    DebugPrint("lxc: WBP_Activity_Coop_ShareFriendsItem_C:ResetTimerInfo TimerKey为nil, FriendUid: " .. tostring(self.FriendData and self.FriendData.Uid))
    return
  end
  local NowMs = TimeUtils.NowTimeMs()
  local EndMs = NowMs + self.CooldownTime * 1000
  local GameInstance = GWorld.GameInstance
  GameInstance.CoopShareTimers = GameInstance.CoopShareTimers or {}
  DebugPrint(string.format("lxc: WBP_Activity_Coop_ShareFriendsItem_C:ResetTimerInfo 定时器: %s, 原到期时间: %s, 新到期时间: %s", self.TimerKey, tostring(GameInstance.CoopShareTimers[self.TimerKey] and GameInstance.CoopShareTimers[self.TimerKey].EndTime), tostring(EndMs)))
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
    DebugPrint(string.format("UpdateCountDownShow: 玩家: %s 恢复ui, self: %s", self.FriendData.Info.Nickname, tostring(self)))
  else
    self.Cd_Node:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    local TimeStr = self:GetTimeStr(RemainingTimeSecs)
    self.TextTime:SetText("(" .. TimeStr .. ")")
    DebugPrint(string.format("UpdateCountDownShow: 玩家: %s, TimeStr: %s, self: %s", self.FriendData.Info.Nickname, TimeStr, tostring(self)))
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

function M:ShareWithFriend()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  
  local function Func(Obj, Ret, player_uid, room_uid)
    DebugPrint("clx: WBP_Activity_Coop_ShareFriendsItem_C:ShareWithFriend " .. "Ret: " .. Ret .. "player_uid: " .. player_uid .. "room_uid: " .. room_uid)
    if ErrorCode:Check(Ret) then
      self.Owner.bShareClick = true
      UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_AsyncCombat_Sharesuccessful")
    end
  end
  
  local CallbackInfo = {Obj = nil, Func = Func}
  local RoomData = self.Owner:GetCurrentAsyncCombatRoomInfo()
  Avatar:SendAsyncCombatRoomToPlayer(CallbackInfo, self.FriendData.Uid, RoomData.RoomUniqueId)
end

function M:OnMouseButtonDown(MyGeometry, InMouseEvent)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  local Key = UE4.UKismetInputLibrary.PointerEvent_GetEffectingButton(InMouseEvent)
  local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)
  if "LeftMouseButton" == KeyName then
    self:OnClick()
  end
  return UWidgetBlueprintLibrary.Handled()
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

function M:BP_OnEntryReleased()
  self:CleanTimer()
  self:UpdateCountDownShow()
  self.BtnShare:ForbidBtn(false)
end

AssembleComponents(M)
return M
