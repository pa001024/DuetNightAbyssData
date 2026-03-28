require("UnLua")
local LevelDetails = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})
local SoloTreasureDataModel = require("BluePrints.UI.WBP.Activity.Widget.SoloTreasure.SoloTreasureDataModel")

function LevelDetails:RefreshStoryLevelDetailPanel(Result)
  self:LoadProgressData(Result)
  local CurRow = Result and Result.CurRow
  if not CurRow then
    DebugPrint(ErrorTag, "----------------未能拿到当前进度行 CurRow-----------------")
    return
  end
  local UserCurProgressId = CurRow.EventProgressId
  if not UserCurProgressId then
    DebugPrint(ErrorTag, "----------------未能拿到用户当前进度ID-----------------")
    return
  end
  local EventDungeonId = CurRow.EventDugeonId
  if not EventDungeonId then
    DebugPrint(ErrorTag, "----------------未能拿到剧情关 EventDugeonId-----------------")
    return
  end
  self.CurEventDungeonId = EventDungeonId
  local StoryRow = DataMgr.TreasureHuntStoryDungeon and DataMgr.TreasureHuntStoryDungeon[EventDungeonId]
  if not StoryRow then
    DebugPrint(ErrorTag, "----------------TreasureHuntStoryDungeon 行不存在:", EventDungeonId, "-----------------")
    return
  end
  self.Text_Map:SetText(GText(StoryRow.DungeonName))
  self.Text_Info:SetText(GText(StoryRow.DungeonDes))
  self.Text_Status:SetText(GText(CurRow.PetConText))
  self.Text_Cost:SetText(StoryRow.Fee)
  local ResourceId = DataMgr.GlobalConstant.SoloTreasureCurrent.ConstantValue
  local CoinIconPath = DataMgr.Resource[ResourceId].Icon
  local CoinObj = LoadObject(CoinIconPath)
  if CoinObj then
    self.Icon_Cost:SetBrushFromTexture(CoinObj)
  end
  if self.Img_Map and StoryRow.DungeonImage then
    local MapImgObj = LoadObject(StoryRow.DungeonImage)
    if MapImgObj then
      self.Img_Map:SetBrushFromTexture(MapImgObj)
    end
  end
  local DungeonId = StoryRow.DungeonId
  local TotalTime = SoloTreasureDataModel:GetDungeonGameTotalTime(DungeonId)
  local TimeStr = self:FormatTimeMS(TotalTime)
  self.Text_Time:SetText(TimeStr)
  if self.Icon_Bird then
    local CurStageIndex = Result.CurStageIndex
    local OldStageIndex, _ = SoloTreasureDataModel:GetLastStageBirdEx(self.EventId)
    self:UpdateBirdState(CurStageIndex, OldStageIndex)
  end
end

function LevelDetails:UpdateBirdState(CurStageIndex, OldStageIndex)
  if not CurStageIndex then
    return
  end
  OldStageIndex = OldStageIndex or CurStageIndex
  self.CurBirdStage = OldStageIndex
  self:ChangeBirdTexture(OldStageIndex)
  self:PlayBirdIn(OldStageIndex)
  if CurStageIndex == OldStageIndex then
    return
  end
  if self.CurBirdStage == CurStageIndex then
    return
  end
  self.PendingBirdStage = CurStageIndex
  self:AddTimer(1, function()
    self:PlayBirdOut()
  end, nil, nil, nil, true)
end

function LevelDetails:ChangeBirdTexture(StateIndex)
  local TexturePath = self.TreasureHuntProgressData[StateIndex].PetConBP
  local ImgObj = LoadObject(TexturePath)
  if ImgObj then
    if not self.BirdMID then
      self.BirdMID = self.Icon_Bird:GetDynamicMaterial()
    end
    if self.BirdMID then
      self.BirdMID:SetTextureParameterValue("MainTex", ImgObj)
    end
  end
end

function LevelDetails:StopAllBirdAnim()
  for i = 1, 5 do
    local inAnim = self["BirdIn_" .. i]
    if inAnim then
      self:StopAnimation(inAnim)
    end
    local loopAnim = self["BirdLoop_" .. i]
    if loopAnim then
      self:StopAnimation(loopAnim)
    end
  end
end

function LevelDetails:PlayBirdOut()
  self:StopAllBirdAnim()
  local OutAnim = self.BirdOut
  self.BirdOutAnim = OutAnim
  self:PlayAnimation(OutAnim)
end

function LevelDetails:PlayBirdIn(StageIndex)
  local InAnim = self["BirdIn_" .. StageIndex]
  self.CurBirdInAnim = InAnim
  if InAnim then
    self:PlayAnimation(InAnim)
  end
  local LoopAnim = self["BirdLoop_" .. StageIndex]
  if LoopAnim then
    self:PlayAnimation(LoopAnim, 0, 0)
  end
end

function LevelDetails:PlayBirdLoop(StageIndex)
  local LoopAnim = self["BirdLoop_" .. StageIndex]
  if LoopAnim then
    self:PlayAnimation(LoopAnim, 0, 0)
  end
end

function LevelDetails:OnAnimationFinished(Animation)
  if self.BirdOutAnim and Animation == self.BirdOutAnim then
    self.BirdOutAnim = nil
    if self.PendingBirdStage then
      self.CurBirdStage = self.PendingBirdStage
      self.PendingBirdStage = nil
      self:ChangeBirdTexture(self.CurBirdStage)
      self:PlayBirdIn(self.CurBirdStage)
    end
    return
  end
  if self.CurBirdInAnim and Animation == self.CurBirdInAnim then
    self.CurBirdInAnim = nil
    if self.CurBirdStage then
      self:PlayBirdLoop(self.CurBirdStage)
      SoloTreasureDataModel:CommitBirdSnapshotByResult(self.EventId, self.NewResult)
    end
    return
  end
end

function LevelDetails:LoadProgressData(Result)
  local EventId = SoloTreasureDataModel:GetEventId()
  if EventId then
    self.EventId = EventId
  end
  local TreasureHuntProgressData = SoloTreasureDataModel:GetTreasureHuntProgressData(self.EventId)
  if not TreasureHuntProgressData then
    DebugPrint(ErrorTag, "--------------TreasureHuntProgressData is nil--------------")
  else
    self.TreasureHuntProgressData = TreasureHuntProgressData
  end
  if Result then
    self.NewResult = Result
  end
end

function LevelDetails:FormatTimeMS(totalSeconds)
  if not totalSeconds or totalSeconds < 0 then
    return "0:00"
  end
  local minutes = math.floor(totalSeconds / 60)
  local seconds = totalSeconds % 60
  return string.format("%d:%02d", minutes, seconds)
end

return LevelDetails
