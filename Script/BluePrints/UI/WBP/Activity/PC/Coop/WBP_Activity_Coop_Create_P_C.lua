require("UnLua")
local EMCache = require("EMCache.EMCache")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local RoomState = {
  Public = 1,
  Friend = 2,
  Guild = 3,
  Private = 4
}

function M:Initialize(Initializer)
  self.CurLevel = nil
  self.CurReward = nil
  self.Entrust = nil
  self.RoomId = nil
  self.GamepadReward = nil
  self.GamepadEntrust = nil
  self.CurClickRewardItem = nil
  self.CurClickEntrustItem = nil
  self.Public = false
  self.Friend = false
  self.Guild = false
  self.Private = false
  self.Closing = false
  self.RoomStateCheckMap = {}
  self.CurCount = nil
  self._UpdatingRoomState = false
  self.bCreated = false
  self.bInGuild = nil
end

function M:Construct()
  self.Btn.Button_Area.OnClicked:Add(self, self.CreateRoom)
  self.BtnClose01.Btn_Close.OnClicked:Add(self, self.ClickClose)
  self.BtnCloseFull.OnClicked:Add(self, self.ClickClose)
end

function M:Destruct()
end

function M:Init(Parent)
  self.Parent = Parent
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/lianmeiyanyi_crystal_sub_panel_show", "Open", nil)
  self.Private01.TextPrivate:SetText(GText("UI_AsyncCombat_Public"))
  self.Private02.TextPrivate:SetText(GText("UI_AsyncCombat_FriendsOnly"))
  self.Private03.TextPrivate:SetText(GText("UI_AsyncCombat_GuildMembersOnly"))
  self.Private04.TextPrivate:SetText(GText("UI_AsyncCombat_InviteOnly"))
  self.TextTitle:SetText(GText("UI_AsyncCombat_CreateRoom"))
  self.TextReward:SetText(GText("UI_AsyncCombat_SelectReward"))
  self.TextMultiplier:SetText(GText("UI_AsyncCombat_SelectMultiTicket"))
  self.TextLevel:SetText(GText("UI_AsyncCombat_SelectDifficulty"))
  self.TextRoom:SetText(GText("UI_AsyncCombat_SetRoomStatus"))
  self.BigReward.TextTitle:SetText(GText("UI_AsyncCombat_RewardPreview"))
  self.BigReward.TextContent:SetText(string.format(GText("UI_AsyncCombat_HostRewardDesc"), 100, 5))
  self.WBP_Com_Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Title_Node:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.BigReward.Icon.Btn:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Btn.Cd_Node:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Btn.TextContent:SetVisibility(UE4.ESlateVisibility.Visible)
  self.Btn.TextStart:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self:InitReward()
  self:InitTicket()
  self:InitRoomLevel()
  self:InitRoomState()
  self:InitNavgation()
  self:InitRoomBtn()
  self.Btn:ForbidBtn(true)
  self:AddTimer(0.01, function()
    self:RefreshBigReward(self.CurReward.Id)
  end)
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnUpdateUIStyleByInputTypeChange)
  self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:InitRoomBtn()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Count = DataMgr.AsyncCombatEventConstant.AsyncCombat_WeeklyLimit.ConstantValue
  local EventId = DataMgr.AsyncCombatEventConstant.AsyncCombat_EventId.ConstantValue
  local UsedCount = Avatar.AsyncCombats[EventId].CreateRoomTimes
  self.Btn.TextContent:SetText(GText("UI_AsyncCombat_CreateRoomWithParam") .. "(" .. Count - UsedCount .. "/" .. Count .. ")")
end

