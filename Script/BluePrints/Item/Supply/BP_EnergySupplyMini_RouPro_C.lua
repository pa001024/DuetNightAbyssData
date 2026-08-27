local BP_EnergySupplyMini_RouPro_C = Class({
  "BluePrints.Item.Supply.BP_EnergySupplyMini_C"
})
local DEFAULT_ROUPRO_RADIUS = 5000
local DEFAULT_ROUPRO_GUIDE_RADIUS = 1000

function BP_EnergySupplyMini_RouPro_C:CommonInitInfo(Info)
  BP_EnergySupplyMini_RouPro_C.Super.CommonInitInfo(self, Info)
  self.Radius = self.UnitParams.Radius or self.RouProRadius or DEFAULT_ROUPRO_RADIUS
  self.GuideRadius = self.UnitParams.GuideRadius or self.RouProGuideRadius or DEFAULT_ROUPRO_GUIDE_RADIUS
  if self.SphereCollision then
    self.SphereCollision:SetSphereRadius(self.Radius, true)
  end
end

function BP_EnergySupplyMini_RouPro_C:OutRecover_Lua(Monster)
  if not IsValid(Monster) or not Monster:IsMonster() then
    return
  end
  if Monster.EnergySupplyCheck == nil then
    Monster.EnergySupplyCheck = 1
  elseif Monster.EnergySupplyCheck ~= nil and -1 ~= Monster.EnergySupplyCheck then
    Monster.EnergySupplyCheck = Monster.EnergySupplyCheck + 1
  end
  local DisX = Monster:K2_GetActorLocation().X - self:K2_GetActorLocation().X
  local DisY = Monster:K2_GetActorLocation().Y - self:K2_GetActorLocation().Y
  local Dis = math.sqrt(DisX * DisX + DisY * DisY)
  if Dis < self.Radius then
    if IsAuthority(self) and self:CheckCanChangeEnergy() then
      local SeqFilterTag = {"Mon.Strong"}
      if Monster:HasAnyTags_Table(Monster, SeqFilterTag, false) then
        self:ChangeEnergy(self.EliteEnergy, true)
      else
        self:ChangeEnergy(self.NormalEnergy, true)
      end
    end
    if self:CheckCanChangeEnergy() and (not IsAuthority(self) or IsStandAlone(self)) then
      local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
      local MonsterLoc = Monster.Mesh:K2_GetComponentLocation()
      local MonsterRot = Monster.Mesh:K2_GetComponentRotation()
      local FXID = DataMgr.VFX_CommonSet[2].EffectId[1]
      local FXObject = Player.FXComponent:PlayEffectByIDParams(FXID, {
        UseAbsoluteLocation = true,
        Location = {
          MonsterLoc.X,
          MonsterLoc.Y,
          MonsterLoc.Z + Monster.OriginHalfHeight
        },
        Rotation = {
          MonsterRot.Pitch,
          MonsterRot.Yaw,
          MonsterRot.Roll
        }
      })
      if FXObject then
        self:OnFxObjectCreated(FXObject)
        UE4.UNiagaraFunctionLibrary.OverrideSystemUserVariableSkeletalMeshComponent(FXObject, "Skeletal Mesh", Monster.Mesh)
        FXObject:SetNiagaraVariableVec3("AttarctionPosition", self.AttarctionPosition:K2_GetComponentLocation())
      end
    end
    Monster.EnergySupplyCheck = -1
  end
end

return BP_EnergySupplyMini_RouPro_C
