require("UnLua")
local MiscUtils = require("Utils.MiscUtils")
local EMCache = require("EMCache.EMCache")
local M = Class("BluePrints.UI.Shop.WBP_Shop_Base_New_C")
M._components = {
  "BluePrints.UI.UI_PC.Common.HorizontalListViewResizeComp",
  "BluePrints.UI.UI_PC.Common.LSFocusComp",
  "BluePrints.UI.Shop.SkinPreview.SkinPreview_ActorComponent",
  "BluePrints.UI.Shop.Component.Shop_PointerInputComponent",
  "BluePrints.UI.WBP.Armory.ActorController.PreviewActorComponent"
}

function M:Initialize(Initializer)
  self.Super.Initialize(self)
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self)
  if not EMCache:Get("ShopUnlockTime", true) then
    EMCache:Set("ShopUnlockTime", TimeUtils.NowTime(), true)
  end
  self.bIsFocusable = true
  self.Filters = {
    "UI_Select_Default",
    "UI_Select_Time",
    "UI_RARITY_NAME",
    "UI_PRICE_NAME"
  }
  self.MainTabMap = {}
  self.SubTabMap = {}
  self.bFilterOwned = false
  self:PlayAnimationReverse(self.Filtrate_Normal)
  self.Text_CountdownTime:SetVisibility(ESlateVisibility.Collapsed)
  local MainTabIdx, SubTabIdx, ShopItemId, ShopSystemName, CloseCallBack, ClsoeCallBackObj = ...
  self.CloseCallBack = CloseCallBack
  self.ClsoeCallBackObj = ClsoeCallBackObj
  self.SelectShopItemId = ShopItemId
  self.List_Item:SetVisibility(ESlateVisibility.Visible)
  if ShopSystemName then
    local ShopBGM = DataMgr.Shop[ShopSystemName].PlaySystemUIBGM
    if ShopBGM then
      AudioManager(self):PlaySystemUIBGM(ShopBGM, nil, ShopSystemName)
    end
  end
  if GWorld.GameInstance then
    GWorld.GameInstance:SetHighFrequencyMemoryCheckGCEnabled(true, "ShopMain")
  end
  self.bAllowedToShowHideUI = false
  self.bShowModel = false
  self.bHideUIExceptVideo = false
  self._OriginVisibilityMap = self._OriginVisibilityMap or {}
  self.BannerTabStates = {}
  local bPlayVideoTopFirst = false
  local BgVideoPath, DisplayType, DisplayId
  local ShopMainTabData = DataMgr.ShopTabMain[MainTabIdx]
  if "Shop" == ShopSystemName and (nil == MainTabIdx or ShopMainTabData and ShopMainTabData.PinVideo) then
    local SwitchBannerList = ShopUtils:GetBannerInfo(true)
    local BannerList = ShopUtils:GetBannerInfo()
    local Banner
    if SwitchBannerList[1] then
      Banner = SwitchBannerList[1]
    elseif BannerList[1] then
      Banner = BannerList[1]
    end
    if Banner then
      local BannerId = Banner.Id
      BgVideoPath = DataMgr.ShopBannerTab[BannerId].BgVideoPath
      DisplayId = DataMgr.ShopBannerTab[BannerId].DisplayId
      DisplayType = DataMgr.ShopBannerTab[BannerId].DisplayType
      if BgVideoPath and "" ~= BgVideoPath and self:IsFirstTimeToEnterBanner(BannerId) then
        bPlayVideoTopFirst = true
      end
    end
  end
  self:InitShop(MainTabIdx, SubTabIdx, ShopItemId, ShopSystemName, bPlayVideoTopFirst)
  if bPlayVideoTopFirst then
    self:InitVideoPlayer(BgVideoPath, DisplayType, DisplayId)
    self:PlayVideoTop()
  end
  self:ShowSkipButton(false)
  self.Image_Hit.OnMouseButtonDownEvent:Unbind()
  self.Image_Hit.OnMouseButtonDownEvent:Bind(self, self.On_Image_Click_MouseButtonDown)
end

function M:IsFirstTimeToEnterBanner(BannerId)
  local key = "bHasPlayedVideo_" .. BannerId
  if not EMCache:Get(key, true) then
    EMCache:Set(key, true, true)
    return true
  end
  return false
end

function M:ReceiveEnterState(StackAction)
  M.Super.ReceiveEnterState(self, StackAction)
  if self.ShopType then
    local ShopBGM = DataMgr.Shop[self.ShopType].PlaySystemUIBGM
    if ShopBGM then
      AudioManager(self):PlaySystemUIBGM(ShopBGM, nil, self.ShopType)
    end
  end
  if 1 == StackAction and self:IsHasVideo() then
    self:PlayVideoBG()
  end
end

function M:ReceiveExitState(StackAction)
  M.Super.ReceiveExitState(self, StackAction)
  if 0 == StackAction and self:IsHasVideo() and self.bPlayVideoBG then
    self:StopVideoBG()
  end
end

function M:Construct()
  M.Super.Construct(self)
  self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
    local Content = NewObject(self.ShopItemContentClass)
    Content.ShopId = nil
    return Content
  end)
  self.List_Jump.OnCreateEmptyContent:Bind(self, function(self)
    local Content = UIManager(self):_CreateWidgetNew("JumpShopItem")
    Content.JumpShopData = nil
    return Content
  end)
  self.Text_BottomTabTips:SetText(GText("UI_Banner_Reminder"))
  if UE.AHotUpdateGameMode.IsGlobalPak() then
    self.Text_BottomTabTips:SetVisibility(ESlateVisibility.Collapsed)
  else
    self.Text_BottomTabTips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  self.CheckBox_Own:BindEventOnClicked({
    Inst = self,
    Func = self.OnClickFilterOwned
  })
  self.Text_ShopItemEmpty:SetText(GText("UI_SHOP_SOLDOUT"))
  self.Text_None:SetText(GText("UI_SHOP_NOTOWNED"))
  self.ShopTab:BindEventOnTabSelected(self, self.OnMainTabChanged)
  if self.Common_Tab.WBP_Com_Tab_ResourceBar then
    self.Common_Tab.WBP_Com_Tab_ResourceBar:SetLastFocusWidget(self.List_Item)
  end
  self.ScrollBox_Recommend.OnUserScrolled:Add(self, self.OnUserScrolled)
  self:AddDispatcher(EventID.OnRechargeFinished, self, self.OnRechargeFinished)
  self:AddDispatcher(EventID.RefreshShop, self, self.RefreshShop)
  if self.Btn_Shop_Visible and self.Btn_Shop_Visible.Btn_Click then
    self.Btn_Shop_Visible.Btn_Click.OnClicked:Add(self, self.HideUIExceptVideoAutoCallBack)
  end
  if self.Btn_Shop_Visible then
    self.Btn_Shop_Visible:SetVisibility(ESlateVisibility.Collapsed)
  end
  if self.Btn_Shop_Refresh then
    self.Btn_Shop_Refresh:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:RefreshShop()
  if not self.bNeedRefreshShop then
    self.bNeedRefreshShop = true
    self:AddTimer(1, function()
      self:RefreshSubTabData(self.CurSubTabMap)
      self.bNeedRefreshShop = false
    end, false, 0, "RefreshShop", true)
  end
