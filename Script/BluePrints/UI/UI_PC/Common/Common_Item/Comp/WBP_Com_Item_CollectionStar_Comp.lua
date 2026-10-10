local Component = {}

function Component:SetCollectionStar(bCollection)
  local function Callback(ColStarUI)
    if not self.Content.bCollection then
      return
    end
    self.ColStarUI = UE.FWeakObjectPtr(ColStarUI)
    local Config = UIConst.ComItemLayerManagement
    self:AddWidgetToNode(nil, self.ColStarUI, Config.Layer.Top, Config.Order.CollectionStar)
  end
  
  if bCollection and not self.Content.bInGear then
    if not self.ColStarUI or not self.ColStarUI:IsValid() then
      self:CreateWidgetAsync("ComItemCollectionStar", Callback)
      return
    else
      Callback(self.ColStarUI:Get())
    end
  elseif self.ColStarUI then
    self:RemoveWidgetFromNode(nil, false, self.ColStarUI)
  end
end

return Component
