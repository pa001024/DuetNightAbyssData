local PrintVarNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode")
local VarLogType = UE.EStoryLogType.StoryVar

function PrintVarNode:Init()
  self.VarName = nil
end

function PrintVarNode:Execute()
  if not self.VarName or self.VarName == "" then
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "PrintVarNode节点出错", "没有填写VarName, FileName:" .. tostring(self.Context.FileName) .. ",请策划排查.")
    return
  end
  local VarInfo = DataMgr.StoryVariable[self.VarName]
  if not VarInfo then
    local _Str = "变量:[" .. tostring(self.VarName) .. "]需要现在StoryVariable.xlsx中先声明"
    if self.QuestChainId and 0 ~= self.QuestChainId then
      _Str = _Str .. ",QuestChainId:[" .. tostring(self.QuestChainId) .. "]"
    end
    _Str = _Str .. ",FileName:" .. tostring(self.Context.FileName) .. ",请策划排查."
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "PrintVarNode节点出错", _Str)
    return
  end
  if VarInfo.QuestChainId and VarInfo.QuestChainId ~= self.QuestChainId then
    local _Str = "变量:[" .. tostring(self.VarName) .. "]不能在QuestChain:[" .. tostring(self.QuestChainId) .. "]中使用！表里填里它只支持在QuestChain:[" .. tostring(VarInfo.QuestChainId) .. "]中使用！"
    _Str = _Str .. ",请策划排查."
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "StorySubsystem错误", _Str)
    return
  end
  local StorySubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
  local VarValue = StorySubsystem:GetInt(self.VarName)
  local Str = "[PrintVarNode]变量[" .. tostring(self.VarName) .. "]的值为[" .. tostring(VarValue) .. "]"
  ScreenPrint(Str)
  return nil
end

function PrintVarNode:Clear()
end

function PrintVarNode:OnQuestlineFinish()
end

function PrintVarNode:OnQuestlineSuccess()
end

function PrintVarNode:OnQuestlineFail()
end

return PrintVarNode
