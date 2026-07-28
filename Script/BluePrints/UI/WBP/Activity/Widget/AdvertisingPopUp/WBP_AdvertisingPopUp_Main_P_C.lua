require("UnLua")
local CoroutineUtils = require("CoroutineUtils")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local LoginPopUpModel = require("BluePrints.UI.WBP.Activity.Widget.AdvertisingPopUp.LoginPopUpModel")
local DEFAULT_TITLE_BP = "/Game/UI/WBP/Activity/Widget/14DaySign/WBP_Activity_14DaySign_Title.WBP_Activity_14DaySign_Title"
local DEFAULT_BG_BP = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/AdvertisingPopUp/Bg/WBP_AdvertisingPopUp_Bg_01.WBP_AdvertisingPopUp_Bg_01'"

function M:Initialize(Initializer)
  self.CurTabIndex = -1
  self.RewardCount = 0
  self.IsOnlyOneTab = false
  self.AllCurrentAdvertisingPages = {}
  self.CacheTitles = {}
  self.CacheBg = {}
  self.IsFocusReward = false
  self.IsOpenTips = false
  self.CurContent = nil
  self.IsSevenDaysClick = false
end

function M:Construct()
  self.BtnReward:SetText(GText("UI_GameEvent_EventPortal_Goto"))
  self.TextTips:SetText(GText("UI_LoginPopUp_7Day"))
  self.TextRewardTitle:SetText(GText("UI_AppearanceScore_RewardPreview"))
end

function M:OnLoaded(...)
  self.NeedShowPopInfo = (...)
  if not self.NeedShowPopInfo then
    self.NeedShowPopInfo = LoginPopUpModel:GetNeedOpenLoginPopUp()
  end
  self.MaxTabNum = #self.NeedShowPopInfo
  self:InitKeyInfo()
  self:InitTabs()
  self:BindEvents()
  self:SetFocus()
  AudioManager(self):PlayUISound(self, "event:/ui/common/recommend_page_show", "AdvertisingPopUpMain", nil)
end

function M:InitKeyInfo()
  if self:IsMobile() then
    self.Ws_Key_L:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Ws_Key_R:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  self.Key_LeftText.IsButton = false
  self.Key_RightText.IsButton = false
  self.Key_Left.IsButton = false
  self.Key_Right.IsButton = false
  self.Key_LeftText:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        Text = UE4.EKeys.Q.KeyName
      }
    },
    bAllowForbid = true
  })
  self.Key_RightText:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        Text = UE4.EKeys.E.KeyName
      }
    },
    bAllowForbid = true
  })
  self.Key_Left:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LB"}
    },
    bAllowForbid = true
  })
  self.Key_Right:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "RB"}
    },
    bAllowForbid = true
  })
  self.KeyReward:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    },
    bAllowForbid = true
  })
  self.CheckBox:InitGamepadKey("Menu", false)
  self.BtnReward:SetGamePadImg("A")
  self:SetBottomKeyInfo(false)
end

function M:SetBottomKeyInfo(IsShowReward)
  local BottomKeyInfo = {}
  if IsShowReward then
    table.insert(BottomKeyInfo, {
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "A",
          Owner = self
        }
      },
      Desc = GText("UI_Controller_CheckDetails")
    })
  end
  table.insert(BottomKeyInfo, {
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "B",
        ClickCallback = self.OnReturnKeyDown,
        Owner = self
      }
    },
    Desc = GText("UI_BACK")
  })
  self.Com_KeyTips:UpdateKeyInfo(BottomKeyInfo)
end