end

function M:InitShopTabInfo(MainTabIdx, SubTabIdx)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local MainShopTabData = DataMgr.Shop[self.ShopType]
  assert(MainShopTabData, "获取商店类型信息失败:" .. self.ShopType)
  self:LoadShopTabInfo(MainShopTabData)
  self.Common_Tab:Init({
    DynamicNode = {
      "Back",
      "ResourceBar",
      "BottomKey"
    },
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Tips_Ensure")
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    },
    StyleName = "Text",
    TitleName = GText(MainShopTabData.ShopName),
    OverridenTopResouces = self.OverridenTopResouces,
    OnResourceBarAddedToFocusPath = self.OnResourceBarAddedToFocusPath,
    OnResourceBarRemovedFromFocusPath = self.OnResourceBarRemovedFromFocusPath,
    OwnerPanel = self,
    BackCallback = self.CloseSelf
  })
  self.ShopTab:Init({
    LeftKey = "Q",
    RightKey = "E",
    Tabs = self.MainTabList,
    ChildWidgetBPPath = "WidgetBlueprint'/Game/UI/WBP/Common/Tab/PC/WBP_Com_TabItem01_P.WBP_Com_TabItem01_P'"
  })
  if not MainTabIdx then
    self.ShopTab:SelectTab(1)
  else
    self.ShopTab:SelectTab(self.MainTabs[MainTabIdx])
    if self.Common_Toggle_TabGroup_PC then
      self.Common_Toggle_TabGroup_PC:SelectTab(self.SubTabMapIdx[SubTabIdx])
    end
  end
  if #self.MainTabList <= 1 then
    self.Group_Tab:SetVisibility(ESlateVisibility.Collapsed)
  else
    self.Group_Tab:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  self:AddLSFocusTarget(nil, {
    self.Common_SortList_PC
  })
  self:AddLSFocusTarget(self.CheckBox_Own.Com_KeyImg, self.CheckBox_Own, "X", true)
  self:AddTabReddotListen()
end

function M:AddTabReddotListen()
  for _, MainTabId in pairs(DataMgr.Shop[self.ShopType].MainTabId) do
    local Data = DataMgr.ShopItem2ShopTab[MainTabId]
    if Data then
      for SubTabId, ShopItems in pairs(Data) do
        local ReddotName = DataMgr.ShopTabSub[SubTabId].ReddotNode
        if ReddotName then
          ReddotManager.AddListenerEx(ReddotName, self, function(self, Count, RdType, RdName)
            if Count > 0 then
              if RdType == EReddotType.Normal then
                self.Common_Toggle_TabGroup_PC:ShowTabRedDotByTabId(SubTabId, false, true, false)
              elseif RdType == EReddotType.New then
                self.Common_Toggle_TabGroup_PC:ShowTabRedDotByTabId(SubTabId, true, false, false)
              end
            else
              self.Common_Toggle_TabGroup_PC:ShowTabRedDotByTabId(SubTabId, false, false, false)
            end
          end)
        end
      end
      local ReddotName = DataMgr.ShopTabMain[MainTabId].ReddotNode
      if ReddotName then
        ReddotManager.AddListenerEx(ReddotName, self, function(self, Count, RdType, RdName)
          if Count > 0 then
            if RdType == EReddotType.Normal then
              self.ShopTab:ShowTabRedDotByTabId(MainTabId, false, true, false)
            elseif RdType == EReddotType.New then
              self.ShopTab:ShowTabRedDotByTabId(MainTabId, true, false, false)
            end
          else
            self.ShopTab:ShowTabRedDotByTabId(MainTabId, false, false, false)
          end
        end)
      end
    end
  end
end

function M:_ShowSubTabReddot(SubTabList)
  for _, SubTab in ipairs(SubTabList) do
    local SubTabId = SubTab.TabId
    local ReddotName = DataMgr.ShopTabSub[SubTabId].ReddotNode
    local Node = ReddotManager.GetTreeNode(ReddotName)
    if Node and Node.Count > 0 then
      local RdType = Node.ReddotType
      if RdType == EReddotType.Normal then
        self.Common_Toggle_TabGroup_PC:ShowTabRedDotByTabId(SubTabId, false, true, false)
      elseif RdType == EReddotType.New then
        self.Common_Toggle_TabGroup_PC:ShowTabRedDotByTabId(SubTabId, true, false, false)
      end
    else
      self.Common_Toggle_TabGroup_PC:ShowTabRedDotByTabId(SubTabId, false, false, false)
    end
  end
end

function M:RemoveTabReddotListen()
  for _, MainTabId in pairs(DataMgr.Shop[self.ShopType].MainTabId) do
    local Data = DataMgr.ShopItem2ShopTab[MainTabId]
    if Data then
      for SubTabId, ShopItems in pairs(Data) do
        local ReddotName = DataMgr.ShopTabSub[SubTabId].ReddotNode
        if ReddotName then
          ReddotManager.RemoveListener(ReddotName, self)
        end
      end
      local ReddotName = DataMgr.ShopTabMain[MainTabId].ReddotNode
      if ReddotName then
        ReddotManager.RemoveListener(ReddotName, self)
      end
    end
  end
end

function M:OnMainTabChanged(TabWidget)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local MainTabId = self.MainTabMap[TabWidget.Idx]
  if not MainTabId then
    return
  end
  self:LoadMainTabInfo(MainTabId)
  if self.Common_Toggle_TabGroup_PC then
    self.Common_Toggle_TabGroup_PC:Init({
      LeftKey = "A",
      RightKey = "D",
      Tabs = self.SubTabList,
      ChildWidgetName = "TabSubTextItem"
    })
    self.Common_Toggle_TabGroup_PC:BindEventOnTabSelected(self, self.OnSubTabChanged)
    if #self.SubTabList <= 1 then
      self.bShowSubTab = true
      self.Tab:SetVisibility(ESlateVisibility.Collapsed)
    else
      self.bShowSubTab = false
      self.Tab:SetVisibility(ESlateVisibility.Visible)
    end
    self.Common_Toggle_TabGroup_PC:SelectTab(1)
  end
  self:_ShowSubTabReddot(self.SubTabList)
end

function M:OnSubTabChanged(TabWidget)
  local SubTabData = self.SubTabMap[TabWidget.Idx]
  if not SubTabData then
    return
  end
  self:ClearSubTabReddot()
  self:RefreshSubTabData(SubTabData)
end

function M:ClearSubTabReddot()
  if not self.CurSubTabMap then
    return
  end
  local NodeName = self.CurSubTabMap.ReddotNode
  if NodeName then
    ReddotManager.ClearLeafNodeCount(NodeName, false, {bAll = 1})
  end
end

