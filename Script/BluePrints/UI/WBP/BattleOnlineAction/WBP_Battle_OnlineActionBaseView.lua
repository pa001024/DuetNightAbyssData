require("UnLua")
local M = {}
local OnlineActionController = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController")
local OnlineActionModel = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionModel")
local OnlineActionCommon = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionCommon")

function M:InitBaseView(OpenReason)
  OpenReason = OpenReason or 1
  self.OpenReason = OpenReason
  self:StaticInit()
  self:BindEvent()
  self:DynamicInit()
  self:PlayAnimation(self.In)
  self:SetFocus()
end

function M:NotifyTick(InDeltaTime)
  if not IsValid(self) then
    return
  end
  self:ClearDeadItem()
  local DisplayedWidgets = self.List_Invite:GetDisplayedEntryWidgets()
  for i = 1, DisplayedWidgets:Length() do
    local WidgetRef = DisplayedWidgets:GetRef(i)
    WidgetRef:NotifyTick()
  end
end

function M:ClearDeadItem()
  local ItemsToRemove = {}
  local AllItems = self.List_Invite:GetListItems()
  if not AllItems then
    return
  end
  for i = 1, AllItems:Length() do
    local Item = AllItems:GetRef(i)
    if Item and Item.Content and (1 == Item.Kind or 3 == Item.Kind) and Item.Content.RemainTime <= 0 then
      table.insert(ItemsToRemove, Item)
    end
  end
  if #ItemsToRemove > 0 then
    local kind = self.OldTabID
    if self.Tab_OnlineAction and self.Tab_OnlineAction.GetCurrentTabInfo then
      local CurrentTabInfo = self.Tab_OnlineAction:GetCurrentTabInfo()
      if CurrentTabInfo then
        kind = CurrentTabInfo.TabId
      end
    end
    self:RemoveItemsAndAutoSwitch(ItemsToRemove, kind)
  end
end

function M:Tick(MyGeometry, InDeltaTime)
end

function M:StaticInit()
  self.Text_Empty:SetText(GText("UI_RegionOnline_NoInvitation"))
  self.Text_Title:SetText(GText("UI_RegionOnline_CommonList"))
end

function M:BindEvent()
  local function ReturnClick()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return", "Click", nil)
    
    self:OnReturnKeyDown()
  end
  
  self.Btn_Close.btn_close.OnClicked:Add(self, ReturnClick)
  self.Tab_OnlineAction:BindEventOnTabSelected(self, self.OnTabSwitchOn)
end

function M:DynamicInit()
  if 1 == self.OpenReason then
    self.WS_Top:SetActiveWidgetIndex(0)
    self:InitTabs()
  else
    self.WS_Top:SetActiveWidgetIndex(1)
    self.Text_Title:SetText(GText("UI_RegionOnline_CommonList"))
    self:OnInvitationspageOpen()
  end
end

local ApplicationTab = {
  TabKey = "Applications",
  Text = GText("UI_RegionOnline_ApplyList"),
  TabId = 1
}
local NearbyPlayersTab = {
  TabKey = "NearbyPlayers",
  Text = GText("UI_RegionOnline_InviteNearby"),
  TabId = 2
}
local InvitationTab = {
  TabKey = "Invitations",
  Text = GText("UI_RegionOnline_InviteList"),
  TabId = 3
}

