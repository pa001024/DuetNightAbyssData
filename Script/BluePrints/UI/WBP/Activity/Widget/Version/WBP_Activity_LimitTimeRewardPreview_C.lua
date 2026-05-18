require("UnLua")
local TimeUtils = require("Utils.TimeUtils")
local EventVersionUtils = require("BluePrints.UI.WBP.Activity.EventVersionUtils")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:OnLoaded()
  self.CurrentVersion = DataMgr.GlobalConstant.CurrentVersion.ConstantValue
  self.Com_BtnClose.Btn_Close.OnClicked:Add(self, self.OnClickedClose)
  self:InitUI()
  self:SetFocus()
  self.Com_KeyTips:UpdateKeyInfo({
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.OnClickedClose,
          Owner = self
        }
      },
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK"),
      bLongPress = false
    }
  })
  self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
  if ActivityMain then
    ActivityMain.NeedShowVersionView = true
  end
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:AddTimer(0.5, function()
      self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end)
  end
  self:BindOuterListSelectionChanged()
  self.Key_ItemRewards:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.RightThumb
      }
    }
  })
  self.LastFocusIndex = {}
  self:AddTimer(0.3, function()
    local MaxScrollOffset = self.Scroll:GetScrollOffsetOfEnd()
    self.Scroll:SetAlwaysShowScrollbar(MaxScrollOffset > 0)
  end)
end

function M:InitGamepadView()
  local BottomKeyInfo = {
    {
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          ClickCallback = self.OnClickedClose,
          Owner = self
        }
      },
      Desc = GText("UI_Tips_Close")
    }
  }
  self.Com_KeyTips:UpdateKeyInfo(BottomKeyInfo)
end

function M:InitKeyboardView()
  local BottomKeyInfo = {
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.OnClickedClose,
          Owner = self
        }
      },
      Desc = GText("UI_BACK")
    }
  }
  self.Com_KeyTips:UpdateKeyInfo(BottomKeyInfo)
end

function M:BindOuterListSelectionChanged()
  if self._OuterListBound or not self.List_Item then
    return
  end
  self._OuterListBound = true
  self.List_Item.BP_OnItemSelectionChanged:Add(self, self.OnOuterListSelectionChanged)
end

function M:OnOuterListSelectionChanged(Content, IsSelected)
  if not IsSelected or not self.List_Item then
    return
  end
  self.LastFocusSection = Content
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  local index = self.List_Item:GetIndexForItem(Content)
  if index and index >= 0 then
    self.List_Item:ScrollIndexIntoView(index)
  end
end

function M:ScrollOuterListToSection(SectionContent)
  if not SectionContent or not self.List_Item then
    return
  end
  self.LastFocusSection = SectionContent
  local index = self.List_Item:GetIndexForItem(SectionContent)
  if index and index >= 0 then
    self.List_Item:BP_NavigateToItem(SectionContent)
    self.List_Item:ScrollIndexIntoView(index)
  end
end

function M:GetSectionWidgetByContent(SectionContent)
  if not self.List_Item or not SectionContent then
    return nil
  end
  local displayed = self.List_Item:GetDisplayedEntryWidgets()
  if not displayed then
    return nil
  end
  local displayedTable = displayed:ToTable()
  for _, widget in ipairs(displayedTable) do
    if widget and widget.ListItemObject == SectionContent then
      return widget
    end
  end
  return nil
end

function M:SetupOuterSectionNavigation()
  if not self.List_Item or not self.List_Item.ListItems then
    return
  end
  local sectionContents = self.List_Item.ListItems:ToTable()
  if #sectionContents <= 0 then
    return
  end
  for i = 1, #sectionContents do
    local sectionWidget = self:GetSectionWidgetByContent(sectionContents[i])
    if sectionWidget then
      sectionWidget:RefreshInnerNavigation()
    end
  end
  for i = 1, #sectionContents do
    local currentWidget = self:GetSectionWidgetByContent(sectionContents[i])
    if currentWidget then
      local firstEntry = currentWidget:GetFirstEntryWidget()
      local lastEntry = currentWidget:GetLastEntryWidget()
      local prevWidget = self:GetSectionWidgetByContent(sectionContents[i - 1])
      local nextWidget = self:GetSectionWidgetByContent(sectionContents[i + 1])
      local prevLastEntry = prevWidget and prevWidget:GetLastEntryWidget() or nil
      local nextFirstEntry = nextWidget and nextWidget:GetFirstEntryWidget() or nil
      if firstEntry then
        if prevLastEntry then
          firstEntry:SetNavigationRuleExplicit(EUINavigation.Up, prevLastEntry)
        else
          firstEntry:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
        end
      end
      if lastEntry then
        if nextFirstEntry then
          lastEntry:SetNavigationRuleExplicit(EUINavigation.Down, nextFirstEntry)
        else
          lastEntry:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
        end
      end
    end
  end
end

function M:RestoreOuterFocus()
  local targetItem = self.LastFocusItem
  if targetItem and targetItem.SetFocus then
    targetItem:SetFocus()
    return
  end
  if not self.List_Item or not self.List_Item.ListItems then
    return
  end
  local sectionContents = self.List_Item.ListItems:ToTable()
  if #sectionContents <= 0 then
    return
  end
  local targetSection = self.LastFocusSection or sectionContents[1]
  local sectionWidget = self:GetSectionWidgetByContent(targetSection)
  if sectionWidget and sectionWidget.FocusInnerEntryByIndex then
    local sectionIndex = targetSection.Index
    local focusIndex = self.LastFocusIndex[sectionIndex] or 0
    sectionWidget:FocusInnerEntryByIndex(focusIndex)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.CurInputDevice = CurInputDevice
  self.CurGamepadName = CurGamepadName
  if CurInputDevice == ECommonInputType.Gamepad then
    self:RestoreOuterFocus()
    self.Key_ItemRewards:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:InitGamepadView()
  else
    self.IsFocusOnRewardItem = false
    self.Key_ItemRewards:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:InitKeyboardView()
    self:AddTimer(0.1, function()
      self:RestoreOuterFocus()
    end)
  end
