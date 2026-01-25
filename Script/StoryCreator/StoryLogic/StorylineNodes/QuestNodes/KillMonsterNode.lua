local TaskUtils = require("BluePrints.UI.TaskPanel.TaskUtils")
local GuidePointLocData = require("BluePrints.UI.TaskPanel/QuestGuidePointLocData")
local KillMonsterNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode")
local ClientEventUtils = require("BluePrints.Common.ClientEvent.ClientEventUtils")

function KillMonsterNode:Init()
  self.KillMonsterType = "Nums"
  self.KillMonsterCnt = 0
  self.MonsterNeedNums = 0
  self.IsShowMonsterGuide = true
  self.StaticCreatorIdList = {}
  self.MonsterGuideMap = {}
  self.MonsterCreatorIdList = {}
end

function KillMonsterNode:Execute(Callback)
  self.Callback = Callback
  self.AddGuideTimer_Handle = "KillMonsterAddGuideTimer" .. self.Key
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  self.KillMonsterCnt = 0
  if self.KillMonsterType == "Nums" then
    GameMode:STLRegisterKillMonsterNode(self)
  else
    self.MonsterCreatorIdList = {}
    for _, Id in pairs(self.StaticCreatorIdList) do
      self.MonsterCreatorIdList[Id] = false
    end
    self:ShowMonterGuide(GameMode)
    GameMode:STLRegisterKillMonsterNode_Creator(self)
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    if Avatar.InSpecialQuest and ClientEventUtils:GetCurrentEvent() and ClientEventUtils:GetCurrentEvent().PreQuestChainId then
      self.CurQuestChainId = ClientEventUtils:GetCurrentEvent().PreQuestChainId
    else
      self.CurQuestChainId = self.Context.QuestChainId
    end
    if Avatar.QuestChains[self.CurQuestChainId] then
      self.CurDoingQuestId = Avatar.QuestChains[self.CurQuestChainId].DoingQuestId
    else
      self.CurDoingQuestId = self.QuestId
    end
    Avatar:DoRefreshTaskItemUIInfo("Modify", nil, {
      self.KillMonsterCnt,
      self.MonsterNeedNums,
      self.CurQuestChainId,
      self.CurDoingQuestId,
      self
    })
  end
  if self.IsShow then
    MissionIndicatorManager:ActiveMissionIndicatorByNode(self)
  end
end

function KillMonsterNode:ShowMonterGuide(GameMode)
  if not self.IsShowMonsterGuide then
    return
  end
  local GameState = GameMode.EMGameState
  local CheckCounter = 0
  
  local function IsAllActivated()
    for _, IsActivated in pairs(self.MonsterCreatorIdList) do
      if not IsActivated then
        return false
      end
    end
    return true
  end
  
  local function CheckAllMonsterToAddGuide()
    CheckCounter = CheckCounter + 1
    for _, StaticCreatorId in pairs(self.StaticCreatorIdList) do
      if self.MonsterCreatorIdList[StaticCreatorId] == false then
        local Creator = GameState.StaticCreatorMap:FindRef(StaticCreatorId)
        if IsValid(Creator) and Creator.ChildEids:Length() > 0 then
          for i = 1, Creator.ChildEids:Length() do
            local Monster = Battle(GWorld.GameInstance):GetEntity(Creator.ChildEids:GetRef(i))
            if IsValid(Monster) then
              self.MonsterCreatorIdList[StaticCreatorId] = true
              GameState:AddGuideEid(Monster.Eid)
              Monster:ActiveGuide("Add")
              DebugPrint("KillMonsterNode: 添加指引", Monster.Eid)
              self.MonsterGuideMap[StaticCreatorId] = Monster.Eid
              if GuidePointLocData[self.GuideName] then
                local Location = {
                  X = GuidePointLocData[self.GuideName].X,
                  Y = GuidePointLocData[self.GuideName].Y,
                  Z = GuidePointLocData[self.GuideName].Z,
                  R = GuidePointLocData[self.GuideName].R or 0
                }
                if Location.R > 0 and false == self:CheckIsNeedShowGuideStyleByLocation(Location) then
                  local GameInstance = GWorld.GameInstance
                  local SceneMgrComponent = GameInstance:GetSceneManager()
                  if IsValid(SceneMgrComponent) then
                    SceneMgrComponent:ShowOrHideSceneGuideIcon(Monster.Eid, false, "KillMonsterNodeTag")
                  end
                end
              end
            end
          end
        end
      end
    end
    local IsThisTimeAllActivated = IsAllActivated()
    DebugPrint("KillMonsterNode: 遍历次数：", CheckCounter, "，是否全部添加指引：", IsThisTimeAllActivated)
    if IsThisTimeAllActivated or CheckCounter > 20 then
      DebugPrint("KillMonsterNode: 移除添加指引timer Handle Name: ", self.AddGuideTimer_Handle)
      GWorld.GameInstance:RemoveTimer(self.AddGuideTimer_Handle)
    end
  end
  
  CheckAllMonsterToAddGuide()
  DebugPrint("KillMonsterNode: 添加指引timer Handle Name: ", self.AddGuideTimer_Handle)
  GWorld.GameInstance:AddTimer(1, CheckAllMonsterToAddGuide, true, 0, self.AddGuideTimer_Handle)
end

function KillMonsterNode:CheckIsNeedShowGuideStyleByLocation(Location)
  local MainPlayer = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  if nil == Location or nil == Location.R or not IsValid(MainPlayer) then
    return false
  end
  local RealRadius
  if Location and Location.R and Location.R > 0 then
    RealRadius = (Location.R + 5) / 100
  end
  local PointLoc = FVector(Location.X, Location.Y, Location.Z)
  local Distance = UKismetMathLibrary.Vector_Distance2D(MainPlayer.CurrentLocation, PointLoc) / 100.0
  if nil == RealRadius then
    return false
  end
  local IsShowRange = RealRadius > Distance
  if nil ~= RealRadius and IsShowRange then
    return true
  end
  return false
