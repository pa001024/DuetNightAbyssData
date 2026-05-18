local BP_SoloTreasureContainer = Class("BluePrints.Item.Chest.BP_MechanismBase_C")

function BP_SoloTreasureContainer:GetShowTagNew()
  if self.bLocalOpened then
    return false
  end
  if not self.DungeonObject then
    self.DungeonObject = GWorld:GetGameModeDungeonObject()
  end
  if self.DungeonObject then
    local MechanismEntity = self.DungeonObject:GetCachedMechanismInfo(self.ServerUniqueId)
    if MechanismEntity and MechanismEntity.bDropMechanism and MechanismEntity.OpenTimeStamp and -1 == MechanismEntity.OpenTimeStamp then
      return true
    end
  end
  return false
end

function BP_SoloTreasureContainer:GetInteractivePriority()
  if self.bLocalOpened then
    return -1
  end
  return nil
end

function BP_SoloTreasureContainer:GetCanOpen(PlayerEid)
  self.CanOpen = true
end

function BP_SoloTreasureContainer:OpenMechanism(PlayerId)
  DebugPrint("gmy@BP_SoloTreasureContainer BP_SoloTreasureContainer:OpenMechanism", PlayerId, "ServerUniqueId", self.ServerUniqueId)
  local DungeonObject = GWorld:GetGameModeDungeonObject()
  if DungeonObject then
    local MechanismEntity = DungeonObject:GetCachedMechanismInfo(self.ServerUniqueId)
    if MechanismEntity and MechanismEntity.OpenTimeStamp and -1 == MechanismEntity.OpenTimeStamp then
      self:OnFirstTimeOpen(PlayerId, MechanismEntity)
    end
  end
  self:RealOpenMechanism()
end

function BP_SoloTreasureContainer:RealOpenMechanism()
  local NowMs = os.clock() * 1000
  if self.OpenMechanismCooldownEndMs and NowMs < self.OpenMechanismCooldownEndMs then
    return
  end
  self.OpenMechanismCooldownEndMs = NowMs + 1000
  if not self.ServerUniqueId then
    return
  end
  if not self.GameMode then
    self.GameMode = UE4.UGameplayStatics.GetGameMode(self)
  end
  if not self.GameMode then
    return
  end
  self.bLocalOpened = true
  self.GameMode:NotifyServerDungeonEvent("OpenSoloTreasureMechanism", self.ServerUniqueId)
  UIManager(self):LoadUINew("SoloTreasureBag", self.ServerUniqueId, function()
    DebugPrint("lgc@ SoloTreasureBag AsyncLoaded self.ServerUniqueId =", self.ServerUniqueId)
  end, "Async")
end

return BP_SoloTreasureContainer
