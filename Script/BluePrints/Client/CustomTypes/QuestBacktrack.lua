local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local CommonConst = require("CommonConst")
local QuestUtils = require("Utils.QuestUtils")
local QuestBacktrackNodeData = Class("QuestBacktrackNodeData", CustomTypes.CustomAttr)
QuestBacktrackNodeData.__Props__ = {
  QuestId = prop.prop("Int", "client save"),
  State = prop.prop("Int", "client save", 0),
  IsUnlock = prop.prop("Bool", "client save", false),
  IsFinished = prop.prop("Bool", "client save", false),
  Snapshot = prop.prop("Bytes", "client save"),
  FalseEndClaimReward = prop.prop("Bool", "client save", false),
  EndType = prop.getter("Data", "EndType"),
  RedoQuestId = prop.getter("Data", "RedoQuestId"),
  EndRewardId = prop.getter("Data", "EndRewardId")
}

function QuestBacktrackNodeData:Init(QuestId)
  if not QuestId then
    return
  end
  self.QuestId = QuestId
  self:NoneStart()
end

function QuestBacktrackNodeData:Data()
  local EndId = self:GetEndId()
  return DataMgr.QuestReview[EndId]
end

function QuestBacktrackNodeData:GetEndId()
  local STLQuest = QuestUtils:GetSTLQuest(self.QuestId)
  return STLQuest.EndingId
end

function QuestBacktrackNodeData:IsTrueEnd()
  return self.EndType and self.EndType == CommonConst.QuestEndType.True
end

function QuestBacktrackNodeData:IsFalseEnd()
  return self.EndType and self.EndType == CommonConst.QuestEndType.False
end

function QuestBacktrackNodeData:IsFalseEndClaimReward()
  return self:IsFalseEnd() and self.FalseEndClaimReward
end

function QuestBacktrackNodeData:OnFalseEndClaimReward()
  self.FalseEndClaimReward = true
end

function QuestBacktrackNodeData:NoneStart()
  self.State = CommonConst.QuestBacktrackNodeState.NoneStart
end

function QuestBacktrackNodeData:Doing()
  self.State = CommonConst.QuestBacktrackNodeState.Doing
  self.IsUnlock = true
end

function QuestBacktrackNodeData:Finish()
  self.State = CommonConst.QuestBacktrackNodeState.Finish
  self.IsFinished = true
end

function QuestBacktrackNodeData:DumpBacktrackSnapshot(Snapshot)
  Snapshot = Snapshot or {}
  Snapshot.QuestId = self.QuestId
  Snapshot.State = self.State
  return Snapshot
end

function QuestBacktrackNodeData:LoadBacktrackSnapshot(Snapshot)
  Snapshot = Snapshot or {}
  self.State = Snapshot.State
end

function QuestBacktrackNodeData:SaveSnapshot(Snapshot)
  self.Snapshot = SerializeUtils:Serialize(Snapshot)
end

function QuestBacktrackNodeData:GetSnapshot()
  return SerializeUtils:UnSerialize(self.Snapshot)
end

FormatProperties(QuestBacktrackNodeData)
local QuestBacktrackNodeDataDict = Class("QuestBacktrackNodeDataDict", CustomTypes.CustomDict)
QuestBacktrackNodeDataDict.KeyType = BaseTypes.Int
QuestBacktrackNodeDataDict.ValueType = QuestBacktrackNodeData
local QuestBacktrackData = Class("QuestBacktrackData", CustomTypes.CustomAttr)
QuestBacktrackData.__Props__ = {
  QuestChainId = prop.prop("Int", "client save"),
  State = prop.prop("Int", "client save", 0),
  IsFinishTrueEnd = prop.prop("Bool", "client save", false),
  Nodes = prop.prop("QuestBacktrackNodeDataDict", "client save", {}),
  EndSnapshot = prop.prop("Bytes", "client save")
}

function QuestBacktrackData:Init(QuestChainId)
  if not QuestChainId then
    return
  end
  local STLQuestChain = DataMgr.STLExportQuestChain[QuestChainId]
  if not STLQuestChain or not STLQuestChain.IsBacktrack then
    return
  end
  self.QuestChainId = QuestChainId
  self:NoneStart()
  self:_BuildTree()
end

function QuestBacktrackData:IsDoing()
  return self.State == CommonConst.QuestBacktrackState.Doing
end

function QuestBacktrackData:NoneStart()
  self.State = CommonConst.QuestBacktrackState.NoneStart
end

