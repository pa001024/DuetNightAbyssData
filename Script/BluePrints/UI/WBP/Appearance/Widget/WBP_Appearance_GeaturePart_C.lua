require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Appearance.WBP_Appearance_MainWidget_Base_C"
})
M._components = {
  "BluePrints.UI.KeyInputComponent"
}
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local SkinNameFont = {
  nil,
  nil,
  "Font_Blue",
  "Font_Purple",
  "Font_Gold",
  "Font_Red"
}
local PageClickData = {
  "Up",
  nil,
  "Down"
}

function M:Construct()
  M.Super.Construct(self)
  self.bIsFocusable = true
  self.Loaded = false
end

function M:Init(Params)
  self.Parent = Params.Parent
  self.Type = CommonConst.ArmoryType.GeaturePart
  self.MainModel = self.Parent.MainModel
  self.ActorController = self.Parent.ActorController
  self.GestureContentsArray = {}
  self.GestureContents = {}
  self.GestureOwnedContents = {}
  self.QuickGestureArray = {}
  self.QuickGestureContents = {}
  self.QuickSlotWidgets = {}
  self.EnableDrag = true
  self.bEnableDragAndDrop = true
  self.bEnablePointerDetection = true
  self.bEnableHovered = true
  self.PageClick = nil
  self.SortType = CommonConst.DESC
  self.PageIndex = 1
  self.SelectSlot = 1
  self:InitGestureList()
  self:SortGestureList()
  self.SelectGestureId = self.SelectGestureId or next(self.GestureContents)
  self.PlayGestureId = -1
  self.SelectContent = self.GestureContents[self.SelectGestureId]
  self:UpdateGestureItem()
  self:UpdateQuickGestureItem()
  self:InitQuickSlotItem()
  self:InitSortList()
  self.List_Gesture.OnDragOver:Bind(self, self.OnListGestureDragOver)
  self.List_Gesture:SetAllowOverscroll(false)
  self.List_Gesture.BP_OnEntryInitialized:Add(self, self.OnEntryInitialized)
  self.List_Gesture.BP_OnItemClicked:Clear()
  self.List_Gesture.BP_OnItemClicked:Add(self, self.OnListItemClicked)
  self.Btn_Function:BindEventOnClicked(self, self.OnBtnFunctionClicked)
  self.Btn_Buy:BindEventOnClicked(self, self.OnBuyBtnClicked)
  self.Gruop_Gesture:Init(self)
  self.Gruop_Gesture.Btn_L:BindEventOnClicked(self, self.OnBtnLClicked)
  self.Gruop_Gesture.Btn_R:BindEventOnClicked(self, self.OnBtnRClicked)
  self.Gruop_Gesture:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Gruop_Gesture.WB_Btn:SetVisibility(UIConst.VisibilityOp.Visible)
  self:AddDispatcher(EventID.OnPurchaseShopItem, self, self.OnPurchaseShopItem)
  self.ActorController:SetCameraData(DataMgr.SkinPreviewCameraData)
  self:RefreshGesturePreview()
  self.Gruop_Gesture.Btn_L:ForbidBtn(true)
  self.Gruop_Gesture:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.Gruop_Gesture:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Gruop_Gesture:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Gesture:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Gesture:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Gesture:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.Com_Sort:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.Com_Sort:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Com_Sort:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.Com_Sort:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.Gruop_Gesture.Key_L:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Gruop_Gesture.Key_R:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Gruop_Gesture.Key_L:CreateGamepadKey(UIConst.GamePadImgKey.DPadUp)
  self.Gruop_Gesture.Key_R:CreateGamepadKey(UIConst.GamePadImgKey.DPadDown)
  self.Loaded = true
end

function M:InitGestureList()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.GestureContents = {}
  self.GestureContentsArray = {}
  self.GestureOwnedContents = {}
  for Id, ResourceData in pairs(DataMgr.Resource or {}) do
    if ResourceData.ResourceSType == "GestureItem" and not ResourceData.ExcludeCollect then
      local GestureContent = self:CreateGestureContent(DataMgr.Resource[Id])
      if GestureContent then
        if Avatar.Resources[GestureContent.Id] then
          GestureContent.IsOwned = true
          self.GestureOwnedContents[GestureContent.Id] = GestureContent
        else
          GestureContent.LockType = 2
        end
        table.insert(self.GestureContentsArray, GestureContent)
      end
    end
  end
end