function M:RefreshSubTabData(SubTabData)
  self.bShoulFocusToLastFocusedWidget = true
  self.Shop_RecommendBanner:ClearAllTimer()
  self.TabType = SubTabData.TabType
  self.IsBannerPage = false
  self.IsJumpShopPage = false
  self.ShowSwitchBanner = false
  self:LoadSubTabInfo(SubTabData)
  self:SetIsDealWithVirtualAccept(false)
  self.Group_Recharge:SetVisibility(ESlateVisibility.Collapsed)
  self.Group_PayGift:SetVisibility(ESlateVisibility.Collapsed)
  self.Group_Empty:SetVisibility(ESlateVisibility.Collapsed)
  self.VB_Jump:SetVisibility(ESlateVisibility.Collapsed)
  self.Group_Recommend:SetVisibility(ESlateVisibility.Collapsed)
  self.Group_Item:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Group_Bottom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Group_BG:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.CheckBox_Own:ForbidBtn(false)
  self:SetAllowedToShowHideUI(false)
  self.Group_RecommendAnchor:SetVisibility(ESlateVisibility.Collapsed)
  if self.Common_Tab and self.Common_Tab.WBP_Com_Tab_ResourceBar then
    self.Common_Tab.WBP_Com_Tab_ResourceBar:SetLastFocusWidget(self.List_Item)
  end
  if SubTabData.TabType == "Banner" then
    self:PlayAnimationReverse(self.Change)
  else
    self:PlayAnimation(self.Change)
  end
  if self.ShopType == "Shop" and SubTabData.TabType ~= "Banner" then
    self:StopVideoBG()
    self:SetAllowedToShowHideUI(false)
    self:SetShowModel(false)
    self:SetHasVideo(false)
    self:DestroyPreviewActor()
    if self.Common_Tab and self.Common_Tab.WBP_Com_Tab_ResourceBar then
      self.Common_Tab.WBP_Com_Tab_ResourceBar:SetGetReplyOnBack(nil)
    end
  end
  if SubTabData.TabType == "Pay" then
    self.CheckBox_Own:ForbidBtn(true)
    self.Group_Bottom:SetVisibility(ESlateVisibility.Collapsed)
    self:InitRechargePage(SubTabData)
    return
  end
  if SubTabData.TabType == "Card" then
    self.Group_Bottom:SetVisibility(ESlateVisibility.Collapsed)
    self:InitMonthCardPage(SubTabData)
    return
  end
  if SubTabData.TabType == "Banner" then
    self.CheckBox_Own:ForbidBtn(true)
    self.Group_Bottom:SetVisibility(ESlateVisibility.Collapsed)
    self.Group_Item:SetVisibility(ESlateVisibility.Collapsed)
    if self.BannerIdMap then
      for index, Item in pairs(self.BannerIdMap) do
        Item:SetVisibility(ESlateVisibility.Collapsed)
      end
    end
    if self.Common_Tab and self.Common_Tab.WBP_Com_Tab_ResourceBar then
      self.Common_Tab.WBP_Com_Tab_ResourceBar:SetGetReplyOnBack(function()
        self:GamePadFocusToSelectBannerItem()
        return UIUtils.Handled
      end)
    end
    self:AddTimer(0.05, function()
      self:GamePadFocusToSelectBannerItem()
    end)
    self.IsBannerPage = true
    self:SetIsDealWithVirtualAccept(true)
    self:InitBannerPage()
    self.bShoulFocusToLastFocusedWidget = false
    return
  end
  if SubTabData.TabType == "Complex" then
    self.CheckBox_Own:ForbidBtn(true)
    self.Group_Bottom:SetVisibility(ESlateVisibility.Collapsed)
    self.IsJumpShopPage = true
    self:InitJumpShopPage()
    return
  end
  self.Group_Bottom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.VB_ItemList:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self:UpdateShopDetail(self.CurSubTabMap)
end

function M:BP_GetDesiredFocusTarget()
  if self.TabType == "Banner" then
    return self:GetSelectBannerItem()
  end
end

function M:CommonInitPage(OverlayWidget, WidgetName)
  self.VB_ItemList:SetVisibility(ESlateVisibility.Collapsed)
  self.Group_Bottom:SetVisibility(ESlateVisibility.Collapsed)
  OverlayWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  local Widget = OverlayWidget:GetChildAt(0)
  if not Widget then
    Widget = UIManager(self):_CreateWidgetNew(WidgetName)
    OverlayWidget:AddChildToOverlay(Widget)
  end
  if Widget.Image_NotabSign then
    if self.bShowSubTab then
      Widget.Image_NotabSign:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
      Widget.Image_NotabSign:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
  Widget:PlayAnimation(Widget.In)
  local Slot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(Widget)
  Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
  Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
  return Widget
end

function M:InitPayGiftPage(ShopItemsData)
  local Widget = self:CommonInitPage(self.Group_PayGift, "PayGiftPage")
  if self.Common_Tab and self.Common_Tab.WBP_Com_Tab_ResourceBar then
    self.Common_Tab.WBP_Com_Tab_ResourceBar:SetLastFocusWidget(Widget)
  end
  local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem(self)
  if 0 == #ShopItemsData then
    GameInputModeSubsystem:SetNavigateWidgetVisibility(false)
    self.Group_PayGift:SetVisibility(ESlateVisibility.Collapsed)
    self.Group_Empty:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Group_Bottom:SetVisibility(ESlateVisibility.Collapsed)
  else
    self.Group_Bottom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Group_Empty:SetVisibility(ESlateVisibility.Collapsed)
  end
  Widget:InitPayGiftInfo(ShopItemsData)
end

function M:InitRechargePage(SubTabData)
  local Widget = self:CommonInitPage(self.Group_Recharge, "ShopRechargePage")
  if self.Common_Tab and self.Common_Tab.WBP_Com_Tab_ResourceBar then
    self.Common_Tab.WBP_Com_Tab_ResourceBar:SetLastFocusWidget(Widget)
  end
  local RechargeContent = {}
  for _, ShopData in pairs(DataMgr.ShopItem) do
    if ShopData.SubTabId == SubTabData.SubTabId then
      table.insert(RechargeContent, ShopData)
    end
  end
  table.sort(RechargeContent, function(a, b)
    return a.ItemId < b.ItemId
  end)
  local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem(self)
  if 0 == #RechargeContent then
    GameInputModeSubsystem:SetNavigateWidgetVisibility(false)
    self.Group_Recharge:SetVisibility(ESlateVisibility.Collapsed)
    self.Group_Empty:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Group_Empty:SetVisibility(ESlateVisibility.Collapsed)
  end
  Widget:InitRechargeInfo(RechargeContent)
  if not CommonUtils:IfExistSystemGuideUI(self) or self:HasAnyFocus() or self:HasFocusedDescendants() then
    self:AddTimer(0.3, function()
      Widget:SetFocus()
    end)
  end
end

function M:OnUserScrolled()
  UIUtils.UpdateScrollBoxArrow(self.ScrollBox_Recommend, self.Group_ListTop, self.Group_ListBottom, 100)
end

