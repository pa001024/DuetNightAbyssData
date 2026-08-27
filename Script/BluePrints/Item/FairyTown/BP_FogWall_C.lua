require("UnLua")
local BP_FogWall_C = Class({
  "BluePrints.Item.BP_CombatItemBase_C",
  "BluePrints.Common.TimerMgr"
})
local FX_CENTER_PATH = "/Game/Asset/Effect/Niagara/Scene/Haiboliya/Common/NS_FogWall_002.NS_FogWall_002"
local FX_FRONT_PATH = "/Game/Asset/Effect/Niagara/Scene/Haiboliya/Common/NS_FogWall_001.NS_FogWall_001"
local POINT_SIZE_MAX = 100
local CM_PER_M = 100

local function CalcPointSize(x, y, z)
  local Raw = math.abs(x) + math.abs(y) + 2 * math.abs(z)
  local Rounded = math.floor(Raw / 5 + 0.5) * 5
  return math.max(5, math.min(Rounded, POINT_SIZE_MAX))
end

local function FormatExtent(Ext)
  if not Ext then
    return "nil"
  end
  local Inner = Ext
  if type(Ext[1]) == "table" then
    Inner = Ext[1]
  end
  local x = Inner.X or Inner[1] or 0
  local y = Inner.Y or Inner[2] or 0
  local z = Inner.Z or Inner[3] or 0
  return "[" .. tostring(x) .. "," .. tostring(y) .. "," .. tostring(z) .. "]"
end

function BP_FogWall_C:ReceiveBeginPlay()
  if self.BpBorn and IsAuthority(self) and self.TryInitActorInfo then
    self:TryInitActorInfo("BeginPlay")
  end
  BP_FogWall_C.Super.ReceiveBeginPlay(self)
  GWorld.logger.info("[BP_FogWall] ReceiveBeginPlay UnitId=" .. tostring(self.UnitId) .. " ActorName=" .. tostring(self:GetName()) .. " Box_Trigger_Trans=" .. FormatExtent(self.Box_Trigger_Trans and self.Box_Trigger_Trans.BoxExtent) .. " Box_Trigger_Fog=" .. FormatExtent(self.Box_Trigger_Fog and self.Box_Trigger_Fog.BoxExtent) .. " ActorLocation=" .. FormatExtent(self:K2_GetActorLocation()))
end

function BP_FogWall_C:ReceiveEndPlay()
  GWorld.logger.info("[BP_FogWall] ReceiveEndPlay 机关销毁, UnitId=" .. tostring(self.UnitId))
  self:StopFogTimer()
  if self._FogAffectedActors then
    for Actor, _ in pairs(self._FogAffectedActors) do
      if self._FogBaseMatMap and self._FogBaseMatMap[Actor] then
        local BaseMat = self._FogBaseMatMap[Actor]
        if Actor and Actor.RemoveBlendableMaterial then
          Actor:RemoveBlendableMaterial(BaseMat)
        end
      end
    end
    self._FogAffectedActors = nil
  end
  self._FogMIDMap = nil
  self._FogCameraComp = nil
  self._FogBaseMatMap = nil
  BP_FogWall_C.Super.ReceiveEndPlay(self)
end

function BP_FogWall_C:CommonInitInfo(Info)
  BP_FogWall_C.Super.CommonInitInfo(self, Info)
  self:SpawnFogWallEffects(Info)
  self:BindFogTriggerOverlaps()
end

