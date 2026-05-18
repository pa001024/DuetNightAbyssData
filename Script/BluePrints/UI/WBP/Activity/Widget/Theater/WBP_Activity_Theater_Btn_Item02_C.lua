require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

local function FormatProgressPercent(progress, target)
  if not target or target <= 0 then
    return "0.0%"
  end
  local percent = progress / target * 100
  local truncated = math.floor(percent * 10) / 10
  return string.format("%.1f%%", truncated)
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Content.UI = self
  if self.Content.Progress >= self.Content.Target then
    self:PlayAnimation(self.Finished)
  else
    self:PlayAnimation(self.Normal)
  end
  self:InitUI()
end

function M:InitUI()
  local ResourceData = DataMgr.Resource[self.Content.Resource]
  local ItemContent = {
    Id = self.Content.Resource,
    ItemType = "Resource",
    Icon = ResourceData.Icon,
    Rarity = ResourceData.Rarity,
    IsShowDetails = true,
    HandleMouseDown = true,
    OnMenuOpenChangedEvents = {
      Obj = self.Content.ParentWidget,
      Callback = self.Content.ParentWidget.ItemMenuAnchorChanged
    }
  }
  self.Com_Item_S:Init(ItemContent)
  self.Text_Item_Name:SetText(GText(ResourceData.ResourceName))
  if self.Content.Progress >= self.Content.Target then
    self.Text_Num:SetText(FormatProgressPercent(self.Content.Target, self.Content.Target))
  else
    self.Text_Num:SetText(FormatProgressPercent(self.Content.Progress, self.Content.Target))
  end
  self.Progress_Num:SetPercent(self.Content.Progress / self.Content.Target)
  self.Progress_NumGrow:SetPercent(0)
end

function M:SetAddProgress(num)
  if 0 == num or nil == num or self.Content.Progress + num > self.Content.Target then
    if self.Content.Progress >= self.Content.Target then
      self.Text_Num:SetText(FormatProgressPercent(self.Content.Target, self.Content.Target))
    else
      self.Text_Num:SetText(FormatProgressPercent(self.Content.Progress, self.Content.Target))
    end
    self.Progress_Num:SetPercent(self.Content.Progress / self.Content.Target)
    self.Progress_NumGrow:SetPercent(0)
  else
    self.Text_Num:SetText(FormatProgressPercent(self.Content.Progress, self.Content.Target))
    self.Progress_Num:SetPercent(self.Content.Progress / self.Content.Target)
    self.Progress_NumGrow:SetPercent((self.Content.Progress + num) / self.Content.Target)
  end
end

return M