function M:SortGestureList()
  if self.SortType == CommonConst.DESC then
    table.sort(self.GestureContentsArray, function(GestureA, GestureB)
      if GestureA.IsOwned ~= GestureB.IsOwned then
        if GestureA.IsOwned then
          return true
        else
          return false
        end
      end
      if GestureA.SortPriority ~= GestureB.SortPriority then
        return GestureA.SortPriority > GestureB.SortPriority
      end
      if GestureA.Id ~= GestureB.Id then
        return GestureA.Id > GestureB.Id
      end
    end)
  else
    table.sort(self.GestureContentsArray, function(GestureA, GestureB)
      if GestureA.IsOwned ~= GestureB.IsOwned then
        if GestureA.IsOwned then
          return false
        else
          return true
        end
      end
      if GestureA.SortPriority ~= GestureB.SortPriority then
        return GestureA.SortPriority < GestureB.SortPriority
      end
      if GestureA.Id ~= GestureB.Id then
        return GestureA.Id < GestureB.Id
      end
    end)
  end
end

function M:UpdateGestureItem()
  local WidgetCount = self.List_Gesture:ClearListItems()
  for Index, GestureContent in pairs(self.GestureContentsArray) do
    self.List_Gesture:AddItem(GestureContent)
    self.GestureContents[GestureContent.Id] = GestureContent
  end
end

function M:UpdateQuickGestureItem()
  self.QuickGestureArray = {}
  local Avatar = GWorld:GetAvatar()
  local QuickSlotData = Avatar.GestureItemPanel
  for CurPageIndex, PageGestureData in pairs(QuickSlotData) do
    for CurSlotIndex, GestureId in pairs(PageGestureData) do
      self.QuickGestureArray[GestureId] = true
      local PreWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Gesture, self.List_Gesture:GetIndexForItem(self.GestureContents[GestureId]))
      if PreWidget then
        PreWidget:SetItemSelect(true)
      end
    end
  end
end

function M:InitGestureInfoUI()
  local GestureConfig = DataMgr.Resource[self.SelectGestureId]
  if not GestureConfig then
    return
  end
  self.Tag_Quality:Init(GestureConfig.Rarity)
  self.Text_Name:SetText(GText(GestureConfig.ResourceName))
  self.Text_Info:SetText(GText(GestureConfig.DetailDes))
  self.Text_Gesture:SetText(GText(GestureConfig.FunctionDes))
  self.Text_Fenghua:SetText(GText("UI_AppearanceScore_ScoreName"))
  local FontName = GestureConfig.Rarity and SkinNameFont[GestureConfig.Rarity]
  if self.Text_Name and FontName and self[FontName] then
    self.Text_Name:SetFont(self[FontName])
  end
  self.Num_Fenghua:SetText(self:GetGestureScore(self.SelectGestureId, GestureConfig))
end

function M:CreateEmptyContent()
  local QuickGestureContent = NewObject(UIUtils.GetCommonItemContentClass())
  QuickGestureContent.ParentWidget = self
  QuickGestureContent.bEnableDrag = true
  QuickGestureContent.QuickSlotClicked = self.QuickSlotClicked
  QuickGestureContent.CreateDragWidget = self.CreateDragWidget
  QuickGestureContent.OnDragCancelled = self.OnDragCancelled
  QuickGestureContent.IsOwned = false
  QuickGestureContent.IsQuick = true
  return QuickGestureContent
end

function M:InitQuickSlotItem()
  local Avatar = GWorld:GetAvatar()
  local QuickSlotData = Avatar.GestureItemPanel
  for SlotIndex = 1, self.Gruop_Gesture.WB_Btn:GetChildrenCount() do
    local QuickWidget = self.Gruop_Gesture.WB_Btn:GetChildAt(SlotIndex - 1)
    local QuickGestureContent = self:CreateEmptyContent()
    if QuickSlotData and QuickSlotData[self.PageIndex] and -1 ~= QuickSlotData[self.PageIndex][SlotIndex] then
      QuickGestureContent = self:CreateGestureContent(DataMgr.Resource[QuickSlotData[self.PageIndex][SlotIndex]])
      QuickGestureContent.IsOwned = true
    end
    QuickGestureContent.SlotIndex = SlotIndex
    self.QuickGestureContents[SlotIndex] = QuickGestureContent
    self.QuickSlotWidgets[SlotIndex] = QuickWidget
    QuickWidget:SetVisibility(UIConst.VisibilityOp.Visible)
    QuickWidget:OnSlotPropObjectSet(QuickGestureContent)
  end
  local OwnQuickSlot = {}
  for CurPageIndex, PageGestureData in pairs(QuickSlotData) do
    for CurSlotIndex, GestureId in pairs(PageGestureData) do
      OwnQuickSlot[GestureId] = true
      self.QuickGestureArray[GestureId] = true
    end
  end
  local UnPutGestureId = -1
  for Index, GestureContent in pairs(self.GestureContentsArray) do
    if OwnQuickSlot and not OwnQuickSlot[GestureContent.Id] then
      UnPutGestureId = GestureContent.Id
      break
    end
  end
  self.SelectGestureId = UnPutGestureId
  self.SelectContent = self.GestureContents[self.SelectGestureId]
  self:QuickSlotClicked(1)
  self:SelectGestureItem(true)
