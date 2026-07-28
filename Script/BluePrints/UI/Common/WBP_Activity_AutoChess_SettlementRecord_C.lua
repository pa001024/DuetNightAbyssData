require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local STAR_ABBR_THRESHOLD = 5

function M:OnListItemObjectSet(Content)
  self.Content = Content
  if Content then
    Content.Widget = self
  end
  self:InitUI()
end

function M:SetContent(Content)
  self.Content = Content
  if Content then
    Content.Widget = self
  end
  self:InitUI()
end

function M:CreateStarImage()
  local Template = self.Image_Star
  if not Template then
    DebugPrint("yly WBP_Activity_AutoChess_SettlementRecord_C CreateStarImage: Template is nil")
    return nil
  end
  local Image = NewObject(UE4.UImage)
  Image:SetBrush(Template.Brush)
  Image:SetColorAndOpacity(Template.ColorAndOpacity)
  Image.bUsing4KImageDesign = Template.bUsing4KImageDesign == true
  return Image
end

function M:ClearDynamicStars()
  if self._DynamicStarImages then
    for _, Image in ipairs(self._DynamicStarImages) do
      if Image and Image.RemoveFromParent then
        Image:RemoveFromParent()
      end
    end
  end
  self._DynamicStarImages = {}
end

function M:RefreshStarDisplay(Level)
  if not self.HorizontalBox_0 or not self.Image_Star then
    DebugPrint("yly WBP_Activity_AutoChess_SettlementRecord_C RefreshStarDisplay: HorizontalBox_0 or Image_Star is nil")
    return
  end
  self:ClearDynamicStars()
  self.Image_Star:SetVisibility(UE4.ESlateVisibility.Collapsed)
  local StarCount = math.max(0, math.floor(tonumber(Level) or 0))
  if StarCount <= 0 then
    if self.TextStarNum then
      self.TextStarNum:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    return
  end
  if StarCount >= STAR_ABBR_THRESHOLD then
    local StarImage = self:CreateStarImage()
    if StarImage then
      self.HorizontalBox_0:AddChildToHorizontalBox(StarImage)
      StarImage:SetVisibility(UE4.ESlateVisibility.Visible)
      table.insert(self._DynamicStarImages, StarImage)
    end
    if self.TextStarNum then
      self.TextStarNum:RemoveFromParent()
      self.HorizontalBox_0:AddChildToHorizontalBox(self.TextStarNum)
      self.TextStarNum:SetText(string.format("×%d", StarCount))
      self.TextStarNum:SetVisibility(UE4.ESlateVisibility.Visible)
    end
  else
    if self.TextStarNum then
      self.TextStarNum:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    for _ = 1, StarCount do
      local StarImage = self:CreateStarImage()
      if StarImage then
        self.HorizontalBox_0:AddChildToHorizontalBox(StarImage)
        StarImage:SetVisibility(UE4.ESlateVisibility.Visible)
        table.insert(self._DynamicStarImages, StarImage)
      end
    end
  end
end

function M:InitUI()
  if not self.Content then
    return
  end
  if self.TextNew then
    self.TextNew:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  if self.TextLevel then
    self.TextLevel:SetText(GText("UI_AutoChess_DifficultyScore"))
  end
  if not self.Content.Level then
    DebugPrint("yly WBP_Activity_AutoChess_SettlementRecord_C InitUI: Level is nil")
    return
  end
  self:RefreshStarDisplay(self.Content.Level)
end

function M:Destruct()
  self:ClearDynamicStars()
end

return M
