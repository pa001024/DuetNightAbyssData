local ipairs = _ENV.ipairs
local pairs = _ENV.pairs
local insert = table.insert
local sort = table.sort
local tonumber = _ENV.tonumber
local BagCommon = require("BluePrints.UI.WBP.Bag.BagCommon")
local ItemUtils = require("Utils.ItemUtils")
local M = {}
M.PopupIds = {
  Unlock = 100019,
  Confirm = 100442,
  Cultivated = 100441
}
M.PreviewTestData = {
  Enabled = true,
  ResourceId = 3007,
  PetValueByRarity = {
    [3] = 100,
    [4] = 200,
    [5] = 300
  },
  DefaultPetValue = 100,
  EntryValueByLevel = {
    [1] = 10,
    [2] = 30,
    [3] = 60
  },
  DefaultEntryValue = 10
}

function M.GetUnavailableReason(Avatar, UniqueId)
  local Pet = Avatar and Avatar.Pets[UniqueId]
  if not Pet then
    return "UI_Pet_Decompose_NotExist"
  end
  if Avatar.CurrentPet == UniqueId then
    return "UI_Pet_Decompose_Equipped"
  end
  if Pet.IsLock then
    return "UI_Pet_Decompose_Locked"
  end
end

function M.GetSelectedIds(SelectedIds)
  local Result = {}
  for UniqueId in pairs(SelectedIds) do
    insert(Result, UniqueId)
  end
  sort(Result)
  return Result
end

function M.PruneSelection(Avatar, SelectedIds)
  local Removed = {}
  for UniqueId in pairs(SelectedIds) do
    if M.GetUnavailableReason(Avatar, UniqueId) then
      SelectedIds[UniqueId] = nil
      insert(Removed, UniqueId)
    end
  end
  return Removed
end

function M.IsCultivated(Pet, PetData, EntryData)
  if Pet.Level > 1 or Pet.Exp > 0 or Pet.BreakNum > 0 then
    return true
  end
  local FixedEntry = PetData.FixedPetEntry
  local HasFixedEntry = FixedEntry and 0 ~= FixedEntry
  local IsResourcePet = Pet:IsResourcePet()
  for _, EntryId in ipairs(Pet.Entry) do
    if 0 ~= EntryId then
      if HasFixedEntry then
        if EntryId ~= FixedEntry then
          return true
        end
      elseif not IsResourcePet then
        return true
      elseif EntryData[EntryId] and EntryData[EntryId].BattlePetLevel > 1 then
        return true
      end
    end
  end
  return false
end

local function MergeRewardCounts(RewardCounts, Rewards)
  if type(Rewards) ~= "table" then
    return
  end
  for ResourceId, Count in pairs(Rewards) do
    local NumericId = tonumber(ResourceId) or ResourceId
    local NumericCount = tonumber(Count)
    if DataMgr.Resource[NumericId] and NumericCount and NumericCount > 0 then
      RewardCounts[NumericId] = (RewardCounts[NumericId] or 0) + NumericCount
    end
  end
end

local function GetPetRewards(PetData)
  if type(PetData.ReturnReward) == "table" then
    return PetData.ReturnReward
  end
  if not M.PreviewTestData.Enabled then
    return
  end
  local Count = M.PreviewTestData.PetValueByRarity[PetData.Rarity] or M.PreviewTestData.DefaultPetValue
  return {
    [M.PreviewTestData.ResourceId] = Count
  }
end

local function GetEntryRewards(EntryData)
  if type(EntryData.ReturnRewardID) == "table" then
    return EntryData.ReturnRewardID
  end
  if not M.PreviewTestData.Enabled then
    return
  end
  local Count = M.PreviewTestData.EntryValueByLevel[EntryData.BattlePetLevel] or M.PreviewTestData.DefaultEntryValue
  return {
    [M.PreviewTestData.ResourceId] = Count
  }
end

local function BuildPreviewRewardList(RewardCounts)
  local Rewards = {}
  for ResourceId, Count in pairs(RewardCounts) do
    local ResourceData = DataMgr.Resource[ResourceId]
    if ResourceData and Count > 0 then
      insert(Rewards, {
        StuffId = ResourceId,
        StuffIcon = ItemUtils.GetItemIconPath(ResourceId, BagCommon.StuffType.Resource),
        StuffType = BagCommon.StuffType.Resource,
        Rarity = ResourceData.Rarity or 0,
        Count = Count
      })
    end
  end
  sort(Rewards, function(A, B)
    if A.Rarity ~= B.Rarity then
      return A.Rarity > B.Rarity
    end
    return A.StuffId < B.StuffId
  end)
  return Rewards
end

function M.GetPreviewRewards(Avatar, UniqueIds)
  if not (Avatar and type(UniqueIds) == "table" and DataMgr.Pet and DataMgr.PetEntry) or not DataMgr.Resource then
    return
  end
  local RewardCounts = {}
  for _, UniqueId in ipairs(UniqueIds) do
    local Pet = Avatar.Pets and Avatar.Pets[UniqueId]
    local PetData = Pet and DataMgr.Pet[Pet.PetId]
    if not Pet or not PetData then
      return
    end
    MergeRewardCounts(RewardCounts, GetPetRewards(PetData))
    for _, EntryId in ipairs(Pet.Entry or {}) do
      if 0 ~= EntryId then
        local EntryData = DataMgr.PetEntry[EntryId]
        if not EntryData then
          return
        end
        MergeRewardCounts(RewardCounts, GetEntryRewards(EntryData))
      end
    end
  end
  return BuildPreviewRewardList(RewardCounts)
end

function M.GetActualRewards(DecomposeResult)
  if type(DecomposeResult) ~= "table" or not DataMgr.Resource then
    return
  end
  local Resources = {}
  MergeRewardCounts(Resources, DecomposeResult)
  if not next(Resources) then
    return
  end
  return {
    [BagCommon.StuffType.Resource .. "s"] = Resources
  }
end

return M
