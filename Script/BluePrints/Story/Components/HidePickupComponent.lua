local FHidePickupComponent = {}

function FHidePickupComponent:New(TalkContext)
  local Obj = setmetatable({}, {__index = FHidePickupComponent})
  Obj.TalkContext = TalkContext
  return Obj
end

function FHidePickupComponent:Execute()
  self.TalkContext:SetPickupHidden(true)
end

function FHidePickupComponent:Resume()
  self.TalkContext:SetPickupHidden(false)
end

return FHidePickupComponent
