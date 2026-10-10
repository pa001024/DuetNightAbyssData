require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.WBP.Play.Widget.GuildWar.GuildWarView"
}

function M:Construct()
  self.New_Tag:SetVisibility(ESlateVisibility.Collapsed)
end

function M:Init_Internal()
  self.Index = 0
  self.RaidFloorTableData = nil
  self.Owner = nil
  self.OnClicked = nil
  self.IsSelected = false
  self.bIsKeyFloor = false
  self.bIsPassedFloor = false
  self.bFlagTextTipAnimation = false
  self.Btn_Click.OnClicked:Add(self, self.OnClicked_Floor)
  self.Btn_Click.OnHovered:Add(self, function()
    if self.IsSelected then
      return
    end
    self:StopAnimation(self.Key_UnHover)
    self:StopAnimation(self.UnHover)
    if self.bIsKeyFloor then
      self:PlayAnimation(self.Key_Hover)
    else
      self:PlayAnimation(self.Hover)
    end
  end)
  self.Btn_Click.OnUnhovered:Add(self, function()
    if self.IsSelected then
      return
    end
    self:StopAnimation(self.Key_Hover)
    self:StopAnimation(self.Hover)
    if self.bIsKeyFloor then
      self:PlayAnimation(self.Key_UnHover)
    else
      self:PlayAnimation(self.UnHover)
    end
  end)
end

function M:Init(Index, RaidFloorTableData, Owner, OnClicked)
  self:Init_Internal()
  self.Index = Index
  self.RaidFloorTableData = RaidFloorTableData
  self.Owner = Owner
  self.OnClicked = OnClicked
  self:InitInfo()
end

function M:InitInfo()
  if self.RaidFloorTableData then
    self.Title_Level:SetText(string.format(GText("Raid_Season_Floor_UI_Floor"), self.RaidFloorTableData.Floor))
    self.bIsKeyFloor = self:IsKeyFloor(self.RaidFloorTableData.Floor)
    if self.bIsKeyFloor then
      self:PlayAnimation(self.Key_Normal)
    end
    self.bIsPassedFloor = self:IsPassedFloor(self.RaidFloorTableData.Floor)
    if self.bIsPassedFloor then
      self.HB_Lv:SetVisibility(ESlateVisibility.Collapsed)
      self.Icon_Finish:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    self.Text_Lv:SetText(tostring(self.RaidFloorTableData.RecLevel))
    if self:GetHighestUnlockedFloor() == self.RaidFloorTableData.Floor and self.RaidFloorTableData.Floor <= self:GetBubbleDisplayMaxFloor() then
      self.Panel_Tip:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.Text_Tip:SetText(GText("Raid_Season_Floor_JumpTips"))
    end
  end
end

function M:OnClicked_Floor()
  if self.Owner and self.Owner.CurSelectedFloorId == self.RaidFloorTableData.FloorId then
    return
  end
  if self.Owner and self.OnClicked then
    self.OnClicked(self.Owner, self.Index, self.RaidFloorTableData)
  end
  self:UpdateNormalOrClick(true)
end

function M:UpdateNormalOrClick(IsSelected)
  self.IsSelected = IsSelected
  if self.IsSelected then
    self:StopAnimation(self.Key_Normal)
    self:StopAnimation(self.Normal)
    if self.bIsKeyFloor then
      self:PlayAnimation(self.Key_Click)
    else
      self:PlayAnimation(self.Click)
    end
  else
    self:StopAnimation(self.Key_Click)
    self:StopAnimation(self.Click)
    if self.bIsKeyFloor then
      self:PlayAnimation(self.Key_Normal)
    else
      self:PlayAnimation(self.Normal)
    end
  end
end

function M:UpdateTextTipAnimation()
  if not self.bFlagTextTipAnimation then
    self.bFlagTextTipAnimation = true
    self:StopAnimation(self.Loop)
    self:PlayAnimation(self.Loop)
  end
end

function M:SetHighestFloorDisplayed(InDisplayed)
  if InDisplayed then
    self:UpdateTextTipAnimation()
  else
    self.bFlagTextTipAnimation = false
  end
end

AssembleComponents(M)
return M
