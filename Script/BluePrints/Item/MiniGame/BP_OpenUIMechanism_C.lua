require("UnLua")
local M = Class("BluePrints/Item/Chest/BP_MechanismBase_C")

function M:AuthorityInitInfo(Info)
  M.Super.AuthorityInitInfo(self, Info)
  self.CanOpen = true
end

function M:CommonInitInfo(Info)
  M.Super.CommonInitInfo(self, Info)
  self.InteractiveType = Const.EndByTargetInteractive
  self.CanOpen = true
  self.ExtraInfo = {}
  for i, v in pairs(self.UnitParams) do
    if "UIName" == i then
      self.UIName = self.UnitParams.UIName or "HardBossLevelChoose"
    else
      self.ExtraInfo[i] = v
    end
  end
end

function M:OnActorReady(Info)
  M.Super.OnActorReady(self, Info)
  local StateData = DataMgr.MechanismState[self.StateId]
  if StateData and StateData.StateEvent then
    for i, v in pairs(StateData.StateEvent) do
      if v.TypeNextState and v.TypeNextState.Type == "InteractDone" then
        self:ChangeState("InteractDone", 0)
      end
    end
  end
end

function M:OpenMechanism(PlayerId)
end

function M:OpenUI(PlayerEid, NextStateId)
  self.UINextStateId = NextStateId
  self:BroadcastOpenMechanism(PlayerEid)
end

function M:CloseMechanism(PlayerId)
  if IsAuthority(self) then
    self.CombatStateChangeComponent:TriggerOnEventEnd(self.UINextStateId)
    if self.bIsSuccess then
      self:ChangeState("InteractDone", PlayerId)
    else
      self:ChangeState("InteractBreak", PlayerId)
    end
  end
  self:BroadcastCloseMechanism(PlayerId)
end

function M:BroadcastOpenMechanism_Lua(PlayerId)
  if IsAuthority(self) and not IsStandAlone(self) then
    return
  end
  if UE4.UGameplayStatics.GetPlayerCharacter(self, 0).Eid ~= PlayerId then
    return
  end
  self:LoadGameUI(PlayerId)
end

function M:BroadcastCloseMechanism_Lua(PlayerId)
  if IsAuthority(self) and not IsStandAlone(self) then
    return
  end
  if UE4.UGameplayStatics.GetPlayerCharacter(self, 0).Eid ~= PlayerId then
    return
  end
  self:UnLoadGameUI(PlayerId)
end

function M:LoadGameUI(PlayerId)
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance:GetGameUIManager()
  UIManager:CloseResidentUI()
  local PlayerCharacter = Battle(self):GetEntity(PlayerId)
  PlayerCharacter:SetCharacterTag("Interactive")
  self.CurrentUI = self:RealLoadGameUI()
  self.CanOpen = false
end

function M:RealLoadGameUI()
  return UIManager(self):LoadUINew(self.UIName, self.ExtraInfo)
end

function M:UnLoadGameUI(PlayerId)
  if UE4.UGameplayStatics.GetPlayerPawn(self, 0).Eid ~= PlayerId then
    return
  end
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance:GetGameUIManager()
  UIManager:OpenResidentUI()
  local PlayerCharacter = Battle(self):GetEntity(PlayerId)
  local Controller = UE4.UGameplayStatics.GetPlayerController(self, 0)
  if PlayerCharacter.AutoSyncProp.CharacterTag == "Interactive" then
    PlayerCharacter:SetCharacterTagIdle()
  end
  self.CanOpen = true
end

function M:EndInteractive(Player, bIsSuccess)
  self:SetVariableBool("bIsSuccess", bIsSuccess, Player.Eid)
  self.ChestInteractiveComponent:EndInteractive(Player)
end

function M:ForceCloseMechanism(PlayerEid)
  self:SetVariableBool("bIsSuccess", true, PlayerEid)
  if self.CurrentUI then
    self.CurrentUI:Close()
  end
  self:CloseMechanism(PlayerEid)
end

function M:GetCanOpen(PlayerEid)
  local Battle = Battle(self)
  if not Battle then
    return
  end
  local Player = Battle:GetEntity(PlayerEid)
  if Player and not Player:CanEnterInteractive() then
    self.CanOpen = false
  else
    self.CanOpen = true
  end
end

return M
