local WaitingObservationFinishNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode")

function WaitingObservationFinishNode:Init()
  self.SequencePath = nil
  self.PauseMark = nil
  self.MoveSpeed = nil
  self.bHidePlayer = nil
  self.Title = nil
  self.ObservationUI = nil
end

function WaitingObservationFinishNode:Execute(Callback)
  local function ObservationCallback(Result)
    if Result then
      DebugPrint("WaitingObservationFinishNode Success")
      
      Callback("Success")
    else
      DebugPrint("WaitingObservationFinishNode Fail")
      Callback("Fail")
    end
  end
  
  if not self.PauseMark or self.PauseMark == "" then
    self.PauseMark = "Start"
  end
  if not self.Title or "" == self.Title then
    self.Title = "UI_Observation_InfoTitle"
  end
  self.ObservationUI = UIManager(self):LoadUINew("Observation", self.SequencePath, self.PauseMark, self.bHidePlayer, self.Title, self.MoveSpeed, ObservationCallback)
end

function WaitingObservationFinishNode:Clear()
  if IsValid(self.ObservationUI) and self.ObservationUI.Interrupt then
    self.ObservationUI:Interrupt()
  end
  self.ObservationUI = nil
end

return WaitingObservationFinishNode
