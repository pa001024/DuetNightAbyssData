require("UnLua")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})

function M:Construct()
  self.Text_Name:SetText(GText("UI_GuildBoss_PlayerNickname"))
  self.Text_Num:SetText(GText("UI_GuildBoss_AssistCount"))
end

function M:InitContent(Params, PopupData, Owner)
  M.Super.InitContent(self, Params, PopupData, Owner)
  Params = Params or {}
  self.GuildBossData = Params.GuildBossData
  if self.GuildBossData and self.GuildBossData.GetAssistRecords then
    self.AssistRecords = self.GuildBossData:GetAssistRecords()
    if self.AssistRecords and self.AssistRecords.Values then
      self.AssistRecords = self.AssistRecords:Values()
    end
  end
  self.Avatar = GWorld:GetAvatar()
  self.Parent = Owner
  self:InitContents()
end

function M:InitContents()
  self.List:ClearListItems()
  if not self.AssistRecords or #self.AssistRecords < 1 then
    return
  end
  local PlayerUids = {}
  self.Contents = {}
  self.AssistRecordMap = {}
  for _, Data in ipairs(self.AssistRecords) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Uid = Data.Uid
    Content.AssistTimes = Data.AssistTimes
    Content.Nickname = Data.Nickname
    table.insert(PlayerUids, Data.Uid)
    table.insert(self.Contents, Content)
    self.AssistRecordMap[Data.Uid] = Data
  end
  
  local function Callback(Ret, MemberInfos)
    if self.Parent then
      self.Parent:BlockAllUIInput(false)
    end
    if not IsValid(self) then
      return
    end
    if not ErrorCode:Check(Ret) then
      self:ProcessContents(nil)
      return
    end
    self:ProcessContents(MemberInfos)
  end
  
  if self.Parent then
    self.Parent:BlockAllUIInput(true)
  end
  self.Avatar:QueryGuildMemberInfo(Callback, PlayerUids, true)
end

function M:FocusFirstListItem()
  self.List:NavigateToIndex(0)
  self:AddTimer(0.1, function()
    if not IsValid(self) then
      return
    end
    local Item = self.List:GetItemAt(0)
    if Item and Item.Widget and IsValid(Item.Widget) then
      Item.Widget:SetFocus()
    end
  end)
end

function M:ProcessContents(MemberInfos)
  local GuildModel = GuildController:GetModel()
  local SelfGuildId = self.Avatar and tonumber(self.Avatar.GuildId) or 0
  local CurrGuild = GuildModel and GuildModel:GetCurrGuild() or nil
  
  local function LookupMemberInfo(Uid)
    if type(MemberInfos) ~= "table" or nil == Uid then
      return nil
    end
    return MemberInfos[Uid] or MemberInfos[tostring(Uid)] or MemberInfos[tonumber(Uid)]
  end
  
  for _, Content in ipairs(self.Contents) do
    local MemberInfo = LookupMemberInfo(Content.Uid)
    local AssistRecord = self.AssistRecordMap and self.AssistRecordMap[Content.Uid]
    if MemberInfo then
      Content.HeadIconId = MemberInfo.HeadIconId
      Content.HeadFrameId = MemberInfo.HeadFrameId
      Content.Nickname = MemberInfo.Nickname
      Content.TitleBefore = MemberInfo.TitleBefore
      Content.TitleAfter = MemberInfo.TitleAfter
      Content.TitleFrame = MemberInfo.TitleFrame
      Content.GuildId = tonumber(MemberInfo.GuildId or MemberInfo.GuildID or 0) or 0
      Content.GuildSimpleInfo = type(MemberInfo.GuildSimpleInfo) == "table" and MemberInfo.GuildSimpleInfo or nil
      Content.GuildName = MemberInfo.GuildName
      Content.GuildLogoInfo = MemberInfo.GuildLogoInfo
      Content.GuildLogo = MemberInfo.GuildLogo
      if Content.GuildSimpleInfo then
        Content.GuildId = tonumber(Content.GuildSimpleInfo.GuildId or Content.GuildSimpleInfo.GuildID or Content.GuildSimpleInfo.Id or Content.GuildId) or Content.GuildId
        Content.GuildName = Content.GuildSimpleInfo.Name or Content.GuildSimpleInfo.GuildName or Content.GuildName
        Content.GuildLogoInfo = Content.GuildSimpleInfo.LogoInfo or Content.GuildSimpleInfo.Logo or Content.GuildSimpleInfo.GuildLogoInfo or Content.GuildSimpleInfo.GuildLogo or Content.GuildLogoInfo
        Content.GuildLogo = Content.GuildSimpleInfo.Logo or Content.GuildLogoInfo or Content.GuildLogo
      end
      if Content.GuildId > 0 and Content.GuildId == SelfGuildId and CurrGuild then
        Content.GuildInfo = CurrGuild
      elseif Content.GuildSimpleInfo then
        Content.GuildInfo = Content.GuildSimpleInfo
      elseif Content.GuildId > 0 then
        Content.GuildInfo = {
          GuildId = Content.GuildId,
          Name = Content.GuildName,
          Logo = Content.GuildLogo,
          LogoInfo = Content.GuildLogoInfo
        }
        Content.GuildSimpleInfo = Content.GuildInfo
      end
    else
      Content.HeadIconId = Content.HeadIconId or 10001
      Content.Nickname = Content.Nickname or AssistRecord and AssistRecord.Nickname or ""
    end
    self.List:AddItem(Content)
  end
  self:FocusFirstListItem()
end

return M
