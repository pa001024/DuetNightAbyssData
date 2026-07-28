require("UnLua")
local AutoChessConst = require("BluePrints.UI.AutoChess.AutoChessConst")
local SkillUtils = require("Utils.SkillUtils")
local TimeUtils = require("Utils.TimeUtils")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local AutoChessDataModel = {}
local ActiveId = AutoChessConst.ActiveId

function AutoChessDataModel:InitModel()
  self:InitReddotTree()
end

function AutoChessDataModel:SetEditingSquadIndex(Index)
  self.EditingSuqadIndex = Index
end

function AutoChessDataModel:GetEditingSuqadIndex()
  return self.EditingSuqadIndex
end

function AutoChessDataModel:InitReddotTree()
  if not ActivityUtils.CheckEventIsOpen(ActiveId) then
    ReddotManager.ClearLeafNodeCount("Acti_AutoChess", true)
    ReddotManager.ClearLeafNodeCount("AutoChessLinear", true)
    ReddotManager.ClearLeafNodeCount("AutoChessReward", true)
    return
  end
  if not ReddotManager.GetTreeNode("Acti_AutoChess") then
    ReddotManager.AddNodeEx("Acti_AutoChess")
  end
  self:RefreshAutoChessLinearReddot()
end

function AutoChessDataModel:RefreshAutoChessLinearReddot()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  
  local function CheckTimeLock(Info)
    local UnlockDay = Info.UnlockDay
    local EventStartTime = DataMgr.EventMain[AutoChessConst.ActiveId].EventStartTime
    local StartTimestamp = EventStartTime:GetTime()
    local CurrentTime = TimeUtils.NowTime()
    local StartDate = os.date("*t", StartTimestamp)
    local RefreshHour = TimeUtils.RefreshHMS[1] or 5
    local RefreshMin = TimeUtils.RefreshHMS[2] or 0
    local RefreshSec = TimeUtils.RefreshHMS[3] or 0
    local FirstRefreshTime = os.time({
      year = StartDate.year,
      month = StartDate.month,
      day = StartDate.day,
      hour = RefreshHour,
      min = RefreshMin,
      sec = RefreshSec
    })
    if StartTimestamp >= FirstRefreshTime then
      FirstRefreshTime = FirstRefreshTime + 86400
    end
    local UnlockTime = FirstRefreshTime + (UnlockDay - 2) * 86400
    if CurrentTime < UnlockTime then
      return false
    end
    return true
  end
  
  local function CheckLinear(Info)
    if Avatar.Dungeons[Info.DungeonId] and Avatar.Dungeons[Info.DungeonId].IsPass then
      return false
    else
      if Info.UnlockMissionId then
        local PreInfo = DataMgr.AutoChessMission[Info.UnlockMissionId]
        if not Avatar.Dungeons[PreInfo.DungeonId] or not Avatar.Dungeons[PreInfo.DungeonId].IsPass then
          return false
        end
      end
      if Info.UnlockDay then
        local TimeUnlock = CheckTimeLock(Info)
        if not TimeUnlock then
          return false
        end
      end
    end
    return true
  end
  
  if not self:IsAutoChessUnlock() then
    return
  end
  for key, value in pairs(DataMgr.AutoChessMission) do
    if 1 == value.MissionType and CheckLinear(value) then
      local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(DataMgr.ReddotNode.AutoChessLinear.Name)
      if CacheDetail and nil == CacheDetail[key] then
        CacheDetail[key] = true
        ReddotManager.IncreaseLeafNodeCount(DataMgr.ReddotNode.AutoChessLinear.Name, 1)
      end
    end
  end
end

function AutoChessDataModel:IsAutoChessUnlock()
  local function GetQuestChainState(QuestChainId)
    local Avatar = GWorld:GetAvatar()
    
    if not Avatar.QuestChains[QuestChainId] then
      return "Unlock"
    end
    if Avatar.QuestChains[QuestChainId]:IsFinish() then
      return "Finish"
    elseif Avatar.QuestChains[QuestChainId]:IsDoing() then
      return "Doing"
    else
      return "Unlock"
    end
  end
  
  if not ActivityUtils.CheckEventIsOpen(ActiveId) or GetQuestChainState(DataMgr.EventMain[ActiveId].PretextTasks1) == "Unlock" then
    return false
  end
  return true
