require("UnLua")
local EInvitationState = {
  None = "None",
  Going = "Going",
  Inviting = "Inviting",
  Backing = "Backing",
  Recording = "Recording"
}
local M = Class("BluePrints.Common.TimerMgr")
local InviteLogType = UE.EStoryLogType.Invite

function M:PostOnInitialize()
  self:TryInitialize()
end

function M:PreOnDeinitialize()
  self.bIsInitialized = false
  if EventManager then
    EventManager:RemoveEvent(EventID.OnGuideStart, self)
    EventManager:RemoveEvent(EventID.OnGuideEnd, self)
  end
end

function M:OnCloseLoading()
  local GameMode = UE.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  local Avatar = GWorld:GetAvatar()
  if not (GameMode and GameMode:IsInRegion() and Avatar) or Avatar:GetCurrentRegionId() ~= self.TargetSubregionId then
    self:StopInvitation()
  end
end

function M:OnInLoading()
  if not self:IsInInvitation() then
    return
  end
  if self.InvitationState ~= EInvitationState.Inviting and self.InvitationState ~= EInvitationState.Backing then
    self:StopInvitation()
    return
  end
end

function M:ListenInterruptInvitataion()
  EventManager:AddEvent(EventID.CloseLoading, self, self.OnCloseLoading)
  EventManager:AddEvent(EventID.InLoading, self, self.OnInLoading)
  EventManager:AddEvent(EventID.OnNetDisconnect, self, self.StopInvitation)
end

function M:ListenEnterOtherRegion()
  EventManager:AddEvent(EventID.OnRegionLoaded, self, self.OnEnterOtherRegion)
end

function M:BeginInvitation(CharacterId, TopicLevel, bIsReview, OnFailed, OnSucceed)
  self:TryInitialize()
  if self:IsInInvitation() then
    DebugPrint(string.format("Error：邀约子系统：开始邀约失败，已处于邀约 %s 中。", self.InvitationState))
    return
  end
  local Avatar = GWorld:GetAvatar()
  self.PartyNPCData = DataMgr.PartyNpc[CharacterId]
  assert(self.PartyNPCData, string.format("Error：邀约子系统：PartyNpc 表不存在键：%d。", CharacterId))
  local PartyTopicId = self.PartyNPCData.PartyTopicList[TopicLevel]
  self.PartyTopicData = DataMgr.PartyTopic[PartyTopicId]
  assert(self.PartyTopicData, string.format("Error：邀约子系统：PartyTopic 表不存在键：%d。", PartyTopicId))
  self.TopicLevel = TopicLevel
  self.bIsReview = bIsReview
  self.InvitationState = EInvitationState.Going
  self:ListenInterruptInvitataion()
  Avatar:StartSojourns(CharacterId, TopicLevel, function(bSuccess, Ret)
    if not bSuccess then
      self:StopInvitation()
      if OnFailed then
        OnFailed()
      end
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "邀约发起服务器返回失败", string.format("邀约服务器返回失败 邀约ID: %d 邀约等级: %d 错误码 %d", CharacterId or -1, TopicLevel or -1, Ret))
      return
    end
    if not self:IsInInvitation() then
      if OnFailed then
        OnFailed()
      end
      return
    end
    local FlowManager = USubsystemBlueprintLibrary.GetWorldSubsystem(GWorld.GameInstance, UGameFlowManager)
    local Flow = FlowManager:CreateFlow("Sojourn")
    self.Flow = Flow
    Flow.OnBegin:Add(Flow, function()
      if OnSucceed then
        OnSucceed()
      end
      DebugPrint(string.format("邀约子系统：开始邀约 %d %d %s。", CharacterId, TopicLevel, tostring(bIsReview)))
      self:ListenEnterOtherRegion()
      self:StartStoryline()
    end)
    FlowManager:AddFlow(Flow)
  end)
end

function M:EndInvitation()
  self:TryInitialize()
  if self:IsInInvitation() == false then
    return
  end
  local CharacterId = self.PartyNPCData.CharId
  local TopicLevel = self.TopicLevel
  local bIsReview = self.bIsReview
  DebugPrint(string.format("邀约子系统：结束邀约 %d %d %s。", CharacterId, TopicLevel, tostring(bIsReview)))
  self:ClearInvitation()
  local FlowManager = USubsystemBlueprintLibrary.GetWorldSubsystem(GWorld.GameInstance, UGameFlowManager)
  local Flow = FlowManager:CreateFlow("Sojourn")
  Flow.OnBegin:Add(Flow, function()
    local FlowOpenUI = FlowManager:CreateFlow("OpenSystemUI")
    FlowOpenUI.OnBegin:Add(FlowOpenUI, function()
      try({
        exec = function()
          UIManager(self):AddFlow("Entertainment", FlowOpenUI)
          local UI = UIManager(self):LoadUINew("Entertainment", CharacterId, TopicLevel, Flow)
        end,
        catch = function(err)
          FlowManager:RemoveFlow(Flow)
          DebugPrint(ErrorTag, "LoadUINew Entertainment Error! traceback: ")
          Traceback(ErrorTag, err, false)
        end
      })
    end)
    FlowManager:AddFlow(FlowOpenUI)
  end)
  FlowManager:AddFlow(Flow)
