local Component = {}
local NumberModel = require("BluePrints.UI.UI_PC.Archive.WBP_Archive_Number_Model")
local AppearanceNumberModel = require("BluePrints.UI.WBP.Appearance.WBP_AppearanceArchive_Number_Model")

function Component:EnterWorld()
  self:RefreshArchiveReddot()
  self:RefreshAppearanceArchiveReddot()
  self:RefreshAppearanceFenghuaReddot()
end

function Component:GetArchiveReward(CallBackFunction, ArchiveId, ArchiveCount)
  self.logger.debug("GetArchiveReward Begin", ArchiveId, ArchiveCount)
  
  local function Callback(Ret, RewardReturn)
    CallBackFunction(Ret, RewardReturn)
    self.logger.debug("GetArchiveReward Callback", Ret, ArchiveId, ArchiveCount, RewardReturn)
  end
  
  self:CallServer("GetArchiveReward", Callback, ArchiveId, ArchiveCount)
end

function Component:GetAllArchiveReward(CallBackFunction, ArchiveId)
  self.logger.debug("GetAllArchiveReward Begin", ArchiveId)
  
  local function Callback(Ret, RewardReturn)
    CallBackFunction(Ret, RewardReturn)
    self.logger.debug("GetAllArchiveReward Callback", Ret, ArchiveId, RewardReturn)
  end
  
  self:CallServer("GetAllArchiveReward", Callback, ArchiveId)
end

function Component:_OnPropChangeArchives(key)
  local ArchiveType = key[1]
  self:_TryAddRewardReddotCommon(ArchiveType)
  self:_TryAddNewReddot(ArchiveType)
end

function Component:_TryAddRewardReddotCommon(ArchiveType)
  local Info = DataMgr.ArchiveInfo[ArchiveType]
  local Count = NumberModel:GetCurrentNumber(ArchiveType)
  local SumNum = NumberModel["Get" .. NumberModel.ArchiveType2Name[ArchiveType] .. "SumNumber"](NumberModel)
  if Count > SumNum then
    Count = SumNum
  end
  if not ReddotManager.GetTreeNode("ArchiveReward") then
    ReddotManager.AddNode("ArchiveReward")
  end
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("ArchiveReward")
  local IncreaceNum = 0
  for i = Info.ArchiveStep, Count, Info.ArchiveStep do
    if not self.Archives[Info.ArchiveType].ArchiveRewardGot[i] then
      if not CacheDetail[Info.ArchiveType] then
        CacheDetail[Info.ArchiveType] = {}
      end
      if not CacheDetail[Info.ArchiveType][i] then
        CacheDetail[Info.ArchiveType][i] = 1
        IncreaceNum = IncreaceNum + 1
      end
    end
  end
  if IncreaceNum > 0 then
    ReddotManager.IncreaseLeafNodeCount("ArchiveReward", IncreaceNum)
  end
end

function Component:_TryAddNewReddot(ArchiveType, RefreshAll)
  local NodeName = self:GetNodeName(ArchiveType)
  self:_TryAddNewReddotCommon(ArchiveType, NodeName, RefreshAll)
end

function Component:_TryAddNewReddotCommon(ArchiveType, NodeName, RefreshAll)
  if NodeName then
    if not ReddotManager.GetTreeNode(NodeName) then
      ReddotManager.AddNode(NodeName)
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
    if RefreshAll and CacheDetail then
      for Id, Value in pairs(CacheDetail) do
        if 1 == Value then
          CacheDetail[Id] = nil
        end
      end
    end
    local IncreaceNum = 0
    for Id, _ in pairs(self.Archives[ArchiveType].ArchiveList) do
      if not CacheDetail[Id] then
        CacheDetail[Id] = 1
        IncreaceNum = IncreaceNum + 1
      end
    end
    if IncreaceNum > 0 then
      ReddotManager.IncreaseLeafNodeCount(NodeName, IncreaceNum)
    end
  end
end

function Component:GetNodeName(ArchiveType)
  local NodeName
  if 1001 == ArchiveType then
    NodeName = DataMgr.ReddotNode.ArchiveNewChar.Name
  elseif 1002 == ArchiveType then
    NodeName = DataMgr.ReddotNode.ArchiveNewMelee.Name
  elseif 1003 == ArchiveType then
    NodeName = DataMgr.ReddotNode.ArchiveNewRanged.Name
  elseif 1004 == ArchiveType then
    NodeName = DataMgr.ReddotNode.ArchiveNewResource.Name
  elseif 1005 == ArchiveType then
    NodeName = DataMgr.ReddotNode.ArchiveNewReadBook.Name
  elseif 1006 == ArchiveType then
    NodeName = DataMgr.ReddotNode.ArchiveNewMonster.Name
  end
  return NodeName
