require("UnLua")
local NpcHeadUIVisibilityMgr = Class("BluePrints.Common.TimerMgr")
local NpcLogType = UE.EStoryLogType.NPC

function NpcHeadUIVisibilityMgr:OnInitialize()
  EventManager:AddEvent(EventID.OnChangeTaskIndicator, self, self.OnChangeTaskIndicator)
  EventManager:AddEvent(EventID.EnterImmersiveTalk, self, self.OnEnterImmersiveTalk)
  EventManager:AddEvent(EventID.LeaveImmersiveTalk, self, self.OnLeaveImmersiveTalk)
  EventManager:AddEvent(EventID.EnableNpcIndicator, self, self.EnableNpcIndicator)
  self.MissionHiddenNpcIds = {}
  self.IndicatorNpcIds = {}
end

function NpcHeadUIVisibilityMgr:EnableNpcIndicator(NpcId, InEnable, Brush)
  local Npc = ANpcCharacter.GetNpc(self, NpcId)
  self.IndicatorNpcIds[NpcId] = InEnable
  if IsValid(Npc) then
    if self.MissionHiddenNpcIds[NpcId] then
      self:HideNpc(NpcId, not InEnable, "Mission")
    end
    Npc:TryEnableIndicator(InEnable, Brush)
  end
end

function NpcHeadUIVisibilityMgr:OnDeinitialize()
  EventManager:RemoveEvent(EventID.OnChangeTaskIndicator, self)
  EventManager:RemoveEvent(EventID.EnterImmersiveTalk, self)
  EventManager:RemoveEvent(EventID.LeaveImmersiveTalk, self)
  EventManager:RemoveEvent(EventID.EnableNpcIndicator, self)
  self.MissionHiddenNpcIds = {}
  self.IndicatorNpcIds = {}
end

function NpcHeadUIVisibilityMgr:OnEnterImmersiveTalk()
  self:HideAll(true, "ImmersiveTalk")
end

function NpcHeadUIVisibilityMgr:OnLeaveImmersiveTalk()
  self:HideAll(false, "ImmersiveTalk")
end

function NpcHeadUIVisibilityMgr:OnChangeTaskIndicator(InMaps)
  local NewHiddenNpcIds = {}
  if InMaps then
    for _, NpcId in pairs(InMaps) do
      NewHiddenNpcIds[NpcId] = true
    end
  end
  local OldHiddenNpcIds = self.MissionHiddenNpcIds or {}
  for NpcId, _ in pairs(OldHiddenNpcIds) do
    if not NewHiddenNpcIds[NpcId] then
      self:HideNpc(NpcId, false, "Mission")
    end
  end
  for NpcId, _ in pairs(NewHiddenNpcIds) do
    if not OldHiddenNpcIds[NpcId] and not self.IndicatorNpcIds[NpcId] then
      self:HideNpc(NpcId, true, "Mission")
    end
  end
  self.MissionHiddenNpcIds = NewHiddenNpcIds
end

return NpcHeadUIVisibilityMgr
