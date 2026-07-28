local M = {}
local QTEUIName = "QTE"

function M:TriggerQTE_SingleClick(TriggerObject, WindowSize, TimeDialation, InteractiveUI, InputActionName, InputGamePadActionName, UIPosition, ClickFaultToleranceCount, SuccessCallbackName, SuccessSequence, FailCallbackName, FailSequence, QTEName)
  DebugPrint("QTE: TriggerQTE_SingleClick")
  local Config = {}
  Config.WindowSize = WindowSize
  Config.RealWindowSize = Config.WindowSize * 1
  Config.TriggerObject = TriggerObject
  Config.TimeDialation = TimeDialation
  Config.InteractiveUI = InteractiveUI
  Config.InputActionName = InputActionName
  Config.InputGamePadActionName = InputGamePadActionName
  Config.UIPosition = UIPosition
  Config.ClickFaultToleranceCount = ClickFaultToleranceCount
  Config.SuccessCallbackName = SuccessCallbackName
  Config.SuccessSequence = SuccessSequence
  Config.FailCallbackName = FailCallbackName
  Config.FailSequence = FailSequence
  Config.ClickType = "Single"
  Config.SuccessClickNum = 1
  self:TriggerQTE(TriggerObject, Config)
end

function M:TriggerQTE_MultiClick(TriggerObject, TimeDialation, InteractiveUI, InputActionName, InputGamePadActionName, UIPosition, ClickFaultToleranceCount, SuccessClickNum, bAlwaysSuccess, SuccessCallbackName, SuccessSequence, FailCallbackName, FailSequence)
  DebugPrint("QTE: TriggerQTE_MultiClick")
  local Config = {}
  Config.RealWindowSize = Config.WindowSize or 5
  Config.TriggerObject = TriggerObject
  Config.TimeDialation = TimeDialation
  Config.InteractiveUI = InteractiveUI
  Config.InputActionName = InputActionName
  Config.InputGamePadActionName = InputGamePadActionName
  Config.UIPosition = UIPosition
  Config.ClickFaultToleranceCount = ClickFaultToleranceCount
  Config.SuccessClickNum = SuccessClickNum
  Config.bAlwaysSuccess = bAlwaysSuccess
  Config.SuccessCallbackName = SuccessCallbackName
  Config.SuccessSequence = SuccessSequence
  Config.FailCallbackName = FailCallbackName
  Config.FailSequence = FailSequence
  Config.ClickType = "Multi"
  self:TriggerQTE(TriggerObject, Config)
end

function M:StopWorkingQTE(TriggerObject)
  if not self:IsQTEWorking() then
    return
  end
  DebugPrint("QTE: StopWorkingQTE", TriggerObject)
  local Config = self.WorkingQTEConfig
  self:ResumeQTETimeDilation()
  self:SwitchPlayNextSequence()
  local QTEUI = UIManager(GWorld.GameInstance):GetUIObj(QTEUIName)
  self.bQTESucceed = Config.bAlwaysSuccess or false
  if QTEUI then
    QTEUI:OnTimeOut(self.bQTESucceed, function()
      self:ClearQTE()
    end)
  end
end

function M:ClearQTE()
  DebugPrint("QTE: ClearQTE")
  self:DisableQTEUI()
  self.bQTEWorking = false
  self.WorkingQTEConfig = nil
  self.WorkingSequencePlayer = nil
end

function M:TriggerQTE(TriggerObject, Config)
  if not self:CheckCanWorkingQTE(Config) then
    return
  end
  DebugPrint("QTE: StartQTE", Config, TriggerObject.Player)
  self.bQTEWorking = true
  self.bQTESucceed = false
  self.WorkingQTEConfig = Config
  self.WorkingSequencePlayer = TriggerObject.Player
  self:SwitchBindSequenceEvent(self.WorkingSequencePlayer, true)
  self:EnableQTETimeDilation(Config)
  self:EnableQTEUI(Config)
end

function M:CheckCanWorkingQTE(Config)
  if not IsValid(Config.TriggerObject) then
    return false
  end
  if self:IsQTEWorking() then
    DebugPrint("QTE: 触发窗口重叠/同一QTE多次触发")
    return false
  end
  return true
end

