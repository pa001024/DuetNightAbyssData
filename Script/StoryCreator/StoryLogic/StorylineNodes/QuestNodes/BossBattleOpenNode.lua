local M = Class("StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode")
local PauseTag = "BossFightOpen"
local FHideGameUIComponent = require("BluePrints.Story.Components.HideGameUIComponent")
local FHideAllMonstersComponent = require("BluePrints.Story.Components.HideAllMonstersComponent")
local FHideAllNpcsComponent = require("BluePrints.Story.Components.HideAllNpcsComponent")

function M:Init()
  self.SequencePath = ""
  self.EnableFadeIn = true
  self.EnableFadeOut = true
  self.EnableSkip = true
  self.PauseGameGlobal = false
  self.DisableMonsterAI = false
  self.DisableNPCAI = false
  self.TalkContext = GWorld.GameInstance:GetTalkContext()
  self.Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  EventManager:AddEvent(EventID.OnHardBossOpeningAllPlayerReady, self, self.OnAllPlayerReadyCallback)
  self.HideGameUIComponent = FHideGameUIComponent:New()
  self.HideAllMonstersComponent = FHideAllMonstersComponent:New()
  self.HideAllNpcsComponent = FHideAllNpcsComponent:New()
end

function M:Execute(Callback)
  self.Callback = Callback
  self:ShowUI()
  self:PlaySequence()
  self.Player:AddDisableInputTag(PauseTag)
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  if GameMode and GameMode.SetPlayerCharacterForceIdle then
    GameMode:SetPlayerCharacterForceIdle(self.Player)
  end
end

function M:Clear()
  self.Player:RemoveClearInputCache()
  self.Player:RemoveDisableInputTag(PauseTag)
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  if GameState then
    GameState:ClientHideHardBossDgActor(false, "Boss")
  end
end

function M:PlaySequence()
  local SequenceAsset = LoadObject(self.SequencePath)
  if not IsValid(SequenceAsset) then
    DebugPrint("Warning: BossBattleOpenNode Sequence路径有误，请检查！！！", self.SequencePath)
    self:OnSequencePlayFinished()
    return
  end
  local transform = UE4.UKismetMathLibrary.MakeTransform(UE4.FVector(0, 0, 0), UE4.FRotator(0, 0, 0), UE4.FVector(1, 1, 1))
  self.LevelSequenceActor = GWorld.GameInstance:GetWorld():SpawnActor(UE4.LoadClass(Const.Talk_LevelSequenceActorPath), transform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
  self.SequencePlayer = self.LevelSequenceActor.SequencePlayer
  self.LevelSequenceActor:SetSequence(SequenceAsset)
  if self.PauseGameGlobal and Utils.IsStandAlone(GWorld.GameInstance) then
    self.TalkContext:OnPausedBegin()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    GameMode:SetGamePaused(PauseTag, true)
    local TS = TalkSubsystem()
    TS:AddIgnorePauseObject(self.LevelSequenceActor)
  end
  self.SequencePlayer.OnFinished:Add(SequenceAsset, function()
    self:OnSequencePlayFinished()
  end)
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  if GameState and GameState:IsInDungeon() then
    self.LoadingUI.Group_Coop:SetVisibility(UIConst.VisibilityOp.Visible)
    self.LoadingUI.Com_Loading:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.LoadingUI.Text_CoopTitle:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  UIManager(GWorld.GameInstance):ClearCachedViewTarget()
  self.SequencePlayer:Play()
  local PlayerController = UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
  UTalkSequenceFunctionLibrary.UpdatePlayerCameraManager(PlayerController)
  if GameState then
    GameState:ClientHideHardBossDgActor(true, "Boss")
  end
end

function M:ShowUI()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  UIManager:HideAllUI(true, Const.BossBattleOpenHideTag)
  self.HideGameUIComponent:SetGameUIHiddenExceptStory(true)
  self.LoadingUI = UIManager:LoadUINew("HardBossBattleOpen", self.EnableFadeIn, self.EnableSkip, self, self.SkipToEnd)
  self.LoadingUI.Text_CoopTitle:SetText(GText("UI_HardBoss_WaitOthers"))
  TeamController:OpenHeadUI(self.LoadingUI.Group_Team)
  TeamController:GetModel():SetIsInOpenCoop(true)
  self.HideAllMonstersComponent:DoHide()
  self.HideAllNpcsComponent:DoHide()
end

function M:SkipToEnd()
  self.SequencePlayer:GoToEndAndStop()
  self:OnSequencePlayFinished()
end

function M:UnShowUI()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  local BossBattleOpenUI = UIManager:GetUIObj("HardBossBattleOpen")
  if self.EnableFadeOut then
    BossBattleOpenUI:BindToAnimationFinished(BossBattleOpenUI.Out, function()
      BossBattleOpenUI:Close()
    end)
    BossBattleOpenUI:PlayAnimation(BossBattleOpenUI.Out)
    BossBattleOpenUI:ShowHardBossTitle(false)
  else
    BossBattleOpenUI:Close()
  end
  UIManager:HideAllUI(false, Const.BossBattleOpenHideTag)
  self.HideGameUIComponent:SetGameUIHiddenExceptStory(false)
  TeamController:GetModel():SetIsInOpenCoop(false)
  self.HideAllMonstersComponent:ResumeHide()
  self.HideAllNpcsComponent:ResumeHide()
end

function M:OnSequencePlayFinished()
  EventManager:RemoveEvent(EventID.OnHardBossOpeningAllPlayerReady, self)
  if self.PauseGameGlobal and Utils.IsStandAlone(GWorld.GameInstance) then
    self.TalkContext:OnPausedEnd()
    local TS = TalkSubsystem()
    TS:ClearIgnorePauseObjects()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    GameMode:SetGamePaused(PauseTag, false)
  end
  self:UnShowUI()
  local Eid = self.Player.MechanismEid
  local Mechanism = Battle(self):GetEntity(Eid)
  if Mechanism then
    Mechanism.ChestInteractiveComponent:EndInteractive(self.Player)
  end
  self.LevelSequenceActor:K2_DestroyActor()
  self.Callback()
  self.SequencePlayer = nil
end

function M:OnAllPlayerReadyCallback()
  if self.SequencePlayer then
    self.SequencePlayer:Play()
  end
end

return M
