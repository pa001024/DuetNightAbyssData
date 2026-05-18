require("UnLua")
local PageJumpUtils = require("Utils.PageJumpUtils")
local UIUtils = require("Utils.UIUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local BUTTON_STATE_GET = 0
local BUTTON_STATE_NOT_DONE = 1
local BUTTON_STATE_GOT = 2
local BUTTON_STATE_ANIMATION_NAME = {
  [BUTTON_STATE_GET] = "Go",
  [BUTTON_STATE_NOT_DONE] = "Not_Done",
  [BUTTON_STATE_GOT] = "Done"
}

local function SetGTextIfValid(TextWidget, TextKey)
  if TextWidget then
    TextWidget:SetText(TextKey and GText(TextKey) or "")
  end
end

local function SetNumberTextIfValid(TextWidget, Value)
  if TextWidget then
    TextWidget:SetText(tostring(Value or ""))
  end
end

local function SetWidgetVisible(Widget, IsVisible)
  if Widget then
    Widget:SetVisibility(IsVisible and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  end
end

local function StopUINavigation(Widget)
  if not Widget or not Widget.SetNavigationRuleBase then
    return
  end
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Up, UE4.EUINavigationRule.Stop)
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Down, UE4.EUINavigationRule.Stop)
end

local function IsNonEmptyString(Value)
  return type(Value) == "string" and "" ~= Value
end

local function FindWidgetByName(Widget, WidgetName)
  if not Widget or not WidgetName then
    return nil
  end
  if Widget.GetName and Widget:GetName() == WidgetName then
    return Widget
  end
  if Widget.WidgetTree and Widget.WidgetTree.FindWidget then
    local FoundWidget = Widget.WidgetTree:FindWidget(WidgetName)
    if FoundWidget then
      return FoundWidget
    end
  end
  if Widget.GetChildrenCount and Widget.GetChildAt then
    local ChildrenCount = Widget:GetChildrenCount()
    for Index = 0, ChildrenCount - 1 do
      local ChildWidget = Widget:GetChildAt(Index)
      local FoundWidget = FindWidgetByName(ChildWidget, WidgetName)
      if FoundWidget then
        return FoundWidget
      end
    end
  end
  if Widget.GetContent then
    local ContentWidget = Widget:GetContent()
    local FoundWidget = FindWidgetByName(ContentWidget, WidgetName)
    if FoundWidget then
      return FoundWidget
    end
  end
  return nil
end

local function SetCommonItemIconIfValid(IconWidget, IconPath)
  if not (IconWidget and IconPath) or "" == IconPath then
    return
  end
  IconWidget.Icon = IconPath
  if IconWidget.SetIcon then
    IconWidget:SetIcon()
  elseif IconWidget.Init then
    IconWidget:Init({Icon = IconPath, NotInteractive = true})
  end
end

local function GetButtonState(Content)
  if type(Content.ButtonState) == "number" then
    return Content.ButtonState
  end
  if Content.IsGot then
    return BUTTON_STATE_GOT
  end
  if Content.CanJump then
    return BUTTON_STATE_GET
  end
  return BUTTON_STATE_NOT_DONE
end

local function ShouldShowQaGroup(Content)
  return Content and type(Content.ItemIdList) == "table" and #Content.ItemIdList > 1
end

local function GetOwnerUIName(Content)
  if type(Content) ~= "table" then
    return nil
  end
  return Content.OwnerUIName or Content.UIName
end

local function IsAppearanceItemType(ItemType)
  return "Skin" == ItemType or "WeaponSkin" == ItemType
end

local function IsPreviewItemType(ItemType)
  return "Skin" == ItemType or "WeaponSkin" == ItemType or "Mount" == ItemType
end

local function GetAppearanceConfig(ItemType, AppearanceId)
  local ConfigTable = ItemType and DataMgr[ItemType]
  if type(ConfigTable) ~= "table" then
    return nil
  end
  return ConfigTable[AppearanceId]
end

