local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr",
  "BluePrints.Common.DelayFrameComponent"
})
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")

function M:Init(Content)
  self.TreasureContent = Content
  self.DefaultDragVisual = self.TreasureContent.DefaultDragVisual or self.DefaultDragVisual
  self.Size = self.TreasureContent.Size or self.Size
  self.Texture = self.TreasureContent.Texture or self.Texture
  self.TreasureRarity = self.TreasureContent.TreasureRarity or self.TreasureRarity
  self.Direction = self.TreasureContent.Direction or self.Direction
  self.Pocket = self.TreasureContent.Pocket or self.Pocket
  self.Position = self.TreasureContent.Position or self.Position
  self.TreasureId = self.TreasureContent.TreasureId or self.TreasureId
  self.bSearched = not self.TreasureContent.bNotSearched
  self.HoverGrids = {}
  if self.TreasureRarity then
    self:SetRarity(self.TreasureRarity)
  end
  if self.Texture and IsValid(self.Image_Icon) then
    self.Image_Icon:SetBrushFromTexture(self.Texture)
  end
  if self.bSearched then
    if self.OverlaySearch then
      self.OverlaySearch:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self:PlayAnimation(self.Unlock)
  else
    if self.OverlaySearch then
      self.OverlaySearch:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      self.IdentifyTime = DataMgr.ExtractionTreasureRarity[self.TreasureRarity].IdentifyTime or 1
    end
    self:PlayAnimation(self.Lock)
  end
  local Pivot = FVector2D(0.5 / (self.Size.X / self.Size.Y), 0.5)
  self:SetRenderTransformPivot(Pivot)
  self.ItemDetails_MenuAnchor:SetRenderTransformPivot(Pivot)
  self:UpdateView({
    NewPocket = self.Pocket,
    NewPosition = self.Position,
    NewDirection = self.Direction
  })
  self.ItemDetails_MenuAnchor.ParentWidget = self
end

function M:SetRarity(Rarity)
  local TextureArray = self.Color_Texture
  local TextureMap = {
    [6] = 7,
    [5] = 5,
    [4] = 3,
    [3] = 1,
    [2] = 1,
    [1] = 1
  }
  local TargetBgTexture = TextureArray:GetRef(TextureMap[Rarity])
  if TargetBgTexture then
    self.Image_Bg:SetBrushFromTexture(TargetBgTexture)
  end
  local TargetSelTexture = TextureArray:GetRef(TextureMap[Rarity] + 1)
  if TargetSelTexture then
    self.Image_Sel:SetBrushFromTexture(TargetSelTexture)
    self.Image_Sel:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:UpdateView(UpdateParams)
  UpdateParams.NewPocket = UpdateParams.NewPocketData and UpdateParams.NewPocketData.Pocket
  if UpdateParams.NewPocket or UpdateParams.NewPosition then
    self:_UpdateViewPosition(UpdateParams)
  end
  if UpdateParams.NewDirection then
    self:_UpdateViewDirection(UpdateParams)
  end
  if UpdateParams.bDrag == true then
    self:_UpdateViewOnDrag(UpdateParams)
  else
    self:_UpdateViewOnDragEnd(UpdateParams)
  end
end

function M:_UpdateViewPosition(UpdateParams)
  local NewPocket = UpdateParams.NewPocket
  local NewPosition = UpdateParams.NewPosition
  if not (NewPocket and IsValid(NewPocket.Panel_Item)) or not NewPosition then
    return
  end
  local TargetPanel = NewPocket.Panel_Item
  if TargetPanel and self:GetParent() ~= TargetPanel then
    self:RemoveFromParent()
    TargetPanel:AddChild(self)
  end
  local NewAbsPosition = NewPosition * 96.0 + 6
  local Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self)
  if Slot then
    Slot:SetPosition(FVector2D(NewAbsPosition.X, NewAbsPosition.Y))
  end
  self.Pocket = NewPocket
  self.Position = NewPosition
  self.NewPocket = nil
  self.NewPosition = nil
  self.HoverGrids = {}
end

