require("UnLua")
local TipsWidgetName = {Item_Currency = 1}
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function M:Construct()
end

function M:InitContent(Params, PopupData, Owner)
  M.Super.InitContent(self, Params, PopupData, Owner)
  self.ItemData = Params.ItemData
  self.ConsumeCurrency = tonumber(self.ItemData.ConsumeCurrency) or CommonConst.GuildFundsCoin
  self.ConsumeNum = tonumber(self.ItemData.ConsumeNum) or 1
  self.CurrentCount = 1
  self:UpdatePricePanel()
  self:InitUIWidget()
  self:InitCommonWidget()
  self:SetIsShowNavigateGuide(false)
end

function M:PostInitContent(Params, PopupData, Owner)
  M.Super.PostInitContent(self, Params, PopupData, Owner)
  self.Owner:ShowDialogTip(TipsWidgetName.Item_Currency)
  self:UpdateCost(self:GetCostCount(self.CurrentCount))
  self.Owner.WBP_Com_Tab_Node_ResourceBar:SetResourceBarVisibility(self.ConsumeCurrency, false)
  self:BindDialogEvent(DialogEvent.OnRightBtnClicked, self.OnBuyBtnClicked)
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
  if self.ItemData.PicAlbum then
    local IconTexture = LoadObject(self.ItemData.PicAlbum)
    if IconTexture then
      self.Image_Icon:SetBrushFromTexture(IconTexture)
    end
  end
  self.Text_Name:SetText(GText(self.ItemData.ComponentName))
  self.Text_Desc:SetText(GText(self.ItemData.ComponentDesc))
  self.Text_Exchange:SetText(GText("UI_Shop_ExchangeAmount") .. ":")
  self:AddTimer(0.01, function()
    self:ForceLayoutPrepass()
    local IsShowScroll = self.ScrollBox_Desc:GetDesiredSize().Y > self.SizeBox_Desc:GetDesiredSize().Y
    if IsShowScroll then
      self.GamepadKeyIndex = self:ShowGamepadShortcutBtn({
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = "RV",
            Owner = self
          }
        },
        Desc = GText("UI_Controller_Slide"),
        bLongPress = false
      })
    end
  end)
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
  self:UpdateCost(self:GetCostCount(self.CurrentCount))
  self:UpdateSelectorState()
end

function M:GetCostCount(Count)
  return (Count or 0) * (self.ConsumeNum or 1)
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
  local Avatar = GWorld:GetAvatar()
  local ResourceData = DataMgr.Resource[self.ConsumeCurrency]
  if not ResourceData then
    DebugPrint("WBP_Guild_Construct_BuyPart_C UpdateCost invalid ConsumeCurrency", self.ConsumeCurrency)
    return
  end
  local ResourceCount = Avatar and Avatar:GetResourceNum(self.ConsumeCurrency) or 0
  local Params = {
    ResourceId = self.ConsumeCurrency,
    Denominator = Cost,
    Numerator = ResourceCount
  }
  ChildCurrencyWidget:InitContent(Params)
end

function M:GetMaxCount()
  local ConsumeNum = self.ConsumeNum or 1
  if ConsumeNum <= 0 then
    return 1
  end
  local MaxValue = math.floor(self:GetOwnedCount() / ConsumeNum)
  return MaxValue > 0 and MaxValue or 1
end

function M:GetOwnedCount()
  local Data = DataMgr.Resource[self.ConsumeCurrency]
  local Avatar = GWorld:GetAvatar()
  if Avatar and Data then
    return Avatar:GetResourceNum(self.ConsumeCurrency) or 0
  end
  return 0
end

function M:IsSelectorEnabled()
  return self:GetOwnedCount() >= (self.ConsumeNum or 1)
end

function M:UpdateSelectorState()
  self.Com_Slider:SetEnabled(self:IsSelectorEnabled())
end

function M:OnBuyBtnClicked()
  if not self:IsSelectorEnabled() then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format(GText("UI_ItemInsufficient"), GText("RESOURCE_NAME_4005")))
    self.Owner.DontCloseWhenRightBtnClicked = true
    return
  end
  self.Owner.DontCloseWhenRightBtnClicked = nil
  local Avatar = GWorld:GetAvatar()
  
  local function BuyComponentCallBack(Count)
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, "UI_ComponentPurchased")
    self.Owner:OnCloseBtnClicked()
  end
  
  Avatar:GuildHomeBuyComponent(BuyComponentCallBack, self.ItemData.ID, self.CurrentCount)
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

function M:OnContentAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.RightAnalogY then
    local DeltaOffset = -1 * UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
    local CurrentOffset = self.ScrollBox_Desc:GetScrollOffset()
    local NextOffset = math.clamp(CurrentOffset + DeltaOffset, 0, self.ScrollBox_Desc:GetScrollOffsetOfEnd())
    self.ScrollBox_Desc:SetScrollOffset(NextOffset)
    IsEventHandled = true
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
end

function M:InitGamepadView()
  if UIUtils.HasAnyFocus(self) then
    self.Owner:SetFocus()
  end
end

return M