function BP_FogWall_C:BindFogTriggerOverlaps()
  if not self.Box_Trigger_Fog then
    GWorld.logger.errorlog("[BP_FogWall] BindFogTriggerOverlaps 失败: Box_Trigger_Fog为空 UnitId=" .. tostring(self.UnitId))
    return
  end
  if self._FogOverlapBound then
    return
  end
  if self.Box_Trigger_Fog.SetGenerateOverlapEvents then
    self.Box_Trigger_Fog:SetGenerateOverlapEvents(true)
  end
  self.Box_Trigger_Fog.OnComponentBeginOverlap:Clear()
  self.Box_Trigger_Fog.OnComponentEndOverlap:Clear()
  self.Box_Trigger_Fog.OnComponentBeginOverlap:Add(self, self.OnBoxTriggerFogBeginOverlap)
  self.Box_Trigger_Fog.OnComponentEndOverlap:Add(self, self.OnBoxTriggerFogEndOverlap)
  self._FogOverlapBound = true
  GWorld.logger.info("[BP_FogWall] BindFogTriggerOverlaps 已绑定 UnitId=" .. tostring(self.UnitId))
end

function BP_FogWall_C:AuthorityInitInfo(Info)
  BP_FogWall_C.Super.AuthorityInitInfo(self, Info)
  self._MaxFogIntensity = 1.0
  GWorld.logger.info("[BP_FogWall] AuthorityInitInfo UnitParams: FogOffset=" .. tostring(self.UnitParams and self.UnitParams.FogOffset) .. " UnitId=" .. tostring(self.UnitId))
  self:SetupFogWallCollision(Info)
end

function BP_FogWall_C:ResolveTransExtent(Info)
  local Source = "fallback"
  if Info and Info.Creator and Info.Creator.TriggerBoxContent then
    local Content = Info.Creator.TriggerBoxContent
    if 0 ~= Content.X or 0 ~= Content.Y or 0 ~= Content.Z then
      Source = "TriggerBoxContent"
      GWorld.logger.info("[BP_FogWall] ResolveTransExtent 来源=" .. Source .. " Extent(cm)=" .. FormatExtent(Content) .. " UnitId=" .. tostring(self.UnitId))
      return Content
    else
      GWorld.logger.info("[BP_FogWall] ResolveTransExtent TriggerBoxContent全为0, 尝试下一来源 UnitId=" .. tostring(self.UnitId))
    end
  else
    GWorld.logger.info("[BP_FogWall] ResolveTransExtent Info.Creator.TriggerBoxContent 不存在" .. " HasInfo=" .. tostring(nil ~= Info) .. " HasCreator=" .. tostring(Info and Info.Creator ~= nil) .. " UnitId=" .. tostring(self.UnitId))
  end
  if self.Box_Trigger_Trans then
    local Ext = self.Box_Trigger_Trans.BoxExtent
    Source = "Box_Trigger_Trans.BoxExtent(组件默认值)"
    GWorld.logger.info("[BP_FogWall] ResolveTransExtent 来源=" .. Source .. " Extent(cm)=" .. FormatExtent(Ext) .. " UnitId=" .. tostring(self.UnitId))
    return Ext
  end
  GWorld.logger.info("[BP_FogWall] ResolveTransExtent 来源=fallback(100,100,100)cm Box_Trigger_Trans组件也不存在 UnitId=" .. tostring(self.UnitId))
  return FVector(100, 100, 100)
end