function M:InitNavgation()
  self.ListReward:SetNavigationRuleCustom(EUINavigation.Down, {
    self,
    function()
      if self.GamepadEntrust then
        self.GamepadEntrust.UI:SetFocus()
      else
        local Item = self.ListMultiplier:GetItemAt(0)
        if Item and Item.UI then
          Item.UI:SetFocus()
        end
      end
    end
  })
  self.ListMultiplier:SetNavigationRuleCustom(EUINavigation.Up, {
    self,
    function()
      if self.GamepadReward then
        self.GamepadReward.UI:SetFocus()
      else
        local Item = self.ListReward:GetItemAt(0)
        if Item and Item.UI then
          Item.UI:SetFocus()
        end
      end
    end
  })
  self.ListMultiplier:SetNavigationRuleCustom(EUINavigation.Left, {
    self,
    function()
      if self.GamepadEntrust then
        local Index = self.ListMultiplier:GetIndexForItem(self.GamepadEntrust)
        if Index > 0 then
          local Item = self.ListMultiplier:GetItemAt(Index - 1)
          if Item and Item.UI then
            Item.UI:SetFocus()
          end
        end
      end
    end
  })
  self.ListDifficulty:SetNavigationRuleCustom(EUINavigation.Up, {
    self,
    function()
      if self.GamepadEntrust then
        self.GamepadEntrust.UI:SetFocus()
      else
        local Item = self.ListMultiplier:GetItemAt(0)
        if Item and Item.UI then
          Item.UI:SetFocus()
        end
      end
    end
  })
end

function M:InitReward()
  self.ListReward:ClearListItems()
  local CachedRewardId = EMCache:Get("CurReward")
  local RewardIdSet = {}
  local RewardIdList = {}
  for key, value in pairs(DataMgr.AsyncCombat) do
    local RewardId = value.ID
    if RewardId and not RewardIdSet[RewardId] then
      RewardIdSet[RewardId] = true
      table.insert(RewardIdList, RewardId)
    end
  end
  local SelectedRewardId
  if CachedRewardId and RewardIdSet[CachedRewardId] then
    SelectedRewardId = CachedRewardId
  else
    SelectedRewardId = RewardIdList[1]
  end
  for key, value in ipairs(RewardIdList) do
    local RewardData = DataMgr.Resource[value]
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = RewardData.ResourceId
    Content.Icon = RewardData.Icon
    Content.ItemType = "Resource"
    Content.UIName = RewardData.ResourceName
    Content.Rarity = RewardData.Rarity
    Content.IsShowDetails = false
    Content.ParentWidget = self
    Content.Parent = self
    Content.Rec = "Reward"
    if value == SelectedRewardId then
      Content.bClick = true
      self.CurReward = Content
      self.CurClickRewardItem = Content
    else
      Content.bClick = false
    end
    Content.OnMouseButtonDownEvent = {
      Obj = self,
      Callback = function()
        if self.CurClickRewardItem then
          self.CurClickRewardItem.SelfWidget:SetSelected(false)
        end
        if self.CurClickEntrustItem then
          self.CurClickEntrustItem.SelfWidget:SetSelected(false)
        end
        AudioManager(self):PlayItemSound(self, Content.Id, "Click", Content.ItemType)
        Content.SelfWidget:SetSelected(true)
        self.CurClickRewardItem = Content
        self.WBP_Com_Tips:SetVisibility(UE4.ESlateVisibility.Visible)
        self.WBP_Com_Tips:RefreshItemInfo(Content, true)
      end
    }
    Content.OverrideDetailsBackObject = self
    
    function Content.OverrideDetailsBackEvent()
      self:SetFocus()
    end
    
    self.ListReward:AddItem(Content)
  end
  self:AddTimer(0.01, function()
    if self.CurReward then
      self.ListReward:BP_NavigateToItem(self.CurReward)
    end
  end)
end

function M:RefreshTips(Content)
  self.WBP_Com_Tips:SetVisibility(UE4.ESlateVisibility.Visible)
  self.WBP_Com_Tips:RefreshItemInfo(Content, true)
  self.WBP_Com_Tips.Key_Back:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:CloseItemDetailsWidget(bClose)
  self.WBP_Com_Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self:SetFocus()
end