end

function Component:RefreshArchiveReddot()
  if not ReddotManager.GetTreeNode("ArchiveReward") then
    ReddotManager.AddNode("ArchiveReward")
  end
  ReddotManager.ClearLeafNodeCount("ArchiveReward", true)
  for ArchiveType = 1001, 1006 do
    self:_TryAddRewardReddotCommon(ArchiveType)
    self:_TryAddNewReddot(ArchiveType, true)
  end
end

function Component:GetAppearanceCollectReward(CallBackFunction, EntranceId, targetGear)
  self.logger.debug("GetAppearanceCollectReward Begin", EntranceId, targetGear)
  
  local function Callback(Ret, RewardReturn)
    CallBackFunction(Ret, RewardReturn)
    self.logger.debug("GetAppearanceCollectReward Callback", Ret, EntranceId, targetGear, RewardReturn)
  end
  
  self:CallServer("GetAppearanceCollectReward", Callback, EntranceId, targetGear)
end

function Component:GetAllAppearanceCollectReward(CallBackFunction, EntranceId)
  self.logger.debug("GetAllAppearanceCollectReward Begin", EntranceId)
  
  local function Callback(Ret, RewardReturn)
    CallBackFunction(Ret, RewardReturn)
    self.logger.debug("GetAllAppearanceCollectReward Callback", Ret, EntranceId, RewardReturn)
  end
  
  self:CallServer("GetAllAppearanceCollectReward", Callback, EntranceId)
end

function Component:GetAppearanceAllScoreRPC(CallBackFunction, TargetType, TargetId)
  self.logger.debug("GetAppearanceAllScoreRPC Begin", TargetType, TargetId)
  
  local function Callback(Ret, ScoreInfo)
    if ScoreInfo then
      CallBackFunction(Ret, ScoreInfo)
      self.logger.debug("GetAppearanceAllScoreRPC Callback", Ret, TargetType, TargetId, ScoreInfo.BaseScore, ScoreInfo.SkinUpgradeScore, ScoreInfo.DyeScore)
    end
  end
  
  self:CallServer("GetAppearanceAllScoreRPC", Callback, TargetType, TargetId)
end

function Component:GetAppearanceAllScore(TargetType, TargetId)
  if not TargetType or not TargetId then
    return nil
  end
  local EntranceInfo = self:CheckAppearanceCollectType(TargetId, TargetType)
  if not EntranceInfo or not EntranceInfo.EntranceId then
    return nil
  end
  local AppearanceCollect = self.AppearanceCollects:GetAppearanceCollect(EntranceInfo.EntranceId)
  local AppearanceCollectItem = AppearanceCollect:GetAppearanceCollectItem(TargetType, TargetId)
  if not AppearanceCollectItem then
    return nil
  end
  local ScoreInfo = {
    BaseScore = self:GetAppearanceScore(TargetType, TargetId),
    SkinUpgradeScore = 0,
    DyeScore = 0
  }
  if TargetType == CommonConst.AppearanceCollectType.Skin then
    local SkinUpgradeLevel = AppearanceCollectItem.UpgradeSkinLevelRecord or 0
    local SkinUpgradeInfo = DataMgr.SkinUpgrade and DataMgr.SkinUpgrade[TargetId]
    for _, LevelInfo in pairs(SkinUpgradeInfo or {}) do
      if LevelInfo and LevelInfo.Step and SkinUpgradeLevel >= LevelInfo.Step then
        ScoreInfo.SkinUpgradeScore = ScoreInfo.SkinUpgradeScore + (LevelInfo.ScoreAddValue or 0)
      end
    end
  end
  if self:CheckAppearanceAddDyeScore(TargetId, TargetType) then
    for _, Score in pairs(AppearanceCollectItem.DyeScoreRecord or {}) do
      if type(Score) == "number" and Score > 0 then
        ScoreInfo.DyeScore = ScoreInfo.DyeScore + Score
      end
    end
  end
  return ScoreInfo
end

function Component:CheckAppearanceAddDyeScore(TargetId, TargetType)
  if not TargetId or not TargetType then
    return false
  end
  local AppearanceCollectType = CommonConst.AppearanceCollectType
  if TargetType == AppearanceCollectType.Skin then
    local SkinInfo = DataMgr.Skin and DataMgr.Skin[TargetId]
    if not SkinInfo then
      return false
    end
    return SkinInfo.SkinSeries ~= nil or nil ~= SkinInfo.SkinTag
  elseif TargetType == AppearanceCollectType.Hair then
    local HairInfo = DataMgr.Hair and DataMgr.Hair[TargetId]
    if not HairInfo then
      return false
    end
    return nil ~= HairInfo.CharId and 0 ~= HairInfo.CharId
  elseif TargetType == AppearanceCollectType.WeaponSkin then
    return nil ~= DataMgr.WeaponSkin and nil ~= DataMgr.WeaponSkin[TargetId]
  end
  return false