function BP_FogWall_C:SpawnFogWallEffects(Info)
  if self._FxSpawned then
    return
  end
  if not IsClient(self) and not IsStandAlone(self) then
    return
  end
  if not self.Box_Trigger_Trans then
    GWorld.logger.errorlog("[BP_FogWall] SpawnFogWallEffects 失败: Box_Trigger_Trans为空 UnitId=" .. tostring(self.UnitId))
    return
  end
  local TransExtent = self:ResolveTransExtent(Info)
  GWorld.logger.info("[BP_FogWall] SpawnFogWallEffects TransExtent=" .. FormatExtent(TransExtent) .. " UnitId=" .. tostring(self.UnitId))
  local FogOffset = self.UnitParams.FogOffset
  GWorld.logger.info("[BP_FogWall] SpawnFogWallEffects FogOffset(cm)=" .. tostring(FogOffset) .. " UnitId=" .. tostring(self.UnitId))
  local FogExtent
  if FogOffset and FogOffset > 0 then
    FogExtent = FVector((TransExtent.X + FogOffset) / CM_PER_M, (TransExtent.Y + FogOffset) / CM_PER_M, (TransExtent.Z + FogOffset / 2) / CM_PER_M)
    GWorld.logger.info("[BP_FogWall] SpawnFogWallEffects FogExtent(m)计算: TransExtent(cm)" .. FormatExtent(TransExtent) .. " + FogOffset(" .. tostring(FogOffset) .. "cm) /" .. tostring(CM_PER_M) .. " = " .. FormatExtent(FogExtent) .. " UnitId=" .. tostring(self.UnitId))
  else
    FogExtent = FVector(TransExtent.X / CM_PER_M, TransExtent.Y / CM_PER_M, TransExtent.Z / CM_PER_M)
    if self.Box_Trigger_Fog then
      local FogBox = self.Box_Trigger_Fog.BoxExtent
      if 0 ~= FogBox.X or 0 ~= FogBox.Y or 0 ~= FogBox.Z then
        FogExtent = FVector(FogBox.X / CM_PER_M, FogBox.Y / CM_PER_M, FogBox.Z / CM_PER_M)
        GWorld.logger.info("[BP_FogWall] SpawnFogWallEffects FogExtent回退=组件BoxExtent(cm->m) " .. FormatExtent(FogExtent) .. " UnitId=" .. tostring(self.UnitId))
      end
    end
    GWorld.logger.info("[BP_FogWall] SpawnFogWallEffects FogOffset无效, FogExtent(m)=" .. FormatExtent(FogExtent) .. " UnitId=" .. tostring(self.UnitId))
  end
  local CenterAsset = LoadObject(self.UnitParams.FogFxCenterPath or FX_CENTER_PATH)
  if CenterAsset then
    local FxCenter = UE4.UNiagaraFunctionLibrary.SpawnSystemAttached(CenterAsset, self.Box_Trigger_Trans, "", FVector(0, 0, -TransExtent.Z), UE4.FRotator(0, 0, 0), 0)
    if FxCenter then
      local SizeX = FogExtent.X
      local SizeY = FogExtent.Y
      local SizeZ = FogExtent.Z
      FxCenter:SetNiagaraVariableFloat("x", SizeX)
      FxCenter:SetNiagaraVariableFloat("y", SizeY)
      FxCenter:SetNiagaraVariableFloat("z", SizeZ)
      local PointSize = CalcPointSize(SizeX, SizeY, SizeZ)
      FxCenter:SetNiagaraVariableFloat("PointSize", PointSize)
      GWorld.logger.info("[BP_FogWall] 底部中心特效已生成 Size(m)=[" .. tostring(SizeX) .. "," .. tostring(SizeY) .. "," .. tostring(SizeZ) .. "] PointSize=" .. tostring(PointSize) .. " UnitId=" .. tostring(self.UnitId))
    end
  else
    GWorld.logger.errorlog("[BP_FogWall] 底部中心特效资产加载失败 Path=" .. tostring(self.UnitParams.FogFxCenterPath or FX_CENTER_PATH) .. " UnitId=" .. tostring(self.UnitId))
  end
  local FrontAsset = LoadObject(self.UnitParams.FogFxFrontPath or FX_FRONT_PATH)
  if FrontAsset then
    local FxFront = UE4.UNiagaraFunctionLibrary.SpawnSystemAttached(FrontAsset, self.Box_Trigger_Trans, "", FVector(TransExtent.X, 0, -TransExtent.Z), UE4.FRotator(0, 0, 0), 0)
    if FxFront then
      local PlanSize = FVector(2 * TransExtent.Y / CM_PER_M, 2 * TransExtent.Z / CM_PER_M, 0)
      FxFront:SetNiagaraVariableVec3("PlanSize", PlanSize)
      local PointSize = CalcPointSize(PlanSize.X, PlanSize.Y, PlanSize.Z)
      FxFront:SetNiagaraVariableFloat("PointSize", PointSize)
      GWorld.logger.info("[BP_FogWall] 正面特效已生成 PlanSize(m)=" .. FormatExtent(PlanSize) .. " PointSize=" .. tostring(PointSize) .. " UnitId=" .. tostring(self.UnitId))
    end
  else
    GWorld.logger.errorlog("[BP_FogWall] 正面特效资产加载失败 Path=" .. tostring(self.UnitParams.FogFxFrontPath or FX_FRONT_PATH) .. " UnitId=" .. tostring(self.UnitId))
  end
  self._FogTransExtent = FVector(TransExtent.X, TransExtent.Y, TransExtent.Z)
  self._FogOffset = FogOffset and FogOffset > 0 and FogOffset or 0
  GWorld.logger.info("[BP_FogWall] 缓存渐变参数 _FogTransExtent(cm)=" .. FormatExtent(self._FogTransExtent) .. " _FogOffset(cm)=" .. tostring(self._FogOffset) .. " UnitId=" .. tostring(self.UnitId))
  self._FxSpawned = true