end

function M:StopInvitation()
  self:TryInitialize()
  if self:IsInInvitation() == false then
    return
  end
  local CharacterId = self.PartyNPCData.CharId
  local TopicLevel = self.TopicLevel
  local bIsReview = self.bIsReview
  DebugPrint(string.format("邀约子系统：停止邀约 %d %d %s。", CharacterId, TopicLevel, tostring(bIsReview)))
  self:StopJumpToSubregion()
  self:StopStoryline()
  self:StopBlackScreen()
  self:ClearInvitation()
end

function M:IsInInvitation()
  self:TryInitialize()
  return self.InvitationState ~= EInvitationState.None
end

function M:TryInitialize()
  if self.bIsInitialized then
    return
  end
  self.bIsInitialized = true
  self.InvitationState = EInvitationState.None
  self.PartyNPCData = nil
  self.PartyTopicData = nil
  self.TopicLevel = nil
  self.bIsReview = nil
  self.HomebaseSubregionId = 210101
  self.RecordWaitSeconds = 0.5
  self.TargetSubregionId = nil
  self.StorylinePath = nil
  self.OnStorylineCompleted = nil
  self.BlackScreenHandle = nil
  self.bSpecialGuide = false
  local SystemGuideId = DataMgr.GlobalConstant.InvitationGuideId
  self.ListenSystemGuideId = SystemGuideId and SystemGuideId.ConstantValue
  EventManager:AddEvent(EventID.OnGuideStart, self, self.OnGuideStart)
  EventManager:AddEvent(EventID.OnGuideEnd, self, self.OnGuideEnd)
end

function M:OnGuideStart(Guide)
  if self.ListenSystemGuideId == Guide then
    self.bSpecialGuide = true
  end
end

function M:OnGuideEnd(Guide)
  if self.ListenSystemGuideId == Guide then
    self.bSpecialGuide = false
  end
end

function M:ClearInvitation()
  DebugPrint("邀约子系统：清理邀约")
  self.InvitationState = EInvitationState.None
  local CharacterId = self.PartyNPCData.CharId
  local TopicLevel = self.TopicLevel
  self.PartyNPCData = nil
  self.PartyTopicData = nil
  self.TopicLevel = nil
  self.bIsReview = nil
  EventManager:RemoveEvent(EventID.OnRegionLoaded, self)
  EventManager:RemoveEvent(EventID.CloseLoading, self)
  EventManager:RemoveEvent(EventID.InLoading, self)
  EventManager:RemoveEvent(EventID.OnNetDisconnect, self)
  local Avatar = GWorld:GetAvatar()
  Avatar:ExitSojourns(CharacterId, TopicLevel, function(bSuccess, Ret)
    if not bSuccess then
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "邀约结束服务器返回失败", string.format("邀约服务器返回失败 邀约ID: %d 邀约等级: %d 错误码 %d", CharacterId or -1, TopicLevel or -1, Ret))
    end
  end)
end

function M:OnEnterOtherRegion()
  if not self:IsInInvitation() then
    return
  end
  if self.InvitationState ~= EInvitationState.Inviting then
    return
  end
  self:StartStoryline()
end

function M:StartStoryline()
  local StorylinePath = self.PartyTopicData.PartyTopicTalkId
  
  local function OnCompleted()
    local FlowManager = USubsystemBlueprintLibrary.GetWorldSubsystem(GWorld.GameInstance, UGameFlowManager)
    FlowManager:RemoveFlow(self.Flow)
    self.Flow = nil
    self:CompleteInvite()
  end
  
  local Avatar = GWorld:GetAvatar()
  DebugPrint(string.format("邀约子系统：传送至地点 %d，开始邀约剧情 %s。", Avatar.CurrentRegionId, StorylinePath))
  if not StorylinePath then
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, InviteLogType, "邀约子系统错误: PartyTopicTalkId无效", string.format("邀约STL配置为空,话题ID %d", self.PartyTopicData.PartyTopicId))
    OnCompleted()
    return
  end
  self.InvitationState = EInvitationState.Inviting
  self:RunStoryline(StorylinePath, OnCompleted)
end