end

function Component:CheckAppearanceCollectType(TargetId, TargetType)
  local EntranceInfo = DataMgr.AppearanceCollectType2Entrance[TargetType]
  if not EntranceInfo then
    return nil
  end
  local TableData = DataMgr[TargetType] and DataMgr[TargetType][TargetId]
  if not TableData then
    return nil
  end
  if TableData.ExcludeCollect == true then
    return nil
  end
  if EntranceInfo.FieldName and EntranceInfo.SubTypes then
    local SubType = TableData[EntranceInfo.FieldName]
    if not SubType or not EntranceInfo.SubTypes[tostring(SubType)] then
      return nil
    end
  end
  return EntranceInfo
end

function Component:GetAppearanceCollectScoreRPC(CallBackFunction, EntranceId)
  if type(CallBackFunction) ~= "function" then
    EntranceId = CallBackFunction
    CallBackFunction = nil
  end
  self.logger.debug("GetAppearanceCollectScoreRPC Begin", EntranceId)
  
  local function Callback(Ret, TotalScore)
    if type(CallBackFunction) == "function" then
      CallBackFunction(Ret, TotalScore)
    end
    self.logger.debug("GetAppearanceCollectScoreRPC Callback", Ret, EntranceId, TotalScore)
  end
  
  self:CallServer("GetAppearanceCollectScoreRPC", Callback, EntranceId)
end

function Component:GetAppearanceTotalScoreRPC(CallBackFunction)
  self.logger.debug("GetAppearanceTotalScoreRPC Begin")
  
  local function Callback(Ret, TotalScore)
    if type(CallBackFunction) == "function" then
      CallBackFunction(Ret, TotalScore)
    end
    self.logger.debug("GetAppearanceTotalScoreRPC Callback", Ret, TotalScore)
  end
  
  self:CallServer("GetAppearanceTotalScoreRPC", Callback)
end

function Component:GetAppearanceScoreRewardRPC(CallBackFunction, TargetScore)
  if type(CallBackFunction) ~= "function" then
    TargetScore = CallBackFunction
    CallBackFunction = nil
  end
  self.logger.debug("GetAppearanceScoreRewardRPC Begin", TargetScore)
  
  local function Callback(Ret, RewardReturn)
    if type(CallBackFunction) == "function" then
      CallBackFunction(Ret, RewardReturn)
    end
    self.logger.debug("GetAppearanceScoreRewardRPC Callback", Ret, TargetScore, RewardReturn)
  end
  
  self:CallServer("GetAppearanceScoreRewardRPC", Callback, TargetScore)
end

function Component:GetAllAppearanceScoreRewardRPC(CallBackFunction)
  self.logger.debug("GetAllAppearanceScoreRewardRPC Begin")
  
  local function Callback(Ret, RewardReturn)
    if type(CallBackFunction) == "function" then
      CallBackFunction(Ret, RewardReturn)
    end
    self.logger.debug("GetAllAppearanceScoreRewardRPC Callback", Ret, RewardReturn)
  end
  
  self:CallServer("GetAllAppearanceScoreRewardRPC", Callback)
end

function Component:_OnPropChangeAppearanceCollects(key)
  local EntranceId = key[1]
  self:_TryAddAppearanceRewardReddotCommon(EntranceId)
  self:_TryAddAppearanceRewardNewCommon(EntranceId)
end

function Component:_TryAddAppearanceRewardReddotCommon(EntranceId)
  local Info = DataMgr.AppearanceCollect[EntranceId]
  local Count = AppearanceNumberModel:GetCurrentNumber(Info.Entrance)
  local SumNum = AppearanceNumberModel["Get" .. Info.Type .. "SumNumber"](AppearanceNumberModel)
  if Count > SumNum then
    Count = SumNum
  end
  if not ReddotManager.GetTreeNode("AppearanceArchiveReward") then
    ReddotManager.AddNode("AppearanceArchiveReward")
  end
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AppearanceArchiveReward")
  local IncreaceNum = 0
  for Index, Target in ipairs(Info.QuantityTarget) do
    if Target <= Count and (not (self.AppearanceCollects and self.AppearanceCollects[Info.Entrance] and self.AppearanceCollects[Info.Entrance].AppearanceCollectRewardGot) or not self.AppearanceCollects[Info.Entrance].AppearanceCollectRewardGot[Index]) then
      if not CacheDetail[Info.Entrance] then
        CacheDetail[Info.Entrance] = {}
      end
      if not CacheDetail[Info.Entrance][Index] then
        CacheDetail[Info.Entrance][Index] = 1
        IncreaceNum = IncreaceNum + 1
      end
    end
  end
  if IncreaceNum > 0 then
    ReddotManager.IncreaseLeafNodeCount("AppearanceArchiveReward", IncreaceNum)
  end
