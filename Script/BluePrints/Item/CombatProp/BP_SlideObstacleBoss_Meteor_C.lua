require("UnLua")
local M = Class({
  "BluePrints/Item/CombatProp/BP_CombatPropBase_C",
  "BluePrints.Common.TimerMgr"
})
local GAME_BUFF_ID = 62
local LAYER_BUFF_ID = 63

function M:ReceiveBeginPlay()
  self:InitFlowControlParams()
  self:InitOverlapEvent()
  self:InitClickCount()
end

function M:AuthorityInitInfo(Info)
  M.Super.AuthorityInitInfo(self, Info)
  local NeedAttach = Info.BoolParams:FindRef("NeedAttach")
  local BossMechanism = Info.DirectSource
  local PosIndex = Info.IntParams:FindRef("PosIndex")
  if NeedAttach then
    local PosComp = BossMechanism["Pos" .. PosIndex]
    local ArrowComp = BossMechanism["Arrow" .. PosIndex]
    if PosComp and ArrowComp then
      self:K2_SetActorLocationAndRotation(PosComp:K2_GetComponentLocation(), ArrowComp:K2_GetComponentRotation(), false, nil, false)
    end
    self:K2_AttachToComponent(BossMechanism.Core, "None", UE4.EAttachmentRule.KeepWorld, UE4.EAttachmentRule.KeepWorld, UE4.EAttachmentRule.KeepWorld, false)
  end
end

function M:OnActorReady(Info)
  M.Super.OnActorReady(self, Info)
  self.BossMechanism = Info.DirectSource
  if self.BossMechanism then
    self:SetActorHiddenInGame(true)
    local AttachComp = self.BossMechanism.Core or self.BossMechanism:K2_GetRootComponent()
    self.AbsorbFXComp = self.FXComponent:PlayFX(self.AbsorbFX, AttachComp, nil, FVector(0, 0, 0), FRotator(0, 0, 0), false, nil)
    self.Absorb2FXComp = self.FXComponent:PlayFX(self.Absorb2FX, AttachComp, nil, FVector(0, 0, 0), FRotator(0, 0, 0), false, nil)
    self:AddTimer(self.AbsorbDuration, function()
      self:OnAbsorbFXFinished()
    end)
    AudioManager(self):PlayNormalSound(self, nil, "event:/sfx/common/scene/ex02/rail_rock_charge", "Absorb")
  end
end

function M:OnAbsorbFXFinished()
  if self.AbsorbFXComp then
    self.AbsorbFXComp:Deactivate()
  end
  if self.Absorb2FXComp then
    self.Absorb2FXComp:Deactivate()
  end
  self:SetActorHiddenInGame(false)
  self.FlyingFXComp = self.FXComponent:PlayFX(self.FlyingFX, self.Mesh, nil, FVector(0, 0, 0), FRotator(0, 0, 0), false, nil)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if Player then
    self.BP_MechanismMoveToComponent:StartMovingToTarget(Player, 1000)
  end
  AudioManager(self):PlayNormalSound(self, nil, "event:/sfx/common/scene/ex02/rail_rock_shot", "Shot")
  AudioManager(self):PlayNormalSound(self, nil, "event:/sfx/common/scene/ex02/rail_rock_loop", "Flying")
end

function M:InitFlowControlParams()
  self.IsClickGameBegin = false
  self.IsClickGameEnd = false
  self.IsTriggeredHit_Player = false
  self.IsTriggeredHit_Boss = false
  self.IsQTEToastActive = false
end

function M:InitOverlapEvent()
  self.SphereSlow.OnComponentBeginOverlap:Add(self, self.OnBeginOverlap_SphereSlow)
  self.SphereHit.OnComponentBeginOverlap:Add(self, self.OnBeginOverlap_SphereHit)
end

function M:InitClickCount()
  self.CurClickCount = 0
  self.MinClickCount = DataMgr.MovementParams.ClickGameMinCount.ParamValue
  self.MaxClickCount = DataMgr.MovementParams.ClickGameMaxCount.ParamValue
  self.ClickInterval = DataMgr.MovementParams.ClickGameInterval.ParamValue
end

function M:OnBeginOverlap_SphereSlow(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex, bFromSweep, SweepResult)
  if OtherActor.IsPlayer and OtherActor:IsPlayer() then
    DebugPrint("SlideObstacleBoss_Meteor OnBeginOverlap_SphereSlow Player!", self.IsClickGameBegin)
    self.Player = OtherActor
    self:OnClickGameBegin()
  end
end

function M:OnBeginOverlap_SphereHit(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex, bFromSweep, SweepResult)
  if OtherActor.IsPlayer and OtherActor:IsPlayer() then
    DebugPrint("SlideObstacleBoss_Meteor OnBeginOverlap_SphereHit Player!", self.IsTriggeredHit_Player)
    if self.IsTriggeredHit_Player then
      return
    end
    self.IsTriggeredHit_Player = true
    self:OnClickGameEnd("HitPlayer")
  end
end

