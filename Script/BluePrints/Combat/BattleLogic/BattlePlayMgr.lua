local msgpack = require("msgpack_core")
local Component = {}

local function ValidateOrderedArray(Data, DataName)
  assert(type(Data) == "table", DataName .. "必须是table")
  local Count = 0
  local MaxIndex = 0
  for Index in pairs(Data) do
    assert(type(Index) == "number" and Index >= 1 and 0 == Index % 1, string.format("%s存在非正整数下标:%s", DataName, tostring(Index)))
    Count = Count + 1
    MaxIndex = math.max(MaxIndex, Index)
  end
  assert(Count > 0, DataName .. "不能为空")
  assert(Count == MaxIndex, string.format("%s下标不连续:元素数=%d,最大下标=%d", DataName, Count, MaxIndex))
end

function Component:_GetParamentsTable(_Data)
  local ParamentsTable
  if _Data.EffectId then
    local EffectInfo = DataMgr.SkillEffects[_Data.EffectId]
    if EffectInfo then
      ParamentsTable = EffectInfo.TaskEffects[_Data.Index] or {}
    end
    _Data.Index = nil
    _Data.EffectId = nil
  end
  return ParamentsTable
end

function Component:ExecuteEffectResults(EffectStruct)
  local Str = EffectStruct:GetResult()
  if not Str then
    return
  end
  local OldClientExec = self.ClientExec
  local Success, Error = xpcall(function()
    local Result = msgpack.unpack(Str)
    ValidateOrderedArray(Result, "EffectResult")
    self.ClientExec = true
    for ResultIndex, _Data in ipairs(Result) do
      assert(type(_Data) == "table", string.format("EffectResult[%d]必须是table", ResultIndex))
      local ParamentsTable = self:_GetParamentsTable(_Data)
      ValidateOrderedArray(_Data, string.format("EffectResult[%d]", ResultIndex))
      for ActionIndex, Args in ipairs(_Data) do
        assert(type(Args) == "table", string.format("EffectResult[%d][%d]必须是table", ResultIndex, ActionIndex))
        local Func, Content
        for Key, Value in pairs(Args) do
          assert(nil == Func, string.format("EffectResult[%d][%d]包含多个函数:%s,%s", ResultIndex, ActionIndex, tostring(Func), tostring(Key)))
          Func = Key
          Content = Value
        end
        assert(type(Func) == "string", string.format("EffectResult[%d][%d]函数名无效:%s", ResultIndex, ActionIndex, tostring(Func)))
        local f = self["Play_" .. Func]
        assert(f, "不存在函数:Play_" .. Func)
        f(self, Content, ParamentsTable)
      end
    end
  end, debug.traceback)
  self.ClientExec = OldClientExec
  if not Success then
    self:ShowBattleErrorLua(Error)
    error(Error, 0)
  end
end

function Component:Play_CutToughness(Content, ParamentsTable)
  local Source = self:GetEntity(Content.SourceEid)
  local CauseHit = Content.CauseHit
  local CutTnEffectParams = UE4.FCutTNEffectParams()
  CutTnEffectParams.Value = ParamentsTable.Value
  CutTnEffectParams.bForceHit = ParamentsTable.ForceHit
  CutTnEffectParams.HitRule = ParamentsTable.CauseHit
  CutTnEffectParams.NotRotateWhenHit = ParamentsTable.NotRotateWhenHit
  if CauseHit then
    local HitRule = DataMgr.HitPerformanceData[CauseHit]
    for Index, TargetEid in ipairs(Content.HitTargets) do
      local CauseHitType = Content.CauseHitTypes[Index]
      local HitType = Content.HitTypes[Index]
      if TargetEid and CauseHitType and HitType then
        local Target = self:GetEntity(TargetEid)
        if not Target then
        else
          Target:ApplyEffectHitPerformance_Cpp(Source, HitType, CauseHitType, CutTnEffectParams)
        end
      end
    end
    if Content.DeadTargets then
      self:AddRadialForceForDead(Source, HitRule, Content.DeadTargets)
    end
  end