end

function M:OnClickedClose()
  AudioManager(self):SetEventSoundParam(nil, "LimitTimeRewardPreview", {ToEnd = 1})
  self:PlayAnimation(self.Out)
  local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
  if ActivityMain then
    ActivityMain.NeedShowVersionView = nil
  end
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Out then
    self:Close()
  end
end

function M:InitUI()
  self.Text_RewardTitle:SetText(GText("UI_Event_BigReward"))
  local VersionContentConfig = DataMgr.VersionContent[self.CurrentVersion]
  if VersionContentConfig then
    self.Text_Title:SetText(GText(VersionContentConfig.VersionName))
    self:UpdateRewardList(VersionContentConfig)
    self.Com_Time:SetPeriodTimeText(GText("UI_Event_VersionTime"), VersionContentConfig.StartTime, VersionContentConfig.EndTime)
    self:InitEventInfo()
    self:SetVersionKV(VersionContentConfig.VerisonKV)
  end
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/common/gift_collection_panel_show", "LimitTimeRewardPreview", nil)
end

function M:SetVersionKV(VersionKV)
  if not VersionKV then
    return
  end
  local tex = LoadObject(VersionKV)
  if not tex then
    return
  end
  self.Image_Icon:SetBrushResourceObject(tex)
end

function M:UpdateRewardList(VersionContentConfig)
  local PreViewReward = VersionContentConfig.RewardViewId
  local RewardContentList = {}
  self.List_RewardItem:ClearListItems()
  self.List_RewardItem.OnCreateEmptyContent:Unbind()
  self.List_RewardItem.OnCreateEmptyContent:Bind(self, function(self)
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = 0
    return Content
  end)
  local RewardInfo = DataMgr.RewardView[PreViewReward]
  if self.RewardList == nil then
    self.RewardList = {}
  end
  if RewardInfo then
    local RewardIds = RewardInfo.Id or {}
    local RewardCounts = RewardInfo.Quantity or {}
    local RewardTypes = RewardInfo.Type or {}
    for i = 1, #RewardIds do
      local ItemId = RewardIds[i]
      local Count = RewardUtils:GetCount(RewardCounts[i])
      local Rarity = ItemUtils.GetItemRarity(ItemId, RewardTypes[i])
      local ItemType = RewardTypes[i]
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.Id = ItemId
      Content.ItemType = ItemType
      Content.Count = Count
      Content.Rarity = Rarity
      Content.Icon = DataMgr[ItemType][ItemId].Icon
      Content.IsShowDetails = true
      Content.ParentWidget = self
      table.insert(RewardContentList, Content)
    end
  end
  for _, ItemContent in ipairs(RewardContentList) do
    self.List_RewardItem:AddItem(ItemContent)
  end
  self:AddTimer(0.2, function()
    if self.List_RewardItem.SetFocus then
      self.List_RewardItem:SetFocus()
    end
  end)
end

function M:InitEventInfo()
  self.List_Item:ClearListItems()
  self.LastFocusSection = nil
  local ver = self.CurrentVersion
  local coll = DataMgr.LimitEventRewardCollection
  local incoming, ing, lock = {}, {}, {}
  if coll and nil ~= ver then
    incoming, ing, lock = EventVersionUtils.GetVersionPreviewEventBuckets(ver, TimeUtils.NowTime())
  end
  local sections = {
    {
      EventList = ing,
      PreviewState = 1,
      TitleKey = "UI_Event_Title_InProgress",
      WSTitleIndex = 0
    },
    {
      EventList = incoming,
      PreviewState = 0,
      TitleKey = "UI_Event_Title_ToBegin",
      WSTitleIndex = 1
    },
    {
      EventList = lock,
      PreviewState = 2,
      TitleKey = "UI_Event_Title_TimeOver",
      WSTitleIndex = 1
    }
  }
  for i, sec in ipairs(sections) do
    local list = sec.EventList or {}
    if #list > 0 then
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.EventList = list
      Content.PreviewState = sec.PreviewState
      Content.TitleKey = sec.TitleKey
      Content.WSTitleIndex = sec.WSTitleIndex
      Content.ParentWidget = self
      Content.Index = i
      self.List_Item:AddItem(Content)
    end
  end
  self.List_Item:RequestPlayEntriesAnim()
  self:AddTimer(1.0, function()
    self:SetupOuterSectionNavigation()
    self:RestoreOuterFocus()
  end)
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = true
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsHandled = self:HandleGamepadInput(InKeyName)
  elseif "Escape" == InKeyName then
    self:OnClickedClose()
  else
    IsHandled = false
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:HandleGamepadInput(InKeyName)
  if "Gamepad_FaceButton_Right" == InKeyName then
    if self.IsFocusOnRewardItem then
      self.IsFocusOnRewardItem = false
      self:RestoreOuterFocus()
      self.Key_ItemRewards:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      if self.LastFocusItem and self.LastFocusItem.OnItemSelectionChanged then
        self.LastFocusItem:OnItemSelectionChanged(true)
      end
    else
      self:OnClickedClose()
    end
    return true
  elseif "Gamepad_RightThumbstick" == InKeyName then
    self.List_RewardItem:SetFocus()
    self.IsFocusOnRewardItem = true
    self.Key_ItemRewards:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return true
  end
  return false
end

return M
