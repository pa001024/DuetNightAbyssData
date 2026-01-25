local Component = {}

local function ScreenPrint()
  return DebugPrint
end

function Component:normalizeAngle(angle)
  angle = angle % 360
  if angle < 0 then
    angle = angle + 360
  end
  return angle
end

function Component:shortestPath(from, to)
  from = self:normalizeAngle(from)
  to = self:normalizeAngle(to)
  local diff = to - from
  if math.abs(diff) > 180 then
    if diff > 0 then
      diff = diff - 360
    else
      diff = diff + 360
    end
  end
  return from + diff
end

function Component:luaSmoothAngle(currentAngle, targetAngle, deltaTime, speed, bIsDay)
  local effectiveTarget = self:shortestPath(currentAngle, targetAngle)
  local newAngle = self:luaInterpTo(currentAngle, effectiveTarget, deltaTime, speed)
  local isStillSmoothing = not self:luaIsNearlyEqual(newAngle, effectiveTarget, 0.1)
  newAngle = self:normalizeAngle(newAngle)
  if isStillSmoothing or math.abs(newAngle - currentAngle) > 0.01 then
    if bIsDay then
      self:SetDayAngle(newAngle)
    else
      self:SetHourAngle(newAngle)
    end
  end
  if not isStillSmoothing then
    newAngle = self:normalizeAngle(targetAngle)
  end
  ScreenPrint("luaSmoothAngle: " .. newAngle .. "→" .. targetAngle)
  return newAngle, isStillSmoothing
end

function Component:luaInterpTo(Current, Target, DeltaTime, Speed)
  local effectiveTarget = self:shortestPath(Current, Target)
  if math.abs(Current - effectiveTarget) < 0.01 then
    return self:normalizeAngle(Target)
  end
  local InterpFactor = 1 - math.exp(-Speed * DeltaTime)
  return Current + (effectiveTarget - Current) * InterpFactor
end

function Component:luaIsNearlyEqual(A, B, Epsilon)
  Epsilon = Epsilon or 0.1
  return Epsilon > math.abs(A - B)
end

function Component:luaClamp(Value, Min, Max)
  return math.max(Min, math.min(Value, Max))
end

function Component:SmoothUpdate(bIsDayList, targetAngle)
  if bIsDayList then
    self.TargetDayAngle = targetAngle
    self.bIsSmoothingDay = true
  else
    self.TargetHourAngle = targetAngle
    self.bIsSmoothingHour = true
  end
end

function Component:Tick(MyGeometry, InDeltaTime)
  if self.bIsSmoothingDay then
    self.CurrentDayAngle, self.bIsSmoothingDay = self:luaSmoothAngle(self.CurrentDayAngle, self.TargetDayAngle, InDeltaTime, self.SmoothBaseSpeed, true)
  end
  if self.bIsSmoothingHour then
    self.CurrentHourAngle, self.bIsSmoothingHour = self:luaSmoothAngle(self.CurrentHourAngle, self.TargetHourAngle, InDeltaTime, self.SmoothBaseSpeed, false)
  end
  if self.bEnableTimeFlow then
    self:TimeFlowTick(InDeltaTime)
  end
end

function Component:TimeFlowTick(DeltaTime)
  if self.TimeFlowCurrentHour and self.TimeFlowTargetHour then
    local diff = self.TimeFlowTargetHour - self.TimeFlowCurrentHour
    if math.abs(diff) < 0.001 then
      self.bEnableTimeFlow = false
      self.TimeFlowCurrentHour = self.TimeFlowTargetHour
    else
      local delta = diff * DeltaTime * self.TimeFlowSpeed
      self.TimeFlowCurrentHour = self.TimeFlowCurrentHour + delta
      if diff > 0 and self.TimeFlowCurrentHour > self.TimeFlowTargetHour or diff < 0 and self.TimeFlowCurrentHour < self.TimeFlowTargetHour then
        self.TimeFlowCurrentHour = self.TimeFlowTargetHour
      end
    end
    if self.Text_TimeBlack then
      local hours = math.floor(self.TimeFlowCurrentHour)
      local minutes = math.floor((self.TimeFlowCurrentHour - hours) * 60)
      if 0 == hours then
        hours = 24
      end
      local formattedTime = string.format("%d:%02d", hours, minutes)
      self.Text_TimeBlack:SetText(formattedTime)
    end
  end
end

function Component:StartTimeFlow(CurrentHour, TargetHour, DeltaTime)
  self.TimeFlowCurrentHour = CurrentHour
  self.TimeFlowTargetHour = TargetHour
  self.TimeFlowSpeed = 1.0 / DeltaTime
  self.bEnableTimeFlow = true
  if not self.Text_TimeBlack then
    print("Warning: Text_TimeBlack not found")
  end
end

return Component
