local ExecuteBlueprintFunctionSetVarNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode")
local VarLogType = UE.EStoryLogType.StoryVar

function ExecuteBlueprintFunctionSetVarNode:Init()
  self.FunctionName = nil
  self.VarName = nil
  self.VarInfos = {}
end

function ExecuteBlueprintFunctionSetVarNode:Execute()
  if not self.VarName or self.VarName == "" then
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "通过蓝图函数设置变量节点出错", "没有填写VarName, FileName:" .. tostring(self.Context.FileName) .. ",请策划排查.")
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
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "通过蓝图函数设置变量节点出错", "函数[" .. tostring(self.FunctionName) .. "]的返回值不是int类型")
    return nil
  end
  StorySubsystem:SetInt(self.VarName, Ret)
  return nil
end

function ExecuteBlueprintFunctionSetVarNode:Clear()
end

function ExecuteBlueprintFunctionSetVarNode:OnQuestlineFinish()
end

function ExecuteBlueprintFunctionSetVarNode:OnQuestlineSuccess()
end

function ExecuteBlueprintFunctionSetVarNode:OnQuestlineFail()
end

return ExecuteBlueprintFunctionSetVarNode
