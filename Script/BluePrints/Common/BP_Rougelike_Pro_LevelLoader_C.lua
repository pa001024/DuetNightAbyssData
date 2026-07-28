local M = Class({
  "BluePrints/Common/EMLevelLoader",
  "BluePrints.Common.TimerMgr"
})

function M:ReceiveBeginPlay()
  self.Overridden.ReceiveBeginPlay(self)
  self:BeginPlay()
  self.LoadingComplete = false
  self.RoomData = DataMgr.RougePro_Room
  self.SeasonId = 0
  self.CurrentRoomId = nil
  self.LastRoomId = nil
  self.AllRoomIds = nil
  self.StepId = 1
  self.RoomId2StreamLevel = {}
  self.StreamLevelNavMeshCheck = {}
  self.ID2DesignStreamingLevel = {}
  self.LoadingFlag = false
  self.LevelSpacing = 100000
  self.IsMobile = CommonUtils.GetRuntimePlatform(self) == "Mobile"
  if IsDedicatedServer(self) or IsStandAlone(self) then
    local DungeonObject = GWorld:GetGameModeDungeonObject()
    if DungeonObject and DungeonObject.CProperty and DungeonObject.CProperty.RoomList then
      if type(DungeonObject.CProperty.RoomList) == "table" then
        local Array = TArray(0)
        for _, Value in pairs(DungeonObject.CProperty.RoomList) do
          Array:Add(Value)
        end
        self:InitAllRooms(Array)
      else
        self:InitAllRooms(DungeonObject.CProperty.RoomList)
      end
      self.StepId = DungeonObject.CProperty.Round
      DebugPrint("self.StepId", self.StepId)
    else
      error("RougeliePro LevelLoader没有找到DS RoomList！！！！")
    end
  elseif IsClient(self) then
    local DungeonObject = GWorld:GetDungeonObjectCProperty()
    if DungeonObject and DungeonObject.RoomList then
      self.StepId = DungeonObject.Round
      self:InitAllRooms(DungeonObject.RoomList)
    else
      error("RougeliePro LevelLoader没有找到Client RoomList！！！！", DungeonObject)
    end
  end
  if IsClient(self) or IsStandAlone(self) then
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    self.LoadingUI = GameInstance:ShowLoadingUI(UIConst.COMMONCHANGESCENE)
  end
  GWorld.RougelikeLevelLoader = self
end

function M:InitAllRooms(AllRoomIds)
  self.AllRoomIds = AllRoomIds
  self:PrintRougeLikeLevelLoader("InitAllRooms count:" .. AllRoomIds:Length())
  if not IsClient(self) then
    self:AddBuildingLock()
  end
  if IsDedicatedServer(self) then
    coroutine.resume(coroutine.create(self.DS_LoadAllRooms), self)
  else
    self:SetForceGCAfterLevelStreamedOut(false)
    self:OnRougeLikeEnterRoom(self.StepId)
  end
end

function M:DS_LoadAllRooms()
  self:PrintRougeLikeLevelLoader("DS_LoadAllRooms start")
  for index = 1, self.AllRoomIds:Length() do
    local roomId = self.AllRoomIds[index]
    self:LoadStreamLevelByRoomId(roomId, index - 1)
    while self.LoadingFlag do
      UKismetSystemLibrary.Delay(self, 0.1)
    end
  end
  self:PrintRougeLikeLevelLoader("DS_LoadAllRooms complete")
  self.CurrentRoomId = self.AllRoomIds[self.StepId]
  self:SetForceGCAfterLevelStreamedOut(false)
  self:LevelLoaderReady()
  self.LoadingComplete = true
  self:ReleaseInitialBuildingLock()
end

function M:TryRougeLikeEnterRoom(Round)
  if self.StepId ~= Round then
    self:OnRougeLikeEnterRoom(Round)
  end
end

