require("UnLua")
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local ChatModel = ChatController:GetModel()
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

function M:SetCooldownTimeText(TimeText)
  self.TextBlock_2:SetText(TimeText)
end

function M:OnClick()
  if self.BtnShare:IsBtnForbidden() then
    self:HandleClickForbiddenButton()
    return
  end
  self:ShareWithFriend()
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

function M:ShareWithFriend()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  
  local function Func(Obj, Ret, player_uid, room_uid)
    DebugPrint("clx: WBP_Activity_Coop_ShareChannelItem_C:ShareWithFriend " .. "Ret: " .. Ret .. "player_uid: " .. player_uid .. "room_uid: " .. room_uid)
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

AssembleComponents(M)
return M