local function GetAppearanceShopItemIdList(Content)
  if type(Content) ~= "table" or not IsAppearanceItemType(Content.ItemType) then
    return nil
  end
  local CandidateIdList = "table" == type(Content.ItemIdList) and Content.ItemIdList or {
    Content.ItemId or Content.Id
  }
  for _, AppearanceId in ipairs(CandidateIdList) do
    local AppearanceConfig = GetAppearanceConfig(Content.ItemType, AppearanceId)
    local ShopItemIdList = AppearanceConfig and AppearanceConfig.GoShopTypeId
    if type(ShopItemIdList) == "table" and next(ShopItemIdList) then
      return ShopItemIdList
    end
  end
  return nil
end

local function BuildCommonItemContent(Content)
  local ItemId = Content.ItemId or Content.Id
  if not (ItemId and Content.ItemType and Content.Icon) or Content.Icon == "" then
    return nil
  end
  return {
    Id = ItemId,
    ItemId = ItemId,
    ItemType = Content.ItemType,
    Rarity = Content.Rarity or 1,
    Icon = Content.Icon,
    IsShowDetails = Content.IsShowDetails,
    HandleMouseDown = Content.IsShowDetails == true,
    bHasGot = GetButtonState(Content) == BUTTON_STATE_GOT
  }
end

function M:OnListItemObjectSet(Content)
  self.bIsFocusable = true
  self.IsGamepadFocused = false
  self.bIsItemTipsOpened = false
  self.bIsQaTipsOpened = false
  self:StopButtonStateAnimations()
  self.CurrentButtonState = nil
  self:StopNativeUINavigation()
  self:ResetQaButton()
  self.Content = Content
  if self.Content then
    self.Content.SelfWidget = self
  end
  self:BindBtnGetEvent()
  self:RefreshView()
end

function M:BP_OnEntryReleased()
  if self.bIsItemTipsOpened or self.bIsQaTipsOpened then
    self.bIsItemTipsOpened = false
    self.bIsQaTipsOpened = false
    self:ShowGamepadKeyTipsWhenItemTipsClosed()
  end
  self:UnBindBtnGetEvent()
  self:ResetQaButton()
  if self.Content then
    self.Content.SelfWidget = nil
  end
  self.Content = nil
  self:SetGamepadFocused(false)
  self:StopButtonStateAnimations()
  self.CurrentButtonState = nil
end

function M:GetBtnGetWidget()
  if self.CachedBtnGetWidget and IsValid(self.CachedBtnGetWidget) then
    return self.CachedBtnGetWidget
  end
  self.CachedBtnGetWidget = self.Com_BtnGet or FindWidgetByName(self, "Com_BtnGet")
  return self.CachedBtnGetWidget
end

function M:GetBtnGetClickArea()
  if self.CachedBtnGetClickArea and IsValid(self.CachedBtnGetClickArea) then
    return self.CachedBtnGetClickArea
  end
  local BtnGetWidget = self:GetBtnGetWidget()
  if not BtnGetWidget then
    return nil
  end
  self.CachedBtnGetClickArea = BtnGetWidget.Button_Area or BtnGetWidget.Btn_Click or FindWidgetByName(BtnGetWidget, "Button_Area") or FindWidgetByName(BtnGetWidget, "Btn_Click")
  return self.CachedBtnGetClickArea
end

function M:StopNativeUINavigation()
  StopUINavigation(self)
  StopUINavigation(self:GetBtnGetWidget())
  StopUINavigation(self:GetBtnGetClickArea())
  local QaButton = self:GetQaButton()
  StopUINavigation(QaButton)
  if QaButton then
    StopUINavigation(QaButton.Btn_Click)
  end
end

function M:BindBtnGetEvent()
  local ClickArea = self:GetBtnGetClickArea()
  if not ClickArea or not ClickArea.OnClicked then
    return
  end
  ClickArea.OnClicked:Remove(self, self.OnBtnGetClicked)
  ClickArea.OnClicked:Add(self, self.OnBtnGetClicked)
end

function M:UnBindBtnGetEvent()
  local ClickArea = self:GetBtnGetClickArea()
  if not ClickArea or not ClickArea.OnClicked then
    return
  end
  ClickArea.OnClicked:Remove(self, self.OnBtnGetClicked)
end

function M:GetAccessMethodContainer()
  if self.CachedAccessMethodContainer and IsValid(self.CachedAccessMethodContainer) then
    return self.CachedAccessMethodContainer
  end
  self.CachedAccessMethodContainer = self.Method_Access or FindWidgetByName(self, "Method_Access") or FindWidgetByName(self, "Root") or self.Group_Qa or FindWidgetByName(self, "Group_Qa")
  return self.CachedAccessMethodContainer
