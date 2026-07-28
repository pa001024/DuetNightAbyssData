local EPanelState = require("BluePrints.UI.WBP.Investigation.InvestigationUtils").EPanelState
local RotateSpeed = 0.15
local ObservationInputComponent = {}

function ObservationInputComponent:InitObservationInput()
  self.bRotating = false
  self.LastMousePos = nil
end

function ObservationInputComponent:BeginRotate()
  self.bRotating = true
  self.LastMousePos = nil
end

function ObservationInputComponent:ProcessRotateInput(DX, DY)
  if not IsValid(self.ObserverCamera) then
    return
  end
  if self.PanelState ~= EPanelState.Normal and self.PanelState ~= EPanelState.Completed then
    return
  end
  local CurrentRotation = self.ObserverCamera:K2_GetActorRotation()
  local DestPitch = CurrentRotation.Pitch + DY * RotateSpeed
  DestPitch = math.clamp(DestPitch, -89, 89)
  local DestYaw = CurrentRotation.Yaw + DX * RotateSpeed
  local NewRotation = FRotator(DestPitch, DestYaw, 0)
  self.ObserverCamera:K2_SetActorRotation(NewRotation, false)
end

function ObservationInputComponent:EndRotate()
  self.bRotating = false
  self.LastMousePos = nil
end

return ObservationInputComponent
