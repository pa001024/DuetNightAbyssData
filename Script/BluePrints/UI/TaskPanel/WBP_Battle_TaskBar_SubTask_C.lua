require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")
local TaskUtils = require("BluePrints.UI.TaskPanel.TaskUtils")
local ClientEventUtils = require("BluePrints.Common.ClientEvent.ClientEventUtils")

function M:Initialize(Initializer)
  self.Super.Initialize(self)
  self.TargetNodeKey = ""
  self.SourceGText = ""
  self.bPlayArrive = false
end

function M:Construct()
  self.Super.Construct(self)
  EventManager:AddEvent(EventID.OnMissiongIndicatorFloorLevelChange, self, self.SetFloorStyle)
end

function M:Destruct()
  self.Super.Destruct(self)
  EventManager:RemoveEvent(EventID.OnMissiongIndicatorFloorLevelChange, self)
end

function M:SetBranchInfo(InKey, InGText)
  self.TargetNodeKey = InKey
  self.SourceGText = InGText
end

function M:PlayArrive()
  self.bPlayArrive = true
  self:PlayAnimation(self.TargetArea)
end

function M:StopArrive()
  self.bPlayArrive = false
  self:PlayAnimation(self.TargetArea_Normal)
end

function M:CheckIsEqualKey(InKey)
  return self.TargetNodeKey == InKey
end

function M:SetFloorStyle(InUIName)
end

function M:SetABCImg(Index, InContent)
  self.WS_Type:SetActiveWidgetIndex(1)
  local Content = string.char(string.byte("A") + Index - 1)
  local RetPath = TaskUtils:GetDiffIconByQuestChainType(InContent, Content)
  UE4.UResourceLibrary.LoadObjectAsync(self, RetPath, {
    self,
    self.RealSetABCImg
  })
end

function M:SetABCImgDiffOptional(Index, InContent)
  self.WS_Type:SetActiveWidgetIndex(1)
  local Content = string.char(string.byte("A") + Index - 1)
  local RetPath = TaskUtils:GetDiffIconOptionalByQuestChainType(InContent, Content)
  UE4.UResourceLibrary.LoadObjectAsync(self, RetPath, {
    self,
    self.RealSetABCImg
  })
end

function M:SetOptional(InGuidePointChainId)
  self.WS_Type:SetActiveWidgetIndex(1)
  local IconObj = TaskUtils:GetOptinalIconTextureByQuestChainType(InGuidePointChainId)
  self.Icon_Letter:SetBrushResourceObject(IconObj)
end

function M:RealSetABCImg(Object)
  self.Icon_Letter:SetBrushResourceObject(Object)
end

return M
