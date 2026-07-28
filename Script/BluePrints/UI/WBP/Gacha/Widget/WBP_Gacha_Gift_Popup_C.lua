require("UnLua")
local TimeUtils = require("Utils.TimeUtils")
local EMCache = require("EMCache.EMCache")
local M = Class({
  "BluePrints.UI.BP_UIState_C",
  "BluePrints.Common.TimerMgr"
})
local COUNTDOWN_TIMER_KEY = "GiftPopupCountdown"

local function GetPackReadKey(PackId)
  return string.format("PopupPack%dRead", PackId)
end

function M:Construct()
  self.Btn_Left:BindEventOnClicked(self, self.OnClickPrev)
  self.Btn_Right:BindEventOnClicked(self, self.OnClickNext)
  if self.Btn_Close and self.Btn_Close.btn_close then
    self.Btn_Close.btn_close.OnClicked:Add(self, self.OnClickClose)
  end
  self.Btn_GiftPay:BindEventOnClicked(self, self.OnClickBuy)
  self:AddDispatcher(EventID.OnPurchaseShopItem, self, self.OnPurchaseShopItem)
  self:AddDispatcher(EventID.OnRechargeFinished, self, self.OnRechargeFinished)
  self:InitNavigation()
  self:InitGamepadKeyImg()
  self:SetFocus()
end

function M:InitGamepadKeyImg()
  if self.Key_Left and self.Key_Left.CreateGamepadKey then
    self.Key_Left:CreateGamepadKey(UIConst.GamePadImgKey.LeftShoulder)
    self.Key_Left:SetVisibility(ESlateVisibility.Collapsed)
  end
  if self.Key_Right and self.Key_Right.CreateGamepadKey then
    self.Key_Right:CreateGamepadKey(UIConst.GamePadImgKey.RightShoulder)
    self.Key_Right:SetVisibility(ESlateVisibility.Collapsed)
  end
  if self.Btn_GiftPay and self.Btn_GiftPay.SetDefaultGamePadImg then
    self.Btn_GiftPay:SetDefaultGamePadImg(UIConst.GamePadImgKey.FaceButtonLeft)
  end
end

function M:InitNavigation()
  self.List_Item:SetNavigationRuleBase(UE4.EUINavigation.Up, UE4.EUINavigationRule.Stop)
  self.List_Item:SetNavigationRuleBase(UE4.EUINavigation.Down, UE4.EUINavigationRule.Stop)
  self.List_Item:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
  self.List_Item:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
end

function M:Destruct()
  self:RemoveTimer(COUNTDOWN_TIMER_KEY)
end

function M:OnEndClose()
  if IsValid(self.GiftParent) and self.GiftParent.OnGiftPopupClosed then
    self.GiftParent:OnGiftPopupClosed()
  end
end

function M:OnPurchaseShopItem(Ret)
  if not ErrorCode:Check(Ret) then
    return
  end
  self:RefreshAfterPurchase()
end

function M:OnRechargeFinished(Result)
  if Result ~= ErrorCode.RET_SUCCESS then
    return
  end
  self:RefreshAfterPurchase()
end

function M:RefreshAfterPurchase()
  if not self.PackIdList then
    return
  end
  for i = #self.PackIdList, 1, -1 do
    local PackId = self.PackIdList[i]
    local Config = DataMgr.PopupPack[PackId]
    local RemainLimit = Config and ShopUtils:GetShopItemPurchaseLimit(Config.ShopItemId)
    if not RemainLimit or not (RemainLimit > 0) then
      table.remove(self.PackIdList, i)
      if i < self.CurrentIndex then
        self.CurrentIndex = self.CurrentIndex - 1
      end
    end
  end
  if 0 == #self.PackIdList then
    EventManager:FireEvent(EventID.OnPopupPackStateUpdate)
    self:OnClickClose()
    return
  end
  if self.CurrentIndex < 1 then
    self.CurrentIndex = 1
  end
  if self.CurrentIndex > #self.PackIdList then
    self.CurrentIndex = #self.PackIdList
  end
  self.bAfterPurchase = true
  self:RefreshCurrentPack()
  self.bAfterPurchase = false
  EventManager:FireEvent(EventID.OnPopupPackStateUpdate)
