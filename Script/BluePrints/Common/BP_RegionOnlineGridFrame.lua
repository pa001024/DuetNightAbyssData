local M = Class("BluePrints.Common.TimerMgr")

function M:Initialize(Initializer)
  EventManager:AddEvent(EventID.SpecialQuestCloseRegionOnline, self, self.CloseTrigger)
  EventManager:AddEvent(EventID.SpecialQuestOpenRegionOnline, self, self.StartTrigger)
  EventManager:AddEvent(EventID.ChangeRegionOnline, self, self.OnChangeRegionOnline)
  self:AddEvents()
end

local ForceRegionOnlineRegionIDList = {
  [104104] = 1,
  [104106] = 1,
  [104108] = 1,
  [104109] = 1,
  [104110] = 1,
  [104901] = 1,
  [999701] = 1,
  [999702] = 1,
  [999703] = 1,
  [999704] = 1,
  [999705] = 1
}

function M:ForceCompleteCondition()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local OnlineConditions = {}
  local RegionOnlineData = DataMgr.RegionOnline[self.SubRegionId]
  if RegionOnlineData then
    table.insert(OnlineConditions, RegionOnlineData.OnlineCondition)
  end
  local GM_Command = require("BluePrints.Client.GM_Command")
  GM_Command:CompleteCondition(OnlineConditions)
end

function M:EnterTrigger()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local flag = false
  if URuntimeCommonFunctionLibrary.IsPlayInEditor(self) and self.SubRegionId and ForceRegionOnlineRegionIDList[self.SubRegionId] then
    self:ForceCompleteCondition()
    flag = true
  end
  if not flag then
    local Condition = ConditionUtils.CheckCondition(Avatar, DataMgr.RegionOnline[self.SubRegionId].OnlineCondition)
    if false == Condition then
      DebugPrint("Condition不满足")
      return
    end
  end
  local CloseCondition = ConditionUtils.CheckCondition(Avatar, DataMgr.RegionOnline[self.SubRegionId].OfflineCondition)
  if CloseCondition and DataMgr.RegionOnline[self.SubRegionId].OfflineCondition then
    DebugPrint("CloseCondition满足")
    return
  end
  if self.OpenTags then
    local Empty = IsEmptyTable(self.OpenTags)
    if not Empty then
      return
    end
  end
  self.bShouldEndDeliveryMontage = GWorld.GameInstance.ShouldPlayDeliveryEndMontage
  local Res = self:CheckIdleTag()
  if not Res then
    self:AddTimer(0.1, self.CheckIdleTag, true, 0, "CheckIdleTagTimer")
  end
end

function M:CheckIdleTag()
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not self.bShouldEndDeliveryMontage then
    self.bShouldEndDeliveryMontage = GWorld.GameInstance.ShouldPlayDeliveryEndMontage
  end
  local LoadingUI = GWorld.GameInstance:GetLoadingUI()
  local bIsInLoading = LoadingUI and LoadingUI.bIsInLoading
  local bIsInBlackScreen = UIManager(self):GetUIObj("BlackScreenXiaobai")
  if PlayerCharacter:GetCharacterTag() == "Idle" and not bIsInLoading and not bIsInBlackScreen then
    self.bIsIdle = true
    PlayerCharacter:AddRegionOnline(self)
    return true
  end
  return false
end

function M:BackToRegionOnline()
  self:RemoveTimer("CheckIdleTagTimer")
  self:RemoveTimer("RegionOnline")
  local TimeUI = UIManager(self):GetUI("RegionOnlineFloat")
  if TimeUI then
    TimeUI:Close()
  end
end