function M:RefreshBottomKeyInfo()
  if not self.UsingGamepad then
    self.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  self:SetBottomKeyInfo(self.IsFocusReward)
  self.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function M:BindEvents()
  self.BtnReward:BindEventOnClicked(self, self.OnBtnJumpClicked)
  self.CheckBox:BindEventOnClicked({
    Inst = self,
    Func = self.OnSevenDaysClicked
  })
  self.WBP_Com_BtnClose02:Init("Close", self, self.OnReturnKeyDown)
  self.ArrowBtnL:BindEventOnClicked(self, self.TabToLeft)
  self.ArrowBtnR:BindEventOnClicked(self, self.TabToRight)
  if self.TileView_MailGift and self.TileView_MailGift.BP_OnItemSelectionChanged then
    self.TileView_MailGift.BP_OnItemSelectionChanged:Clear()
    self.TileView_MailGift.BP_OnItemSelectionChanged:Add(self, self.OnRewardItemSelectionChanged)
  end
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:InitTabs()
  self.Tabs = {}
  local MaxTabNum = self.MaxTabNum
  self.IsOnlyOneTab = 1 == MaxTabNum
  for i = 1, 3 do
    local TabItem = self["WBP_Activity_TryOut_CharacterItem_" .. i]
    local Visibility = UE4.ESlateVisibility.Collapsed
    if i <= MaxTabNum then
      table.insert(self.Tabs, TabItem)
      Visibility = UE4.ESlateVisibility.SelfHitTestInvisible
    end
    if self.IsOnlyOneTab then
      Visibility = UE4.ESlateVisibility.Collapsed
    end
    TabItem:SetVisibility(Visibility)
  end
  local LastShowTabId = EMCache:Get("AdvertisingPopUpShowID", true)
  local CurShowTabId = 1
  for i, Tab in ipairs(self.Tabs) do
    local Index = i
    local PopId = self.NeedShowPopInfo[i].PopId
    if LastShowTabId and PopId == LastShowTabId and i < self.MaxTabNum then
      CurShowTabId = i + 1
    end
    Tab:Init({
      Index = Index,
      PopId = PopId,
      ClickCallback = self.OnTabClick
    }, self)
    LoginPopUpModel:UpdateLoginPopUpRecord(PopId)
  end
  local PopInfo = self.Tabs[CurShowTabId]:GetPopInfo()
  if PopInfo and PopInfo.PopId then
    EMCache:Set("AdvertisingPopUpShowID", PopInfo.PopId, true)
  end
  self.Tabs[CurShowTabId]:SetIsSelected(true)
  if self.IsOnlyOneTab then
    self.Ws_Key_L:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Ws_Key_R:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:OnTabClick(TabIndex)
  if self.CurTabIndex == TabIndex then
    return
  end
  TabIndex = TabIndex or 1
  self.CurTabIndex = TabIndex
  for i, Tab in ipairs(self.Tabs) do
    if i ~= TabIndex then
      Tab:SetIsSelected(false)
    end
  end
  self:RefreshLeftAndRightBtn()
  local PopInfo = self.Tabs[TabIndex]:GetPopInfo()
  self:RefreshText(PopInfo)
  self:InitReward(PopInfo)
  self:GenerateBgBp(PopInfo)
  if not PopInfo.PopInterfaceJump then
    self.BtnReward:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    self.BtnReward:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
end

function M:GenerateBgBp(PopInfo)
  local PopId = PopInfo and PopInfo.PopId or self.CurTabIndex
  local AdvertisingPage = self.AllCurrentAdvertisingPages[PopId]
  if nil == AdvertisingPage then
    local AdvertisingPageName = "AdvertisingPageName_" .. PopId
    local AdvertisingPageBp = PopInfo.BgBp or DEFAULT_BG_BP
    CoroutineUtils.RunAsyncTask(self, AdvertisingPageName, function(CoroutineObj)
      local AdvertisingPage
      if CommonUtils.GetDeviceTypeByPlatformName(self) == CommonConst.CLIENT_DEVICE_TYPE.PC then
        AdvertisingPage = UIManager(self):CreateWidgetAsync(AdvertisingPageName, CoroutineObj, AdvertisingPageBp)
      else
        AdvertisingPage = UIManager(self):CreateWidgetAsync(AdvertisingPageName, CoroutineObj, AdvertisingPageBp)
      end
      if nil ~= AdvertisingPage then
        self:HideAllCachedBg()
        self:AddAdvertisingPageToNewNode(AdvertisingPage)
        self:SetDescTextType(AdvertisingPage)
        self.AllCurrentAdvertisingPages[PopId] = AdvertisingPage
      end
      self:PlayAnimation(self.Switch)
      AudioManager(self):PlayUISound(self, "event:/ui/common/recommend_page_change", nil, nil)
    end)
  else
    self:HideAllCachedBg()
    AdvertisingPage:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:SetDescTextType(AdvertisingPage)
    self:PlayAnimation(self.Switch)
    AudioManager(self):PlayUISound(self, "event:/ui/common/recommend_page_change", nil, nil)
  end