function M:InitTicket()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.ListMultiplier:ClearListItems()
  local CachedEntrustId = EMCache:Get("Entrust")
  local BlueId = DataMgr.AsyncCombatEventConstant.AsyncCombat_AddBonusRate1.ConstantValue
  local GreenId = DataMgr.AsyncCombatEventConstant.AsyncCombat_AddBonusRate2.ConstantValue
  local PurpleId = DataMgr.AsyncCombatEventConstant.AsyncCombat_AddBonusRate8.ConstantValue
  local GoldId = DataMgr.AsyncCombatEventConstant.AsyncCombat_AddBonusRate20.ConstantValue
  local TicketTable = {
    BlueId,
    GreenId,
    PurpleId,
    GoldId
  }
  local FirstOwnedEntrust, CachedEntrust
  for key, value in ipairs(TicketTable) do
    local RewardData = DataMgr.Resource[value]
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = RewardData.ResourceId
    Content.Count = Avatar.Resources[value] and Avatar.Resources[value].Count or 0
    Content.TicketId = value
    Content.Icon = RewardData.Icon
    Content.ItemType = "Resource"
    Content.UIName = RewardData.ResourceName
    Content.Rarity = RewardData.Rarity
    Content.IsShowDetails = false
    Content.ParentWidget = self
    Content.Parent = self
    Content.bClick = false
    Content.Rec = "Entrust"
    Content.OnMouseButtonDownEvent = {
      Obj = self,
      Callback = function()
        if self.CurClickEntrustItem then
          self.CurClickEntrustItem.SelfWidget:SetSelected(false)
        end
        if self.CurClickRewardItem then
          self.CurClickRewardItem.SelfWidget:SetSelected(false)
        end
        self.CurClickEntrustItem = nil
        AudioManager(self):PlayItemSound(self, Content.Id, "Click", Content.ItemType)
        Content.SelfWidget:SetSelected(true)
        self.CurClickEntrustItem = Content
        self.WBP_Com_Tips:SetVisibility(UE4.ESlateVisibility.Visible)
        self.WBP_Com_Tips:RefreshItemInfo(Content, true)
      end
    }
    Content.OverrideDetailsBackObject = self
    
    function Content.OverrideDetailsBackEvent()
      self:SetFocus()
    end
    
    self.ListMultiplier:AddItem(Content)
    if not FirstOwnedEntrust and Content.Count > 0 then
      FirstOwnedEntrust = Content
    end
    if CachedEntrustId and Content.TicketId == CachedEntrustId then
      CachedEntrust = Content
    end
  end
  local DefaultEntrust
  if CachedEntrust and CachedEntrust.Count > 0 then
    DefaultEntrust = CachedEntrust
  else
    DefaultEntrust = FirstOwnedEntrust
  end
  
  local function SelectDefaultEntrustCallback()
    if DefaultEntrust and DefaultEntrust.UI then
      self:SelectDefaultEntrust(DefaultEntrust)
      self:RemoveTimer("SelectDefaultEntrustTimer")
    end
  end
  
  self:AddTimer(0.1, SelectDefaultEntrustCallback, true, 0, "SelectDefaultEntrustTimer")
end

function M:SelectDefaultEntrust(FirstOwnedEntrust)
  if not FirstOwnedEntrust then
    self.Entrust = nil
    self.GamepadEntrust = nil
    self.CurClickEntrustItem = nil
    self:RefreshBigReward(nil)
    return
  end
  self.Entrust = FirstOwnedEntrust
  self.GamepadEntrust = FirstOwnedEntrust
  self.CurClickEntrustItem = FirstOwnedEntrust
  self.Entrust.bClick = true
  if self.Entrust.UI then
    self.Entrust.UI:OnClickSelected()
  else
    self:RefreshBigReward(nil)
  end
end

function M:InitRoomState()
  self.Private01:Init(RoomState.Public, self)
  self.Private02:Init(RoomState.Friend, self)
  self.Private03:Init(RoomState.Guild, self)
  self.Private04:Init(RoomState.Private, self)
  self:SetRoomStateChecked(RoomState.Public, false)
  self:SetRoomStateChecked(RoomState.Friend, false)
  self:SetRoomStateChecked(RoomState.Guild, false)
  self:SetRoomStateChecked(RoomState.Private, false)
  local CachePublic = EMCache:Get("Public") == true
  local CacheFriend = EMCache:Get("Friend") == true
  local bInGuild = self:GetPlayerInGuild()
  self.bInGuild = bInGuild
  self.Private03:InitGuildButton(bInGuild)
  local CachePrivate = EMCache:Get("Private") == true
  local HasCacheSelected = CachePublic or CacheFriend or bInGuild or CachePrivate
  if HasCacheSelected then
    if CachePublic then
      self:ApplyRoomStateRule(RoomState.Public, true)
    end
    if CacheFriend then
      self:ApplyRoomStateRule(RoomState.Friend, true)
    end
    if bInGuild then
      self:ApplyRoomStateRule(RoomState.Guild, true)
    end
    if CachePrivate then
      self:ApplyRoomStateRule(RoomState.Private, true)
    end
  else
    self:ApplyRoomStateRule(RoomState.Public, true)
  end