end

function BP_FogWall_C:GetFogScreenMaterial()
  if not self._FogScreenMaterial then
    local MaterialPath = "/Game/Asset/Scene/common/PP/MI_PP_Misty_01.MI_PP_Misty_01"
    self._FogScreenMaterial = LoadObject(MaterialPath)
    GWorld.logger.info("[BP_FogWall] GetFogScreenMaterial LoadObject=" .. tostring(self._FogScreenMaterial) .. " UnitId=" .. tostring(self.UnitId))
  end
  return self._FogScreenMaterial
end

function BP_FogWall_C:OnBoxTriggerFogBeginOverlap(_OverlappedComponent, OtherActor, _OtherComp, _OtherBodyIndex, _bFromSweep, _SweepResult)
  GWorld.logger.info("[BP_FogWall] >>> OnBoxTriggerFogBeginOverlap OtherActor=" .. tostring(OtherActor) .. " UnitId=" .. tostring(self.UnitId))
  self:ApplyFogEffect(OtherActor)
end

function BP_FogWall_C:OnBoxTriggerFogEndOverlap(_OverlappedComponent, OtherActor, _OtherComp, _OtherBodyIndex)
  GWorld.logger.info("[BP_FogWall] >>> OnBoxTriggerFogEndOverlap OtherActor=" .. tostring(OtherActor) .. " UnitId=" .. tostring(self.UnitId))
  self:RemoveFogEffect(OtherActor)
end

function BP_FogWall_C:CalcFogIntensityForActor(Actor)
  local MaxIntensity = self._MaxFogIntensity or 1.0
  if not Actor or not self.Box_Trigger_Trans then
    return MaxIntensity, nil
  end
  local FogOffset = self._FogOffset
  local TransExtent = self._FogTransExtent
  if not FogOffset or FogOffset <= 0 or not TransExtent then
    return MaxIntensity, nil
  end
  local TransWorld = self.Box_Trigger_Trans:K2_GetComponentToWorld()
  local PlayerWorldLoc = Actor:K2_GetActorLocation()
  local PlayerLocalLoc = UE4.UKismetMathLibrary.InverseTransformLocation(TransWorld, PlayerWorldLoc)
  local ExcessX = math.max(0, math.abs(PlayerLocalLoc.X) - TransExtent.X)
  local ExcessY = math.max(0, math.abs(PlayerLocalLoc.Y) - TransExtent.Y)
  local Distance = math.sqrt(ExcessX * ExcessX + ExcessY * ExcessY)
  local t = math.max(0, math.min(1, Distance / FogOffset))
  local Intensity = MaxIntensity * (0.2 + 0.8 * (1 - t))
  return Intensity, Distance
end

