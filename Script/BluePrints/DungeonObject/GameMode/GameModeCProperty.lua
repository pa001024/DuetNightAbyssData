local GameModeCProperty = {}

function GameModeCProperty:BeginPlay()
  self.CProperty = {}
end

function GameModeCProperty:BindCObject(Obj)
  local OldCProperty = self.CProperty
  self.CProperty = Obj
  for k, v in pairs(OldCProperty) do
    self.CProperty[k] = v
  end
end

return GameModeCProperty