end

function M:GetRoomStateWidget(State)
  if State == RoomState.Public then
    return self.Private01
  elseif State == RoomState.Friend then
    return self.Private02
  elseif State == RoomState.Guild then
    return self.Private03
  elseif State == RoomState.Private then
    return self.Private04
  end
  return nil
end

function M:SetRoomStateChecked(State, bChecked)
  if State == RoomState.Guild and not self.bInGuild then
    return
  end
  local Checked = bChecked and true or false
  self.RoomStateCheckMap[State] = Checked
  if State == RoomState.Public then
    self.Public = Checked
  elseif State == RoomState.Friend then
    self.Friend = Checked
  elseif State == RoomState.Guild then
    self.Guild = Checked
  elseif State == RoomState.Private then
    self.Private = Checked
  end
  local Widget = self:GetRoomStateWidget(State)
  if Widget and Widget.SetChecked then
    Widget:SetChecked(Checked)
  end
end

function M:GetRoomStateSelectedCount()
  local Count = 0
  if self.Public then
    Count = Count + 1
  end
  if self.Friend then
    Count = Count + 1
  end
  if self.Guild then
    Count = Count + 1
  end
  if self.Private then
    Count = Count + 1
  end
  return Count
end

function M:IsOnlyPrivateSelected()
  return self.Private == true and 1 == self:GetRoomStateSelectedCount()
end

function M:OnRoomStateCheckChanged(State, bChecked)
  if self._UpdatingRoomState then
    return
  end
  if not bChecked and self.RoomStateCheckMap[State] == true and self:GetRoomStateSelectedCount() <= 1 then
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_AsyncCombat_AtLeastOneSelect"))
    self:SetRoomStateChecked(State, true)
    return
  end
  if bChecked then
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_check", nil, nil)
  else
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_uncheck", nil, nil)
  end
  self:ApplyRoomStateRule(State, bChecked)
  if self:IsOnlyPrivateSelected() then
    self.Title_Node:SetVisibility(UE4.ESlateVisibility.Visible)
    self.TextPublic:SetText(GText("UI_AsyncCombat_InviteToPublic"))
  else
    self.Title_Node:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:ApplyRoomStateRule(State, bChecked)
  self._UpdatingRoomState = true
  self:SetRoomStateChecked(State, bChecked)
  if State == RoomState.Public then
    if bChecked then
      self:SetRoomStateChecked(RoomState.Friend, true)
      self:SetRoomStateChecked(RoomState.Guild, true)
      self:SetRoomStateChecked(RoomState.Private, false)
    end
  elseif State == RoomState.Friend then
    if bChecked then
      self:SetRoomStateChecked(RoomState.Private, false)
    else
      self:SetRoomStateChecked(RoomState.Public, false)
    end
  elseif State == RoomState.Guild and self.bInGuild then
    if bChecked then
      self:SetRoomStateChecked(RoomState.Private, false)
    else
      self:SetRoomStateChecked(RoomState.Public, false)
    end
  elseif State == RoomState.Private and bChecked then
    self:SetRoomStateChecked(RoomState.Public, false)
    self:SetRoomStateChecked(RoomState.Friend, false)
    self:SetRoomStateChecked(RoomState.Guild, false)
  end
  if self:GetRoomStateSelectedCount() <= 0 then
    self:SetRoomStateChecked(RoomState.Public, false)
    self:SetRoomStateChecked(RoomState.Friend, false)
    self:SetRoomStateChecked(RoomState.Guild, false)
    self:SetRoomStateChecked(RoomState.Private, true)
  end
  self._UpdatingRoomState = false
end

