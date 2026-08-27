local BP_StoryVarsObject_C = Class()

function BP_StoryVarsObject_C:TryInitVars()
  self:ClearVars()
  self:InitVars()
end

function BP_StoryVarsObject_C:InitVars()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  self.InitFlag = true
  for VarName, DefaultValue in pairs(DataMgr.StoryVariable2DefaultValue) do
    self:RawSetInt(VarName, DefaultValue)
  end
  for VarName, Value in pairs(Avatar.StoryVariable) do
    local VarInfo = DataMgr.StoryVariable[VarName]
    if VarInfo then
      self:RawSetInt(VarName, Value)
    end
  end
end

function BP_StoryVarsObject_C:UpdateGlobalVariable(VarName, Value)
  local VarInfo = DataMgr.StoryVariable[VarName]
  if VarInfo and VarInfo.IsGlobal then
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      if nil == Value then
        Avatar:RemoveStoryVariable(VarName, Value)
      else
        Avatar:UpdateStoryVariable(VarName, Value)
      end
    end
  end
end

function BP_StoryVarsObject_C:RemoveGlobalVariable(VarName)
  local VarInfo = DataMgr.StoryVariable[VarName]
  if VarInfo and VarInfo.IsGlobal then
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      Avatar:RemoveStoryVariable(VarName)
    end
  end
end

function BP_StoryVarsObject_C:OnRep_StoryVariable(Variables)
  if nil == Variables or nil == next(Variables) then
    return
  end
  for VarName, Param in pairs(Variables) do
    if nil ~= Param and nil ~= next(Param) and Param.OldValue ~= Param.NewValue then
      if not DataMgr.StoryVariable[VarName] then
        do
          local _Str = "变量:[" .. tostring(VarName) .. "]需要先在StoryVariable.xlsx中先声明,请策划排查."
          UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "QuestSetVar出错: StoryVariable表中未找到变量", _Str)
        end
      else
        self:RawSetInt(VarName, Param.NewValue)
      end
    end
  end
end

function BP_StoryVarsObject_C:RestoreQuestChainVariables(QuestChainId)
  local VarNameList = DataMgr.QuestChainId2StoryVariable[QuestChainId]
  if not VarNameList then
    return
  end
  local Avatar = GWorld:GetAvatar()
  for _, VarName in pairs(VarNameList) do
    local VarInfo = DataMgr.StoryVariable[VarName]
    if VarInfo then
      local Value
      if Avatar and VarInfo.IsGlobal then
        Value = Avatar.StoryVariable[VarName]
      end
      if nil == Value then
        Value = VarInfo.DefaultValue or 0
      end
      self:RawSetInt(VarName, Value)
    end
  end
end

function BP_StoryVarsObject_C:FlushGlobalVariables(QuestChainId)
  local VarNameList = DataMgr.QuestChainId2StoryVariable[QuestChainId]
  if not VarNameList then
    return
  end
  local Avatar = GWorld:GetAvatar()
  for _, VarName in pairs(VarNameList) do
    local VarInfo = DataMgr.StoryVariable[VarName]
    if VarInfo and VarInfo.IsGlobal then
      local LocalValue = self:GetInt(VarName)
      local CommittedValue = Avatar and Avatar.StoryVariable[VarName]
      if nil == CommittedValue then
        CommittedValue = VarInfo.DefaultValue or 0
      end
      if LocalValue ~= CommittedValue then
        self:UpdateGlobalVariable(VarName, LocalValue)
      end
    end
  end
end

function BP_StoryVarsObject_C:UpdateTaskQuestExtraData(InKey, InOldValue, InNewValue)
  EventManager:FireEvent(EventID.OnCalcVarChange, InKey, InOldValue, InNewValue)
  EventManager:FireEvent(EventID.SetCustomNpcFlexibShowOrHideDynamic)
  EventManager:FireEvent(EventID.OnVarCheck)
end

return BP_StoryVarsObject_C
