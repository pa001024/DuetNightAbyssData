require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.bIsFocusable = true
  self.bHeadMenuOpen = false
  if self.Head_Anchor then
    self.Head_Anchor.OnMenuOpenChanged:Add(self, self.HeadMenuOpenChanged)
  end
end

function M:Destruct()
  if self.Head_Anchor then
    self.Head_Anchor.OnMenuOpenChanged:Remove(self, self.HeadMenuOpenChanged)
  end
end

function M:HeadMenuOpenChanged(bOpen)
  self.bHeadMenuOpen = true == bOpen
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(UE4.UKismetInputLibrary.GetKey(InKeyEvent))
  if self.bHeadMenuOpen then
    if InKeyName == UIConst.GamePadKey.FaceButtonRight and self.Head_Anchor then
      self.Head_Anchor:Close()
      self:SetFocus()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom and self.Head then
    self.Head:BtnAreaOnClicked()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnListItemObjectSet(Content)
  local HeadIconId = Content.HeadIconId or 10001
  if self.Head.SetHeadIconEmpty then
    self.Head:SetHeadIconEmpty(false)
  end
  self.Head:SetHeadIconById(HeadIconId)
  self.Head:SetHeadFrame(Content.HeadFrameId)
  if self.Head.CleanUpAnchor then
    self.Head:CleanUpAnchor()
  end
  if self.Head.HeadIconSetupAnchor then
    self.Head:HeadIconSetupAnchor(self.Head_Anchor, Content, Content.GuildInfo, true, true)
  end
  self.Text_Name:SetText(Content.Nickname or "")
  self.Text_Num:SetText(Content.AssistTimes or 1)
  local TitleBefore = tonumber(Content.TitleBefore) or -1
  local TitleAfter = tonumber(Content.TitleAfter) or -1
  local IsNilFrame = Content.TitleBefore == nil and Content.TitleAfter == nil
  local IsEmptyFrame = TitleBefore < 0 and TitleAfter < 0
  if IsNilFrame or IsEmptyFrame then
    self.WS_Title:SetActiveWidgetIndex(1)
    return
  end
  self.WS_Title:SetActiveWidgetIndex(0)
  local TitleFrame = Content.TitleFrame
  if not TitleFrame or TitleFrame < 0 then
    TitleFrame = 10001
  end
  self.Overlay_Title:ClearChildren()
  local TitleFrameWidget = UIManager(self):LoadTitleFrameWidget(TitleFrame)
  if TitleFrameWidget then
    self.Overlay_Title:AddChildToOverlay(TitleFrameWidget)
    TitleFrameWidget:SetTitleContent(TitleBefore, TitleAfter)
  end
end

return M