function M:InitTabs()
  local Tabs = {}
  if 1 == self.OpenReason or not self.OpenReason then
    Tabs = {
      ApplicationTab,
      NearbyPlayersTab,
      InvitationTab
    }
  elseif 2 == self.OpenReason then
    Tabs = {InvitationTab}
  else
    ScreenPrint("InitTabs: Unknown OpenReason 错误的打开原因，找不到对应Tab数据" .. tostring(self.OpenReason))
    Tabs = {InvitationTab}
  end
  local IsMobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
  local ConfigData = {
    LeftKey = "Q",
    RightKey = "E",
    LeftGamePadKey = "LeftShoulder",
    RightGamePadKey = "RightShoulder",
    ChildWidgetName = "",
    ChildWidgetBPPath = "/Game/UI/WBP/Battle/Widget/Online_Action/WBP_Battle_OnlineAction_TabItem.WBP_Battle_OnlineAction_TabItem",
    Tabs = Tabs,
    SoundFunc = function(self)
      AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_03", "OnlineActionTabBtnClick", nil)
    end
  }
  if 1 == self.OpenReason and not OnlineActionModel:HaveOtherApply() then
    self.Tab_OnlineAction:Init(ConfigData)
    self:HideLastTabItemLine()
    self.Tab_OnlineAction:SelectTab(2)
  elseif 1 == self.OpenReason and OnlineActionModel:HaveOtherApply() then
    self.Tab_OnlineAction:Init(ConfigData)
    self:HideLastTabItemLine()
    self.Tab_OnlineAction:SelectTab(1)
  elseif 2 == self.OpenReason then
    self:OnInvitationspageOpen()
  end
end

function M:HideLastTabItemLine()
  local tab = self.Tab_OnlineAction
  if not tab or not tab.List_Tab then
    return
  end
  local count = tab.List_Tab:GetChildrenCount() or 0
  if count <= 0 then
    return
  end
  local last = tab.List_Tab:GetChildAt(count - 1)
  if not last then
    return
  end
  if last.Line then
    last.Line:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SwitchListView()
  self.WS_State:SetActiveWidgetIndex(0)
end

function M:SwitchEmptyBG(Kind)
  if 1 == Kind then
    self.Text_Empty:SetText(GText("UI_RegionOnline_NoApplication"))
  elseif 2 == Kind then
    self.Text_Empty:SetText(GText("UI_RegionOnline_NoPlayer"))
  elseif 3 == Kind then
    self.Text_Empty:SetText(GText("UI_RegionOnline_NoInvitation"))
  end
  self.WS_State:SetActiveWidgetIndex(1)
end

function M:OnTabSwitchOn(TabWidget, TabInfo)
  if TabInfo.TabKey == "Applications" then
    self.TabKind = 1
    self:SwitchListView(TabWidget, TabInfo)
    self:OnApplicationsTabSwitchOn(TabWidget, TabInfo)
  elseif TabInfo.TabKey == "NearbyPlayers" then
    self.TabKind = 2
    self:SwitchEmptyBG(TabWidget, TabInfo)
    self:OnNearbyPlayersTabSwitchOn(TabWidget, TabInfo)
  elseif TabInfo.TabKey == "Invitations" then
    self.TabKind = 3
    self:SwitchEmptyBG(TabWidget, TabInfo)
    self:OnInvitationsTabSwitchOn(TabWidget, TabInfo)
  end
end

function M:GenerateListItem(Kind, needAni)
  local Data, Cache
  local List = self.List_Invite
  if 1 == Kind then
    Data = OnlineActionModel:GetApplyInfos()
    Cache = self.ApplyInfosCache
  elseif 2 == Kind then
    Data = OnlineActionModel:GetNearbyPlayerInfos()
    Cache = self.NearbyPlayersCache
  elseif 3 == Kind then
    Data = OnlineActionModel:GetInvitationInfos()
    Cache = self.InvitationInfosCache
  end
  if Data and next(Data) then
    self:SwitchListView()
    List:ClearListItems()
    if 2 == Kind then
      local MaxPlayerNum = OnlineActionModel:GetMaxPlayerNum()
      for index, ItemData in ipairs(Data) do
        local NewItem = NewObject(UIUtils.GetCommonItemContentClass())
        NewItem.Parent = self
        NewItem.Content = ItemData
        Cache:Add(NewItem)
        NewItem.Parent = self
        NewItem.CallbackObj = self
        NewItem.Kind = Kind
        NewItem.NeedAni = needAni
        
        function NewItem.InvitationCallback(CallbackObj, Content, Index)
          OnlineActionController:SendInvitation(Content, Index)
        end
        
        NewItem.MaxPlayerNum = MaxPlayerNum
        List:AddItem(NewItem)
      end
    else
      for i = #Data, 1, -1 do
        local ItemData = Data[i]
        if 1 == Kind then
          self:AddNewApplicationItem(ItemData, needAni)
        elseif 3 == Kind then
          self:AddNewInvitationItem(ItemData, needAni)
        end
      end
    end
    if self.IsGamePad then
      self:FocusFirstItem()
    end
  else
    self:SwitchEmptyBG(Kind)
  end
