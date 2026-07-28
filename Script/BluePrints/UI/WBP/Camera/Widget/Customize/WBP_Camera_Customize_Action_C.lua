require("UnLua")
local Utils = require("BluePrints.UI.WBP.Camera.CameraCustomizeUtils")
local ActionItemClickSound = "event:/ui/common/click_mid"
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  self.FocusIndex = 1
  self.ActionContents = {}
  self:InitActionListEvents()
end

function M:Init(Config, OwnerPanel)
  self.Config = Config
  self.OwnerPanel = OwnerPanel
  self.FocusIndex = 1
  self:InitActionListEvents()
  self:InitActionDispatchers()
  self:BuildList()
end

function M:InitActionListEvents()
  if not self.List_Action or self.bActionListEventsInited then
    return
  end
  if self.List_Action.BP_OnItemClicked then
    self.List_Action.BP_OnItemClicked:Clear()
    self.List_Action.BP_OnItemClicked:Add(self, self.OnListItemClicked)
  end
  if self.List_Action.BP_OnItemSelectionChanged then
    self.List_Action.BP_OnItemSelectionChanged:Clear()
    self.List_Action.BP_OnItemSelectionChanged:Add(self, self.OnListItemSelectionChanged)
  end
  if self.List_Action.BP_OnEntryInitialized then
    self.List_Action.BP_OnEntryInitialized:Clear()
    self.List_Action.BP_OnEntryInitialized:Add(self, self.OnEntryInitialized)
  end
  if self.List_Action.OnCreateEmptyContent then
    self.List_Action.OnCreateEmptyContent:Bind(self, function()
      return Utils.GetCommonItemContent()
    end)
  end
  self.bActionListEventsInited = true
end

function M:InitActionDispatchers()
  if not (not self.bActionDispatchersInited and self.AddDispatcher) or not EventID then
    return
  end
  self:AddDispatcher(EventID.OnResourcesChanged, self, self.OnResourcesChanged)
  self:AddDispatcher(EventID.OnChangeWheel, self, self.OnWheelActionEquippedChanged)
  self:AddDispatcher(EventID.OnExchangeBattleWheel, self, self.OnWheelActionEquippedChanged)
  self:AddDispatcher(EventID.OnChangeBattleWheel, self, self.OnWheelActionEquippedChanged)
  self:AddDispatcher(EventID.OnTakeOffBattleWheel, self, self.OnWheelActionEquippedChanged)
  self:AddDispatcher(EventID.OnWheelItemCleared, self, self.OnWheelActionEquippedChanged)
  self.bActionDispatchersInited = true
end

function M:BuildList()
  self.ActionContents = Utils.BuildWheelActionContents(self)
  self.CurrentSelectedContent = nil
  self.LastSelectedContent = nil
  if self.List_Action then
    if self.List_Action.BP_ClearSelection then
      self.List_Action:BP_ClearSelection()
    end
    self.List_Action:ClearListItems()
  end
  for Index, Content in ipairs(self.ActionContents or {}) do
    Content.Config = self.Config
    Content.ParentConfig = self.Config
    Content.OwnerPanel = self.OwnerPanel
    Content.ParentAction = self
    Content.Index = Index
    if self.List_Action then
      self.List_Action:AddItem(Content)
    end
  end
  if self.List_Action then
    if self.List_Action.RequestFillEmptyContent then
      self.List_Action:RequestFillEmptyContent()
    end
    if self.List_Action.RequestPlayEntriesAnim then
      self.List_Action:RequestPlayEntriesAnim()
    end
  end
  self:RestoreActionSelection(true)
end

function M:OnResourcesChanged(ResourceId)
  if nil == ResourceId then
    self:BuildList()
    return
  end
  local Avatar = Utils.GetWheelActionAvatar()
  local Resource = Avatar and Avatar.Resources and Avatar.Resources[ResourceId]
  local CurrentId = self.CurrentSelectedContent and self.CurrentSelectedContent.UnitId
  local bNeedRefresh = Utils.IsWheelActionResource(Resource) or CurrentId == ResourceId
  if not bNeedRefresh then
    for _, Content in ipairs(self.ActionContents or {}) do
      if Content.UnitId == ResourceId then
        bNeedRefresh = true
        break
      end
    end
  end
  if bNeedRefresh then
    self:BuildList()
  end
end

function M:OnWheelActionEquippedChanged()
  self:BuildList()
end

function M:RegisterEntry(Content, EntryWidget)
  if Content then
    Content.EntryWidget = EntryWidget
    Content.SelfWidget = EntryWidget
    if EntryWidget and EntryWidget.Refresh then
      EntryWidget:Refresh()
    end
    if Content == self.CurrentSelectedContent or Content.IsFocused == true then
      self:RefreshContentFocus(Content)
      self:UpdateGamePadFocusWidget(Content)
    end
  end
end

function M:OnEntryInitialized(Content, Widget)
  self:RegisterEntry(Content, Widget)
end