end

function Component:_TryAddAppearanceRewardNewCommon(EntranceId, RefreshAll, IsFirstTime)
  if self.AppearanceCollects and self.AppearanceCollects[EntranceId] and self.AppearanceCollects[EntranceId].AppearanceCollectList then
    local AppearanceCollectList = self.AppearanceCollects[EntranceId].AppearanceCollectList
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AppearanceArchiveNew")
    if RefreshAll and CacheDetail[EntranceId] then
      if CacheDetail[EntranceId].Ids then
        for Id, Value in pairs(CacheDetail[EntranceId].Ids) do
          if 1 == Value then
            CacheDetail[EntranceId].Ids[Id] = nil
          end
        end
      end
      if CacheDetail[EntranceId].Num then
        CacheDetail[EntranceId].Num = 0
      end
    end
    local IncreaceNum = 0
    for Id, _ in pairs(AppearanceCollectList) do
      if not AppearanceNumberModel:CheckItemIsExcludedCollect(Id) then
        if not CacheDetail[EntranceId] then
          CacheDetail[EntranceId] = {
            Num = 0,
            Ids = {}
          }
        end
        if not CacheDetail[EntranceId].Ids[Id] then
          if IsFirstTime then
            CacheDetail[EntranceId].Ids[Id] = 0
          else
            CacheDetail[EntranceId].Ids[Id] = 1
            IncreaceNum = IncreaceNum + 1
          end
        end
      end
    end
    if CacheDetail[EntranceId] then
      if CacheDetail[EntranceId].Num then
        CacheDetail[EntranceId].Num = CacheDetail[EntranceId].Num + IncreaceNum
      else
        CacheDetail[EntranceId].Num = IncreaceNum
      end
    end
    if IncreaceNum > 0 then
      ReddotManager.IncreaseLeafNodeCount("AppearanceArchiveNew", IncreaceNum)
    end
  end
end

function Component:RefreshAppearanceArchiveReddot()
  if not ReddotManager.GetTreeNode("AppearanceArchiveReward") then
    ReddotManager.AddNode("AppearanceArchiveReward")
  end
  ReddotManager.ClearLeafNodeCount("AppearanceArchiveReward", true)
  if not ReddotManager.GetTreeNode("AppearanceArchiveNew") then
    ReddotManager.AddNode("AppearanceArchiveNew")
  end
  ReddotManager.ClearLeafNodeCount("AppearanceArchiveNew")
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AppearanceArchiveNew")
  local IsFirstTime = false
  if not CacheDetail.FirstTimeFinished then
    IsFirstTime = true
    CacheDetail.FirstTimeFinished = true
  end
  for _, Info in pairs(DataMgr.AppearanceCollect) do
    self:_TryAddAppearanceRewardReddotCommon(Info.Entrance)
    self:_TryAddAppearanceRewardNewCommon(Info.Entrance, true, IsFirstTime)
  end
end

function Component:_OnPropChangeAppearanceScores(key)
  if "Total" == key[1] then
    self:_TryAddAppearanceFenghuaRewardReddot()
  end
end

function Component:_TryAddAppearanceFenghuaRewardReddot()
  local TotalScore = self.AppearanceScores.Total
  if TotalScore then
    if not ReddotManager.GetTreeNode("AppearanceFenghuaReward") then
      ReddotManager.AddNode("AppearanceFenghuaReward")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AppearanceFenghuaReward")
    local IncreaseNum = 0
    for _, Info in pairs(DataMgr.ScoreReward) do
      if Info.ScoreTarget and TotalScore >= Info.ScoreTarget and not self.AppearanceScoreRewards[Info.ScoreTarget] and not CacheDetail[Info.ScoreTarget] then
        CacheDetail[Info.ScoreTarget] = 1
        IncreaseNum = IncreaseNum + 1
      end
    end
    if IncreaseNum > 0 then
      ReddotManager.IncreaseLeafNodeCount("AppearanceFenghuaReward", IncreaseNum)
    end
  end
end

function Component:RefreshAppearanceFenghuaReddot()
  if not ReddotManager.GetTreeNode("AppearanceFenghuaReward") then
    ReddotManager.AddNode("AppearanceFenghuaReward")
  end
  ReddotManager.ClearLeafNodeCount("AppearanceFenghuaReward", true)
  self:_TryAddAppearanceFenghuaRewardReddot()
end

return Component
