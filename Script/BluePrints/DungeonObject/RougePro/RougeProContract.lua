local RougeProContract = DungeonClass.Class()

function RougeProContract:BeginPlay()
  self:InitReplicatedProperties(self, "Contract", {}, "OnRep_Contract")
  self.bCanSelectContract = false
end

function RougeProContract:StartContractSelect()
  self:NotifyGameModeDungeonEvent("OnStartContractSelect")
  self.bCanSelectContract = true
end

function RougeProContract:OnNotifyServerDungeonEvent_OnSelectContract(Id, Level)
  if not self.bCanSelectContract then
    return ErrorCode.RET_ROUGEPRO_CANNOT_SELECT_CONTRACT
  end
  local Info = DataMgr.RougeProContract[Id]
  if not Info then
    return ErrorCode.RET_ROUGEPRO_CONTRACT_NOT_EXIST
  end
  local MaxLevel = Info.MaxLevel
  if Level > MaxLevel then
    return ErrorCode.RET_ROUGEPRO_CONTRACT_LEVEL_NOT_VALID
  end
  local CurLevel = self.Contract[Id]
  self.Contract[Id] = Level > 0 and (not CurLevel or Level ~= CurLevel) and Level or nil
  if CurLevel ~= self.Contract[Id] then
    self.Contract = self.Contract
  end
end

function RougeProContract:OnNotifyServerDungeonEvent_OnEnsureContract()
  self.bCanSelectContract = false
  self:RealEffectContract()
end

function RougeProContract:RealEffectContract()
  for Id, Level in pairs(self.Contract) do
    local Info = DataMgr.RougeProContract[Id]
    local Effect = Info.Effect
    self:ActivateRougeProEffects(self, Effect)
  end
end

return RougeProContract
