require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:BtnSetUpWithData(ParentWidget, BtnType, BtnText, ClickCallBack, HotKeyInfo)
  self.ParentWidget = ParentWidget
  self.BtnType = BtnType
  self.Text_Entry:SetText(GText(BtnText))
  self.ClickCallBack = ClickCallBack
  self.Com_KeyImg:CreateGamepadKey(HotKeyInfo.Key)
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
end

function M:OnBtnClicked()
  if self.ClickCallBack and type(self.ClickCallBack) == "function" then
    self.ClickCallBack(self.ParentWidget)
  end
end

function M:OnUpdateSubUIViewStyle(bIsUseGamePad)
  if bIsUseGamePad then
    self.Com_KeyImg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:RefreshReddot(Count)
  if Count > 0 then
    self.Reddot:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.Reddot:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

return M