function M:OnRougeLikeEnterRoom(Round)
  self:PrintRougeLikeLevelLoader("OnRougeLikeEnterRoom:" .. Round)
  self.CurrentRoomId = self.AllRoomIds[Round]
  self.StepId = Round
  if IsDedicatedServer(self) then
    self:UnloadLastRoom()
    self:SetPlayerTrans()
    self.LastRoomId = self.CurrentRoomId
  else
    if self.StepId > 1 then
      self.LoadingUI = GWorld.GameInstance:ShowLoadingUI(UIConst.COMMONCHANGESCENE)
    end
    coroutine.resume(coroutine.create(self.Client_EnterRoom), self, self.CurrentRoomId)
  end
end

function M:Client_EnterRoom(RoomId)
  if IsStandAlone(self) then
    local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
    if Player then
      Player:GetMovementComponent():SetMovementMode(UE4.EMovementMode.Move_None)
    end
  end
  self:UnloadLastRoom()
  local index = self.StepId - 1
  self:LoadStreamLevelByRoomId(RoomId, index)
  while self.LoadingFlag do
    UKismetSystemLibrary.Delay(self, 0.1)
  end
  self:PrintRougeLikeLevelLoader("Client_EnterRoom complete:" .. RoomId)
  self.LastRoomId = self.CurrentRoomId
  self:SetPlayerTrans()
  if not self.LoadingComplete then
    self:LevelLoaderReady()
    self.LoadingComplete = true
  elseif self.LoadingUI then
    self.LoadingUI:AddQuene(100)
  end
  if IsStandAlone(self) then
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
      GameMode:NotifyServerDungeonEvent("ChangeRound")
    end
  end
end

function M:UnloadLastRoom()
  if self.LastRoomId then
    local lastStep = self.StepId - 2
    coroutine.resume(coroutine.create(self.UnloadStreamLevelByRoomId), self, self.LastRoomId, lastStep)
    self.LastRoomId = nil
  end
end

function M:InitSettings()
  DebugPrint("LevelLoaderInitSettings RougeLike Pro")
  URuntimeCommonFunctionLibrary.SetConsoleVariableIntValue("r.Mobile.EnableReadSurface", 0, 1)
end

function M:OnArtLevelLoaded(RoomId)
  if self.LoadingComplete then
    self:DisableLevelRVTVolume(self.RoomId2StreamLevel[RoomId][3])
  end
  coroutine.resume(coroutine.create(self.CheckLevelLoaded), self, RoomId)
end

function M:CheckLevelLoaded(RoomId)
  self:PrintRougeLikeLevelLoader("CheckLevelLoaded:" .. RoomId)
  while true do
    local levelCheck = true
    for i = 1, #self.RoomId2StreamLevel[RoomId] do
      local streamLevel = self.RoomId2StreamLevel[RoomId][i]
      if streamLevel and 2 ~= i and i <= 3 then
        if not streamLevel:GetLoadedLevel() or not streamLevel:GetLoadedLevel().bIsVisible then
          levelCheck = false
          break
        end
      elseif i > 3 and #streamLevel > 0 and (not streamLevel[1]:GetLoadedLevel() or not streamLevel[1]:GetLoadedLevel().bIsVisible) then
        levelCheck = false
        break
      end
    end
    if levelCheck then
      self:PrintRougeLikeLevelLoader("check complete:" .. RoomId)
      break
    end
    UKismetSystemLibrary.Delay(self, 0.1)
  end
  self.LoadingFlag = false
  self:PrintRougeLikeLevelLoader("LoadingFlag false")
end

function M:OnPostAttachNavMeshDataChunk_Lua(InStreamLevel)
  self.StreamLevelNavMeshCheck[InStreamLevel] = true
end

function M:SetPlayerTrans()
  if IsClient(self) or IsStandAlone(self) then
    self:CreateBattleMap()
    if self.RoomId2StreamLevel[self.CurrentRoomId] and self.RoomId2StreamLevel[self.CurrentRoomId][3] then
      self:EnableLevelRVTVolume(self.RoomId2StreamLevel[self.CurrentRoomId][3])
    end
    local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
    if Player then
      local MovementComponent = Player:GetMovementComponent()
      MovementComponent:SetMovementMode(MovementComponent.DefaultLandMovementMode)
    end
  end
  if IsDedicatedServer(self) then
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if IsValid(GameMode) and self.StepId > 1 then
      for i = 0, GameMode:GetTargetPlayerNum() - 1 do
        local Controller = UE4.UGameplayStatics.GetPlayerController(self, i)
        if Controller then
          local Player = Controller:GetMyPawn()
          if Player then
            Player:GetMovementComponent():SetMovementMode(UE4.EMovementMode.Move_None)
          end
        end
      end
    end
  end
  if IsDedicatedServer(self) or IsStandAlone(self) then
    self:RandomSetPlayerTrans()
  end
