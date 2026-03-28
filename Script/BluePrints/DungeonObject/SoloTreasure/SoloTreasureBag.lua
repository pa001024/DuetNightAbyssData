local SoloTreasureBag = DungeonClass.Class()

function SoloTreasureBag:Init(sizeX, sizeY)
  self.SizeX = sizeX
  self.SizeY = sizeY
  self.SlotDict = {}
end

function SoloTreasureBag:GetPos(x, y)
  return (y - 1) * self.SizeX + x
end

function SoloTreasureBag:GetXY(pos)
  if self.SizeX <= 0 then
    return -1, -1
  end
  local x = (pos - 1) % self.SizeX + 1
  local y = math.floor((pos - 1) / self.SizeX) + 1
  return x, y
end

function SoloTreasureBag:CanPlacementItem(uid, sizeX, sizeY, pos, conflictlist)
  if pos <= 0 or pos > self.SizeX * self.SizeY then
    return false
  end
  local targetX, targetY = self:GetXY(pos)
  if targetX + sizeX - 1 <= 0 or targetX + sizeX - 1 > self.SizeX or targetY + sizeY <= 0 or targetY + sizeY - 1 > self.SizeY then
    return false
  end
  for _x = targetX, targetX + sizeX - 1 do
    for _y = targetY, targetY + sizeY - 1 do
      local ExistUniqueId = self.SlotDict[self:GetPos(_x, _y)]
      if ExistUniqueId and ExistUniqueId ~= uid then
        if nil == conflictlist then
          return false
        end
        if CommonUtils.HasValue(conflictlist, ExistUniqueId) == false then
          table.insert(conflictlist, ExistUniqueId)
        end
      end
    end
  end
  return true
end

function SoloTreasureBag:PlacementItem(uid, sizeX, sizeY, pos)
  if self:CanPlacementItem(uid, sizeX, sizeY, pos, nil) == false then
    return -1
  end
  local targetX, targetY = self:GetXY(pos)
  for _x = targetX, targetX + sizeX - 1 do
    for _y = targetY, targetY + sizeY - 1 do
      self.SlotDict[self:GetPos(_x, _y)] = uid
    end
  end
  return pos
end

function SoloTreasureBag:PushItem(uid, sizeX, sizeY, pos)
  pos = pos or 1
  for i = pos, self.SizeX * self.SizeY do
    local NewPos = self:PlacementItem(uid, sizeX, sizeY, i)
    if -1 ~= NewPos then
      return NewPos
    end
  end
  for i = 1, pos do
    local NewPos = self:PlacementItem(uid, sizeX, sizeY, i)
    if -1 ~= NewPos then
      return NewPos
    end
  end
  return -1
end

function SoloTreasureBag:PopItem(uid)
  for Pos = 1, self.SizeX * self.SizeY do
    if self.SlotDict[Pos] == uid then
      self.SlotDict[Pos] = nil
    end
  end
  return true
end

function SoloTreasureBag:RemoveItem(uid)
  for Pos = 1, self.SizeX * self.SizeY do
    if self.SlotDict[Pos] == uid then
      self.SlotDict[Pos] = nil
    end
  end
  return true
end

function SoloTreasureBag:MoveItem(uid, sizeX, sizeY, pos)
  if self:CanPlacementItem(uid, sizeX, sizeY, pos, nil) == false then
    return false
  end
  local targetX, targetY = self:GetXY(pos)
  for _x = targetX, targetX + sizeX - 1 do
    for _y = targetY, targetY + sizeY - 1 do
      self.SlotDict[self:GetPos(_x, _y)] = uid
    end
  end
  return true
end

return SoloTreasureBag
