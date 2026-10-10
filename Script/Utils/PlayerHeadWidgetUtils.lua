local PlayerHeadWidgetUtils = {}

function PlayerHeadWidgetUtils:EnableNameWidget(WidgetComp, Name, Style, PlayerNumber)
  if not WidgetComp then
    return
  end
  WidgetComp:EnableNameWidget(Name, Style or "", PlayerNumber or 0)
end

function PlayerHeadWidgetUtils:DisableNameWidget(WidgetComp)
  if not WidgetComp then
    return
  end
  WidgetComp:DisableNameWidget()
end

function PlayerHeadWidgetUtils:RefreshRegionNameInfo(WidgetComp, UId, ObjId)
  local Name = ""
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local RegionAvatars = Avatar.RegionAvatars or {}
    local OtherAvatar = RegionAvatars[ObjId]
    local AvatarInfo = OtherAvatar and OtherAvatar.AvatarInfo
    Name = AvatarInfo and AvatarInfo.Nickname or ""
  end
  local Member, Pos = TeamController:GetModel():GetTeamMember(UId)
  self:DisableNameWidget(WidgetComp)
  local Style = "Player"
  if 0 == Pos or not Pos then
    Style = ""
  end
  self:EnableNameWidget(WidgetComp, Name or "", Style, Pos or 0)
  self:RefreshRegionGuildSignInfo(WidgetComp, ObjId)
end

function PlayerHeadWidgetUtils:RefreshRegionGuildSignInfo(WidgetComp, ObjId)
  if not IsValid(WidgetComp) then
    return
  end
  local Avatar = GWorld:GetAvatar()
  local RegionAvatars = Avatar and Avatar.RegionAvatars or {}
  local OtherAvatar = RegionAvatars[ObjId]
  local AvatarInfo = OtherAvatar and OtherAvatar.AvatarInfo
  local UniformWidget = WidgetComp:GetWidget()
  local NameWidget = IsValid(UniformWidget) and UniformWidget.Npc_Name_PC or nil
  if IsValid(NameWidget) then
    NameWidget:RefreshGuildSign(AvatarInfo)
  end
end

function PlayerHeadWidgetUtils:RefreshTitleInfo(WidgetComp, ObjId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local RegionAvatars = Avatar.RegionAvatars or {}
  local OtherAvatar = RegionAvatars[ObjId]
  if not OtherAvatar or not OtherAvatar.AvatarInfo then
    return
  end
  local PrefixId = OtherAvatar.AvatarInfo.TitleBefore
  local SuffixId = OtherAvatar.AvatarInfo.TitleAfter
  local TitleFrameId = OtherAvatar.AvatarInfo.TitleFrame
  self:RefreshTitle(WidgetComp, PrefixId, SuffixId, TitleFrameId)
end

function PlayerHeadWidgetUtils:EnableTitle(WidgetComp, PrefixId, SuffixId, TitleFrameId)
  if not WidgetComp then
    return
  end
  WidgetComp:EnableTitleWidget(PrefixId, SuffixId, TitleFrameId)
end

function PlayerHeadWidgetUtils:DisableTitle(WidgetComp)
  if not WidgetComp then
    return
  end
  WidgetComp:DisableTitleWidget()
end

function PlayerHeadWidgetUtils:RefreshTitle(WidgetComp, PrefixId, SuffixId, TitleFrameId)
  self:DisableTitle(WidgetComp)
  self:EnableTitle(WidgetComp, PrefixId, SuffixId, TitleFrameId)
end

function PlayerHeadWidgetUtils:PlayEmoji(WidgetComp, EmojiPath)
  if not WidgetComp then
    return
  end
  WidgetComp:EnableEmojiWidget(EmojiPath)
end

function PlayerHeadWidgetUtils:StopEmoji(WidgetComp)
  if not WidgetComp then
    return
  end
  WidgetComp:DisableEmojiWidget()
end

return PlayerHeadWidgetUtils