function M:StartRegionOnline()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if self.bCloseTrigger then
    return
  end
  self:RemoveTimer("CheckIdleTagTimer")
  self:RemoveTimer("RegionOnline")
  local TimeUI = UIManager(self):GetUI("RegionOnlineFloat")
  if TimeUI then
    TimeUI:Close()
  end
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local ShowWeaponType = PlayerCharacter:GetCurrentShowWeapon()
  if "None" == ShowWeaponType or "" == ShowWeaponType or "none" == ShowWeaponType then
    ShowWeaponType = nil
  end
  local TimeUI = UIManager(self):GetUI("RegionOnlineFloat")
  if TimeUI then
    TimeUI:Close()
  end
  if PlayerCharacter.bFirstInitRegionOnline or self.bNotShowEnterUI == false then
    self.bNotShowEnterUI = true
    TimeUI = UIManager(self):LoadUINew("RegionOnlineFloat", "In")
    PlayerCharacter.bFirstInitRegionOnline = false
  end
  local EnterState = (self.bShouldEndDeliveryMontage or GWorld.GameInstance.ShouldPlayDeliveryEndMontage) and CommonConst.OnlineState.UseDelivery or CommonConst.OnlineState.Normal
  PlayerCharacter.CurrentOnlineState = EnterState
  Avatar:RequestEnterOnline(self.SubRegionId, ShowWeaponType, EnterState)
  if true or EnterState == CommonConst.OnlineState.UseDelivery and PlayerCharacter:IsMainPlayer() then
    PlayerCharacter:AddTimer(5, function()
      if PlayerCharacter and (not PlayerCharacter.CurrentOnlineState or PlayerCharacter.CurrentOnlineState == CommonConst.OnlineState.UseDelivery) then
        Avatar:SwitchOnlineState(Avatar.CurrentOnlineType, CommonConst.OnlineState.Normal)
      end
    end, false, 0, "SetOnlineStateNormal")
  end
  DebugPrint("@lkkkRequestEnterOnline", self.SubRegionId, self:GetName())
  SystemGuideManager:RunGuideById(self.GuideId)
end

function M:ExitTrigger()
  DebugPrint("ExitTrigger")
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if self.bNotShowCloseUI then
    local TimeUI = UIManager(self):GetUI("RegionOnlineFloat")
    if TimeUI then
      TimeUI:Close()
    end
    self:EndTrigger()
  end
end

function M:OnTriggerEnd()
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  PlayerCharacter:RemoveCurRegionOnline(self)
end

function M:FiveSecondExit()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local TimeUI = UIManager(self):GetUI("RegionOnlineFloat")
  if TimeUI then
    TimeUI:OnLoaded("Out", 5)
  else
    TimeUI = UIManager(self):LoadUINew("RegionOnlineFloat", "Out", 5)
  end
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  PlayerCharacter:SetFiveSecondTimerRegionOnline(self)
  self:AddTimer(5, function()
    self:RealFiveSecondExit()
  end, false, 0, "RegionOnline")
end

function M:RealFiveSecondExit()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local TimeUI = UIManager(self):GetUI("RegionOnlineFloat")
  if TimeUI then
    TimeUI:Close()
  end
  self.bIsIdle = false
  self.bNotShowEnterUI = false
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  self:RemoveTimer("CheckIdleTagTimer")
  self:RemoveTimer("RegionOnline")
  PlayerCharacter:RemoveFiveSecondTimerRegionOnline(self)
  PlayerCharacter:RemoveCurRegionOnlineOnRealExit()
  Avatar:RequestLeaveOnline(self.SubRegionId)
  DebugPrint("RealExitRegionOnline", self.SubRegionId)
end

function M:RemoveFiveSecondExit()
  self:RemoveTimer("RegionOnline")
end

function M:EndRegionOnline()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if not Avatar.PreEnterSubRegionId or Avatar.PreEnterSubRegionId ~= self.SubRegionId and Avatar.CurrentOnlineType ~= self.SubRegionId then
    return
  end
  local TimeUI = UIManager(self):GetUI("RegionOnlineFloat")
  if TimeUI then
    TimeUI:Close()
  end
  self.bIsIdle = false
  Avatar:RequestLeaveOnline(self.SubRegionId)
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if PlayerCharacter then
    PlayerCharacter:RemoveFiveSecondTimerRegionOnline(self)
  end
  DebugPrint("@lkkRequestLeaveOnline", self.SubRegionId)
  self:RemoveTimer("CheckIdleTagTimer")
  self:RemoveTimer("RegionOnline")
