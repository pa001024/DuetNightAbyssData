require("UnLua")
local FriendController = require("BluePrints.UI.WBP.Friend.FriendController")
local FriendModel = FriendController:GetModel()
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})

function M:Initialize()
  self.TabIndex = nil
  self.ChannelItems = {}
  self.FriendList = {}
  self.FriendListItemObjectSetNum = 0
  self.bShareClick = false
end

function M:InitContent(Params, PopupData, Owner)
  M.Super.InitContent(self, Params, PopupData, Owner)
  self.RoomData = Params.RoomData
  self.ShareCallback = Params.ShareCallback
  self.ShareCallbackObj = Params.ShareCallbackObj
  self:BindDialogEvent(DialogEvent.OnTitleTabSelected, self.OnTabSelected)
  for _, ChannelItem in pairs(self.ChannelItems) do
    ChannelItem.RoomUid = self.RoomData.RoomUniqueId
  end
end

function M:Construct()
  self.Ws_List:SetActiveWidgetIndex(0)
  self:RefreshFriendList()
  self:RefreshChannels()
  self.TabIndex = 1
  self.EmptyBg.Text_Empty:SetText(GText("UI_Friend_NoAnyFriend"))
  if 1 == self.TabIndex and 0 == #self.FriendList then
    self.Ws_List:SetActiveWidgetIndex(2)
  end
end

function M:Destruct()
  if self.ShareCallback and self.ShareCallbackObj then
    self.ShareCallback(self.ShareCallbackObj, self.bShareClick)
  end
end

function M:RefreshFriendList()
  if self.FriendListRefreshed then
    return
  end
  self.FriendListRefreshed = true
  local FriendList, FriendOnlineList = FriendModel:GetFriendList()
  self.FriendList = FriendList
  for _, Uid in pairs(FriendList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    self:SetupListContent(Uid, Content)
    Content.Owner = self
    self.ListFriend:AddItem(Content)
  end
end

function M:RefreshChannels()
  if self.ChannelListRefreshed then
    return
  end
  self.ChannelListRefreshed = true
  self.ItemChannel_1.Owner = self
  local Padding
  if self.ItemChannel_1 then
    local Slot = UE4.UWidgetLayoutLibrary.SlotAsScrollBoxSlot(self.ItemChannel_1)
    Padding = Slot.Padding
  end
  local ChannelItemBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/Coop/WBP_Activity_Coop_ShareChannelItem.WBP_Activity_Coop_ShareChannelItem'"
  local WorldChannelItem = UIManager(self):CreateWidget(ChannelItemBPPath, false)
  WorldChannelItem.Owner = self
  self.ListChannel:AddChild(WorldChannelItem)
  local ScrollBoxSlot = UE4.UWidgetLayoutLibrary.SlotAsScrollBoxSlot(WorldChannelItem)
  ScrollBoxSlot:SetPadding(Padding)
  ScrollBoxSlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Center)
  local RegionChannelItem = UIManager(self):CreateWidget(ChannelItemBPPath, false)
  RegionChannelItem.Owner = self
  self.ListChannel:AddChild(RegionChannelItem)
  ScrollBoxSlot = UE4.UWidgetLayoutLibrary.SlotAsScrollBoxSlot(RegionChannelItem)
  ScrollBoxSlot:SetPadding(Padding)
  ScrollBoxSlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Center)
  local OtherChannel = NewObject(UE4.UCanvasPanel)
  self.ListChannel:AddChild(OtherChannel)
  ScrollBoxSlot = UE4.UWidgetLayoutLibrary.SlotAsScrollBoxSlot(OtherChannel)
  ScrollBoxSlot:SetPadding(Padding)
  if self.Line then
    local Image = self:CopyImage(self.Line)
    local CanvasPanelSlot = OtherChannel:AddChildToCanvas(Image)
    local SlotLine = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Line)
    local LineLayout = SlotLine:GetLayout()
    CanvasPanelSlot:SetLayout(LineLayout)
  end
  local OtherChannelText
  if self.TextChannel then
    local SlotTextChannel = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.TextChannel)
    local TextLayout = SlotTextChannel:GetLayout()
    OtherChannelText = self:CopyTextBlock(self.TextChannel)
    local CanvasPanelSlot = OtherChannel:AddChildToCanvas(OtherChannelText)
    CanvasPanelSlot:SetLayout(TextLayout)
    CanvasPanelSlot:SetAutoSize(true)
  end
  local OtherChannelState
  if self.TextState then
    local SlotTextState = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.TextState)
    local TextLayout = SlotTextState:GetLayout()
    OtherChannelState = self:CopyTextBlock(self.TextState)
    local CanvasPanelSlot = OtherChannel:AddChildToCanvas(OtherChannelState)
    CanvasPanelSlot:SetLayout(TextLayout)
    CanvasPanelSlot:SetAutoSize(true)
  end
  local GuildChannelItem = UIManager(self):CreateWidget(ChannelItemBPPath, false)
  GuildChannelItem.Owner = self
  self.ListChannel:AddChild(GuildChannelItem)
  ScrollBoxSlot = UE4.UWidgetLayoutLibrary.SlotAsScrollBoxSlot(GuildChannelItem)
  ScrollBoxSlot:SetPadding(Padding)
  ScrollBoxSlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Center)
  self.TextChannel:SetText(GText("UI_AsyncCombat_PublicChannel"))
  self.TextState:SetText(GText("UI_AsyncCombat_ShareToPublic"))
  self.ItemChannel_1.TextChannel:SetText(GText("UI_AsyncCombat_RecruitChannel"))
  WorldChannelItem.TextChannel:SetText(GText("UI_AsyncCombat_WorldChannel"))
  RegionChannelItem.TextChannel:SetText(GText("UI_AsyncCombat_RegionChannel"))
  OtherChannelText:SetText(GText("UI_AsyncCombat_OtherChannels"))
  GuildChannelItem.TextChannel:SetText(GText("UI_AsyncCombat_GuildChannel"))
  OtherChannelState:SetText(GText("UI_AsyncCombat_ShareToGuild"))
  self.ItemChannel_1:InitShareChannel(ChatCommon.ChannelDef.TeamUp)
  WorldChannelItem:InitShareChannel(ChatCommon.ChannelDef.Public)
  RegionChannelItem:InitShareChannel(ChatCommon.ChannelDef.Region)
  GuildChannelItem:InitShareChannel(ChatCommon.ChannelDef.InGuild)
  table.insert(self.ChannelItems, 1, self.ItemChannel_1)
  table.insert(self.ChannelItems, 2, WorldChannelItem)
  table.insert(self.ChannelItems, 3, RegionChannelItem)
  table.insert(self.ChannelItems, 4, GuildChannelItem)
  for I = 1, #self.ChannelItems do
    local PrevIndex = I - 1
    if 0 == PrevIndex then
      PrevIndex = #self.ChannelItems
    end
    local NextIndex = I + 1
    if NextIndex == #self.ChannelItems + 1 then
      NextIndex = 1
    end
    self.ChannelItems[I].bIsFocusable = true
    self.ChannelItems[I]:SetNavigationRuleCustom(EUINavigation.Up, {
      self,
      function()
        self.ChannelItems[I].WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.ChannelItems[PrevIndex].WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.ChannelItems[PrevIndex]:SetFocus()
        if 1 == PrevIndex then
          self.ListChannel:ScrollWidgetIntoView(self.Title)
        else
          self.ListChannel:ScrollWidgetIntoView(self.ChannelItems[PrevIndex])
        end
        return self.ChannelItems[PrevIndex]
      end
    })
    self.ChannelItems[I]:SetNavigationRuleCustom(EUINavigation.Down, {
      self,
      function()
        self.ChannelItems[I].WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.ChannelItems[NextIndex].WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.ChannelItems[NextIndex]:SetFocus()
        if 1 == NextIndex then
          self.ListChannel:ScrollWidgetIntoView(self.Title)
        else
          self.ListChannel:ScrollWidgetIntoView(self.ChannelItems[NextIndex])
        end
        return self.ChannelItems[NextIndex]
      end
    })
  end