function M:SwitchBindSequenceEvent(SequencePlayer, bBind)
  if not SequencePlayer then
    return
  end
  if bBind then
    SequencePlayer.OnFinished:Add(self, self.OnQTESequencePlayFinished)
    SequencePlayer.OnStop:Add(self, self.OnQTESequencePlayStopped)
  else
    SequencePlayer.OnFinished:Remove(self, self.OnQTESequencePlayFinished)
    SequencePlayer.OnStop:Remove(self, self.OnQTESequencePlayStopped)
  end
end

function M:OnQTESequencePlayStopped()
  DebugPrint("QTE: OnQTESequencePlayStopped")
  self:SwitchBindSequenceEvent(self.WorkingSequencePlayer, false)
  self:ClearQTE()
end

function M:OnQTESequencePlayFinished()
  DebugPrint("QTE: OnQTESequencePlayFinished")
  self:SwitchBindSequenceEvent(self.WorkingSequencePlayer, false)
  self:ClearQTE()
end

function M:EnableQTETimeDilation(Config)
  self.bHasResumeQTETimeDilation = false
  if 0 == Config.TimeDialation then
    Config.TimeDialation = 0.01
  end
  DebugPrint("QTE: 更改全局时间膨胀", Config.TimeDialation)
  Config.OriGlobalTimeDilation = UE4.UGameplayStatics.GetGlobalTimeDilation(self)
  UE4.UGameplayStatics.SetGlobalTimeDilation(self, Config.TimeDialation)
end

function M:ResumeQTETimeDilation()
  if self.bHasResumeQTETimeDilation then
    return
  end
  local Config = self.WorkingQTEConfig
  self.bHasResumeQTETimeDilation = true
  if Config and Config.OriGlobalTimeDilation then
    DebugPrint("QTE: 恢复全局时间膨胀", Config.OriGlobalTimeDilation)
    UE4.UGameplayStatics.SetGlobalTimeDilation(self, Config.OriGlobalTimeDilation)
  else
    DebugPrint("QTE: warning ResumeQTETimeDilation without ori TimeDilation, Use Default 1.0 GlobalTimeDilation")
    UE4.UGameplayStatics.SetGlobalTimeDilation(self, 1.0)
  end
end

function M:EnableQTEUI(Config)
  DebugPrint("QTE: EnableQTEUI", QTEUIName)
  local UI = UIManager(GWorld.GameInstance):LoadUINew(QTEUIName)
  UI:SetOnSuccCallback(self, self.OnQTESucceed)
  UI:SetOnFailCallback(self, self.OnQTEFailed)
  UI:ResponseQTE(Config)
end

function M:DisableQTEUI()
  UIManager(GWorld.GameInstance):UnLoadUINew(QTEUIName)
end

function M:IsQTEWorking()
  return self.bQTEWorking
end

function M:OnQTESucceed()
  DebugPrint("QTE: QTE响应成功")
  self.bQTESucceed = true
  self:ResumeQTETimeDilation()
end

function M:OnQTEFailed()
  DebugPrint("QTE: QTE响应失败")
  self.bQTESucceed = false
  self:ResumeQTETimeDilation()
end

function M:SwitchPlayNextSequence()
  local Config = self.WorkingQTEConfig
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  local NextCallbackName, NextSequence
  if self.bQTESucceed then
    NextCallbackName = Config.SuccessCallbackName
    NextSequence = Config.SuccessSequence
  else
    NextCallbackName = Config.FailCallbackName
    NextSequence = Config.FailSequence
  end
  if GameMode and NextCallbackName then
    GameMode:PostCustomEvent(NextCallbackName)
  end
  self:TryPlayNextSequence(Config, NextSequence)
end

function M:TryPlayNextSequence(Config, Sequence)
  if not IsValid(Sequence) then
    return
  end
  if not self:IsQTEWorking() then
    return
  end
  DebugPrint("QTE: TryPlayNextSequence", Sequence)
  local SP = Config.TriggerObject.Player
  SP:Stop()
  local LevelSequenceActorClass = UE4.LoadClass(Const.Talk_LevelSequenceActorPath)
  local DefaultTrans = UE4.UKismetMathLibrary.MakeTransform(UE4.FVector(0, 0, 0), UE4.FRotator(0, 0, 0), UE4.FVector(1, 1, 1))
  local World = self:GetWorld()
  local SequenceActor = World:SpawnActor(LevelSequenceActorClass, DefaultTrans, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
  SequenceActor:SetSequence(Sequence)
  SequenceActor.SequencePlayer:Play()
end

return M