end

function M:UpdateQuickSlotItem(IsPage)
  local Avatar = GWorld:GetAvatar()
  local QuickSlotData = Avatar.GestureItemPanel
  for SlotIndex = 1, self.Gruop_Gesture.WB_Btn:GetChildrenCount() do
    local QuickGestureContent = self:CreateEmptyContent()
    local QuickWidget = self.Gruop_Gesture.WB_Btn:GetChildAt(SlotIndex - 1)
    if QuickSlotData and QuickSlotData[self.PageIndex] and -1 ~= QuickSlotData[self.PageIndex][SlotIndex] then
      QuickGestureContent = self:CreateGestureContent(DataMgr.Resource[QuickSlotData[self.PageIndex][SlotIndex]])
      QuickGestureContent.IsOwned = true
    end
    QuickGestureContent.SlotIndex = SlotIndex
    self.QuickGestureContents[SlotIndex] = QuickGestureContent
    self.QuickSlotWidgets[SlotIndex] = QuickWidget
    QuickWidget:SetVisibility(UIConst.VisibilityOp.Visible)
    QuickWidget:OnSlotPropObjectSet(QuickGestureContent)
  end
  if not IsPage then
    self:QuickSlotClicked(self.SelectSlot)
  end
end

function M:SelectGestureItem(IsInit)
  local Avatar = GWorld:GetAvatar()
  local QuickSlotData = Avatar.GestureItemPanel
  if QuickSlotData and QuickSlotData[self.PageIndex] and -1 ~= QuickSlotData[self.PageIndex][self.SelectSlot] then
    local CurQuickSlotId = QuickSlotData[self.PageIndex][self.SelectSlot]
    local QuickGestureContent = self.QuickGestureContents[CurQuickSlotId]
    local CurGestureContent = self.GestureContents[CurQuickSlotId]
    if CurGestureContent.Id then
      self.List_Gesture:ScrollIndexIntoView(self.List_Gesture:GetIndexForItem(CurGestureContent), false, UE4.EDescendantScrollDestination.Top)
    end
    if IsInit or self.SelectContent.Id ~= CurQuickSlotId then
      local PreWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Gesture, self.List_Gesture:GetIndexForItem(self.SelectContent))
      if PreWidget then
        PreWidget:SetSelected(false)
      end
      self.SelectGestureId = CurQuickSlotId
      self.SelectContent = CurGestureContent
      self:AddTimer(0.1, self.DelaySelectItem, false, 0.1, self.TimeHandleName, true)
    end
  else
    local QuickSlot = {}
    for CurPageIndex, PageGestureData in pairs(QuickSlotData) do
      for CurSlotIndex, GestureId in pairs(PageGestureData) do
        if -1 ~= GestureId then
          QuickSlot[GestureId] = true
        end
      end
    end
    local UnPutGestureId = -1
    for Index, GestureContent in pairs(self.GestureContentsArray) do
      if QuickSlot and not QuickSlot[GestureContent.Id] then
        UnPutGestureId = GestureContent.Id
        break
      end
    end
    if -1 ~= UnPutGestureId then
      local CurGestureContent = self.GestureContents[UnPutGestureId]
      self.List_Gesture:ScrollIndexIntoView(self.List_Gesture:GetIndexForItem(CurGestureContent), false, UE4.EDescendantScrollDestination.Top)
    end
    if IsInit or self.SelectContent.Id ~= UnPutGestureId then
      local PreWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Gesture, self.List_Gesture:GetIndexForItem(self.SelectContent))
      if PreWidget then
        PreWidget:SetSelected(false)
      end
      self.SelectGestureId = UnPutGestureId
      self.SelectContent = self.GestureContents[UnPutGestureId]
      self:AddTimer(0.1, self.DelaySelectItem, false, 0.1, self.TimeHandleName, true)
    end
  end
  self:UpdateBtnFunction()
  self:InitGestureInfoUI()
  if self.PlayGestureId ~= self.SelectGestureId then
    self:RefreshGesturePreview()
  end