end

function M:Open(PackIdList)
  if not PackIdList or 0 == #PackIdList then
    return
  end
  self.PackIdList = PackIdList
  self.CurrentIndex = 1
  self.PendingIndex = nil
  self.bClosing = false
  self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self:RefreshCurrentPack()
  if self.In then
    self:PlayAnimation(self.In)
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/gacha_pool_gift_pack_show", "GachaGiftPackShow", nil)
end

function M:OnClickClose()
  if self.bClosing then
    return
  end
  self.bClosing = true
  AudioManager(self):SetEventSoundParam(self, "GachaGiftPackShow", {ToEnd = 1})
  self:RemoveTimer(COUNTDOWN_TIMER_KEY)
  if self.In then
    self:StopAnimation(self.In)
  end
  if self.Out then
    self:BindToAnimationFinished(self.Out, {
      self,
      self.Close
    })
    self:PlayAnimation(self.Out)
  else
    self:Close()
  end
end

function M:CloseByParent()
  self.bClosing = true
  AudioManager(self):SetEventSoundParam(self, "GachaGiftPackShow", {ToEnd = 1})
  self:RemoveTimer(COUNTDOWN_TIMER_KEY)
  self:Close()
end

function M:Info_Change()
  if self.PendingIndex then
    self.CurrentIndex = self.PendingIndex
    self.PendingIndex = nil
    self:RefreshCurrentPack()
  end
end

function M:RefreshCurrentPack()
  local PackId = self.PackIdList[self.CurrentIndex]
  local PopupPackConfig = DataMgr.PopupPack[PackId]
  if not PopupPackConfig then
    return
  end
  local ShopItemId = PopupPackConfig.ShopItemId
  local ShopItemData = DataMgr.ShopItem[ShopItemId]
  if not ShopItemData then
    return
  end
  self:MarkPackRead(PackId)
  local RewardData = DataMgr.Reward[ShopItemData.TypeId]
  if PopupPackConfig.Name then
    self.Text_GachaGiftTitle:SetText(GText(PopupPackConfig.Name))
  end
  if PopupPackConfig.Desc and PopupPackConfig.Desc ~= "" then
    self.Text_Desc:SetText(GText(PopupPackConfig.Desc))
  else
    self.Text_Desc:SetText("")
  end
  if PopupPackConfig.DisplayPath and "" ~= PopupPackConfig.DisplayPath then
    local Texture = LoadObject(PopupPackConfig.DisplayPath)
    if Texture then
      self.Image_Icon:SetBrushResourceObject(Texture)
    end
  end
  self:RefreshItemList(RewardData)
  local PurchaseLimit = ShopItemData.PurchaseLimit or 1
  local RemainLimit = ShopUtils:GetShopItemPurchaseLimit(ShopItemId)
  RemainLimit = RemainLimit or 0
  self.Text_Limit:SetText(GText("UI_SHOP_SHOPITEMLIMIT") .. string.format("%d/%d", RemainLimit, PurchaseLimit))
  self:RefreshDiscountBadge(ShopItemData.ShowBonus)
  self:StartCountdown(PackId)
  self:RefreshBuyBtn(ShopItemId, RemainLimit)
  self:RefreshPageNav()
end

function M:RefreshDiscountBadge(ShowBonus)
  if not ShowBonus or ShowBonus <= 0 then
    self.Group_More:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  self.Group_More:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Text_MoreNum:SetText(tostring(ShowBonus))
  if self.Text_MoreNum_1 then
    self.Text_MoreNum_1:SetText("%")
  end
end