function M:OnClickGameBegin()
  if self.IsClickGameBegin then
    return
  end
  self.IsClickGameBegin = true
  self:InitGameBuff()
  self:EnableQTEUI()
  self:SetQTEGuideToastActive(true)
end

function M:InitGameBuff()
  Battle(self):AddBuffToTarget(self, self.Player, GAME_BUFF_ID, -1)
  self:BindBuffEvent()
end

function M:BindBuffEvent()
  if self.BuffEventBound then
    return
  end
  if not IsValid(self.Player) or not self.Player.BuffManager then
    return
  end
  self.BuffRemovedDelegate = {
    self,
    self.OnBuffRemoved_ClickGame
  }
  self.BuffLayerChangedDelegate = {
    self,
    self.OnBuffLayerChanged
  }
  self.Player.BuffManager:BP_BindOnBuffRemoved(GAME_BUFF_ID, self.BuffRemovedDelegate)
  self.Player.BuffManager:BP_BindOnBuffRefreshed(LAYER_BUFF_ID, self.BuffLayerChangedDelegate)
  self.BuffEventBound = true
end

function M:UnbindBuffEvent()
  if not self.BuffEventBound then
    return
  end
  self.BuffEventBound = false
  if not IsValid(self.Player) or not self.Player.BuffManager then
    self.BuffRemovedDelegate = nil
    self.BuffLayerChangedDelegate = nil
    return
  end
  self.Player.BuffManager:BP_UnbindOnBuffRemoved(GAME_BUFF_ID, self.BuffRemovedDelegate)
  self.Player.BuffManager:BP_UnbindOnBuffRefreshed(LAYER_BUFF_ID, self.BuffLayerChangedDelegate)
  self.BuffRemovedDelegate = nil
  self.BuffLayerChangedDelegate = nil
end

function M:OnBuffLayerChanged(Buff)
  if not self.IsClickGameBegin or self.IsClickGameEnd then
    return
  end
  if not Buff then
    return
  end
  local NewLayer = Buff.Layer or 0
  if NewLayer == self.CurClickCount then
    return
  end
  self.CurClickCount = NewLayer
  DebugPrint("SlideObstacleBoss_Meteor: OnBuffLayerChanged LayerCount:", self.CurClickCount)
  if self.OnMeteorLightHit then
    self:OnMeteorLightHit(self.Player, self.CurClickCount)
  end
  self:OnReceiveClick()
end

function M:OnBuffRemoved_ClickGame(Buff, RemovedReason)
  if not self.IsClickGameBegin or self.IsClickGameEnd then
    return
  end
  self:OnClickGameEnd("BuffRemoved")
end

local QTEUIName = "QTE"
local QTE_GUIDE_TOAST_KEY = "QTE_GuideToast"
local QTE_TOAST_TEXT_KEY = "UI_Track_Toast02"

function M:EnableQTEUI()
  DebugPrint("QTE: EnableTrackQTE")
  local Config = {
    InputActionName = "LeftMouseButton",
    InputGamePadActionName = "X",
    UIPosition = "3",
    ClickFaultToleranceCount = -1,
    SuccessClickNum = self.MaxClickCount,
    OnSuccCallback = nil,
    OnFailCallback = nil,
    bHideUnderlyingUI = true,
    ClickType = "Multi",
    MultiQTEMode = 2,
    bBlockProgressRefreshed = true
  }
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if Player then
    Player:AddDisableInputTag("QTE")
  end
  self.QTEUI = UIManager(GWorld.GameInstance):LoadUINew(QTEUIName)
  self.QTEUI:SetOnCorrectClickCallback(self, self.OnQTECorrectClick)
  self.QTEUI:ResponseQTE(Config)
end

function M:SetQTEGuideToastActive(bIsActive)
  if CommonUtils.GetDeviceTypeByPlatformName() ~= CommonConst.CLIENT_DEVICE_TYPE.MOBILE then
    return
  end
  self.IsQTEToastActive = bIsActive
  local UIMgr = UIManager(self)
  if not bIsActive then
    local Panel = UIMgr:GetUIObj(QTE_GUIDE_TOAST_KEY)
    if Panel then
      Panel:DeleteGuideMessage(true)
    end
    return
  end
  local Panel = UIMgr:GetUIObj(QTE_GUIDE_TOAST_KEY)
  if Panel then
    Panel:GuideUIInit_String(QTE_GUIDE_TOAST_KEY, GText(QTE_TOAST_TEXT_KEY), -1, "", false, false)
    return
  end
  UIMgr:LoadUI(UIConst.GUIDETEXTFLOAT, QTE_GUIDE_TOAST_KEY, UIConst.ZORDER_FOR_COMMON_TIP, function(UIObj)
    if not IsValid(UIObj) then
      return
    end
    if not self.IsQTEToastActive then
      UIMgr:UnLoadUI(QTE_GUIDE_TOAST_KEY)
      return
    end
    local ToastList = UIMgr:GetUIObj("CommonTopToastList")
    if not ToastList then
      ToastList = UIMgr:LoadUINew("CommonTopToastList")
    elseif ToastList:IsHide() then
      ToastList:ClearAllHideTags()
      ToastList:Show()
    end
    UIObj:RemoveFromParent()
    ToastList.VerticalBox_Toast:AddChild(UIObj)
    UIObj:GuideUIInit_String(QTE_GUIDE_TOAST_KEY, GText(QTE_TOAST_TEXT_KEY), -1, "", false, false)
  end, "Async")