end

function M:DelaySelectItem()
  local TargetWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Gesture, self.List_Gesture:GetIndexForItem(self.SelectContent))
  if TargetWidget then
    TargetWidget:SetSelected(true)
  end
  self:RemoveTimer(self.TimeHandleName)
end

function M:UpdateQucikSlotItem(Content, SlotIndex, IsChange)
  local function UpdateQucikSlotItemCallBack(Ret, PageIndex, SlotIndex, ResourceId)
    if 0 == Ret then
      AudioManager(self):PlayUISound(nil, "event:/ui/common/weapon_replace", nil, nil)
      
      self.SelectSlot = SlotIndex
      self:UpdateQuickGestureItem()
      local QuickWidget = self.Gruop_Gesture.WB_Btn:GetChildAt(SlotIndex - 1)
      if QuickWidget and not IsChange then
        local PreSelectId = self.QuickGestureContents[SlotIndex].Id
        if PreSelectId and not self.QuickGestureArray[PreSelectId] then
          local PreWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Gesture, self.List_Gesture:GetIndexForItem(self.GestureContents[PreSelectId]))
          if PreWidget then
            PreWidget:SetItemSelect(false)
          end
        end
      end
      self:UpdateQuickSlotItem()
    end
  end
  
  local Avatar = GWorld:GetAvatar()
  Avatar:SetGestureItemPanel(UpdateQucikSlotItemCallBack, self.PageIndex, SlotIndex, Content.Id)
end

function M:RemoveQucikSlotItem(Content, SlotIndex)
  local function RemoveQucikSlotItemCallBack(Ret, PageIndex, SlotIndex)
    if 0 == Ret then
      self.SelectSlot = SlotIndex
      
      local QuickWidget = self.Gruop_Gesture.WB_Btn:GetChildAt(SlotIndex - 1)
      if QuickWidget then
        local QuickGestureContent = self:CreateEmptyContent()
        self.QuickSlotWidgets[SlotIndex] = QuickWidget
        QuickWidget:SetVisibility(UIConst.VisibilityOp.Visible)
        QuickGestureContent.SlotIndex = SlotIndex
        QuickWidget:OnSlotPropObjectSet(QuickGestureContent)
        self.QuickGestureContents[SlotIndex] = QuickGestureContent
        local PreWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Gesture, self.List_Gesture:GetIndexForItem(self.GestureContents[Content.Id]))
        if PreWidget then
          PreWidget:SetItemSelect(false)
        end
        local QuickSlot = {}
        local Avatar = GWorld:GetAvatar()
        local QuickSlotData = Avatar.GestureItemPanel
        local UnPutGestureId = -1
        for CurPageIndex, PageGestureData in pairs(QuickSlotData) do
          for CurSlotIndex, GestureId in pairs(PageGestureData) do
            if -1 ~= GestureId then
              QuickSlot[GestureId] = true
            end
          end
        end
        for Index, GestureContent in pairs(self.GestureContentsArray) do
          if QuickSlot and not QuickSlot[GestureContent.Id] then
            UnPutGestureId = GestureContent.Id
            break
          end
        end
        if -1 ~= UnPutGestureId then
          local CurGestureContent = self.GestureContents[UnPutGestureId]
        end
        self:UpdateBtnFunction()
      end
    end
  end
  
  local Avatar = GWorld:GetAvatar()
  Avatar:RemoveGestureItemPanel(RemoveQucikSlotItemCallBack, self.PageIndex, SlotIndex)
end

function M:OnListItemClicked(Content)
  if self.SelectContent.SelfWidget then
    self.SelectContent.SelfWidget:SetSelected(false)
  end
  self.SelectGestureId = Content.Id
  self.SelectContent = Content
  self:InitGestureInfoUI()
  if self.PlayGestureId ~= self.SelectGestureId then
    self:RefreshGesturePreview()
  end
  self:UpdateBtnFunction()
  Content.SelfWidget:SetSelected(true)
end

