local SplineMoveStartNode = Class("StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode")

function SplineMoveStartNode:Init()
  self.SplineActorIndex = 0
  self.WalkType = 0
  self.MoveSpeedRate = 1.0
  self.bEnableCameraSeq = false
  self.bEnableCameraBlend = false
  self.IsTriggerable = false
  self.UseEndOverlapBox = true
  self.CanMoveReverse = false
  self.CanExitSpline = false
  self.GuideCameraToStart = true
  self.bStartOverlap = false
  self.StopAtEndPoint = false
end

function SplineMoveStartNode:Start(Context)
  local GameInstance = GWorld.GameInstance
  DebugPrint("SplineMoveStartNode ", GameInstance)
  local CinemaMoveSpline = URuntimeCommonFunctionLibrary.FindCinemaMoveSplineByIndex(self.SplineActorIndex, GameInstance)
  if not IsValid(CinemaMoveSpline) then
    GWorld.logger.error("SplineMoveStartNode:Start, CinemaMoveSpline not found!, SplineActorIndex: " .. tostring(self.SplineActorIndex))
    self:Finish()
    return
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
  local Res = CinemaMoveSpline:SplineInit(Player, self.WalkType, self.MoveSpeedRate, self.CanMoveReverse, self.CanExitSpline, self.IsTriggerable, self.StopAtEndPoint, self.UseEndOverlapBox, self.GuideCameraToStart)
  if not Res then
    self:Finish()
    return
  end
  CinemaMoveSpline:SplineStart()
  self:Finish()
end

return SplineMoveStartNode
