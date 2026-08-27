local UIUtils = require("Utils.UIUtils")
local TeamController = require("BluePrints.UI.WBP.Team.TeamController")
local TeamHallCommon = require("BluePrints.UI.WBP.TeamHall.TeamHallCommon")
local TeamHallController = require("BluePrints.UI.WBP.TeamHall.TeamHallController")
local MiscUtils = require("Utils.MiscUtils")
local M = {}
local RecruitListViewState = {
  Empty = 1,
  Loading = 2,
  List = 3
}

local function TableToLogString(Data)
  if CommonUtils and CommonUtils.TableToString then
    return CommonUtils.TableToString(Data, 6)
  end
  return tostring(Data)
end

local function IsRecruitDebugLogEnabled()
  return TeamHallCommon.DebugFlags and TeamHallCommon.DebugFlags.EnableVerboseLog
end

local function IsRecruitSourceTraceEnabled()
  return TeamHallCommon.DebugFlags and TeamHallCommon.DebugFlags.EnableSourceTraceScreenPrint
end

local function ScreenPrintRecruitSource(Message)
  if not IsRecruitSourceTraceEnabled() or not ScreenPrint then
    return
  end
  ScreenPrint("[TeamHallSrc] " .. tostring(Message))
end

function M:RefreshRecruitSubTab()
  local AllSubTabInfo = TeamHallController:GetModel():GetRecruitSubTabInfoList()
  self.Com_TabSub:UpdateTabs(AllSubTabInfo)
  if #AllSubTabInfo > 0 then
    self.Com_TabSub:SelectTab(1)
    return
  end
  self.CurSubTabId = nil
  self:InitRecruitFilter()
end

function M:_ResolveRecruitSubTabId(TabWidget, TabData)
  local ResolvedTabData = TabData
  if not ResolvedTabData and self.Com_TabSub and self.Com_TabSub.Tabs and TabWidget and TabWidget.Idx then
    ResolvedTabData = self.Com_TabSub.Tabs[TabWidget.Idx]
  end
  return ResolvedTabData and ResolvedTabData.TabId or TabWidget and TabWidget.TabId, ResolvedTabData
end

function M:OnSubTabSelected(TabWidget, TabData)
  if 1 ~= self.CurMainTabIndex then
    return
  end
  local TabId, ResolvedTabData = self:_ResolveRecruitSubTabId(TabWidget, TabData)
  self.CurSubTabId = TabId
  self:InitRecruitFilter()
  self:SearchTeamByTab(TabId, "RecruitSubTabSelected")
end

function M:SearchTeamByTab(FirstTypeId, Source)
  local HallModel = TeamHallController:GetModel()
  local Tags = HallModel:BuildRecruitmentRequestFilters(FirstTypeId)
  local FinalSource = Source or "SearchTeamByTab"
  self.MineItem:HideRecruitmentDetail()
  self:SwitchListViiewState(RecruitListViewState.Loading)
  
  local function RefreshFunc()
    self:RefreshRecruitList()
  end
  
  TeamHallController:RequestRecruitmentList(RefreshFunc, Tags, FinalSource)
  self:RefreshRefreshButtonState()
end

function M:InitRecruitFilter()
  if not self.bRecruitEmptyContentBound and self.List_Team and self.List_Team.OnCreateEmptyContent then
    self.List_Team.OnCreateEmptyContent:Bind(self, self.CreateRecruitEmptyContent)
    self.bRecruitEmptyContentBound = true
  end
  local HallModel = TeamHallController:GetModel()
  local FilterState = HallModel:GetRecruitBoardFilterState()
  local CurrentFirstTypeId = self.CurSubTabId
  local bUseCachedState = FilterState and FilterState.FirstTypeId == CurrentFirstTypeId
  local SelectedItems = bUseCachedState and FilterState.SelectedItems or {}
  local bOnlyShowNotFull = bUseCachedState and FilterState.OnlyShowNotFull or false
  local ItemDatas = CurrentFirstTypeId and HallModel:GetRecruitBoardSiftItemDatas(CurrentFirstTypeId) or {}
  HallModel:SetRecruitBoardFilterState(CurrentFirstTypeId, SelectedItems, ItemDatas, bOnlyShowNotFull)
  self.Sift:SetItemDatas(ItemDatas)
  self.Sift.SelectedSiftItems = SelectedItems
  self.Sift:BindEventOnSelectionsChanged(nil, nil)
  self.Sift:BindEventOnSelectionsChanged(self, self.OnRecruitSiftSelectionsChanged)
  self.Com_CheckBox:UnBindEventOnClicked({
    Inst = self,
    Func = self.OnRecruitOnlyShowNotFullChanged
  })
  self.Com_CheckBox:BindEventOnClicked({
    Inst = self,
    Func = self.OnRecruitOnlyShowNotFullChanged
  })
  self.Com_CheckBox:SetIsCheckedWithoutCallback(bOnlyShowNotFull)
