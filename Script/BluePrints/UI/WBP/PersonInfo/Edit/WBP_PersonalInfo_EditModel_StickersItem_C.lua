require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Initialize(Initializer)
  self.StickerViewData = nil
  self.HostPage = nil
  self.bItemSelected = false
  self.IsBindingFinished = false
  self.IsChangeBindingFinished = false
end

function M:InitStickerItem(StickerViewData, HostPage)
  self.StickerViewData = StickerViewData
  self.HostPage = HostPage
  self.bItemSelected = false
  if self.SetIsDealWithVirtualAccept then
    self:SetIsDealWithVirtualAccept(true)
  end
  self:_BindClick()
  self:_BindChangeButton()
  self:RefreshEntry()
  self:PrepareEntryIn()
end

function M:RefreshEntry()
  self:_RefreshIconSwitcher()
  self:SyncSelectFromHost()
end

function M:SyncSelectFromHost()
  local bSelected = self.HostPage and self.HostPage.IsStickerEntrySelected and self.HostPage:IsStickerEntrySelected(self.StickerViewData)
  bSelected = true == bSelected
  self.bItemSelected = bSelected
  if self.StickerViewData then
    self.StickerViewData.IsSelected = bSelected
  end
  self:_RefreshIconSwitcher()
  self:_ApplyFiveStateVisual()
  self:_RefreshChangeButtonVisibility()
end

function M:PlayEntryIn()
  if not self.In then
    return
  end
  self:UnbindAllFromAnimationFinished(self.In)
  self:BindToAnimationFinished(self.In, {
    self,
    self._OnEntryInFinished
  })
  self:StopAnimation(self.In)
  self:PlayAnimation(self.In)
end

function M:PrepareEntryIn()
  local Group = self.Group_StickersItem
  if not Group and self.GetWidgetFromName then
    Group = self:GetWidgetFromName("Group_StickersItem")
  end
  if Group then
    Group:SetRenderOpacity(0)
  end
  if self.In then
    self:UnbindAllFromAnimationFinished(self.In)
    self:StopAnimation(self.In)
  end
end

function M:OnItemClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/armory/click_crystal_btn_content", nil, nil)
  if not self.HostPage then
    return
  end
  local bSelected = self.HostPage.IsStickerEntrySelected and self.HostPage:IsStickerEntrySelected(self.StickerViewData)
  if bSelected then
    if self:_IsNoneStickerItem() then
      return
    end
    if self.HostPage.RequestOpenStickerEdit then
      self.HostPage:RequestOpenStickerEdit()
    end
    return
  end
  if not self.HostPage.RequestSelectStickerItem then
    return
  end
  local StickerId = self.StickerViewData and self.StickerViewData.StickerId or nil
  self.HostPage:RequestSelectStickerItem(StickerId)
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName ~= UIConst.GamePadKey.FaceButtonBottom then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  self:OnItemClicked()
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnItemHovered()
  if self.bItemSelected then
    return
  end
  if self.Hover then
    self:PlayAnimation(self.Hover)
  end
end

function M:OnItemUnhovered()
  if self.bItemSelected then
    return
  end
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
    self:BindToAnimationFinished(self.UnHover, {
      self,
      self._OnItemUnHoverFinished
    })
    self:PlayAnimation(self.UnHover)
    return
  end
  self:_PlayItemNormal()
end

function M:OnItemPressed()
  if self.bItemSelected then
    return
  end
  if self.Press then
    self:PlayAnimation(self.Press)
  end
end

function M:OnChangeClicked()
  if self.HostPage and self.HostPage.RequestOpenStickerEdit then
    self.HostPage:RequestOpenStickerEdit()
  end
end

function M:FocusGamepadItem()
  if self.Btn_Click and self.Btn_Click.SetFocus then
    self.Btn_Click:SetFocus()
    return true
  end
  return false
end