function M:OnBuyBtnClicked()
  local ShopItemId = ShopUtils:GetShopItemDataById(self.SelectGestureId, CommonConst.DataType.Resource, true)
  local ShopItemData = DataMgr.ShopItem[ShopItemId]
  if not ShopItemData then
    return
  end
  local Price = ShopUtils:GetShopItemPrice(ShopItemData.ItemId)
  UIManager(self):ShowCommonPopupUI(100041, {
    ShopItemData = ShopItemData,
    ShopType = 0,
    Funds = {
      {
        FundId = ShopItemData.PriceType,
        FundNeed = Price
      }
    },
    ShowParentTabCoin = true,
    SingleItemNotInteractive = true,
    RightCallbackObj = self,
    RightCallbackFunction = self.PurchaseAccessory
  }, self)
end

function M:PurchaseAccessory(PackageResult, DialogWidget)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local ShopItemId = ShopUtils:GetShopItemDataById(self.SelectGestureId, CommonConst.DataType.Resource, true)
  local ShopItemData = DataMgr.ShopItem[ShopItemId]
  if not ShopItemData then
    return
  end
  local SelectedDiscount
  if PackageResult and PackageResult.Content_1 and PackageResult.Content_1.CallObj and PackageResult.Content_1.CallObj.SelectedDiscount then
    SelectedDiscount = PackageResult.Content_1.CallObj.SelectedDiscount
  end
  Avatar:PurchaseShopItem(ShopItemData.ItemId, 1, nil, nil, SelectedDiscount and SelectedDiscount.VoucherId or nil)
end

function M:OnPurchaseShopItem(Ret)
  if Ret == ErrorCode.RET_SUCCESS then
    self:InitGestureList()
    self:SortGestureList()
    self:UpdateGestureItem()
    self:UpdateQuickGestureItem()
    self:UpdateBtnFunction()
    self:InitQuickSlotItem()
    self.SelectGestureId = self.SelectGestureId or next(self.GestureContents)
    self.SelectContent = self.GestureContents[self.SelectGestureId]
    return
  end
end

function M:UpdateBtnFunction()
  local Avatar = GWorld:GetAvatar()
  if self.SelectContent.IsOwned then
    self.WS_BtnState:SetActiveWidgetIndex(0)
    if self.QuickGestureContents[self.SelectSlot].Id then
      if self.QuickGestureContents[self.SelectSlot].Id == self.SelectContent.Id then
        self.Btn_Function.Text_Button:SetText(GText("UI_AppearanceScore_Unequip"))
      elseif self.QuickGestureContents[self.SelectSlot].Id ~= nil then
        self.Btn_Function.Text_Button:SetText(GText("UI_AppearanceScore_Replace"))
      end
    else
      self.Btn_Function.Text_Button:SetText(GText("UI_Accessory_Equip"))
    end
  else
    local ShopItemId, ShopItemData = ShopUtils:GetShopItemDataById(self.SelectGestureId, CommonConst.DataType.Resource, true)
    if ShopItemData then
      self.WS_BtnState:SetActiveWidgetIndex(1)
      local NeedCoinCount = ShopItemData.Price
      local CoinResource = Avatar.Resources[ShopItemData.PriceType] or {Count = 0}
      local Denominator = NeedCoinCount
      local UnitPrice = ShopUtils:GetShopItemPrice(ShopItemData.ItemId)
      self.Btn_Buy:SetText(GText("UI_SHOP_PURCHASE"))
      if NeedCoinCount > CoinResource.Count then
        Denominator = Denominator + 1
        self.Btn_Buy:ForbidBtn(true)
        self.Btn_Buy:PlayAnimation(self.Btn_Buy.Forbidden)
      else
        self.Btn_Buy:ForbidBtn(false)
        self.Btn_Buy:PlayAnimation(self.Btn_Buy.Normal)
      end
      self.Panel_Buy:SetVisibility(UIConst.VisibilityOp.Visible)
      self.WBP_Com_Cost:InitContent({
        Owner = self,
        ResourceId = ShopItemData.PriceType,
        Numerator = UnitPrice,
        Denominator = UnitPrice,
        bShowDenominator = false,
        IsGamePadIconVisible = false
      })
    else
      self.Panel_Buy:SetVisibility(UIConst.VisibilityOp.Collapsed)
      local GestureData = DataMgr.Resource[self.SelectGestureId]
      if GestureData and GestureData.AccessKey then
        local AccessData = DataMgr.Access[GestureData.AccessKey[1]]
        local AccessText = GText(AccessData.AccessText)
        if AccessData.AccessKey == "Shop_Main" then
          self.WS_BtnState:SetActiveWidgetIndex(4)
          self.Text_Lock:SetText(GText("UI_AppearanceScore_Soldout"))
        elseif AccessText then
          self.WS_BtnState:SetActiveWidgetIndex(3)
          self.Text_Lock:SetText(AccessText)
          if self.Panel_Lock then
            self.Panel_Lock:SetVisibility(UIConst.VisibilityOp.Visible)
          end
        end
      end
    end
  end
