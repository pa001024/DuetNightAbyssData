local RougeProContract = DungeonClass.Class()

function RougeProContract:BeginPlay()
  self:InitReplicatedProperties(self, "Contract", {}, "OnRep_Contract")
  self.bCanSelectContract = false
end

function RougeProContract:GetRougeProContract()
  local Contract = 0
  for AvatarEid, Player in self:PlayerIterator() do
    local PlayerCrossAttr = self:GetAvatarCrossAttr(AvatarEid)
    if PlayerCrossAttr and PlayerCrossAttr.RougePro and PlayerCrossAttr.RougePro.Contract then
      Contract = math.max(Contract, PlayerCrossAttr.RougePro.Contract)
    end
  end
  return Contract
end

function RougeProContract:ApplyRougeProContract()
  local ContractValue = self:GetRougeProContract()
  print(string.format("DungeonInstance Contract Value = %s", tostring(ContractValue)))
  for _, tabRougePro_Contract in pairs(DataMgr.RougeProContract) do
    if tabRougePro_Contract.StartHeat and ContractValue >= tabRougePro_Contract.StartHeat then
      table.insert(self.Contract, tabRougePro_Contract.Id)
    end
  end
  self.Contract = self.Contract
  for i = 1, #self.Contract do
    self:RealEffectContract(self.Contract[i])
  end
end

function RougeProContract:RealEffectContract(Id)
  print(string.format("RougeProContract:RealEffectContract(Id=%s)", tostring(Id)))
  local tabRougePro_Contract = DataMgr.RougeProContract[Id]
  if nil == tabRougePro_Contract then
    return
  end
  if tabRougePro_Contract.Effect then
    self:ActivateRougeProEffects(self, tabRougePro_Contract.Effect)
  end
end

return RougeProContract