function BP_FogWall_C:SetFogIntensityOnMID(MID, Intensity)
  if not MID then
    return
  end
  local paramNames = {
    "FogIntensity",
    "Intensity",
    "Opacity",
    "Fade",
    "Amount",
    "Strength",
    "Density",
    "Weight",
    "Power",
    "FogAmount",
    "FogDensity",
    "FadeAmount",
    "Blend",
    "Scale",
    "Appear"
  }
  if self.UnitParams and self.UnitParams.FogIntensityParamName then
    table.insert(paramNames, 1, self.UnitParams.FogIntensityParamName)
  end
  for _, pName in ipairs(paramNames) do
    pcall(function()
      MID:SetScalarParameterValue(pName, Intensity)
    end)
  end
end

function BP_FogWall_C:ApplyFogEffect(OtherActor)
  if not (OtherActor and OtherActor.IsPlayer) or not OtherActor:IsPlayer() then
    GWorld.logger.info("[BP_FogWall] ApplyFogEffect 跳过: 非玩家 OtherActor=" .. tostring(OtherActor) .. " HasIsPlayer=" .. tostring(nil ~= OtherActor and OtherActor.IsPlayer ~= nil) .. " UnitId=" .. tostring(self.UnitId))
    return
  end
  if not IsClient(self) and not IsStandAlone(self) then
    GWorld.logger.info("[BP_FogWall] ApplyFogEffect 跳过: 非客户端/单机 UnitId=" .. tostring(self.UnitId))
    return
  end
  GWorld.logger.info("[BP_FogWall] ApplyFogEffect 开始, Actor=" .. tostring(OtherActor) .. " UnitId=" .. tostring(self.UnitId))
  local FogMat = self:GetFogScreenMaterial()
  if not FogMat then
    GWorld.logger.errorlog("[BP_FogWall] FogMat为空, UnitId=" .. tostring(self.UnitId))
    return
  end
  if not OtherActor.AddBlendableMaterialInst and not OtherActor.AddBlendableMaterial then
    GWorld.logger.errorlog("[BP_FogWall] ApplyFogEffect 失败: Actor不支持AddBlendableMaterial UnitId=" .. tostring(self.UnitId))
    return
  end
  if OtherActor.AddBlendableMaterialInst then
    OtherActor:AddBlendableMaterialInst(FogMat, 1)
  else
    OtherActor:AddBlendableMaterial(FogMat, 1)
  end
  self._FogAffectedActors = self._FogAffectedActors or {}
  self._FogAffectedActors[OtherActor] = true
  local CameraComp = OtherActor:GetCameraComponent()
  self._FogCameraComp = self._FogCameraComp or {}
  self._FogCameraComp[OtherActor] = CameraComp
  self._FogMIDMap = self._FogMIDMap or {}
  self._FogBaseMatMap = self._FogBaseMatMap or {}
  local BaseMat = FogMat.GetBaseMaterial and FogMat:GetBaseMaterial() or FogMat
  self._FogBaseMatMap[OtherActor] = BaseMat
  local InitialIntensity, Distance = self:CalcFogIntensityForActor(OtherActor)
  if CameraComp and CameraComp.MaterialInstDynamicMaps then
    local CameraMID = CameraComp.MaterialInstDynamicMaps:Find(BaseMat)
    if CameraMID then
      self._FogMIDMap[OtherActor] = CameraMID
      self:SetFogIntensityOnMID(CameraMID, InitialIntensity)
      GWorld.logger.info("[BP_FogWall] ApplyFogEffect 初始浓度=" .. string.format("%.2f", InitialIntensity) .. " 距离=" .. tostring(Distance and string.format("%.0f", Distance) or "nil") .. " UnitId=" .. tostring(self.UnitId))
    else
      GWorld.logger.info("[BP_FogWall] ApplyFogEffect MID未找到 BaseMat=" .. tostring(BaseMat) .. " UnitId=" .. tostring(self.UnitId))
    end
  else
    GWorld.logger.info("[BP_FogWall] ApplyFogEffect CameraComp/MaterialInstDynamicMaps无效 CameraComp=" .. tostring(CameraComp) .. " UnitId=" .. tostring(self.UnitId))
  end
  if self._FogOffset and self._FogOffset > 0 and not self._FogTimerKey then
    self._FogTimerKey = "FogWall_Intensity"
    self:AddTimer(0.1, function()
      if IsValid(self) then
        self:UpdateFogIntensity()
      end
    end, true, 0.0, self._FogTimerKey)
    GWorld.logger.info("[BP_FogWall] ApplyFogEffect Timer已启动 key=" .. self._FogTimerKey .. " UnitId=" .. tostring(self.UnitId))
  else
    GWorld.logger.info("[BP_FogWall] ApplyFogEffect Timer未启动 _FogOffset=" .. tostring(self._FogOffset) .. " _FogTimerKey=" .. tostring(self._FogTimerKey) .. " UnitId=" .. tostring(self.UnitId))
  end
