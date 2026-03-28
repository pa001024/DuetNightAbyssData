require("UnLua")
local AnnounceModel = AnnounceController:GetModel()
local ReddotNames = {
  "SystemAnnouncement",
  "ActivityAnnouncement",
  "NewsAnnouncement"
}
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  M.Super.Construct(self)
  self.VB_Catalog:ClearChildren()
  self.WB_CatalogItem:ClearChildren()
  if self.Panel_Catalog then
    self.Panel_Catalog:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Panel_PageBtn then
    self.Panel_PageBtn:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Text_Fail:SetText(GText("AFDayEvent_PhotoWall_LoadFailed"))
  self.Com_Empty.Text_Empty:SetText(GText("UI_Notice_None"))
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  self:SetWebContentVisible(false)
  self.Main:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Com_Empty:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.WS_State:SetActiveWidgetIndex(0)
  self.WebContent:BindUObject("widget", self, true)
  self.WebContent.OnLoadCompleted:Add(self, function()
    if self.bWebFailed then
      return
    end
    self:SetLoadingVisible(false)
    self.WS_State:SetActiveWidgetIndex(0)
    if self.WebContent:GetUrl() == "about:blank" then
      return
    end
    self:SetWebContentVisible(true)
    self:OnWebContentLoadDone()
    self.bWebFailed = false
  end)
  self.WebContent.OnLoadError:Add(self, function()
    self:SetWebContentVisible(false)
    self.WS_State:SetActiveWidgetIndex(1)
    self:SetLoadingVisible(false)
    self.bWebFailed = true
  end)
  self.WebContent.OnLoadStarted:Add(self, function()
    if self.bWebFailed then
      return
    end
    self:SetWebContentVisible(false)
    self.WS_State:SetActiveWidgetIndex(2)
    self:SetLoadingVisible(true)
  end)
  self.Btn_Refresh.OnClicked:Add(self, self.ClickRetry)
  self.Btn_Close:Init("Close", self, function()
    self:Close()
  end)
  self.CurContent = nil
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  self.Btn_Close.btn_close.AudioEventPath = "event:/ui/common/click_btn_small"
end

function M:ClickRetry()
  self.CurrUrl = nil
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  if self.CurContent then
    self:ChangeMainContent(self.CurContent, true)
  end
end

function M:OnWebContentLoadDone()
end

function M:SetLoadingVisible(bVisible)
  if bVisible then
    self.Com_Loading:PlayAnimation(self.Com_Loading.Loop, 0, 0)
  else
    self.Com_Loading:StopAllAnimations()
  end
end

function M:AddReddotListener(ReddotName, TabIdx)
  ReddotManager.AddListener(ReddotName, self, function(self, Count)
    local NodeConf = DataMgr.ReddotNode[ReddotName]
    local IsNew = 1 == NodeConf.Type and Count > 0
    self.Tab_Announcement:ShowTabRedDot(TabIdx, IsNew, false, false)
  end)
end

function M:RemoveReddotListener(ReddotName)
  ReddotManager.RemoveListener(ReddotName, self)
end

function M:Destruct()
  self.WebContent:UnbindUObject("widget", self, true)
  for i, NodeName in ipairs(ReddotNames) do
    self:RemoveReddotListener(NodeName)
  end
  M.Super.Destruct(self)
  EMCache:SaveCommon()
  AnnounceController:ClearAnnounceMainUI()
end

function M:SetWebContentVisible(bVisible)
  if bVisible and self.CurContent then
    if self.CurContent.Conf.HasLinkImage or self.CurContent.Conf.UIStyle == AnnounceCommon.ContentUIStyle.Default then
      if AnnounceController:IsGamepad() then
        self.WebContent:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      else
        self.WebContent:SetVisibility(UIConst.VisibilityOp.Visible)
      end
    else
      self.WebContent:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
  else
  end
end

function M:OnSubTabClick(TabWidget)
  if TabWidget ~= self.CurSubTab then
    TabWidget:SetSelected()
    self.CurSubTab:RevertSelect()
    self.CurSubTab = TabWidget
  end
  self.WebContent:ExecuteJavascript()
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
  self.bNeedRequest, self.HostId, self.ShowTag, self.CurrTabIdx = ...
  self:SetUpTabs()
  self:AddDispatcher(EventID.GameViewportSizeChanged, self, function()
    if self.CurContent then
      self:RealLoadWeb(self.CurContent)
    end
  end)
end

function M:OnLoaded()
  self:BlockAllUIInput(false)
end

function M:_CreateTabParams()
  local TabParams = {
    PlatformName = PlatformName,
    Tabs = {
      {
        Text = GText(DataMgr.NoticeTab[1].Text),
        TabId = 1,
        Icon = DataMgr.NoticeTab[1].IconPath
      },
      {
        Text = GText(DataMgr.NoticeTab[2].Text),
        TabId = 2,
        Icon = DataMgr.NoticeTab[2].IconPath
      },
      {
        Text = GText(DataMgr.NoticeTab[3].Text),
        TabId = 3,
        Icon = DataMgr.NoticeTab[3].IconPath
      }
    },
    ChildWidgetBPPath = "WidgetBlueprint'/Game/UI/WBP/Announcement/Widget/WBP_Announcement_TabCell.WBP_Announcement_TabCell'"
  }
  return TabParams
