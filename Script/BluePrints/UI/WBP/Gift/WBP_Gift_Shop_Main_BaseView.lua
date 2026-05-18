require("UnLua")
local M = {}
M._components = {
  "BluePrints.UI.UI_PC.Common.LSFocusComp",
  "BluePrints.UI.UI_PC.Common.HorizontalListViewResizeComp"
}
local GiftController = require("BluePrints.UI.WBP.Gift.GiftController")

function M:Construct()
end

function M:OnLoaded(...)
  if self.Super and self.Super.OnLoaded then
    self.Super.OnLoaded(self)
  end
  local Params = select(1, ...)
  local MainTabIdx, SubTabIdx, ShopItemId, CloseCallBack, CloseCallBackObj, FriendUid
  if type(Params) == "table" then
    MainTabIdx = Params.MainTabIdx
    SubTabIdx = Params.SubTabIdx
    ShopItemId = Params.ShopItemId
    FriendUid = Params.FriendUid
    CloseCallBack = Params.CloseCallBack
    CloseCallBackObj = Params.CloseCallBackObj
  else
    MainTabIdx, SubTabIdx, ShopItemId, CloseCallBack, CloseCallBackObj = ...
  end
  self.Filters = {
    "UI_Select_Default",
    "UI_Select_Time",
    "UI_RARITY_NAME",
    "UI_PRICE_NAME"
  }
  self.bFilterOwned = false
  self.FriendUid = FriendUid
  self:InitShop(MainTabIdx, SubTabIdx, ShopItemId, "GiftShop", false)
  self.List_Item:SetVisibility(ESlateVisibility.Visible)
  if self.List_Item and self.List_Item.OnCreateEmptyContent and self.List_Item.OnCreateEmptyContent.Bind then
    self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.ShopType = self.ShopType or "GiftShop"
      Content.ShopId = nil
      return Content
    end)
  end
  self.Text_BottomTabTips:SetText(GText("UI_Banner_Reminder"))
  self.Text_CountdownTime:SetVisibility(ESlateVisibility.Collapsed)
  if Params.FriendUid then
    self.Gift_ShopTarget.Parent = self
    self.Gift_ShopTarget:Init(Params.FriendUid, self.OnSelectedFriendChange)
  else
    local FreendList = FriendController:GetModel():GetFriendList()
    if FreendList and #FreendList > 0 then
      self.Gift_ShopTarget:Init(FreendList[1].Uid, self.OnSelectedFriendChange)
    end
    ScreenPrint("打开送礼商店没有传入好友ID")
  end
  self.Gift_ShopTarget.Parent = self
end

function M:OnSelectedFriendChange(Uid)
  self.FriendUid = Uid
  self:UpdateShopDetail(self.CurSubTabMap)
end

function M:GetGiftCandidateItems(SubTabData)
  local SubTabId = SubTabData and SubTabData.SubTabId
  if not SubTabId then
    return {}
  end
  local ids = GiftController:GetModel():GetGiftIdsByGiftSubTabId(SubTabId)
  if type(ids) ~= "table" then
    return {}
  end
  local res = {}
  local ShopItemTable = DataMgr and DataMgr.ShopItem or {}
  for i = 1, #ids do
    local id = ids[i]
    local ShopData = ShopItemTable[id]
    if ShopData then
      table.insert(res, ShopData)
    end
  end
  return res
end

function M:FilterGiftItems(CandidateList, Avatar, bFilterOwned)
  local out = {}
  for _, ShopData in ipairs(CandidateList) do
    local ShopItemId = ShopData.ItemId
    if ShopUtils:GetGiftItemCanShow(ShopItemId, self.FriendUid) then
      if not bFilterOwned or ShopData.ItemType == "Reward" then
        table.insert(out, ShopData)
      else
        local CheckFuncName = "Check" .. ShopData.ItemType .. "Enough"
        local CheckMethod = Avatar[CheckFuncName]
        local bOwn = CheckMethod and CheckMethod(Avatar, {
          [ShopData.TypeId] = 1
        }) or false
        if not bOwn then
          table.insert(out, ShopData)
        end
      end
    end
  end
  return out
end

