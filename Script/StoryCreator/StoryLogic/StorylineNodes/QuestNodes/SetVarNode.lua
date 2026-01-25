local SetVarNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode")
local VarLogType = UE.EStoryLogType.StoryVar

function SetVarNode:Init()
  self.VarName = nil
  self.VarValue = 0
end

function SetVarNode:Execute()
  if not self.VarName or self.VarName == "" then
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "SetVarNode节点出错", "没有填写VarName, FileName:" .. tostring(self.Context.FileName) .. ",请策划排查.")
    return
  end
  local VarInfo = DataMgr.StoryVariable[self.VarName]
  if not VarInfo then
    local _Str = "变量:[" .. tostring(self.VarName) .. "]需要现在StoryVariable.xlsx中先声明"
    if self.QuestChainId and 0 ~= self.QuestChainId then
      _Str = _Str .. ",QuestChainId:[" .. tostring(self.QuestChainId) .. "]"
    end
    _Str = _Str .. ",FileName:" .. tostring(self.Context.FileName) .. ",请策划排查."
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "SetVarNode节点出错", _Str)
    return
  end
  if VarInfo.QuestChainId and VarInfo.QuestChainId ~= self.QuestChainId then
    local _Str = "变量:[" .. tostring(self.VarName) .. "]不能在QuestChain:[" .. tostring(self.QuestChainId) .. "]中使用！表里填里它只支持在QuestChain:[" .. tostring(VarInfo.QuestChainId) .. "]中使用！"
    _Str = _Str .. ",请策划排查."
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "StorySubsystem错误", _Str)
    return
  end
  local StorySubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
  StorySubsystem:SetInt(self.VarName, self.VarValue)
  return nil
end

function SetVarNode:Clear()
end

function SetVarNode:OnQuestlineFinish()
end

function SetVarNode:OnQuestlineSuccess()
end

function SetVarNode:OnQuestlineFail()
end

return SetVarNode