end

function AutoChessDataModel:CheckLinearIsNew(MissionId)
  local Node = ReddotManager.GetTreeNode("AutoChessLinear")
  if Node and Node.Cache.Detail and Node.Cache.Detail[MissionId] then
    return true
  end
  return false
end

function AutoChessDataModel:DecreaseLinearReddotById(MissionId)
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(DataMgr.ReddotNode.AutoChessLinear.Name)
  if not MissionId and CacheDetail then
    local AllUnlockedLevels = {}
    for Id, _ in pairs(CacheDetail) do
      if true == CacheDetail[Id] then
        table.insert(AllUnlockedLevels, Id)
        CacheDetail[Id] = false
      end
    end
    ReddotManager.ClearLeafNodeCount("AutoChessLinear", false, AllUnlockedLevels)
    return
  end
  if MissionId and CacheDetail[MissionId] then
    CacheDetail[MissionId] = false
    ReddotManager.DecreaseLeafNodeCount("AutoChessLinear", 1, {MissionId})
  end
end

function AutoChessDataModel:CheckMonsterIsNew(CombatChessId)
  local Node = ReddotManager.GetTreeNode("AutoChessMonster")
  if Node and Node.Cache.Detail and Node.Cache.Detail[CombatChessId] then
    return false
  end
  return true
end

function AutoChessDataModel:CheckEquipIsNew(EquipId)
  local Node = ReddotManager.GetTreeNode("AutoChessEquip")
  if Node and Node.Cache.Detail and Node.Cache.Detail[EquipId] then
    return false
  end
  return true
end

function AutoChessDataModel:DecreaseMonsterReddotById(CombatChessId)
  if CombatChessId then
    ReddotManager.DecreaseLeafNodeCount("AutoChessMonster", 1, {CombatChessId})
  else
    local Avatar = GWorld:GetAvatar()
    local AllUnlockedMonsters = {}
    for MonsterId, _ in pairs(Avatar.AutoChess.UnlockedCards) do
      table.insert(AllUnlockedMonsters, MonsterId)
    end
    ReddotManager.ClearLeafNodeCount("AutoChessMonster", false, AllUnlockedMonsters)
  end
end

function AutoChessDataModel:DecreaseEquipReddotById(EquipId)
  if EquipId then
    ReddotManager.DecreaseLeafNodeCount("AutoChessEquip", 1, {EquipId})
  else
    local Avatar = GWorld:GetAvatar()
    local AllUnlockedEquips = {}
    for _, EquipId in ipairs(Avatar.AutoChess.UnlockedEquips) do
      table.insert(AllUnlockedEquips, EquipId)
    end
    ReddotManager.ClearLeafNodeCount("AutoChessEquip", false, AllUnlockedEquips)
  end
end

function AutoChessDataModel:GetChessData()
  local ChessIds = DataMgr.AutoChessConstant[ActiveId].EventChessId
  local Result = {}
  for _, Id in pairs(ChessIds) do
    table.insert(Result, self:GetMonsterInfoByCombatId(Id))
  end
  
  local function Cmp(Item_1, Item_2)
    if Item_1.Locked ~= Item_2.Locked then
      return Item_1.Locked == false
    end
    if Item_1.TotalCost ~= Item_2.TotalCost then
      return Item_1.TotalCost > Item_2.TotalCost
    end
    return Item_1.Id < Item_2.Id
  end
  
  table.sort(Result, Cmp)
  return Result
end

function AutoChessDataModel:GetEquipsData()
  local RobotEquip = DataMgr.AutoChessConstant[AutoChessConst.ActiveId].EventEquipId
  local Result = {}
  for _, Id in ipairs(RobotEquip) do
    table.insert(Result, self:GetEquipInfoByEquipId(Id))
  end
  return Result
end

function AutoChessDataModel:GetRankInfo()
  local Avatar = GWorld:GetAvatar()
  return Avatar.AutoChess.RankLevel, Avatar.AutoChess.RankScore
end

