local Component = {}

function Component:SetIsGot2(IsGot)
  local function Callback(IsGot2UI)
    if not self.Content.bHasGot2 then
      return
    end
    self.IsGot2UI = UE.FWeakObjectPtr(IsGot2UI)
    self:AddWidgetToNode(nil, self.IsGot2UI)
  end
  
  if IsGot then
    if not self.IsGot2UI or not self.IsGot2UI:IsValid() then
      self:CreateWidgetAsync("ComItemHasGot2", Callback)
      return
    else
      Callback(self.IsGot2UI:Get())
    end
  else
    self:RemoveWidgetFromNode(nil, false, self.IsGot2UI)
  end
end

return Component
