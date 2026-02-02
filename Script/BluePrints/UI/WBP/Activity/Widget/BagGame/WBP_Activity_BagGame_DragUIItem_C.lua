require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C",
  "BluePrints.UI.WBP.Activity.Widget.BagGame.Activity_BagGame_DragComponent"
})

function M:Construct()
  self.Overlay_Double:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Stop.OnClicked:Add(self, self.OnStopBtnClicked)
  self.Btn_Rotation.OnClicked:Add(self, self.OnRotationBtnClicked)
  self.Btn_Check.OnClicked:Add(self, self.OnCheckBtnClicked)
end

function M:OnStopBtnClicked()
  if self.PlayScreen and self.PlayScreen.RecycleItem then
    self.PlayScreen:RecycleItem(self)
  else
    DebugPrint("OnStopBtnClicked: PlayScreen 引用无效")
  end
end

function M:OnRotationBtnClicked()
  if not self.ShapeOffsets or 0 == #self.ShapeOffsets then
    return
  end
  self.RotationCount = ((self.RotationCount or 0) + 1) % 4
  self:RotateShape90CW()
  DebugPrint("OnRotationBtnClicked: 旋转次数=" .. self.RotationCount)
end

function M:RotateShape90CW()
  if not self.ShapeOffsets or 0 == #self.ShapeOffsets then
    return
  end
  local MinRow, MaxRow = 0, 0
  local MinCol, MaxCol = 0, 0
  for _, Offset in ipairs(self.ShapeOffsets) do
    MinRow = math.min(MinRow, Offset[1])
    MaxRow = math.max(MaxRow, Offset[1])
    MinCol = math.min(MinCol, Offset[2])
    MaxCol = math.max(MaxCol, Offset[2])
  end
  local Height = MaxRow - MinRow + 1
  local Width = MaxCol - MinCol + 1
  local bCenterRotate = Height == Width or 1 == Height % 2 and 1 == Width % 2
  local NewOffsets = {}
  if bCenterRotate then
    for _, Offset in ipairs(self.ShapeOffsets) do
      local Row, Col = Offset[1], Offset[2]
      local NewRow = Col
      local NewCol = -Row
      table.insert(NewOffsets, {NewRow, NewCol})
    end
  else
    for _, Offset in ipairs(self.ShapeOffsets) do
      local Row, Col = Offset[1] - MinRow, Offset[2] - MinCol
      local NewRow = Col
      local NewCol = Height - 1 - Row
      table.insert(NewOffsets, {NewRow, NewCol})
    end
  end
  self.ShapeOffsets = self:NormalizeOffsets(NewOffsets)
  self:UpdateVisualRotation()
end

function M:NormalizeOffsets(Offsets)
  if not Offsets or 0 == #Offsets then
    return {
      {0, 0}
    }
  end
  local MinRow, MinCol = Offsets[1][1], Offsets[1][2]
  for _, Offset in ipairs(Offsets) do
    MinRow = math.min(MinRow, Offset[1])
    MinCol = math.min(MinCol, Offset[2])
  end
  local Normalized = {}
  for _, Offset in ipairs(Offsets) do
    table.insert(Normalized, {
      Offset[1] - MinRow,
      Offset[2] - MinCol
    })
  end
  return Normalized
end

function M:UpdateVisualRotation()
  local Angle = (self.RotationCount or 0) * 90
  self:SetRenderTransformAngle(Angle)
end

function M:OnCheckBtnClicked()
  print("OnCheckBtnClicked")
  self:PlayAnimation(self.Btn_Out)
end

function M:SetShape(ShapeOffsets)
  self.ShapeOffsets = ShapeOffsets or {
    {0, 0}
  }
end

function M:GetShape()
  return self.ShapeOffsets
end

function M:GetShapeCells(BaseRow, BaseCol)
  local Cells = {}
  for _, Offset in ipairs(self.ShapeOffsets) do
    local Row = BaseRow + (Offset[1] or 0)
    local Col = BaseCol + (Offset[2] or 0)
    table.insert(Cells, {Row = Row, Col = Col})
  end
  return Cells
end

function M:Destruct()
end

function M:SetItemSize(TargetWidth, TargetHeight)
  self:ForceLayoutPrepass()
  local OriginalSize = self:GetDesiredSize()
  if OriginalSize and OriginalSize.X > 0 and OriginalSize.Y > 0 then
    local ScaleX = TargetWidth / OriginalSize.X
    local ScaleY = TargetHeight / OriginalSize.Y
    self:SetRenderScale(FVector2D(ScaleX, ScaleY))
    self.ItemWidth = TargetWidth
    self.ItemHeight = TargetHeight
    DebugPrint("SetItemSize: 原始(" .. OriginalSize.X .. "x" .. OriginalSize.Y .. ") -> 目标(" .. TargetWidth .. "x" .. TargetHeight .. "), 缩放(" .. ScaleX .. "x" .. ScaleY .. ")")
  else
    DebugPrint("SetItemSize: 无法获取原始大小")
  end
end

return M
