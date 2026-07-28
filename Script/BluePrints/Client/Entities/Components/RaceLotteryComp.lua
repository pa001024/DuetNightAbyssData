local Component = {}
local RacingOutsiderController = require("BluePrints.UI.WBP.Activity.Widget.Racing.Outsider.RacingOutsiderController")

function Component:EnterWorld()
  DebugPrint("RaceLotteryComp EnterWorld")
  RacingOutsiderController:Init()
end

function Component:LeaveWorld()
  DebugPrint("RaceLotteryComp LeaveWorld")
  RacingOutsiderController:Destory()
end

function Component:RaceLotteryChangeStatus(NewStatus)
  DebugPrint("RaceLotteryChangeStatus NewStatus= " .. tostring(NewStatus))
  if 1 == NewStatus then
    RacingOutsiderController:OnRefreshInNextDay()
    self:RaceLotteryQueryPlayerList()
  end
  if 2 == NewStatus then
    RacingOutsiderController:EightStatusUpdate()
    ReddotManager.ClearLeafNodeCount("RacingChoosePet", false)
  end
  if 3 == NewStatus then
    RacingOutsiderController:EightThirtyStatusUpdate()
    ReddotManager.ClearLeafNodeCount("RacingChoosePet", false)
  end
end

function Component:OnLoginSuccess()
  RacingOutsiderController:InitModelData()
end

function Component:RaceLotteryQueryPlayerList()
  local function CallBack(RetCode, res)
    self.logger.info(string.format("RaceLotteryQueryPlayerList RetCode=%s, res=%s", tostring(RetCode), CommonUtils.TableToString3(res)))
    
    for PlayerId, Speed in pairs(res) do
      self.logger.info(string.format("RaceLotteryQueryPlayerList PlayerId = %s, Speed = %s", tostring(PlayerId), CommonUtils.TableToString3(Speed)))
    end
    if ErrorCode:Check(RetCode) then
      RacingOutsiderController:SetTodayPlayerList(res)
    end
  end
  
  self:CallServer("RaceLotteryQueryPlayerList", CallBack)
end

function Component:RaceLotterySelectPlayer(PlayerList, InCallback)
  local function CallBack(RetCode)
    self.logger.info(string.format("RaceLotterySelectPlayer RetCode = %s", tostring(RetCode)))
    
    if InCallback then
      InCallback(RetCode)
    end
  end
  
  self:CallServer("RaceLotterySelectPlayer", CallBack, PlayerList)
end

function Component:RaceLotteryAddAnteNum(AnteNum, InCallback)
  local function CallBack(RetCode)
    self.logger.info(string.format("RaceLotteryAddAnteNum RetCode = %s self.RaceLotteryInfo.RaceLotteryAnteNum = %s", tostring(RetCode), tostring(self.RaceLotteryInfo.RaceLotteryAnteNum)))
    
    if InCallback then
      InCallback(RetCode)
    end
  end
  
  self:CallServer("RaceLotteryAddAnteNum", CallBack, AnteNum)
end

function Component:RaceLotteryQueryPlayerRumor(PlayerId, InCallback)
  local function CallBack(RetCode)
    self.logger.info(string.format("RaceLotteryQueryPlayerRumor RetCode = %s", tostring(RetCode)))
    
    if InCallback then
      InCallback(RetCode)
    end
  end
  
  self:CallServer("RaceLotteryQueryPlayerRumor", CallBack, PlayerId)
end

function Component:RacceLotteryQueryJoinPlayerTotalCostSecond(InCallback)
  local function CallBack(RetCode, list)
    self.logger.info(string.format("RacceLotteryQueryJoinPlayerTotalCostSecond RetCode = %s res = %s", tostring(RetCode), CommonUtils.TableToString3(list)))
    
    if InCallback then
      InCallback(RetCode, list)
    end
  end
  
  self:CallServer("RacceLotteryQueryJoinPlayerTotalCostSecond", CallBack)
end

