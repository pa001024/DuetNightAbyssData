require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Announcement.NewView.WBP_Announcement_Main_C"
})

function M:Construct()
  M.Super.Construct(self)
  local Anchor = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.WebContent:GetParent())
  Anchor:SetAlignment(FVector2D(0, 0))
  Anchor:SetPosition(FVector2D(-100, 0))
  local Size = Anchor:GetSize()
  Anchor:SetSize(FVector2D(900, Size.Y))
  local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
  if "OpenHarmony" == PlatformName then
    local Size = Anchor:GetSize()
    Anchor:SetSize(FVector2D(Size.X - 100, Size.Y))
  end
end

function M:InitUIInfo(...)
  M.Super.InitUIInfo(self, ...)
  self:AddDispatcher(EventID.LoadUI, self, function(UIName)
    if UIName ~= self:GetUIConfigName() then
      if not self._PreWebContentV then
        self._PreWebContentV = self.WebContent:GetVisibility()
      end
      self.WebContent:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end)
  self:AddDispatcher(EventID.UnLoadUI, self, function(UIName)
    if UIName ~= self:GetUIConfigName() and self._PreWebContentV then
      self.WebContent:SetVisibility(self._PreWebContentV)
      self._PreWebContentV = nil
    end
  end)
end

return M