function M:Refresh()
  for _, Content in ipairs(self.ActionContents or {}) do
    if Content.EntryWidget and Content.EntryWidget.Refresh then
      Content.EntryWidget:Refresh()
    end
  end
end

function M:ClearNew()
  if self.OwnerPanel then
    self.OwnerPanel:ClearNew(self.Config and self.Config.NewKey)
  end
  self:RefreshNewState()
end

function M:RefreshValue()
  local Content = self.CurrentSelectedContent
  if Content and Content.EntryWidget and Content.EntryWidget.RefreshValue then
    Content.EntryWidget:RefreshValue()
  end
end

function M:RefreshNewState()
  for _, Content in ipairs(self.ActionContents or {}) do
    if Content.EntryWidget and Content.EntryWidget.RefreshNewState then
      Content.EntryWidget:RefreshNewState()
    end
  end
end

function M:GetContentIndex(Content)
  for Index, ActionContent in ipairs(self.ActionContents or {}) do
    if ActionContent == Content then
      return Index
    end
  end
  return nil
end

function M:GetContentById(ActionId)
  if nil == ActionId then
    return nil
  end
  for _, Content in ipairs(self.ActionContents or {}) do
    if Content.Id == ActionId then
      return Content
    end
  end
  return nil
end

function M:GetStoredSelectedActionId()
  if self.OwnerPanel and self.OwnerPanel.CameraCustomizeSelectedActionId ~= nil then
    return self.OwnerPanel.CameraCustomizeSelectedActionId
  end
  return self.SelectedActionId
end

function M:SetStoredSelectedActionId(ActionId)
  self.SelectedActionId = ActionId
  if self.OwnerPanel then
    self.OwnerPanel.CameraCustomizeSelectedActionId = ActionId
  end
end

function M:GetHostPanel()
  return self.OwnerPanel and self.OwnerPanel.OwnerPanel
end

function M:RefreshFocus(bFocused)
  local bParentFocused = true == bFocused
  self:RefreshContentFocus(self.LastSelectedContent)
  self:RefreshContentFocus(self.CurrentSelectedContent)
  if bParentFocused and not self.bActionParentFocused then
    self:RestoreActionSelection(true)
  end
  self.bActionParentFocused = bParentFocused
end

function M:RefreshContentFocus(Content)
  if Content and Content.EntryWidget and Content.EntryWidget.RefreshFocus then
    Content.EntryWidget:RefreshFocus()
  end
end

function M:UpdateGamePadFocusWidget(Content)
  local EntryWidget = Content and Content.EntryWidget
  if not EntryWidget then
    return
  end
  local Host = self:GetHostPanel()
  if Host and Host.RefreshCameraCustomizeGamePadCursor then
    Host:RefreshCameraCustomizeGamePadCursor(EntryWidget)
  end
end

function M:FocusActionList()
  if self.List_Action and self.List_Action.SetFocus then
    self.List_Action:SetFocus()
  end
end

function M:GetListSelectedContent()
  if self.List_Action and self.List_Action.BP_GetSelectedItem then
    return self.List_Action:BP_GetSelectedItem()
  elseif self.List_Action and self.List_Action.GetSelectedItem then
    return self.List_Action:GetSelectedItem()
  end
  return nil
end

function M:GetCurrentSelectionIndex()
  local Content = self:GetListSelectedContent() or self.CurrentSelectedContent
  return self:GetContentIndex(Content) or self.FocusIndex or 1
end

function M:SyncListSelection(Content, bNavigate, bSuppressPlay)
  if not self.List_Action or not Content then
    return
  end
  local Index = self:GetContentIndex(Content)
  if bSuppressPlay then
    self.SuppressActionSelectionPlayContent = Content
  elseif self.SuppressActionSelectionPlayContent ~= Content then
    self.SuppressActionSelectionPlayContent = nil
  end
  if self.List_Action.BP_CancelScrollIntoView then
    self.List_Action:BP_CancelScrollIntoView()
  end
  if self.List_Action.SetSelectedIndex and Index then
    self.List_Action:SetSelectedIndex(Index - 1)
  elseif self.List_Action.BP_SetSelectedItem then
    self.List_Action:BP_SetSelectedItem(Content)
  end
  if bNavigate and self.List_Action.NavigateToIndex and Index then
    self.List_Action:NavigateToIndex(Index - 1)
  elseif bNavigate and self.List_Action.BP_NavigateToItem then
    self.List_Action:BP_NavigateToItem(Content)
  end
end

function M:RestoreActionSelection(bNavigate)
  local Content = self.CurrentSelectedContent or self:GetContentById(self:GetStoredSelectedActionId()) or self.ActionContents[self.FocusIndex] or self.ActionContents[1]
  if Content then
    self:SelectActionContent(Content, true)
    self:SyncListSelection(Content, bNavigate, true)
    self:FocusActionList()
  end
end

