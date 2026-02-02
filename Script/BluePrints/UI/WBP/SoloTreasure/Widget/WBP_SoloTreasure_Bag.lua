require("UnLua")
require("DataMgr")
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Construct()
end

function M:Destruct()
end

function M:OnLoaded(...)
  self.SearchId = (...)
  self.SearchId = tonumber(self.SearchId)
  if not self.bInit then
    self:Init()
    self.bInit = true
  end
  self:PlayInAnim()
  self:UpdateRecycleSection()
  self:UpdateSearchSection(self.SearchId)
  self:UpdateBagSection()
  self.WBP_Close:BindEventOnClicked(self, function()
    self:CloseSelf()
  end)
end

function M:Init()
  self.InventoryController = InventoryController
  local ControllerParams = {MainWidget = self}
  self.InventoryController:Init(ControllerParams)
  self:InitStaticRecycleSection()
  self:InitStaticBagSection()
end

function M:InitStaticRecycleSection()
end

function M:UpdateRecycleSection()
end

function M:UpdateSearchSection(SearchId)
  if SearchId then
    local InitParams = {Parent = self, SearchId = SearchId}
    self.Bag_Search:Init(InitParams)
    self.Bag_Search:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Bag_Search:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:InitStaticBagSection()
end

function M:UpdateBagSection()
end

function M:PlayInAnim()
  self:PlayAnimation(self.In)
end

function M:CloseSelf()
  self:StopAllAnimations()
  self:PlayAnimation(self.Out)
  self:ClearAllPockets()
  self:BindToAnimationFinished(self.Out, {
    self,
    function()
      self:UnbindAllFromAnimationFinished(self.Out)
      local Controller = self.InventoryController
      local ClearPocketQueue = self._ClearPocketQueue
      if ClearPocketQueue and #ClearPocketQueue > 0 and Controller and Controller.ClearPocket then
        while #ClearPocketQueue > 0 do
          local Pocket = table.remove(ClearPocketQueue, 1)
          if Pocket and IsValid(Pocket) then
            Controller:ClearPocket(Pocket)
          end
        end
      end
      self:Close()
    end
  })
  self.Bag_Search:CloseSelf()
end

function M:ClearAllPockets()
  local Controller = self.InventoryController
  if not (Controller and Controller.InventoryModel) or not Controller.InventoryModel.Pockets then
    return false
  end
  local Queue = {}
  local Pockets = Controller.InventoryModel.Pockets
  local SearchPocketData = Pockets.WBP_Search_Bag
  if SearchPocketData and SearchPocketData.Pocket and IsValid(SearchPocketData.Pocket) then
    table.insert(Queue, SearchPocketData.Pocket)
  end
  for Name, PocketData in pairs(Pockets) do
    if "WBP_Search_Bag" ~= Name then
      local Pocket = PocketData and PocketData.Pocket
      if Pocket and IsValid(Pocket) then
        table.insert(Queue, Pocket)
      end
    end
  end
  self._ClearPocketQueue = Queue
  if self._ClearPocketQueue and #self._ClearPocketQueue > 0 then
    self.ClearFrameCount = 0
    self:_ProcessClearPocketChunk()
    self:AddDelayFrameFunc(function()
      if self then
        self:_ProcessClearPocketChunk()
      end
    end, 2, "ClearAllPocketsChunk" .. self.ClearFrameCount)
  end
  return true
end

function M:_ProcessClearPocketChunk()
  self.ClearFrameCount = self.ClearFrameCount + 1
  if not self._ClearPocketQueue or 0 == #self._ClearPocketQueue then
    return
  end
  local Controller = self.InventoryController
  local Pocket = table.remove(self._ClearPocketQueue, 1)
  if Pocket and IsValid(Pocket) and Controller and Controller.ClearPocket then
    Controller:ClearPocket(Pocket)
  end
  if self._ClearPocketQueue and #self._ClearPocketQueue > 0 then
    self:AddDelayFrameFunc(function()
      if self then
        self:_ProcessClearPocketChunk()
      end
    end, 1, "ClearAllPocketsChunk" .. self.ClearFrameCount)
  end
end

function M:Close()
  self:SetInputUIOnly(false)
  self.Super.Close(self)
end

return M