end

function M:CreateRecruitEmptyContent()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.IsEmpty = true
  Content.ParentWidget = self
  return Content
end

function M:OnRecruitSiftSelectionsChanged(SelectedItems, ItemDatas)
  local HallModel = TeamHallController:GetModel()
  local FilterState = HallModel:GetRecruitBoardFilterState()
  HallModel:SetRecruitBoardFilterState(self.CurSubTabId, SelectedItems, ItemDatas or FilterState and FilterState.ItemDatas or {}, self.Com_CheckBox:IsChecked())
  if self.CurSubTabId then
    self:SearchTeamByTab(self.CurSubTabId, "RecruitSiftChanged")
  end
end

function M:OnRecruitOnlyShowNotFullChanged(bChecked)
  local HallModel = TeamHallController:GetModel()
  local FilterState = HallModel:GetRecruitBoardFilterState()
  HallModel:SetRecruitBoardFilterState(self.CurSubTabId, self.Sift.SelectedSiftItems or FilterState and FilterState.SelectedItems or {}, FilterState and FilterState.ItemDatas or HallModel:GetRecruitBoardSiftItemDatas(self.CurSubTabId), bChecked)
  self:RefreshMyRecruitmentDetail()
  self:RefreshRecruitList()
end

function M:IsMyRecruitmentData(RecruitmentData)
  local Avatar = GWorld and GWorld:GetAvatar() or nil
  if not (Avatar and Avatar.Uid and RecruitmentData) or not RecruitmentData.Members then
    return false
  end
  for _, MemberData in ipairs(RecruitmentData.Members) do
    if MemberData and MemberData.Uid == Avatar.Uid then
      return true
    end
  end
  return false
end

