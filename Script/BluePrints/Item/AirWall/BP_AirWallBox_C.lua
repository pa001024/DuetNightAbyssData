require("UnLua")
local BP_AirWallBox_C = Class({
  "BluePrints.Item.BP_CombatItemBase_C"
})

function BP_AirWallBox_C:ReceiveBeginPlay()
  BP_AirWallBox_C.Super.ReceiveBeginPlay(self)
  EventManager:AddEvent(EventID.OnLevelDeliverBlackCurtainEnd, self, self.CloseLoading)
  EventManager:AddEvent(EventID.CloseLoading, self, self.CloseLoading)
end

function BP_AirWallBox_C:ReceiveEndPlay()
  EventManager:RemoveEvent(EventID.OnLevelDeliverBlackCurtainEnd, self)
  EventManager:RemoveEvent(EventID.CloseLoading, self)
end

function BP_AirWallBox_C:AuthorityInitInfo(Info)
  BP_AirWallBox_C.Super.AuthorityInitInfo(self, Info)
  if not self.BpBorn then
    self:SetBoxExtent(Info.Creator.TriggerBoxContent, Info.Creator.TriggerTipsBoxContent)
  end
end

function BP_AirWallBox_C:CommonInitInfo(Info)
  BP_AirWallBox_C.Super.CommonInitInfo(self, Info)
  local DynamicEffectId = self.UnitParams.DynamicEffectId
  local ConstantEffectId = self.UnitParams.ConstantEffectId
  if not DynamicEffectId or not ConstantEffectId then
    return
  end
  local DynamicEffect = DataMgr.VisualEffect[DynamicEffectId].EffectParam.color
  local ConstantEffect = DataMgr.VisualEffect[ConstantEffectId].EffectParam.color
  local DynamicColor = FLinearColor(DynamicEffect[1], DynamicEffect[2], DynamicEffect[3], DynamicEffect[4])
  self.ApproachEffect:GetMaterials():GetRef(1):SetVectorParameterValue("Color", DynamicColor)
  local ConstantColor = FLinearColor(ConstantEffect[1], ConstantEffect[2], ConstantEffect[3], ConstantEffect[4])
  self.ResidentEffect:GetMaterials():GetRef(1):SetVectorParameterValue("MainTexColor", ConstantColor)
end

function BP_AirWallBox_C:SetBoxExtent_Multicast(Size)
  local targetVector = FVector(0, 0, 0)
  if nil ~= Size then
    targetVector.X = self:GetScale(Size.X)
    targetVector.Y = self:GetScale(Size.Y)
    targetVector.Z = self:GetScale(Size.Z) / 2
  end
  if 2 == self.Type then
    targetVector.Z = self:GetScale(Size.Z)
  else
    targetVector.Z = self:GetScale(Size.Z) / 2
  end
  self:SetActorScale(targetVector)
  if self.EMAutoGenerateModifier then
    self.EMAutoGenerateModifier:SpawnAllModifiers()
  end
end

function BP_AirWallBox_C:GetScale(Length)
  if Length < 0 then
    Length = 0
  else
    Length = Length / 100
  end
  return Length
end

function BP_AirWallBox_C:CloseLoading()
  if self.EMAutoGenerateModifier then
    self:AddTimer(1.5, function()
      self.EMAutoGenerateModifier:RefreshNavmodifier()
    end)
  end
end

return BP_AirWallBox_C