function M:OnAddedToFocusPath(InFocusEvent)
  if not UIUtils.IsGamepadInput() then
    return
  end
  if self.HostPage and self.HostPage.ScrollGamepadFocusedWidgetIntoView then
    self.HostPage:ScrollGamepadFocusedWidgetIntoView(self)
  end
end

function M:Destruct()
  if self.In then
    self:UnbindAllFromAnimationFinished(self.In)
  end
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
  end
  self.StickerViewData = nil
  self.HostPage = nil
  self.bItemSelected = nil
  self.IsBindingFinished = nil
  self.IsChangeBindingFinished = nil
end

function M:_IsNoneStickerItem()
  return self.StickerViewData == nil or nil == self.StickerViewData.StickerId
end

function M:_RefreshIconSwitcher()
  if not self.WS_Icon then
    return
  end
  if self:_IsNoneStickerItem() then
    self.WS_Icon:SetActiveWidgetIndex(0)
    return
  end
  self.WS_Icon:SetActiveWidgetIndex(1)
  local IconPath = self.StickerViewData and self.StickerViewData.Icon or nil
  if IconPath and self.Image_Icon then
    local Texture = LoadObject(IconPath)
    if Texture then
      self.Image_Icon:SetBrushFromTexture(Texture, true)
    end
  end
end

function M:_RefreshChangeButtonVisibility()
  if not self.Btn_Change then
    return
  end
  if self:_IsNoneStickerItem() or not self.bItemSelected then
    self.Btn_Change:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  self.Btn_Change:SetVisibility(UIConst.VisibilityOp.Visible)
  local TextChange = self.Btn_Change.Text_Change or self.Text_Change
  if TextChange then
    TextChange:SetText(GText("UI_PersonalPage_Adjust"))
  end
end

function M:_BindClick()
  if self.IsBindingFinished or not self.Btn_Click then
    return
  end
  local Btn = self.Btn_Click
  Btn.OnClicked:Clear()
  Btn.OnClicked:Add(self, self.OnItemClicked)
  Btn.OnHovered:Clear()
  Btn.OnHovered:Add(self, self.OnItemHovered)
  Btn.OnUnhovered:Clear()
  Btn.OnUnhovered:Add(self, self.OnItemUnhovered)
  Btn.OnPressed:Clear()
  Btn.OnPressed:Add(self, self.OnItemPressed)
  self.IsBindingFinished = true
end

function M:_BindChangeButton()
  if self.IsChangeBindingFinished or not self.Btn_Change then
    return
  end
  local Btn = self.Btn_Change
  Btn.OnClicked:Clear()
  Btn.OnClicked:Add(self, self.OnChangeClicked)
  self.IsChangeBindingFinished = true
end

function M:_OnEntryInFinished()
  if self.In then
    self:UnbindAllFromAnimationFinished(self.In)
  end
end

function M:_OnItemUnHoverFinished()
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
  end
  if self.bItemSelected then
    return
  end
  self:_PlayItemNormal()
end

function M:_ApplyFiveStateVisual()
  self:_StopFiveStateAnimations()
  if self.bItemSelected then
    self:_PlayItemClickHold()
  else
    self:_PlayItemNormal()
  end
end

function M:_StopFiveStateAnimations()
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
    self:StopAnimation(self.UnHover)
  end
  if self.Click then
    self:StopAnimation(self.Click)
  end
  if self.Hover then
    self:StopAnimation(self.Hover)
  end
  if self.Press then
    self:StopAnimation(self.Press)
  end
  if self.Normal then
    self:StopAnimation(self.Normal)
  end
end

function M:_PlayItemNormal()
  if self.Normal then
    self:PlayAnimation(self.Normal, 0, 1, UE4.EUMGSequencePlayMode.Forward, 1, false)
  end
end

function M:_PlayItemClickHold()
  if self.Click then
    self:PlayAnimation(self.Click, 0, 1, UE4.EUMGSequencePlayMode.Forward, 1, false)
  end
end

return M