function AutoChessDataModel:GetMonsterEquipInfo(AutoChessId)
  local Avatar = GWorld:GetAvatar()
  local MonsterInfos = Avatar.AutoChess.UnlockedCards
  if MonsterInfos then
    local MonsterInfo = MonsterInfos[AutoChessId]
    if MonsterInfo then
      local Result = {}
      for _, EquipId in ipairs(MonsterInfo.Equips) do
        table.insert(Result, EquipId)
      end
      return Result
    end
  end
  return {}
end

local function SortByUnlocked(Item_1, Item_2)
  if Item_1.Locked ~= Item_2.Locked then
    return true, not Item_1.Locked
  end
  return false
end

local function SortByRarity(Item_1, Item_2, IsIncrease)
  if Item_1.Rarity ~= Item_2.Rarity then
    if IsIncrease then
      return true, Item_1.Rarity < Item_2.Rarity
    else
      return true, Item_1.Rarity > Item_2.Rarity
    end
  end
  return false
end

local function SortByCost(Item_1, Item_2, IsIncrease)
  if Item_1.Cost ~= Item_2.Cost then
    if IsIncrease then
      return true, Item_1.Cost < Item_2.Cost
    else
      return true, Item_1.Cost > Item_2.Cost
    end
  end
  return false
end

local function SortById(Item_1, Item_2)
  return true, Item_1.Id < Item_2.Id
end

local SortMethods_ByRarity = {
  SortByUnlocked,
  SortByRarity,
  SortByCost,
  SortById
}
local SortMethods_ByCost = {
  SortByUnlocked,
  SortByCost,
  SortByRarity,
  SortById
}

function AutoChessDataModel:SortEquipInfos(EquipDatas, SortType, IsIncrease)
  local SortTypeMap = {"Cost", "Rarity"}
  local IsIncreaseMap = {true, false}
  SortType = SortTypeMap[SortType or 1]
  IsIncrease = IsIncreaseMap[IsIncrease or 1]
  local SortMethod
  if "Rarity" == SortType then
    SortMethod = SortMethods_ByRarity
  else
    SortMethod = SortMethods_ByCost
  end
  return self:_SortDatas(EquipDatas, SortMethod, IsIncrease)
end

function AutoChessDataModel:_SortDatas(EquipDatas, SortMethod, IsIncrease)
  local function Cmp(Item_1, Item_2)
    for _, SortMethod in ipairs(SortMethod) do
      local IsBreak, Result = SortMethod(Item_1, Item_2, IsIncrease)
      
      if IsBreak then
        return Result
      end
    end
  end
  
  table.sort(EquipDatas, Cmp)
  return EquipDatas
end

function AutoChessDataModel:GetBuffType(BuffId)
  local BuffData = DataMgr.ChallengeBuff[BuffId]
  if not BuffData then
    return 0
  end
  if BuffData.BuffType then
    return BuffData.BuffType
  end
  if BuffData.DailyChallengeId and 0 ~= BuffData.DailyChallengeId then
    return AutoChessConst.BuffType.Weather
  end
  return AutoChessConst.BuffType.Challenge
end

function AutoChessDataModel:IsWeatherBuff(BuffId)
  return self:GetBuffType(BuffId) == AutoChessConst.BuffType.Weather
end

function AutoChessDataModel:IsChallengeBuff(BuffId)
  return self:GetBuffType(BuffId) == AutoChessConst.BuffType.Challenge
end

function AutoChessDataModel:IsFieldBuff(BuffId)
  return self:GetBuffType(BuffId) == AutoChessConst.BuffType.Field
end

function AutoChessDataModel:GetBuffsByMissionId(MissionId)
  local Result = {}
  local MissionData = DataMgr.AutoChessMission[MissionId]
  if not MissionData then
    DebugPrint("Tianyi@ 错误的关卡Id")
    return
  end
  local MissionType = MissionData.MissionType
  if MissionType == AutoChessConst.LevelSelectType.Linear then
    if MissionData.SpecifyBuffId then
      for _, BuffId in ipairs(MissionData.SpecifyBuffId) do
        table.insert(Result, BuffId)
      end
    end
  elseif MissionType == AutoChessConst.LevelSelectType.Random then
    local Avatar = GWorld:GetAvatar()
    if Avatar.AutoChess.RandomBuffList then
      for _, BuffId in ipairs(Avatar.AutoChess.RandomBuffList) do
        table.insert(Result, BuffId)
      end
    end
  end
  if MissionData.RegularBuffId then
    table.insert(Result, MissionData.RegularBuffId)
  end
  return Result