end

function M:RemoveSameSeatApplications(InteractiveId)
  local itemsToRemove = {}
  local allListItems = self.List_Invite and self.List_Invite:GetListItems()
  if allListItems then
    for i = allListItems:Length(), 1, -1 do
      local Item = allListItems:GetRef(i)
      if Item and Item.Content.InteractiveId == InteractiveId then
        table.insert(itemsToRemove, Item)
      end
    end
  end
  self:RemoveItemsAndAutoSwitch(itemsToRemove, 1)
end

function M:IsListHaveItem()
  local List = self.List_Invite
  return List and List:GetNumItems() > 0
end

function M:RemoveItemsAndAutoSwitch(Items, Kind)
  local List = self.List_Invite
  if not List then
    return
  end
  if Items then
    if #Items > 1 then
      for _, item in ipairs(Items) do
        if item then
          List:RemoveItem(item)
        end
      end
    else
      List:RemoveItem(Items[1] or Items)
    end
  end
  if not self:IsListHaveItem() then
    local kindToUse = Kind
    if not kindToUse then
      local CurrentTabInfo = self.Tab_OnlineAction and self.Tab_OnlineAction.GetCurrentTabInfo and self.Tab_OnlineAction:GetCurrentTabInfo()
      if CurrentTabInfo and CurrentTabInfo.TabId then
        kindToUse = CurrentTabInfo.TabId
      else
        kindToUse = self.TabKind
      end
    end
    if kindToUse then
      self:SwitchEmptyBG(kindToUse)
    end
  end
end

function M:FocusFirstItem()
  self:AddTimer(0.01, function()
    if self:IsListHaveItem() then
      local Item = self.List_Invite:GetItemAt(0)
      self.List_Invite:BP_NavigateToItem(Item)
      self.List_Invite:BP_SetItemSelection(Item, true)
    else
      self:SetFocus()
    end
  end)
end

function M:OnTabSwitchOnBase(TabWidget, TabInfo)
  local TabId = TabInfo.TabId
  if self.OldTabID and TabId > self.OldTabID then
    self:PlayAnimation(self.List_Change_R)
  elseif self.OldTabID and TabId < self.OldTabID then
    self:PlayAnimation(self.List_Change_L)
  end
  if self.Key_Refuse then
    self.Key_Refuse:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if self.Btn_Refuse then
    self.Btn_Refuse:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  self.OldTabID = TabId
  self.List_Invite:ClearListItems()
end

function M:OnApplicationsTabSwitchOn(TabWidget, TabInfo)
  self:OnTabSwitchOnBase(TabWidget, TabInfo)
  self:GenerateListItem(1)
end

function M:OnNearbyPlayersTabSwitchOn(TabWidget, TabInfo)
  self:OnTabSwitchOnBase(TabWidget, TabInfo)
  self:GenerateListItem(2)
  if self.Key_Refuse then
    self.Key_Refuse:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Btn_Refuse then
    self.Btn_Refuse:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnInvitationsTabSwitchOn(TabWidget, TabInfo)
  self:OnTabSwitchOnBase(TabWidget, TabInfo)
  self:GenerateListItem(3)
end

function M:OnInvitationspageOpen()
  self:GenerateListItem(3)
end

function M:OnLeftTabKeyDown()
  if self.Tab_OnlineAction.CurrentTab and self.Tab_OnlineAction.CurrentTab - 1 >= 1 then
    self.Tab_OnlineAction:TabToLeft()
  end
end

function M:OnRightTabKeyDown()
  if self.Tab_OnlineAction.CurrentTab and self.Tab_OnlineAction.CurrentTab + 1 <= #self.Tab_OnlineAction.Tabs then
    self.Tab_OnlineAction:TabToRight()
  end
end

