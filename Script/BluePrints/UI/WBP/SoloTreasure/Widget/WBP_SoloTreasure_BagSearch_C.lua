require("UnLua")
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")
local SoloTreasureUtils = require("BluePrints.UI.WBP.SoloTreasure.Widget.SoloTreasureUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr",
  "BluePrints.Common.DelayFrameComponent",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})

function M:Construct()
  self.Text_Search:SetText(GText("UI_SoloTreasure_BagPreview"))
end

function M:Init(InitParams)
  self.Parent = InitParams.Parent
  self.MechanismUid = InitParams.MechanismUid
  self:PlayInAnim()
  if not (self.Parent and InventoryController) or not InventoryController.bInit then
    return
  end
  local PocketName = InventoryCommonConst.SearchPocketNamePrefix .. self.MechanismUid
  local ServerEntity = GWorld:GetServerEntity()
  if not ServerEntity then
    return
  end
  local Dungeonobject = ServerEntity:GetDungeonObject()
  if not Dungeonobject then
    return
  end
  local MechanismEntity = Dungeonobject:GetCachedMechanismInfo(self.MechanismUid)
  if not MechanismEntity then
    return
  end
  local MechanismInfo = DataMgr.ExtractionTreasureMechanism[MechanismEntity.UnitId]
  if not MechanismInfo then
    MechanismInfo = DataMgr.ExtractionTreasureGuard[MechanismEntity.UnitId]
    MechanismInfo = MechanismInfo and DataMgr.ExtractionTreasureMechanism[MechanismInfo.MechanismItemBox]
  end
  if not MechanismInfo then
    return
  end
  self.ContainerTextMapId = MechanismInfo.MechanismName
  self.Text_Search:SetText(GText(self.ContainerTextMapId))
  local Size = FVector2D(MechanismInfo.Shape[1], MechanismInfo.Shape[2])
  local PocketData
  if not InventoryController.InventoryModel.Pockets[PocketName] then
    PocketData = {
      Name = PocketName,
      Size = Size,
      Parent = InventoryController.MainWidget,
      Inventory = InventoryCommonConst.PocketType.Mechanism
    }
    InventoryController.InventoryModel.Pockets[PocketName] = PocketData
    InventoryController:InitGridsData(PocketData)
  end
  self.PocketWidget = self[InventoryCommonConst.SearchPocketNamePrefix]
  if not self.PocketWidget then
    return
  end
  self.PocketWidget:Init({
    Name = PocketName,
    Index = 0,
    Size = Size,
    Inventory = InventoryCommonConst.PocketType.Mechanism,
    MechanismUid = self.MechanismUid,
    Parent = self,
    PocketData = PocketData
  })
  self:InitEvents()
  self.EMScrollBox:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function M:InitEvents()
  self.EMScrollBox.OnUserScrolled:Add(self, function()
    InventoryController.bDetectDrag = false
  end)
  self:AddDispatcher(EventID.OnTreasureItemDragDetected, self, function(_, DragGridData)
    self.EMScrollBox:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end)
  self:AddDispatcher(EventID.OnTreasureItemDrop, self, function(_, MoveInfo)
    self.EMScrollBox:SetVisibility(ESlateVisibility.Visible)
  end)
  self:AddDispatcher(EventID.OnTreasureItemDragCancelled, self, function(_)
    self.EMScrollBox:SetVisibility(ESlateVisibility.Visible)
  end)
end

function M:RemoveEvents()
  self:RemoveDispatcher(EventID.OnTreasureItemDrop, self)
  self:RemoveDispatcher(EventID.OnTreasureItemDragDetected, self)
  self:RemoveDispatcher(EventID.OnTreasureItemDragCancelled, self)
  self:RemoveDispatcher(EventID.OnUpdateBagTreasureScore, self)
end

function M:PlayInAnim()
  if not self.In then
    return
  end
  self:PlayAnimation(self.In)
end

function M:Tick(MyGeometry, InDeltaTime)
  if not self.MechanismUid then
    return
  end
  if UIUtils.CheckScrollBoxCanScroll(self.EMScrollBox) then
    local TriggerParams = {
      DeltaTime = InDeltaTime,
      ScrollBox = self.EMScrollBox,
      TriggerScrollUp = self.DragScrollTip_Up,
      TriggerScrollDown = self.DragScrollTip_Bottom,
      ShowPocketsScrollUpArrow = self.ShowPocketsScrollUpArrow,
      ShowPocketsScrollDownArrow = self.ShowPocketsScrollDownArrow,
      CurTouchPos = InventoryController.MainWidget and InventoryController.MainWidget.CurTouchPos or nil
    }
    SoloTreasureUtils:TickTriggerScrollSizeBox(TriggerParams)
  end
end

function M:CloseSelf()
  self:RemoveEvents()
  if not self:IsVisible() then
    return
  end
  if self.PocketWidget and IsValid(self.PocketWidget) then
    self.PocketWidget:Close()
  end
  local PocketData = InventoryController.InventoryModel.Pockets[InventoryCommonConst.SearchPocketNamePrefix .. self.MechanismUid]
  if PocketData then
    InventoryController:ClearPocketView(InventoryCommonConst.SearchPocketNamePrefix .. self.MechanismUid)
    PocketData.Pocket = nil
  end
  if not self.Out then
    return
  end
  self:PlayAnimation(self.Out)
end

return M
