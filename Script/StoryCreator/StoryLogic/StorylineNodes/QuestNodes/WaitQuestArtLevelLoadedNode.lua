local WaitQuestArtLevelLoadedNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode")
local BLACK_SCREEN_ASSURE_TIME = 6

function WaitQuestArtLevelLoadedNode:Init()
  self.VarName = nil
  self.BlackScreenEnable = true
  self.BlackScreenHandle = nil
  self.PollTimerHandle = nil
  self.AssureTimerHandle = nil
  self.LoadLevelList = nil
  self.ArtLevelInfo = nil
  self.ExecuteCallback = nil
end

function WaitQuestArtLevelLoadedNode:Execute(Callback)
  self.ExecuteCallback = Callback
  local Info, ErrMsg = self:GetArtLevelInfo()
  if not Info then
    self:PrintErrorlog(ErrMsg or "获取ArtLevelControl配置失败")
    Callback()
    return
  end
  self.ArtLevelInfo = Info
  self.LoadLevelList = Info.LoadLevel
  if self:AreAllLoadLevelsLoaded() then
    Callback()
    return
  end
  if self.BlackScreenEnable then
    self:ShowBlackScreen()
    self:AddAssureTimer()
  end
  self:StartPollTimer()
end

function WaitQuestArtLevelLoadedNode:GetArtLevelInfo()
  if not self.VarName or self.VarName == "" then
    return nil, "VarName为空"
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return nil, "Avatar不存在"
  end
  local SubRegionId = Avatar:GetCurrentRegionId()
  local SubRegionData = DataMgr.SubRegion[SubRegionId]
  if not SubRegionData or not SubRegionData.RegionId then
    return nil, "当前子区域无效, SubRegionId:" .. tostring(SubRegionId)
  end
  local RegionId = SubRegionData.RegionId
  local VarData = DataMgr.ArtLevelControl_TaskVar2Data[self.VarName]
  if not VarData then
    return nil, "VarName不在ArtLevelControl_TaskVar2Data中, VarName:" .. self.VarName
  end
  local Info = VarData[RegionId]
  if not Info then
    return nil, "VarName在当前RegionId下无配置, VarName:" .. self.VarName .. " RegionId:" .. RegionId
  end
  if not Info.LoadLevel or 0 == #Info.LoadLevel then
    return nil, "导表数据缺少LoadLevel, VarName:" .. self.VarName .. " RegionId:" .. RegionId
  end
  return Info
end

function WaitQuestArtLevelLoadedNode:GetLevelPackageName(LevelPath)
  local FileName = LevelPath:match("([^/]+)$") or LevelPath
  return FileName:match("^([^.]+)") or FileName
end

function WaitQuestArtLevelLoadedNode:IsLevelPackageLoaded(LevelPath)
  local LevelPackageName = self:GetLevelPackageName(LevelPath)
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  if not IsValid(GameMode) then
    return false
  end
  local WCSubSystem = GameMode:GetWCSubSystem()
  if WCSubSystem then
    return WCSubSystem:IsTaskLevelLoadedByName(LevelPackageName)
  end
  return false
end

function WaitQuestArtLevelLoadedNode:AreAllLoadLevelsLoaded()
  if not self.LoadLevelList then
    return true
  end
  for _, LevelPath in pairs(self.LoadLevelList) do
    if not self:IsLevelPackageLoaded(LevelPath) then
      return false
    end
  end
  return true
end

function WaitQuestArtLevelLoadedNode:StartPollTimer()
  if self.PollTimerHandle then
    return
  end
  self.PollTimerHandle = "WaitQuestArtLevelLoadedNodePoll" .. self.Key
  GWorld.GameInstance:AddTimer(0.1, function()
    if self:AreAllLoadLevelsLoaded() then
      self:OnAllLevelsLoaded()
    end
  end, true, 0, self.PollTimerHandle)
end

function WaitQuestArtLevelLoadedNode:ShowBlackScreen()
  self.BlackScreenHandle = "WaitQuestArtLevelLoadedNode" .. self.Key
  local Info = self.ArtLevelInfo or {}
  UIManager(GWorld.GameInstance):ShowCommonBlackScreen({
    BlackScreenHandle = self.BlackScreenHandle,
    InAnimationPlayTime = Info.InTime or 0,
    OutAnimationPlayTime = Info.OutTime or 0
  })
end

function WaitQuestArtLevelLoadedNode:HideBlackScreen()
  if not self.BlackScreenHandle then
    return
  end
  UIManager(GWorld.GameInstance):HideCommonBlackScreen(self.BlackScreenHandle)
end

function WaitQuestArtLevelLoadedNode:AddAssureTimer()
  self.AssureTimerHandle = "WaitQuestArtLevelLoadedNodeAssure" .. self.Key
  GWorld.GameInstance:AddTimer(BLACK_SCREEN_ASSURE_TIME, function()
    self:PrintErrorlog("等待任务Art关卡加载超时, 触发黑屏保底后节点完成")
    self:OnAllLevelsLoaded(true)
  end, false, 0, self.AssureTimerHandle)
end

function WaitQuestArtLevelLoadedNode:OnAllLevelsLoaded(bForceCloseBlackScreen)
  if not self.ExecuteCallback then
    return
  end
  local Callback = self.ExecuteCallback
  self.ExecuteCallback = nil
  if self.PollTimerHandle then
    GWorld.GameInstance:RemoveTimer(self.PollTimerHandle)
    self.PollTimerHandle = nil
  end
  if self.AssureTimerHandle then
    GWorld.GameInstance:RemoveTimer(self.AssureTimerHandle)
    self.AssureTimerHandle = nil
  end
  if self.BlackScreenEnable then
    self:HideBlackScreen()
  end
  Callback()
end

function WaitQuestArtLevelLoadedNode:Clear()
  self.ExecuteCallback = nil
  if self.PollTimerHandle then
    GWorld.GameInstance:RemoveTimer(self.PollTimerHandle)
    self.PollTimerHandle = nil
  end
  if self.AssureTimerHandle then
    GWorld.GameInstance:RemoveTimer(self.AssureTimerHandle)
    self.AssureTimerHandle = nil
  end
end

function WaitQuestArtLevelLoadedNode:PrintErrorlog(Msg)
  ScreenPrint("Error! WaitQuestArtLevelLoadedNode: ", Msg)
  local FileName = self.Context and self.Context.FileName or "invalid_filename"
  local Message = "WaitQuestArtLevelLoadedNode " .. Msg .. "\n====STL信息========" .. [[

FileName:	]] .. FileName .. [[

QuestChainId:	]] .. tostring(self.QuestChainId) .. [[

QuestId:	]] .. tostring(self.QuestId) .. [[

StoryNodeKey:	]] .. tostring(self.Context and self.Context.Data and self.Context.Data.key) .. [[

Key:	]] .. tostring(self.Key) .. "\n====节点配置信息========" .. [[

VarName:	]] .. tostring(self.VarName) .. [[

BlackScreenEnable:	]] .. tostring(self.BlackScreenEnable)
  UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "等待任务Art关卡加载节点出错", Message)
end

return WaitQuestArtLevelLoadedNode