end

function M:OnBtnFunctionClicked()
  local Avatar = GWorld:GetAvatar()
  if self.QuickGestureContents[self.SelectSlot].Id == self.SelectContent.Id then
    self:RemoveQucikSlotItem(self.SelectContent, self.SelectSlot)
  else
    self:UpdateQucikSlotItem(self.SelectContent, self.SelectSlot)
  end
end

function M:QuickSlotClicked(SlotIndex)
  self.SelectSlot = SlotIndex
  for Index, QuickSlotWidget in ipairs(self.QuickSlotWidgets) do
    QuickSlotWidget:QuickSlotClicked(SlotIndex)
  end
  self:SelectGestureItem()
end

function M:UpdatePage()
  if self.PageClick == "Up" then
    if self.PageIndex > 1 then
      self.PageIndex = self.PageIndex - 1
      self:UpdateQuickSlotItem(true)
      self:UpdatePageInfo()
    end
    if self.PageIndex < 4 then
      self.Gruop_Gesture.Btn_R:ForbidBtn(false)
    end
    if 1 == self.PageIndex then
      self.Gruop_Gesture.Btn_L:ForbidBtn(true)
    end
  elseif self.PageClick == "Down" then
    if self.PageIndex < 4 then
      self.PageIndex = self.PageIndex + 1
      self:UpdateQuickSlotItem(true)
      self:UpdatePageInfo()
    end
    if self.PageIndex > 1 then
      self.Gruop_Gesture.Btn_L:ForbidBtn(false)
    end
    if 4 == self.PageIndex then
      self.Gruop_Gesture.Btn_R:ForbidBtn(true)
    end
  end
  AudioManager(self):PlayUISound(nil, "event:/ui/common/sub_bar_content_scroll", nil, nil)
  self.PageClick = nil
  self:UpdateBtnFunction()
end

function M:OnBtnLClicked()
  AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_add", nil, nil)
  if not self.PageClick then
    self.Gruop_Gesture:PlayAnimation(self.Gruop_Gesture.Up)
    self.PageClick = "Up"
  end
end

function M:OnBtnRClicked()
  AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_add", nil, nil)
  if not self.PageClick then
    self.Gruop_Gesture:PlayAnimation(self.Gruop_Gesture.Down)
    self.PageClick = "Down"
  end
end

function M:UpdatePageInfo()
  self.Gruop_Gesture.GesturePoint.WS_State:SetActiveWidgetIndex(0)
  self.Gruop_Gesture.GesturePoint_1.WS_State:SetActiveWidgetIndex(0)
  self.Gruop_Gesture.GesturePoint_2.WS_State:SetActiveWidgetIndex(0)
  self.Gruop_Gesture.GesturePoint_3.WS_State:SetActiveWidgetIndex(0)
  if 1 == self.PageIndex then
    self.Gruop_Gesture.GesturePoint.WS_State:SetActiveWidgetIndex(1)
  elseif 2 == self.PageIndex then
    self.Gruop_Gesture.GesturePoint_1.WS_State:SetActiveWidgetIndex(1)
  elseif 3 == self.PageIndex then
    self.Gruop_Gesture.GesturePoint_2.WS_State:SetActiveWidgetIndex(1)
  elseif 4 == self.PageIndex then
    self.Gruop_Gesture.GesturePoint_3.WS_State:SetActiveWidgetIndex(1)
  end
end

function M:OnCurrentSoltChanged(SlotIndex)
  if -1 ~= SlotIndex then
    self.IsDrop = true
  else
    self.IsDrop = false
  end
  self.CurrentSlotIndex = SlotIndex
end

function M:OnDragCancelled(PointerEvent, Operation)
  local DragContent = Operation.Payload
  if Operation.Tag == "WBP_GestureBtn_C" and nil ~= DragContent and -1 ~= DragContent.SlotIndex then
    local DragSlotIndex = DragContent.SlotIndex
    self:RemoveQucikSlotItem(DragContent, DragSlotIndex)
  end
end

