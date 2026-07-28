require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local InGameModel = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingInGameModel")

function M:Construct()
  self.MoveSpeed = 300
  self.BaseMoveSpeed = self.MoveSpeed
  self.StartX = 900
  self.StartY = 0
  self.EndX = -900
  self.CurX = self.StartX
  self.CurY = self.StartY
  self.bMoving = false
  self.MoveTweenHandle = nil
  EventManager:AddEvent(EventID.OnRaceGameTimesSet, self, self.OnRaceGameTimesSet)
end

function M:Init(PlayerId, InsideBuffId, StartX, StartY, LaneIndex)
  local PlayerInfo = DataMgr.RaceLotteryPlayer[PlayerId]
  if not PlayerInfo then
    return
  end
  local PlayerIcon = PlayerInfo.PlayerIcon
  local IconDice = LoadObject(PlayerIcon)
  local InsideBuff = DataMgr.RaceLotteryInsideBuff[InsideBuffId]
  if IconDice then
    self.Image_Icon:SetBrushFromTexture(IconDice)
  end
  local PlayerName = PlayerInfo.PlayerName
  local SkillDes = string.format(GText(InsideBuff.InsideBuffDes), GText(PlayerName))
  self.Text_Scrolling:SetText(SkillDes)
  self:ForceLayoutPrepass()
  self.LaneIndex = LaneIndex
  self.StartX = StartX or self.StartX
  self.StartX = self.StartX + self:GetHalfWidth()
  self.StartY = StartY or self.StartY
  self.CurX = self.StartX
  self.CurY = self.StartY
  InGameModel:SetScrollingLaneWidget(self.LaneIndex, self)
  self:SetRenderTranslation(FVector2D(self.CurX, self.CurY))
  self:StartMoveTimer()
end

function M:StartMoveTimer()
  self:StopMoveTimer()
  local StartPos = FVector2D(self.StartX, self.StartY)
  local EndPos = FVector2D(self.EndX, self.StartY)
  local Speed = InGameModel:GetRaceGameSpeed()
  local MoveSpeed = self.MoveSpeed * Speed or 0
  local MoveDuration = MoveSpeed > 0 and math.abs(self.StartX - self.EndX) / MoveSpeed or 0
  self.CurX = StartPos.X
  self.CurY = StartPos.Y
  self:SetRenderTranslation(StartPos)
  if MoveDuration <= 0 then
    self:SetRenderTranslation(EndPos)
    self:RemoveFromParent()
    return
  end
  self.bMoving = true
  self.MoveTweenHandle = UE4.ULTweenBPLibrary.Vector2To(self, {
    self,
    function(_, Value)
      self.CurX = Value.X
      self.CurY = Value.Y
      self:SetRenderTranslation(Value)
    end
  }, StartPos, EndPos, MoveDuration, 0, 0)
  self.MoveTweenHandle:OnComplete({
    self,
    function()
      self.MoveTweenHandle = nil
      self.bMoving = false
      self:RemoveFromParent()
    end
  })
  local LTweenActor = UE4.ALTweenActor.GetLTweenInstance(self.MoveTweenHandle)
  if LTweenActor then
    LTweenActor:SetTickableWhenPaused(true)
  end
end

function M:StopMoveTimer()
  self.bMoving = false
  if self.MoveTweenHandle then
    ULTweenBPLibrary.KillIfIsTweening(self, self.MoveTweenHandle)
    self.MoveTweenHandle = nil
  end
end

function M:OnRaceGameTimesSet(Speed)
  if not self.bMoving then
    return
  end
  self.MoveSpeed = self.BaseMoveSpeed * Speed
  local CurX = self.CurX or self.StartX
  local CurY = self.CurY or self.StartY
  if CurX <= self.EndX then
    self:StopMoveTimer()
    self:RemoveFromParent()
    return
  end
  if self.MoveTweenHandle then
    ULTweenBPLibrary.KillIfIsTweening(self, self.MoveTweenHandle, false)
    self.MoveTweenHandle = nil
  end
  local StartPos = FVector2D(CurX, CurY)
  local EndPos = FVector2D(self.EndX, CurY)
  local MoveDuration = math.abs(CurX - self.EndX) / self.MoveSpeed
  if MoveDuration <= 0 then
    self:SetRenderTranslation(EndPos)
    self:RemoveFromParent()
    return
  end
  self.MoveTweenHandle = UE4.ULTweenBPLibrary.Vector2To(self, {
    self,
    function(_, Value)
      self.CurX = Value.X
      self.CurY = Value.Y
      self:SetRenderTranslation(Value)
    end
  }, StartPos, EndPos, MoveDuration, 0, 0)
  self.MoveTweenHandle:OnComplete({
    self,
    function()
      self.MoveTweenHandle = nil
      self.bMoving = false
      self:RemoveFromParent()
    end
  })
  local LTweenActor = UE4.ALTweenActor.GetLTweenInstance(self.MoveTweenHandle)
  if LTweenActor then
    LTweenActor:SetTickableWhenPaused(true)
  end
end

function M:GetHalfWidth()
  local WidgetSize = self:GetDesiredSize()
  return WidgetSize and WidgetSize.X * 0.5 or 0
end

function M:GetHeight()
  self:ForceLayoutPrepass()
  local WidgetSize = self:GetDesiredSize()
  return WidgetSize.Y
end

function M:GetTailX()
  local WidgetWidth = self:GetHalfWidth()
  return (self.CurX or 0) + WidgetWidth
end

function M:Destruct()
  InGameModel:RemoveScrollingLaneWidget(self.LaneIndex, self)
  self:StopMoveTimer()
  EventManager:RemoveEvent(EventID.OnRaceGameTimesSet, self)
end

return M
