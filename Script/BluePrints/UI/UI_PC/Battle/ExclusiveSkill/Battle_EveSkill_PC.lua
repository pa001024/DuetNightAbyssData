require("UnLua")
local M = Class({
  "BluePrints.UI.UI_PC.Battle.ExclusiveSkill.Base.Battle_Skill_UI_Base"
})
local MAX_SUMMONER_TYPE_COUNT = 3
local MAX_DESTROYED_SUMMONER_ID_CACHE_COUNT = 20
local SUMMONER_UI_REFRESH_FLUSH_KEY = "EveSkillSummonerUIRefresh"
local SUMMONER_UI_MERGE_DELAY_FRAME = 0
local SKILL_ITEM_STATE = {
  NONE = -1,
  GRAY = 0,
  NORMAL = 1,
  MAX = 2
}

function M:Initialize(Initializer)
  self.Super.Initialize(self)
  self.OwnerPlayer = nil
  self.SummonerId2MaxCountMap = {}
  self.RegisteredSummonerIdSet = {}
  self.SummonerId2RuntimeDataMap = {}
  self.SummonerId2SkillItemMap = {}
  self.HasDestroyedSummoners = {}
  self.HasDestroyedSummonersCache = {}
  self.HasDestroyedSummonersCnt = 0
  self.PendingRefreshSummonerIds = {}
  self.NormalAnimQueues = {}
  self.NormalAnimPlaying = {}
  self.SummonerTransitionEpoch = {}
  self._SummonerUIFlushScheduled = false
end

function M:OnSummonerAdd(Entity, MaxLifeTime)
  if not self:IsMainPlayerSummon(Entity, self.OwnerPlayer) then
    return
  end
  local SummonerId = Entity.UnitId
  local RuntimeData = self.SummonerId2RuntimeDataMap[SummonerId]
  if not RuntimeData then
    return
  end
  self:QueueSummonerUIRefresh(SummonerId)
end

function M:OnSummonerRemove(Entity)
  local EntityEid = Entity:GetEid()
  if self.HasDestroyedSummoners[EntityEid] or self.HasDestroyedSummonersCache[EntityEid] then
    return
  end
  if not self:IsMainPlayerSummon(Entity, self.OwnerPlayer) then
    return
  end
  if self.HasDestroyedSummonersCnt >= MAX_DESTROYED_SUMMONER_ID_CACHE_COUNT then
    self.HasDestroyedSummonersCache = self.HasDestroyedSummoners
    self.HasDestroyedSummoners = {}
    self.HasDestroyedSummonersCnt = 0
  end
  self.HasDestroyedSummoners[EntityEid] = true
  self.HasDestroyedSummonersCnt = self.HasDestroyedSummonersCnt + 1
  local SummonerId = Entity.UnitId
  local RuntimeData = self.SummonerId2RuntimeDataMap[SummonerId]
  if not RuntimeData then
    return
  end
  self:QueueSummonerUIRefresh(SummonerId)
end

function M:QueueSummonerUIRefresh(SummonerId)
  if not self.SummonerId2RuntimeDataMap[SummonerId] then
    return
  end
  local RuntimeData = self.SummonerId2RuntimeDataMap[SummonerId]
  local Pending = self.PendingRefreshSummonerIds[SummonerId]
  if not Pending then
    Pending = {
      BaselineCount = RuntimeData.DisplayedCount or 0
    }
    self.PendingRefreshSummonerIds[SummonerId] = Pending
  end
  self:ScheduleSummonerUIRefreshFlush()
end

function M:ScheduleSummonerUIRefreshFlush()
  if self._SummonerUIFlushScheduled then
    return
  end
  self._SummonerUIFlushScheduled = true
  self:AddDelayFrameFunc(function()
    self._SummonerUIFlushScheduled = false
    self:FlushPendingSummonerUIRefresh()
  end, SUMMONER_UI_MERGE_DELAY_FRAME, SUMMONER_UI_REFRESH_FLUSH_KEY)
end

function M:FlushPendingSummonerUIRefresh()
  local PendingIds = self.PendingRefreshSummonerIds
  self.PendingRefreshSummonerIds = {}
  for SummonerId, Pending in pairs(PendingIds) do
    self:ApplySummonerItemUI(SummonerId, Pending.BaselineCount)
  end
end