end

function AutoChessDataModel:IsLinearMission(MissionId)
  local MissionData = MissionId and DataMgr.AutoChessMission[MissionId]
  return nil ~= MissionData and MissionData.MissionType == AutoChessConst.LevelSelectType.Linear
end

function AutoChessDataModel:IsShareEditMode(MissionId)
  local MissionData = MissionId and DataMgr.AutoChessMission[MissionId]
  return nil ~= MissionData and MissionData.MissionType == AutoChessConst.LevelSelectType.Editor
end

function AutoChessDataModel:GetEditingSquadBuffs()
  local Avatar = GWorld:GetAvatar()
  if not (Avatar and Avatar.AutoChess) or not Avatar.AutoChess.SharedSquads then
    return {}
  end
  local SquadIdx = self:GetEditingSuqadIndex() or 1
  local Squad = Avatar.AutoChess.SharedSquads[SquadIdx]
  if not Squad or not Squad.Buffs then
    return {}
  end
  return Squad.Buffs
end

function AutoChessDataModel:GetDisplayWeatherBuff(MissionId, ActiveBuffIds)
  if self:IsLinearMission(MissionId) then
    return nil
  end
  if ActiveBuffIds then
    for _, BuffId in ipairs(ActiveBuffIds) do
      if self:IsWeatherBuff(BuffId) then
        return BuffId
      end
    end
    return nil
  end
  if self:IsShareEditMode(MissionId) then
    for _, BuffId in ipairs(self:GetEditingSquadBuffs()) do
      if self:IsWeatherBuff(BuffId) then
        return BuffId
      end
    end
    return nil
  end
  local Avatar = GWorld:GetAvatar()
  if not (Avatar and Avatar.AutoChess) or not Avatar.AutoChess.DailyChallengeBuffs then
    return nil
  end
  for BuffId, _ in pairs(Avatar.AutoChess.DailyChallengeBuffs) do
    return BuffId
  end
  return nil
end

function AutoChessDataModel:GetDisplayBuffs(MissionId, ActiveBuffIds)
  local Result = {}
  local BuffIds = self:GetBuffsByMissionId(MissionId) or {}
  for _, BuffId in ipairs(BuffIds) do
    local Row = DataMgr.AutoChessBuff[BuffId]
    if Row then
      table.insert(Result, {
        BuffId = BuffId,
        BuffIcon = Row.BuffIcon,
        BuffName = GText(Row.BuffName),
        BuffDesc = GText(Row.BuffDes)
      })
    end
  end
  if ActiveBuffIds then
    for _, BuffId in ipairs(ActiveBuffIds) do
      if not self:IsWeatherBuff(BuffId) then
        local BuffData = DataMgr.ChallengeBuff[BuffId]
        if BuffData then
          table.insert(Result, {
            BuffId = BuffId,
            BuffIcon = BuffData.BuffIcon,
            BuffName = GText(BuffData.BuffName),
            BuffDesc = GText(BuffData.BuffDesc)
          })
        end
      end
    end
    return Result
  end
  if self:IsLinearMission(MissionId) then
    return Result
  end
  local SelectedBuffIds = {}
  if self:IsShareEditMode(MissionId) then
    for _, BuffId in ipairs(self:GetEditingSquadBuffs()) do
      if not self:IsWeatherBuff(BuffId) then
        table.insert(SelectedBuffIds, BuffId)
      end
    end
  else
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.AutoChess and Avatar.AutoChess.ChallengeBuffs then
      for ChallengeBuffId, _ in pairs(Avatar.AutoChess.ChallengeBuffs) do
        if not self:IsWeatherBuff(ChallengeBuffId) then
          table.insert(SelectedBuffIds, ChallengeBuffId)
        end
      end
    end
  end
  for _, ChallengeBuffId in ipairs(SelectedBuffIds) do
    local BuffData = DataMgr.ChallengeBuff[ChallengeBuffId]
    if BuffData then
      table.insert(Result, {
        BuffId = ChallengeBuffId,
        BuffIcon = BuffData.BuffIcon,
        BuffName = GText(BuffData.BuffName),
        BuffDesc = GText(BuffData.BuffDesc)
      })
    end
  end
  return Result
