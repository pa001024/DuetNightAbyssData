require("UnLua")
local WBP_Activity_SoloTreasure_LevelItem = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local SoloTreasureDataModel = require("BluePrints.UI.WBP.Activity.Widget.SoloTreasure.SoloTreasureDataModel")
local TimeUtils = require("Utils.TimeUtils")
local UIUtils = require("Utils.UIUtils")
local RomaNumMap = {
  [1] = "Ⅰ",
  [2] = "Ⅱ",
  [3] = "Ⅲ",
  [4] = "Ⅳ"
}

function WBP_Activity_SoloTreasure_LevelItem:OnListItemObjectSet(LevelObj)
  self.Content = LevelObj
  self.Text_Name:SetText(GText(LevelObj.DungeonName))
  self.bNeedPlayUnlockAnim = LevelObj.bNeedPlayUnlockAnim == true
  self:SetSelected(LevelObj.IsSelected)
  self:SetBtnForbidden(self.Content.bForbidden)
  if self.bNeedPlayUnlockAnim and not self.Content.bForbidden and self.Forbidden then
    self:PlayAnimation(self.Forbidden)
  end
  if self.Text_Num then
    self.Text_Num:SetText(RomaNumMap[LevelObj.Index])
  end
  self.Panel_ExtraCoin:SetVisibility(UE4.ESlateVisibility.Collapsed)
  if self.Content.bIsExtraLevel then
    self.Panel_ExtraCoin:SetVisibility(UE4.ESlateVisibility.Visible)
    self.Text_ExtraCoin:SetText(GText("UI_SoloTreasure_TicketLevelSubTitle"))
  end
  self:BindBtnState()
  self.ReddotNode = LevelObj.ReddotNode or "SoloTreasure_LevelListView"
  if self.ReddotNodeListening then
    ReddotManager.RemoveListener(self.ReddotNodeListening, self)
    self.ReddotNodeListening = nil
  end
  self.ReddotNodeListening = self.ReddotNode
  ReddotManager.AddListenerEx(self.ReddotNode, self, function(self, Count, RdType)
    self:RefreshNewReddot()
  end)
  self:RefreshNewReddot()
end

function WBP_Activity_SoloTreasure_LevelItem:RefreshNewReddot()
  if not self.Content then
    return
  end
  if self.Content.bForbidden then
    self:EMShowReddot(false, EReddotType.New, 0)
    return
  end
  local EventId = self.Content.EventId or SoloTreasureDataModel:GetEventId()
  local Index = self.Content.Index
  local bRead
  if self.Content.IsReadCallback then
    bRead = self.Content.IsReadCallback(EventId, Index)
  else
    bRead = SoloTreasureDataModel:IsLevelEntryRead(EventId, Index)
  end
  local bShow = not bRead
  self:EMShowReddot(bShow, EReddotType.New, bShow and 1 or 0)
end

function WBP_Activity_SoloTreasure_LevelItem:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.Content and self.Content.bForbidden then
    local Parent = self.Content.Parent
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if self.Content and self.Content.OnFocusReceivedCallback then
    self.Content.OnFocusReceivedCallback(self)
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function WBP_Activity_SoloTreasure_LevelItem:SetSelected(bSelected)
  self:ResetAnim()
  if bSelected then
    self:PlayAnimation(self.Click)
  else
    self:PlayAnimation(self.Normal)
  end
end

function WBP_Activity_SoloTreasure_LevelItem:SetBtnForbidden(bForbidden)
  if not self.Btn_Click then
    return
  end
  if bForbidden then
    self:PlayAnimation(self.Forbidden)
  end
end

function WBP_Activity_SoloTreasure_LevelItem:UnLockLevel()
  if not self.bNeedPlayUnlockAnim then
    return
  end
  self.bNeedPlayUnlockAnim = false
  if self.Forbidden then
    self:StopAnimation(self.Forbidden)
  end
  if self.UnLock then
    AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_unlock_new_level", nil, nil)
    self:PlayAnimation(self.UnLock)
  end
end

function WBP_Activity_SoloTreasure_LevelItem:BindBtnState()
  if not self.Btn_Click then
    return
  end
  self.Btn_Click.OnClicked:Clear()
  self.Btn_Click.OnClicked:Add(self, self.OnLevelItemClicked)
  if self.Btn_Click.OnHovered then
    self.Btn_Click.OnHovered:Clear()
    self.Btn_Click.OnHovered:Add(self, self.BtnHovered)
  end
  if self.Btn_Click.OnUnhovered then
    self.Btn_Click.OnUnhovered:Clear()
    self.Btn_Click.OnUnhovered:Add(self, self.BtnUnhovered)
  end
  if self.Btn_Click.OnPressed then
    self.Btn_Click.OnPressed:Clear()
    self.Btn_Click.OnPressed:Add(self, self.BtnPressed)
  end
end

function WBP_Activity_SoloTreasure_LevelItem:OnLevelItemClicked()
  if self.Content and self.Content.bForbidden then
    local Parent = self.Content.Parent
    Parent:ShowLockedToastByObj(self.Content)
    return
  end
  if UIUtils.IsGamepadInput() and self.Content and self.Content.Parent then
    self.Content.Parent:OnPrepareClicked()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if self.Content and self.Content.OnBtnClickedCallback then
    local Index = self.Content.Index
    self.Content.OnBtnClickedCallback(Index)
  end
end

function WBP_Activity_SoloTreasure_LevelItem:BtnHovered()
  if not self.Content or self.Content.IsSelected then
    return
  end
  if not self.Content.bForbidden then
    self:PlayAnimation(self.Hover)
  end
end

function WBP_Activity_SoloTreasure_LevelItem:BtnUnhovered()
  if not self.Content or self.Content.IsSelected then
    return
  end
  if not self.Content.bForbidden then
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.UnHover)
  end
end

function WBP_Activity_SoloTreasure_LevelItem:BtnPressed()
  if not self.Content or self.Content.IsSelected then
    return
  end
  if not self.Content.bForbidden then
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.Press)
  end
end

function WBP_Activity_SoloTreasure_LevelItem:ResetAnim()
  if self.Normal then
    self:StopAnimation(self.Normal)
  end
  if self.Hover then
    self:StopAnimation(self.Hover)
  end
  if self.UnHover then
    self:StopAnimation(self.UnHover)
  end
  if self.Click then
    self:StopAnimation(self.Click)
  end
  if self.Press then
    self:StopAnimation(self.Press)
  end
  if self.Forbidden then
    self:StopAnimation(self.Forbidden)
  end
end

function WBP_Activity_SoloTreasure_LevelItem:Destruct()
  if self.ReddotNodeListening then
    ReddotManager.RemoveListener(self.ReddotNodeListening, self)
    self.ReddotNodeListening = nil
  end
end

return WBP_Activity_SoloTreasure_LevelItem