end

function KillMonsterNode:HideMonsterGuide(GameMode)
  if not self.IsShowMonsterGuide then
    return
  end
  local GameState = GameMode.EMGameState
  local SceneMgrComponent = GWorld.GameInstance:GetSceneManager()
  GWorld.GameInstance:RemoveTimer(self.AddGuideTimer_Handle)
  for StaticCreatorId, _ in pairs(self.MonsterCreatorIdList) do
    local Creator = GameState.StaticCreatorMap:FindRef(StaticCreatorId)
    if IsValid(Creator) and Creator.ChildEids:Length() > 0 then
      for i = 1, Creator.ChildEids:Length() do
        local Eid = Creator.ChildEids:GetRef(i)
        local Data = DataMgr.Monster[Creator.UnitId]
        if IsValid(SceneMgrComponent) and Data and Data.GuideIconAni then
          self.MonsterCreatorIdList[StaticCreatorId] = false
          GameState:RemoveGuideEid(Eid)
          SceneMgrComponent:UpdateSceneGuideIcon(Eid, nil, nil, "Delete", true, Data)
          DebugPrint("KillMonsterNode: 清除指引 静态点Id", StaticCreatorId, " 怪物Eid", Eid)
        end
      end
    end
  end
end

function KillMonsterNode:OnMonsterKilledByNums(Monster)
  if Monster and Monster:IsRealMonster() then
    self.KillMonsterCnt = self.KillMonsterCnt + 1
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      Avatar:DoRefreshTaskItemUIInfo("Modify", nil, {
        self.KillMonsterCnt,
        self.MonsterNeedNums,
        self.CurQuestChainId,
        self.CurDoingQuestId,
        self
      })
    end
    DebugPrint("KillMonsterNode: 数目击杀计数 ", self.KillMonsterCnt, "STL Key", self.Key)
    if self.KillMonsterCnt >= self.MonsterNeedNums then
      self.Callback()
    end
  end
end

function KillMonsterNode:OnCancelTrack()
  DebugPrint("KillMonsterNode: OnCancelTrack", self.KillMonsterType)
  if self.KillMonsterType ~= "Nums" then
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    self:HideMonsterGuide(GameMode)
  end
end

function KillMonsterNode:OnChooseTrack()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:DoRefreshTaskItemUIInfo("Modify", nil, {
      self.KillMonsterCnt,
      self.MonsterNeedNums,
      self.CurQuestChainId,
      self.CurDoingQuestId,
      self
    })
  end
  DebugPrint("KillMonsterNode: OnChooseTrack", self.KillMonsterType)
  if self.KillMonsterType ~= "Nums" then
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    self:ShowMonterGuide(GameMode)
  end
end

function KillMonsterNode:OnMonsterKilledByCreatorId(Monster)
  if Monster then
    if self.MonsterCreatorIdList[Monster.CreatorId] ~= nil then
      self.KillMonsterCnt = self.KillMonsterCnt + 1
      local Avatar = GWorld:GetAvatar()
      if Avatar then
        Avatar:DoRefreshTaskItemUIInfo("Modify", nil, {
          self.KillMonsterCnt,
          self.MonsterNeedNums,
          self.CurQuestChainId,
          self.CurDoingQuestId,
          self
        })
      end
      DebugPrint("KillMonsterNode: 静态点击杀计数 ", self.KillMonsterCnt, "被击杀怪物静态点Id ", Monster.CreatorId, "STL Key", self.Key)
    end
    Monster:DeactiveGuide()
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    GameState:RemoveGuideEid(Monster.Eid)
    if self.KillMonsterCnt >= self.MonsterNeedNums then
      self.Callback()
    end
  end
end

function KillMonsterNode:Clear()
  DebugPrint("KillMonsterNode: Clear，进行清理")
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  if self.KillMonsterType == "Nums" then
    GameMode:STLUnRegisterKillMonsterNode(self.Key)
  else
    DebugPrint("KillMonsterNode: 移除添加指引timer Handle Name: ", self.AddGuideTimer_Handle)
    GWorld.GameInstance:RemoveTimer(self.AddGuideTimer_Handle)
    self:HideMonsterGuide(GameMode)
    self.MonsterCreatorIdList = {}
    GameMode:STLUnRegisterKillMonsterNode_Creator(self.Key)
  end
  if self.IsShow then
    MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
  end
  TaskUtils:ClearQuestExtraInfo(self.CurQuestChainId, self.CurDoingQuestId, self.Key)
  local TaskUIObj = TaskUtils:GetTaskBarWidget()
  if TaskUIObj then
    TaskUIObj:ClearCurTaskBarExtraInfo()
  end
  GameMode.KillMonsterNode = nil
  self.Callback = nil
end

function KillMonsterNode:OnQuestlineFail()
  DebugPrint("KillMonsterNode: 任务失败，清理计数", self.KillMonsterCnt)
  self.KillMonsterCnt = 0
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:DoRefreshTaskItemUIInfo("Modify", nil, {
      self.KillMonsterCnt,
      self.MonsterNeedNums,
      self.CurQuestChainId,
      self.CurDoingQuestId,
      self
    })
  end
  if self.IsShow then
    MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
  end
  TaskUtils:ClearQuestExtraInfo(self.CurQuestChainId, self.CurDoingQuestId, self.Key)
end

return KillMonsterNode
