require("UnLua")
local AnnounceController = require("BluePrints.UI.WBP.Announcement.AnnounceController")
local AnnounceModel = AnnounceController:GetModel()
local Utils = require("Utils")
local EMCache = require("EMCache.EMCache")
local ReddotNodeName = DataMgr.ReddotNode.AnnouncementItems.Name
local Component = {}

function Component:BindForAnnouncement()
  AnnounceController:Init()
  self.Btn_Announcement:Construct()
  self.Btn_Announcement:BindEventOnReleased(self, self.OnClickAnnoucement)
  local HeroUSDKSubsystem = HeroUSDKSubsystem(self)
  ReddotManager.AddListener(ReddotNodeName, self, self.UpdateAnnoucementReddot)
  if URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
    self:OpenAnnouncementOnce(true)
  end
end

function Component:UnbindForAnnouncement()
  self.Btn_Announcement:UnBindEventOnReleased(self, self.OnClickAnnoucement)
  ReddotManager.RemoveListener(ReddotNodeName, self)
  AnnounceController:TryCloseAnnounceMainUI()
end

function Component:UpdateAnnoucementReddot(Count)
  self.Btn_Announcement.New:SetEnable(Count > 0)
end

function Component:OpenAnnouncementOnce(bReset)
  if self.Coroutine then
    return
  end
  local HostId = self.ServerInfo and self.ServerInfo.hostnum
  if not HostId then
    DebugPrint(WarningTag, "登录模块提供的HostId丢失了, 用默认的HostId")
    HostId = AHotUpdateGameMode.IsGlobalPak() and 20001 or 10001
  end
  if bReset then
    AnnounceController:ResetConf()
  end
  self.Coroutine = nil
  self.Coroutine = coroutine.create(function()
    DebugPrint("[Laixiaoyang]LoginMain::OpenAnnouncementOnce  自动弹出游戏公告")
    AnnounceModel:TrySetServerAreaNew(HostId)
    if not AnnounceController.bInit then
      AnnounceController:GetAnnouncementDataAsync(AnnounceCommon.ShowTag.InLogin, self.Coroutine, HostId)
    end
    if AnnounceModel.HasNewAdd then
      self:OnClickAnnoucement(false)
      AnnounceModel:ResetNew()
      HeroUSDKSubsystem(self):MSDKUploadCommonEventByEventName("game_anc")
    end
    self.Coroutine = nil
  end)
  coroutine.resume(self.Coroutine)
end

function Component:ClearOpenAnnouncementAsync()
  ForceStopAsyncTask(self, "OpenAnnouncementAsync")
end

function Component:OnClickAnnoucement(bNeedRequest)
  local HostId = self.ServerInfo and self.ServerInfo.hostnum
  if not HostId or URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
    bNeedRequest = true
  end
  if nil == bNeedRequest then
    bNeedRequest = not AnnounceController.bInit
  end
  self:ClearOpenAnnouncementAsync()
  RunAsyncTask(self, "OpenAnnouncementAsync", function(Coroutine)
    AnnounceController:OpenAnnouncementMain(AnnounceCommon.ShowTag.InLogin, bNeedRequest, HostId, self, Coroutine)
  end)
end

return Component
