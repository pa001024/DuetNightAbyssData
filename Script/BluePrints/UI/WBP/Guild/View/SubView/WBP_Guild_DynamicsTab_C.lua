require("UnLua")
local WBP_Guild_DynamicsTab_C = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function WBP_Guild_DynamicsTab_C:Construct()
  self.bIsSelect = false
  self.Btn_Click.OnClicked:Add(self, self.OnCellClicked)
  self.Btn_Click.OnHovered:Add(self, self.OnCellHovered)
  self.Btn_Click.OnUnhovered:Add(self, self.OnCellUnhovered)
  self.Btn_Click.OnPressed:Add(self, self.OnCellPressed)
  self.Btn_Click.OnReleased:Add(self, self.OnCellReleased)
end

function WBP_Guild_DynamicsTab_C:PlayAnim(AnimName)
  if self[AnimName] then
    self:PlayAnimation(self[AnimName], 0, 1, UE4.EUMGSequencePlayMode.Forward, 1)
  end
end

function WBP_Guild_DynamicsTab_C:OnListItemObjectSet(Content)
  self.Content = Content
  self.Content.Entry = self
  self.bIsSelect = false
  if self.Content.Root.SelectedTabId and self.Content.Root.SelectedTabId == self.Content.TabId then
    self.bIsSelect = true
  end
  self.Text_Name:SetText(self.Content.TabName or "")
  if self.Content.bIsLocked then
    self:PlayAnim("Lock")
  elseif self.bIsSelect then
    self:PlayAnim("Click")
  else
    self:PlayAnim("Normal")
  end
end

function WBP_Guild_DynamicsTab_C:UnSelected()
  self.bIsSelect = false
  self:PlayAnim("Normal")
end

function WBP_Guild_DynamicsTab_C:Selected()
  self.bIsSelect = true
  self:PlayAnim("Click")
end

function WBP_Guild_DynamicsTab_C:OnCellClicked()
  if self.Content.bIsLocked then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_GuildSystemNotAvailable"))
    return
  end
  if self.bIsSelect then
    return
  end
  if self.Content.Root.SelectedTabEntry then
    self.Content.Root.SelectedTabEntry:UnSelected()
  end
  self:Selected()
  self.Content.Root.SelectedTabEntry = self
  self.Content.Root:OnTabSelected(self.Content.TabId)
end

function WBP_Guild_DynamicsTab_C:OnCellHovered()
  if self.Content.bIsLocked then
    return
  end
  if self.bIsSelect then
    return
  end
  self:PlayAnim("Hover")
end

function WBP_Guild_DynamicsTab_C:OnCellUnhovered()
  if self.Content.bIsLocked then
    return
  end
  if self.bIsSelect then
    return
  end
  self:PlayAnim("UnHover")
end

function WBP_Guild_DynamicsTab_C:OnCellPressed()
  if self.Content.bIsLocked then
    return
  end
  if self.bIsSelect then
    return
  end
  self:PlayAnim("Press")
end

function WBP_Guild_DynamicsTab_C:OnCellReleased()
  if self.Content.bIsLocked then
    return
  end
  if self.bIsSelect then
    return
  end
  self:PlayAnim("Hover")
end

return WBP_Guild_DynamicsTab_C
