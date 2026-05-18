local M = Class()
local CharModel = require("BluePrints.Common.MVC.Model.CharModel")
local CharSlotNames = {
  "Char",
  "Phantom1",
  "Phantom2"
}

local function FixMainPlayerInProps(Avatar, Props)
  local MainPlayerCharId = AvatarUtils:GetMainPlayerCharacterAttributeCharId(Avatar)
  if not MainPlayerCharId or -1 == MainPlayerCharId then
    return
  end
  local MainPlayerUuid = CharModel:GetUuidByCharId(MainPlayerCharId)
  if not MainPlayerUuid then
    return
  end
  for _, SlotName in ipairs(CharSlotNames) do
    local Uuid = Props[SlotName]
    if Uuid and "" ~= Uuid then
      local Char = Avatar.Chars[Uuid]
      local CharId = Char and Char.CharId
      if CharId and CharId ~= MainPlayerCharId and AvatarUtils:IsCharacterAttributeSwitchSameGroup(MainPlayerCharId, CharId) then
        Props[SlotName] = MainPlayerUuid
      end
    end
  end
end

function M:GetProcessedSquadList()
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.Squad then
    return {}
  end
  local Result = {}
  for Key, SquadData in pairs(Avatar.Squad) do
    local Props = {}
    for Name, Id in pairs(SquadData.Props) do
      Props[Name] = Id
    end
    FixMainPlayerInProps(Avatar, Props)
    Result[Key] = {
      Name = SquadData.Name,
      Props = Props
    }
  end
  return Result
end

return M