end

function M:OnQTECorrectClick(ClickCount)
  DebugPrint("SlideObstacleBoss_Meteor: OnQTECorrectClick ClickCount:", ClickCount)
  self:SetQTEGuideToastActive(false)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if Player then
    Player:ActionCallback("Attack", EInputEvent.IE_Pressed)
    Player:ActionCallback("Attack", EInputEvent.IE_Released)
  end
end

function M:UpdateQTEProgress()
  if not IsValid(self.QTEUI) or not self.QTEUI.ProgressBarMat then
    return
  end
  local MaxClickCount = self.MaxClickCount and self.MaxClickCount > 0 and self.MaxClickCount or 1
  local Percent = (self.CurClickCount or 0) / MaxClickCount
  self.QTEUI.ProgressBarMat:SetScalarParameterValue("Percent", Percent)
end

function M:OnReceiveClick()
  if not self.IsClickGameBegin or self.IsClickGameEnd then
    return
  end
  self:RemoveTimer("ClickIntervalTimer")
  EventManager:FireEvent(EventID.OnSlideBossClickCountChange, self.CurClickCount)
  self:UpdateQTEProgress()
end

function M:CleanupQTE(bIsSuccess)
  DebugPrint("QTE: StopTrackQTE")
  if self.QTEUI then
    self.QTEUI:OnTimeOut(bIsSuccess, function()
      UIManager(self):UnLoadUINew(QTEUIName)
    end)
  end
  self.QTEUI = nil
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if Player then
    Player:RemoveDisableInputTag("QTE")
  end
end

function M:OnClickGameEnd(EndReason)
  if not self.IsClickGameBegin or self.IsClickGameEnd then
    return
  end
  self.IsClickGameEnd = true
  DebugPrint("SlideObstacleBoss_Meteor: OnClickGameEnd EndReason", EndReason)
  self:SetQTEGuideToastActive(false)
  AudioManager(self):StopSound(self, "Flying")
  if "HitPlayer" == EndReason then
    Battle(self):RemoveBuffFromTarget(self, self.Player, GAME_BUFF_ID, false, -1)
    self:OnClickGameFail()
    return
  end
  if self.CurClickCount >= self.MinClickCount then
    self:OnClickGameSucceed()
  else
    self:OnClickGameFail()
  end
end

function M:OnClickGameSucceed()
  self.BP_MechanismMoveToComponent:StartMovingToTarget(self.BossMechanism, 3000, self.OnHitBoss, self.FlyToBossOffset)
  self:CleanupQTE(true)
  if self.OnMeteorHeavyHit then
    self:OnMeteorHeavyHit(self.Player)
  end
end

function M:OnHitBoss()
  self.BP_MechanismMoveToComponent:StopMoving()
  if self.FlyingFXComp then
    self.FlyingFXComp:Deactivate()
  end
  DebugPrint("SlideObstacleBoss_Meteor OnHitBoss !", self.IsTriggeredHit_Boss)
  if self.IsTriggeredHit_Boss then
    return
  end
  self.IsTriggeredHit_Boss = true
  DebugPrint("SlideObstacleBoss_Meteor: OnHitBoss 这里播放特效!!! ")
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  GameMode:PostCustomEvent("OnHitSlideObstacleBoss")
  self:PlayExplosionAndDestroy()
end

function M:PlayExplosionAndDestroy()
  self:SetActorHiddenInGame(true)
  self.ExplosionFXComp = self.FXComponent:PlayFX(self.ExplosionFX, nil, nil, self:K2_GetActorLocation(), FRotator(0, 0, 0), true, nil)
  if self.ExplosionFXComp then
    self.ExplosionFXComp.OnSystemFinished:Add(self, self.OnExplosionFXFinished)
  else
    self:EMActorDestroy(EDestroyReason.DungeonNormal)
  end
  AudioManager(self):PlayNormalSound(self, nil, "event:/sfx/common/scene/ex02/rail_rock_exp", "Explosion")
end

function M:OnExplosionFXFinished()
  self:EMActorDestroy(EDestroyReason.DungeonNormal)
end

function M:OnClickGameFail()
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  GameMode:PostCustomEvent("OnClickGameFail")
  if self.BossMechanism and self.BossMechanism.OnClickGameFail then
    self.BossMechanism:OnClickGameFail()
  end
  self.BP_MechanismMoveToComponent:StopMoving()
  if self.FlyingFXComp then
    self.FlyingFXComp:Deactivate()
  end
  self:PlayExplosionAndDestroy()
  self:CleanupQTE(false)
end

function M:ReceiveEndPlay(Reason)
  M.Super.ReceiveEndPlay(self, Reason)
  self:UnbindBuffEvent()
  self.BP_MechanismMoveToComponent:StopMoving()
end

return M