function M:ComposeSortFunc(Filter1, SortType)
  local function BySequence(a, b)
    if SortType == CommonConst.ASC then
      if a.Sequence == b.Sequence then
        return a.ItemId > b.ItemId
      end
      return a.Sequence > b.Sequence
    else
      return a.Sequence < b.Sequence
    end
  end
  
  local function ByTime(a, b)
    if SortType == CommonConst.ASC then
      return a.StartTime < b.StartTime
    else
      return a.StartTime > b.StartTime
    end
  end
  
  local function ByRarity(a, b)
    local ItemDataA = DataMgr[a.ItemType][a.TypeId]
    local ItemDataB = DataMgr[b.ItemType][b.TypeId]
    local RarityA = ItemDataA.Rarity or ItemDataA.WeaponRarity or 1
    local RarityB = ItemDataB.Rarity or ItemDataB.WeaponRarity or 1
    if SortType == CommonConst.ASC then
      return RarityA < RarityB
    else
      return RarityA > RarityB
    end
  end
  
  local function ByPrice(a, b)
    if SortType == CommonConst.ASC then
      return ShopUtils:GetShopItemPrice(a.ItemId) < ShopUtils:GetShopItemPrice(b.ItemId)
    else
      return ShopUtils:GetShopItemPrice(a.ItemId) > ShopUtils:GetShopItemPrice(b.ItemId)
    end
  end
  
  if 1 == Filter1 then
    return function(a, b)
      if BySequence(a, b) then
        return true
      elseif BySequence(b, a) then
        return false
      elseif ByTime(a, b) then
        return true
      elseif ByTime(b, a) then
        return false
      elseif ByRarity(a, b) then
        return true
      elseif ByRarity(b, a) then
        return false
      elseif ByPrice(a, b) then
        return true
      elseif ByPrice(b, a) then
        return false
      else
        return false
      end
    end
  elseif 3 == Filter1 then
    return function(a, b)
      if ByRarity(a, b) then
        return true
      elseif ByRarity(b, a) then
        return false
      elseif BySequence(a, b) then
        return true
      elseif BySequence(b, a) then
        return false
      elseif ByTime(a, b) then
        return true
      elseif ByTime(b, a) then
        return false
      elseif ByPrice(a, b) then
        return true
      elseif ByPrice(b, a) then
        return false
      else
        return false
      end
    end
  elseif 2 == Filter1 then
    return function(a, b)
      if ByTime(a, b) then
        return true
      elseif ByTime(b, a) then
        return false
      elseif BySequence(a, b) then
        return true
      elseif BySequence(b, a) then
        return false
      elseif ByRarity(a, b) then
        return true
      elseif ByRarity(b, a) then
        return false
      elseif ByPrice(a, b) then
        return true
      elseif ByPrice(b, a) then
        return false
      else
        return false
      end
    end
  else
    return function(a, b)
      if ByPrice(a, b) then
        return true
      elseif ByPrice(b, a) then
        return false
      elseif BySequence(a, b) then
        return true
      elseif BySequence(b, a) then
        return false
      elseif ByTime(a, b) then
        return true
      elseif ByTime(b, a) then
        return false
      elseif ByRarity(a, b) then
        return true
      elseif ByRarity(b, a) then
        return false
      else
        return false
      end
    end
  end
end

function M:PartitionItemsByState(ShopDataList, Avatar)
  local NotSoldOutList, SoldOutList, LimitLevelList = {}, {}, {}
  for _, ShopData in pairs(ShopDataList) do
    local Remain
    if self.FriendUid then
      Remain = ShopUtils:GetGiftItemPurchaseLimit(ShopData.ItemId, self.FriendUid)
    else
      Remain = select(1, ShopUtils:GetContextRemainAndTotal(ShopData.ItemId))
    end
    if 0 == Remain then
      table.insert(SoldOutList, ShopData)
    else
      local NeedLevel = ShopData.UnlockLevel or 0
      if NeedLevel > Avatar.Level then
        table.insert(LimitLevelList, ShopData)
      else
        table.insert(NotSoldOutList, ShopData)
      end
    end
  end
  return NotSoldOutList, SoldOutList, LimitLevelList
end