end

function M:AddEvents()
  EventManager:AddEvent(EventID.StartTalk, self, function(_, Message)
    self:CloseTrigger(Message.bDisableGameInput, Message.bExitOnline, "Talk")
  end)
  EventManager:AddEvent(EventID.EndTalk, self, function(_, Message)
    self:StartTrigger(Message.bDisableGameInput, Message.bExitOnline, "Talk")
  end)
end

function M:RemoveEvents()
  EventManager:RemoveEvent(EventID.StartTalk, self)
  EventManager:RemoveEvent(EventID.EndTalk, self)
end

function M:RemoveEventsOnEndPlay()
  self:RemoveEvents()
  EventManager:RemoveEvent(EventID.SpecialQuestCloseRegionOnline, self)
  EventManager:RemoveEvent(EventID.SpecialQuestOpenRegionOnline, self)
  EventManager:RemoveEvent(EventID.ChangeRegionOnline, self)
end

function M:StartTrigger(bDisableGameInput, bExitOnline, Tag)
  DebugPrint("[OnlineComp] CZC StartTrigger: ", self:GetName(), bDisableGameInput, bExitOnline, Tag)
  if not bExitOnline then
    return
  end
  if self.OpenTags == nil then
    self.OpenTags = {}
  end
  self.OpenTags[Tag] = nil
  local Empty = IsEmptyTable(self.OpenTags)
  if not Empty then
    return
  end
  self.bCloseTrigger = false
  self.bNotShowCloseUI = false
  if "Talk" == Tag then
    self.bNotShowEnterUI = true
  end
  self:RealStartTrigger()
end

function M:RealStartTrigger()
  for key, value in pairs(self.Boxes) do
    value:SetCollisionResponseToChannel(UE4.ECollisionChannel.ECC_Pawn, UE4.ECollisionResponse.ECR_Block)
    value:SetCollisionResponseToChannel(UE4.ECollisionChannel.ECC_Pawn, UE4.ECollisionResponse.ECR_Overlap)
  end
end

function M:RealCloseTrigger()
  for key, value in pairs(self.Boxes) do
    local currentResponse = value:GetCollisionResponseToChannel(UE4.ECollisionChannel.ECC_Pawn)
    if currentResponse ~= UE4.ECollisionResponse.ECR_Ignore then
      value:SetCollisionResponseToChannel(UE4.ECollisionChannel.ECC_Pawn, UE4.ECollisionResponse.ECR_Ignore)
    end
  end
end

function M:CloseTrigger(bDisableGameInput, bExitOnline, Tag)
  DebugPrint("[OnlineComp] CZC CloseTrigger: ", self:GetName(), bDisableGameInput, bExitOnline, Tag)
  if not bExitOnline then
    return
  end
  self:RemoveTimer("CheckIdleTagTimer")
  if self.OpenTags == nil then
    self.OpenTags = {}
  end
  self.OpenTags[Tag] = 1
  self.bCloseTrigger = true
  self.bNotShowCloseUI = true
  self:RealCloseTrigger()
end

function M:OnChangeRegionOnline(bOpen)
  if bOpen then
    local Empty = IsEmptyTable(self.OpenTags)
    if not Empty then
      return
    end
    self.bNotShowCloseUI = false
    self:RealStartTrigger()
  else
    self.bNotShowCloseUI = true
    self:RealCloseTrigger()
    self:EndRegionOnline()
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if PlayerCharacter then
      PlayerCharacter:RemoveFiveSecondTimerRegionOnline(self)
      PlayerCharacter:RemoveCurRegionOnlineOnRealExit()
    end
  end
end

return M