function M:SelectActionContent(Content, bNavigate)
  if not Content then
    local LastContent = self.CurrentSelectedContent
    if LastContent then
      LastContent.IsFocused = false
      self.LastSelectedContent = LastContent
      self:RefreshContentFocus(LastContent)
    end
    self.CurrentSelectedContent = nil
    self.FocusIndex = 1
    return
  end
  local Index = self:GetContentIndex(Content)
  local LastContent = self.CurrentSelectedContent
  if LastContent and LastContent ~= Content then
    LastContent.IsFocused = false
    self.LastSelectedContent = LastContent
    self:RefreshContentFocus(LastContent)
  end
  self.FocusIndex = Index or self.FocusIndex or 1
  self.CurrentSelectedContent = Content
  Content.IsFocused = true
  self:SetStoredSelectedActionId(Content.Id)
  Utils.SetWheelActionReddotRead(Content)
  self:RefreshContentFocus(Content)
  if bNavigate then
    self:UpdateGamePadFocusWidget(Content)
  end
end

function M:MoveFocus(Delta, bPlayOnFocus)
  local Count = #(self.ActionContents or {})
  if 0 == Count then
    return false
  end
  local Index = self:GetCurrentSelectionIndex() + Delta
  if Index < 1 then
    Index = Count
  elseif Count < Index then
    Index = 1
  end
  local Content = self.ActionContents[Index]
  self:FocusActionList()
  self:SyncListSelection(Content, true, false)
  return true
end

function M:HandleLeftRight(Delta)
  return self:MoveFocus(Delta)
end

function M:HandleConfirm()
  return self:PlayAction(not self:GetListSelectedContent() and not self.CurrentSelectedContent and self.ActionContents and self.ActionContents[self.FocusIndex]) ~= false
end

function M:GetControllerOpInfo()
  if not self:GetListSelectedContent() and not self.CurrentSelectedContent then
    return nil
  end
  return {
    Key = "A",
    TextKey = "UI_CTL_Play"
  }
end

function M:HandleGamePadDirection(DirectionKey)
  if DirectionKey == UIConst.GamePadKey.LeftStickLeft or DirectionKey == UIConst.GamePadKey.LeftStickUp or DirectionKey == UIConst.GamePadKey.DPadLeft or DirectionKey == UIConst.GamePadKey.DPadUp then
    return self:MoveFocus(-1, true)
  elseif DirectionKey == UIConst.GamePadKey.LeftStickRight or DirectionKey == UIConst.GamePadKey.LeftStickDown or DirectionKey == UIConst.GamePadKey.DPadRight or DirectionKey == UIConst.GamePadKey.DPadDown then
    return self:MoveFocus(1, true)
  end
  return false
end

function M:GetCurrentFrameCount()
  if UE4 and UE4.UKismetSystemLibrary and UE4.UKismetSystemLibrary.GetFrameCount then
    return UE4.UKismetSystemLibrary.GetFrameCount()
  elseif UKismetSystemLibrary and UKismetSystemLibrary.GetFrameCount then
    return UKismetSystemLibrary.GetFrameCount()
  end
  return nil
end

function M:IsDuplicateListItemClick(Content)
  local FrameCount = self:GetCurrentFrameCount()
  if not FrameCount then
    return false
  end
  if self.LastClickedActionContent == Content and self.LastClickedActionFrame == FrameCount then
    return true
  end
  self.LastClickedActionContent = Content
  self.LastClickedActionFrame = FrameCount
  return false
end

function M:OnListItemClicked(Content, bFromItemButton)
  if not Content or not Content.Id then
    return
  end
  if self:IsDuplicateListItemClick(Content) then
    return
  end
  if AudioManager then
    AudioManager(self):PlayUISound(self.List_Action or self, ActionItemClickSound, nil, nil)
  end
  local LastContent = self.CurrentSelectedContent
  self:SelectActionContent(Content, true)
  if true == bFromItemButton then
    self:SyncListSelection(Content, true, true)
  end
  if self:PlayAction(Content) == false then
    self:SelectActionContent(LastContent, true)
    self:SyncListSelection(LastContent, true, true)
    if not LastContent then
      self.SuppressActionSelectionPlayContent = nil
    end
  end
end

function M:OnListItemSelectionChanged(Content, IsSelected)
  if not (IsSelected and Content) or not Content.Id then
    return
  end
  local LastContent = self.CurrentSelectedContent
  local bSuppressPlay = self.SuppressActionSelectionPlayContent == Content
  if bSuppressPlay then
    self.SuppressActionSelectionPlayContent = nil
  end
  self:SelectActionContent(Content, true)
  Utils.SetWheelActionReddotRead(Content)
  if bSuppressPlay or UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  if self:PlayAction(Content) == false and LastContent and LastContent ~= Content then
    self:SelectActionContent(LastContent, true)
    self:SyncListSelection(LastContent, true, true)
  end
end

function M:PlayAction(Content)
  if not Content or not Content.Id then
    return false
  end
  Utils.SetWheelActionReddotRead(Content)
  if self.OwnerPanel then
    self.OwnerPanel:ClearNew(self.Config and self.Config.NewKey)
    return self.OwnerPanel:OnItemValueChanged(self.Config, Content.Id, Content) ~= false
  end
  return true
end

return M