end

function M:CreateAccessHost()
  local MethodContainer = self:GetAccessMethodContainer()
  if not (MethodContainer and MethodContainer.AddChild and MethodContainer.GetChildrenCount) or not MethodContainer.GetChildAt then
    return nil
  end
  local AccessHost = {
    Method = MethodContainer,
    UIName = GetOwnerUIName(self.Content),
    OwnerWidget = self,
    ParentWidget = {
      Parent = self.Content and self.Content.OwnerPopup
    }
  }
  
  function AccessHost:CreateWidgetNew(UIName)
    return UIManager(self.OwnerWidget):_CreateWidgetNew(UIName)
  end
  
  return AccessHost
end

function M:GetCreatedAccessItems(AccessHost)
  local CreatedAccessItems = {}
  local MethodContainer = AccessHost and AccessHost.Method
  if not (MethodContainer and MethodContainer.GetChildrenCount) or not MethodContainer.GetChildAt then
    return CreatedAccessItems
  end
  for Index = 0, MethodContainer:GetChildrenCount() - 1 do
    local ChildWidget = MethodContainer:GetChildAt(Index)
    if ChildWidget and ChildWidget.Parent == AccessHost then
      CreatedAccessItems[#CreatedAccessItems + 1] = ChildWidget
    end
  end
  return CreatedAccessItems
end

function M:ClearCreatedAccessItems(AccessHost, CreatedAccessItems)
  local MethodContainer = AccessHost and AccessHost.Method
  if not MethodContainer or not MethodContainer.RemoveChild then
    return
  end
  local AccessItems = CreatedAccessItems or self:GetCreatedAccessItems(AccessHost)
  for _, AccessItem in ipairs(AccessItems) do
    MethodContainer:RemoveChild(AccessItem)
  end
end

function M:CreateAccessItems(AccessHost, ItemId, ItemType, AccessKey)
  if not (AccessHost and ItemType) or nil == ItemId or not IsNonEmptyString(AccessKey) then
    return nil, nil
  end
  self:ClearCreatedAccessItems(AccessHost)
  PageJumpUtils:GetItemAccess(AccessHost, ItemId, ItemType, AccessKey, GetOwnerUIName(self.Content))
  local CreatedAccessItems = self:GetCreatedAccessItems(AccessHost)
  local AccessItem
  for _, CandidateAccessItem in ipairs(CreatedAccessItems) do
    if CandidateAccessItem and type(CandidateAccessItem.JumpFunc) == "function" then
      AccessItem = CandidateAccessItem
      break
    end
  end
  return CreatedAccessItems, AccessItem
end

function M:TryJumpByAccessItem()
  local Content = self.Content
  if not Content or not IsNonEmptyString(Content.JumpLink) then
    return false
  end
  local AccessKey = Content.JumpLink
  if not DataMgr.Access or not DataMgr.Access[AccessKey] then
    return false
  end
  local AccessHost = self:CreateAccessHost()
  if not AccessHost then
    return false
  end
  local ItemId = Content.ItemId or Content.Id
  local CreatedAccessItems, AccessItem = self:CreateAccessItems(AccessHost, ItemId, Content.ItemType, AccessKey)
  if not AccessItem then
    self:ClearCreatedAccessItems(AccessHost, CreatedAccessItems)
    return false
  end
  if AccessItem.SetVisibility then
    AccessItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  local Jumped = self:ExecuteJumpFuncWithoutClosing(AccessItem.JumpFunc)
  self:ClearCreatedAccessItems(AccessHost, CreatedAccessItems)
  return Jumped
end

function M:ExecuteJumpFuncWithoutClosing(JumpFunc)
  if type(JumpFunc) ~= "function" then
    return false
  end
  local OriginalCloseFrontDialog = PageJumpUtils.CloseFrontDialog
  
  function PageJumpUtils.CloseFrontDialog()
  end
  
  local Ok, Result = pcall(JumpFunc)
  PageJumpUtils.CloseFrontDialog = OriginalCloseFrontDialog
  if not Ok then
    return false
  end
  return false ~= Result
end

function M:TryJumpByAppearanceShop()
  local Content = self.Content
  if not (Content and IsAppearanceItemType(Content.ItemType)) or not IsNonEmptyString(Content.JumpLink) then
    return false
  end
  if string.sub(Content.JumpLink, 1, 5) ~= "Shop_" then
    return false
  end
  local ShopItemIdList = GetAppearanceShopItemIdList(Content)
  if type(ShopItemIdList) ~= "table" then
    return false
  end
  local AccessHost = self:CreateAccessHost()
  if not AccessHost then
    return false
  end
  for _, ShopItemId in ipairs(ShopItemIdList) do
    local ShopItemData = DataMgr.ShopItem and DataMgr.ShopItem[ShopItemId]
    if ShopItemData and ShopItemData.TypeId and IsNonEmptyString(ShopItemData.ItemType) then
      local CreatedAccessItems, AccessItem = self:CreateAccessItems(AccessHost, ShopItemData.TypeId, ShopItemData.ItemType, Content.JumpLink)
      if AccessItem then
        if AccessItem.SetVisibility then
          AccessItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        local Jumped = self:ExecuteJumpFuncWithoutClosing(AccessItem.JumpFunc)
        self:ClearCreatedAccessItems(AccessHost, CreatedAccessItems)
        if Jumped then
          return true
        end
      else
        self:ClearCreatedAccessItems(AccessHost, CreatedAccessItems)
      end
    end
  end
  return false
end

function M:TryJumpByJumpId()
  local Content = self.Content
  if not Content then
    return false
  end
  local JumpId = tonumber(Content.JumpLink)
  if not (JumpId and DataMgr.InterfaceJump) or not DataMgr.InterfaceJump[JumpId] then
    return false
  end
  return PageJumpUtils:JumpToTargetPageByJumpId(JumpId)
end

function M:OnBtnGetClicked()
  if not self.Content or GetButtonState(self.Content) ~= BUTTON_STATE_GET then
    return
  end
  local OwnerPopup = self.Content.OwnerPopup
  if OwnerPopup and OwnerPopup.CaptureTaskPopupViewState then
    OwnerPopup:CaptureTaskPopupViewState(self)
  end
  if self:TryJumpByAppearanceShop() then
    return
  end
  if self:TryJumpByAccessItem() then
    return
  end
  if self:TryJumpByJumpId() then
    return
  end
  if OwnerPopup and OwnerPopup.ClearPendingTaskPopupViewState then
    OwnerPopup:ClearPendingTaskPopupViewState()
  end
end

function M:GetQaButton()
  if self.CachedQaButton and IsValid(self.CachedQaButton) then
    return self.CachedQaButton
  end
  self.CachedQaButton = self.Com_BtnQa or FindWidgetByName(self, "Com_BtnQa")
  return self.CachedQaButton
end

function M:InitQaButton()
  local QaButton = self:GetQaButton()
  if not QaButton or not QaButton.Init then
    return nil
  end
  StopUINavigation(QaButton)
  StopUINavigation(QaButton.Btn_Click)
  if not self.QaButtonInitialized then
    QaButton:Init({
      OwnerWidget = self,
      TextContent = GText("UI_AppearanceCollect_ObtainSameSeries"),
      OnMenuOpenChangedCallBack = self.OnQaTipsMenuOpenChanged
    })
    self.QaButtonInitialized = true
  else
    QaButton.OwnerWidget = self
    QaButton.TextContent = GText("UI_AppearanceCollect_ObtainSameSeries")
    QaButton.OnMenuOpenChangedCallBack = self.OnQaTipsMenuOpenChanged
  end
  return QaButton
end

function M:ResetQaButton()
  local QaButton = self:GetQaButton()
  if not QaButton then
    return
  end
  if QaButton.IsMenuAnchorOpen and QaButton.CloseMenuAnchor and QaButton:IsMenuAnchorOpen() then
    QaButton:CloseMenuAnchor()
    return
  end
  if QaButton.ResetStyle then
    QaButton:ResetStyle()
  elseif QaButton.SetChecked then
    QaButton:SetChecked(false)
  end
end

function M:RefreshQaGroup()
  local ShouldShow = ShouldShowQaGroup(self.Content)
  if self.Group_Qa then
    self.Group_Qa:SetVisibility(ShouldShow and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  end
  if not ShouldShow then
    self:ResetQaButton()
    self:UpdateQaGamepadKeyVisibility()
    return
  end
  self:InitQaButton()
  self:InitGamepadQaKey()
  self:UpdateQaGamepadKeyVisibility()
end

function M:InitGamepadQaKey()
  if not self.Com_KeyImg or self.QaGamepadKeyInitialized then
    return
  end
  self.Com_KeyImg:CreateGamepadKey(UIConst.GamePadImgKey.RightThumb)
  self.Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.QaGamepadKeyInitialized = true
end

function M:UpdateQaGamepadKeyVisibility()
  if not self.Com_KeyImg then
    return
  end
  local ShouldShow = self:ShouldShowGamepadActionKeys() and ShouldShowQaGroup(self.Content)
  self.Com_KeyImg:SetVisibility(ShouldShow and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
end

function M:IsAnyTipsOpened()
  return self.bIsItemTipsOpened == true or true == self.bIsQaTipsOpened
end

function M:ShouldShowGamepadActionKeys()
  return self.IsGamepadFocused == true and UIUtils.IsGamepadInput() and not self:IsAnyTipsOpened()
end

function M:SetGamepadFocused(IsFocused)
  self.IsGamepadFocused = true == IsFocused
  if self.IsGamepadFocused then
    if self.Hover then
      self:PlayAnimation(self.Hover)
    end
    self:UpdateBtnGetGamepadVisibility(self:ShouldShowGamepadActionKeys())
  else
    if self.Hover then
      self:StopAnimation(self.Hover)
    end
    if self.Normal then
      self:PlayAnimation(self.Normal)
    end
    if self.Content then
      self:SetButtonState(GetButtonState(self.Content))
    end
    self:UpdateBtnGetGamepadVisibility(false)
  end
  self:UpdateQaGamepadKeyVisibility()
end

function M:UpdateBtnGetGamepadVisibility(bShow)
  local BtnGetWidget = self:GetBtnGetWidget()
  if not BtnGetWidget then
    return
  end
  if bShow then
    BtnGetWidget.OverrideGamePadVisibilityOp = nil
    if BtnGetWidget.SetGamePadVisibility then
      BtnGetWidget:SetGamePadVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
  else
    if BtnGetWidget.OverrideGamePadVisibility then
      BtnGetWidget:OverrideGamePadVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if BtnGetWidget.SetGamePadVisibility then
      BtnGetWidget:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  local OwnerPopup = self.Content and self.Content.OwnerPopup
  if OwnerPopup and OwnerPopup.OnSubTaskItemGamepadFocusReceived then
    OwnerPopup:OnSubTaskItemGamepadFocusReceived(self)
  end
  return UIUtils.Handled
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  self:UpdateQaGamepadKeyVisibility()
  self:UpdateBtnGetGamepadVisibility(self:ShouldShowGamepadActionKeys())
end

function M:OnGamepadConfirm()
  if not self.Content or GetButtonState(self.Content) ~= BUTTON_STATE_GET then
    return false
  end
  if self.Pressed then
    self:PlayAnimation(self.Pressed)
  end
  self:OnBtnGetClicked()
  return true
end

function M:FocusSelfAfterItemTipsClosed()
  if self.SetFocus then
    self:SetFocus()
  end
  local OwnerPopup = self.Content and self.Content.OwnerPopup
  if OwnerPopup and OwnerPopup.OnSubTaskItemGamepadFocusReceived then
    OwnerPopup:OnSubTaskItemGamepadFocusReceived(self)
  end
end

function M:HideGamepadKeyTipsWhenItemTipsOpened()
  local OwnerPopup = self.Content and self.Content.OwnerPopup
  if OwnerPopup and OwnerPopup.Com_KeyTips then
    OwnerPopup.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  self:UpdateQaGamepadKeyVisibility()
  self:UpdateBtnGetGamepadVisibility(false)
end

function M:ShowGamepadKeyTipsWhenItemTipsClosed()
  local OwnerPopup = self.Content and self.Content.OwnerPopup
  if OwnerPopup and OwnerPopup.RefreshBottomKeyTips and not self:IsAnyTipsOpened() then
    OwnerPopup:RefreshBottomKeyTips()
  end
  self:UpdateQaGamepadKeyVisibility()
  self:UpdateBtnGetGamepadVisibility(self:ShouldShowGamepadActionKeys())
end

function M:OnQaTipsMenuOpenChanged(bIsOpen)
  self.bIsQaTipsOpened = true == bIsOpen
  if not UIUtils.IsGamepadInput() then
    self:UpdateQaGamepadKeyVisibility()
    self:UpdateBtnGetGamepadVisibility(false)
    return
  end
  if self.bIsQaTipsOpened then
    self:HideGamepadKeyTipsWhenItemTipsOpened()
  else
    self:ShowGamepadKeyTipsWhenItemTipsClosed()
  end
end

function M:CloseItemTipsAndFocusSelf()
  local ComItem = self:GetComItem()
  local MenuAnchor = ComItem and ComItem.Item and ComItem.Item.ItemDetails_MenuAnchor
  if MenuAnchor and MenuAnchor.CloseItemDetailsWidget then
    MenuAnchor:CloseItemDetailsWidget(true)
  end
  self.bIsItemTipsOpened = false
  self:ShowGamepadKeyTipsWhenItemTipsClosed()
  self:FocusSelfAfterItemTipsClosed()
end

function M:OpenItemTips()
  local ComItem = self:GetComItem()
  if not ComItem or not ComItem.OpenItemMenu then
    return false
  end
  self.bIsItemTipsOpened = true
  self:HideGamepadKeyTipsWhenItemTipsOpened()
  local MenuAnchor = ComItem.Item and ComItem.Item.ItemDetails_MenuAnchor
  if MenuAnchor and MenuAnchor.SetLastFocusWidget then
    MenuAnchor:SetLastFocusWidget(self)
  end
  ComItem:OpenItemMenu()
  local CommonItemDetails = MenuAnchor and MenuAnchor.CommonItemDetails
  if CommonItemDetails then
    CommonItemDetails.OverrideDetailsBackObj = self
    CommonItemDetails.OverrideDetailsBackEvent = self.CloseItemTipsAndFocusSelf
  end
  return true
end

function M:JumpToItemPreview()
  local Content = self.Content
  if not Content or not IsPreviewItemType(Content.ItemType) then
    return false
  end
  local ItemId = Content.ItemId or Content.Id
  if not ItemId then
    return false
  end
  local OwnerUIName = GetOwnerUIName(Content)
  if OwnerUIName and DataMgr.SystemUI and DataMgr.SystemUI[OwnerUIName] and DataMgr.SystemUI[OwnerUIName].IsBanAccess then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_COMMONPOP_TITLE_100059"))
    return true
  end
  local OwnerPopup = Content.OwnerPopup
  if OwnerPopup and OwnerPopup.CaptureTaskPopupViewState then
    OwnerPopup:CaptureTaskPopupViewState(self)
  end
  PageJumpUtils:JumpToSkinPreview({
    TypeId = ItemId,
    ItemType = Content.ItemType,
    SinglePreview = true,
    HidePurchase = true
  }, OwnerPopup or self)
  return true
end

function M:OpenItemTipsOrPreview()
  if self:JumpToItemPreview() then
    return true
  end
  return self:OpenItemTips()
end

function M:OpenQaTips()
  if not ShouldShowQaGroup(self.Content) then
    return false
  end
  local QaButton = self:InitQaButton()
  if not QaButton then
    return false
  end
  if QaButton.IsMenuAnchorOpen and QaButton:IsMenuAnchorOpen() then
    self:OnQaTipsMenuOpenChanged(true)
    return true
  end
  if QaButton.Btn_Click and QaButton.Btn_Click.SetChecked then
    QaButton.Btn_Click:SetChecked(true)
  elseif QaButton.SetChecked then
    QaButton:SetChecked(true)
  end
  if QaButton.OpenMenuAnchor then
    QaButton:OpenMenuAnchor()
  end
  return true
end

function M:ToggleQaTips()
  if not ShouldShowQaGroup(self.Content) then
    return false
  end
  local QaButton = self:InitQaButton()
  if not QaButton then
    return false
  end
  if QaButton.IsMenuAnchorOpen and QaButton:IsMenuAnchorOpen() then
    return self:CloseQaTips()
  end
  return self:OpenQaTips()
end

function M:CloseQaTips(ShouldFocusSelf)
  local QaButton = self:GetQaButton()
  if not (QaButton and QaButton.IsMenuAnchorOpen) or not QaButton:IsMenuAnchorOpen() then
    return false
  end
  if QaButton.Btn_Click and QaButton.Btn_Click.SetChecked then
    QaButton.Btn_Click:SetChecked(false)
  elseif QaButton.SetChecked then
    QaButton:SetChecked(false)
  end
  if QaButton.CloseMenuAnchor then
    QaButton:CloseMenuAnchor()
  end
  if false ~= ShouldFocusSelf then
    self:FocusSelfAfterItemTipsClosed()
  end
  return true
end

function M:RefreshView()
  if not self.Content then
    return
  end
  self:StopNativeUINavigation()
  local ButtonState = GetButtonState(self.Content)
  SetGTextIfValid(self.Text_ItemName, self.Content.ItemName)
  SetNumberTextIfValid(self.Text_NumGet, self.Content.ScoreValue or 0)
  SetCommonItemIconIfValid(self:GetScoreIconWidget(), self.Content.ScoreIcon)
  SetGTextIfValid(self.Tex_Explanation, "UI_AppearanceCollect_Description")
  SetGTextIfValid(self.Text_NotDone, self.Content.NotDoneText or "UI_AppearanceCollect_StatusPending")
  SetGTextIfValid(self.Text_Got, self.Content.GotText or "UI_AppearanceCollect_StatusObtained")
  if self.Com_BtnGet and self.Com_BtnGet.Text_Button then
    SetGTextIfValid(self.Com_BtnGet.Text_Button, self.Content.GetText or "UI_AppearanceCollect_GoToObtain")
  end
  self:RefreshQaGroup()
  SetWidgetVisible(self.Image_Got, ButtonState == BUTTON_STATE_GOT)
  self:SetButtonState(ButtonState)
  self:RefreshComItem()
  self:UpdateBtnGetGamepadVisibility(self:ShouldShowGamepadActionKeys())
end

function M:StopButtonStateAnimations()
  for _, StateAnimationName in pairs(BUTTON_STATE_ANIMATION_NAME) do
    if self[StateAnimationName] then
      self:StopAnimation(self[StateAnimationName])
    end
  end
end

function M:SetButtonState(ButtonState)
  self.CurrentButtonState = ButtonState
  if self.Content then
    self.Content.ButtonState = ButtonState
  end
  self:StopButtonStateAnimations()
  if self.WS_Btn then
    self.WS_Btn:SetActiveWidgetIndex(ButtonState)
  end
  self:PlayButtonStateAnimation(ButtonState)
  if self.WS_Btn then
    self.WS_Btn:SetActiveWidgetIndex(ButtonState)
  end
end

function M:PlayButtonStateAnimation(ButtonState)
  local AnimationName = BUTTON_STATE_ANIMATION_NAME[ButtonState]
  if not AnimationName then
    return
  end
  if self[AnimationName] then
    self:PlayAnimation(self[AnimationName])
  end
end

function M:GetComItem()
  if self.CachedComItem and IsValid(self.CachedComItem) then
    return self.CachedComItem
  end
  self.CachedComItem = self.Com_Item or FindWidgetByName(self, "Com_Item")
  return self.CachedComItem
end

function M:GetScoreIconWidget()
  if self.CachedScoreIconWidget and IsValid(self.CachedScoreIconWidget) then
    return self.CachedScoreIconWidget
  end
  self.CachedScoreIconWidget = self.Com_ItemIcon or FindWidgetByName(self, "Com_ItemIcon")
  return self.CachedScoreIconWidget
end

function M:RefreshComItem()
  local ComItem = self:GetComItem()
  if not ComItem or not ComItem.Init then
    return
  end
  local ItemContent = BuildCommonItemContent(self.Content)
  if ItemContent then
    ComItem:Init(ItemContent)
  else
    ComItem:Init({Id = 0, ItemType = "Resource"})
  end
  local Rarity = (self.Content and self.Content.Rarity) - 2
  if Rarity and self["Lv_0" .. Rarity] then
    self:PlayAnimation(self["Lv_0" .. Rarity])
  end
end

return M