end

function M:HideAllCachedBg()
  for _, CachedPage in pairs(self.AllCurrentAdvertisingPages) do
    if IsValid(CachedPage) then
      CachedPage:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
end

function M:RefreshText(PopInfo)
  if not PopInfo then
    return
  end
  local PopId = PopInfo.PopId or self.CurTabIndex
  local TitleWidget = self.CacheTitles[PopId]
  if nil == TitleWidget and PopInfo.PopTitle then
    local TitleBp = PopInfo.TitleBp or DEFAULT_TITLE_BP
    TitleWidget = UIManager(self):CreateWidget(TitleBp)
    if nil == TitleWidget then
      DebugPrint("Failed to create TitleWidget for PopId: " .. tostring(PopId))
      return
    end
    if TitleWidget and TitleWidget.Condition then
      TitleWidget.Condition = false
      TitleWidget:SetTitleSingle()
    end
    if TitleWidget.Text_Title then
      TitleWidget.Text_Title:SetText(GText(PopInfo.PopTitle))
    end
    if TitleWidget.Text_MainTitle then
      TitleWidget.Text_MainTitle:SetText(GText(PopInfo.PopTitle))
    end
    if 5 == PopId and TitleWidget.Text_Subtitle then
      TitleWidget.Text_Subtitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      TitleWidget.Text_Subtitle:SetText(GText("UI_AsyncCombat_CombatRoom"))
    end
    self.Title:AddChildToOverlay(TitleWidget)
    self.CacheTitles[PopId] = TitleWidget
  end
  self:HideAllCachedTitles()
  TitleWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.Text_Desc:SetText(GText(PopInfo.PopDes) or "")
  self.Text_Desc_White:SetText(GText(PopInfo.PopDes) or "")
end

function M:HideAllCachedTitles()
  for _, CachedTitle in pairs(self.CacheTitles) do
    if IsValid(CachedTitle) then
      CachedTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
end

function M:SetDescTextType(AdvertisingPage)
  if AdvertisingPage then
    local index = 0
    if AdvertisingPage and AdvertisingPage.WS_DescIndex then
      local descIndex = tonumber(AdvertisingPage.WS_DescIndex)
      if descIndex and descIndex >= 0 and descIndex <= 1 then
        index = math.floor(descIndex)
      end
      if self.WS_TextDesc ~= nil then
        self.WS_TextDesc:SetActiveWidgetIndex(index)
      end
    end
  end
end

function M:AddAdvertisingPageToNewNode(AdvertisingPage)
  if nil ~= AdvertisingPage then
    self.Overlay_Bg:AddChildToOverlay(AdvertisingPage)
    local ContentOverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(AdvertisingPage)
    ContentOverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    ContentOverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
  end
end

