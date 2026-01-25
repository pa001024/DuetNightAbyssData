require("UnLua")
require("Const")
local AbyssComponent = {}

function AbyssComponent:IsAbyssDungeon()
  if self.IsDungeonTypeAbyss == nil then
    local DungeonInfo = DataMgr.Dungeon[self.DungeonId]
    if DungeonInfo then
      self.IsDungeonTypeAbyss = DungeonInfo.DungeonType == "Abyss"
    end
  end
  return self.IsDungeonTypeAbyss
end

function AbyssComponent:OnStartNextRoom(LevelId, NewLevelId)
  if self:IsSubGameMode() then
    return
  end
  print(_G.LogTag, "LXZ OnStartNextRoom", LevelId, NewLevelId)
end

function AbyssComponent:OnAbyssRoomBegin(LevelId, RoomId)
  if not self:IsSubGameMode() then
    return
  end
  self.AbyssRoomId = RoomId
  local AbyssRoomInfo = DataMgr.AbyssRoom[self.AbyssRoomId]
  if not AbyssRoomInfo then
    self.EMGameState:ShowDungeonError("RoomId不存在于AbyssRoom表里, RoomId" .. self.AbyssRoomId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    return
  end
  if not AbyssRoomInfo.ClearCondition then
    self.EMGameState:ShowDungeonError("AbyssRoom表里不存在ClearCondition, RoomId" .. self.AbyssRoomId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    return
  end
  if not AbyssRoomInfo.TimeLimit then
    self.EMGameState:ShowDungeonError("AbyssRoom表里不存在TimeLimit, RoomId" .. self.AbyssRoomId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    return
  end
  if not AbyssRoomInfo.UnitSpawnId then
    self.EMGameState:ShowDungeonError("AbyssRoom表里不存在UnitSpawnId, RoomId" .. self.AbyssRoomId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    return
  end
  self.ClearCondition = AbyssRoomInfo.ClearCondition
  self.TimeLimit = AbyssRoomInfo.TimeLimit
  self.UnitSpawnId:Clear()
  for _, Id in pairs(AbyssRoomInfo.UnitSpawnId) do
    self.UnitSpawnId:Add(Id)
  end
  self.StaticCreatorId:Clear()
  if AbyssRoomInfo.StaticCreatorId then
    for _, Id in pairs(AbyssRoomInfo.StaticCreatorId) do
      self.StaticCreatorId:Add(Id)
    end
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/battle_warning", nil, nil)
  self.Overridden.OnAbyssRoomBegin(self, LevelId, RoomId)
end

function AbyssComponent:IsAbyssBossRoom()
  if self.IsAbyssRoomTypeBossRoom == nil then
    local AbyssRoomInfo = DataMgr.AbyssRoom[self.AbyssRoomId]
    self.IsAbyssRoomTypeBossRoom = AbyssRoomInfo.RoomType == "Boss"
  end
  return self.IsAbyssRoomTypeBossRoom
end

function AbyssComponent:TryUnlockDoor()
  if self.GetLevelLoader and self:GetLevelLoader() then
    local LevelLoader = self:GetLevelLoader()
    if LevelLoader.LevelId2Doors[self.LevelName] then
      for i = 1, #LevelLoader.LevelId2Doors[self.LevelName] do
        if LevelLoader.LevelId2Doors[self.LevelName][i].door_state then
          local Door = LevelLoader.LevelId2Doors[self.LevelName][i].AutoDoor
          Door:OnUnLockDoor()
          if LevelLoader.LoadAbyssLevel then
            LevelLoader:LoadAbyssLevel(LevelLoader.LevelId2Doors[self.LevelName][i], self.LevelName)
          end
          return true
        end
      end
    else
      self.EMGameState:ShowDungeonError("当前房间通过，但是LevelLoader.LevelId2Doors中没有当前LevelName：" .. self.LevelName, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    end
  else
    self.EMGameState:ShowDungeonError("当前房间通过，但是GameMode获取不到LevelLoader", Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.FindObject)
  end
  return false
end

function AbyssComponent:TryLockDoor()
  if self.LevelGameMode.GetLevelLoader and self.LevelGameMode:GetLevelLoader() then
    local LevelLoader = self.LevelGameMode:GetLevelLoader()
    if LevelLoader.LevelId2Doors[self.LevelName] then
      for i = 1, #LevelLoader.LevelId2Doors[self.LevelName] do
        if LevelLoader.LevelId2Doors[self.LevelName][i].door_state then
          local Door = LevelLoader.LevelId2Doors[self.LevelName][i].AutoDoor
          Door:OnLockDoor()
        end
      end
    else
      self.EMGameState:ShowDungeonError("进入新房间，但是LevelLoader.LevelId2Doors中没有当前LevelName：" .. self.LevelName .. self:GetName(), Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    end
  else
    self.EMGameState:ShowDungeonError("进入新房间，但是GameMode获取不到LevelLoader", Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.FindObject)
  end
end

function AbyssComponent:AddAbyssBattleCount(Value)
  self.EMGameState.AbyssBattleCount = self.EMGameState.AbyssBattleCount + Value
  EventManager:FireEvent(EventID.OnRepAbyssBattleCount)
end

function AbyssComponent:SetAbyssBattleMaxNum(Value, DisplayText, IsShowBar)
  self.EMGameState.AbyssBattleCount = 0
  self.EMGameState.AbyssBattleMaxNum = Value
  EventManager:FireEvent(EventID.OnRepAbyssBattleCount)
  local AbyssBattleUI = UIManager(self):GetUIObj("Abyss_BattleProgress")
  if AbyssBattleUI then
    self:SetAbyssBattlePanelVisibility(true)
    AbyssBattleUI:InitAbyssBattleDisplayText(DisplayText, IsShowBar)
  else
    self:AddTimer(0.1, function()
      AbyssBattleUI = UIManager(self):GetUIObj("Abyss_BattleProgress")
      if AbyssBattleUI then
        self:SetAbyssBattlePanelVisibility(true)
        AbyssBattleUI:InitAbyssBattleDisplayText(DisplayText, IsShowBar)
        self:RemoveTimer("InitAbyssDisplayTextTimer")
      end
    end, true, 0, "InitAbyssDisplayTextTimer")
  end
end

function AbyssComponent:HideAbyssBattlePanel()
  self:SetAbyssBattlePanelVisibility(false)
end

function AbyssComponent:SetAbyssBattlePanelVisibility(IsShow)
  local AbyssBattleUI = UIManager(self):GetUIObj("Abyss_BattleProgress")
  if AbyssBattleUI then
    AbyssBattleUI:SetAbyssBattleVisibility(IsShow)
  else
    DebugPrint("AbyssComponent:SetAbyssBattlePanelVisibility 找不到AbyssBattleUI ", IsShow)
  end
end

function AbyssComponent:GetCurrentAbyssDungeonId()
  if self.EMGameState.GameModeType ~= "Abyss" then
    return 0
  end
  return self.LevelGameMode:GetDungeonComponent() and self.LevelGameMode:GetDungeonComponent().AbyssDungeonId or 0
end

function AbyssComponent:BpOnTimerDel_AbyssBattle()
  if CommonUtils.HasClientTimerStruct("AbyssBattle") then
    local PassedTime = CommonUtils.GetClientTimerStructPassedTime("AbyssBattle")
    self.LevelGameMode:TriggerDungeonComponentFun("SendAbyssPassedTime", PassedTime)
    self.LevelGameMode:TriggerDungeonComponentFun("RealSendAbyssPassedTime")
  elseif CommonUtils.HasClientTimerStruct("AbyssBattleNew") then
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local Info = GameState.ClientTimerStruct:GetTimerInfo("AbyssBattleNew")
    local IsRealTime = Info.IsRealTime
    self:BpDelTimer("AbyssBattleNew", IsRealTime, Const.GameModeEventServerClient)
  end
end

function AbyssComponent:BpOnTimerDel_AbyssBattleNew()
  local PassedTime = CommonUtils.GetClientTimerStructPassedTime("AbyssBattleNew")
  self.LevelGameMode:TriggerDungeonComponentFun("SendAbyssPassedTime", PassedTime)
end

function AbyssComponent:BpOnTimerEnd_AbyssBattleNew()
  self:BpOnTimerEnd("AbyssBattle")
end

function AbyssComponent:AbyssTeleport(Location, Rotation, IsBoss)
  if self.EMGameState.GameModeType ~= "Abyss" then
    return
  end
  DebugPrint("AbyssTeleport", Location)
  self:GetLevelLoader():OnAbyssTeleport(IsBoss)
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local LastLevelId = self:GetLevelLoader():GetLevelIdByLocation(PlayerCharacter:K2_GetActorLocation())
  local NewLevelId = self:GetLevelLoader():GetLevelIdByLocation(Location)
  PlayerCharacter:K2_TeleportTo(Location, Rotation, false, nil, false)
  EventManager:FireEvent(EventID.ForceUpdatePlayerCurrentLevelId)
  self.LevelGameMode.IsAbyssTeleporting = true
  self:AddTimer(2, self.OnCharacterChangeLevel, false, 0, "AbyssTeleport", false, LastLevelId, NewLevelId)
end

function AbyssComponent:OnCharacterChangeLevel(LastLevelId, NewLevelId)
  self.LevelGameMode.IsAbyssTeleporting = false
  print(_G.LogTag, "LXZ OnCharacterChangeLevel", LastLevelId, NewLevelId, self:GetName())
  self:TryLockDoor()
  self.LevelGameMode:AbyssRecordProgressData({LastLevelId = LastLevelId, NewLevelId = NewLevelId})
  self.LevelGameMode:TriggerDungeonComponentFun("TriggerStartNextRoom", LastLevelId, NewLevelId)
end

function AbyssComponent:OnAbyssRoomTimeUp()
  local IsReEntering = self.LevelGameMode:TriggerDungeonComponentFun("IsReEnteringAbyss")
  DebugPrint("AbyssComponent:OnAbyssRoomTimeUp Abyss IsReEntering", IsReEntering)
  if IsReEntering then
    return
  end
  self:TriggerDungeonFailed()
end

return AbyssComponent