end

function M:SetUpTabs()
  local PlatformName = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
  if AnnounceController:IsGamepad() then
    PlatformName = "Gamepad"
  end
  local TabParams = self:_CreateTabParams()
  self.Tab_Announcement:Init(TabParams)
  self.Tab_Announcement:BindEventOnTabSelected(self, function(self, TabWidget)
    self.CurrTabIdx = TabWidget.Idx
    self.CurrUrl = nil
    self:UpdateAnnoucement()
  end)
  for i, NodeName in ipairs(ReddotNames) do
    self:AddReddotListener(NodeName, i)
  end
  self.Tab_Announcement:SelectTab(1)
end

function M:UpdateAnnoucement()
  if self.bNeedRequest then
    ForceStopAsyncTask(self, "UpdateAnnouncementTask")
    RunAsyncTask(self, "UpdateAnnouncementTask", function(Coroutine)
      AnnounceController:GetAnnouncementDataAsync(self.ShowTag, Coroutine, self.HostId)
      self:RefreshAllAnnouncement()
    end)
    self.bNeedRequest = false
  else
    self:RefreshAllAnnouncement()
  end
end

function M:RefreshAllAnnouncement()
  HeroUSDKSubsystem(self):UploadTrackLog_Lua("game_show_notice")
  local Confs = AnnounceModel:FilterConfForUI(self.CurrTabIdx, self.ShowTag)
  if not Confs or 0 == #Confs then
    self.Com_Empty:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Main:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    return
  else
    self.Com_Empty:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Main:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
  self.List_Announcement:ScrollToTop()
  self.List_Announcement:ClearListItems()
  local bFirst = false
  local LastContent
  for _, Conf in pairs(Confs) do
    if not Conf then
    else
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.Conf = Conf
      Content.IsSelected = false
      Content.Parent = self
      Content.Index = Index
      Content.OnChangeMainContent = self.ChangeMainContent
      
      function Content.OnSelectedItenClick()
        if AnnounceController:IsGamepad() then
          return self.WebContent
        end
      end
      
      if not bFirst then
        bFirst = true
        Content.bBegin = true
        Content.IsSelected = true
      end
      self.List_Announcement:AddItem(Content)
      LastContent = Content
    end
  end
  if LastContent then
    LastContent.bLast = true
  end
  self.List_Announcement:RequestPlayEntriesAnim()
end

function M:ChangeMainContent(Content, bForce)
  local bChanged = false
  if self.CurContent and self.CurContent.Conf.NoticeID ~= Content.Conf.NoticeID then
    if self.CurContent.Widget then
      self.CurContent.Widget.Btn_Area:SetVisibility(UIConst.VisibilityOp.Visible)
      self.CurContent.Widget.Btn_Area:SetChecked(false)
      self.CurContent.Widget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    end
    self.CurContent.IsSelected = false
    bChanged = true
  end
  if not self.CurContent or self.CurContent.Conf.NoticeID ~= Content.Conf.NoticeID or bForce then
    if not AnnounceController:IsMobile() then
      self.WebContent:LoadURL("about:blank")
      DebugPrint("M:ChangeMainContent   LoadUrl about:blank")
    end
    if self:IsExistTimer(self.GetHtmlHandle) and IsValid(self) then
      self:RemoveTimer(self.GetHtmlHandle)
    end
    local _, key = self:AddTimer(0.1, function()
      self:RealLoadWeb(Content)
    end)
    self.GetHtmlHandle = key
    bChanged = true
  end
  self.CurContent = Content
  return bChanged
end

function M:RealLoadWeb(Content)
  self.bWebFailed = false
  if not self.WebContentSize then
    self.WebContentSize = UIManager(self):GetWidgetRenderSize(self.WS_State)
  end
  AnnounceModel:LoadHtmlContent(Content.Conf, function(DummyUrl, HtmlText)
    if DummyUrl == self.CurrUrl then
      return
    end
    self.CurrUrl = DummyUrl
    self.WebContent:LoadURL(self.CurrUrl)
    DebugPrint("M:RealLoadWeb   LoadUrl", DummyUrl)
  end, self.WebContentSize.X)
end

function M:Close()
  if self.IsBeginToClose then
    return
  end
  M.Super.Close(self)
  AnnounceController:OnCloseAnnounceMainUI()
  self.WebContent:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:NotifyClose()
  self:Close()
end

function M:NotifyLaunchUrl(Url)
  UE4.UKismetSystemLibrary.LaunchURL(Url)
end

function M:NotifySelectionExpand(bExpand)
  self.bSelectionExpand = bExpand
end

return M