function M:GetActualSummonerCount(SummonerId)
  if not IsValid(self.OwnerPlayer) or not SummonerId then
    return 0
  end
  local Summons = self.OwnerPlayer:GetSummonsList(SummonerId, true, true)
  if not Summons then
    return 0
  end
  local Count = 0
  for _, Eid in pairs(Summons) do
    if IsValid(Battle(self):GetEntity(Eid)) then
      Count = Count + 1
    end
  end
  return Count
end

function M:SyncSummonerRuntimeCount(SummonerId)
  local RuntimeData = self.SummonerId2RuntimeDataMap[SummonerId]
  if not RuntimeData then
    return
  end
  RuntimeData.RuntimeCount = self:GetActualSummonerCount(SummonerId)
end

function M:GetDisplayCount(SummonerId, Count)
  local MaxSummonerCount = self.SummonerId2MaxCountMap[SummonerId]
  Count = Count or 0
  if not MaxSummonerCount then
    return Count
  end
  if MaxSummonerCount <= Count then
    return MaxSummonerCount
  end
  return Count
end

function M:GetTargetItemStateForCount(SummonerId, Count)
  local MaxSummonerCount = self.SummonerId2MaxCountMap[SummonerId]
  if not MaxSummonerCount then
    return SKILL_ITEM_STATE.NONE
  end
  Count = Count or 0
  if Count <= 0 then
    return SKILL_ITEM_STATE.GRAY
  end
  if MaxSummonerCount <= Count then
    return SKILL_ITEM_STATE.MAX
  end
  return SKILL_ITEM_STATE.NORMAL
end

function M:GetTargetItemState(SummonerId)
  local RuntimeData = self.SummonerId2RuntimeDataMap[SummonerId]
  if not RuntimeData then
    return SKILL_ITEM_STATE.NONE
  end
  return self:GetTargetItemStateForCount(SummonerId, RuntimeData.RuntimeCount)
end

function M:IsMainPlayerSummon(Entity, OwnerPlayer)
  local SummonerId = Entity.UnitId
  if not SummonerId or not self.RegisteredSummonerIdSet[SummonerId] then
    return false
  end
  return self.Super.IsMainPlayerSummon(self, Entity, OwnerPlayer, SummonerId)
end

function M:OnLoaded(PlayerCharacter, SpecialUIInfo)
  self.Super.OnLoaded(self, PlayerCharacter, SpecialUIInfo)
  self:InitNode(SpecialUIInfo, PlayerCharacter)
  self:InitListenEvent()
end

function M:InitListenEvent()
  self:AddDispatcher(EventID.OnCharCallSummoner, self, self.OnSummonerAdd)
  self:AddDispatcher(EventID.OnCharRemoveSummoner, self, self.OnSummonerRemove)
end

function M:InitNode(Params, OwnerPlayer)
  self.OwnerPlayer = OwnerPlayer
  if not IsValid(self.OwnerPlayer) or not Params then
    return
  end
  for i = 1, MAX_SUMMONER_TYPE_COUNT do
    local SummonerId = Params["Sum0" .. i .. "Id"]
    if SummonerId then
      self.SummonerId2MaxCountMap[SummonerId] = Params["MaxSum0" .. i]
      self.RegisteredSummonerIdSet[SummonerId] = true
      self.SummonerId2SkillItemMap[SummonerId] = self["Skill_" .. i]
      local ActualCount = self:GetActualSummonerCount(SummonerId)
      self.SummonerId2RuntimeDataMap[SummonerId] = {
        RuntimeCount = ActualCount,
        ItemState = SKILL_ITEM_STATE.NONE,
        DisplayedCount = 0
      }
    end
  end
  for id, item in pairs(self.SummonerId2SkillItemMap) do
    if id and item then
      item:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      self:ApplySummonerItemUI(id)
    end
  end
end

function M:NextSummonerTransitionEpoch(SummonerId)
  local Epoch = (self.SummonerTransitionEpoch[SummonerId] or 0) + 1
  self.SummonerTransitionEpoch[SummonerId] = Epoch
  return Epoch
end

function M:IsSummonerTransitionEpochValid(SummonerId, Epoch)
  return self.SummonerTransitionEpoch[SummonerId] == Epoch
end

function M:ClearSummonerTransitionBindings(SkillItem)
  if not SkillItem then
    return
  end
  local Anims = {
    SkillItem.Max_Normal,
    SkillItem.Subtract01,
    SkillItem.Subtract02,
    SkillItem.Max,
    SkillItem.Activate,
    SkillItem.Gray
  }
  for _, Anim in ipairs(Anims) do
    if Anim then
      SkillItem:UnbindAllFromAnimationFinished(Anim)
    end
  end
