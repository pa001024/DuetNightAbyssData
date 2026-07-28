local M = Class({
  "BluePrints/Item/CombatProp/BP_Paotai_C"
})

function M:CommonInitInfo(Info)
  M.Super.CommonInitInfo(self, Info)
  self:SetbCanTriggerGameMode(true)
  if IsAuthority(self) then
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState then
      print(_G.LogTag, "gyy BP_Paotai_Weekly_C RegisterGameModeEvent OnDisconnect")
      GameState:RegisterGameModeEvent("OnDisconnect", self, self.OnDisconnect)
    end
  end
end

function M:GetCanTriggerGameMode()
  return self.bCanTriggerGameMode
end

function M:SetbCanTriggerGameMode(v)
  self.bCanTriggerGameMode = v
  UE4.UNetPushModelHelpers.MarkPropertyDirty(self, "bCanTriggerGameMode")
end

function M:OnEnterState(NowStateId)
  self.Overridden.OnEnterState(self, NowStateId)
  if NowStateId == self.CompleteStateId then
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    GameState.DefBaseMap:Remove(self.Eid)
    GameState.HatredCombatProp:Remove(self.Eid)
    self:SetbCanTriggerGameMode(false)
  end
end

function M:OpenMechanism(PlayerEid)
  print(_G.LogTag, "LXZ OpenMechanism")
  self.OpenState = true
end

function M:CloseMechanism(PlayerEid)
  self.OpenState = false
  if IsAuthority(self) then
    self:Cancel(PlayerEid)
  end
end

function M:OpenUI(PlayerEid)
  if IsAuthority(self) and not IsStandAlone(self) then
    return
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if Player and Player.Eid == PlayerEid then
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    self.PaoTaiBattleFront = UIManager:LoadUINew("BattleFort02", self.Eid, true)
  end
end

function M:CloseUI(PlayerEid)
  self.OpenState = false
  if IsAuthority(self) and not IsStandAlone(self) then
    return
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if Player and Player.Eid == PlayerEid and IsValid(self.PaoTaiBattleFront) then
    self.PaoTaiBattleFront:Close()
    self.PaoTaiBattleFront = nil
  end
end

function M:SetActiveType()
  self.ActiveType = ""
end

function M:EndInteractive(Player)
  self.ChestInteractiveComponent:EndInteractive(Player)
end

function M:OnDisconnect(AvatarEidStr)
  print(_G.LogTag, "gyy BP_Paotai_Weekly_C OnDisconnect")
  if self.OpenState and self.PlayerEid then
    local Player = Battle(self):GetEntity(self.PlayerEid)
    if Player and Player.PlayerState then
      local PlayerAvatarEidStr = Player.PlayerState.AvatarEidStr
      if PlayerAvatarEidStr == AvatarEidStr then
        print(_G.LogTag, "gyy BP_Paotai_Weekly_C OnDisconnect CloseMechanism")
        self:CloseMechanism(self.PlayerEid)
      end
    end
  end
end

function M:ReceiveEndPlay()
  if IsAuthority(self) then
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState then
      print(_G.LogTag, "gyy BP_Paotai_Weekly_C RemoveGameModeEvent OnDisconnect")
      GameState:RemoveGameModeEvent("OnDisconnect", self, self.OnDisconnect)
    end
  end
  self:CloseUI(self.PlayerEid)
end

return M
