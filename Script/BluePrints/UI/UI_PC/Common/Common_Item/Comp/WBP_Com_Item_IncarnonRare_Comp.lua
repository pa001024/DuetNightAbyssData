local Component = {}

function Component:SetIncarnonRare(bIncarnon)
  local function Callback(IncarnonRare)
    self.IncarnonRare = UE.FWeakObjectPtr(IncarnonRare)
    
    self:AddWidgetToNode(nil, self.IncarnonRare)
  end
  
  if bIncarnon then
    if not self.IncarnonRare or not self.IncarnonRare:IsValid() then
      self:CreateWidgetAsync("ComItemIncarnonRare", Callback)
      return
    else
      Callback(self.IncarnonRare:Get())
    end
  else
    self:RemoveWidgetFromNode(nil, false, self.IncarnonRare)
  end
end

return Component