end

function M:CopyTextBlock(InTextBlock)
  if not InTextBlock then
    return nil
  end
  local ColorAndOpacity = InTextBlock.ColorAndOpacity
  local Text = InTextBlock:GetText()
  local Font = InTextBlock.Font
  local TextBlock = NewObject(UE4.UTextBlock)
  TextBlock:SetColorAndOpacity(ColorAndOpacity)
  TextBlock:SetText(Text)
  TextBlock:SetFont(Font)
  return TextBlock
end

function M:CopyImage(InImage)
  if not InImage then
    return nil
  end
  local Brush = InImage.Brush
  local ColorAndOpacity = InImage.ColorAndOpacity
  local Image = NewObject(UE4.UImage)
  Image:SetBrush(Brush)
  Image:SetColorAndOpacity(ColorAndOpacity)
  return Image
end

function M:SetupListContent(Uid, NewContent)
  local Dict = FriendModel:GetFriendDict()
  local FriendData = Dict[Uid]
  NewContent.Data = FriendData
  NewContent.Type = FriendCommon.FriendTabType.MyFriend
end

function M:GetCurrentAsyncCombatRoomInfo()
  return self.RoomData
end

function M:OnTabSelected(TabWidget)
  self.TabIndex = TabWidget.Idx
  local SwitcherIndex = self.TabIndex - 1
  self.Ws_List:SetActiveWidgetIndex(SwitcherIndex)
  self:RefreshOpInfoByInputDevice(CommonUtils.GetCurrentInputType())
  if 1 == self.TabIndex and 0 == #self.FriendList then
    self.Ws_List:SetActiveWidgetIndex(2)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.MouseAndKeyboard then
    self:InitKeyboardView()
  elseif CurInputDevice == ECommonInputType.Gamepad then
    self:InitGamepadView()
  end
end

function M:InitGamepadView()
  if 1 == self.TabIndex then
    local FriendNum = self.ListFriend:GetNumItems()
    if 0 == FriendNum then
      return
    end
    local Item = self.ListFriend:GetItemAt(0)
    
    local function SetFocus()
      if Item and Item.UI then
        Item.UI:SetFocus()
      end
    end
    
    if Item and Item.UI then
      Item.UI:SetFocus()
    else
      self:AddTimer(0.01, SetFocus, false, 0)
    end
  elseif 2 == self.TabIndex then
    if self.ChannelItems and 0 == #self.ChannelItems then
      return
    end
    self.ChannelItems[1]:SetFocus()
  end
end

function M:InitKeyboardView()
  local NumItems = self.ListFriend:GetNumItems()
  for I = 1, NumItems do
    local Item = self.ListFriend:GetItemAt(I - 1)
    if Item and Item.UI and Item.UI.WBP_Com_KeyImg then
      Item.UI.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
  for _, Item in pairs(self.ChannelItems) do
    if Item and Item.WBP_Com_KeyImg then
      Item.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

return M
