require("UnLua")
local M = Class({
  "BluePrints.Item.BP_CombatItemBase_C",
  "BluePrints.Common.TimerMgr"
})

function M:ReceiveBeginPlay()
  M.Super.ReceiveBeginPlay(self)
  self.TeleportingPlayers = {}
  self.PlayerCooldowns = {}
  self.AllTriggerBoxes = {}
  self:CollectTriggerBoxes()
  self:BindTriggerBoxes()
  self.AllTeleportTargets = {}
  self:CollectTeleportTargets()
end

local function NormalizeCompName(Comp)
  local name = Comp and Comp.GetName and Comp:GetName() or ""
  return (string.gsub(name, "_GEN_VARIABLE$", ""))
end

local function IsTriggerCompName(name)
  return "TriggerBox" == name or "TriggerSphere" == name or string.match(name, "^TriggerBox_%d+$") ~= nil or nil ~= string.match(name, "^TriggerSphere_%d+$")
end

local function IsTeleportPointName(name)
  return "TeleportPoint" == name or string.match(name, "^TeleportPoint_%d+$") ~= nil
end

local function ForEachComponent(CompArray, Callback)
  if not CompArray then
    return
  end
  if CompArray.Length then
    for i = 1, CompArray:Length() do
      Callback(CompArray[i])
    end
  else
    for _, Comp in pairs(CompArray) do
      Callback(Comp)
    end
  end
end

function M:CollectTriggerBoxes()
  local seen = {}
  
  local function TryAdd(Comp)
    if not IsValid(Comp) or seen[Comp] then
      return
    end
    if not IsTriggerCompName(NormalizeCompName(Comp)) then
      return
    end
    seen[Comp] = true
    table.insert(self.AllTriggerBoxes, Comp)
  end
  
  ForEachComponent(self:K2_GetComponentsByClass(UE4.UBoxComponent), TryAdd)
  ForEachComponent(self:K2_GetComponentsByClass(UE4.USphereComponent), TryAdd)
end

function M:BindTriggerBoxes()
  for _, comp in ipairs(self.AllTriggerBoxes) do
    comp.OnComponentBeginOverlap:Add(self, self.OnTriggerEnter)
  end
end

function M:UnbindTriggerBoxes()
  for _, comp in ipairs(self.AllTriggerBoxes) do
    if IsValid(comp) then
      comp.OnComponentBeginOverlap:Clear()
    end
  end
end

function M:CollectTeleportTargets()
  local seen = {}
  
  local function TryAdd(Comp)
    if not IsValid(Comp) or seen[Comp] then
      return
    end
    if not IsTeleportPointName(NormalizeCompName(Comp)) then
      return
    end
    seen[Comp] = true
    table.insert(self.AllTeleportTargets, Comp)
  end
  
  ForEachComponent(self:K2_GetComponentsByClass(UE4.USceneComponent), TryAdd)
end

function M:GetAllPlayerCharacters()
  local World = self.GetWorld and self:GetWorld() or UE4.UGameplayStatics.GetWorld(self)
  if not World then
    return {}
  end
  local PCs = {}
  local Actors = UE4.UGameplayStatics.GetAllActorsOfClass(World, UE4.APlayerCharacter)
  if Actors then
    for i = 1, Actors:Length() do
      local Actor = Actors:GetRef(i)
      if Actor then
        table.insert(PCs, Actor)
      end
    end
  end
  return PCs
end

function M:OnTriggerEnter(Comp, OtherActor, OtherComp, OtherBodyIndex, bFromSweep, SweepResult)
  if not self.bCanTrigger then
    return
  end
  if not OtherActor:IsPlayer() then
    return
  end
  if 0 == #self.AllTeleportTargets then
    return
  end
  if self.TeleportingPlayers[OtherActor.Eid] then
    return
  end
  if self.PlayerCooldowns[OtherActor.Eid] then
    return
  end
  self.TeleportingPlayers[OtherActor.Eid] = true
  self:StartTeleportSequence(OtherActor)
end