function M:MergeItems(NotSoldOutList, LimitLevelList, SoldOutList, SortFunc)
  table.sort(NotSoldOutList, SortFunc)
  table.sort(SoldOutList, SortFunc)
  table.sort(LimitLevelList, SortFunc)
  local ShopDataList = {}
  for _, v in ipairs(NotSoldOutList) do
    table.insert(ShopDataList, v)
  end
  for _, v in ipairs(LimitLevelList) do
    table.insert(ShopDataList, v)
  end
  for _, v in ipairs(SoldOutList) do
    table.insert(ShopDataList, v)
  end
  return ShopDataList
end

function M:CommonInitPage(OverlayWidget, WidgetName)
  self.VB_ItemList:SetVisibility(ESlateVisibility.Collapsed)
  OverlayWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  local Widget
  local Count = OverlayWidget:GetChildrenCount()
  if Count and Count > 0 then
    Widget = OverlayWidget:GetChildAt(0)
  end
  if not Widget then
    Widget = UIManager(self):_CreateWidgetNew(WidgetName)
    OverlayWidget:AddChildToOverlay(Widget)
  end
  if "PayGiftPage" == WidgetName then
    self.PayGiftPage = Widget
    self.List_PayGift_Cached = Widget.List_PayGift
  end
  if self.Common_Tab.WBP_Com_Tab_ResourceBar then
    self.Common_Tab.WBP_Com_Tab_ResourceBar:SetLastFocusWidget(Widget)
  end
  local Slot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(Widget)
  Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
  Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
  Widget:PlayAnimation(Widget.In)
  return Widget
end

function M:RefreshGiftShopUI(ShopDataList)
  if self.CurSubTabMap and self.CurSubTabMap.TabType == "Pack" then
    self.VB_ItemList:SetVisibility(ESlateVisibility.Collapsed)
    self:InitPayGiftPage(ShopDataList)
    return
  end
  self.Group_PayGift:SetVisibility(ESlateVisibility.Collapsed)
  self.List_Item:ScrollIndexIntoView(0)
  self.List_Item:ClearListItems()
  self.ShopItemNum = #ShopDataList
  self.Index2ShopSkin = {}
  self.ShopSkin2Index = {}
  self.SkinCount = 0
  for i = 1, self.ShopItemNum do
    local ShopData = ShopDataList[i]
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.ShopType = self.ShopType
    Content.ShopId = ShopData.ItemId
    if UIUtils.CanOpenSkinPreview(ShopData.ItemType, ShopData.TypeId) then
      self.SkinCount = self.SkinCount + 1
      self.Index2ShopSkin[self.SkinCount] = ShopData.ItemId
      self.ShopSkin2Index[ShopData.ItemId] = self.SkinCount
    end
    if self.SelectShopItemId and self.SelectShopItemId == ShopData.ItemId and 0 ~= ShopUtils:GetGiftItemPurchaseLimit(self.SelectShopItemId, self.FriendUid) then
      self.ItemIndex = i - 1
    end
    self.List_Item:AddItem(Content)
  end
  local XAnchor = 0.5
  self:HorizontalListViewResize_SetUp(self.Group_Item, self.List_Item, XAnchor)
  local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem(self)
  if self.List_Item:GetNumItems() > 0 then
    self.VB_ItemList:SetVisibility(ESlateVisibility.Hidden)
    self.Group_Bottom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:AddTimer(0.1, function()
      self.VB_ItemList:SetVisibility(ESlateVisibility.Visible)
      self.Group_Empty:SetVisibility(ESlateVisibility.Collapsed)
      if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        GameInputModeSubsystem:SetNavigateWidgetVisibility(true)
      end
      self.List_Item:RequestFillEmptyContent()
      self.List_Item:RequestPlayEntriesAnim()
      local CommonDialog = UIManager(self):GetUIObj("CommonDialog")
      if (not CommonUtils:IfExistSystemGuideUI(self) or self:HasAnyFocus() or self:HasFocusedDescendants()) and (not CommonDialog or not CommonDialog:HasFocusedDescendants()) and not self.Common_SortList_PC:HasFocusedDescendants() and not self.Common_SortList_PC:HasAnyUserFocus() then
        self.List_Item:SetFocus()
        self.List_Item:ScrollIndexIntoView(self.ItemIndex)
      end
      self.ItemIndex = nil
    end)
  else
    self.Text_ShopItemEmpty:SetText(GText("UI_SendGift_NoItem"))
    GameInputModeSubsystem:SetNavigateWidgetVisibility(false)
    self.VB_ItemList:SetVisibility(ESlateVisibility.Collapsed)
    self.Group_Empty:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if self.bFilterOwned then
      self.Group_Bottom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
      self.Group_Bottom:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