function M:RefreshItemList(RewardData)
  self.List_Item:ClearListItems()
  if not RewardData or not RewardData.Id then
    return
  end
  local FirstItem
  for i = 1, #RewardData.Id do
    local ItemId = RewardData.Id[i]
    local ItemType = RewardData.Type[i]
    local Count = RewardUtils:GetCount(RewardData.Count[i])
    local Icon = ItemUtils.GetItemIconPath(ItemId, ItemType)
    local ItemData = DataMgr[ItemType] and DataMgr[ItemType][ItemId]
    local Item = NewObject(UIUtils.GetCommonItemContentClass())
    Item.Id = ItemId
    Item.ItemType = ItemType
    Item.Count = Count
    Item.Icon = Icon
    Item.Rarity = ItemData and (ItemData.Rarity or ItemData.WeaponRarity) or 1
    Item.UIName = "GachaGiftPopup"
    Item.IsShowDetails = true
    Item.MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight
    Item.OnMenuOpenChangedEvents = {
      Obj = self,
      Callback = self.OnItemMenuOpenChanged
    }
    self.List_Item:AddItem(Item)
    if 1 == i then
      FirstItem = Item
    end
  end
  if FirstItem then
    if not self.bAfterPurchase then
      self.List_Item:NavigateToIndex(0)
    end
    self.List_Item:BP_SetSelectedItem(FirstItem)
  end
end

function M:RefreshBuyBtn(ShopItemId, RemainLimit)
  local Btn = self.Btn_GiftPay
  local ShopItemData = DataMgr.ShopItem[ShopItemId]
  if not ShopItemData then
    return
  end
  local CanBuy = RemainLimit and RemainLimit > 0
  local Cost = ShopUtils:GetShopItemPrice(ShopItemId)
  if DataMgr.ShopItem2PayGoods[ShopItemId] then
    if Btn.WS_Detail then
      Btn.WS_Detail:SetActiveWidgetIndex(0)
    end
    if Btn.Text_PriceMoneySymbol then
      Btn.Text_PriceMoneySymbol:SetText(GText(ShopUtils:GetCurrencyType()))
    end
    if Btn.Text_PriceMoneyNum then
      Btn.Text_PriceMoneyNum:SetText(tostring(Cost))
    end
  else
    if Btn.WS_Detail then
      Btn.WS_Detail:SetActiveWidgetIndex(1)
    end
    local ResourceData = DataMgr.Resource[ShopItemData.PriceType]
    if Btn.Icon_Currency and ResourceData then
      Btn.Icon_Currency:Init({
        Id = ShopItemData.PriceType,
        Icon = LoadObject(ResourceData.Icon),
        ItemType = "Resource",
        UIName = "GachaGiftPopup",
        IsShowDetails = false
      })
    end
    if Btn.Text_Price then
      Btn.Text_Price:SetText(tostring(Cost))
    end
    if Btn.Text_Undiscounted_Price then
      local CutoffData = ShopUtils:GetShopItemCutoffData(ShopItemId)
      if CutoffData then
        Btn.Text_Undiscounted_Price:SetText(tostring(ShopItemData.Price))
        Btn.Text_Undiscounted_Price:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      else
        Btn.Text_Undiscounted_Price:SetVisibility(ESlateVisibility.Collapsed)
      end
    end
  end
  if Btn.Text_BtnBuy then
    Btn.Text_BtnBuy:SetText(GText("UI_SHOP_PURCHASE"))
  end
  if Btn.ForbidBtn then
    Btn:ForbidBtn(not CanBuy)
  end
end

function M:IsPackNew(PackId)
  if not PackId then
    return false
  end
  return EMCache:Get(GetPackReadKey(PackId), true) == nil
end

function M:MarkPackRead(PackId)
  if not PackId then
    return
  end
  if self:IsPackNew(PackId) then
    EMCache:Set(GetPackReadKey(PackId), true, true)
  end
end

