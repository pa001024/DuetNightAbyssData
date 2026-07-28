require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.StoryReview.StoryReviewWidget.WBP_Story_Review_ItemBase"
})

function M:Construct()
  M.Super.Construct(self)
  EventManager:AddEvent(EventID.GameViewportSizeChanged, self, self.UpdateWrapTextAt)
  self:UpdateWrapTextAt()
end

function M:Destruct()
  EventManager:RemoveEvent(EventID.GameViewportSizeChanged, self)
  M.Super.Destruct(self)
end

function M:UpdateWrapTextAt()
  local VPScale = UWidgetLayoutLibrary.GetViewportScale(self)
  local VPWidth = UWidgetLayoutLibrary.GetViewportSize(self).X / VPScale
  local MainSlot = UWidgetLayoutLibrary.SlotAsOverlaySlot(self.Main)
  local Padding = MainSlot.Padding.Left + MainSlot.Padding.Right
  local VB_Slot = UWidgetLayoutLibrary.SlotAsOverlaySlot(self.VB)
  Padding = VB_Slot.Padding.Left * 2 + Padding
  local NewWTA = VPWidth - Padding
  self.Text_Content:SetWrapTextAt(NewWTA)
  self.Text_Details:SetWrapTextAt(NewWTA)
end

return M
