require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local GroupRankTexturePathPattern = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/GuildWar/T_Activity_GuildWar_Rank_%s.T_Activity_GuildWar_Rank_%s'"
local GroupRankNameById = {
  [1] = "SSS",
  [2] = "SS",
  [3] = "S",
  [4] = "A",
  [5] = "B"
}

function M:Init(Data)
  Data = Data or {}
  local GroupId = Data.GroupId
  local GroupName = GroupId and GroupRankNameById[GroupId]
  if not GroupName then
    if GroupId then
      DebugPrint("WBP_Com_Ranking_GradeIcon: invalid GroupId " .. tostring(GroupId))
    end
    if self.WS_Type then
      self.WS_Type:SetActiveWidgetIndex(1)
    end
    return
  end
  local TexturePath = string.format(GroupRankTexturePathPattern, GroupName, GroupName)
  local RankTexture = LoadObject(TexturePath)
  if not RankTexture then
    DebugPrint("WBP_Com_Ranking_GradeIcon: failed to load texture " .. TexturePath)
    if self.WS_Type then
      self.WS_Type:SetActiveWidgetIndex(1)
    end
    return
  end
  if self.WS_Type then
    self.WS_Type:SetActiveWidgetIndex(0)
  end
  if self.Image_Rank then
    self.Image_Rank:SetBrushFromTexture(RankTexture)
  end
end

return M
