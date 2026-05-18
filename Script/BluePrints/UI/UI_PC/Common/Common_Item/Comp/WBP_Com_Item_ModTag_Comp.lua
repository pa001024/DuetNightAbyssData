local Component = {}

function Component:SetModTag(bAllowModTag, bModEquiped)
  local function Callback(ModTagUI)
    self.ModTagUI = UE.FWeakObjectPtr(ModTagUI)
    
    self:AddWidgetToNode(nil, self.ModTagUI)
    ModTagUI:StopAllAnimations()
    if bModEquiped then
      ModTagUI:PlayAnimation(ModTagUI.Normal)
    else
      ModTagUI:PlayAnimation(ModTagUI.Not)
    end
  end
  
  if bAllowModTag then
    if not self.ModTagUI or not self.ModTagUI:IsValid() then
      self:CreateWidgetAsync("ComItemModTag", Callback)
      return
    else
      Callback(self.ModTagUI:Get())
    end
  elseif self.ModTagUI then
    self:RemoveWidgetFromNode(nil, false, self.ModTagUI)
  end
end

return Component