end

function Component:Play_GatherTargets(Content, ParamentsTable)
  local Source = self:GetEntity(Content.SourceEid)
  if not Source then
    return
  end
  local HitTargets = Content.HitTargets
  if not HitTargets or not next(HitTargets) then
    return
  end
  local Params = UE4.FGatherSharedParams()
  Params.GatherPoint = ParamentsTable.GatherPoint
  Params.TargetSocketName = ParamentsTable.TargetSocketName
  Params.GatherSpeed = ParamentsTable.GatherSpeed
  Params.StopDistance = ParamentsTable.StopDistance
  Params.Acceleration = ParamentsTable.Acceleration or FVector(0, 0, 0)
  Params.LocationOffset = FVector(0, 0, 0)
  Params.Time = ParamentsTable.Time
  local TargetEids = TArray(0)
  for _, Eid in ipairs(HitTargets) do
    TargetEids:Add(Eid)
  end
  self:ApplyGatherToSourceBatch(Source, Params, TargetEids)
end

function Component:Play_PlaySE(Content, ParamentsTable)
  local SourceEid = Content.SourceEid
  local Source = self:GetEntity(SourceEid)
  if not Source then
    return
  end
  if Content.ExtraParams and Content.ExtraParams.SceneSe then
    Source:ApplyHitPerformSe(Source, ParamentsTable, Content.ExtraParams)
  end
  local HitTargets = Content.HitTargets
  if not HitTargets then
    return
  end
  for _, Eid in ipairs(HitTargets) do
    local Target = self:GetEntity(Eid)
    if Target then
      Target:ApplyHitPerformSe(Source, ParamentsTable, Content.ExtraParams)
    end
  end
end

function Component:Play_SkillMove(Content, ParamentsTable)
  local HitTargets = Content.HitTargets
  for _, Eid in pairs(HitTargets) do
    local Target = self:GetEntity(Eid)
    if Target then
      if ParamentsTable.DisableRootMotion then
        Target:DisableRootMotion(ESourceTags.SkillMove)
      end
      local MoveX = ParamentsTable.MoveX or 0
      local MoveY = ParamentsTable.MoveY or 0
      local MoveZ = ParamentsTable.MoveZ or 0
      if ParamentsTable.CanSkillRangeModify then
        local SkillRangeModity = Target:GetAttrByConstrain(EAttrName.SkillRange)
        MoveX = MoveX * SkillRangeModity
        MoveY = MoveY * SkillRangeModity
        MoveZ = MoveZ * SkillRangeModity
      end
      Target:SetMoveInfo_Lua(ESourceTags.SkillMove, ParamentsTable.TotalTime, MoveX, MoveY, MoveZ)
      Target:AddTimer_Combat(ParamentsTable.TotalTime, function()
        if not UKismetSystemLibrary.IsValid(Target) then
          return
        end
        if ParamentsTable.DisableRootMotion then
          Target:EnableRootMotion(ESourceTags.SkillMove)
        end
        Target:ClearMoveInfo_Lua(ESourceTags.SkillMove)
      end, false, 0)
    end
  end
end

function Component:Play_Disarm(Content, ParamentsTable)
  local DisarmParam = Content.DisarmParam
  local Source = self:GetEntity(Content.SourceEid)
  if not Source then
    return
  end
  for i, Param in ipairs(DisarmParam) do
    local Target = self:GetEntity(Param.Eid)
    if Target and Param.DisarmHitMontage then
      local HitLogicComp = Target:GetOrAddHitLogicComp()
      if HitLogicComp and HitLogicComp:_GetHitMontage(Param.DisarmHitMontage) then
        local HitParams = UE4.FHitParams()
        HitParams.CauseHitName = "LightHit"
        HitParams.CauseHitType = Const.CauseHitTypeNormal
        HitParams.OverrideMontageSuffix = Param.DisarmHitMontage
        Target:ProcessHit("LightHit", Source, HitParams)
      end
    end
  end
end

return Component
