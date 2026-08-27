require("UnLua")
local BP_SlideTarget_KepDis_C = Class({
  "BluePrints/Item/CombatProp/BP_CombatPropBase_C"
})

function BP_SlideTarget_KepDis_C:ReceiveBeginPlay()
  BP_SlideTarget_KepDis_C.Super.ReceiveBeginPlay(self)
  if IsValid(self.SlideTargetKepDisMove) then
    self.SlideTargetKepDisMove:InitComponent(self.RelativeDistance)
  end
end

function BP_SlideTarget_KepDis_C:StartMove()
  if IsValid(self.SlideTargetKepDisMove) then
    self.SlideTargetKepDisMove:StartMove()
  end
end

function BP_SlideTarget_KepDis_C:StopMove()
  if IsValid(self.SlideTargetKepDisMove) then
    self.SlideTargetKepDisMove:StopMove()
  end
end

function BP_SlideTarget_KepDis_C:SpawnSkillMechanism(Index, UnitId, NeedAttach)
  DebugPrint("SpawnSkillMechanism Index:", Index, "UnitId:", UnitId)
  if not IsAuthority(self) then
    return
  end
  local PosComp = self["Pos" .. Index]
  if not IsValid(PosComp) then
    DebugPrint("SpawnKillMechanism 找不到点位组件 Pos" .. tostring(Index))
    return
  end
  local ArrowComp = self["Arrow" .. Index]
  if not IsValid(ArrowComp) then
    DebugPrint("SpawnKillMechanism 找不到箭头组件 Arrow" .. tostring(Index))
    return
  end
  if not DataMgr.Mechanism[UnitId] then
    DebugPrint("SpawnKillMechanism 找不到机关配置 UnitId = " .. tostring(UnitId))
    return
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  local Context = AEventMgr.CreateUnitContext()
  Context.UnitType = "Mechanism"
  Context.UnitId = UnitId
  Context.Loc = PosComp:K2_GetComponentLocation()
  Context.Rotation = ArrowComp:K2_GetComponentRotation()
  Context.DirectSource = self
  Context.BoolParams:Add("NeedAttach", NeedAttach)
  Context.IntParams:Add("PosIndex", Index)
  Context.IntParams:Add("RegionDataType", 0)
  GameMode.EMGameState.EventMgr:CreateUnitNew(Context, false)
end

function BP_SlideTarget_KepDis_C:ActiveCombat()
  self.Super.ActiveCombat(self)
  self:StartMove()
end

function BP_SlideTarget_KepDis_C:DeActiveCombat()
  self.Super.DeActiveCombat(self)
  self:StopMove()
end

return BP_SlideTarget_KepDis_C