function M:UpdateSelectBtn(Forbid)
  if Forbid then
    self.Btn:ForbidBtn(true)
  else
    self.Btn:ForbidBtn(false)
  end
end

function M:InitRoomLevel()
  self.ListDifficulty:ClearListItems()
  local CachedLevel = EMCache:Get("CurLevel")
  local LevelTable = {
    50,
    70,
    90,
    110
  }
  local SelectedLevel
  for _, Level in ipairs(LevelTable) do
    if CachedLevel == Level then
      SelectedLevel = CachedLevel
      break
    end
  end
  SelectedLevel = SelectedLevel or LevelTable[1]
  for index, value in ipairs(LevelTable) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Level = value
    Content.bClick = value == SelectedLevel
    if Content.bClick then
      self.CurLevel = Content
    end
    Content.ParentWidget = self
    self.ListDifficulty:AddItem(Content)
  end
end

function M:CreateRoom()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/lianmeiyanyi_btn_common_click", nil, nil)
  if self.Entrust == nil then
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_AsyncCombat_ManualInsufficient"))
    return
  end
  local Count = DataMgr.AsyncCombatEventConstant.AsyncCombat_WeeklyLimit.ConstantValue
  local EventId = DataMgr.AsyncCombatEventConstant.AsyncCombat_EventId.ConstantValue
  local UsedCount = Avatar.AsyncCombats[EventId].CreateRoomTimes
  if Count <= UsedCount then
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_AsyncCombat_HostLimitExceeded"))
    return
  end
  
  local function cb(ErrorCode, RoomInfo)
    if 0 == ErrorCode then
      self.Parent:RefreshPlayerInfo()
      if self.CurLevel then
        EMCache:Set("CurLevel", self.CurLevel.Level)
      end
      if self.CurReward then
        EMCache:Set("CurReward", self.CurReward.Id)
      end
      if self.Entrust then
        EMCache:Set("Entrust", self.Entrust.TicketId)
      end
      EMCache:Set("Public", self.Public)
      EMCache:Set("Friend", self.Friend)
      EMCache:Set("Private", self.Private)
      local Detail = UIManager(self):LoadUINew("CoopDetails", RoomInfo, false)
      if Detail then
        Detail:InitPageTab()
        Detail:Init(RoomInfo)
        Detail.bNeedRefreshHallList = true
        self.bCreated = true
      end
      self:ClickClose()
    else
      UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_AsyncCombat_ConditionNotMet"))
    end
    if 0 == ErrorCode then
      self.Parent:RefreshPlayerInfo()
      self:ClickClose()
      EMCache:Set("Public", self.Public)
      EMCache:Set("Friend", self.Friend)
      EMCache:Set("Private", self.Private)
    end
  end
  
  local Rate = self:GetRate()
  local RoomStateList = {}
  if self.Public then
    table.insert(RoomStateList, 1)
  end
  if self.Friend then
    table.insert(RoomStateList, 2)
  end
  if self.Guild then
    table.insert(RoomStateList, 3)
  end
  if self.Private then
    table.insert(RoomStateList, 4)
  end
  Avatar:AsyncCombatCreateRoom(cb, self.RoomId, Rate, RoomStateList)
end

function M:GetRate()
  local Rate
  if self.Entrust and self.Entrust.TicketId then
    if self.Entrust.TicketId == 206 then
      Rate = 1
    elseif self.Entrust.TicketId == 207 then
      Rate = 2
    elseif self.Entrust.TicketId == 208 then
      Rate = 8
    elseif self.Entrust.TicketId == 209 then
      Rate = 20
    end
  end
  return Rate
end

