local ExecuteBlueprintFunctionCheckVarNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode")
local VarLogType = UE.EStoryLogType.StoryVar

function ExecuteBlueprintFunctionCheckVarNode:Init()
  self.ListenIntervalSeconds = 0.2
  self.FunctionName = nil
  self.VarName = nil
  self.VarInfos = {}
  self.Duration = 0
  self.TimerTime = 0
end

function ExecuteBlueprintFunctionCheckVarNode:Start()
  if 0 == self.Duration then
    local ReturnValue = self:Execute()
    self:Finish(nil ~= ReturnValue and tostring(ReturnValue) or nil)
  else
    self:Execute(function(ReturnValue)
      self:Finish(nil ~= ReturnValue and tostring(ReturnValue) or nil)
    end)
  end
end

function ExecuteBlueprintFunctionCheckVarNode:Execute(Callback)
  self.Callback = Callback
  if not self.VarName or self.VarName == "" then
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "执行变量检测函数节点出错", "没有填写VarName, FileName:" .. tostring(self.Context.FileName) .. ",请策划排查.")
    return
  end
  if self.Duration < 0 then
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "执行变量检测函数节点出错", "持续时间只能填0和正整数, 持续时间: " .. self.Duration .. ", FileName:" .. tostring(self.Context.FileName) .. ",请策划排查.")
    return
  end
  local VarInfo = DataMgr.StoryVariable[self.VarName]
  if not VarInfo then
    local _Str = "变量:[" .. tostring(self.VarName) .. "]需要现在StoryVariable.xlsx中先声明"
    if self.QuestChainId and 0 ~= self.QuestChainId then
      _Str = _Str .. ",QuestChainId:[" .. tostring(self.QuestChainId) .. "]"
    end
    _Str = _Str .. ",FileName:" .. tostring(self.Context.FileName) .. ",请策划排查."
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "执行变量检测函数节点出错", _Str)
    return
  end
  self.NewVarInfos = {}
  for k, v in pairs(self.VarInfos) do
    local _VarName = v.VarName
    local _VarValue = v.VarValue
    if tonumber(_VarValue) then
      self.NewVarInfos[_VarName] = tonumber(_VarValue)
    else
      self.NewVarInfos[_VarName] = _VarValue
    end
  end
  local StorySubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
  local Ret = StorySubsystem:ExecuteBlueprintVarFunction(self.FunctionName, self.VarName, self.NewVarInfos, self.QuestChainId, true)
  if type(Ret) ~= "number" or 0 ~= Ret % 1 then
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "执行变量检测函数节点出错", "函数[" .. tostring(self.FunctionName) .. "]的返回值不是bool类型")
    return nil
  end
  if 0 == self.Duration then
    return 1 == Ret
  else
    if 1 == Ret then
      self.Callback(true)
      return
    end
    self.TimerTime = 0
    self.ListenTimer = GWorld.GameInstance:AddTimer(self.ListenIntervalSeconds, function()
      self:ListenForBlueprintFunction()
    end, true, self.ListenIntervalSeconds)
  end
end

function ExecuteBlueprintFunctionCheckVarNode:ListenForBlueprintFunction()
  self.TimerTime = self.TimerTime + self.ListenIntervalSeconds
  if self.TimerTime >= self.Duration then
    self.Callback(false)
    self:Clear()
  end
  local StorySubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
  local Ret = StorySubsystem:ExecuteBlueprintVarFunction(self.FunctionName, self.VarName, self.NewVarInfos, self.QuestChainId, true)
  if 1 == not Ret then
    return
  end
  self.Callback(true)
  self:Clear()
end

function ExecuteBlueprintFunctionCheckVarNode:Clear()
  assert(GWorld.GameInstance, "执行变量检测函数节点：清理失败，游戏实例为空。")
  GWorld.GameInstance:RemoveTimer(self.ListenTimer)
  self.ListenTimer = nil
  self.Callback = nil
  self.TimerTime = 0
end

function ExecuteBlueprintFunctionCheckVarNode:OnQuestlineFinish()
end

function ExecuteBlueprintFunctionCheckVarNode:OnQuestlineSuccess()
end

function ExecuteBlueprintFunctionCheckVarNode:OnQuestlineFail()
end

return ExecuteBlueprintFunctionCheckVarNode
