require("UnLua")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})
local GiftModel = GiftController:GetModel()
M._components = {
  "BluePrints.UI.WBP.Gift.Widget.WBP_Gift_ShopTarget_ChooseFriendContent_GamePadCompoment"
}

function M:InitContent(Parms)
  self.FriendUid = Parms.FriendUid
  self.FriendChangeCallBack = Parms.FriendChangeCallBack
  if self.Owner and self.Owner.ClearAllGamepadShortcutContent then
    self.Owner:ClearAllGamepadShortcutContent()
  end
  self:ShowGamepadCloseBtn(true)
  self:InitFriends()
  self:InitTitle()
  self:AddDispatcher(EventID.UnLoadUI, self, self.OnUIUnLoad)
end

function M:OnUIUnLoad(UIName)
  DebugPrint("yklua OnUIUnLoad" .. UIName)
  if "PersonInfoPageMain" == UIName then
    if not self.Owner:IsVisible() then
      self.Owner:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.IsGamePad then
      self:AddTimer(0.01, function()
        self:InitOriginFocus()
      end)
    end
  end
end

function M:InitTitle()
  local Title = self.Owner:GetTitle()
  self.Title = Title
  Title.Com_Qa:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  Title.HB_Qa:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if Title.Com_Qa and Title.Com_Qa.Init then
    Title.Com_Qa:Init({
      OwnerWidget = self,
      TextContent = self:GetQAText(),
      OnMenuOpenChangedCallBack = self.OnDescOpenChanged
    })
  end
end

function M:GetQAText()
  local ConsumeGiftQuota, TotalGiftQuota = GiftModel:GetTotalGiftQuota()
  local CurrentMonthSendGiftCount, TotalGiftCount = GiftModel:GetTotalGiftCount()
  return string.format(GText("UI_SendGift_Desc"), ConsumeGiftQuota, TotalGiftQuota, CurrentMonthSendGiftCount, TotalGiftCount)
end

function M:InitFriends()
  local Friends = GiftModel:GetFriends()
  if not Friends or 0 == #Friends then
    return
  end
  if self.FriendUid then
    local SelectedFriend
    local Others = {}
    for _, Friend in pairs(Friends) do
      if Friend.Uid == self.FriendUid then
        SelectedFriend = Friend
      else
        table.insert(Others, Friend)
      end
    end
    if SelectedFriend then
      Friends = {SelectedFriend}
      for _, Friend in ipairs(Others) do
        table.insert(Friends, Friend)
      end
    end
  end
  self.List_FriendContent:ClearListItems()
  for _, Friend in pairs(Friends) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.HeadFrameId = Friend.Info.HeadFrameId
    Content.Nickname = Friend.Info.Nickname
    Content.HeadIconId = Friend.Info.HeadIconId
    Content.Uid = Friend.Uid
    Content.Parent = self
    Content.ShopItemId = self.ShopItemId
    if self.FriendUid == Friend.Uid then
      self.SelectedContent = Content
      Content.IsSelected = true
    else
      Content.IsSelected = false
    end
    self.List_FriendContent:AddItem(Content)
  end
  self.List_FriendContent.OnCreateEmptyContent:Bind(self, function(self)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.IsEmpty = true
    return Obj
  end)
  self.List_FriendContent:RequestFillEmptyContent()
end

function M:OnFriendSelectClick(SelectedContent)
  self:CancelSelectFriend()
  self:SelectFriend(SelectedContent)
  if self.FriendChangeCallBack then
    self.FriendChangeCallBack(SelectedContent.Uid)
  end
end

function M:CancelSelectFriend()
  if not self.SelectedContent or not self.SelectedContent.UI then
    return
  end
  self.SelectedContent.UI:CancelSelect()
  self.SelectedContent = nil
end

function M:SelectFriend(Content)
  self.SelectedContent = Content
  self.SelectedContent.UI:Select()
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    self.IsGamePad = true
    IsEventHandled = self:OnGamePadDown(InKeyName)
  else
    self.IsGamePad = false
  end
  if IsEventHandled then
    return true
  else
    return false
  end
end

AssembleComponents(M)
return M