function M:HasNewInDirection(dir)
  local From = dir > 0 and self.CurrentIndex + 1 or 1
  local To = dir > 0 and #self.PackIdList or self.CurrentIndex - 1
  for i = From, To do
    local PackId = self.PackIdList[i]
    local bNew = self:IsPackNew(PackId)
    DebugPrint("[GiftNew] HasNewInDirection dir=", dir, " i=", i, " PackId=", PackId, " IsNew=", tostring(bNew))
    if bNew then
      return true
    end
  end
  return false
end

function M:SetArrowNew(Btn, bShow)
  DebugPrint("[GiftNew] SetArrowNew bShow=", bShow, " Btn=", tostring(Btn), " hasSetNew=", tostring(Btn and Btn.SetNew ~= nil))
  if Btn and Btn.SetNew then
    Btn:SetNew(bShow)
  end
end

function M:RefreshPageNav()
  local Total = #self.PackIdList
  local Idx = self.CurrentIndex
  if Total <= 1 then
    self.Group_Page:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Left:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Right:SetVisibility(ESlateVisibility.Collapsed)
  else
    self.Group_Page:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_Page:SetText(string.format("%d/%d", Idx, Total))
    self.Btn_Left:SetVisibility(Idx > 1 and ESlateVisibility.Visible or ESlateVisibility.Hidden)
    self.Btn_Right:SetVisibility(Total > Idx and ESlateVisibility.Visible or ESlateVisibility.Hidden)
    self:SetArrowNew(self.Btn_Left, self:HasNewInDirection(-1))
    self:SetArrowNew(self.Btn_Right, self:HasNewInDirection(1))
  end
  self:RefreshSideTabBG(Total, Idx)
  self:RefreshGamepadTips()
end