end

function AutoChessDataModel:GetMonsterInfoByMissionId(MissionId)
  local Result = {}
  local MissionData = DataMgr.AutoChessMission[MissionId]
  if not MissionData then
    DebugPrint("错误MissionId:", tostring(MissionId))
    return
  end
  local ACFormationId = MissionData.ACFormationId
  if not ACFormationId then
    DebugPrint("缺少ACFormationId:", tostring(MissionId))
    return
  end
  local FormationData = DataMgr.AutoChessFormat[ACFormationId]
  if not FormationData then
    DebugPrint("错误的布局Id:", tostring(ACFormationId))
    return
  end
  for SlotIndex = 1, 24 do
    local Loc = FormationData["ACLocation" .. SlotIndex]
    if Loc then
      for MonsterId, EquipList in pairs(Loc) do
        if type(MonsterId) == "number" then
          local MonsterInfo = DataMgr.CombatChessInfo[MonsterId]
          table.insert(Result, {
            MonsterId = MonsterId,
            MonsterInfo = MonsterInfo,
            EquipList = EquipList
          })
        end
      end
    end
  end
  return Result
end

function AutoChessDataModel:GetMonsterEquipByEquipList(EquipList)
  local Result = {}
  if nil == EquipList then
    return Result
  end
  local EquipIds
  if type(EquipList) == "table" then
    EquipIds = EquipList
  else
    EquipIds = {EquipList}
  end
  for _, EquipId in ipairs(EquipIds) do
    local Id = tonumber(EquipId)
    if Id then
      local EquipData = DataMgr.RobotEquip[Id]
      if EquipData then
        table.insert(Result, {
          EquipId = Id,
          EquipRarity = EquipData.EquipRarity,
          EquipIcon = EquipData.EquipIcon,
          EquipName = EquipData.EquipName,
          ExtraBuffDesc = self:CalcEquipExtraDesc(Id),
          DeployCost = EquipData.DeployCost
        })
      else
        DebugPrint("RobotEquip 表找不到 EquipId:", tostring(Id))
      end
    else
      DebugPrint("EquipId 非法:", tostring(EquipId))
    end
  end
  return Result
end

function AutoChessDataModel:GetMonsterInfoByCombatId(AutoChessId)
  local Avatar = GWorld:GetAvatar()
  local CombatChessData = DataMgr.CombatChessInfo[AutoChessId]
  if not CombatChessData then
    DebugPrint("Tianyi@ GetMonsterInfoByCombatId failed, invalid AutoChessId: " .. tostring(AutoChessId))
    return
  end
  local Result = {}
  Result.Id = AutoChessId
  Result.Locked = Avatar.AutoChess.UnlockedCards[AutoChessId] == nil
  Result.IsNew = self:CheckMonsterIsNew(AutoChessId) and not Result.Locked
  Result.EquipItems = self:GetMonsterEquipInfo(AutoChessId)
  local ChessAttrData = DataMgr.BattleMonster[CombatChessData.EnemyMonsterUnitId]
  local BaseMaxHp = 0
  local BaseMaxEs = 0
  local BaseAtk = 0
  local BaseDef = 0
  if ChessAttrData then
    BaseMaxHp = ChessAttrData.MaxHp or 0
    BaseMaxEs = ChessAttrData.MaxES or 0
    BaseAtk = ChessAttrData.ATK or 0
    BaseDef = ChessAttrData.DEF or 0
  end
  local AtkBonus = 0
  local DefBonus = 0
  local HpBonus = 0
  local EsBonus = 0
  for _, EquipId in ipairs(Result.EquipItems or {}) do
    local EquipInfo = self:GetEquipInfoByEquipId(EquipId)
    if EquipInfo then
      AtkBonus = AtkBonus + self:ParsePercentToFloat(EquipInfo.Atk)
      DefBonus = DefBonus + self:ParsePercentToFloat(EquipInfo.Def)
      HpBonus = HpBonus + self:ParsePercentToFloat(EquipInfo.Hp)
      EsBonus = EsBonus + self:ParsePercentToFloat(EquipInfo.Es)
    end
  end
  Result.MaxHp = BaseMaxHp * (1 + HpBonus)
  Result.MaxEs = BaseMaxEs * (1 + EsBonus)
  Result.Atk = BaseAtk * (1 + AtkBonus)
  Result.Def = BaseDef * (1 + DefBonus)
  Result.TotalCost = CombatChessData.DeployCost or 0
  for _, EquipId in ipairs(Result.EquipItems or {}) do
    local EquipData = DataMgr.RobotEquip[EquipId]
    if EquipData then
      Result.TotalCost = Result.TotalCost + EquipData.DeployCost
    end
  end
  return Result