function QuestBacktrackData:Doing()
  self.State = CommonConst.QuestBacktrackState.Doing
end

function QuestBacktrackData:Finish()
  self.State = CommonConst.QuestBacktrackState.Finish
end

function QuestBacktrackData:FinishTrueEnd()
  self.IsFinishTrueEnd = true
end

function QuestBacktrackData:GetNode(QuestId)
  local Ret = self.Nodes:Get(QuestId)
  if Ret then
    return Ret
  end
  local STLQuest = QuestUtils:GetSTLQuest(QuestId)
  if not STLQuest then
    DebugPrint("ERROR::", "QuestId:" .. tostring(QuestId) .. "不存在, 请检查STLExportQuestChain表是否同步双端")
    return
  end
  if not STLQuest.IsBacktrack then
    DebugPrint("ERROR::", "QuestId:" .. tostring(QuestId) .. "不是回溯任务, 请检查STLExportQuestChain表Quests.IsBacktrack配置")
    return
  end
  return self.Nodes:Get(QuestId)
end

function QuestBacktrackData:GetNodeValues()
  return self.Nodes:Values()
end

function QuestBacktrackData:DumpBacktrackSnapshot(Snapshot)
  Snapshot = Snapshot or {}
  Snapshot.QuestChainId = self.QuestChainId
  Snapshot.State = self.State
  Snapshot.Nodes = {}
  for _, QuestBacktrackNode in ipairs(self.Nodes:Values()) do
    local QuestId = QuestBacktrackNode.QuestId
    Snapshot.Nodes[QuestId] = QuestBacktrackNode:DumpBacktrackSnapshot()
  end
  return Snapshot
end

function QuestBacktrackData:LoadBacktrackSnapshot(Snapshot)
  Snapshot = Snapshot or {}
  self.State = Snapshot.State
  for QuestId, QuestSnapshot in pairs(Snapshot.Nodes or {}) do
    local QuestBacktrackNode = self.Nodes[QuestId]
    if QuestBacktrackNode then
      QuestBacktrackNode:LoadBacktrackSnapshot(QuestSnapshot)
    end
  end
end

function QuestBacktrackData:SaveEndSnapshot(Snapshot)
  self.EndSnapshot = SerializeUtils:Serialize(Snapshot)
end

function QuestBacktrackData:GetEndSnapshot()
  return SerializeUtils:UnSerialize(self.EndSnapshot)
end

function QuestBacktrackData:_BuildTree()
  local QuestChainId = self.QuestChainId
  local STLQuestChain = QuestUtils:GetSTLQuestChain(QuestChainId)
  if not STLQuestChain then
    DebugPrint("ERROR::", "QuestChainId:" .. QuestChainId .. "不存在, 请检查STLExportQuestChain表是否同步双端, QuestChainId:" .. self.QuestChainId)
    return
  end
  if not STLQuestChain.IsBacktrack then
    DebugPrint("ERROR::", "QuestChainId:" .. QuestChainId .. "不是回溯任务链, 请检查STLExportQuestChain表IsBacktrack配置, QuestChainId:" .. self.QuestChainId)
    return
  end
  local Quests = STLQuestChain.Quests or {}
  for QuestId, QuestInfo in pairs(Quests) do
    local IsBacktrack = QuestInfo.IsBacktrack
    if IsBacktrack then
      self.Nodes:SetDefault(QuestId, QuestBacktrackNodeData(QuestId))
    end
  end
end

FormatProperties(QuestBacktrackData)
local QuestBacktrackDataDict = Class("QuestBacktrackDataDict", CustomTypes.CustomDict)
QuestBacktrackDataDict.KeyType = BaseTypes.Int
QuestBacktrackDataDict.ValueType = QuestBacktrackData

function QuestBacktrackDataDict:GetBacktrackData(QuestChainId)
  if not QuestChainId then
    return
  end
  local Ret = self:Get(QuestChainId)
  if Ret then
    return Ret
  end
  local STLQuestChain = DataMgr.STLExportQuestChain[QuestChainId]
  if not STLQuestChain or not STLQuestChain.IsBacktrack then
    return
  end
  Ret = QuestBacktrackData(QuestChainId)
  self:SetDefault(QuestChainId, Ret)
  return Ret
end

return {
  QuestBacktrackNodeData = QuestBacktrackNodeData,
  QuestBacktrackNodeDataDict = QuestBacktrackNodeDataDict,
  QuestBacktrackData = QuestBacktrackData,
  QuestBacktrackDataDict = QuestBacktrackDataDict
}