function M:CompleteInvite()
  local TargetSubregionId = self.HomebaseSubregionId
  DebugPrint(string.format("邀约子系统：邀约完成，返回 %d。", TargetSubregionId))
  self.InvitationState = EInvitationState.Backing
  self:JumpToSubregion(TargetSubregionId, function()
    self:BackFromInvite()
    return true
  end)
end

function M:BackFromInvite()
  if self.bIsReview then
    self:EndInvitation()
  else
    self:RecordInvite()
  end
end

function M:RecordInvite()
  local CharacterId = self.PartyNPCData.CharId
  local TopicLevel = self.TopicLevel
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    DebugPrint("Error: 邀约子系统：记录邀约失败，Avatar 为空。")
    return
  end
  DebugPrint("邀约子系统：记录邀约。")
  self.InvitationState = EInvitationState.Recording
  self:StartBlackScreen()
  self:SetPlayerInputEnabled(false)
  Avatar:TriggerPartyTopicComplete(CharacterId, TopicLevel, function(Ret)
    ErrorCode:Check(Ret)
    self:StopBlackScreen()
    self:SetPlayerInputEnabled(true)
    self:EndInvitation()
  end)
end

function M:SetInvitationRegionId(TargetRegionId)
  if not self:IsInInvitation() then
    return
  end
  self.TargetSubregionId = TargetRegionId
end

function M:JumpToSubregion(TargetSubregionId, OnSucceed, OnFailed)
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    DebugPrint("Error: 跳转到 %d 子区域失败，Avatar 为空。", TargetSubregionId)
    if OnFailed then
      OnFailed()
    end
    return
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if IsValid(GameMode) == false then
    DebugPrint("Error: 跳转到 %d 子区域失败，GameMode 为空。", TargetSubregionId)
    if OnFailed then
      OnFailed()
    end
    return
  end
  self:SetInvitationRegionId(TargetSubregionId)
  Avatar:StartJumpRegion(TargetSubregionId, function()
    self:StopJumpToSubregion(TargetSubregionId)
    if OnSucceed then
      OnSucceed()
    end
  end)
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance:GetGameUIManager()
  if UIManager then
    local MenuWorld = UIManager:GetUI("MenuWorld")
    if MenuWorld then
      MenuWorld.CloseByChild = true
    end
  end
  GameMode:HandleLevelDeliver(UE4.EModeType.ModeRegion, TargetSubregionId, 1, nil, true)
end

function M:StopJumpToSubregion()
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    DebugPrint("Error: 中断跳转 %d 子区域失败，Avatar 为空。", self.TargetSubregionId)
    return
  end
  Avatar:StopJumpRegion(self.TargetSubregionId)
  self.TargetSubregionId = nil
end

function M:RunStoryline(StorylinePath, OnCompleted)
  self.StorylinePath = StorylinePath
  
  function self.OnStorylineCompleted()
    self:ClearRunStorylineCache()
    if OnCompleted then
      OnCompleted()
    end
  end
  
  GWorld.StoryMgr:RunStory(StorylinePath, nil, nil, self.OnStorylineCompleted, nil, {bIsInvitation = true})
end

function M:StopStoryline()
  local StorylinePath = self.StorylinePath
  local OnCompleted = self.OnStorylineCompleted
  GWorld.StoryMgr:StopStoryline(StorylinePath, OnCompleted)
  self:ClearRunStorylineCache()
end

function M:ClearRunStorylineCache()
  self.StorylinePath = nil
  self.OnStorylineCompleted = nil
end

function M:StartBlackScreen()
  local UIManager = UIManager(self)
  if IsValid(UIManager) == false then
    DebugPrint("Error: 邀约子系统：开始黑屏失败，UIManager 为空。")
    return
  end
  if self.BlackScreenHandle then
    self:StopBlackScreen()
  end
  self.BlackScreenHandle = UIManager:ShowCommonBlackScreen({})
end

function M:StopBlackScreen()
  local UIManager = UIManager(self)
  if IsValid(UIManager) == false then
    DebugPrint("Error: 邀约子系统：停止黑屏失败，UIManager 为空。")
    return
  end
  if self.BlackScreenHandle then
    UIManager:HideCommonBlackScreen(self.BlackScreenHandle)
    self.BlackScreenHandle = nil
  end
end

function M:SetPlayerInputEnabled(bNewEnabled)
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if IsValid(PlayerCharacter) == false then
    return
  end
  local UIManager = UIManager(self)
  if IsValid(UIManager) == false then
    return
  end
  local Tag = "Invitation"
  local KeyboardSetName = "Invitation"
  if bNewEnabled then
    PlayerCharacter:RemoveDisableInputTag(Tag)
    UIManager:SetBannedActionCallback(KeyboardSetName, false, Tag)
  else
    PlayerCharacter:AddDisableInputTag(Tag)
    UIManager:SetBannedActionCallback(KeyboardSetName, true, Tag)
  end
end

return M