end

function M:FocusListAfterRefresh(Delay)
  local delay = Delay or 0.1
  local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem(self)
  self:AddTimer(delay, function()
    if self.CurSubTabMap and (self.CurSubTabMap.TabType == "Pack" or self.CurSubTabMap.TabType == "Pay" or self.CurSubTabMap.TabType == "Banner" or self.CurSubTabMap.TabType == "Complex") then
      return
    end
    if not (self.List_Item and self.List_Item.GetNumItems) or self.List_Item:GetNumItems() <= 0 then
      return
    end
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
      GameInputModeSubsystem:SetNavigateWidgetVisibility(true)
    end
    self.VB_ItemList:SetVisibility(ESlateVisibility.Visible)
    self.Group_Empty:SetVisibility(ESlateVisibility.Collapsed)
    self.List_Item:RequestFillEmptyContent()
    self.List_Item:RequestPlayEntriesAnim()
    if not CommonUtils:IfExistSystemGuideUI(self) and (not self.Common_SortList_PC or (not self.Common_SortList_PC.HasAnyUserFocus or not self.Common_SortList_PC:HasAnyUserFocus()) and (not self.Common_SortList_PC.HasFocusedDescendants or not self.Common_SortList_PC:HasFocusedDescendants()) and not self.Common_SortList_PC.IsListViewOpened) then
      self.List_Item:SetFocus()
    end
    if self.List_Item.ScrollIndexIntoView then
      self.List_Item:ScrollIndexIntoView(0)
    end
  end)
end

function M:InitPayGiftPage(ShopItemsData)
  local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem(self)
  if type(ShopItemsData) ~= "table" then
    ShopItemsData = {}
  end
  local Widget = self:CommonInitPage(self.Group_PayGift, "PayGiftPage")
  self.PayGiftPage = Widget
  self.List_PayGift_Cached = Widget.List_PayGift
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
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and #ShopItemsData > 0 then
    GameInputModeSubsystem:SetNavigateWidgetVisibility(true)
  end
  if self.List_PayGift_Cached:GetNumItems() > 0 and not CommonUtils:IfExistSystemGuideUI(self) then
    self:AddTimer(0.05, function()
      if not self.Common_SortList_PC:HasFocusedDescendants() and not self.Common_SortList_PC:HasAnyUserFocus() then
        self.List_PayGift_Cached:SetFocus()
      end
    end)
  end
end

function M:UpdateShopDetail(SubTabData)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Filter1, SortType = self.Common_SortList_PC:GetSortInfos()
  local CandidateList = self:GetGiftCandidateItems(SubTabData)
  local ShopDataList = self:FilterGiftItems(CandidateList, Avatar, self.bFilterOwned)
  local SortFunc = self:ComposeSortFunc(Filter1, SortType)
  local NotSoldOutList, SoldOutList, LimitLevelList = self:PartitionItemsByState(ShopDataList, Avatar)
  local FinalList = self:MergeItems(NotSoldOutList, LimitLevelList, SoldOutList, SortFunc)
  self:RefreshGiftShopUI(FinalList)
end

