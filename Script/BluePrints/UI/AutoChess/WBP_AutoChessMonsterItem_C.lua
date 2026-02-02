require("UnLua")
local UIUtils = require("Utils.UIUtils")
local Model = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local View = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function View:OnListItemObjectSet(Content)
  self:StopAllAnimations()
  self.Content = Content
  if Content.IsEmpty then
    self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.WS_Type:SetActiveWidgetIndex(1)
    return
  else
    self.WS_Type:SetActiveWidgetIndex(0)
  end
  local ChessData = DataMgr.CombatChessInfo[Content.Data.Id]
  if ChessData then
    self.Text_Name:SetText(GText(ChessData.CombatChessName))
    self.Text_Cost:SetText(tostring(Content.Data.TotalCost or 0))
    if ChessData.PositionIcon then
      local ImgType = LoadObject(ChessData.PositionIcon)
      self.Icon_Type.Icon:SetBrushFromTexture(ImgType)
    end
  end
  if Content.Data.EquipItems then
    self:UpdateEquipInfo(Content.Data.EquipItems)
  else
    self.Equipment_01.WS_Type:SetActiveWidgetIndex(1)
    self.Equipment_02.WS_Type:SetActiveWidgetIndex(1)
  end
  if ChessData.MonsterIcon then
    local ImgHead = LoadObject(ChessData.MonsterIcon)
    self.Image_Head:SetBrushFromTexture(ImgHead)
  end
  self:SetLocked(Content.Data.Locked)
  if Content.Data.IsNew then
    self.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
  else
    self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  if Content.IsSelected then
    self:PlayAnimation(self.Click)
  elseif Content.bInGame then
    self:SetForbidden(Content.bForbidden)
  end
  if Content.bInGame then
    if self.New then
      self.New:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.Text_Cost:SetText(tostring(Content.InGameCost or 0))
  end
  self.Btn_Click.OnClicked:Clear()
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
  if self.Btn_Click.OnHovered then
    self.Btn_Click.OnHovered:Clear()
    self.Btn_Click.OnHovered:Add(self, self.OnHovered)
  end
  if self.Btn_Click.OnUnhovered then
    self.Btn_Click.OnUnhovered:Clear()
    self.Btn_Click.OnUnhovered:Add(self, self.OnUnhovered)
  end
  if self.Btn_Click.OnPressed then
    self.Btn_Click.OnPressed:Clear()
    self.Btn_Click.OnPressed:Add(self, self.OnPressed)
  end
end

function View:SetLocked(bLocked)
  if bLocked then
    self.Panel_Lock:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
    self:PlayAnimation(self.Lock)
  else
    self.Panel_Lock:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:PlayAnimation(self.Normal)
  end
  self.IsLocked = bLocked
end

function View:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.Content and self.Content.OnFocusReceivedCallback then
    self.Content.OnFocusReceivedCallback(self.Content.Data.Id)
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function View:UpdateEquipInfo(EquipItems)
  local EquipItemsNum = #EquipItems
  self.Equipment_01.WS_Type:SetActiveWidgetIndex(1)
  self.Equipment_02.WS_Type:SetActiveWidgetIndex(1)
  if EquipItemsNum >= 1 then
    self.Equipment_01.WS_Type:SetActiveWidgetIndex(0)
  end
  if EquipItemsNum >= 2 then
    self.Equipment_02.WS_Type:SetActiveWidgetIndex(0)
  end
  local ChessData = DataMgr.CombatChessInfo[self.Content.Data.Id]
  local TotalCost = ChessData.DeployCost
  for _, EquipId in ipairs(EquipItems) do
    local EquipData = DataMgr.RobotEquip[EquipId]
    if EquipData then
      TotalCost = TotalCost + EquipData.DeployCost
    end
  end
  self.Text_Cost:SetText(TotalCost)
end

function View:SetSelected(bSelected)
  self.Content.IsSelected = bSelected
  if bSelected then
    self:PlayAnimation(self.Click)
  elseif self.IsLocked then
    self:PlayAnimation(self.Lock)
  else
    self:PlayAnimation(self.Normal)
  end
end

function View:SetIsNew(bIsNew)
  self.Content.Data.IsNew = bIsNew
  if bIsNew then
    self.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
  else
    self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function View:OnBtnClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_icon_btn_click", nil, nil)
  if self.Content and self.Content.OnBtnClickedCallback then
    self.Content.OnBtnClickedCallback(self.Content.Data.Id)
  end
end

function View:SetForbidden(bForbidden)
  if true == bForbidden then
    self:PlayAnimation(self.Foridden)
  elseif self.IsLocked then
    self:PlayAnimation(self.Lock)
  else
    self:PlayAnimation(self.Normal)
  end
  self.Content.bForbidden = bForbidden
end

function View:OnHovered()
  if self.Content.IsSelected or self.Content.bForbidden then
    return
  end
  self:PlayAnimation(self.Hover)
end

function View:OnUnhovered()
  if self.Content.IsSelected or self.Content.bForbidden then
    return
  end
  self:PlayAnimation(self.UnHover)
end

function View:OnPressed()
  if self.Content.IsSelected or self.Content.bForbidden then
    return
  end
  self:PlayAnimation(self.Press)
end

return View