function Component:RaceLotteryGetReward()
  local function CallBack(RetCode, TargetResource)
    self.logger.info(string.format("RaceLotteryGetReward RetCode = %s ", tostring(RetCode)))
    
    if ErrorCode:Check(RetCode) then
      if TargetResource then
        local RaceLotteryCurrency = tonumber(DataMgr.RaceLotteryConstant.RaceLotteryCurrency.ConstantValue)
        local RewardData = DataMgr.Resource[RaceLotteryCurrency]
        local ItemType = CommonConst.DataType.Resource
        local ResourceNum = TargetResource[RaceLotteryCurrency]
        UIUtils.ShowGetItemPageAndOpenBagIfNeeded(ItemType, RaceLotteryCurrency, ResourceNum, nil, false, nil, self, false)
      end
      local WatchAndGetRewardReddot = ReddotManager.GetTreeNode("RacingWatchAndGetReward")
      if WatchAndGetRewardReddot then
        ReddotManager.ClearLeafNodeCount("RacingWatchAndGetReward", true)
      end
    end
  end
  
  self:CallServer("RaceLotteryGetReward", CallBack)
end

function Component:RaceLotteryQueryRaceInfo(PlayerId, RaceId)
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  if not GameState then
    return
  end
  local PetId = PlayerId
  
  local function CallBack(RetCode, RaceProcessTotalRecord)
    self.logger.info(string.format("RaceLotteryQueryRaceInfo RetCode = %s RaceProcessTotalRecord = %s", tostring(RetCode), CommonUtils.TableToString3(RaceProcessTotalRecord)))
    if 0 ~= RetCode then
      return
    end
    local Spline = GameState.PetRaceSplineMaps:FindRef(RaceId)
    if Spline then
      Spline:InitPetRaceAllBuffIno(PetId, RaceProcessTotalRecord)
    end
  end
  
  self:CallServer("RaceLotteryQueryRaceInfo", CallBack, PetId)
end

function Component:RaceLotteryQueryRaceTrack(RaceId, RaceSamplesNum)
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  if not GameState then
    return
  end
  
  local function CallBack(RetCode, TrackData)
    self.logger.info(string.format("RaceLotteryQueryRaceTrack RetCode = %s TrackData = %s", tostring(RetCode), CommonUtils.TableToString3(TrackData)))
    if 0 ~= RetCode then
      UIManager(GWorld.GameInstance):SetBannedActionCallback("BlackScreen", false, "PetRaceStart")
      return
    end
    local Spline = GameState.PetRaceSplineMaps:FindRef(RaceId)
    if Spline then
      Spline:StartPetRaceProcess(TrackData)
    end
  end
  
  self:CallServer("RaceLotteryQueryRaceTrack", CallBack, RaceSamplesNum)
end

function Component:RaceLotteryQueryRandomRaceId()
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  if not GameState then
    UIManager(GWorld.GameInstance):SetBannedActionCallback("BlackScreen", false, "PetRaceStart")
    return
  end
  
  local function CallBack(RetCode, RandomRaceId)
    self.logger.info(string.format("RaceLotteryQueryRandomRaceId RetCode = %s RandomRaceId = %s", tostring(RetCode), tostring(RandomRaceId)))
    if 0 ~= RetCode then
      UIManager(GWorld.GameInstance):SetBannedActionCallback("BlackScreen", false, "PetRaceStart")
      return
    end
    local RaceId = RandomRaceId
    local Spline = GameState.PetRaceSplineMaps:FindRef(RaceId)
    if Spline then
      local RaceSamplesNum = Spline:GetRaceSampleNum()
      DebugPrint("PetRaceLotteryGame RaceLotteryQueryRandomRaceId, RaceId:", RaceId, "RaceSamplesNum:", RaceSamplesNum)
      if RaceSamplesNum < tonumber(DataMgr.RaceLotteryConstant.RaceTrackNumSamples_Min.ConstantValue) or RaceSamplesNum > tonumber(DataMgr.RaceLotteryConstant.RaceTrackNumSamples_Max.ConstantValue) then
        local GameInstance = GWorld.GameInstance
        local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
        Battle(PlayerCharacter):ShowError_Monster_Inner_Lua("魔灵赛跑: @luohanqing, RaceSamplesNum Error:" .. RaceSamplesNum, "PetRace")
      end
      self:RaceLotteryQueryRaceTrack(RaceId, RaceSamplesNum)
    end
  end
  
  self:CallServer("RaceLotteryQueryRandomRaceId", CallBack)
end

return Component