function M:CreateDragWidget(Content, Slot)
  if not Content.IsOwned then
    return
  end
  if not IsValid(self._DragWidget) then
    self._DragWidget = UIManager(self):CreateWidget("/Game/UI/WBP/Armory/Widget/Unit/WBP_Armory_Item_Drag.WBP_Armory_Item_Drag", false)
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/combat_bag_cell_drag_common", nil, nil)
  local IconDynaMaterial = self._DragWidget.Prop_Icon:GetDynamicMaterial()
  if IconDynaMaterial then
    IconDynaMaterial:SetTextureParameterValue("MainTex", LoadObject(Content.Icon))
  end
  return self._DragWidget
end

function M:OnListGestureDragOver(MyGeometry, PointerEvent)
  return IsValid(self._DragWidget) and self._DragWidget:IsVisible()
end

function M:OnEntryInitialized(MyGeometry, PointerEvent)
  self:UpdateQuickGestureItem()
end

function M:RefreshGesturePreview()
  if not self.ActorController or not self.SelectGestureId then
    return
  end
  if not self.ArmoryRotation then
    self.ArmoryRotation = self.ActorController:GetArmoryPlayerRotation()
  end
  self.ActorController:StopPlayerMontage()
  local GestureData = DataMgr.Resource[self.SelectGestureId]
  self.ActorController:ResetActorRotation()
  self.ActorController:SetExCameraOffset(FVector(-100, 0, 0))
  self.ActorController:DestroyAllPlayerWeapons()
  if GestureData.PlayArmoryAnim then
    local ActionName = Const.ArmoryActionIdToArmoryTag[GestureData.PlayArmoryAnim]
    if ActionName == Const.Melee then
      local ServerWeapon = self.MainModel:GetSelectedMeleeWeapon()
      if not ServerWeapon then
        local Avatar = GWorld:GetAvatar()
        ServerWeapon = Avatar.Weapons[Avatar.MeleeWeapon]
      end
      self.ActorController:ChangeWeaponModel(ServerWeapon)
    elseif ActionName == Const.Ranged then
      local ServerWeapon = self.MainModel:GetSelectedRangedWeapon()
      if not ServerWeapon then
        local Avatar = GWorld:GetAvatar()
        ServerWeapon = Avatar.Weapons[Avatar.RangedWeapon]
      end
      self.ActorController:ChangeWeaponModel(ServerWeapon)
    end
  end
  self.ActorController:PlayResourceMotion(self.SelectGestureId)
  self.PlayGestureId = self.SelectGestureId
  if GestureData then
    self.ActorController:SetArmoryCameraTag(GestureData.CameraName or "Char", "", "")
  end
  local ResEntry = DataMgr.Resource[self.SelectGestureId]
  if ResEntry and ResEntry.SkyBoxIndex ~= nil then
    self.ActorController:ChangeSkyBoxColor(ResEntry.SkyBoxIndex)
  else
    self.ActorController:ChangeSkyBoxColor(0)
  end
end

function M:CreateGestureContent(Data)
  if Data then
    local bCreateContent = true
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return
    end
    if bCreateContent then
      local Obj = NewObject(UIUtils.GetCommonItemContentClass())
      Obj.Id = Data.ResourceId
      Obj.ItemType = CommonConst.DataType.Resource
      Obj.Icon = Data.Icon or ""
      Obj.SortPriority = Data.SortPriority or 0
      Obj.IsHide = Data.IsHide
      Obj.LockType = 0
      Obj.Rarity = Data.Rarity or 0
      Obj.bSelectTag = false
      Obj.IsSelect = false
      Obj.ParentWidget = self
      Obj.bEnableDrag = true
      Obj.AccessoryType = "Gesture"
      Obj.UnlockOptionText = GText(Data.UnlockOption or "")
      Obj.Name = Data.ResourceName
      Obj.Des = Data.DetailDes
      Obj.bIsFocusable = true
      Obj.CreateDragWidget = self.CreateDragWidget
      Obj.QuickSlotClicked = self.QuickSlotClicked
      Obj.OnDragCancelled = self.OnDragCancelled
      Obj.OnFocusReceivedEvent = {
        Obj = self,
        Callback = function()
          if self.CurInputDeviceType == ECommonInputType.Gamepad then
            self:OnListItemClicked(Obj)
          end
        end
      }
      Obj.OnMouseButtonUpEvents = {
        Obj = self,
        Callback = function()
          if self.CurInputDeviceType == ECommonInputType.Gamepad then
            self:OnBtnGamePadClick()
          end
        end
      }
      return Obj
    end
  end
end

function M:GetZOrder()
  if self.Parent and self.Parent.GetZOrder then
    return self.Parent:GetZOrder()
  end
  if self.Root and self.Root.GetZOrder then
    return self.Root:GetZOrder()
  end
  return 0
