local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local CommonConst = require("CommonConst")
local ClueContent = Class("ClueContent", CustomTypes.CustomAttr)
ClueContent.__Props__ = {
  ClueContentId = prop.prop("Int", "client save"),
  State = prop.prop("Int", "client save", CommonConst.ClueContentState.Locked),
  FinalState = prop.getter("Data", "FinalState")
}

function ClueContent:Init(ClueContentId)
  self.ClueContentId = ClueContentId
end

function ClueContent:Data()
  return DataMgr.ClueContent[self.ClueContentId]
end

function ClueContent:GetState()
  return self.State
end

function ClueContent:IsFinalState()
  return self.State == self.FinalState
end

function ClueContent:TrySetState(State)
  if self:IsFinalState() then
    return false
  end
  if not CommonUtils.HasValue(CommonConst.ClueContentState, State) then
    return false
  end
  self.State = State
  return true
end

FormatProperties(ClueContent)
local ClueContentDict = Class("ClueContentDict", CustomTypes.CustomDict)
ClueContentDict.KeyType = BaseTypes.Int
ClueContentDict.ValueType = ClueContent

function ClueContentDict:GetClueContent(ClueContentId)
  return self:Get(ClueContentId)
end

function ClueContentDict:NewClueContent(ClueContentId)
  local NewClueContent = ClueContent(ClueContentId)
  self:AddValue(ClueContentId, NewClueContent)
  return self:GetClueContent(ClueContentId)
end

local Clue = Class("Clue", CustomTypes.CustomAttr)
Clue.__Props__ = {
  ClueId = prop.prop("Int", "client save"),
  State = prop.prop("Int", "client save", CommonConst.ClueState.Locked),
  ClueContents = prop.prop("ClueContentDict", "client save"),
  FinalClueContentCnt = prop.prop("Int", "client save", 0),
  ClueContentStateCnt = prop.prop("Int2IntDict", "client save", {}),
  ClueContentIds = prop.getter("Data", "ClueContent")
}

function Clue:Init(ClueId)
  self.ClueId = ClueId
  self:Rebuild()
end

function Clue:Data()
  return DataMgr.Clue[self.ClueId]
end

function Clue:GetClueContent(ClueContentId)
  return self.ClueContents:GetClueContent(ClueContentId)
end

function Clue:GetClueContentStateCnt(State)
  return self.ClueContentStateCnt[State] or 0
end

function Clue:AddClueContentStateCnt(State, Cnt)
  self.ClueContentStateCnt[State] = (self.ClueContentStateCnt[State] or 0) + Cnt
end

function Clue:AddFinalClueContentCnt()
  self.FinalClueContentCnt = self.FinalClueContentCnt + 1
end

function Clue:UpdateState()
  local ClueContentIdsLength = #self.ClueContentIds
  self:Locked()
  if self:GetClueContentStateCnt(CommonConst.ClueContentState.Locked) ~= ClueContentIdsLength then
    self:Exploring()
  end
  if ClueContentIdsLength <= self.FinalClueContentCnt then
    self:Finished()
  end
end

function Clue:Locked()
  self.State = CommonConst.ClueState.Locked
end

function Clue:Exploring()
  self.State = CommonConst.ClueState.Exploring
end

function Clue:Finished()
  self.State = CommonConst.ClueState.Finished
end

function Clue:Rebuild()
  self:EnsureClueContents()
  self:RebuildClueContentStateCnt()
  self:UpdateState()
end

function Clue:EnsureClueContents()
  for _, ClueContentId in ipairs(self.ClueContentIds) do
    local ClueContent = self.ClueContents:GetClueContent(ClueContentId)
    if not ClueContent then
      self.ClueContents:NewClueContent(ClueContentId)
    end
  end
end

function Clue:RebuildClueContentStateCnt()
  self.FinalClueContentCnt = 0
  self.ClueContentStateCnt:Clear()
  for _, ClueContent in ipairs(self.ClueContents:Values()) do
    local State = ClueContent:GetState()
    self:AddClueContentStateCnt(State, 1)
    if ClueContent:IsFinalState() then
      self:AddFinalClueContentCnt()
    end
  end
end

FormatProperties(Clue)
local ClueDict = Class("ClueDict", CustomTypes.CustomDict)
ClueDict.KeyType = BaseTypes.Int
ClueDict.ValueType = Clue

function ClueDict:GetClue(ClueId)
  local Clue = self:Get(ClueId)
  if Clue then
    return Clue
  end
  return self:NewClue(ClueId)
end

function ClueDict:NewClue(ClueId)
  local NewClue = Clue(ClueId)
  self:AddValue(ClueId, NewClue)
  return self:GetClue(ClueId)
end

function ClueDict:GetClueContent(ClueId, ClueContentId)
  local Clue = self:GetClue(ClueId)
  if not Clue then
    return
  end
  local ClueContent = Clue:GetClueContent(ClueContentId)
  return ClueContent, Clue
end

function ClueDict:Rebuild()
  for _, Clue in ipairs(self:Values()) do
    Clue:Rebuild()
  end
end

return {
  ClueContent = ClueContent,
  ClueContentDict = ClueContentDict,
  Clue = Clue,
  ClueDict = ClueDict
}