function M:_UpdateViewDirection(UpdateParams)
  if not UpdateParams.NewDirection then
    return
  end
  if UpdateParams.NewDirection then
    self.Direction = UpdateParams.NewDirection
    UpdateParams.NewDirection = nil
  end
  if self.Size.X == self.Size.Y then
    return
  end
  local Angle = self:GetRenderTransformAngle()
  if self.Direction == InventoryCommonConst.Direction.Vertical and 90 ~= Angle then
    self:SetRenderTransformAngle(90)
    self.ItemDetails_MenuAnchor:SetRenderTransformAngle(-90)
  elseif self.Direction == InventoryCommonConst.Direction.Horizontal and 0 ~= Angle then
    self:SetRenderTransformAngle(0)
    self.ItemDetails_MenuAnchor:SetRenderTransformAngle(0)
  end
end

function M:_UpdateViewOnDrag(UpdateParams)
  if self.bDraging then
    return
  end
  self.bDraging = true
  self.Image_Icon:SetRenderOpacity(0.3)
  self.Image_Bg:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:_UpdateViewOnDragEnd(UpdateParams)
  if not self.bDraging then
    return
  end
  self.bDraging = false
  self.Image_Icon:SetRenderOpacity(1)
  self.Image_Bg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function M:CreateDragWidget(TreasureData)
  local DragWidget = UIManager(self):CreateWidget(InventoryCommonConst.DefaultDragWidgetPath, false)
  if not DragWidget then
    return
  end
  if self.Texture and IsValid(DragWidget.Prop_Icon) then
    DragWidget.Prop_Icon:SetBrushFromTexture(self.Texture)
  end
  self.TreasureContent.DefaultDragVisual = DragWidget
  self.DefaultDragVisual = DragWidget
  return DragWidget
end

function M:CloseItemDetailsWidget()
  DebugPrint("lgc@WBP_SoloTreasure_Item CloseItemDetailsWidget")
end

function M:OnClicked()
  self:PlayAnimation(self.Click)
  self.Content = {
    ItemType = "ExtractionTreasure",
    ItemId = self.TreasureId
  }
  self.ItemDetails_MenuAnchor.ParentWidget = self
  self.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, self.Content)
end

function M:OnHovered(Grid)
  if not next(self.HoverGrids) then
    self:PlayAnimation(self.Hover)
  end
  self.HoverGrids[Grid] = true
end

function M:OnUnHovered(Grid)
  self:AddDelayFrameFunc(function()
    self.HoverGrids[Grid] = nil
    for HoverGrid, bHovered in pairs(self.HoverGrids) do
      if true == bHovered then
        return
      end
    end
    self:PlayAnimation(self.Unhover)
  end, 2)
end

function M:OnPressed()
end

function M:NotifyBeginSearch(SearchEndCallback)
  if self.bSearched or self.bSearching then
    return
  end
  self.bSearching = true
  self._OnSearchEnd = SearchEndCallback
  if self.OverlaySearch then
    self.OverlaySearch:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  if self.Searching_In then
    self:PlayAnimation(self.Searching_In)
  end
  self:BindToAnimationFinished(self.Searching_In, {
    self,
    function()
      self:UnbindAllFromAnimationFinished(self.Searching_In)
      self:PlayAnimation(self.Searching_Loop, 0, 0)
    end
  })
  self:AddTimer(self.IdentifyTime or 1, function(self)
    if not self or not self.bSearching then
      return
    end
    self:StopAnimation(self.Searching_Loop)
    self.bSearching = false
    self.bSearched = true
    local UnlockAnim = {
      [6] = "Unlock_Red",
      [5] = "Unlock_Gold",
      [4] = "Unlock_Purple",
      [3] = "Unlock_Green",
      [2] = "Unlock_Green",
      [1] = "Unlock_Green"
    }
    self:PlayAnimation(self[UnlockAnim[self.TreasureRarity]])
    if self._OnSearchEnd then
      self._OnSearchEnd(self)
    end
  end, false, 0, "SearchEnd")
end

function M:CancelSearch()
  if not self.bSearching then
    return
  end
  self.bSearching = false
  self:RemoveTimer("SearchStartLoop")
  self:RemoveTimer("SearchEnd")
  if self.Searching_Loop then
    self:StopAnimation(self.Searching_Loop)
  end
  if self.OverlaySearch then
    self.OverlaySearch:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

return M