function M:InitBannerPage(SelectBannerId)
  local LastSelectBanner = self.BannerIdMap and self.BannerIdMap[self.SelectBannerId]
  self.BannerIdMap = {}
  self.SwitchBannerList = ShopUtils:GetBannerInfo(true)
  local BannerData, BannerIdDict = ShopUtils:GetBannerInfo()
  if SelectBannerId then
    self.SelectBannerId = SelectBannerId
  elseif not BannerIdDict[self.SelectBannerId] then
    self.SelectBannerId = nil
  end
  local ScrollBoxChildrenTable = self.ScrollBox_Recommend:GetAllChildren():ToTable()
  if ScrollBoxChildrenTable and next(ScrollBoxChildrenTable) then
    for _, value in ipairs(ScrollBoxChildrenTable) do
      if value and value.ScrollboxIndex and value.ScrollboxIndex >= 1 then
        value:RemoveFromParent()
      end
    end
  end
  if not self.SelectBannerId then
    if next(self.SwitchBannerList) then
      self.SelectBannerId = self.SwitchBannerList[1].Id
    else
      assert(BannerData[1], "有效Banner数量不足一个")
      self.SelectBannerId = BannerData[1].Id
    end
  end
  local Path
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    Path = CommonConst.ShopBannerMobilePath
  else
    Path = CommonConst.ShopBannerPCPath
  end
  local bSwitchBanner = false
  if self.SwitchBannerList and next(self.SwitchBannerList) then
    self.Shop_RecommendBanner:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Shop_RecommendBanner:InitItemInfo()
    self.Shop_RecommendBanner:BindBtnEvent(self, self.OnSwitchBannerChanged)
    self.Shop_RecommendBanner:BindBtnClickEvent(self, self.OnSwitchBannerItemClick)
    local BannerBPPath = Path .. "WBP_Shop_Recommend_Common"
    local BannerPageWidget = UIManager(self):CreateWidget(BannerBPPath)
    if BannerPageWidget then
      for _, BannerInfo in ipairs(self.SwitchBannerList) do
        if BannerInfo.Id == self.SelectBannerId then
          bSwitchBanner = true
        end
        self.BannerIdMap[BannerInfo.Id] = BannerPageWidget
      end
      BannerPageWidget:SetVisibility(ESlateVisibility.Collapsed)
      self.Group_RecommendAnchor:AddChild(BannerPageWidget)
      local Slot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(BannerPageWidget)
      Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
      Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    end
    self.Shop_RecommendBanner.ScrollboxIndex = 0
  else
    self.Shop_RecommendBanner:SetVisibility(ESlateVisibility.Collapsed)
  end
  self.BannerList = ShopUtils:GetBannerInfo()
  self.VB_ItemList:SetVisibility(ESlateVisibility.Collapsed)
  self.Group_Recommend:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Group_RecommendAnchor:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.BannerBpMap = {}
  for i, BannerInfo in ipairs(BannerData) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.BannerId = BannerInfo.Id
    Content.ClickEvent = {
      Obj = self,
      Callback = self.OnBannerItemClick
    }
    Content.VirtualClickCallback = self.HandleVirtualClickInGamePad
    Content.OnKeyDownCallBack = self.HandleOnKeyDownCallBack
    Content.SetListItemCallBack = self.HandleSetListItemCallBack
    Content.Parent = self
    Content.ScrollboxIndex = i
    if 1 == i then
      Content.UpToSwitchWidget = self.Shop_RecommendBanner
    end
    if self.SelectBannerId == BannerInfo.Id then
      Content.bSelected = true
    else
      Content.bSelected = false
    end
    if self.SelectBannerId == BannerInfo.Id and not self.BannerIdMap[BannerInfo.Id] then
      local BannerBPPath = Path .. BannerInfo.Bp
      local BannerPageWidget = UIManager(self):CreateWidget(BannerBPPath)
      if BannerPageWidget then
        self.BannerIdMap[BannerInfo.Id] = BannerPageWidget
        self.BannerIdMap[BannerInfo.Id]:SetVisibility(ESlateVisibility.Collapsed)
        self.Group_RecommendAnchor:AddChild(self.BannerIdMap[BannerInfo.Id])
        local Slot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(self.BannerIdMap[BannerInfo.Id])
        Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
        Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
      end
    end
    local BannerItemWidget = UIManager(self):CreateWidget("WidgetBlueprint'/Game/UI/WBP/Shop/Widget/Recommend/WBP_Shop_Recommend_ListItem.WBP_Shop_Recommend_ListItem'")
    BannerItemWidget:OnListItemObjectSet(Content)
    self.ScrollBox_Recommend:AddChild(BannerItemWidget)
  end
  self.BannerBpMap[DataMgr.ShopBannerTab[self.SelectBannerId].Bp] = self.BannerIdMap[self.SelectBannerId]
  if bSwitchBanner and not CommonUtils:IfExistSystemGuideUI(self) then
    self.Shop_RecommendBanner:SetFocus()
  elseif not CommonUtils:IfExistSystemGuideUI(self) then
  end
  self:AddTimer(0.5, function()
    self:OnUserScrolled()
  end)
end

function M:HandleVirtualClickInGamePad(BannerId)
  local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem(self)
  local CurInputDeviceType = GameInputModeSubsystem and GameInputModeSubsystem:GetCurrentInputType() or nil
  if CurInputDeviceType and CurInputDeviceType ~= ECommonInputType.Gamepad then
    return
  end
  if not BannerId then
    return
  end
  local CurrentPage = self.BannerIdMap[BannerId]
  if CurrentPage and CurrentPage.OnGamePadDown then
    CurrentPage:OnGamePadDown(UIConst.GamePadKey.FaceButtonBottom)
  end
end

function M:HandleOnKeyDownCallBack(BannerId, MyGeometry, InKeyEvent)
  if not BannerId then
    return
  end
  local CurrentPage = self.BannerIdMap[BannerId]
  if CurrentPage and CurrentPage.OnKeyDown then
    return CurrentPage:OnKeyDown(MyGeometry, InKeyEvent)
  end
  return UIUtils.UnHandled
end

function M:HandleSetListItemCallBack(BannerId, ListItem)
  if not BannerId then
    return
  end
  local CurrentPage = self.BannerIdMap[BannerId]
  if CurrentPage and CurrentPage.SetListItem then
    CurrentPage:SetListItem(ListItem)
  end
end

function M:ChangeBanner(BannerId, bSwitch, bRight)
  if self.LastSelectBannerId and self.LastSelectBannerId ~= BannerId and self.BannerIdMap[self.LastSelectBannerId] then
    if bSwitch then
      self.BannerIdMap[self.LastSelectBannerId]:PlayAnimationSwitch(bRight)
    elseif self.BannerIdMap[self.LastSelectBannerId].PlayAnimationOut then
      self.BannerIdMap[self.LastSelectBannerId]:PlayAnimationOut()
    else
      self.BannerIdMap[self.LastSelectBannerId]:SetVisibility(ESlateVisibility.Collapsed)
    end
    if self.BannerIdMap[self.LastSelectBannerId].ExitBanner then
      self.BannerIdMap[self.LastSelectBannerId]:ExitBanner()
    end
  end
  if self.LastWidgetContent and self.LastWidgetContent.SelfWidget then
    self.LastWidgetContent.SelfWidget:UnSelect()
  end
  local BannerData = DataMgr.ShopBannerTab[BannerId]
  if BannerData and BannerData.Bp and BannerData.Bp ~= "WBP_Shop_Recommend_Common" then
    self:SetCameraToDefault()
    self:StopActorSound()
    self.Group_BG:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  self:SetReplayGestureVisible(false)
  if self.BannerIdMap[BannerId] and self.BannerIdMap[BannerId].InitBannerPage then
    self.BannerIdMap[BannerId]:InitBannerPage(BannerId, self)
  end
  self.BannerIdMap[BannerId]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  if not bSwitch and self.BannerIdMap[BannerId].PlayAnimationIn then
    self.BannerIdMap[BannerId]:PlayAnimationIn()
  end
  self.SelectBannerId = BannerId
  self.LastSelectBannerId = BannerId
  self:UpdateSwitchBannerGamePadKey()