function M:RefreshSideTabBG(Total, Idx)
  if self.LeftOtherBG then
    self.LeftOtherBG:SetVisibility(Total > 1 and Idx > 1 and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
  end
  if self.RightOtherBG then
    self.RightOtherBG:SetVisibility(Total > 1 and Idx < Total and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
  end
end

function M:RefreshGamepadTips()
  if not IsValid(self.Com_MidKeyTips) then
    return
  end
  if not UIUtils.IsGamepadInput() then
    self.Com_MidKeyTips:SetVisibility(ESlateVisibility.Collapsed)
    if self.Key_Left then
      self.Key_Left:SetVisibility(ESlateVisibility.Collapsed)
    end
    if self.Key_Right then
      self.Key_Right:SetVisibility(ESlateVisibility.Collapsed)
    end
    return
  end
  local Tips = {}
  if self.bFocusItemTips then
    table.insert(Tips, {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK")
    })
  else
    table.insert(Tips, {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("UI_Controller_CheckDetails")
    })
    table.insert(Tips, {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK")
    })
  end
  self.Com_MidKeyTips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Com_MidKeyTips:UpdateKeyInfo(Tips)
  if self.Btn_GiftPay and self.Btn_GiftPay.SetGamePadIconVisible then
    self.Btn_GiftPay:SetGamePadIconVisible(not self.bFocusItemTips)
  end
  self:RefreshPageKeyImg()
end

function M:RefreshPageKeyImg()
  local Total = self.PackIdList and #self.PackIdList or 0
  local Idx = self.CurrentIndex or 1
  local bSwitch = Total > 1 and not self.bFocusItemTips and UIUtils.IsGamepadInput()
  if self.Key_Left then
    self.Key_Left:SetVisibility(bSwitch and Idx > 1 and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
  end
  if self.Key_Right then
    self.Key_Right:SetVisibility(bSwitch and Total > Idx and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
  end
end

function M:StartCountdown(PackId)
  self:RemoveTimer(COUNTDOWN_TIMER_KEY)
  self:UpdateRemainTime(PackId)
  self:AddTimer(1, self.UpdateRemainTime, true, 0, COUNTDOWN_TIMER_KEY, true, PackId)
end

function M:UpdateRemainTime(PackId)
  local PopupPackConfig = DataMgr.PopupPack[PackId]
  if not PopupPackConfig then
    self:RemoveTimer(COUNTDOWN_TIMER_KEY)
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Record = Avatar.PopupPack:GetPopupData(PackId)
  if not Record then
    self:RemoveTimer(COUNTDOWN_TIMER_KEY)
    return
  end
  local ExpireTime = Record.LastPopTimeStamp + PopupPackConfig.Duration * 60
  local RemainSeconds = ExpireTime - TimeUtils.NowTime()
  if RemainSeconds <= 0 then
    self:RemoveTimer(COUNTDOWN_TIMER_KEY)
    self:OnClickClose()
    EventManager:FireEvent(EventID.OnPopupPackStateUpdate)
    return
  end
  self.Text_Time:SetText(ShopUtils:GetRefreshTimeStr(RemainSeconds))
end

function M:OnClickBuy()
  AudioManager(self):PlayUISound(nil, "event:/ui/common/battle_pass_btn_click_mid", nil, nil)
  local PackId = self.PackIdList[self.CurrentIndex]
  local PopupPackConfig = DataMgr.PopupPack[PackId]
  if not PopupPackConfig then
    return
  end
  local ShopItemId = PopupPackConfig.ShopItemId
  local ShopItemData = setmetatable({}, {
    __index = DataMgr.ShopItem[ShopItemId]
  })
  ShopUtils:CanPurchase(ShopItemData, ShopItemData.PriceType, ShopUtils:GetShopItemPrice(ShopItemId))
  if DataMgr.ShopItem2PayGoods[ShopItemId] then
    ShopItemData.PurchaseFailRes = ShopItemData.PurchaseFailRes or 0
    ShopUtils:Purchase(ShopItemData, self)
    return
  end
  if ShopItemData.PurchaseFailRes and 0 ~= ShopItemData.PurchaseFailRes then
    ShopUtils:Purchase(ShopItemData, self)
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  Avatar:PurchaseShopItem(ShopItemId, 1)
end

function M:OnClickPrev()
  if self.CurrentIndex <= 1 then
    return
  end
  AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_add", nil, nil)
  AudioManager(self):PlayUISound(nil, "event:/ui/common/gacha_pool_gift_pack_page_change", nil, nil)
  self.PendingIndex = self.CurrentIndex - 1
  if self.Change_L then
    self:PlayAnimation(self.Change_L)
  else
    self:Info_Change()
  end
end

function M:OnClickNext()
  if self.CurrentIndex >= #self.PackIdList then
    return
  end
  AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_add", nil, nil)
  AudioManager(self):PlayUISound(nil, "event:/ui/common/gacha_pool_gift_pack_page_change", nil, nil)
  self.PendingIndex = self.CurrentIndex + 1
  if self.Change_R then
    self:PlayAnimation(self.Change_R)
  else
    self:Info_Change()
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadDown(InKeyName)
  elseif "Escape" == InKeyName then
    self:OnClickClose()
    IsEventHandled = true
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnItemMenuOpenChanged(bIsOpen, _Content)
  self.bFocusItemTips = bIsOpen
  self:RefreshGamepadTips()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
  self:RefreshGamepadTips()
end

function M:SetFocus_Lua()
  local UIMan = UIManager(self)
  if IsValid(UIMan:GetUIObj("GetItemPage")) or IsValid(UIMan:GetUIObj("GetItemPageSP")) then
    return
  end
  self:RefreshAfterPurchase()
  if not self.PackIdList or 0 == #self.PackIdList then
    return
  end
  if UIUtils.IsGamepadInput() then
    self.List_Item:NavigateToIndex(0)
    self.List_Item:SetFocus()
  end
end

function M:OnGamePadDown(InKeyName)
  if self.bFocusItemTips then
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:OnClickClose()
    return true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    self:OnClickBuy()
    return true
  elseif InKeyName == UIConst.GamePadKey.LeftShoulder then
    self:OnClickPrev()
    return true
  elseif InKeyName == UIConst.GamePadKey.RightShoulder then
    self:OnClickNext()
    return true
  end
  return false
end

return M