end

function BP_FogWall_C:UpdateFogIntensity()
  if not self._FogOffset or self._FogOffset <= 0 then
    self:StopFogTimer()
    return
  end
  if not self._FogAffectedActors or not self._FogMIDMap then
    return
  end
  if not self.Box_Trigger_Trans then
    return
  end
  self._UpdateCount = (self._UpdateCount or 0) + 1
  local bDiagnosticFrame = 1 == self._UpdateCount % 30
  for Actor, _ in pairs(self._FogAffectedActors) do
    if not IsValid(Actor) then
      self._FogAffectedActors[Actor] = nil
      self._FogMIDMap[Actor] = nil
      self._FogCameraComp[Actor] = nil
      self._FogBaseMatMap[Actor] = nil
    end
  end
  for Actor, _ in pairs(self._FogAffectedActors) do
    local MID = self._FogMIDMap[Actor]
    if MID then
      local Intensity, Distance = self:CalcFogIntensityForActor(Actor)
      self:SetFogIntensityOnMID(MID, Intensity)
      if bDiagnosticFrame then
        GWorld.logger.info("[BP_FogWall] UpdateFogIntensity #" .. tostring(self._UpdateCount) .. " 距离=" .. string.format("%.0f", Distance or -1) .. " Intensity=" .. string.format("%.2f", Intensity) .. " UnitId=" .. tostring(self.UnitId))
      end
    end
  end
  if nil == next(self._FogAffectedActors) then
    self:StopFogTimer()
  end
end

function BP_FogWall_C:RemoveFogEffect(OtherActor)
  if not (OtherActor and OtherActor.IsPlayer) or not OtherActor:IsPlayer() then
    GWorld.logger.info("[BP_FogWall] RemoveFogEffect 跳过: 非玩家 OtherActor=" .. tostring(OtherActor) .. " HasIsPlayer=" .. tostring(nil ~= OtherActor and OtherActor.IsPlayer ~= nil) .. " UnitId=" .. tostring(self.UnitId))
    return
  end
  GWorld.logger.info("[BP_FogWall] RemoveFogEffect 开始, Actor=" .. tostring(OtherActor) .. " UnitId=" .. tostring(self.UnitId))
  if self._FogBaseMatMap and self._FogBaseMatMap[OtherActor] then
    local BaseMat = self._FogBaseMatMap[OtherActor]
    if OtherActor.RemoveBlendableMaterial then
      OtherActor:RemoveBlendableMaterial(BaseMat)
    end
    self._FogBaseMatMap[OtherActor] = nil
  end
  if self._FogMIDMap then
    self._FogMIDMap[OtherActor] = nil
  end
  if self._FogCameraComp then
    self._FogCameraComp[OtherActor] = nil
  end
  if self._FogAffectedActors then
    self._FogAffectedActors[OtherActor] = nil
  end
  if not self._FogAffectedActors or nil == next(self._FogAffectedActors) then
    self:StopFogTimer()
  end
end

function BP_FogWall_C:StopFogTimer()
  if self._FogTimerKey then
    self:RemoveTimer(self._FogTimerKey)
    GWorld.logger.info("[BP_FogWall] StopFogTimer key=" .. tostring(self._FogTimerKey) .. " UnitId=" .. tostring(self.UnitId))
    self._FogTimerKey = nil
  end