function M:InitShopTabInfo(MainTabIdx, SubTabIdx, ShopType)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local MainShopTabData = DataMgr.Shop[self.ShopType or ShopType]
  assert(MainShopTabData, "获取商店类型信息失败:" .. tostring(self.ShopType or ShopType))
  self:LoadShopTabInfo(MainShopTabData)
  if self.Common_Tab and self.Common_Tab.Init then
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
      OwnerPanel = self,
      BackCallback = self.CloseSelf,
      InfoCallback = self.OnClick_Desc,
      LastFocusWidget = self.List_Item,
      GetReplyOnBack = function()
        if self.CurSubTabMap and self.CurSubTabMap.TabType == "Pack" then
          if self.List_PayGift_Cached and self.List_PayGift_Cached.SetFocus then
            self.List_PayGift_Cached:SetFocus()
          elseif self.PayGiftPage and self.PayGiftPage.SetFocus then
            self.PayGiftPage:SetFocus()
          end
        else
          self.List_Item:SetFocus()
        end
        return UIUtils.Handled
      end
    })
    if self.Common_Tab.WBP_Com_Tab_ResourceBar and self.List_Item then
      self.Common_Tab.WBP_Com_Tab_ResourceBar:SetLastFocusWidget(self.List_Item)
    end
    if self.Common_Tab.WBP_Com_Tab_ResourceBar and self.Common_Tab.GetReplyOnBack then
      self.Common_Tab.WBP_Com_Tab_ResourceBar:SetGetReplyOnBack(self.Common_Tab.GetReplyOnBack)
    end
  end
  if self.ShopTab and self.ShopTab.Init then
    self.ShopTab:Init({
      LeftKey = "Q",
      RightKey = "E",
      Tabs = self.MainTabList,
      ChildWidgetBPPath = "WidgetBlueprint'/Game/UI/WBP/Common/Tab/PC/WBP_Com_TabItem01_P.WBP_Com_TabItem01_P'"
    })
    if self.ShopTab.BindEventOnTabSelected then
      self.ShopTab:BindEventOnTabSelected(self, self.OnMainTabChanged)
    end
    if not MainTabIdx then
      self.ShopTab:SelectTab(1)
    else
      local mainSelectIdx = self.MainTabs and self.MainTabs[MainTabIdx] or MainTabIdx
      self.ShopTab:SelectTab(mainSelectIdx)
      if self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.SelectTab and self.SubTabMapIdx then
        local subIdx = self.SubTabMapIdx[SubTabIdx]
        if subIdx then
          self.Common_Toggle_TabGroup_PC:SelectTab(subIdx)
        end
      end
    end
  end
  self:RefreshGiftNum()
  self:AddDispatcher(EventID.OnSendGiftFinished, self, function()
    if IsValid(self) then
      self:RefreshGiftNum()
      self:UpdateShopDetail(self.CurSubTabMap)
    end
  end)
  self:AddDispatcher(EventID.OnRechargeFinished, self, M.OnRechargeFinished)
  if self.Common_Tab.Btn_Tip then
    self.Common_Tab.Panel_Tip:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  elseif self.Common_Tab.WBP_Com_Tab_ResourceBar and self.Common_Tab.WBP_Com_Tab_ResourceBar.Tip_PC then
    self.Common_Tab.WBP_Com_Tab_ResourceBar.Panel_Tip:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if self.MainTabList and #self.MainTabList <= 1 then
    self.Group_Tab:SetVisibility(ESlateVisibility.Collapsed)
  else
    self.Group_Tab:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  if self.AddLSFocusTarget and self.Common_SortList_PC then
    self:AddLSFocusTarget(nil, {
      self.Common_SortList_PC
    })
  end
  if self.AddLSFocusTarget and self.CheckBox_Own and self.CheckBox_Own.Com_KeyImg then
    self:AddLSFocusTarget(self.CheckBox_Own.Com_KeyImg, self.CheckBox_Own, "X", true)
  end
end

function M:OnMainTabChanged(TabWidget)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local MainTabId = self.MainTabMap and TabWidget and self.MainTabMap[TabWidget.Idx]
  if not MainTabId then
    return
  end
  self:LoadMainTabInfo(MainTabId)
  if self.Group_PayGift and self.Group_PayGift.SetVisibility then
    self.Group_PayGift:SetVisibility(ESlateVisibility.Collapsed)
  end
  if self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.Init then
    self.Common_Toggle_TabGroup_PC:Init({
      LeftKey = "A",
      RightKey = "D",
      Tabs = self.SubTabList,
      ChildWidgetName = "TabSubTextItem"
    })
    if self.Common_Toggle_TabGroup_PC.BindEventOnTabSelected then
      self.Common_Toggle_TabGroup_PC:BindEventOnTabSelected(self, self.OnSubTabChanged)
    end
    if #self.SubTabList <= 1 then
      self.Tab:SetVisibility(ESlateVisibility.Collapsed)
    else
      self.Tab:SetVisibility(ESlateVisibility.Visible)
    end
    self.Common_Toggle_TabGroup_PC:SelectTab(1)
  end
end

