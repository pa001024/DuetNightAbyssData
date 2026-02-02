local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local Component = {}

function Component:MulticastChatMessage_Lua(Messages)
  local MyPlayer = GWorld:GetMainPlayer()
  for _, DsMessage in pairs(Messages) do
    if DsMessage.Eid == MyPlayer.Eid then
      ChatController:RecvChatToTeam(DsMessage.Content)
    else
      local OtherDs = self:GetPlayerState(DsMessage.Eid)
      local Message = {
        Uid = DsMessage.Eid,
        Content = DsMessage.Content,
        Time = DsMessage.TimeStamp,
        Sender = {
          Uid = OtherDs.Uid,
          Nickname = OtherDs.PlayerName,
          Level = OtherDs.PlayerLevel,
          HeadIconId = OtherDs.HeadIconId,
          HeadFrameId = OtherDs.HeadFrameId,
          IsOnline = true,
          IsInDungeon = true
        },
        Type = CommonConst.MESSAGE_TYPE_TEAM,
        ChannelType = ChatCommon.ChannelDef.InTeam
      }
      ChatController:HandleChatMessage(Message)
    end
  end
end

return Component
