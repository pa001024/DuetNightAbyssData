require("UnLua")
local NpcHeadUISubsystem = Class("BluePrints.Common.TimerMgr")

function NpcHeadUISubsystem:OnInitialize()
  EventManager:AddEvent(EventID.OnChangeTaskIndicator, self, self.OnChangeTaskIndicator)
  EventManager:AddEvent(EventID.EnterImmersiveTalk, self, self.OnEnterImmersiveTalk)
  EventManager:AddEvent(EventID.LeaveImmersiveTalk, self, self.OnLeaveImmersiveTalk)
  self.HideTags = {}
  self.HideTagsCache = {}
  self.HeadWidgetComps = {}
  self.EmojiDuration = 5
  self.EmojiTimer = {}
  if ChatController then
    ChatController:RegisterEvent(self, function(self, EventId, ...)
      if EventId == ChatCommon.EventID.RecvStickerInPubChannels then
        local Uid, EmojiPath = ...
        self:OnShowPlayerEmoji(Uid, EmojiPath)
      end
    end)
  end
end

function NpcHeadUISubsystem:HideAllNpcHeadUI(bHidden, Tag)
  if bHidden then
    self.HideTags[Tag] = 1
  else
    self.HideTags[Tag] = nil
  end
  self.bIsHeadUIHidden = not IsEmptyTable(self.HideTags)
  for NpcId, HeadWidgetComponent in pairs(self.HeadWidgetComps) do
    if IsValid(HeadWidgetComponent) then
      HeadWidgetComponent:SetUniformWidgetHideTag(bHidden, Tag)
    end
  end
end

function NpcHeadUISubsystem:HideNpcHeadUI(NpcId, bHidden, Tag)
  local HeadWidgetComponent = self.HeadWidgetComps[NpcId]
  if IsValid(HeadWidgetComponent) then
    HeadWidgetComponent:SetUniformWidgetHideTag(bHidden, Tag)
  else
    local HideTag = self.HideTagsCache[NpcId] or {}
    self.HideTagsCache[NpcId] = HideTag
    if bHidden then
      HideTag[Tag] = 1
    else
      HideTag[Tag] = nil
    end
  end
end

function NpcHeadUISubsystem:RegisterHeadWidgetComp(NpcId, HeadWidgetComponent)
  if not IsValid(HeadWidgetComponent) then
    return
  end
  if not NpcId then
    return
  end
  self.HeadWidgetComps[NpcId] = HeadWidgetComponent
  local HideTags = self.HideTagsCache[NpcId]
  if HideTags then
    HeadWidgetComponent:SetUniformWidgetHideTags(HideTags)
    self.HideTagsCache[NpcId] = nil
  end
  for Tag, bHidden in pairs(self.HideTags) do
    HeadWidgetComponent:SetUniformWidgetHideTag(true, Tag)
  end
end

function NpcHeadUISubsystem:UnRegisterHeadWidgetComp(NpcId)
  if not NpcId then
    return
  end
  self.HeadWidgetComps[NpcId] = nil
end

function NpcHeadUISubsystem:OnChangeTaskIndicator(InMaps)
  local InMapNpc = {}
  if InMaps then
    for _, NpcId in pairs(InMaps) do
      self:HideNpcHeadUI(NpcId, true, "Mission")
      InMapNpc[NpcId] = true
    end
  end
  for NpcId, HeadWidgetComponent in pairs(self.HeadWidgetComps) do
    if not InMapNpc[NpcId] then
      self:HideNpcHeadUI(NpcId, false, "Mission")
    end
  end
  for NpcId, Tags in pairs(self.HideTagsCache) do
    if not InMapNpc[NpcId] then
      self:HideNpcHeadUI(NpcId, false, "Mission")
    end
  end
end

function NpcHeadUISubsystem:OnEnterImmersiveTalk()
  self:HideAllNpcHeadUI(true, "ImmersiveTalk")
end

function NpcHeadUISubsystem:OnLeaveImmersiveTalk()
  self:HideAllNpcHeadUI(false, "ImmersiveTalk")
end

function NpcHeadUISubsystem:OnNpcEndPlay_Lua(Npc)
  if not IsValid(Npc) then
    return
  end
  self:UnRegisterHeadWidgetComp(Npc.NpcId)
end

function NpcHeadUISubsystem:OnDeinitialize()
  EventManager:RemoveEvent(EventID.OnChangeTaskIndicator, self)
  EventManager:RemoveEvent(EventID.EnterImmersiveTalk, self)
  EventManager:RemoveEvent(EventID.LeaveImmersiveTalk, self)
  if ChatController then
    ChatController:UnRegisterEvent(self)
  end
end

function NpcHeadUISubsystem:OnShowPlayerEmoji(Uid, EmojiPath)
  local EMGameState = UE4.UGameplayStatics.GetGameState(self)
  local IsInDungeon = EMGameState and EMGameState:IsInDungeon()
  local Avatar = GWorld:GetAvatar()
  if not IsInDungeon and Avatar.Uid ~= Uid then
    return
  end
  local Eid, Player
  if Avatar.Uid ~= Uid then
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    for i, PlayerState in pairs(GameState.PlayerArray) do
      if PlayerState and PlayerState.Uid == Uid then
        Eid = PlayerState.Eid
        break
      end
    end
    Player = Battle(self):GetEntity(Eid)
  else
    Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    Eid = Player.Eid
  end
  if not Player then
    return
  end
  local Timer = self.EmojiTimer[Eid]
  if Timer then
    self:RemoveTimer(Timer)
  end
  Player:StopEmoji()
  Player:PlayEmoji(EmojiPath)
  Timer = self:AddTimer(self.EmojiDuration, function()
    self.EmojiTimer[Eid] = nil
    Player:StopEmoji()
  end)
  self.EmojiTimer[Eid] = Timer
end

return NpcHeadUISubsystem