end

function M:SyncDisplayedCount(SummonerId, Count)
  local RuntimeData = self.SummonerId2RuntimeDataMap[SummonerId]
  local SkillItem = self.SummonerId2SkillItemMap[SummonerId]
  if not RuntimeData or not SkillItem then
    return
  end
  RuntimeData.DisplayedCount = self:GetDisplayCount(SummonerId, Count)
  if SkillItem.Num_Eve then
    SkillItem.Num_Eve:SetText(RuntimeData.DisplayedCount)
  end
end

function M:ClearNormalAnimQueue(SummonerId)
  local SkillItem = self.SummonerId2SkillItemMap[SummonerId]
  if SkillItem then
    if SkillItem.Add then
      SkillItem:UnbindAllFromAnimationFinished(SkillItem.Add)
    end
    if SkillItem.Subtract01 then
      SkillItem:UnbindAllFromAnimationFinished(SkillItem.Subtract01)
    end
  end
  self.NormalAnimQueues[SummonerId] = nil
  self.NormalAnimPlaying[SummonerId] = nil
end

function M:EnqueueNormalCountAnims(SummonerId, AddCount, SubtractCount, bReplaceQueue)
  if AddCount <= 0 and SubtractCount <= 0 then
    return
  end
  if bReplaceQueue then
    self:ClearNormalAnimQueue(SummonerId)
    self.NormalAnimQueues[SummonerId] = {adds = AddCount, subs = SubtractCount}
  else
    local Queue = self.NormalAnimQueues[SummonerId]
    if not Queue then
      Queue = {adds = 0, subs = 0}
      self.NormalAnimQueues[SummonerId] = Queue
    end
    Queue.adds = Queue.adds + AddCount
    Queue.subs = Queue.subs + SubtractCount
  end
  self:TryPlayNextNormalAnim(SummonerId)
end

function M:TryPlayNextNormalAnim(SummonerId)
  if self.NormalAnimPlaying[SummonerId] then
    return
  end
  local Queue = self.NormalAnimQueues[SummonerId]
  if not Queue or Queue.adds <= 0 and Queue.subs <= 0 then
    self.NormalAnimPlaying[SummonerId] = nil
    return
  end
  local SkillItem = self.SummonerId2SkillItemMap[SummonerId]
  if not SkillItem then
    self:ClearNormalAnimQueue(SummonerId)
    return
  end
  local RuntimeData = self.SummonerId2RuntimeDataMap[SummonerId]
  local TargetDisplay = self:GetDisplayCount(SummonerId, RuntimeData.RuntimeCount)
  local Anim
  if Queue.adds > 0 then
    local NextDisplay = (RuntimeData.DisplayedCount or 0) + 1
    if TargetDisplay < NextDisplay then
      Queue.adds = Queue.adds - 1
      self:TryPlayNextNormalAnim(SummonerId)
      return
    end
    Queue.adds = Queue.adds - 1
    Anim = SkillItem.Add
    RuntimeData.DisplayedCount = NextDisplay
  else
    Queue.subs = Queue.subs - 1
    Anim = SkillItem.Subtract01
    RuntimeData.DisplayedCount = (RuntimeData.DisplayedCount or 0) - 1
  end
  RuntimeData.DisplayedCount = self:GetDisplayCount(SummonerId, RuntimeData.DisplayedCount)
  if SkillItem.Num_Eve then
    SkillItem.Num_Eve:SetText(RuntimeData.DisplayedCount)
  end
  self.NormalAnimPlaying[SummonerId] = true
  SkillItem:UnbindAllFromAnimationFinished(Anim)
  SkillItem:PlayAnimation(Anim)
  SkillItem:BindToAnimationFinished(Anim, {
    self,
    function()
      if not IsValid(SkillItem) then
        self:ClearNormalAnimQueue(SummonerId)
        return
      end
      self.NormalAnimPlaying[SummonerId] = nil
      self:TryPlayNextNormalAnim(SummonerId)
    end
  })
end