function M:StartTeleportSequence(Player)
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  if not UIManager then
    self.TeleportingPlayers[Player.Eid] = nil
    return
  end
  local inputTag = "TPMech_" .. tostring(self.Eid)
  Player:AddDisableInputTag(inputTag)
  local rawText = (self.UnitParams or {}).BlackScreenText or ""
  local fadeIn = self.FadeInTime or 0.5
  local fadeOut = self.FadeOutTime or 0.5
  local hold = self.HoldBlackTime or 1.0
  local handle = "TPMech_" .. tostring(self.Eid)
  local displayText = ""
  if "" ~= rawText then
    displayText = GText(rawText)
  end
  UIManager:ShowCommonBlackScreen({
    BlackScreenHandle = handle,
    BlackScreenText = displayText,
    InAnimationPlayTime = fadeIn,
    InAnimationObj = self,
    InAnimationCallback = function()
      if not IsValid(self) or not IsValid(Player) then
        return
      end
      self:ExecuteTeleport(Player)
      if IsValid(self) then
        self:AddTimer(hold, function()
          if not IsValid(self) then
            return
          end
          local mgr = GWorld.GameInstance:GetGameUIManager()
          if mgr then
            mgr:HideCommonBlackScreen(handle)
          end
        end, false, 0, "TPMech_Hide_" .. tostring(self.Eid))
      end
    end,
    OutAnimationPlayTime = fadeOut,
    OutAnimationObj = self,
    OutAnimationCallback = function()
      if IsValid(Player) then
        Player:RemoveDisableInputTag(inputTag)
      end
      if not IsValid(self) then
        return
      end
      self.TeleportingPlayers[Player.Eid] = nil
      self:StartCooldown(Player)
    end
  })
end

function M:ExecuteTeleport(Player)
  local playerLoc = Player:K2_GetActorLocation()
  local nearest = self:FindNearestTarget(playerLoc)
  if not nearest then
    return
  end
  local targetLoc = nearest:K2_GetComponentLocation()
  local targetRot = nearest:K2_GetComponentRotation()
  Player:K2_SetActorLocation(targetLoc, false, nil, false)
  Player:K2_SetActorRotation(targetRot, false)
  local Controller = Player:GetController()
  if Controller then
    Controller:SetControlRotation(targetRot)
  end
  Player:ResetIdle()
end

function M:FindNearestTarget(playerLoc)
  local minDistSq = math.huge
  local nearest
  for _, target in ipairs(self.AllTeleportTargets) do
    if IsValid(target) then
      local targetLoc = target:K2_GetComponentLocation()
      local dx = playerLoc.X - targetLoc.X
      local dy = playerLoc.Y - targetLoc.Y
      local dz = playerLoc.Z - targetLoc.Z
      local distSq = dx * dx + dy * dy + dz * dz
      if minDistSq > distSq then
        minDistSq = distSq
        nearest = target
      end
    end
  end
  return nearest
end

function M:StartCooldown(Player)
  local cd = self.TeleportCooldown or 2.0
  if cd <= 0 then
    return
  end
  self.PlayerCooldowns[Player.Eid] = true
  self:AddTimer(cd, function()
    if not IsValid(self) then
      return
    end
    self.PlayerCooldowns[Player.Eid] = nil
  end, false, 0, "TPMech_CD_" .. tostring(self.Eid) .. "_" .. tostring(Player.Eid))
end

function M:ReceiveEndPlay(Reason)
  local inputTag = "TPMech_" .. tostring(self.Eid)
  for _, Player in ipairs(self:GetAllPlayerCharacters()) do
    if Player.DisableInputTags and Player.DisableInputTags:Find(inputTag) then
      Player:RemoveDisableInputTag(inputTag)
    end
  end
  self:UnbindTriggerBoxes()
  self.AllTriggerBoxes = {}
  self.AllTeleportTargets = {}
  self.PlayerCooldowns = {}
  self.TeleportingPlayers = {}
  M.Super.ReceiveEndPlay(self, Reason)
end

return M