end

function M:InitSortList()
  self.Com_Sort:Init(self, {
    GText("UI_Select_Default")
  }, CommonConst.DESC, {})
  self.Com_Sort:BindEventOnSelectionsChanged(self, self.OnSelectionsChanged)
  self.Com_Sort:BindEventOnSortTypeChanged(self, self.OnSortTypeChanged)
end

function M:OnSelectionsChanged(SortBy, SortType)
end

function M:OnSortTypeChanged(SortType, SortBy)
  if self.SortType == CommonConst.ASC then
    self.SortType = CommonConst.DESC
  else
    self.SortType = CommonConst.ASC
  end
  self:SortGestureList()
  self:UpdateGestureItem()
  self:SelectGestureItem()
end

function M:GetGestureScore(GestureId, GestureConfig)
  for _, ScoreInfo in pairs(DataMgr.AppearanceSingleScore or {}) do
    if ScoreInfo.Type == "Resource" and ScoreInfo.Id == GestureId then
      return ScoreInfo.Score or 0
    end
  end
  local Rarity = GestureConfig and GestureConfig.Rarity
  for _, ScoreInfo in pairs(DataMgr.AppearanceScore or {}) do
    if ScoreInfo.Type == "Resource" and ScoreInfo.Rarity == Rarity then
      return ScoreInfo.Score or 0
    end
  end
  return 0
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.CurInputDeviceType = CurInputDevice
  self.IsGamepadInput = self.CurInputDeviceType == ECommonInputType.Gamepad
  self:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  if self.IsGamepadInput then
    self.Gruop_Gesture.Key_L:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Gruop_Gesture.Key_R:SetVisibility(UIConst.VisibilityOp.Visible)
  else
    self.Gruop_Gesture.Key_L:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Gruop_Gesture.Key_R:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  self:OnFocusChanged()
end

function M:OnFocusChanged()
  if not self.Loaded then
    return
  end
  local TargetWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Gesture, self.List_Gesture:GetIndexForItem(self.SelectContent))
  if TargetWidget and self.IsGamepadInput then
    TargetWidget:SetFocus(true)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.IsGamepadInput() then
    local DesiredFocusTarget = self:GetDesiredFocusTarget()
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), DesiredFocusTarget)
  end
  return UIUtils.Handled
end

function M:GetDesiredFocusTarget()
  return self.QuickSlotWidgets[1]
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.DPadUp then
    self:OnBtnLClicked()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif InKeyName == UIConst.GamePadKey.DPadDown then
    self:OnBtnRClicked()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnParentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == Const.GamepadLeftThumbstick then
    self.Com_Sort:SetFocus()
    return true
  end
  return UIUtils.Unhandled
end

function M:OnBtnGamePadClick(MyGeometry, InKeyEvent)
  if self.SelectContent.IsOwned then
    self:OnBtnFunctionClicked()
  else
    self:OnBuyBtnClicked()
  end
end

function M:OnFocusLost(InFocusEvent)
end

function M:OnTabChangeToOther()
  self:PlayOutAnim()
  self.ActorController:DestroyAllPlayerWeapons()
  self.ActorController.bEnableReflection = true
  self.ActorController:HidePlayerActorInternal(self.ActorController:GetReflectionActor(self.ActorController:GetPlayerActor()), "ReflectionHideByGesture", false)
  self.ActorController:SetCameraData()
  self.ActorController:ChangeSkyBoxColor(0)
end

function M:OnTabChangeToSelf()
  self:OnFocusChanged()
  self:PlayInAnim()
  self.ActorController:HidePlayerActorInternal(self.ActorController:GetReflectionActor(self.ActorController:GetPlayerActor()), "ReflectionHideByGesture", true)
  self.ActorController.bEnableReflection = false
  self.ActorController:SetCameraData(DataMgr.SkinPreviewCameraData)
  self:RefreshGesturePreview()
  self:UpdateBtnFunction()
end

function M:OnClose()
  self.ActorController.bEnableReflection = true
  self.ActorController:HidePlayerActorInternal(self.ActorController:GetReflectionActor(self.ActorController:GetPlayerActor()), "ReflectionHideByGesture", false)
  self:PlayOutAnim()
  self.ActorController:SetCameraData()
end

function M:PlayInAnim()
  self:StopAnimation(self.Out)
  self:PlayAnimation(self.In)
end

function M:PlayOutAnim()
  self:StopAnimation(self.In)
  self:PlayAnimation(self.Out)
end

return M
