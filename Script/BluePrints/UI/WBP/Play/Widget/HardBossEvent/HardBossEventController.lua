local HardBossEventModel = require("BluePrints.UI.WBP.Play.Widget.HardBossEvent.HardBossEventModel")
local BOSS_CONTENT_CLASS_PATH = "/Game/UI/UI_PC/Common/Common_Item_subsize_PC_Content.Common_Item_subsize_PC_Content_C"
local M = Class("BluePrints.Common.MVC.Controller")

function M:Init(EventId)
  if not self.bInited then
    M.Super.Init(self)
  end
  self.EventId = self:GetModel():GetCurrentEventId(EventId)
  self.CurrentBossConfig = nil
end

function M:Destory()
  if not self.bInited then
    return
  end
  self.EventId = nil
  self.CurrentBossConfig = nil
  M.Super.Destory(self)
end

function M:GetEventName()
  return EventID.HardBossEventControllerEvent
end

function M:GetModel()
  return HardBossEventModel
end

function M:GetRootPageData()
  local ActivityConfig = self.EventId and self:GetModel():GetActivityConfig(self.EventId) or nil
  return self.EventId, ActivityConfig
end

function M:GetSelectPageData(EventId)
  local CurrentEventId = self:GetModel():GetCurrentEventId(EventId or self.EventId)
  if not CurrentEventId then
    return nil, {}
  end
  self.EventId = CurrentEventId
  return CurrentEventId, self:GetModel():GetBossConfigList(CurrentEventId)
end

function M:SetCurrentBossConfig(BossConfig)
  self.CurrentBossConfig = BossConfig
end

function M:GetCurrentBossConfig()
  return self.CurrentBossConfig
end

function M:BuildBossContents(Owner, BossConfigList)
  local Result = {}
  local ContentClass = UE4.LoadClass(BOSS_CONTENT_CLASS_PATH)
  if not ContentClass then
    return Result
  end
  for Index, BossConfig in ipairs(BossConfigList or {}) do
    local Content = NewObject(ContentClass)
    Content.Id = BossConfig.HardBossDungeonId
    Content.BossConfig = BossConfig
    Content.Index = Index
    Content.Parent = Owner
    Content.Empty = false
    Content.IsSelect = false
    table.insert(Result, Content)
  end
  return Result
end

function M:BuildRewardContents(Owner, BossConfig)
  local Result = {}
  local RewardViewConfig = self:GetModel():GetRewardViewConfig(BossConfig)
  if not RewardViewConfig then
    return Result
  end
  local ContentClass = UIUtils.GetCommonItemContentClass()
  if not ContentClass then
    return Result
  end
  local Ids = RewardViewConfig.Id or {}
  local Types = RewardViewConfig.Type or {}
  local Quantities = RewardViewConfig.Quantity or {}
  for Index, ItemId in ipairs(Ids) do
    local ItemType = Types[Index]
    local Content = NewObject(ContentClass)
    Content.UIName = "HardBossEvent"
    Content.Parent = Owner
    Content.IsShowDetails = true
    Content.Id = ItemId
    Content.ItemType = ItemType
    Content.Icon = ItemUtils.GetItemIconPath(ItemId, ItemType)
    Content.Rarity = ItemUtils.GetItemRarity(ItemId, ItemType)
    local Quantity = Quantities[Index]
    if type(Quantity) == "table" then
      Content.Count = Quantity[1]
      Content.MaxCount = #Quantity > 1 and Quantity[2] or nil
    elseif Quantity then
      Content.Count = Quantity
    end
    table.insert(Result, Content)
  end
  table.sort(Result, function(A, B)
    if A.Rarity == B.Rarity then
      return A.Id > B.Id
    end
    return A.Rarity > B.Rarity
  end)
  return Result
end

function M:GetRewardTimes(EventId)
  return self:GetModel():GetRewardTimes(EventId)
end

return M
