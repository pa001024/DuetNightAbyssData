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
  self.TreasureItems = Params.TreasureItems or self.TreasureItems or {}
  self.BagId = Params.BagId or self.BagId or 0
end

function InventoryModel:DestroyDatas()
  self.Grids = {}
  self.Pockets = {}
  self.TreasureItems = {}
  self.BagId = 0
end

function InventoryModel:Destory()
  self.bInit = false
  self:DestroyDatas()
end

return InventoryModel
