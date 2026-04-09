require("UnLua")
local NpcHeadUISubsystem = Class("BluePrints.Common.TimerMgr")

function NpcHeadUISubsystem:OnInitialize()
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

function NpcHeadUISubsystem:OnNpcEndPlay_Lua(Npc)
end

function NpcHeadUISubsystem:OnDeinitialize()
  if ChatController then
    ChatController:UnRegisterEvent(self)
  end
end

function NpcHeadUISubsystem:GetHeadWidgetComponent(Character)
  if Character.IsMainPlayer and Character:IsMainPlayer() and not Character.HeadWidgetComponent then
    Character:InitHeadWidgetComponent()
  end
  return self.Overridden.GetHeadWidgetComponent(self, Character)
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