function M:PlaySummonerItemTransition(SummonerId, SkillItem, OldState, TargetState, RuntimeCount, TransitionEpoch)
  TransitionEpoch = TransitionEpoch or self.SummonerTransitionEpoch[SummonerId] or 0
  if TargetState == SKILL_ITEM_STATE.MAX then
    if OldState ~= SKILL_ITEM_STATE.MAX then
      self:SyncDisplayedCount(SummonerId, RuntimeCount)
      SkillItem:PlayAnimation(SkillItem.Max)
    end
  elseif TargetState == SKILL_ITEM_STATE.GRAY then
    if OldState == SKILL_ITEM_STATE.MAX then
      self:SyncDisplayedCount(SummonerId, RuntimeCount)
      SkillItem:UnbindAllFromAnimationFinished(SkillItem.Max_Normal)
      SkillItem:PlayAnimation(SkillItem.Max_Normal)
      SkillItem:BindToAnimationFinished(SkillItem.Max_Normal, {
        self,
        function()
          if not self:IsSummonerTransitionEpochValid(SummonerId, TransitionEpoch) then
            return
          end
          if IsValid(SkillItem) then
            SkillItem:PlayAnimation(SkillItem.Subtract02)
          end
        end
      })
    elseif OldState == SKILL_ITEM_STATE.NORMAL then
      self:SyncDisplayedCount(SummonerId, RuntimeCount)
      SkillItem:PlayAnimation(SkillItem.Subtract02)
    elseif OldState == SKILL_ITEM_STATE.NONE then
      self:SyncDisplayedCount(SummonerId, RuntimeCount)
      SkillItem:PlayAnimation(SkillItem.Gray)
    end
  elseif TargetState == SKILL_ITEM_STATE.NORMAL then
    if OldState == SKILL_ITEM_STATE.MAX then
      self:SyncDisplayedCount(SummonerId, RuntimeCount)
      SkillItem:UnbindAllFromAnimationFinished(SkillItem.Max_Normal)
      SkillItem:PlayAnimation(SkillItem.Max_Normal)
      SkillItem:BindToAnimationFinished(SkillItem.Max_Normal, {
        self,
        function()
          if not self:IsSummonerTransitionEpochValid(SummonerId, TransitionEpoch) then
            return
          end
          if IsValid(SkillItem) then
            SkillItem:UnbindAllFromAnimationFinished(SkillItem.Subtract01)
            SkillItem:PlayAnimation(SkillItem.Subtract01)
          end
        end
      })
    elseif OldState == SKILL_ITEM_STATE.GRAY then
      self:SyncDisplayedCount(SummonerId, RuntimeCount)
      SkillItem:PlayAnimation(SkillItem.Activate)
    end
  end
end

function M:ApplySummonerItemUI(SummonerId, BaselineCount)
  local RuntimeData = self.SummonerId2RuntimeDataMap[SummonerId]
  if not RuntimeData then
    return
  end
  self:SyncSummonerRuntimeCount(SummonerId)
  local SkillItem = self.SummonerId2SkillItemMap[SummonerId]
  if not SkillItem then
    return
  end
  local CurrentCount = RuntimeData.RuntimeCount or 0
  if nil == BaselineCount then
    BaselineCount = CurrentCount
  end
  local TargetState = self:GetTargetItemState(SummonerId)
  local OldState = RuntimeData.ItemState
  local BaselineState = self:GetTargetItemStateForCount(SummonerId, BaselineCount)
  if TargetState == OldState then
    if TargetState == SKILL_ITEM_STATE.NORMAL and BaselineState == SKILL_ITEM_STATE.NORMAL then
      local DisplayBaseline = self:GetDisplayCount(SummonerId, BaselineCount)
      local DisplayCurrent = self:GetDisplayCount(SummonerId, CurrentCount)
      local NetDelta = DisplayCurrent - DisplayBaseline
      RuntimeData.DisplayedCount = DisplayBaseline
      if SkillItem.Num_Eve then
        SkillItem.Num_Eve:SetText(RuntimeData.DisplayedCount)
      end
      if NetDelta > 0 then
        self:EnqueueNormalCountAnims(SummonerId, NetDelta, 0, true)
      elseif NetDelta < 0 then
        self:EnqueueNormalCountAnims(SummonerId, 0, -NetDelta, true)
      else
        self:SyncDisplayedCount(SummonerId, CurrentCount)
      end
    else
      self:SyncDisplayedCount(SummonerId, CurrentCount)
    end
    return
  end
  local TransitionEpoch = self:NextSummonerTransitionEpoch(SummonerId)
  self:ClearSummonerTransitionBindings(SkillItem)
  self:ClearNormalAnimQueue(SummonerId)
  SkillItem:StopAllAnimations()
  self:PlaySummonerItemTransition(SummonerId, SkillItem, OldState, TargetState, CurrentCount, TransitionEpoch)
  RuntimeData.ItemState = TargetState
end

return M
