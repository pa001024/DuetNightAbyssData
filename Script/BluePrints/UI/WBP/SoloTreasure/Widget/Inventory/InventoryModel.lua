local InventoryModel = Class()

function InventoryModel:Init(Params)
  self.SlotState = {}
  self.bInit = true
  if not Params then
    return
  end
  self:InitDatas(Params)
end

function InventoryModel:InitDatas(Params)
  self.Grids = Params.Grids or self.Grids or {}
  self.Pockets = Params.Pockets or self.Pockets or {}
end

function InventoryModel:DestroyDatas()
  self.Grids = {}
  self.Pockets = {}
end

function InventoryModel:Destory()
  self.bInit = false
  self:DestroyDatas()
end

function InventoryModel:GetTreasureItemByGridPos(Pos)
  local Grid = self.Grids[Pos]
  return Grid.TreasureItem
end

function InventoryModel:GetInventoryByGrid(Grid)
  local Ret
  if Grid and Grid.Pocket and Grid.Pocket.Inventory then
    Ret = Grid.Pocket.Inventory
  end
  return Ret
end

return InventoryModel