end

function M:RandomSetPlayerTrans()
  local StartPoints = FArray(AActor)
  StartPoints = UGameplayStatics.GetAllActorsOfClass(self, LoadClass("/Game/BluePrints/Common/Level/BP_StartPoint.BP_StartPoint_C"))
  local CurrentId = tostring(self.CurrentRoomId)
  DebugPrint("InitSetPlayerTrans", CurrentId)
  local TargetPoints = {}
  for _, StartPoint in pairs(StartPoints:ToTable()) do
    if CurrentId == self:GetDesignActorLevelName(StartPoint) then
      table.insert(TargetPoints, StartPoint)
      UGameplayStatics.GetGameMode(self):InitRougeLikeProSubGameMode("/Game/AssetDesign/GameMode/BP_EMGameMode.BP_EMGameMode", CurrentId)
    end
  end
  if #TargetPoints > 0 then
    local TargetPoint = TargetPoints[math.random(1, #TargetPoints)]
    TargetPoint:AlwaysSetPlayerTrans()
    if not self.InitTargetPoint then
      self.InitTargetPoint = TargetPoint
    end
  else
    error("RougePro当前房间Id " .. CurrentId .. " 找不到StartPoint！")
  end
end

function M:CreateBattleMap()
  local battleMain = UIManager(self):GetUI("BattleMain")
  if not battleMain then
    return
  end
  local MiniMap = battleMain.Battle_Map
  if MiniMap then
    local data = {}
    data[1] = string.gsub(self.RoomData[self.CurrentRoomId].ArtDataPath, "_Art", "")
    data[1] = string.gsub(data[1], "_Layout", "")
    data[1] = string.sub(data[1], string.find(data[1], "%.") + 1)
    local levelTransform = self.LevelID2GridFrame:FindRef(tostring(self.CurrentRoomId)):GetTransform()
    data[2] = {
      X = levelTransform.Translation.X,
      Y = levelTransform.Translation.Y
    }
    data[3] = levelTransform.Rotation:ToRotator().Yaw
    data[4] = ""
    MiniMap.MapNeedDynamicMaterial = false
    MiniMap:CreateRougelikeBattleMap(self.CurrentRoomId, data)
  end
end

function M:UnloadStreamLevelByRoomId(RoomId, StepId)
  self:PrintRougeLikeLevelLoader("UnloadStreamLevelByRoomId ", RoomId, StepId)
  local prefix = self:GetWorldStreamingLevelsPrefix()
  local needPrefix = IsClient(self) and URuntimeCommonFunctionLibrary.IsPlayInEditor(self) and "" == prefix
  if needPrefix then
    StepId = "UEDPIE_0_" .. StepId
  end
  self.LevelID2GridFrame:Remove(tostring(RoomId))
  UAsyncFunctionLibrary.UnloadStreamLevelWithID(self, StepId .. "-" .. RoomId .. "_Art", RoomId, false)
  UAsyncFunctionLibrary.UnloadStreamLevelWithID(self, StepId .. "-" .. RoomId .. "_Design", RoomId * 1000, false)
  if self.RoomId2StreamLevel[RoomId][2] then
    UAsyncFunctionLibrary.UnloadStreamLevelWithID(self, StepId .. "-" .. RoomId .. "_NavMesh", RoomId * 1000 + 1, false)
  end
  if #self.RoomId2StreamLevel[RoomId][4] > 0 then
    UAsyncFunctionLibrary.UnloadStreamLevelWithID(self, StepId .. "-" .. RoomId .. "_Sound", RoomId * 1000 + 2, false)
  end
  if #self.RoomId2StreamLevel[RoomId][5] > 0 then
    UAsyncFunctionLibrary.UnloadStreamLevelWithID(self, StepId .. "-" .. RoomId .. "_Effect", RoomId * 1000 + 3, false)
  end
  self.RoomId2StreamLevel[RoomId] = nil
  self.ID2DesignStreamingLevel[tostring(RoomId)] = nil
end

function M:GetCurrentRoomDesignPath()
  if self.CurrentRoomId and self.RoomData and self.RoomData[self.CurrentRoomId] then
    self:PrintRougeLikeLevelLoader("GetCurrentRoomDesignPath", self.CurrentRoomId)
    PrintTable(self.RoomData, 2)
    return self.CurrentRoomId, self.RoomData[self.CurrentRoomId].DesignDataPath
  end
  return nil
end

function M:LoadStreamLevelByRoomId(RoomId, Index)
  self.LoadingFlag = true
  local artPath = self.RoomData[RoomId].ArtDataPath
  local designPath = self.RoomData[RoomId].DesignDataPath
  local navPath = string.gsub(artPath, "_Art", "_NavMesh")
  navPath = string.gsub(navPath, "_Layout", "_NavMesh")
  local soundPath = string.gsub(artPath, "_Art", "_Sound")
  local effectPath = string.gsub(artPath, "_Art", "_Effect")
  if self.IsMobile then
    local tempPath = string.gsub(artPath, "/Maps/", "/Maps_Phone/")
    if UResourceLibrary.CheckResourceExistOnDisk(tempPath) then
      artPath = tempPath
    end
  end
  local success = false
  local streamLevel
  self.RoomId2StreamLevel[RoomId] = {}
  local location = self:GetRoomLocation(Index)
  self:PrintRougeLikeLevelLoader("RoomId and Location:", RoomId, Index, location)
  success, streamLevel = ULevelStreamingDynamic.LoadLevelInstance(self, designPath, location, FRotator(), success, Index .. "-" .. RoomId .. "_Design")
  table.insert(self.RoomId2StreamLevel[RoomId], streamLevel)
  self.ID2DesignStreamingLevel[tostring(RoomId)] = streamLevel
  success, streamLevel = ULevelStreamingDynamic.LoadLevelInstance(self, navPath, location, FRotator(), success, Index .. "-" .. RoomId .. "_NavMesh")
  table.insert(self.RoomId2StreamLevel[RoomId], streamLevel)
  self.LevelName2Center:Add(navPath, FVector2D(0, 0))
  self.StreamLevel2ID:Add(streamLevel, RoomId)
  self.LevelID2Yaw:Add(RoomId, 0)
  success, streamLevel = ULevelStreamingDynamic.LoadLevelInstance(self, artPath, location, FRotator(), success, Index .. "-" .. RoomId .. "_Art")
  table.insert(self.RoomId2StreamLevel[RoomId], streamLevel)
  streamLevel.OnLevelLoaded:Add(self, function()
    self:OnArtLevelLoaded(RoomId)
  end)
  success, streamLevel = ULevelStreamingDynamic.LoadLevelInstance(self, soundPath, location, FRotator(), success, Index .. "-" .. RoomId .. "_Sound")
  table.insert(self.RoomId2StreamLevel[RoomId], {streamLevel})
  success, streamLevel = ULevelStreamingDynamic.LoadLevelInstance(self, effectPath, location, FRotator(), success, Index .. "-" .. RoomId .. "_Effect")
  table.insert(self.RoomId2StreamLevel[RoomId], {streamLevel})
end

function M:GetRoomLocation(Index)
  return FVector(self.LevelSpacing * (Index - 5), self.LevelSpacing * (Index - 5), 0)
end

function M:ReceiveEndPlay(reason)
end

function M:K2_GetArtPathByLevelId(LevelId)
  if not self.ID2DesignStreamingLevel[LevelId] then
    return
  end
  local transform = self.ID2DesignStreamingLevel[LevelId].LevelTransform
  return self.RoomData[tonumber(LevelId)].ArtDataPath, transform.Translation, transform.Rotation
end

function M:PrintRougeLikeLevelLoader(...)
  print(_G.LogTag, "RougeLike_Pro_LevelLoader", ...)
end

function M:CheckIsRougeLike()
  return true
end

function M:GetLevelIdByLevel(InLevel)
  for RoomId, Table in pairs(self.RoomId2StreamLevel) do
    if Table[2] and Table[2]:GetLoadedLevel() and Table[2]:GetLoadedLevel() == InLevel then
      return RoomId
    end
  end
  return ""
end

function M:GetActorInLevelTransform(InActor)
  print("RougeLike Pro EnvirSystemActor GetActorInLevelTransform")
  if not self.RoomId2StreamLevel then
    return FTransform()
  end
  local Level = UE4.URuntimeCommonFunctionLibrary.GetLevel(InActor)
  for Id, StreamLevelTable in pairs(self.RoomId2StreamLevel) do
    if StreamLevelTable and StreamLevelTable[3] and StreamLevelTable[3]:GetLoadedLevel() == Level then
      return StreamLevelTable[3].LevelTransform
    end
  end
  return FTransform()
end

function M:TeleportInDedicatedServer(PlayerCharacter, TargetPosition, TargetRotation, TeleportTag)
  if IsDedicatedServer(self) then
    URuntimeCommonFunctionLibrary.ResetCharacterBaseLocation(PlayerCharacter, TargetPosition, true)
    PlayerCharacter:MulticastSetPlayerRotation(TargetRotation)
    if PlayerCharacter:GetMovementComponent() then
      PlayerCharacter:GetMovementComponent():ForceClientUpdate()
    end
    PlayerCharacter:TeleportFollowSummons(TargetPosition, TargetRotation)
    PlayerCharacter.RPCComponent:TeleportInDedicatedServer(TargetPosition, TargetRotation, TeleportTag)
    PlayerCharacter:GetEMPlayerState():SetIsDedicatedServerTeleporting(true)
    self:PrintRougeLikeLevelLoader("SetIsDedicatedServerTeleporting true")
  elseif IsClient(self) or IsStandAlone(self) then
    if IsStandAlone(self) then
      PlayerCharacter:GetEMPlayerState():SetIsDedicatedServerTeleporting(true)
      PlayerCharacter:GetMovementComponent():SetMovementMode(UE4.EMovementMode.Move_None)
    end
    self.LoadingUI = GWorld.GameInstance:ShowLoadingUI(UIConst.COMMONCHANGESCENE)
    self.LoadingUI:AddQuene(100)
    self:PrintRougeLikeLevelLoader("TeleportInDedicatedServer End!!!!!!!!!!!", TeleportTag)
    if IsValid(PlayerCharacter) then
      if IsStandAlone(self) then
        URuntimeCommonFunctionLibrary.ResetCharacterBaseLocation(PlayerCharacter, TargetPosition, true)
        PlayerCharacter:MulticastSetPlayerRotation(TargetRotation)
        local MovementComponent = PlayerCharacter:GetMovementComponent()
        MovementComponent:SetMovementMode(MovementComponent.DefaultLandMovementMode)
        PlayerCharacter:TeleportFollowSummons(TargetPosition, TargetRotation)
      end
      PlayerCharacter.RPCComponent:TeleportInDedicatedServerEnd(TeleportTag)
    end
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState.ShouldStopHookInDungeonDelivery then
      GameState.ShouldStopHookInDungeonDelivery = false
    end
  end
  return true
end

function M:SetEnteredPlayerTrans(PlayerController)
  if not self.InitTargetPoint then
    error("SetEnteredPlayerTrans Error")
  else
    self.InitTargetPoint:SetEnteredPlayerTrans(PlayerController)
  end
end

function M:RealSetNewEnteredPlayerTrans(AvatarEidStr)
  if self.InitTargetPoint == nil then
    error("RealSetNewEnteredPlayerTrans Error")
  else
    self.InitTargetPoint:RealSetNewEnteredPlayerTrans(AvatarEidStr, true)
  end
end

return M
