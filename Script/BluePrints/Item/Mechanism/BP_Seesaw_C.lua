local M = Class()

function M:ReceiveBeginPlay()
  self.Overridden.ReceiveBeginPlay(self)
  if self.Box1 and IsValid(self.Box1) then
    self.Box1.OnComponentBeginOverlap:Add(self, self.OnBox1ComponentBeginOverlap)
    self.Box1.OnComponentEndOverlap:Add(self, self.OnBox1ComponentEndOverlap)
  end
  if self.Box2 and IsValid(self.Box2) then
    self.Box2.OnComponentBeginOverlap:Add(self, self.OnBox2ComponentBeginOverlap)
    self.Box2.OnComponentEndOverlap:Add(self, self.OnBox2ComponentEndOverlap)
  end
  self.AreaOccupy = Const.AreaOccupyEnum.None
  self.CurRotAngle = self.InitRotationAngle or 0
  self.RotAxis = self.RotationAxis
  if self.RotAxis ~= "X" and self.RotAxis ~= "Y" and self.RotAxis ~= "Z" then
    GWorld.logger.error("BP_SeeSaw ReceiveTick error RotAxis!")
    return
  end
  local InitDeltaAngle = 0
  if self.RotAxis == "X" then
    InitDeltaAngle = self.Mesh.RelativeRotation.Roll
    self.Mesh:K2_AddRelativeRotation(FRotator(0, 0, self.InitRotationAngle - InitDeltaAngle), false, nil, false)
  elseif self.RotAxis == "Y" then
    InitDeltaAngle = self.Mesh.RelativeRotation.Pitch
    self.Mesh:K2_AddRelativeRotation(FRotator(self.InitRotationAngle - InitDeltaAngle, 0, 0), false, nil, false)
  elseif self.RotAxis == "Z" then
    InitDeltaAngle = self.Mesh.RelativeRotation.Yaw
    self.Mesh:K2_AddRelativeRotation(FRotator(0, self.InitRotationAngle - InitDeltaAngle, 0), false, nil, false)
  end
end

function M:ReceiveTick(DeltaSeconds)
  if self.AreaOccupy == Const.AreaOccupyEnum.None then
    return
  end
  local tmpDeltaRot = self.RotSpeed * DeltaSeconds
  if self.AreaOccupy == Const.AreaOccupyEnum.Box1 then
    if self.CurRotAngle + tmpDeltaRot > self.MaxRotAngle then
      self.CurDeltaRotation = self.MaxRotAngle - self.CurRotAngle
    else
      self.CurDeltaRotation = tmpDeltaRot
    end
    self.CurRotAngle = self.CurRotAngle + self.CurDeltaRotation
    if self.RotAxis == "X" then
      self.Mesh:K2_AddRelativeRotation(FRotator(0, 0, self.CurDeltaRotation), false, nil, false)
    elseif self.RotAxis == "Y" then
      self.Mesh:K2_AddRelativeRotation(FRotator(self.CurDeltaRotation, 0, 0), false, nil, false)
    elseif self.RotAxis == "Z" then
      self.Mesh:K2_AddRelativeRotation(FRotator(0, self.CurDeltaRotation, 0), false, nil, false)
    end
  else
    if self.CurRotAngle - tmpDeltaRot < -1 * self.MaxRotAngle then
      self.CurDeltaRotation = -1 * self.MaxRotAngle - self.CurRotAngle
    else
      self.CurDeltaRotation = -1 * tmpDeltaRot
    end
    self.CurRotAngle = self.CurRotAngle + self.CurDeltaRotation
    if self.RotAxis == "X" then
      self.Mesh:K2_AddRelativeRotation(FRotator(0, 0, self.CurDeltaRotation), false, nil, false)
    elseif self.RotAxis == "Y" then
      self.Mesh:K2_AddRelativeRotation(FRotator(self.CurDeltaRotation, 0, 0), false, nil, false)
    elseif self.RotAxis == "Z" then
      self.Mesh:K2_AddRelativeRotation(FRotator(0, self.CurDeltaRotation, 0), false, nil, false)
    end
  end
end

function M:OnBox1ComponentBeginOverlap(Comp, OtherActor, OtherComp, OtherBodyIndex, bFromSweep, SweepResult)
  if not OtherActor:IsPlayer() then
    return
  end
  DebugPrint("yly BP_Seesaw_C:OnBox1ComponentBeginOverlap")
  self.AreaOccupy = Const.AreaOccupyEnum.Box1
end

function M:OnBox1ComponentEndOverlap(Comp, OtherActor, OtherComp, OtherBodyIndex)
  if not OtherActor:IsPlayer() then
    return
  end
  DebugPrint("yly BP_Seesaw_C:OnBox1ComponentEndOverlap")
  self.AreaOccupy = Const.AreaOccupyEnum.None
end

function M:OnBox2ComponentBeginOverlap(Comp, OtherActor, OtherComp, OtherBodyIndex, bFromSweep, SweepResult)
  if not OtherActor:IsPlayer() then
    return
  end
  DebugPrint("yly BP_Seesaw_C:OnBox2ComponentBeginOverlap")
  self.AreaOccupy = Const.AreaOccupyEnum.Box2
end

function M:OnBox2ComponentEndOverlap(Comp, OtherActor, OtherComp, OtherBodyIndex)
  if not OtherActor:IsPlayer() then
    return
  end
  DebugPrint("yly BP_Seesaw_C:OnBox2ComponentEndOverlap")
  self.AreaOccupy = Const.AreaOccupyEnum.None
end

function M:ReceiveEndPlay(Reason)
  self.Overridden.ReceiveEndPlay(self, Reason)
  if self.Box1 and IsValid(self.Box1) then
    self.Box1.OnComponentBeginOverlap:Clear()
    self.Box1.OnComponentEndOverlap:Clear()
  end
  if self.Box2 and IsValid(self.Box2) then
    self.Box2.OnComponentBeginOverlap:Clear()
    self.Box2.OnComponentEndOverlap:Clear()
  end
end

return M
