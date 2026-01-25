local M = Class()

function M:ReceiveBeginPlay()
  self.ProceduralMesh:SetBoundsScale(1000000.0)
end

function M:GenerateStripMesh(XCount, YCount, UnitSize)
  if not self.ProceduralMesh then
    DebugPrint("缺少 ProceduralMesh 组件")
    return
  end
  XCount = XCount or 10
  YCount = YCount or 10
  UnitSize = UnitSize or 100
  local Vertices, Triangles, Normals, UVs = {}, {}, {}, {}
  for y = 0, YCount do
    for x = 0, XCount do
      local posX = x * UnitSize
      local posY = y * UnitSize
      table.insert(Vertices, FVector(posX, posY, 0))
      table.insert(Normals, FVector(0, 0, 1))
      table.insert(UVs, FVector2D(x / XCount, y / YCount))
    end
  end
  for y = 0, YCount - 1 do
    for x = 0, XCount - 1 do
      local i = y * (XCount + 1) + x
      table.insert(Triangles, i)
      table.insert(Triangles, i + XCount + 1)
      table.insert(Triangles, i + 1)
      table.insert(Triangles, i + 1)
      table.insert(Triangles, i + XCount + 1)
      table.insert(Triangles, i + XCount + 2)
    end
  end
  self.ProceduralMesh:CreateMeshSection_LinearColor(0, Vertices, Triangles, Normals, UVs, nil, nil, false)
  local DebugMat = UE4.UMaterial.Load("/Engine/EngineDebugMaterials/WireframeMaterial")
  self.ProceduralMesh:SetMaterial(0, DebugMat)
  DebugPrint(string.format("平面生成成功：%d 行 × %d 列，共 %d 面（三角数 %d）", YCount, XCount, XCount * YCount, #Triangles / 3))
end

return M