function M:OnSubTabChanged(TabWidget)
  local SubTabData = self.SubTabMap and TabWidget and self.SubTabMap[TabWidget.Idx]
  if not SubTabData then
    return
  end
  self:LoadSubTabInfo(SubTabData)
  if self.Group_PayGift and self.Group_PayGift.SetVisibility then
    self.Group_PayGift:SetVisibility(ESlateVisibility.Collapsed)
  end
  self:UpdateShopDetail(self.CurSubTabMap)
end

function M:OnClickFilterOwned()
  self.bFilterOwned = not self.bFilterOwned
  if self.CheckBox_Own and self.CheckBox_Own.SetChecked then
    self.CheckBox_Own:SetChecked(self.bFilterOwned)
  end
  self:UpdateShopDetail(self.CurSubTabMap)
end

function M:RefreshGiftNum()
  local ConsumeGiftNum, GiftNum = GiftModel:GetTotalGiftCount()
  if self.Text_Gift_Shop_TabTips then
    self.Text_Gift_Shop_TabTips:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    self.Text_Gift_Shop_TabTips:SetText(GText("UI_SendGift_SendTimes") .. ConsumeGiftNum .. "/" .. GiftNum)
  end
end

function M:OnClick_Desc()
  UIManager(self):ShowCommonPopupUI(100293, {
    LongText = self:GetQAText()
  })
end

function M:GetQAText()
  local ConsumeGiftQuota, TotalGiftQuota = GiftModel:GetTotalGiftQuota()
  return string.format(GText("UI_SendGift_Desc2"), TotalGiftQuota - ConsumeGiftQuota)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Gamepad then
    self:InitGamepadView()
    if not self:HasAnyFocus() and not self:HasFocusedDescendants() and self.List_Item and self.List_Item.SetFocus then
      self.List_Item:SetFocus()
    end
  else
    self:InitKeyboardView()
  end
end

function M:InitGamepadView()
  if self.CheckBox_Own and self.CheckBox_Own.Com_KeyImg and self.CheckBox_Own.Com_KeyImg.SetVisibility then
    self.CheckBox_Own.Com_KeyImg:SetVisibility(ESlateVisibility.Visible)
    if self.CheckBox_Own.Com_KeyImg.CreateCommonKey then
      self.CheckBox_Own.Com_KeyImg:CreateCommonKey({
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "X"}
        }
      })
    end
  end
end

function M:InitKeyboardView()
  if self.CheckBox_Own and self.CheckBox_Own.Com_KeyImg and self.CheckBox_Own.Com_KeyImg.SetVisibility then
    self.CheckBox_Own.Com_KeyImg:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:OnRechargeFinished(Result, GoodsId, ShopItems, OrderId)
  if Result == ErrorCode.RET_SUCCESS then
    self:UpdateShopDetail(self.CurSubTabMap)
  end
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Out then
    self:BlockAllUIInput(true, "SP_DisplayOnly")
    self:Close()
  elseif InAnimation == self.In then
    self:BlockAllUIInput(false)
  end
end

function M:CloseSelf()
  if self.IsAnimationPlaying and self:IsAnimationPlaying(self.Out) then
    return
  end
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  if self.PlayAnimationForward and self.IsAddInDeque then
    self:PlayAnimationForward(self.Out, UIConst.AnimOutSpeedWithPageJump and UIConst.AnimOutSpeedWithPageJump.LittleFastSpeed or nil)
  elseif self.PlayAnimation and self.Out then
    self:PlayAnimation(self.Out)
  else
    self:Close()
  end
end

function M:Destruct()
  if self.HorizontalListViewResize_TearDown then
    self:HorizontalListViewResize_TearDown()
  end
end

function M:SetFocus_Lua()
  DebugPrint("默认聚焦 SetFocus_Lua")
  if self.CurSubTabMap and self.CurSubTabMap.TabType == "Pack" then
    if self.List_PayGift_Cached and self.List_PayGift_Cached.GetNumItems and self.List_PayGift_Cached:GetNumItems() > 0 then
      self.List_PayGift_Cached:SetFocus()
      return
    end
    if self.PayGiftPage and self.PayGiftPage.SetFocus then
      self.PayGiftPage:SetFocus()
      return
    end
  end
  if self.List_Item and self.List_Item.GetNumItems and self.List_Item:GetNumItems() > 0 then
    self.List_Item:SetFocus()
  else
    self:SetFocus()
  end
end

AssembleComponents(M)
return M
