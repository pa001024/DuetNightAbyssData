require("UnLua")
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr",
  "BluePrints.Common.DelayFrameComponent"
})

function M:Init(InitParams)
  self.Parent = InitParams.Parent
  self.SearchId = InitParams.SearchId
  if not (self.Parent and self.Parent.InventoryController) or not self.Parent.InventoryController.bInit then
    return
  end
  self.Parent.InventoryController:ClearPocket(self.WBP_Search_Bag)
  self.Text_Search:SetText(GText("容器名称正在搜索物资...(未配Textmap)"))
  if 1 == self.SearchId then
    local TempConstTreasures = {
      100105,
      100105,
      100105,
      100125,
      100125,
      100125
    }
    self:FillSearchPocket(TempConstTreasures)
  elseif 2 == self.SearchId then
    local TempConstTreasures = {100101, 100101}
    self:FillSearchPocket(TempConstTreasures)
  elseif 3 == self.SearchId then
    local TempConstTreasures = {
      100102,
      100102,
      100102,
      100102,
      100102,
      100102,
      100102,
      100102,
      100102,
      100102,
      100102
    }
    self:FillSearchPocket(TempConstTreasures)
  end
  self:PlayInAnim()
end

function M:FillSearchPocket(TreasureIds)
  if not (TreasureIds and self.Parent and self.Parent.InventoryController) or not self.Parent.InventoryController.bInit then
    return
  end
  local Controller = self.Parent.InventoryController
  local Pocket = self.WBP_Search_Bag
  if not Pocket or not IsValid(Pocket) then
    return
  end
  local GridDatas = Controller.InventoryModel.Grids[Pocket.Name]
  if not GridDatas then
    return
  end
  self._LoadQueue = {}
  self._SearchQueue = {}
  for _, Tid in ipairs(TreasureIds) do
    table.insert(self._LoadQueue, Tid)
  end
  self:AddDelayFrameFunc(function()
    if self then
      self:_ProcessSearchQueueChunk()
    end
  end, 1, "BeginSearchQueueChunk")
end

function M:_ProcessSearchQueueChunk()
  self.LoadFrameCount = (self.LoadFrameCount or 0) + 1
  local Controller = self.Parent and self.Parent.InventoryController
  if not Controller or not Controller.bInit then
    return
  end
  local Pocket = self.WBP_Search_Bag
  if not Pocket or not IsValid(Pocket) then
    return
  end
  local MaxCount = InventoryCommonConst.MaxTreasureLoadCountInSingleFrame or 5
  local Loaded = 0
  while MaxCount > Loaded and self._LoadQueue and #self._LoadQueue > 0 do
    local Tid = table.remove(self._LoadQueue, 1)
    local ValidInfo = Controller:GetValidTopLeftByTreasureId(Pocket, Tid, InventoryCommonConst.Direction.Horizontal)
    if ValidInfo and ValidInfo.TopLeft then
      local TreasureWidget = Controller:CreateNewTreasureItemToPocket(Pocket, Tid, ValidInfo.TopLeft, true)
      if TreasureWidget and IsValid(TreasureWidget) then
        table.insert(self._SearchQueue, TreasureWidget)
      end
    end
    Loaded = Loaded + 1
  end
  if self._LoadQueue and #self._LoadQueue > 0 then
    self:AddDelayFrameFunc(function()
      if self then
        self:_ProcessSearchQueueChunk()
      end
    end, 5, "SearchQueueChunk" .. self.LoadFrameCount)
  else
    self:NotifyBeginSearch()
  end
end

function M:NotifyBeginSearch()
  if not self._SearchQueue or 0 == #self._SearchQueue then
    return
  end
  self.bSearchingActive = true
  self._SearchIndex = 1
  self:_ProcessNextSearchItem()
  self.Text_Search:SetText(GText("正在搜索物资...(未配Textmap)"))
end

function M:_ProcessNextSearchItem()
  if not self.bSearchingActive then
    return
  end
  while self._SearchIndex <= (#self._SearchQueue or 0) do
    local Item = self._SearchQueue[self._SearchIndex]
    self._SearchIndex = self._SearchIndex + 1
    if Item and IsValid(Item) and not Item.bSearched then
      self._CurrentSearching = Item
      Item:NotifyBeginSearch(function()
        if not self or not self.bSearchingActive then
          return
        end
        if Item and IsValid(Item) then
          Item.bSearched = true
        end
        self._CurrentSearching = nil
        self:AddDelayFrameFunc(function()
          if self then
            self:_ProcessNextSearchItem()
          end
        end, 1, "NextSearchItem")
      end)
      return
    end
  end
  self.bSearchingActive = false
  self.Text_Search:SetText(GText("容器名称(未配Textmap)"))
end

function M:PlayInAnim()
  if not self.In then
    return
  end
  self:PlayAnimation(self.In)
end

function M:CloseSelf()
  self._LoadQueue = nil
  self.bSearchingActive = false
  if self._CurrentSearching and IsValid(self._CurrentSearching) and self._CurrentSearching.CancelSearch then
    self._CurrentSearching:CancelSearch()
  end
  if not self.Out then
    return
  end
  self:PlayAnimation(self.Out)
end

return M