function M:InitReward(PopInfo)
  self.TileView_MailGift:ClearListItems()
  if not PopInfo or not PopInfo.RewardView then
    self.Reward_Panel:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.RewardCount = 0
    return
  end
  local RewardList = RewardUtils:GetRewardViewInfoById(PopInfo.RewardView)
  local RewardCount = 0
  for _, ItemData in pairs(RewardList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = ItemData.Id
    Content.Icon = ItemUtils.GetItemIconPath(ItemData.Id, ItemData.Type)
    Content.ParentWidget = self
    Content.ItemType = ItemData.Type
    Content.Rarity = ItemData.Rarity or 1
    Content.IsShowDetails = false
    Content.Count = ItemData.Quantity and ItemData.Quantity[1]
    Content.Root = self
    Content.IsShowDetails = true
    Content.OnMenuOpenChangedEvents = {
      Obj = self,
      Callback = self.ItemMenuAnchorChanged
    }
    self.TileView_MailGift:AddItem(Content)
    RewardCount = RewardCount + 1
  end
  self.TileView_MailGift:RequestPlayEntriesAnim()
  if 0 == RewardCount then
    self.Reward_Panel:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    self.Reward_Panel:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  self.RewardCount = RewardCount
end

function M:ItemMenuAnchorChanged(bIsOpen)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  self.IsOpenTips = bIsOpen
  self:ShowBottomKeyInfo(not bIsOpen)
  if false == bIsOpen then
    self:SetFocus()
  end
end

function M:TabToLeft()
  if self.IsOnlyOneTab then
    return
  end
  local TargetIndex = self.CurTabIndex - 1
  if TargetIndex < 1 then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_add", nil, nil)
  self.Tabs[TargetIndex]:SetIsSelected(true)
end

function M:TabToRight()
  if self.IsOnlyOneTab then
    return
  end
  local TargetIndex = self.CurTabIndex + 1
  if TargetIndex > self.MaxTabNum then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_add", nil, nil)
  self.Tabs[TargetIndex]:SetIsSelected(true)
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
  if self:IsMobile() then
    return
  end
  local IsUseKeyAndMouse = CurInputType == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    self.UsingGamepad = false
    self.KeyReward:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    self.UsingGamepad = true
    self.KeyReward:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  self:EnterRewardFocusMode(false)
  self:ShowGamepadImg(self.UsingGamepad)
  self:RefreshLeftAndRightKey(self.UsingGamepad)
  self:RefreshBottomKeyInfo()
end

function M:RefreshLeftAndRightBtn()
  if self.IsOnlyOneTab then
    return
  end
  if self.CurTabIndex > 1 then
    self.ArrowBtnL:ForbidBtn(false)
  else
    self.ArrowBtnL:ForbidBtn(true)
  end
  if self.CurTabIndex < self.MaxTabNum then
    self.ArrowBtnR:ForbidBtn(false)
  else
    self.ArrowBtnR:ForbidBtn(true)
  end
end

function M:RefreshLeftAndRightKey(IsShowGamePadMode)
  if self.IsOnlyOneTab then
    self.Ws_Key_L:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Ws_Key_R:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.ArrowBtnL:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.ArrowBtnR:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  else
    self.Ws_Key_L:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Ws_Key_R:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.ArrowBtnL:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.ArrowBtnR:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  if IsShowGamePadMode then
    self.Ws_Key_L:SetActiveWidgetIndex(0)
    self.Ws_Key_R:SetActiveWidgetIndex(0)
  else
    self.Ws_Key_L:SetActiveWidgetIndex(1)
    self.Ws_Key_R:SetActiveWidgetIndex(1)
  end
end

function M:ShowGamepadImg(IsShow)
  self.BtnReward:SetGamePadIconVisible(IsShow)
  self.CheckBox:HideKey(not IsShow)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:Handle_KeyDownOnGamePad(InKeyName)
  elseif "Escape" == InKeyName then
    IsEventHandled = true
    self:OnReturnKeyDown()
  elseif InKeyName == UE4.EKeys.Q.KeyName then
    IsEventHandled = true
    self:TabToLeft()
  elseif InKeyName == UE4.EKeys.E.KeyName then
    IsEventHandled = true
    self:TabToRight()
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:Handle_KeyDownOnGamePad(InKeyName)
  local IsEventHandled = false
  if not self.IsFocusReward and InKeyName == UIConst.GamePadKey.LeftShoulder then
    IsEventHandled = true
    self:TabToLeft()
  elseif not self.IsFocusReward and InKeyName == UIConst.GamePadKey.RightShoulder then
    IsEventHandled = true
    self:TabToRight()
  elseif not self.IsFocusReward and InKeyName == UIConst.GamePadKey.LeftThumb then
    local PopInfo = self.Tabs[self.CurTabIndex] and self.Tabs[self.CurTabIndex]:GetPopInfo()
    if PopInfo.RewardView and self.RewardCount > 0 then
      IsEventHandled = true
      self:EnterRewardFocusMode(true)
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    IsEventHandled = true
    if not self.IsFocusReward then
      self:OnBtnJumpClicked()
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
    IsEventHandled = true
    self:OnReturnKeyDown()
  elseif not self.IsFocusReward and InKeyName == UIConst.GamePadKey.SpecialRight then
    self.CheckBox:Activate()
    self:OnSevenDaysClicked()
  end
  return IsEventHandled
end

function M:OnRewardItemSelectionChanged(Content, IsSelected)
  if not IsSelected or not Content then
    return
  end
  self.CurContent = Content
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.UsingGamepad then
    if self.IsFocusReward and self.CurContent then
      self.TileView_MailGift:BP_SetSelectedItem(self.CurContent)
      self.TileView_MailGift:BP_NavigateToItem(self.CurContent)
    else
      self.IsFocusReward = false
    end
    self:RefreshGamepadType(self.IsFocusReward)
  end
  return UIUtils.Handled
end

function M:EnterRewardFocusMode(IsEnter)
  self.CurContent = nil
  self.IsFocusReward = IsEnter
  if IsEnter and self.RewardCount > 0 then
    local Content = self.TileView_MailGift:GetItemAt(0)
    if Content then
      self.IsFocusReward = Content
      self.TileView_MailGift:BP_SetSelectedItem(Content)
      self.TileView_MailGift:BP_NavigateToItem(Content)
    else
      IsEnter = false
      self:SetFocus()
    end
  else
    self:SetFocus()
  end
  self:RefreshGamepadType(IsEnter)
end

function M:RefreshGamepadType(IsEnter)
  local CurVisibility = IsEnter and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.SelfHitTestInvisible
  self.Ws_Key_L:SetVisibility(CurVisibility)
  self.Ws_Key_R:SetVisibility(CurVisibility)
  self:ShowGamepadImg(not IsEnter)
  self:RefreshBottomKeyInfo()
end

function M:ShowBottomKeyInfo(IsShow)
  local CurVisibility = IsShow and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed
  self.Com_KeyTips:SetVisibility(CurVisibility)
end

function M:OnBtnJumpClicked()
  if not self.CurTabIndex then
    return
  end
  local PopInfo = self.Tabs[self.CurTabIndex] and self.Tabs[self.CurTabIndex]:GetPopInfo()
  if not PopInfo then
    return
  end
  if not PopInfo.PopInterfaceJump then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_btn_click_normal", nil, nil)
  PageJumpUtils:JumpToTargetPageByJumpId(PopInfo.PopInterfaceJump)
end

function M:OnSevenDaysClicked()
  self.IsSevenDaysClick = not self.IsSevenDaysClick
  local PopIds = {}
  for _, PopInfo in ipairs(self.NeedShowPopInfo) do
    table.insert(PopIds, PopInfo.PopId)
  end
  LoginPopUpModel:SetLoginPopUpNoPopSevenDays(self.IsSevenDaysClick, PopIds, nil)
end

function M:OnReturnKeyDown()
  if self.IsFocusReward then
    self:EnterRewardFocusMode(false)
  else
    AudioManager(self):SetEventSoundParam(self, "AdvertisingPopUpMain", {ToEnd = 1})
    self:Close()
  end
end

function M:Destruct()
  self.Overlay_Bg:ClearChildren()
  self.Title:ClearChildren()
  self.Super.Destruct(self)
end

function M:IsMobile()
  return CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance) == CommonConst.CLIENT_DEVICE_TYPE.MOBILE
end

return M