end

function M:UpdateSwitchBannerGamePadKey()
  if self.ShowSwitchBanner and UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self.Shop_RecommendBanner.Key_Left:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Shop_RecommendBanner.Key_Right:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Shop_RecommendBanner.Key_Left:SetVisibility(ESlateVisibility.Collapsed)
    self.Shop_RecommendBanner.Key_Right:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:OnSwitchBannerItemClick(BannerId, bSwitch, bRight)
  self.ShowSwitchBanner = true
  self:OnSwitchBannerChanged(BannerId, bSwitch, bRight)
end

function M:OnSwitchBannerChanged(BannerId, bSwitch, bRight)
  if not self.ShowSwitchBanner then
    return
  end
  self.Shop_RecommendBanner:StopBannerTimer()
  self:ChangeBanner(BannerId, bSwitch, bRight)
  self.LastWidgetContent = nil
end

function M:OnBannerItemClick(BannerId, Content, bPlaySound)
  self.Shop_RecommendBanner:StartBannerTimer()
  self.Shop_RecommendBanner:UnSelect()
  self.ShowSwitchBanner = false
  local BannerData = DataMgr.ShopBannerTab[BannerId]
  local Path
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    Path = CommonConst.ShopBannerMobilePath
  else
    Path = CommonConst.ShopBannerPCPath
  end
  if not self.BannerIdMap[BannerId] then
    local BannerBPPath = Path .. BannerData.Bp
    local BannerPageWidget = UIManager(self):CreateWidget(BannerBPPath)
    self.BannerIdMap[BannerId] = BannerPageWidget
    self.Group_RecommendAnchor:AddChild(self.BannerIdMap[BannerId])
    local Slot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(self.BannerIdMap[BannerId])
    Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
  end
  if bPlaySound then
    AudioManager(self):PlayUISound(self, "event:/ui/activity/large_btn_click", nil, nil)
  end
  self.BannerBpMap[DataMgr.ShopBannerTab[BannerId].Bp] = self.BannerIdMap[BannerId]
  self:ChangeBanner(BannerId)
  self.LastWidgetContent = Content
  self:UpdateCommonTabInfo()
end

function M:OnBannerExpire()
  if self.IsBannerPage then
    self.ShopTab:SelectTab(self.ShopTab.CurrentTab)
  end
end

function M:InitMonthCardPage(SubTabData)
  self.VB_ItemList:SetVisibility(ESlateVisibility.Collapsed)
  self.Group_MonthCard:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  local Count = self.Group_MonthCard:GetChildrenCount()
  local Widget
  if Count > 0 then
    Widget = self.Group_MonthCard:GetChildAt(0)
  end
  if not IsValid(Widget) then
    self.Group_MonthCard:ClearChildren()
    Widget = UIManager(self):_CreateWidgetNew("MonthCardPage")
    self.Group_MonthCard:AddChild(Widget)
  end
  Widget:InitBannerPage()
  local Slot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(Widget)
  Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
  Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
  if not CommonUtils:IfExistSystemGuideUI(self) then
    Widget:SetFocus()
  end
end

function M:InitJumpShopPage()
  if self.Common_Tab and self.Common_Tab.WBP_Com_Tab_ResourceBar then
    self.Common_Tab.WBP_Com_Tab_ResourceBar:SetLastFocusWidget(self.List_Jump)
  end
  self.VB_ItemList:SetVisibility(ESlateVisibility.Collapsed)
  self.VB_Jump:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  local JumpShopList = ShopUtils:GetComplexInfo(self.CurSubTabMap.SubTabId)
  self.List_Jump:ScrollIndexIntoView(0)
  self.List_Jump:ClearListItems()
  for index, JumpShopInfo in ipairs(JumpShopList) do
    local JumpConfig = DataMgr.InterfaceJump[JumpShopInfo.InterfaceJumpId]
    local PlayerAvatar = GWorld:GetAvatar()
    if ConditionUtils.CheckCondition(PlayerAvatar, JumpConfig.PortalUnlockCondition) then
      local Content = UIManager(self):_CreateWidgetNew("JumpShopItem")
      Content.JumpShopData = JumpShopInfo
      self.List_Jump:AddItem(Content)
    end
  end
  if self.List_Jump:GetNumItems() > 0 then
    self.List_Jump:RequestFillEmptyContent()
    self.List_Jump:RequestPlayEntriesAnim()
    self.List_Jump:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.List_Jump:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self:AddTimer(0.01, function()
      if not CommonUtils:IfExistSystemGuideUI(self) then
        self.List_Jump:SetFocus()
      end
    end)
  end
end

function M:Close()
  if self.VideoPlayer then
    self:StopVideoTop()
    self:StopVideoBG()
  end
  self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
  if self.CloseCallBack then
    self.CloseCallBack(self.ClsoeCallBackObj)
  end
  self:ClearSubTabReddot()
  self:RemoveTabReddotListen()
  self.Super.Close(self)
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Out then
    self:BlockAllUIInput(true)
    self:Close()
  elseif InAnimation == self.In then
    self:BlockAllUIInput(false)
    if self.SelectShopItemId then
      self:AddTimer(0.1, function()
        self:ShowItemDetail()
        self.SelectShopItemId = nil
      end, false, 0, "OpenShopItemDialog", true)
    end
  end
end

function M:Destruct()
  local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
  if Player then
    Player:SetCanInteractiveTrigger(true)
  end
  AudioManager(self):StopSystemUIBGM(self.ShopType)
  self:HorizontalListViewResize_TearDown()
  self.Group_RecommendAnchor:ClearChildren()
  self:CleanTimer()
  self.List_Item.OnCreateEmptyContent:Unbind()
  self.List_Jump.OnCreateEmptyContent:Unbind()
  if self.Btn_Shop_Visible and self.Btn_Shop_Visible.Btn_Click then
    self.Btn_Shop_Visible.Btn_Click.OnClicked:Remove(self, self.HideUIExceptVideoAutoCallBack)
  end
  if GWorld.GameInstance then
    GWorld.GameInstance:SetHighFrequencyMemoryCheckGCEnabled(false, "ShopMain")
  end
  self.Super.Destruct(self)
end

