require("UnLua")
local M = {}

function M:GetGroupLevel(GroupId, Count)
  local Level = 1
  if 0 == Count then
    return Level
  end
  local GroupData = DataMgr.BlessingGroup[GroupId]
  for _, v in pairs(GroupData.ActivateNeed) do
    if Count < v + GWorld.RougeLikeManager.BlessingGroupDiscount then
      break
    end
    Level = Level + 1
  end
  return Level
end

function M:GetGroupIsActive(GroupId, Count)
  local GroupData = DataMgr.BlessingGroup[GroupId]
  assert(GroupData, "套装信息未找到：" .. GroupId)
  local IsActive = false
  for _, v in pairs(GroupData.ActivateNeed) do
    if Count == v + GWorld.RougeLikeManager.BlessingGroupDiscount then
      IsActive = true
      break
    end
  end
  return IsActive
end

function M:GetIsCanLevelUp(BlessingId)
  local RougeLikeManager = GWorld.RougeLikeManager
  local BlessingsList = RougeLikeManager.Blessings
  for Id, _ in pairs(BlessingsList) do
    if Id == BlessingId then
      return true
    end
  end
  return false
end

function M:ShowRougeLikeError(Text)
  local bDistribution = UE4.URuntimeCommonFunctionLibrary.IsDistribution()
  local bEnableShippingLog = UE4.URuntimeCommonFunctionLibrary.EnableLogInShipping()
  if bDistribution and not bEnableShippingLog then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:SendToFeishuForRougeLike(Text, "肉鸽报错")
    return
  end
end

function M:GenSuitDetail(SuitId, CurrentLV, IsPreAdd, IsUnlockFeedback, IsGuide)
  if not self.ActiveNeedMap then
    self.ActiveNeedMap = {}
    for _, v in pairs(DataMgr.BlessingGroup) do
      for _, ActiveNeed in ipairs(v.ActivateNeed) do
        if self.ActiveNeedMap[v.GroupId] == nil then
          self.ActiveNeedMap[v.GroupId] = {}
        end
        table.insert(self.ActiveNeedMap[v.GroupId], ActiveNeed)
      end
    end
  end
  local _TextUnlockNum, _TextCurrentNum
  if IsGuide then
    _TextUnlockNum = self.ActiveNeedMap[SuitId][CurrentLV]
    _TextCurrentNum = _TextUnlockNum
  else
    _TextUnlockNum = self.ActiveNeedMap[SuitId][CurrentLV] + GWorld.RougeLikeManager.BlessingGroupDiscount
    _TextCurrentNum = GWorld.RougeLikeManager.BlessingGroup:Find(SuitId) or 0
  end
  local _IsActive
  local _TextSuitDesc = DataMgr.BlessingGroup[SuitId].ActivateDesc[CurrentLV]
  local _ExplanationId
  if DataMgr.BlessingGroup[SuitId].ExplanationId then
    _ExplanationId = DataMgr.BlessingGroup[SuitId].ExplanationId[CurrentLV]
  end
  if IsPreAdd then
    _TextCurrentNum = _TextCurrentNum + 1
  else
  end
  if _TextUnlockNum <= _TextCurrentNum then
    if IsPreAdd and _TextCurrentNum == _TextUnlockNum then
      _IsActive = 2
    else
      _IsActive = 1
    end
  else
    _IsActive = 0
  end
  return {
    TextGroupLevel = CurrentLV,
    TextCurrentNum = _TextCurrentNum,
    TextUnlockNum = _TextUnlockNum,
    IsActive = _IsActive,
    TextSuitDesc = _TextSuitDesc,
    IsUnlockFeedback = IsUnlockFeedback,
    ExplanationId = _ExplanationId
  }
end

return M