end

function AutoChessDataModel:ParsePercentToFloat(PercentStr)
  if not PercentStr then
    return 0
  end
  local NumStr = string.gsub(tostring(PercentStr), "%%", "")
  local Num = tonumber(NumStr)
  if Num then
    return Num / 100
  end
  return 0
end

function AutoChessDataModel:CalcMonsterPreviewAttr(AutoChessId, PreviewEquipId, bRemoving)
  local CombatChessData = DataMgr.CombatChessInfo[AutoChessId]
  if not CombatChessData then
    DebugPrint("Tianyi@ CalcMonsterPreviewAttr failed, invalid AutoChessId: " .. tostring(AutoChessId))
    return nil
  end
  local CurrentEquips = self:GetMonsterEquipInfo(AutoChessId)
  local PreviewEquips = {}
  for _, EquipId in ipairs(CurrentEquips) do
    table.insert(PreviewEquips, EquipId)
  end
  if bRemoving then
    for i = #PreviewEquips, 1, -1 do
      if PreviewEquips[i] == PreviewEquipId then
        table.remove(PreviewEquips, i)
        break
      end
    end
  else
    table.insert(PreviewEquips, PreviewEquipId)
  end
  local ChessAttrData = DataMgr.BattleMonster[CombatChessData.EnemyMonsterUnitId]
  local BaseMaxHp = 0
  local BaseMaxEs = 0
  local BaseAtk = 0
  local BaseDef = 0
  if ChessAttrData then
    BaseMaxHp = ChessAttrData.MaxHp or 0
    BaseMaxEs = ChessAttrData.MaxES or 0
    BaseAtk = ChessAttrData.ATK or 0
    BaseDef = ChessAttrData.DEF or 0
  end
  local AtkBonus = 0
  local DefBonus = 0
  local HpBonus = 0
  local EsBonus = 0
  for _, EquipId in ipairs(PreviewEquips) do
    local EquipInfo = self:GetEquipInfoByEquipId(EquipId)
    if EquipInfo then
      AtkBonus = AtkBonus + self:ParsePercentToFloat(EquipInfo.Atk)
      DefBonus = DefBonus + self:ParsePercentToFloat(EquipInfo.Def)
      HpBonus = HpBonus + self:ParsePercentToFloat(EquipInfo.Hp)
      EsBonus = EsBonus + self:ParsePercentToFloat(EquipInfo.Es)
    end
  end
  local Result = {}
  Result.MaxHp = BaseMaxHp * (1 + HpBonus)
  Result.MaxEs = BaseMaxEs * (1 + EsBonus)
  Result.Atk = BaseAtk * (1 + AtkBonus)
  Result.Def = BaseDef * (1 + DefBonus)
  Result.TotalCost = CombatChessData.DeployCost or 0
  for _, EquipId in ipairs(PreviewEquips) do
    local EquipData = DataMgr.RobotEquip[EquipId]
    if EquipData then
      Result.TotalCost = Result.TotalCost + EquipData.DeployCost
    end
  end
  return Result
end