function M:OnGamePadSelect(ItemContent, bHover)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad or bHover then
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local InputEvent = UWidgetBlueprintLibrary.GetInputEventFromKeyEvent(InKeyEvent)
  local IsRepeat = UKismetInputLibrary.InputEvent_IsRepeat(InputEvent)
  if IsRepeat then
    return UWidgetBlueprintLibrary.UnHandled()
  end
  if self:IsAllowedToShowHideUI() then
    if "U" == InKeyName or InKeyName == Const.GamepadFaceButtonLeft then
      self:HideUIExceptVideoAutoCallBack()
      return UWidgetBlueprintLibrary.Handled()
    end
    if self.bHideUIExceptVideo then
      self:HideUIExceptVideo(false)
      return UWidgetBlueprintLibrary.Handled()
    end
  end
  local IsHandled = false
  if self.ShowSwitchBanner and not self.FocusOnResourceBar then
    if InKeyName == UIConst.GamePadKey.DPadRight then
      self.Shop_RecommendBanner:SwitchBannerItem(nil, true)
    elseif InKeyName == UIConst.GamePadKey.DPadLeft then
      self.Shop_RecommendBanner:SwitchBannerItem(nil, false)
    end
  end
  if "Gamepad_FaceButton_Bottom" == InKeyName and self.IsBannerPage and self.BannerMap and self.BannerMap[self.CurrentPageIndex] then
    local Banner = self.BannerMap[self.CurrentPageIndex]
    Banner:OnGoToInterface()
    IsHandled = true
  end
  if "SpaceBar" == InKeyName and self.IsBannerPage and not self.bPlayVideoTop then
    local BpName = DataMgr.ShopBannerTab[self.SelectBannerId].Bp
    local Banner = self.BannerBpMap[BpName]
    if Banner and Banner.OnGoToInterface then
      Banner:OnGoToInterface()
      IsHandled = true
    end
  end
  if self.TabType == "Banner" and self.SelectBannerId and self.BannerIdMap and type(self.BannerIdMap) == "table" then
    local CurrentPage = self.BannerIdMap[self.SelectBannerId]
    if CurrentPage and CurrentPage.HandlePreviewKeyDown and not IsHandled then
      IsHandled = CurrentPage:HandlePreviewKeyDown(InKey, InKeyName)
    end
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnGamePadDown(InKeyName)
  local IsEventHandled = false
  if "Gamepad_LeftTrigger" == InKeyName or "Gamepad_RightTrigger" == InKeyName then
    if self.IsBannerPage then
    elseif self.Common_Toggle_TabGroup_PC then
      IsEventHandled = self.Common_Toggle_TabGroup_PC:Handle_KeyEventOnGamePad(InKeyName)
    end
  elseif "Gamepad_FaceButton_Right" == InKeyName then
    if not UIManager(self):GetUIObj("CommonDialog") then
      self:CloseSelf()
    end
    IsEventHandled = true
  elseif "Gamepad_RightShoulder" == InKeyName or "Gamepad_LeftShoulder" == InKeyName then
    IsEventHandled = self.ShopTab:Handle_KeyEventOnGamePad(InKeyName)
  else
    IsEventHandled = self.Common_Tab:Handle_KeyEventOnGamePad(InKeyName)
  end
  return IsEventHandled
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  if CurInputDevice == ECommonInputType.Gamepad then
    self:InitGamepadView()
  else
    self:InitKeyboardView()
  end
  self:UpdateSwitchBannerGamePadKey()
  if self.BannerIdMap then
    for _, Banner in pairs(self.BannerIdMap) do
      if Banner and Banner.RefreshOpInfoByInputDevice then
        Banner:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
      end
    end
  end
  if self.IsJumpShopPage and self.List_Jump then
    if CurInputDevice == ECommonInputType.Gamepad and (self:HasAnyFocus() or self:HasFocusedDescendants()) and not CommonUtils:IfExistSystemGuideUI(self) then
      self.List_Jump:SetFocus()
    end
  elseif self.IsBannerPage and CurInputDevice == ECommonInputType.Gamepad and (self:HasAnyFocus() or self:HasFocusedDescendants()) and not CommonUtils:IfExistSystemGuideUI(self) then
    self.ScrollBox_Recommend:SetFocus()
  end
  self:UpdateVideoKeyInfo(CurInputDevice, CurGamepadName)
end

function M:InitGamepadView()
  self.CheckBox_Own.Com_KeyImg:SetVisibility(ESlateVisibility.Visible)
  self.CheckBox_Own.Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    }
  })
end

function M:InitKeyboardView()
  self.CheckBox_Own.Com_KeyImg:SetVisibility(ESlateVisibility.Collapsed)
end

function M:OnSpaceBarDown()
  if self.IsBannerPage and self.BannerIdMap and self.SelectBannerId then
    local Banner = self.BannerIdMap[self.SelectBannerId]
    if Banner.OnPCKeyDown then
      Banner:OnPCKeyDown("SpaceBar")
    end
  end
end

function M:UpdateCommonTabInfo(Params)
  if not (self.SelectBannerId and self.Common_Tab) or not self.Common_Tab.UpdateBottomKeyInfo then
    return
  end
  if Params and next(Params) then
    self.Common_Tab:UpdateBottomKeyInfo(Params)
    return
  end
  local Params = {}
  local TargetBannerData = DataMgr.ShopBannerTab[self.SelectBannerId]
  if TargetBannerData and TargetBannerData.Bp and TargetBannerData.Bp == "WBP_Shop_Recommend_WeaponSkin" then
    Params = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "X",
            Owner = self
          }
        },
        Desc = GText("UI_CTL_SkinPreview"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "SpaceBar",
            ClickCallback = self.OnSpaceBarDown,
            Owner = self
          }
        },
        Desc = GText("UI_SHOP_PURCHASE"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    }
  elseif TargetBannerData and TargetBannerData.Bp and TargetBannerData.Bp == "WBP_Shop_Recommend_Gift4_1" then
    Params = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "X",
            Owner = self
          }
        },
        Desc = GText("UI_CTL_SkinPreview"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "SpaceBar",
            Owner = self.BannerBpMap[TargetBannerData.Bp],
            ClickCallback = self.BannerBpMap[TargetBannerData.Bp].OnGoToInterface
          }
        },
        Desc = GText("UI_SHOP_PURCHASE"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    }
  elseif TargetBannerData and TargetBannerData.Bp and TargetBannerData.Bp == "WBP_Shop_Recommend_AvatarSkin" then
    Params = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Tab",
            Owner = self,
            ClickCallback = self.HideUIExceptVideoAutoCallBack
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "LS",
            Owner = self
          }
        },
        Desc = GText("UI_Dye_HideUI"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "SpaceBar",
            Owner = self,
            ClickCallback = self.OnSpaceBarDown
          }
        },
        Desc = GText("UI_Banner_SkinGacha_Goto"),
        bLongPress = false
      },
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "X",
            Owner = self
          }
        },
        Desc = GText("UI_CTL_SkinPreview"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Escape",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
  elseif TargetBannerData and TargetBannerData.Bp and TargetBannerData.Bp == "WBP_Shop_Banner_MonthCard" then
    Params = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "SpaceBar",
            Owner = self,
            ClickCallback = self.OnSpaceBarDown
          }
        },
        Desc = GText("UI_SHOP_PURCHASE"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Escape",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
  elseif TargetBannerData and TargetBannerData.Bp and TargetBannerData.Bp == "WBP_Shop_Recommend_PageGift" then
  else
    Params = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Tips_Ensure")
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    }
  end
  self.Common_Tab:UpdateBottomKeyInfo(Params)
end

