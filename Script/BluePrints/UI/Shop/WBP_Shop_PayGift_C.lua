require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.UI_PC.Common.HorizontalListViewResizeComp"
}

function M:Construct()
  self:AddInputMethodChangedListen()
  self.bQuickAddOpen = false
  self.List_PayGift.OnCreateEmptyContent:Bind(self, function(self)
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.ShopId = nil
    Content.bQuickAddOpen = self.bQuickAddOpen
    return Content
  end)
end

function M:Destruct()
  self:HorizontalListViewResize_TearDown()
end

function M:InitPayGiftInfo(ShopItemsData)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.List_PayGift:ClearListItems()
  for _, v in ipairs(ShopItemsData) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.ItemData = v
    Content.bQuickAddOpen = self.bQuickAddOpen
    if 0 ~= ShopUtils:GetShopItemPurchaseLimit(v.ItemId) or Avatar:CheckShopItemSoldOutDisplay(v.ItemId) then
      self.List_PayGift:AddItem(Content)
    end
  end
  if self.List_PayGift:GetNumItems() > 0 then
    self.List_PayGift:RequestFillEmptyContent()
    self.List_PayGift:RequestPlayEntriesAnim()
    local ShopMain = UIManager(self):GetUIObj("ShopMain")
    if ShopMain and (ShopMain:HasAnyFocus() or ShopMain:HasFocusedDescendants()) and not CommonUtils:IfExistSystemGuideUI(self) then
      self:AddTimer(0.01, function()
        self.List_PayGift:SetFocus()
      end)
    end
  end
end

function M:SetQuickAddMode(bOpen)
  self.bQuickAddOpen = bOpen
  local Items = self.List_PayGift:GetListItems()
  if Items then
    for _, Content in pairs(Items) do
      if Content and Content.SelfWidget and Content.SelfWidget.SetQuickAddMode then
        Content.bQuickAddOpen = bOpen
        Content.SelfWidget:SetQuickAddMode(bOpen)
      end
    end
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Gamepad then
    local ShopMain = UIManager(self):GetUIObj("ShopMain")
    if (ShopMain and ShopMain:HasAnyFocus() or self:HasFocusedDescendants()) and not CommonUtils:IfExistSystemGuideUI(self) then
      self.List_PayGift:SetFocus()
    end
  end
end

AssembleComponents(M)
return M