function M:OnReceivedNewInvitation(InvitationInfo)
  if 3 == self.TabKind or 2 == self.OpenReason then
    local NewItem = self:AddNewInvitationItem(InvitationInfo, true)
    self.WS_State:SetActiveWidgetIndex(0)
    self:AddTimer(0.1, function()
      NewItem.NeedAni = false
    end)
  end
end

function M:AddNewInvitationItem(InvitationInfo, NeedAni)
  local Kind = 3
  local List = self.List_Invite
  local Cache = self.InvitationInfosCache
  local NewItem = NewObject(UIUtils.GetCommonItemContentClass())
  NewItem.Content = InvitationInfo
  NewItem.Parent = self
  Cache:Add(NewItem)
  NewItem.Parent = self
  NewItem.CallbackObj = self
  NewItem.Kind = Kind
  NewItem.NeedAni = NeedAni
  
  function NewItem.AcceptCallback(CallbackObj, Content)
    OnlineActionController:SendAcceptInvitation(Content)
    self:ClearListAndSwitchEmpty(3)
    self:OnReturnKeyDown()
  end
  
  function NewItem.RejectCallback(CallbackObj, Content)
    OnlineActionController:SendRejectInvitation(Content)
    self:RemoveItemsAndAutoSwitch(NewItem, 3)
  end
  
  List:AddItem(NewItem)
  return NewItem
end

function M:OnReceivedNewApplication(ApplicationInfo)
  if 1 == self.TabKind then
    local NewItem = self:AddNewApplicationItem(ApplicationInfo, true)
    self.WS_State:SetActiveWidgetIndex(0)
    self:AddTimer(0.1, function()
      NewItem.NeedAni = false
    end)
  end
end

function M:AddNewApplicationItem(ApplicationInfo, NeedAni)
  local Kind = 1
  local List = self.List_Invite
  local Cache = self.ApplyInfosCache
  local NewItem = NewObject(UIUtils.GetCommonItemContentClass())
  NewItem.Content = ApplicationInfo
  NewItem.Parent = self
  Cache:Add(NewItem)
  NewItem.Parent = self
  NewItem.CallbackObj = self
  NewItem.Kind = Kind
  NewItem.NeedAni = NeedAni
  
  function NewItem.AcceptCallback(CallbackObj, Content)
    OnlineActionController:SendAcceptApplication(Content)
    self:ClearListAndSwitchEmpty(3)
    self:OnReturnKeyDown()
  end
  
  function NewItem.RejectCallback(CallbackObj, Content)
    OnlineActionController:SendRejectApplication(Content)
    self:RemoveItemsAndAutoSwitch(NewItem, 3)
  end
  
  List:AddItem(NewItem)
  return NewItem
end

function M:OnRefreshAllKeyDown()
  DebugPrint("OnRefreshAllKeyDown")
  if 2 == self.OpenReason then
    self:GenerateListItem(3, true)
  end
  if 1 == self.TabKind then
    self:GenerateListItem(1, true)
  elseif 2 == self.TabKind then
    OnlineActionModel:FindPlayerAround()
    self:GenerateListItem(2, true)
  elseif 3 == self.TabKind then
    self:GenerateListItem(3, true)
  end
end

function M:ClearListAndSwitchEmpty(kind)
  local List = self.List_Invite
  if not List then
    return
  end
  List:ClearListItems()
  local kindToUse = kind or self.TabKind or 3
  self:SwitchEmptyBG(kindToUse)
end

function M:OnRejectAllKeyDown()
  DebugPrint("OnRejectAllKeyDown")
  if 3 == self.TabKind or 2 == self.OpenReason then
    OnlineActionController:RejectAllInvitations()
    self:ClearListAndSwitchEmpty(3)
  elseif 1 == self.TabKind then
    OnlineActionController:RejectAllApplications()
    self:ClearListAndSwitchEmpty(1)
  end
end

function M:OnReturnKeyDown()
  self:PlayAnimation(self.Out)
  self:UnbindAllFromAnimationFinished(self.Out)
  self:BindToAnimationFinished(self.Out, function()
    OnlineActionController:CloseView(self)
    self:Close()
  end)
end

function M:Close()
  self.Super.Close(self)
end

return M