function M:UpdateCommonTabInfoByReward()
  if not self.SelectBannerId then
    return
  end
  local TargetBannerData = DataMgr.ShopBannerTab[self.SelectBannerId]
  if TargetBannerData and TargetBannerData.Bp and TargetBannerData.Bp == "WBP_Shop_Recommend_Gift4_1" then
    self.Common_Tab:UpdateBottomKeyInfo({
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Controller_Check"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    })
  elseif TargetBannerData and TargetBannerData.Bp and TargetBannerData.Bp == "WBP_Shop_Recommend_PageGift" then
    self.Common_Tab:UpdateBottomKeyInfo({
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Controller_CheckDetails"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    })
  end
end

function M:SetHasVideo(flag)
  self.bHasVideo = flag
end

function M:IsHasVideo()
  return self.bHasVideo
end

function M:SetAllowedToShowHideUI(flag)
  self.bAllowedToShowHideUI = flag
  if self.Btn_Shop_Visible then
    if flag then
      self.Btn_Shop_Visible:SetVisibility(ESlateVisibility.Visible)
    else
      self.Btn_Shop_Visible:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
end

function M:SetShowModel(flag)
  self.bShowModel = flag
end

function M:IsShowModel()
  return self.bShowModel
end

function M:SetReplayGestureVisible(flag)
  if self.Btn_Shop_Refresh then
    if flag then
      self.Btn_Shop_Refresh:SetVisibility(ESlateVisibility.Visible)
    else
      self.Btn_Shop_Refresh:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
end

function M:IsAllowedToShowHideUI()
  return self.bAllowedToShowHideUI
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self.bPlayVideoTop and ("Escape" == InKeyName or InKeyName == Const.GamepadFaceButtonRight) then
    return UWidgetBlueprintLibrary.Handled()
  end
  if self.TabType == "Banner" and self.SelectBannerId and self.BannerIdMap and type(self.BannerIdMap) == "table" then
    local CurrentPage = self.BannerIdMap[self.SelectBannerId]
    if CurrentPage and CurrentPage.HandleKeyDown and CurrentPage:HandleKeyDown(InKey, InKeyName) then
      return UWidgetBlueprintLibrary.Handled()
    end
  end
  return M.Super.OnKeyDown(self, MyGeometry, InKeyEvent)
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self.Key_Video and self.bPlayVideoTop and ("SpaceBar" == InKeyName or InKeyName == Const.GamepadFaceButtonDown) then
    self.Key_Video.Panel_Key:GetChildAt(0):OnButtonReleased()
    return UWidgetBlueprintLibrary.Handled()
  end
  return M.Super.OnKeyUp(self, MyGeometry, InKeyEvent)
end

function M:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
  return self:OnPointerDown(MyGeometry, MouseEvent)
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
  return self:OnMouseWheelScroll(MyGeometry, MouseEvent)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  return self:OnPointerUp(MyGeometry, MouseEvent)
end

function M:OnMouseMove(MyGeometry, MouseEvent)
  if self.bPlayVideoTop and self:IsAllowedToShowHideUI() and self.bHideUIExceptVideo then
    DebugPrint("WBP_ShopMain_C:OnMouseMove")
    local MouseMoveThreshold = 10
    self.LastMousePos = self.LastMousePos or {X = nil, Y = nil}
    local CurPos = UWidgetLayoutLibrary.GetMousePositionOnViewport(self)
    local LastPos = self.LastMousePos
    local ShouldHandle = false
    if LastPos.X and LastPos.Y then
      local Dx = CurPos.X - LastPos.X
      local Dy = CurPos.Y - LastPos.Y
      local Dist = math.sqrt(Dx * Dx + Dy * Dy)
      if MouseMoveThreshold <= Dist then
        DebugPrint(string.format("WBP_ShopMain_C:OnMouseMove, Dist: %f, ShouldHandle = true", Dist))
        ShouldHandle = true
      end
    end
    self.LastMousePos.X = CurPos.X
    self.LastMousePos.Y = CurPos.Y
    if ShouldHandle then
      self:HideUIExceptVideo(false)
      return UWidgetBlueprintLibrary.Handled()
    end
  else
    return self:OnPointerMove(MyGeometry, MouseEvent)
  end
end

function M:OnTouchStarted(MyGeometry, InTouchEvent)
  return self:OnSinglePointerDown(MyGeometry, InTouchEvent)
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
  return self:OnPointerUp(MyGeometry, InTouchEvent)
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
  return self:OnPointerMove(MyGeometry, InTouchEvent)
end

function M:OnCameraScrollBackwardKeyDown()
  self:ScrollCamera(1)
end

function M:OnCameraScrollForwardKeyDown()
  self:ScrollCamera(-1)
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_RightX" == InKeyName then
    if self.ActorController then
      local DeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
      self.ActorController:OnDragging({X = DeltaX})
    end
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:OnMouseCaptureLost()
  self:OnPointerCaptureLost()
end

function M:OnBackgroundClicked()
  if self.bSelfHidden then
    self:OnHideUIKeyDown()
  end
end

function M:InitVideoPlayer(BgVideoPath, DisplayType, DisplayId)
  self._OriginVisibilityMap = self._OriginVisibilityMap or {}
  self.bPlayVideoTop = false
  self.VideoPlayer:SetUrlByMediaSource(LoadObject(BgVideoPath))
  self.DisplayType = DisplayType
  self.DisplayId = DisplayId
end

function M:UpdateVideoKeyInfo(CurInputDevice, CurGamepadName)
  if IsValid(self.GameInputModeSubsystem) then
    CurInputDevice = CurInputDevice or self.GameInputModeSubsystem:GetCurrentInputType()
    CurGamepadName = CurGamepadName or self.GameInputModeSubsystem:GetCurrentGamepadName()
  end
  if not self.Key_Video then
    return
  end
end

function M:SetSkipButton()
  self.VideoPlayer.Button_Skip:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    if self.Button_Skip then
      self.Button_Skip.Button_Area.OnClicked:Add(self, self.StopVideoTop)
      self.Button_Skip.Text_Function:SetText(GText("UI_TALK_SKIP_MOIILE"))
    end
  elseif CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" and self.Key_Video then
    self:UpdateVideoKeyInfo()
  end
end

function M:ShowSkipButton(flag)
  local Visibility = flag and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.Collapsed
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    if self.Button_Skip then
      self.Button_Skip:SetVisibility(Visibility)
    end
  elseif CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" and self.Key_Video then
    self.Key_Video:SetVisibility(Visibility)
  end
end

function M:HideUIExceptVideoAutoCallBack()
  if self:IsAllowedToShowHideUI() then
    self:HideUIExceptVideo(not self.bHideUIExceptVideo, false)
  end
end

function M:HideUIExceptVideo(flag, bSkipAnimation)
  DebugPrint("WBP_ShopMain_C HideUIExceptVideo")
  if not flag and self.bPlayVideoTop then
    self:StopVideoTop()
  end
  if not bSkipAnimation and (self:IsAnimationPlaying(self.In_Info) or self:IsAnimationPlaying(self.Out_Info)) then
    return false
  end
  if flag == self.bHideUIExceptVideo then
    return true
  end
  self.bHideUIExceptVideo = flag
  if bSkipAnimation or self.bHasHideUIManually then
    self.bHasHideUIManually = flag
    local Count = self.Root:GetChildrenCount()
    for i = 0, Count - 1 do
      local Child = self.Root:GetChildAt(i)
      if Child ~= self.Group_Video then
        if flag then
          if self._OriginVisibilityMap[Child] == nil then
            self._OriginVisibilityMap[Child] = Child:GetVisibility()
          end
          Child:SetVisibility(ESlateVisibility.Hidden)
        elseif self._OriginVisibilityMap[Child] ~= nil then
          Child:SetVisibility(self._OriginVisibilityMap[Child])
        end
      end
    end
  end
  if not bSkipAnimation then
    if flag then
      self:PlayAnimation(self.Out_Info)
      self:SetFocus()
    else
      self:PlayAnimation(self.In_Info)
      if not CommonUtils:IfExistSystemGuideUI(self) and self:HasAnyFocus() and self.CurSubTabMap.TabType == "Banner" then
        self:AddTimer(0.05, function()
          self:GamePadFocusToSelectBannerItem()
        end)
      end
    end
  end
  if flag then
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
  else
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
  end
  local CurPos = UWidgetLayoutLibrary.GetMousePositionOnViewport(self)
  self.LastMousePos = {
    X = CurPos.X,
    Y = CurPos.Y
  }
  if self.Shop_RecommendBanner then
    if flag or self.ShowSwitchBanner then
      self.Shop_RecommendBanner:StopBannerTimer()
    else
      self.Shop_RecommendBanner:StartBannerTimer()
    end
  end
  return true
end

function M:HideCursor()
  if CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance) == "PC" then
    local GameInputSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(GWorld.GameInstance)
    GameInputSubsystem:SetMouseCursorVisable(false)
  end
end

function M:ShowCursor()
  if CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance) == "PC" then
    local GameInputSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(GWorld.GameInstance)
    GameInputSubsystem:SetMouseCursorVisable(true)
  end
end

function M:PlayVideoTop()
  DebugPrint("WBP_ShopMain_C PlayVideoTop")
  if CommonUtils:IfExistSystemGuideUI(self) then
    self:PlayVideoBG()
    return
  end
  if self.bPlayVideoTop then
    return
  end
  self:UpdateVideoKeyInfo()
  self.bPlayVideoTop = true
  self:HideUIExceptVideo(true, true)
  self.Group_Video:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Group_Video:SetFocus()
  self.VideoPlayer.MediaPlayer.OnEndReached:Add(self, self.OnPlayVideoTopEnd)
  self:HideCursor()
  self.VideoPlayer:SetLooping(true)
  self.VideoPlayer:Play()
  self:StopOtherSound()
  self:PlayVideoSound()
end

function M:StopOtherSound()
  AudioManager(self):PlayUISound(self, "event:/ui/common/gacha_amb", "GachaAmb", nil)
end

function M:ResumeOtherSound()
  AudioManager(self):SetEventSoundParam(self, "GachaAmb", {ToEnd = 1})
end

function M:PlayVideoSound()
  if not self.DisplayType or not self.DisplayId then
    DebugPrint("没有配置DisplayType或DisplayId，无法找到视频需要的声音")
    return
  end
  local SoundPath
  if self.DisplayType == CommonConst.DataType.Skin then
    local SkinInfo = DataMgr.Skin[self.DisplayId]
    if not SkinInfo then
      DebugPrint("DisplayId对应的Skin配置不存在")
      return
    end
    SoundPath = SkinInfo.GetSoundPath
  elseif self.DisplayType == CommonConst.DataType.Resource then
    local ResourceInfo = DataMgr.Resource[self.DisplayId]
    if not ResourceInfo then
      DebugPrint("DisplayId对应的Resource配置不存在")
      return
    end
    SoundPath = ResourceInfo.GetSoundPath
  elseif self.DisplayType == CommonConst.DataType.Char then
    local CharInfo = DataMgr.Char[self.DisplayId]
    local TargetName = CharInfo.GUIPathVariable
    if not TargetName then
      DebugPrint("DisplayId对应的Char配置不存在GUIPathVariable")
      return
    end
    SoundPath = "event:/ui/char/gacha_show_" .. TargetName
  end
  if not SoundPath then
    DebugPrint("DisplayType不是Skin、Resource、Char其中之一，无法找到声音")
    return
  end
  AudioManager(self):PlayUISound(self, SoundPath, "VideoSound", nil)
end

function M:StopVideoSound()
  AudioManager(self):StopSound(self, "VideoSound")
end

function M:OnPlayVideoTopEnd()
  self:StopVideoTop()
end

function M:StopVideoTop()
  DebugPrint("WBP_ShopMain_C StopVideoTop")
  if not self.bPlayVideoTop then
    return
  end
  self.bPlayVideoTop = false
  self:HideUIExceptVideo(false, false)
  self.VideoPlayer.MediaPlayer.OnEndReached:Remove(self, self.OnPlayVideoTopEnd)
  self:ShowCursor()
  self:ResumeOtherSound()
  self:StopVideoSound()
  self.bPlayVideoBG = true
  self:AddTimer(0.05, function()
    self:GamePadFocusToSelectBannerItem()
  end)
end

function M:PlayVideoBG()
  DebugPrint("WBP_ShopMain_C PlayVideoBG")
  if self.bPlayVideoBG then
    return
  end
  self.bPlayVideoBG = true
  self.Group_Video:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Group_BG:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.VideoPlayer:SetLooping(true)
  self.VideoPlayer:Play()
end

function M:StopVideoBG()
  DebugPrint("WBP_ShopMain_C StopVideoBG")
  if not self.bPlayVideoBG then
    return
  end
  self.bPlayVideoBG = false
  self.Group_Video:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Group_BG:SetVisibility(UIConst.VisibilityOp.Visible)
  self.VideoPlayer:Stop()
end

function M:GamePadFocusToSelectBannerItem()
  local SelectBannerItem = self:GetSelectBannerItem()
  if not SelectBannerItem or CommonUtils:IfExistSystemGuideUI(self) then
    return
  end
  SelectBannerItem:SetFocus()
end

function M:GetSelectBannerItem()
  if not self.SelectBannerId or self.ShowSwitchBanner then
    return self.Shop_RecommendBanner
  end
  local ScrollBoxChildrenTable = self.ScrollBox_Recommend:GetAllChildren():ToTable()
  if ScrollBoxChildrenTable and next(ScrollBoxChildrenTable) then
    for index, Widget in pairs(ScrollBoxChildrenTable) do
      if Widget.BannerId and Widget.BannerId == self.SelectBannerId then
        return Widget
      end
    end
  end
  return nil
end

function M:OnRepeatKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if self.TabType == "Banner" and self.SelectBannerId and self.BannerIdMap and type(self.BannerIdMap) == "table" then
    local CurrentPage = self.BannerIdMap[self.SelectBannerId]
    if CurrentPage and CurrentPage.HandleRepeatKeyDown and not IsHandled then
      IsHandled = CurrentPage:HandleRepeatKeyDown(InKey, InKeyName)
    end
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnResourceBarAddedToFocusPath()
  self.FocusOnResourceBar = true
end

function M:OnResourceBarRemovedFromFocusPath()
  self.FocusOnResourceBar = false
  if self.SelectBannerId and self.BannerIdMap and type(self.BannerIdMap) == "table" then
    local CurrentPage = self.BannerIdMap[self.SelectBannerId]
    if CurrentPage and CurrentPage.OnResourceBarRemovedFromFocusPath then
      CurrentPage:OnResourceBarRemovedFromFocusPath()
    end
  end
end

AssembleComponents(M)
return M
