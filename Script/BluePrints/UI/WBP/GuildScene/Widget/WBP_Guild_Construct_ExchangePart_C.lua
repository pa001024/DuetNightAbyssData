require("UnLua")
local PageJumpUtils = PageJumpUtils or require("Utils.PageJumpUtils")
local TipsWidgetName = {Item_Tip3 = 1, Item_Currency = 2}
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function M:Construct()
end

function M:InitExchangeData()
  self.ConsumeCurrency = CommonConst.GuildFundsCoin
  self.ConsumeNum = 15
end

function M:PreInitContent(Params, PopupData, Owner)
  M.Super.PreInitContent(self, Params, PopupData, Owner)
  self:InitExchangeData()
  if self:IsSelectorEnabled() then
    self.Owner.ButtonBar.Btn_Yes:SetText(GText("UI_Exchange_Use"))
    self:BindDialogEvent(DialogEvent.OnRightBtnClicked, self.OnExchangeBtnClicked)
  else
    self.Owner.ButtonBar.Btn_Yes:SetText(GText("UI_GameEvent_Goto"))
    self:BindDialogEvent(DialogEvent.OnRightBtnClicked, self.OnBuyBtnClicked)
  end
end

function M:InitContent(Params, PopupData, Owner)
  M.Super.InitContent(self, Params, PopupData, Owner)
  self:InitExchangeData()
  self.CurrentCount = 1
  self:UpdatePricePanel()
  self:InitUIWidget()
  self:InitCommonWidget()
  self:SetIsShowNavigateGuide(false)
end

function M:PostInitContent(Params, PopupData, Owner)
  M.Super.PostInitContent(self, Params, PopupData, Owner)
  if self:IsSelectorEnabled() then
    self.Owner:ShowDialogTip(TipsWidgetName.Item_Currency)
    self.Owner:HideDialogTip(TipsWidgetName.Item_Tip3)
    self:UpdateCost(self.CurrentCount)
  else
    self.Owner:ShowDialogTip(TipsWidgetName.Item_Tip3)
    self.Owner:HideDialogTip(TipsWidgetName.Item_Currency)
  end
  self.Owner.WBP_Com_Tab_Node_ResourceBar:SetResourceBarVisibility(self.ConsumeCurrency, false)
end

function M:Destroy()
  self:UnbindDialogEvent(DialogEvent.OnRightBtnClicked)
end

function M:InitCommonWidget()
  local ConfigData = {
    InitValue = self.CurrentCount,
    ClickInterval = 1,
    MinValue = 1,
    MaxValue = self:GetMaxCount(),
    OwnerPanel = self,
    MinusBtnCallback = self.MinusBtnCallback,
    AddBtnCallback = self.AddBtnCallback,
    SliderChangeCallback = self.SliderChangeCallback,
    EnableMiniBtn = true,
    EnableMaxBtn = true
  }
  self.Com_Slider:Init(ConfigData)
  self:UpdateSelectorState()
end

function M:InitUIWidget()
  self.Text_Exchange:SetText(GText("UI_Shop_ExchangeAmount") .. ":")
  self.Text_ExchangeTitleLeft:SetText(GText("RESOURCE_NAME_99") .. " x1")
  self.Text_ExchangeTitleRight:SetText(GText("RESOURCE_NAME_4005") .. " x" .. tostring(self.ConsumeNum))
  self.Text_Exchange:SetText(GText("UI_Shop_ExchangeAmount") .. ":")
end

function M:MinusBtnCallback()
  self.CurrentCount = self.Com_Slider.CurrentCount
  self:UpdatePricePanel()
end

function M:AddBtnCallback()
  self.CurrentCount = self.Com_Slider.CurrentCount
  self:UpdatePricePanel()
end

function M:SliderChangeCallback(Value)
  self.CurrentCount = Value
  self:UpdatePricePanel()
end

function M:UpdatePricePanel()
  local MaxCount = self:GetMaxCount()
  if MaxCount < self.CurrentCount then
    self.CurrentCount = MaxCount
  end
  self.Num_Exchange:SetText(tostring(self.CurrentCount))
  self.Num_Max_1:SetText(tostring(MaxCount))
  self:UpdateCost(self.CurrentCount)
  self:UpdateSelectorState()
end

function M:UpdateCost(Cost)
  if not self.Owner then
    return
  end
  local CurrencyWidget = self.Owner:GetContentWidgetByName("Item_Currency")
  if not IsValid(CurrencyWidget) then
    return
  end
  CurrencyWidget:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
  CurrencyWidget.Panel_Currency:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
  local ChildCurrencyWidget = CurrencyWidget.HB_Item:GetChildAt(0)
  if not IsValid(ChildCurrencyWidget) then
    ChildCurrencyWidget = CurrencyWidget:CreateWidgetNew("CommonDialogCurrency")
    CurrencyWidget.HB_Item:AddChildToHorizontalBox(ChildCurrencyWidget)
  end
  if not IsValid(ChildCurrencyWidget) then
    return
  end
  local Params = {
    ResourceId = 99,
    Denominator = Cost,
    Numerator = Cost
  }
  ChildCurrencyWidget:InitContent(Params)
end

function M:GetMaxCount()
  local MaxValue = self:GetOwnedCount()
  return MaxValue > 0 and MaxValue or 1
end

function M:GetOwnedCount()
  local MaxValue = 0
  local Data = DataMgr.Resource[99]
  local Avatar = GWorld:GetAvatar()
  if Avatar and Data then
    local Resource = Avatar.Resources[99] or {Count = 0}
    MaxValue = Resource.Count
  end
  return MaxValue
end

function M:IsSelectorEnabled()
  return self:GetOwnedCount() > 0
end

function M:UpdateSelectorState()
  self.Com_Slider:SetEnabled(self:IsSelectorEnabled())
end

function M:OnExchangeBtnClicked()
  if not self:IsSelectorEnabled() then
    return
  end
  local Avatar = GWorld:GetAvatar()
  
  local function TransformCallBack(Count)
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded("Resource", self.ConsumeCurrency, Count, nil, false, nil, self, false)
  end
  
  Avatar:TransformCoin4ToCoin1(self.CurrentCount, TransformCallBack)
end

function M:OnBuyBtnClicked()
  local Avatar = GWorld:GetAvatar()
  local UIUnlockRule = DataMgr.UIUnlockRule
  if not UIUnlockRule or not UIUnlockRule.Shop then
    DebugPrint("WBP_Guild_Construct_ExchangePart_C OnBuyBtnClicked UIUnlockRule or UIUnlockRule.Shop is nil")
    return
  end
  local UIUnlockRuleId = UIUnlockRule.Shop.UIUnlockRuleId
  if Avatar and UIUnlockRuleId then
    local bUnlocked = Avatar:CheckUIUnlocked(UIUnlockRuleId)
    if bUnlocked then
      PageJumpUtils:JumpToShopPage(CommonConst.GachaJumpToShopMainTabId, nil, nil, "Shop")
    else
      UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, UIUnlockRule.Shop.UIUnlockDesc)
    end
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  return self:OnContentKeyDown(MyGeometry, InKeyEvent)
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return false
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  return self:OnGamePadDown(InKeyName)
end

function M:OnGamePadDown(InKeyName)
  local IsEventHandled = self.Com_Slider:Handle_KeyDownEventOnGamePad(InKeyName)
  return IsEventHandled
end

function M:OnGamePadUp(InKeyName)
  local IsEventHandled = self.Com_Slider:Handle_KeyUpEventOnGamePad(InKeyName)
  return IsEventHandled
end

function M:OnContentKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return false
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  return self:OnGamePadUp(InKeyName)
end

return M
