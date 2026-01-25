local M = Class("BluePrints.Common.MVC.Model")

function M:Init()
  M.Super.Init(self)
  self._ModelData = {}
  self._ModelDataRefCount = {}
end

function M:Destory()
  M.Super.Destory(self)
  self._ModelData = nil
end

function M:SetModelData(Name, Value)
  if not Name or "" == Name then
    return false
  end
  if not self._ModelData then
    self:Init()
  end
  self._ModelData[Name] = Value
  return true
end

function M:GetModelData(Name, DefaultValue)
  if not Name or "" == Name then
    return DefaultValue
  end
  if not self._ModelData then
    self:Init()
  end
  local Value = self._ModelData[Name]
  if nil ~= Value then
    return Value
  end
  return DefaultValue
end

function M:AddModelDataRefCount(Name)
  if not Name or "" == Name then
    return
  end
  local RefCount = self._ModelDataRefCount[Name] or 0
  self._ModelDataRefCount[Name] = RefCount + 1
end

function M:RemoveModelDataRefCount(Name, DelFunc)
  if not Name or "" == Name or not self._ModelDataRefCount then
    return
  end
  local RefCount = self._ModelDataRefCount[Name] or 0
  if RefCount > 0 then
    self._ModelDataRefCount[Name] = RefCount - 1
  end
  if self._ModelDataRefCount[Name] <= 0 then
    if DelFunc then
      DelFunc(self._ModelData[Name])
    end
    self._ModelData[Name] = nil
  end
end

function M:ClearAllModelData()
  self._ModelData = {}
  self._ModelDataRefCount = {}
end

function M:GetAllModelData()
  local Copy = {}
  for k, v in pairs(self._ModelData) do
    Copy[k] = v
  end
  return Copy
end

return M