function M:RefreshRecruitList()
  if UIUtils.IsGamepadInput() then
    self:PrepareInitialRecruitFocusAfterListRefresh()
  end
  TeamHallController:StopTimer(self.RecruitListEntriesAnimTimerKey)
  self.List_Team:SetRenderOpacity(1)
  self.List_Team:ClearListItems()
  local HallModel = TeamHallController:GetModel()
  local bHasMineRecruitment = self.MineItem and self.MineItem.RecruitmentData ~= nil and (HallModel:IsRecruiting() or HallModel:IsTeamInRecruiting())
  local DisplayRecruitmentList = {}
  local HallData = HallModel:GetHallData()
  if HallData then
    local RecruitmentList = HallModel:FilterRecruitmentList(HallData:GetRecruitmentList())
    for _, RecruitmentData in ipairs(RecruitmentList or {}) do
      if not self:IsMyRecruitmentData(RecruitmentData) then
        table.insert(DisplayRecruitmentList, RecruitmentData)
      end
    end
  end
  if #DisplayRecruitmentList <= 0 then
    if bHasMineRecruitment then
      self:SwitchListViiewState(RecruitListViewState.List)
      if self.List_Team.RequestFillEmptyContent then
        self.List_Team:RequestFillEmptyContent()
      end
    else
      self:SwitchListViiewState(RecruitListViewState.Empty)
    end
    self:TryFocusInitialRecruitmentByGamepad()
    return
  end
  self:SwitchListViiewState(RecruitListViewState.List)
  for _, RecruitmentData in ipairs(DisplayRecruitmentList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.RecruitmentData = RecruitmentData
    Content.ParentWidget = self
    self.List_Team:AddItem(Content)
  end
  if self.List_Team.RequestFillEmptyContent then
    self.List_Team:RequestFillEmptyContent()
  end
  self:PlayBoardListEntriesAnim(self.List_Team, self.RecruitListEntriesAnimTimerKey)
  self:TryFocusInitialRecruitmentByGamepad()
end

function M:RemoveExpiredRecruitmentItem(RecruitmentId)
  if not RecruitmentId then
    return false
  end
  for _, Content in ipairs(self.List_Team:GetListItems():ToTable()) do
    local RecruitmentData = Content and Content.RecruitmentData
    if RecruitmentData and tostring(RecruitmentData.RecruitmentId) == tostring(RecruitmentId) then
      local ItemWidget = Content.SelfWidget
      local bHadFocus = ItemWidget and (ItemWidget:HasAnyUserFocus() or ItemWidget:HasFocusedDescendants())
      self.List_Team:RemoveItem(Content)
      if self.List_Team:GetNumItems() > 0 then
        if self.List_Team.RequestFillEmptyContent then
          self.List_Team:RequestFillEmptyContent()
        end
      else
        local bHasMineRecruitment = self.MineItem and self.MineItem.RecruitmentData ~= nil
        if bHasMineRecruitment then
          self:SwitchListViiewState(RecruitListViewState.List)
          if self.List_Team.RequestFillEmptyContent then
            self.List_Team:RequestFillEmptyContent()
          end
        else
          self:SwitchListViiewState(RecruitListViewState.Empty)
        end
      end
      if bHadFocus and UIUtils.IsGamepadInput() then
        self:RequestInitialRecruitFocusByGamepad()
      end
      return true
    end
  end
  return false
end

function M:SwitchListViiewState(StateId)
  if StateId == RecruitListViewState.Empty then
    TeamHallController:StopTimer(self.RecruitListEntriesAnimTimerKey)
    self.List_Team:ClearListItems()
    self.List_Team:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WS_Detail:SetActiveWidgetIndex(1)
    self.Text_Empty:SetText(GText("UI_NoTeamRecruitment"))
    self.Group_Refresh:SetVisibility(UIConst.VisibilityOp.Collapsed)
  elseif StateId == RecruitListViewState.Loading then
    TeamHallController:StopTimer(self.RecruitListEntriesAnimTimerKey)
    self.List_Team:ClearListItems()
    self.List_Team:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WS_Detail:SetActiveWidgetIndex(0)
    self.Group_Refresh:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Text_RefreshLoading:SetText(GText("UI_TeamHallLoading"))
  else
    self.Group_Refresh:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.List_Team:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WS_Detail:SetActiveWidgetIndex(0)
  end
end

function M:GetRecruitTotalSeconds()
  local GlobalConstant = DataMgr.GlobalConstant or {}
  local Cfg = GlobalConstant.PublishResidenceTime
  local Minutes = Cfg and Cfg.ConstantValue or 30
  return Minutes * 60
end

function M:StartRecruitTimer(RecruitStartTime)
  if not RecruitStartTime then
    self:StopRecruitTimer()
    return
  end
  self.RecruitStartTime = RecruitStartTime
  self.RecruitTotalSeconds = self:GetRecruitTotalSeconds()
  self:UpdateRecruitRemainTime()
end

function M:StopRecruitTimer()
  self.RecruitStartTime = nil
  self.RecruitTotalSeconds = nil
end

function M:UpdateRecruitRemainTime()
  if not self.RecruitStartTime or not self.RecruitTotalSeconds then
    return
  end
  local RemainSeconds = self.RecruitTotalSeconds - (TimeUtils.NowTime() - self.RecruitStartTime)
  if RemainSeconds <= 0 then
    self:StopRecruitTimer()
    return
  end
  local Minutes = math.floor(RemainSeconds / 60)
  local Seconds = math.floor(RemainSeconds % 60)
  local RemainText = string.format("%02d:%02d", Minutes, Seconds)
  if self.Text_StopRecruit and self.Text_StopRecruit.SetText then
    local Template = GText("UI_TeamHallEndToast")
    self.Text_StopRecruit:SetText(string.gsub(Template, "%%s", RemainText))
  end
end

function M:OnRecruitTick()
  if not self.RecruitStartTime then
    return
  end
  self:UpdateRecruitRemainTime()
end

function M:SyncRecruitTimerByState()
  local HallModel = TeamHallController:GetModel()
  if HallModel:IsRecruiting() or HallModel:IsTeamInRecruiting() then
    local RecruitmentData = self.GetMyRecruitmentDetailData and self:GetMyRecruitmentDetailData() or nil
    local RecruitStartTime = RecruitmentData and RecruitmentData.RecruitStartTime or nil
    if RecruitStartTime then
      self:StartRecruitTimer(RecruitStartTime)
    else
      self:StopRecruitTimer()
    end
    return
  end
  if self.RecruitStartTime then
    self:StopRecruitTimer()
  end
end

function M:TryFocusInitialRecruitmentByGamepad()
end

function M:RequestInitialRecruitFocusByGamepad()
end

return M
