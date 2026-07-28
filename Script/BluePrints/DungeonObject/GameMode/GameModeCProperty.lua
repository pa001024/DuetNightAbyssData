local GameModeCProperty = {}

function GameModeCProperty:Init(Env)
  if self.CProperty == nil then
    self.CProperty = {}
    self.CProperty.DungeonId = Env.DungeonId
  end
end

function GameModeCProperty:BindCObject(Obj)
  local OldCProperty = self.CProperty
  self.CProperty = Obj
  for k, v in pairs(OldCProperty) do
    self.CProperty[k] = v
  end
end

return GameModeCProperty