function M:RefreshBigReward(Id)
  if nil ~= Id then
    self.CurCount = nil
    for key, value in pairs(DataMgr.AsyncCombat) do
      local Info = DataMgr.AsyncCombat[key]
      if Info.ID == Id and Info.Level == self.CurLevel.Level then
        self.RoomId = key
        self.CurCount = Info.Count
        break
      end
    end
  end
  local Rate = self:GetRate()
  local RealCount
  if nil ~= Rate then
    RealCount = self.CurCount * self:GetRate()
  else
    RealCount = self.CurCount
  end
  if nil == Id then
    if self.Entrust then
      self.BigReward.Icon.TextNum:SetText(RealCount)
    else
      self.BigReward.Icon.TextNum:SetText("???")
    end
    return
  end
  local RewardData = DataMgr.Resource[Id]
  local Rarity = RewardData.Rarity
  if 2 == Rarity then
    self.BigReward.Icon.Img_Quality:SetBrush(self.BigReward.Icon.Color_01)
  elseif 3 == Rarity then
    self.BigReward.Icon.Img_Quality:SetBrush(self.BigReward.Icon.Color_02)
  elseif 4 == Rarity then
    self.BigReward.Icon.Img_Quality:SetBrush(self.BigReward.Icon.Color_03)
  elseif 5 == Rarity then
    self.BigReward.Icon.Img_Quality:SetBrush(self.BigReward.Icon.Color_04)
  end
  self.BigReward.Icon.WBP_Com_ItemIcon.Img_Icon:SetBrushFromTexture(LoadObject(DataMgr.Resource[Id].Icon))
  self.BigReward.Icon.Panel_ItemNum:SetVisibility(UE4.ESlateVisibility.Visible)
  if self.Entrust then
    self.BigReward.Icon.TextNum:SetText(RealCount)
  else
    self.BigReward.Icon.TextNum:SetText("???")
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Escape" == InKeyName then
    self:ClickClose()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif "Gamepad_FaceButton_Left" == InKeyName then
    self:CreateRoom()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif "Gamepad_FaceButton_Right" == InKeyName then
    if self.WBP_Com_Tips:HasFocusedDescendants() or self.WBP_Com_Tips:HasAnyUserFocus() then
      self:SetFocus()
    else
      self:ClickClose()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif "Gamepad_Special_Left" == InKeyName and self.WBP_Com_Tips:GetVisibility() == UE4.ESlateVisibility.Visible then
    self.WBP_Com_Tips:TryGoToFirstItem()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  if CurInputType == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputType == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    self:SetFocus()
    self.UsingGamepad = false
    if self.Panel_Key then
      self.Panel_Key:ClearChildren()
    end
    self.Btn.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if self.GamepadEntrust and self.GamepadEntrust.bHover and not self.GamepadEntrust.bClick then
      self.GamepadEntrust.UI:PlayAnimation(self.GamepadEntrust.UI.UnHover)
      self.GamepadEntrust.bHover = false
    end
    if self.GamepadReward and self.GamepadReward.bHover and not self.GamepadReward.bClick then
      self.GamepadReward.UI:PlayAnimation(self.GamepadReward.UI.UnHover)
      self.GamepadReward.bHover = false
    end
  else
    self:SetFocus()
    self:InitPadKeyInfo()
    self.Btn.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Visible)
    self.UsingGamepad = true
  end
end

function M:InitPadKeyInfo()
  self.Panel_Key:ClearChildren()
  local Key_Choose = UIManager(self):_CreateWidgetNew("ComKeyTextDesc")
  local Key_B = UIManager(self):_CreateWidgetNew("ComKeyTextDesc")
  Key_Choose:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    },
    Desc = GText("UI_CTL_Select/Cancel")
  })
  Key_B:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "B"}
    },
    Desc = GText("UI_BACK")
  })
  self.Panel_Key:AddChild(Key_Choose)
  self.Panel_Key:AddChild(Key_B)
  self.Btn.WBP_Com_KeyImg:CreateGamepadKey("X")
end

function M:ClickClose()
  AudioManager(self):SetEventSoundParam(self, "Open", {ToEnd = 1})
  if self.Closing then
    return
  end
  self:BindToAnimationFinished(self.Out, {
    self,
    function()
      self:Close()
    end
  })
  self.Closing = true
  self:PlayAnimation(self.Out)
end

function M:OnEndClose()
  if not self.bCreated and self.Parent then
    self.Parent:SetFocus()
  end
  self.bCreated = false
end

function M:GetPlayerInGuild()
  local Avatar = GWorld:GetAvatar()
  if not (Avatar and Avatar.GuildId) or 0 == Avatar.GuildId then
    return false
  end
  return true
end

return M
