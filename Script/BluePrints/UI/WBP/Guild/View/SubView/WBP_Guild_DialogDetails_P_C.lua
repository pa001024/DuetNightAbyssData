require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.DelayFrameComponent"
})
local GuildModel = require("BluePrints.UI.WBP.Guild.Model.GuildModel")
local GuildController = require("BluePrints.UI.WBP.Guild.Controller.GuildController")

function M:Construct()
  if self.Btn_Close and self.Btn_Close.BindEventOnClicked then
    self.Btn_Close:BindEventOnClicked(self, self.OnBtnCloseClicked)
  end
  self.CurrGuildInfo = GuildController:GetModel():GetCurrGuild()
  self:InitData(self.CurrGuildInfo)
end

function M:Destruct()
  if self.Btn_Close and self.Btn_Close.UnBindEventOnClicked then
    self.Btn_Close:UnBindEventOnClicked(self, self.OnBtnCloseClicked)
  end
end

function M:OnBtnCloseClicked()
  self:Close()
end

function M:RefreshList()
  self.List_Item:ClearListItems()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.CurrGuildInfo = self.CurrGuildInfo
  Content.Type = 0
  self.List_Item:AddItem(Content)
  local T = DataMgr.GuildMessage
  for _, DetailItem in pairs(DataMgr.GuildDetailItem) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Type = 1
    Content.ItemTitle = DetailItem.ItemTitle
    Content.Describe = DetailItem.Describe
    self.List_Item:AddItem(Content)
  end
  self.List_Item:SetScrollbarVisibility(UE4.ESlateVisibility.Collapsed)
  self.List_Item:SetControlScrollbarInside(true)
  self:AddDelayFrameFunc(function()
    local CommonDialog = UIManager(self):GetUI("CommonDialog")
    self.MaxScrollOffset = self:GetMaxScrollOffset()
    if CommonDialog and CommonDialog.ShowGamepadScrollBtn then
      if self.MaxScrollOffset > 0 then
        CommonDialog:ShowGamepadScrollBtn(true)
      else
        CommonDialog:ShowGamepadScrollBtn(false)
      end
    end
  end, 10)
end

function M:InitView(GuildInfo)
  self.CurrGuildInfo = GuildInfo
  self:SetVisibility(UIConst.VisibilityOp.Visible)
  self:RefreshList()
end

function M:InitData(GuildInfo)
  self:InitView(GuildInfo)
end

function M:OnContentAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.RightAnalogY then
    local DeltaOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 0.1
    local CurrentOffset = self.List_Item:GetScrollOffset()
    local NextOffset = math.clamp(CurrentOffset - DeltaOffset, 0, UIUtils.GetMaxScrollOffsetOfListView(self.List_Item))
    self.List_Item:SetScrollOffset(NextOffset)
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:GetMaxScrollOffset()
  if self.MaxScrollOffset and self.MaxScrollOffset > 0 then
    return self.MaxScrollOffset
  end
  local ItemUIs = self.List_Item:GetDisplayedEntryWidgets()
  if 0 == ItemUIs:Length() then
    return 0
  end
  local ItemSize = UIManager(self.List_Item):GetWidgetRenderSize(ItemUIs:GetRef(1))
  local ItemSize2 = UIManager(self.List_Item):GetWidgetRenderSize(ItemUIs:GetRef(2))
  local ListSize = UIManager(self.List_Item):GetWidgetRenderSize(self.List_Item)
  if 0 == ListSize then
    self.List_Item:ForceLayoutPrepass()
    ListSize = UIManager:GetWidgetRenderSize(self.List_Item)
  end
  local ItemNum = self.List_Item:GetNumItems()
  local MaxScrollOffset = 0
  MaxScrollOffset = (ItemSize.Y + (ItemNum - 1) * ItemSize2.Y - ListSize.Y) / ItemSize.Y
  return MaxScrollOffset
end

return M
