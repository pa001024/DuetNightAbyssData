local ExecuteBlueprintFunctionSetVarNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode")
local VarLogType = UE.EStoryLogType.StoryVar

function ExecuteBlueprintFunctionSetVarNode:Init()
  self.FunctionName = nil
  self.VarName = nil
  self.VarInfos = {}
end

function ExecuteBlueprintFunctionSetVarNode:Execute(Callback)
  if not self.VarName or self.VarName == "" then
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "通过蓝图函数设置变量节点出错", "没有填写VarName, FileName:" .. tostring(self.Context.FileName) .. ",请策划排查.")
    Callback()
    return
  end
  local VarInfo = DataMgr.StoryVariable[self.VarName]
  if not VarInfo then
    local _Str = "变量:[" .. tostring(self.VarName) .. "]需要现在StoryVariable.xlsx中先声明"
    if self.QuestChainId and 0 ~= self.QuestChainId then
      _Str = _Str .. ",QuestChainId:[" .. tostring(self.QuestChainId) .. "]"
    end
    _Str = _Str .. ",FileName:" .. tostring(self.Context.FileName) .. ",请策划排查."
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "通过蓝图函数设置变量节点出错", _Str)
    Callback()
    return
  end
  local NewVarInfos = {}
  for k, v in pairs(self.VarInfos) do
    local _VarName = v.VarName
    local _VarValue = v.VarValue
    if tonumber(_VarValue) then
      NewVarInfos[_VarName] = tonumber(_VarValue)
    else
      NewVarInfos[_VarName] = _VarValue
    end
  end
  local StorySubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
  local Ret = StorySubsystem:ExecuteBlueprintVarFunction(self.FunctionName, self.VarName, NewVarInfos, self.QuestChainId, false)
  if type(Ret) ~= "number" or 0 ~= Ret % 1 then
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "通过蓝图函数设置变量节点出错", "函数[" .. tostring(self.FunctionName) .. "]的返回值不是int类型, Ret:" .. tostring(Ret))
    Callback()
    return nil
  end
  StorySubsystem:SetInt(self.VarName, Ret)
  if not VarInfo.IsGlobal then
    Callback()
  else
    EventManager:AddEvent(EventID.OnStoryVarUpdated, self, function(Obj, VarName, VarValue)
      EventManager:RemoveEvent(EventID.OnStoryVarUpdated, self)
      if VarName == self.VarName and VarValue == Ret then
        Callback()
      end
    end)
  end
end

function ExecuteBlueprintFunctionSetVarNode:Stop()
  self:Clear()
end

function ExecuteBlueprintFunctionSetVarNode:Clear()
  EventManager:RemoveEvent(EventID.OnStoryVarUpdated, self)
end

function ExecuteBlueprintFunctionSetVarNode:OnQuestlineFinish()
end

function ExecuteBlueprintFunctionSetVarNode:OnQuestlineSuccess()
end

function ExecuteBlueprintFunctionSetVarNode:OnQuestlineFail()
end

return ExecuteBlueprintFunctionSetVarNode