end

function BP_FogWall_C:SetupFogWallCollision(Info)
  local TransExtent = self:ResolveTransExtent(Info)
  local FogOffset = self.UnitParams.FogOffset
  GWorld.logger.info("[BP_FogWall] ===== SetupFogWallCollision 数据汇总 =====")
  GWorld.logger.info("[BP_FogWall] TransExtent(内盒半尺寸cm)=" .. FormatExtent(TransExtent) .. " UnitId=" .. tostring(self.UnitId))
  GWorld.logger.info("[BP_FogWall] FogOffset(cm)=" .. tostring(FogOffset) .. " UnitId=" .. tostring(self.UnitId))
  if self.Box_Trigger_Trans then
    local ExtentCM = FVector(TransExtent.X, TransExtent.Y, TransExtent.Z)
    self.Box_Trigger_Trans:SetBoxExtent(ExtentCM, true)
    GWorld.logger.info("[BP_FogWall] [设置后] Box_Trigger_Trans BoxExtent=" .. FormatExtent(self.Box_Trigger_Trans.BoxExtent) .. " UnitId=" .. tostring(self.UnitId))
    if self.Cube then
      local Scale = FVector(ExtentCM.X / 50, ExtentCM.Y / 50, ExtentCM.Z / 50)
      self.Cube:SetRelativeScale3D(Scale)
      GWorld.logger.info("[BP_FogWall] Cube Scale=" .. FormatExtent(Scale) .. " UnitId=" .. tostring(self.UnitId))
    end
  else
    GWorld.logger.info("[BP_FogWall] Box_Trigger_Trans 不存在, 跳过内盒设置 UnitId=" .. tostring(self.UnitId))
  end
  if FogOffset and FogOffset > 0 and self.Box_Trigger_Fog then
    local FogExtent = FVector(TransExtent.X + FogOffset, TransExtent.Y + FogOffset, TransExtent.Z + FogOffset / 2)
    GWorld.logger.info("[BP_FogWall] FogExtent(外盒半尺寸cm) 计算: TransExtent" .. FormatExtent(TransExtent) .. " + FogOffset(" .. tostring(FogOffset) .. ") = " .. FormatExtent(FogExtent) .. " 公式: X=TE.X+" .. tostring(FogOffset) .. " Y=TE.Y+" .. tostring(FogOffset) .. " Z=TE.Z+" .. tostring(FogOffset / 2) .. " UnitId=" .. tostring(self.UnitId))
    self.Box_Trigger_Fog:SetBoxExtent(FogExtent, true)
    local RelLocZ = FogOffset / 2
    self.Box_Trigger_Fog:K2_SetRelativeLocation(FVector(0, 0, RelLocZ), false, nil, false)
    GWorld.logger.info("[BP_FogWall] [设置后] Box_Trigger_Fog BoxExtent=" .. FormatExtent(self.Box_Trigger_Fog.BoxExtent) .. " RelLocation=" .. FormatExtent(self.Box_Trigger_Fog.RelativeLocation) .. " UnitId=" .. tostring(self.UnitId))
    if self.Cube1 then
      local Scale = FVector(FogExtent.X / 50, FogExtent.Y / 50, FogExtent.Z / 50)
      self.Cube1:SetRelativeScale3D(Scale)
      GWorld.logger.info("[BP_FogWall] Cube1 Scale=" .. FormatExtent(Scale) .. " UnitId=" .. tostring(self.UnitId))
    end
  else
    GWorld.logger.info("[BP_FogWall] 外盒跳过: FogOffset=" .. tostring(FogOffset) .. " Box_Trigger_Fog存在=" .. tostring(self.Box_Trigger_Fog ~= nil) .. " UnitId=" .. tostring(self.UnitId))
  end
  GWorld.logger.info("[BP_FogWall] ===== SetupFogWallCollision 结束 =====")
end

return BP_FogWall_C
