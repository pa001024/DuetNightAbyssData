local Component = {}

function Component:SetTimeTag(TimeTagList)
  local function Callback(TimeTagUI)
    self.TimeTag = FWeakObjectPtr(TimeTagUI)
    
    self:AddWidgetToNode(nil, self.TimeTag)
    TimeTagUI:SetUpTimeTag(TimeTagList)
  end
  
  if not table.isempty(TimeTagList) then
    if not (self.TimeTag and self.TimeTag:IsValid()) or not self.WidgetMap[self.TimeTag] then
      self:CreateWidgetAsync("ComItemTimeTag", Callback)
      return
    else
      Callback(self.TimeTag:Get())
    end
  elseif self.TimeTag then
    self:RemoveWidgetFromNode(nil, false, self.TimeTag)
  end
end

return Component