function AutoChessDataModel:GetEquipInfoByEquipId(EquipId)
  local AutoChessEquipData = DataMgr.RobotEquip[EquipId]
  if not AutoChessEquipData then
    DebugPrint("Tianyi@ GetEquipInfoByEquipId failed, invalid EquipId: " .. tostring(EquipId))
    return
  end
  local Result = {}
  Result.Id = EquipId
  Result.Locked = not self:CheckAutoChessEquipUnlocked(EquipId)
  Result.IsNew = self:CheckEquipIsNew(EquipId) and not Result.Locked
  Result.Rarity = AutoChessEquipData.EquipRarity or 1
  Result.Cost = AutoChessEquipData.DeployCost or 0
  Result.ExtraDesc = self:CalcEquipExtraDesc(EquipId)
  Result.Atk = SkillUtils.CalcSkillDescValue(AutoChessEquipData.ATKValue or "", 1)
  Result.Def = SkillUtils.CalcSkillDescValue(AutoChessEquipData.DEFValue or "", 1)
  Result.Hp = SkillUtils.CalcSkillDescValue(AutoChessEquipData.HPValue or "", 1)
  Result.Es = SkillUtils.CalcSkillDescValue(AutoChessEquipData.ShieldValue or "", 1)
  return Result
end

function AutoChessDataModel:CalcEquipExtraDesc(EquipId)
  local EquipData = DataMgr.RobotEquip[EquipId]
  if not EquipData or not EquipData.ExtraBuffDesc then
    return nil
  end
  local RawDesc = GText(EquipData.ExtraBuffDesc)
  return self:CalcDescCommom(EquipData, RawDesc)
end

function AutoChessDataModel:CalcDescCommom(Conf, Desc)
  local RawDesc = Desc
  local ExtraDescValues = {}
  for Index, Value in ipairs(Conf.DescValue or {}) do
    local DescValue = SkillUtils.CalcSkillDescValue(Value, 1)
    DescValue = string.gsub(DescValue, "%%", "%%%%")
    RawDesc = string.gsub(RawDesc, "#" .. Index, DescValue)
  end
  return RawDesc
end

function AutoChessDataModel:CheckAutoChessEquipUnlocked(EquipId)
  local Avatar = GWorld:GetAvatar()
  for _, Id in ipairs(Avatar.AutoChess.UnlockedEquips) do
    if Id == EquipId then
      return true
    end
  end
  return false
end

function AutoChessDataModel:GetEventInfo()
  local CurrentTime = TimeUtils.NowTime()
  local EventStartTime = DataMgr.EventMain[AutoChessConst.ActiveId].EventStartTime
  local Result = {}
  Result.TotalPassedTime = CurrentTime - EventStartTime
  local LinearMissions = {}
  for MissionId, MissionData in pairs(DataMgr.AutoChessMission) do
    if MissionData.MissionType == AutoChessConst.LevelSelectType.Linear and MissionData.UnlockDay then
      table.insert(LinearMissions, MissionId)
    end
  end
  table.sort(LinearMissions, function(Id_1, Id_2)
    return DataMgr.AutoChessMission[Id_1].UnlockDay < DataMgr.AutoChessMission[Id_2].UnlockDay
  end)
  for Index, MissionId in ipairs(LinearMissions) do
    local MissionData = DataMgr.AutoChessMission[MissionId]
    local UnlockDay = MissionData.UnlockDay
    local StartTimestamp = EventStartTime:GetTime()
    local StartDate = os.date("*t", StartTimestamp)
    local RefreshHour = TimeUtils.RefreshHMS[1] or 5
    local RefreshMin = TimeUtils.RefreshHMS[2] or 0
    local RefreshSec = TimeUtils.RefreshHMS[3] or 0
    local FirstRefreshTime = os.time({
      year = StartDate.year,
      month = StartDate.month,
      day = StartDate.day,
      hour = RefreshHour,
      min = RefreshMin,
      sec = RefreshSec
    })
    if StartTimestamp >= FirstRefreshTime then
      FirstRefreshTime = FirstRefreshTime + 86400
    end
    local UnlockTime = FirstRefreshTime + (UnlockDay - 2) * 86400
    if CurrentTime < UnlockTime then
      Result.NextUnlockMissionId = MissionId
      Result.NextUnlockTime = UnlockTime
      Result.RemainSeconds = UnlockTime - CurrentTime
      break
    end
  end
  return Result
end

return AutoChessDataModel
