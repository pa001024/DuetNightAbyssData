require("unlua")
local WBP_Common_Dialog_Item_Tip_PC_C = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function WBP_Common_Dialog_Item_Tip_PC_C:PreInitContent(Params, PopupData, Owner)
  self.Super.PreInitContent(self, Params, PopupData, Owner)
  self.PosIndex = self.Owner:GetItemIndex()
  self:BindDialogEvent(DialogEvent.HideDialogItem, self.HideDialogItem)
  self:BindDialogEvent("UpdateDialogTipText", self.UpdateDialogTipText)
  if Params and Params.HideItemTips then
    self:SetVisibility(UE.ESlateVisibility.Collapsed)
  end
end

function WBP_Common_Dialog_Item_Tip_PC_C:InitContent(Params, PopupData, Owner)
  self.Super.InitContent(self, Params, PopupData, Owner)
  self:ShowTip(Params, PopupData)
  if self.Owner and not self.Owner:GetButtonBar() then
    self.Switcher_Bg:SetActiveWidgetIndex(0)
  else
    self.Switcher_Bg:SetActiveWidgetIndex(1)
  end
end

function WBP_Common_Dialog_Item_Tip_PC_C:ShowTip(Params, PopupData)
  local Text
  if PopupData and PopupData.Tip then
    Text = PopupData.Tip[self.PosIndex]
  end
  if Params and Params.Tips then
    Text = Params.Tips[self.PosIndex]
  end
  if Params and Params.bShowTip then
    self:SetVisibility(ESlateVisibility.Visible)
  end
  if Text then
    self.CachedTipText = GText(Text)
    self.Text_Tips:SetText(self.CachedTipText)
    self.bHasContent = true
    local IsBig = self.Owner and self.Owner.PopupStyle and self.Owner.PopupStyle.BigSize
    local WrapAt = IsBig and self.WrapText_Large or self.WarpText_Normal
    if WrapAt then
      self.Text_Tips:SetWrapTextAt(WrapAt)
    end
  elseif not self.bHasContent then
    self:SetVisibility(UE.ESlateVisibility.Collapsed)
  end
end

function WBP_Common_Dialog_Item_Tip_PC_C:DetectTipTwoLine()
  local TextWidget = self.Text_Tips
  if not TextWidget or not self.CachedTipText then
    return false
  end
  TextWidget:SetText("A")
  self:ForceLayoutPrepass()
  local OneLineH = TextWidget:GetDesiredSize().Y
  TextWidget:SetText(self.CachedTipText)
  self:ForceLayoutPrepass()
  local ActualH = TextWidget:GetDesiredSize().Y
  return ActualH > OneLineH + 4
end

function WBP_Common_Dialog_Item_Tip_PC_C:HideDialogItem(Params, PopupData)
  if Params.DialogItemIndex == self.PosIndex then
    if Params.bHideDialogItem then
      self.Owner.bTipTwoLine = false
      if Params.bShouldPlayAnim and self.Visibility == UE.ESlateVisibility.SelfHitTestInvisible then
        self:PlayAnimation(self.Out)
      else
        self:SetVisibility(UE.ESlateVisibility.Collapsed)
      end
    else
      self:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
      self.Owner.bTipTwoLine = self:DetectTipTwoLine()
      self:PlayAnimation(self.In)
      local ContentName = self:GetContentWidgetName()
      if ContentName and "Item_Tip2" == ContentName then
        AudioManager(self):PlayUISound(nil, "event:/ui/common/err_action_warning", nil, nil)
      elseif ContentName and "Item_Tip3" == ContentName then
        AudioManager(self):PlayUISound(self, "event:/ui/common/input_err", nil, nil)
      end
    end
  end
  self.Owner:AutofitDialog()
end

function WBP_Common_Dialog_Item_Tip_PC_C:UpdateDialogTipText(Params, PopupData)
  if Params.DialogItemIndex == self.PosIndex then
    self:ShowTip(Params, PopupData)
    self.Owner.bTipTwoLine = self:DetectTipTwoLine()
    self.Owner:AutofitDialog()
  end
end

function WBP_Common_Dialog_Item_Tip_PC_C:OnAnimationFinished(Anim)
  if Anim == self.Out then
    self:SetVisibility(UE.ESlateVisibility.Collapsed)
  end
end

return WBP_Common_Dialog_Item_Tip_PC_C
