require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  GuildController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == GuildCommon.EventID.OnRequestJoinGuild then
      local bInvited = (...)
      self:ApplyJoinGuildComplete(bInvited)
    end
  end)
end

function M:SetData(AllGuildList)
  self.GuildList:SetData(AllGuildList, {
    Func = self.SetGuildInfo,
    Obj = self
  }, self)
  self.GuildInfo.ParentWidget = self.ParentWidget
end

function M:SetGuildInfo(GuildData)
  if not GuildData then
    self.GuildInfo:SetData(nil, false, "GuildMain")
    return
  end
  if self.GuildInfo.GuildData and self.GuildInfo.GuildData.GuildId == GuildData.GuildId then
    return
  end
  self.GuildInfo:SetData(GuildData, false, "GuildMain")
end

function M:ApplyJoinGuildComplete(bInvited)
  if 2 == bInvited then
    self.GuildList:UpdateJoinGuildItem(self.GuildInfo.GuildData)
    self.GuildInfo:JoinSuccessful()
  end
end

function M:Destruct()
  GuildController:UnRegisterEvent(self)
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local IsHandled
  IsHandled = self.GuildInfo:OnContentKeyDown(MyGeometry, InKeyEvent)
  IsHandled = IsHandled or self.GuildList:OnContentKeyDown(MyGeometry, InKeyEvent)
  return IsHandled
end

function M:OnContentKeyUp(MyGeometry, InKeyEvent)
  local IsHandled
  IsHandled = self.GuildInfo:OnContentKeyUp(MyGeometry, InKeyEvent)
  IsHandled = IsHandled or self.GuildList:OnContentKeyUp(MyGeometry, InKeyEvent)
  return IsHandled
end

function M:SetListFocus()
  if 0 == #self.GuildList.CurShowGuildList then
    self.ParentWidget:SetFocus()
  else
    local List = self.GuildList.List_Guild
    List:SetFocus()
  end
end

function M:UpdateGamePadIcon(CurInputDevice, CurGamepadName)
  self.GuildList:UpdateGamePadIcon()
end

return M
