require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

local function BuildPlayerInfo(RankData, PlayerInfo)
  if type(RankData) ~= "table" then
    return PlayerInfo
  end
  PlayerInfo = PlayerInfo or {}
  if PlayerInfo.Uid == nil and RankData.Uid ~= nil then
    PlayerInfo.Uid = RankData.Uid
  end
  if (nil == PlayerInfo.Nickname or PlayerInfo.Nickname == "") and RankData.Nickname then
    PlayerInfo.Nickname = RankData.Nickname
  end
  if nil == PlayerInfo.HeadIconId then
    PlayerInfo.HeadIconId = RankData.HeadIconId or 10001
  end
  if nil == PlayerInfo.HeadFrameId then
    PlayerInfo.HeadFrameId = RankData.HeadFrameId
  end
  return PlayerInfo
end

function M:OnListItemObjectSet(Content)
  self:Refresh(Content and Content.Data, Content and Content.Rank, Content and Content.PlayerInfo, Content and Content.GuildInfo)
end

function M:Refresh(RankData, Rank, PlayerInfo, GuildInfo)
  local HasData = type(RankData) == "table" and tonumber(RankData.Uid) and tonumber(RankData.Uid) > 0
  PlayerInfo = HasData and BuildPlayerInfo(RankData, PlayerInfo) or nil
  self.RankData = RankData
  self.Rank = Rank or 0
  self.PlayerInfo = PlayerInfo
  self.GuildInfo = GuildInfo
  if self.WS_Type then
    self.WS_Type:SetActiveWidgetIndex(HasData and 0 or 1)
  end
  if self.Text_Ranking then
    self.Text_Ranking:SetText(tostring(Rank))
  end
  if self.Text_Name then
    self.Text_Name:SetText(HasData and RankData.Nickname or "")
  end
  if self.Text_Level then
    self.Text_Level:SetText("")
  end
  if self.WS_Title then
    self.WS_Title:SetActiveWidgetIndex(1)
    if self.Overlay_Title then
      self.Overlay_Title:ClearChildren()
    end
  end
  if HasData and PlayerInfo then
    self:RefreshPlayerInfo(PlayerInfo, GuildInfo)
  elseif self.Head_Player then
    if self.Head_Player.CleanUpAnchor then
      self.Head_Player:CleanUpAnchor()
    end
    if self.Head_Player.SetHeadIconEmpty then
      self.Head_Player:SetHeadIconEmpty(true)
    end
    self.Head_Player:SetHeadFrame(nil)
  end
end

function M:RefreshPlayerInfo(PlayerInfo, GuildInfo)
  self.Text_Name:SetText(PlayerInfo.Nickname or "")
  self.Text_Level:SetText(PlayerInfo.Level and tostring(PlayerInfo.Level) or "")
  if PlayerInfo.HeadIconId then
    self.Head_Player:SetHeadIconEmpty(false)
    self.Head_Player:SetHeadIconById(PlayerInfo.HeadIconId, false)
  else
    self.Head_Player:SetHeadIconEmpty(true)
  end
  self.Head_Player:SetHeadFrame(PlayerInfo.HeadFrameId)
  local HasTitle = (PlayerInfo.TitleBefore ~= nil or nil ~= PlayerInfo.TitleAfter) and (not ((PlayerInfo.TitleBefore or -1) < 0) or not ((PlayerInfo.TitleAfter or -1) < 0))
  self.WS_Title:SetActiveWidgetIndex(HasTitle and 0 or 1)
  self.Overlay_Title:ClearChildren()
  if HasTitle then
    local TitleFrame = PlayerInfo.TitleFrame
    if not TitleFrame or TitleFrame < 0 then
      TitleFrame = 10001
    end
    local TitleFrameWidget = UIManager(self):LoadTitleFrameWidget(TitleFrame)
    if TitleFrameWidget then
      self.Overlay_Title:AddChildToOverlay(TitleFrameWidget)
      TitleFrameWidget:SetTitleContent(PlayerInfo.TitleBefore, PlayerInfo.TitleAfter)
    end
  end
  if self.Head_Player.CleanUpAnchor then
    self.Head_Player:CleanUpAnchor()
  end
  self.Head_Player:HeadIconSetupAnchor(self.Head_Anchor, PlayerInfo, GuildInfo)
end

return M
