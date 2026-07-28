require("UnLua")
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local UIUtils = require("Utils.UIUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

local function ResetBlueprintContentCache(CacheArray)
  if not CacheArray then
    return
  end
  if CacheArray.Empty then
    CacheArray:Empty()
  elseif CacheArray.Clear then
    CacheArray:Clear()
  end
end

local function AddContentToBlueprintCache(CacheArray, Content)
  if not (CacheArray and Content) or not CacheArray.Add then
    return
  end
  CacheArray:Add(Content)
end

M._components = {
  "BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditExpandListCompoment",
  "BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditChooseSelectionComponent",
  "BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditChooseCharacterComponent",
  "BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditChooseWeaponComponent",
  "BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditChooseActionComponent",
  "BluePrints.Common.TimerMgr"
}

function M:InitChoosePage(EditRootController, ChooseMode, Params)
  self:ApplyChoosePageContext(EditRootController, ChooseMode, Params)
  self.IsBindingFinished = self.IsBindingFinished == true
  self.IsChooseTabInitialized = false
  self.ListContents = {}
  self.AllItemContents = {}
  self.FilteredContents = {}
  self.SelectedFilterContents = {}
  self.FilterIdxes = {}
  self:_InitChooseSelectionState()
  self.LastSelectedContent = nil
  self.LastSelectedFilterContent = nil
  self.FilterContentObj_All = nil
  self.IsCharacterTipsOpened = false
  self.CurrentCharacterTipsContent = nil
  self.SelectItem = nil
  self.BottomKeyPlanIndex = nil
  if not self.EditDataModel then
    self.EditDataModel = PersonInfoController:GetEdirModel()
  end
  self:BindPageEvents()
  self:_InitCharacterTips()
  self:_InitChoosePageTab()
  self:_GetChoosePageTabWidget():PlayInAnim()
  self:RefreshChoosePageClickMaskState(false)
  self:RefreshView()
  self:PlayAnimation(self.Change_List)
end

function M:ApplyChoosePageContext(EditRootController, ChooseMode, Params)
  self.EditRootController = EditRootController
  self.ChooseMode = ChooseMode
  self.Params = Params or {}
  self.CurrentWeaponSubTab = self:_ResolveInitialWeaponSubTab()
end

function M:BindPageEvents()
  if self.IsBindingFinished then
    return
  end
  self.TileView_Select_Role.BP_OnEntryInitialized:Clear()
  self.TileView_Select_Role.BP_OnEntryInitialized:Add(self, self.OnChooseEntryInitialized)
  self.TileView_Select_Role.BP_OnItemSelectionChanged:Clear()
  self.TileView_Select_Role.BP_OnItemSelectionChanged:Add(self, self.OnListItemSelectionChanged)
  self.TileView_Select_Role.BP_OnItemClicked:Clear()
  self.TileView_Select_Role.BP_OnItemClicked:Add(self, self.OnListItemClicked)
  self.EMListView_Filter.BP_OnItemClicked:Clear()
  self.EMListView_Filter.BP_OnItemClicked:Add(self, self.OnFilterListItemClicked)
  self.Type_Melee.Btn_Click.OnClicked:Clear()
  self.Type_Melee.Btn_Click.OnClicked:Add(self, self.OnMeleeSelect)
  self.Type_Range.Btn_Click.OnClicked:Clear()
  self.Type_Range.Btn_Click.OnClicked:Add(self, self.OnRangedSelect)
  if self.Btn_Confirm and self.Btn_Confirm.Button_Area and self.Btn_Confirm.Button_Area.OnClicked then
    self.Btn_Confirm.Button_Area.OnClicked:Clear()
    self.Btn_Confirm.Button_Area.OnClicked:Add(self, self.OnClickConfirmChoose)
  end
  if self.Btn_Confirm and self.Btn_Confirm.BindForbidStateExecuteEvent then
    self.Btn_Confirm:BindForbidStateExecuteEvent(self, self.OnClickConfirmChooseForbidden)
  end
  if self.Btn_Cancel and self.Btn_Cancel.Button_Area and self.Btn_Cancel.Button_Area.OnClicked then
    self.Btn_Cancel.Button_Area.OnClicked:Clear()
    self.Btn_Cancel.Button_Area.OnClicked:Add(self, self.OnClickBack)
  end
  self.IsBindingFinished = true
end

function M:RefreshView()
  if not self.EditRootController then
    return
  end
  self:_RefreshChoosePageTab()
  self:RefreshSubTabState()
  self:RefreshListContents()
  self:RefreshTitle()
  self:RefreshBottomKeyInfo()
  self:_RefreshChoosePageActionButtons()
end

function M:_PlayEnterChoosePageAnimation()
  if self.Change_List then
    self:PlayAnimation(self.Change_List)
    return
  end
end

function M:RefreshTitle()
  local RootViewPanel = self.EditRootController.RootViewPanel
  RootViewPanel:_RefreshEditTitleCard(self.EditRootController:BuildChoosePreviewTitleViewData(self:GetSelectedContent()))
end

function M:RefreshSubTabState()
  local bIsWeaponMode = self.ChooseMode == "Weapon"
  local Visibility = bIsWeaponMode and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  self.Panel_FilterTab:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Group_Tab:SetVisibility(Visibility)
  if bIsWeaponMode then
    self:_RefreshWeaponSubTabStyle()
  end
end

function M:RefreshListContents()
  self:ExpandList(true)
end

function M:_RefreshWeaponSubTabStyle()
  if self.CurrentWeaponSubTab == "Ranged" then
    self.Type_Melee:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Type_Melee:SetSwitchOn(false)
    self.Type_Range:PlayAnimation(self.Type_Range.Click)
    self.Type_Range:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    return
  end
  self.Type_Range:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Type_Range:SetSwitchOn(false)
  self.Type_Melee:PlayAnimation(self.Type_Melee.Click)
  self.Type_Melee:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function M:RefreshBottomKeyInfo()
  local ComTab = self:_GetChoosePageTabWidget()
  if ComTab and ComTab.UpdateBottomKeyInfo then
    local BottomKeyInfo = self:_BuildBottomKeyInfo()
    if self:_IsChoosePageGamepadInput() and self.BuildChoosePageGamepadBottomKeyInfo then
      local GamepadBottomKeyInfo = self:BuildChoosePageGamepadBottomKeyInfo()
      if nil ~= GamepadBottomKeyInfo then
        BottomKeyInfo = GamepadBottomKeyInfo
      end
    end
    local PlanIndex = self:_BuildBottomKeyPlanIndex()
    if self.BottomKeyPlanIndex == PlanIndex then
      return
    end
    self.BottomKeyPlanIndex = PlanIndex
    ComTab:UpdateBottomKeyInfo(BottomKeyInfo)
  end
end

function M:OnClickBack()
  if self:_TryCloseCharacterTips() then
    return
  end
  self.EditRootController:CloseChoosePageAndReturn()
end

function M:OnClickConfirmChoose()
  if self.ChooseMode == "Character" then
    if self.IsCharacterTipsOpened then
      return
    end
    self.EditRootController:ConfirmCharacterChoosePage()
  end
end

function M:OnClickConfirmChooseForbidden()
  if self.ChooseMode ~= "Character" or not self.EditRootController then
    return
  end
  if self.EditRootController:IsSavingEdit() then
    return
  end
  if not self.EditRootController:CanConfirmCharacterChoosePage() then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_PersonalPage_NoChanges"))
  end
end

function M:OnListItemClicked(Content)
  self:OnExpandListItemClicked(Content)
end

function M:CharacterMain_OnListItemClicked(Content)
  self:OnCharacterContentClicked(Content)
end

function M:WeaponMain_OnListItemClicked(Content)
  self:OnWeaponContentClicked(Content)
end

function M:ActionMain_OnListItemClicked(Content)
  self:OnActionContentClicked(Content)
end

function M:OnListItemSelectionChanged(Content, IsSelected)
  if not self:_IsValidChooseContent(Content) then
    return
  end
  if IsSelected then
    self.LastSelectedListContent = Content
  end
  if self.Event_OnListItemSelectionChanged then
    self.Event_OnListItemSelectionChanged(self.EventReceiver, Content, IsSelected)
  end
end

function M:OnClickCharacterChosenMinus(Content)
  if self.ChooseMode ~= "Character" then
    return
  end
  if not Content or not Content.ChosenBoxIdx then
    return
  end
  local RemovedSlotIndex = Content.ChosenBoxIdx
  DebugPrint(string.format("PersonInfoDeleteChar: click minus uuid=%s slot=%s isChosen=%s", tostring(Content.Uuid), tostring(RemovedSlotIndex), tostring(Content.IsChosen == true)))
  if not self.EditRootController:RemoveCharacterChooseSelectionBySlot(RemovedSlotIndex) then
    DebugPrint(string.format("PersonInfoDeleteChar: remove failed uuid=%s slot=%s", tostring(Content.Uuid), tostring(RemovedSlotIndex)))
    return
  end
  if self.CurrentCharacterTipsContent and self.CurrentCharacterTipsContent.Uuid == Content.Uuid then
    self:_HideCharacterTips(false)
  end
  if self.SelectItem == Content then
    self.SelectItem = nil
  end
  if self:IsSelectedContent(Content) then
    self:ClearSelectedContent()
  end
  if self.LastSelectedContent == Content then
    self.LastSelectedContent = nil
  end
  if self.LastSelectedListContent == Content then
    self.LastSelectedListContent = nil
  end
  Content.IsChosen = false
  Content.ChosenBoxIdx = nil
  Content.bMinus = false
  Content.bSelectTag = false
  local EntryWidget = IsValid(Content.UI) and Content.UI or nil
  if not EntryWidget and IsValid(Content.Widget) then
    EntryWidget = Content.Widget
  end
  if not EntryWidget and IsValid(Content.SelfWidget) then
    EntryWidget = Content.SelfWidget
  end
  if EntryWidget then
    self:RefreshEntryVisual(Content, EntryWidget)
  end
  self:_RefreshChoosePageActionButtons()
  DebugPrint(string.format("PersonInfoDeleteChar: click minus done uuid=%s slot=%s", tostring(Content.Uuid), tostring(RemovedSlotIndex)))
end

function M:OnMeleeSelect()
  if self.CurrentWeaponSubTab == "Melee" then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
  self.CurrentWeaponSubTab = "Melee"
  self.Type_Range:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Type_Range:SetSwitchOn(false)
  self.Type_Melee:PlayAnimation(self.Type_Melee.Click)
  self.Type_Melee:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self:ExpandList(true)
  self:_SelectAndFocusWeaponDefaultContent()
  self:_RefreshChoosePageTabBottomKey()
  self:RefreshTitle()
  self:RefreshBottomKeyInfo()
end

function M:OnRangedSelect()
  if self.CurrentWeaponSubTab == "Ranged" then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
  self.CurrentWeaponSubTab = "Ranged"
  self.Type_Melee:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Type_Melee:SetSwitchOn(false)
  self.Type_Range:PlayAnimation(self.Type_Range.Click)
  self.Type_Range:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self:ExpandList(true)
  self:_SelectAndFocusWeaponDefaultContent()
  self:_RefreshChoosePageTabBottomKey()
  self:RefreshTitle()
  self:RefreshBottomKeyInfo()
end

function M:TrySyncWeaponSubTabWithSelectedSlot()
  if self.ChooseMode ~= "Weapon" then
    return false
  end
  local TargetSubTab = self:_ResolveWeaponSubTabBySelectedSlot()
  if TargetSubTab == self.CurrentWeaponSubTab then
    return false
  end
  self.CurrentWeaponSubTab = TargetSubTab
  self:RefreshSubTabState()
  self:RefreshListContents()
  self:_SyncEquippedContentAsSelectedForUniqueEquipModes()
  if self.EditRootController and self.EditRootController._RefreshChoosePageEquippedEntryState then
    self.EditRootController:_RefreshChoosePageEquippedEntryState()
  end
  self:RefreshTitle()
  self:RefreshBottomKeyInfo()
  return true
end

function M:OnReturnKeyDown()
  self:OnClickBack()
end

function M:Handle_ChoosePageForwardedKeyDown(InKeyName)
  if self.ChooseMode == "Weapon" then
    if "A" == InKeyName then
      self:OnMeleeSelect()
      return true
    end
    if "D" == InKeyName then
      self:OnRangedSelect()
      return true
    end
  end
  return false
end

function M:OnFilterListItemClicked(Content)
  self.LastSelectedFilterContent = Content
  local bRestoreFilterFocus = self:_ShouldRestoreFilterFocusAfterFilterRefresh()
  if self.FilterMod == "Single" then
    if Content.IsSelected then
      return
    end
    for Tag, Value in pairs(self.SelectedFilterContents) do
      if Value ~= Content then
        self:SetFilterContentIsSelected(Value, false)
        self.SelectedFilterContents[Tag] = nil
      end
    end
    if self.FilterContentObj_All ~= Content then
      self:SetFilterContentIsSelected(self.FilterContentObj_All, false)
    end
    self:SetFilterContentIsSelected(Content, true)
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
  self:UpdateFilterInfos()
  if self.Event_FilterFunction then
    self.FilteredContents = self.Event_FilterFunction(self.EventReceiver, self.AllItemContents, self.FilterIdxes) or {}
    if self.Event_SortFuncion then
      local SortByIdx, SortType = self.Common_Sort_List:GetSortInfos()
      self.Event_SortFuncion(self.EventReceiver, self.FilteredContents, SortByIdx, SortType)
    end
    self:FillListView()
    if bRestoreFilterFocus then
      self:_RestoreFilterItemFocusAfterFilterRefresh(Content)
    end
  end
end

function M:OnSortListSelectionsChanged()
  local SortByIdx, SortType = self.Common_Sort_List:GetSortInfos()
  if self.Event_SortFuncion then
    self.Event_SortFuncion(self.EventReceiver, self.FilteredContents, SortByIdx, SortType)
    self:FillListView()
  end
end

function M:OnSortTypeChanged()
  local SortByIdx, SortType = self.Common_Sort_List:GetSortInfos()
  if self.Event_SortFuncion then
    self.Event_SortFuncion(self.EventReceiver, self.FilteredContents, SortByIdx, SortType)
    self:FillListView()
  end
end

function M:_BuildCurrentListContents(TabName)
  if "Character" == TabName then
    return self.EditDataModel:GetCustomEditCharacterItems()
  end
  if "Melee" == TabName or "Ranged" == TabName then
    return self.EditDataModel:GetCustomEditWeaponItems(TabName)
  end
  if "Action" == TabName then
    return self.EditDataModel:GetCustomEditActionItems()
  end
  return {}
end

function M:_CommitCharacterSelection(Content)
  if not Content or not Content.Uuid then
    return false
  end
  local Avatar = GWorld and GWorld.GetAvatar and GWorld:GetAvatar() or nil
  local CharData = Avatar and Avatar.Chars and Avatar.Chars[Content.Uuid] or nil
  return self.EditRootController:ApplyCharacterSelection(CharData, nil)
end

function M:_CommitWeaponSelection(Content)
  if not Content then
    return false, "weapon_missing"
  end
  if Content.IsEmptyWeapon == true then
    return self.EditRootController:ApplyWeaponSelection(nil)
  end
  if not Content.Uuid then
    return false, "weapon_missing"
  end
  local Avatar = GWorld and GWorld.GetAvatar and GWorld:GetAvatar() or nil
  local WeaponData = Avatar and Avatar.Weapons and Avatar.Weapons[Content.Uuid] or nil
  return self.EditRootController:ApplyWeaponSelection(WeaponData)
end

function M:_CommitActionSelection(Content)
  if Content and Content.IsDefaultAction == true then
    return self.EditRootController:ApplyActionSelection(nil)
  end
  local ActionData = self.EditDataModel:BuildCustomEditActionData(Content)
  if not ActionData then
    return false, "action_missing"
  end
  return self.EditRootController:ApplyActionSelection(ActionData)
end

function M:InitEditListView(Parent, Params)
  self.Parent = Parent
  self.Params = Params
  self.Filters = Params.Filters or {}
  self.FilterMod = Params.FilterMod or "Single"
  self.FilterIdxes = {}
  self.OrderByDisplayNames = Params.OrderByDisplayNames
  self.SortType = Params.SortType
  self.AllItemContents = Params.ItemContents
  self.EMListView_Filter:ClearListItems()
  ResetBlueprintContentCache(self.CacheFilterContents)
  ResetBlueprintContentCache(self.CacheChooseContents)
  ResetBlueprintContentCache(self.CacheChooseEmptyContents)
  self.SelectedFilterContents = {}
  self.FilteredContents = {}
  if self.AllItemContents then
    for _, Content in ipairs(self.AllItemContents) do
      self.FilteredContents[#self.FilteredContents + 1] = Content
    end
  end
  self.LastSelectedFilterContent = nil
  self.FilterContentObj_All = nil
  if #self.Filters > 0 then
    self.FilterContentObj_All = NewObject(UIUtils.GetCommonItemContentClass())
    self.FilterContentObj_All.Index = 0
    self.FilterContentObj_All.Icon = "/Game/UI/Texture/Static/Atlas/Armory/T_Armory_Select.T_Armory_Select"
    self.FilterContentObj_All.IsSelected = true
    self.FilterContentObj_All.Owner = self
    self.LastSelectedFilterContent = self.FilterContentObj_All
    self.EMListView_Filter:AddItem(self.FilterContentObj_All)
    AddContentToBlueprintCache(self.CacheFilterContents, self.FilterContentObj_All)
    self.Panel_FilterTab:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Panel_FilterTab:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  for Index, FilterData in ipairs(self.Filters) do
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    for Key, Value in pairs(FilterData) do
      Obj[Key] = Value
    end
    Obj.Index = Index
    Obj.Owner = self
    self.EMListView_Filter:AddItem(Obj)
    AddContentToBlueprintCache(self.CacheFilterContents, Obj)
  end
  self.Common_Sort_List:Init(self:_GetSortParentWidget(), self.OrderByDisplayNames, self.SortType or CommonConst.DESC, {
    OnGetBackFocusWidget = function()
      return self:GetDesiredFocusTarget()
    end,
    OnAddedToFocusPath = function()
      if self.OnSortListAddedToFocusPath then
        self:OnSortListAddedToFocusPath()
      end
    end,
    OnRemovedFromFocusPath = function()
      if self.OnSortListRemovedFromFocusPath then
        self:OnSortListRemovedFromFocusPath()
      end
    end
  })
  self.Common_Sort_List:BindEventOnSelectionsChanged(self, self.OnSortListSelectionsChanged)
  self.Common_Sort_List:BindEventOnSortTypeChanged(self, self.OnSortTypeChanged)
  self.WS_List:SetActiveWidgetIndex(0)
  self.Event_SortFuncion(self.EventReceiver, self.FilteredContents, 1, 2)
  self:FillListView()
end

function M:BindEvents(EventReceiver, Events)
  self.EventReceiver = EventReceiver
  self.Event_OnListItemClicked = Events.OnListItemClicked
  self.Event_OnListItemSelectionChanged = Events.OnListItemSelectionChanged
  self.Event_SortFuncion = Events.SortFuncion
  self.Event_FilterFunction = Events.FilterFunction
  self.Event_OnListItemInited = Events.OnListItemInited
  self.Event_OnEntryInitialized = Events.OnEntryInitialized
  self.Event_OnItemIsHoverChanged = Events.OnItemIsHoverChanged
end

function M:FillListView()
  self:PlayAnimation(self.Change)
  self.TileView_Select_Role:ClearListItems()
  local MatchedSelectedContent = self:_FindMatchedContent(self.FilteredContents, self:GetSelectedContent())
  if MatchedSelectedContent ~= self:GetSelectedContent() then
    self.SelectedContent = MatchedSelectedContent
  end
  self:_SyncEquippedContentAsSelectedForUniqueEquipModes()
  self.LastSelectedContent = self:GetSelectedContent()
  self.LastSelectedListContent = self:GetSelectedContent()
  if self.ChooseMode == "Character" then
    self:_RefreshCharacterChosenState(self.FilteredContents)
  end
  for _, Content in ipairs(self.FilteredContents or {}) do
    local bIsSelected = self:IsSelectedContent(Content)
    Content.IsSelect = bIsSelected
    Content.IsSelected = bIsSelected
    if self.ChooseMode == "Character" then
      Content.bSelectTag = Content.IsChosen == true
    else
      Content.bSelectTag = false
    end
    self.TileView_Select_Role:AddItem(Content)
    AddContentToBlueprintCache(self.CacheChooseContents, Content)
  end
  if #self.FilteredContents <= 0 then
    self.WS_List:SetActiveWidgetIndex(1)
    self.Text_Empty:SetText(self:_BuildEmptyText())
    self.Common_Sort_List:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.TileView_Select_Role:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  self.WS_List:SetActiveWidgetIndex(0)
  self.Common_Sort_List:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.TileView_Select_Role:SetVisibility(UIConst.VisibilityOp.Visible)
  if self:GetSelectedContent() then
    self.TileView_Select_Role:BP_SetSelectedItem(self:GetSelectedContent())
    self.TileView_Select_Role:BP_NavigateToItem(self:GetSelectedContent())
  end
  self:AddTimer(0.001, function()
    if 0 == GWorld.GameInstance:GetGameUIManager():GetWidgetRenderSize(self.TileView_Select_Role).X then
      return
    end
    local ItemUIs = self.TileView_Select_Role:GetDisplayedEntryWidgets()
    local XCount, YCount = UIUtils.GetTileViewContentMaxCount(self.TileView_Select_Role, "XY")
    local ItemLen = ItemUIs:Length()
    local RestCount = XCount * YCount - ItemLen
    if RestCount <= 0 then
      RestCount = XCount - #self.FilteredContents % XCount
    end
    self:FillEmptyItems(RestCount)
    if self.Event_OnListItemInited then
      self.Event_OnListItemInited(self.EventReceiver)
    end
  end, false, 0, "DelayAddEmptyItem", true)
end

function M:_ShouldRestoreFilterFocusAfterFilterRefresh()
  if not self:_IsChoosePageUsingGamepad() then
    return false
  end
  if not self.EMListView_Filter then
    return false
  end
  return UIUtils.HasAnyFocus(self.EMListView_Filter)
end

function M:_RestoreFilterItemFocusAfterFilterRefresh(Content)
  self:AddTimer(0.001, function()
    if not self.EMListView_Filter or not self.EMListView_Filter.SetFocus then
      return
    end
    local FocusContent = Content or self.LastSelectedFilterContent or self.FilterContentObj_All
    if FocusContent then
      self.EMListView_Filter:BP_SetSelectedItem(FocusContent)
      self.EMListView_Filter:BP_NavigateToItem(FocusContent)
    end
    self.EMListView_Filter:SetFocus()
  end, false, 0, "DelayFocusFilterItemAfterRefresh", true)
end

function M:FillEmptyItems(Count)
  for _ = 1, Count do
    local EmptyContent = NewObject(UIUtils.GetCommonItemContentClass())
    self.TileView_Select_Role:AddItem(EmptyContent)
    AddContentToBlueprintCache(self.CacheChooseEmptyContents, EmptyContent)
  end
end

function M:OnChooseEntryInitialized(Content, EntryWidget)
  if not self:_IsValidChooseContent(Content) then
    if EntryWidget and EntryWidget.SetVisibility then
      EntryWidget:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    return
  end
  Content.UI = EntryWidget
  Content.Widget = EntryWidget
  Content.SelfWidget = EntryWidget
  self:RefreshEntryVisual(Content, EntryWidget)
end

function M:_FindDefaultSelectedContent(ItemContents)
  if self.ChooseMode == "Character" then
    local Slot = self.EditRootController and self.EditRootController.GetSelectedCharacterSlot and self.EditRootController:GetSelectedCharacterSlot() or nil
    local CharData = Slot and Slot.CharData or nil
    local CharUuid = CharData and CharData.Uuid or nil
    for _, Content in ipairs(ItemContents) do
      if Content.Uuid == CharUuid then
        return Content
      end
    end
    return nil
  elseif self.ChooseMode == "Weapon" then
    local WeaponData = self.EditRootController:GetSelectedCharacterWeaponData()
    local WeaponUuid = WeaponData and WeaponData.Uuid or nil
    for _, Content in ipairs(ItemContents) do
      if Content.Uuid == WeaponUuid then
        return Content
      end
    end
    if nil ~= WeaponData then
      return nil
    end
    for _, Content in ipairs(ItemContents) do
      if Content.IsEmptyWeapon == true then
        return Content
      end
    end
  elseif self.ChooseMode == "Action" then
    local ActionData = self.EditRootController:GetSelectedCharacterActionData()
    local PoseId = ActionData and ActionData.PoseId or nil
    for _, Content in ipairs(ItemContents) do
      if Content.PoseId == PoseId then
        return Content
      end
    end
    for _, Content in ipairs(ItemContents) do
      if true == Content.IsDefaultAction then
        return Content
      end
    end
  end
  return ItemContents[1]
end

function M:_SelectAndFocusWeaponDefaultContent()
  local DefaultContent = self:_FindDefaultSelectedContent(self.FilteredContents or {})
  if not DefaultContent then
    return
  end
  self:SetSelectedContent(DefaultContent)
end

function M:_ShouldSyncEquippedContentAsSelected()
  return self.ChooseMode == "Weapon" or self.ChooseMode == "Action"
end

function M:_SyncEquippedContentAsSelectedForUniqueEquipModes()
  if not self:_ShouldSyncEquippedContentAsSelected() then
    return
  end
  local DefaultContent = self:_FindDefaultSelectedContent(self.FilteredContents or {})
  self:SetSelectedContent(DefaultContent)
end

function M:_InitChoosePageTab()
  local ComTab = self:_GetChoosePageTabWidget()
  if not ComTab then
    self.IsChooseTabInitialized = true
    return
  end
  local TabConfigData = {
    TitleName = self:_BuildTitleText(),
    StyleName = "TextImage",
    DynamicNode = {"Back", "BottomKey"},
    BottomKeyInfo = self:_BuildBottomKeyInfo(),
    OwnerPanel = self,
    BackCallback = self.OnReturnKeyDown
  }
  ComTab:Init(TabConfigData)
  self.IsChooseTabInitialized = true
end

function M:_RefreshChoosePageTab()
  local ComTab = self:_GetChoosePageTabWidget()
  if not ComTab then
    self.IsChooseTabInitialized = true
    return
  end
  if not self.IsChooseTabInitialized then
    self:_InitChoosePageTab()
    return
  end
  ComTab:UpdateTopTitle(self:_BuildTitleText())
  self:_RefreshChoosePageTabBottomKey()
end

function M:_RefreshChoosePageTabBottomKey()
  self:RefreshBottomKeyInfo()
end

function M:_GetChoosePageTabWidget()
  return self.Com_Tab
end

function M:_BuildBottomKeyPlanIndex()
  local ChooseMode = self.ChooseMode or "None"
  local bIsGamepad = self:_IsChoosePageGamepadInput()
  local bIsTipsOpened = self.IsCharacterTipsOpened == true
  local FocusedContent = self.LastSelectedListContent or self.LastSelectedContent
  local bShowClear = "Character" == ChooseMode and nil ~= FocusedContent and true == FocusedContent.IsChosen and not bIsTipsOpened
  return string.format("%s|%s|%s|%s", tostring(ChooseMode), tostring(bIsGamepad), tostring(bIsTipsOpened), tostring(bShowClear))
end

function M:SetFilterContentIsSelected(Content, IsSelected)
  if not Content then
    return
  end
  Content.IsSelected = true == IsSelected
  if IsValid(Content.UI) and Content.UI.SetIsSelected then
    Content.UI:SetIsSelected(Content.IsSelected)
  end
  if Content.Tag then
    if Content.IsSelected then
      self.SelectedFilterContents[Content.Tag] = Content
    else
      self.SelectedFilterContents[Content.Tag] = nil
    end
  end
end

function M:UpdateFilterInfos()
  local Indexes = {}
  local Items = self.EMListView_Filter:GetListItems()
  local Len = Items:Length()
  for Index = 2, Len do
    local Item = Items[Index]
    if Item and self.SelectedFilterContents[Item.Tag] then
      Indexes[#Indexes + 1] = Item.Index
    end
  end
  self.FilterIdxes = Indexes
  return Indexes
end

function M:_FilterItemContents(InContentArray, FilterIdxes, ListType)
  if not FilterIdxes or #FilterIdxes <= 0 then
    return self:_CloneArray(InContentArray)
  end
  local FilteredItems = {}
  if "Character" == ListType then
    local Tags = self.CharacterFilterTags
    for _, Content in ipairs(InContentArray or {}) do
      local CharCfg = DataMgr.BattleChar and DataMgr.BattleChar[Content.UnitId] or nil
      for _, FilterIndex in ipairs(FilterIdxes) do
        if CharCfg and CharCfg.Attribute == Tags[FilterIndex] then
          FilteredItems[#FilteredItems + 1] = Content
          break
        end
      end
    end
    return FilteredItems
  end
  if "Melee" == ListType then
    local Tags = self.MeleeFilterTags
    local Avatar = GWorld and GWorld.GetAvatar and GWorld:GetAvatar() or nil
    for _, Content in ipairs(InContentArray or {}) do
      if Content.IsEmptyWeapon == true then
        FilteredItems[#FilteredItems + 1] = Content
      else
        local Weapon = Avatar and Avatar.Weapons and Avatar.Weapons[Content.Uuid] or nil
        for _, FilterIndex in ipairs(FilterIdxes) do
          if Weapon and Weapon:HasTag(Tags[FilterIndex]) then
            FilteredItems[#FilteredItems + 1] = Content
            break
          end
        end
      end
    end
    return FilteredItems
  end
  if "Ranged" == ListType then
    local Tags = self.RangedFilterTags
    local Avatar = GWorld and GWorld.GetAvatar and GWorld:GetAvatar() or nil
    for _, Content in ipairs(InContentArray or {}) do
      if Content.IsEmptyWeapon == true then
        FilteredItems[#FilteredItems + 1] = Content
      else
        local Weapon = Avatar and Avatar.Weapons and Avatar.Weapons[Content.Uuid] or nil
        for _, FilterIndex in ipairs(FilterIdxes) do
          if Weapon and Weapon:HasTag(Tags[FilterIndex]) then
            FilteredItems[#FilteredItems + 1] = Content
            break
          end
        end
      end
    end
    return FilteredItems
  end
  if "Action" == ListType then
    local Tags = self.ActionFilterTags
    for _, Content in ipairs(InContentArray or {}) do
      if true == Content.IsDefaultAction then
        FilteredItems[#FilteredItems + 1] = Content
      else
        for _, FilterIndex in ipairs(FilterIdxes) do
          if Content.ActionCategory == Tags[FilterIndex] then
            FilteredItems[#FilteredItems + 1] = Content
            break
          end
        end
      end
    end
    return FilteredItems
  end
  return self:_CloneArray(InContentArray)
end

function M:_BuildTitleText()
  if self.ChooseMode == "Character" then
    return GText("UI_PersonalPage_SelectChar")
  end
  if self.ChooseMode == "Weapon" then
    return GText("UI_PersonalPage_SetWeapon")
  end
  if self.ChooseMode == "Action" then
    return GText("UI_PersonalPage_SetAction")
  end
  return ""
end

function M:_BuildEmptyText()
  if self.ChooseMode == "Character" then
    return GText("UI_Armory_Char_Empty")
  end
  if self.ChooseMode == "Weapon" then
    return GText("UI_Armory_Weapon_Empty")
  end
  if self.ChooseMode == "Action" then
    return GText("UI_Armory_PetListIsEmpty")
  end
  return GText("UI_Armory_PetListIsEmpty")
end

function M:_BuildBottomKeyInfo()
  local BottomKeyInfo = {}
  BottomKeyInfo[#BottomKeyInfo + 1] = {
    KeyInfoList = {
      {
        Type = "Text",
        Text = "Esc",
        ClickCallback = self.OnClickBack,
        Owner = self
      }
    },
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = "B",
        ClickCallback = self.OnClickBack,
        Owner = self
      }
    },
    Desc = GText("UI_BACK")
  }
  return BottomKeyInfo
end

function M:_RefreshChooseEntryWidget(EntryWidget, Content, bIsSelected)
  if not EntryWidget or not Content then
    return
  end
  if self.ChooseMode == "Character" then
    local bIsChosen = Content.IsChosen == true
    Content.bSelectTag = Content.IsChosen == true
    Content.IsSelect = true == bIsSelected
    Content.IsSelected = true == bIsSelected
    EntryWidget:SetItemSelect(bIsChosen)
    EntryWidget:SetSelected(true == bIsSelected)
    EntryWidget:SetItemMinus(bIsChosen)
    if bIsChosen then
      self:_BindChooseEntryMinusButton(EntryWidget, Content)
    end
    return
  end
  if self.ChooseMode == "Weapon" then
    local bIsChosen = self:_IsWeaponContentChosen(Content)
    Content.bSelectTag = bIsChosen
    Content.bInGear = false
    Content.IsSelect = true == bIsSelected
    Content.IsSelected = true == bIsSelected
    EntryWidget:SetItemSelect(bIsChosen)
    if EntryWidget.SetInGear then
      EntryWidget:SetInGear(false)
    end
    EntryWidget:SetSelected(true == bIsSelected)
    EntryWidget:SetItemMinus(false)
    return
  end
  local bIsChosen = self:_IsActionContentChosen(Content)
  Content.bSelectTag = bIsChosen
  Content.bInGear = false
  Content.IsSelect = true == bIsSelected
  Content.IsSelected = true == bIsSelected
  EntryWidget:SetItemSelect(bIsChosen)
  if EntryWidget.SetInGear then
    EntryWidget:SetInGear(false)
  end
  EntryWidget:SetSelected(true == bIsSelected)
  EntryWidget:SetItemMinus(false)
end

function M:_IsWeaponContentChosen(Content)
  if not (Content and self.EditRootController) or not self.EditRootController.DisplayEditor then
    return false
  end
  local Draft = self.EditRootController.DisplayEditor:GetDraft()
  local CharacterSlots = Draft and Draft.CharacterSlots or nil
  if not CharacterSlots then
    return false
  end
  for _, Slot in ipairs(CharacterSlots) do
    local WeaponData = Slot and Slot.WeaponData or nil
    if Content.IsEmptyWeapon == true then
      if Slot and Slot.CharData and nil == WeaponData then
        return true
      end
    elseif WeaponData and nil ~= Content.Uuid and WeaponData.Uuid == Content.Uuid then
      return true
    end
  end
  return false
end

function M:_IsActionContentChosen(Content)
  if not (Content and self.EditRootController) or not self.EditRootController.DisplayEditor then
    return false
  end
  local Draft = self.EditRootController.DisplayEditor:GetDraft()
  local CharacterSlots = Draft and Draft.CharacterSlots or nil
  if not CharacterSlots then
    return false
  end
  local SlotIndex = self.EditRootController.GetSelectedCharacterSlotIndex and self.EditRootController:GetSelectedCharacterSlotIndex() or nil
  local Slot = SlotIndex and CharacterSlots[SlotIndex] or nil
  if not Slot or not Slot.CharData then
    return false
  end
  local ActionData = Slot.Action
  local PoseId = ActionData and ActionData.PoseId or nil
  if Content.IsDefaultAction == true then
    return nil == PoseId
  end
  return Content.PoseId ~= nil and Content.PoseId == PoseId
end

function M:_BindChooseEntryMinusButton(EntryWidget, Content)
  if not IsValid(EntryWidget.MinusWidget) then
    return
  end
  local MinusBtn = EntryWidget.MinusWidget.Btn_Minus
  MinusBtn:UnBindEventOnClickedByObj(self)
  if Content.IsChosen ~= true then
    return
  end
  MinusBtn:BindEventOnClicked(self, function()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_minus", nil, nil)
    self:OnClickCharacterChosenMinus(Content)
  end)
end

function M:_RefreshCharacterChosenState(ItemContents)
  if self.ChooseMode ~= "Character" then
    return
  end
  local SlotDraft = self.EditRootController and self.EditRootController._BuildCharacterChooseSlotDraft and self.EditRootController:_BuildCharacterChooseSlotDraft() or nil
  local ChosenSlotIndexByUuid = {}
  if SlotDraft and SlotDraft.CharacterSlots then
    for SlotIndex, Slot in ipairs(SlotDraft.CharacterSlots) do
      local CharData = Slot and Slot.CharData or nil
      local CharUuid = CharData and CharData.Uuid or nil
      if nil ~= CharUuid then
        ChosenSlotIndexByUuid[CharUuid] = SlotIndex
      end
    end
  end
  for _, Content in ipairs(ItemContents or {}) do
    local ChosenSlotIndex = ChosenSlotIndexByUuid[Content.Uuid]
    Content.bAllUseAsyncLoadWidget = false
    Content.IsChosen = nil ~= ChosenSlotIndex
    Content.ChosenBoxIdx = ChosenSlotIndex
    Content.bMinus = Content.IsChosen == true
    Content.Parent = self
  end
end

function M:RefreshEntryVisual(Content, EntryWidget)
  if not Content then
    return
  end
  EntryWidget = EntryWidget or self:_GetChooseEntryWidget(Content)
  if not EntryWidget then
    return
  end
  local bSelected = self:IsSelectedContent(Content)
  local bShowMinus = self:_CanShowContentMinus(Content)
  Content.IsSelect = bSelected
  Content.IsSelected = bSelected
  Content.bMinus = bShowMinus
  EntryWidget:SetSelected(bSelected)
  self:RefreshEntryEquipState(Content, EntryWidget)
  EntryWidget:SetItemMinus(bShowMinus)
  if bShowMinus then
    self:_BindChooseEntryMinusButton(EntryWidget, Content)
  end
end

function M:RefreshEntryEquipState(Content, EntryWidget)
  if not Content then
    return
  end
  local bEquipped = self:_IsContentEquipped(Content)
  Content.bSelectTag = bEquipped
  Content.IsEquipped = bEquipped
  EntryWidget = EntryWidget or self:_GetChooseEntryWidget(Content)
  if not EntryWidget then
    self:RefreshEntryConflictVisual(Content, nil)
    return
  end
  EntryWidget:SetItemSelect(bEquipped)
  if EntryWidget.SetInGear then
    EntryWidget:SetInGear(false)
  end
  self:RefreshEntryConflictVisual(Content, EntryWidget)
end

function M:RefreshEntryConflictVisual(Content, EntryWidget)
  if not Content then
    return
  end
  if self.ChooseMode == "Weapon" and self.RefreshWeaponEntryConflictVisual then
    self:RefreshWeaponEntryConflictVisual(Content, EntryWidget)
    return
  end
  Content.bConflict = false
  EntryWidget = EntryWidget or self:_GetChooseEntryWidget(Content)
  if not EntryWidget then
    return
  end
  if EntryWidget.SetItemConflict then
    EntryWidget:SetItemConflict(false)
  end
end

function M:_RefreshFilteredEntryVisuals()
  for _, Content in ipairs(self.FilteredContents or {}) do
    if self:_IsValidChooseContent(Content) then
      self:RefreshEntryVisual(Content)
    end
  end
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if self:_TryCloseCharacterTips() then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self.Handle_ChoosePageGamepadKeyDown and self:Handle_ChoosePageGamepadKeyDown(InKeyName) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if "Escape" == InKeyName then
    self:OnClickBack()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if self:Handle_ChoosePageForwardedKeyDown(InKeyName) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:GetZOrder()
  local ParentWidget = self:_GetSortParentWidget()
  if ParentWidget and ParentWidget ~= self and ParentWidget.GetZOrder then
    return ParentWidget:GetZOrder()
  end
  return 200
end

function M:_ResolveInitialWeaponSubTab()
  if self.ChooseMode ~= "Weapon" then
    return self.CurrentWeaponSubTab or "Melee"
  end
  return self:_ResolveWeaponSubTabBySelectedSlot()
end

function M:_ResolveWeaponSubTabBySelectedSlot()
  local WeaponData = self.EditRootController and self.EditRootController.GetSelectedCharacterWeaponData and self.EditRootController:GetSelectedCharacterWeaponData() or nil
  if WeaponData and WeaponData.HasTag and WeaponData:HasTag("Ranged") then
    return "Ranged"
  end
  return "Melee"
end

function M:_FindMatchedContent(ItemContents, OldContent)
  if not OldContent then
    return nil
  end
  for _, Content in ipairs(ItemContents or {}) do
    if self.ChooseMode == "Weapon" and Content.IsEmptyWeapon == true and OldContent.IsEmptyWeapon == true then
      return Content
    end
    if self.ChooseMode == "Action" and true == Content.IsDefaultAction and true == OldContent.IsDefaultAction then
      return Content
    end
    if self.ChooseMode == "Action" then
      if Content.PoseId == OldContent.PoseId then
        return Content
      end
    elseif Content.Uuid == OldContent.Uuid then
      return Content
    end
  end
  return nil
end

function M:_IsValidChooseContent(Content)
  if not Content then
    return false
  end
  if self.ChooseMode == "Weapon" then
    return Content.IsEmptyWeapon == true or Content.Uuid ~= nil
  end
  if self.ChooseMode == "Action" then
    return true == Content.IsDefaultAction or nil ~= Content.PoseId
  end
  return Content.Uuid ~= nil
end

function M:_DelayFocusCharacterTips()
  self:AddTimer(0.001, function()
    if not self.IsCharacterTipsOpened or not self.WBP_PersonalInfo_Edit_Tips then
      return
    end
    local TipsWidget = self.WBP_PersonalInfo_Edit_Tips
    if TipsWidget.SetFocus then
      TipsWidget:SetFocus()
    end
    if TipsWidget.FocuesFirstItem then
      TipsWidget:FocuesFirstItem()
      return
    end
    local CandidateWidgets = {
      TipsWidget.ModType01,
      TipsWidget.ModType02,
      TipsWidget.ModType03,
      TipsWidget.FashionType01,
      TipsWidget.FashionType02,
      TipsWidget.FashionType03,
      TipsWidget.Btn_Confirm and TipsWidget.Btn_Confirm.Button_Area or nil
    }
    for _, Candidate in ipairs(CandidateWidgets) do
      if Candidate and Candidate.SetFocus then
        Candidate:SetFocus()
        return
      end
      if Candidate and Candidate.Btn_Check and Candidate.Btn_Check.SetFocus then
        Candidate.Btn_Check:SetFocus()
        return
      end
    end
  end, false, 0, "DelayFocusCharacterTips", true)
end

function M:_InitCharacterTips()
  if self.CharacterTipsInitialized or not self.WBP_PersonalInfo_Edit_Tips then
    return
  end
  self.WBP_PersonalInfo_Edit_Tips:SetComfirmCallball(self.OnCharacterTipsConfirmClicked, self)
  if self.WBP_PersonalInfo_Edit_Tips.SetOnCloseByGamepadCallback then
    self.WBP_PersonalInfo_Edit_Tips:SetOnCloseByGamepadCallback(self._OnCharacterTipsCloseByGamepad, self)
  end
  if self.WBP_PersonalInfo_Edit_Tips.SetOnAppearancePlanChangedCallback then
    self.WBP_PersonalInfo_Edit_Tips:SetOnAppearancePlanChangedCallback(self.OnCharacterTipsAppearancePlanChanged, self)
  end
  self.WBP_PersonalInfo_Edit_Tips:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.CharacterTipsInitialized = true
end

function M:_OpenCharacterTips(Content)
  if not Content then
    return
  end
  self:_RestoreSelectItemDisplay()
  self.SelectItem = Content
  local DefaultAppearancePlan, DefaultModPlan = self:_GetCharacterTipsDefaultPlans(Content)
  self.CurrentCharacterTipsContent = Content
  self.IsCharacterTipsOpened = true
  self.LastSelectedListContent = Content
  self:SetSelectedContent(Content)
  if IsValid(Content.UI) then
    Content.UI:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  end
  self:_PreviewCharacterContent(Content, DefaultAppearancePlan)
  if self.WBP_PersonalInfo_Edit_Tips then
    self.WBP_PersonalInfo_Edit_Tips:FreahCharView(Content.UnitName, Content.Rarity, DefaultAppearancePlan, DefaultModPlan, Content.Uuid)
    self.WBP_PersonalInfo_Edit_Tips:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if self.WBP_PersonalInfo_Edit_Tips.PlayAnimation and self.WBP_PersonalInfo_Edit_Tips.In then
      self.WBP_PersonalInfo_Edit_Tips:PlayAnimation(self.WBP_PersonalInfo_Edit_Tips.In)
    end
  end
  self:RefreshChoosePageClickMaskState(true)
  self.EditRootController:RefreshImageClickMaskState()
  if self:_IsChoosePageUsingGamepad() then
    self:_DelayFocusCharacterTips()
  end
end

function M:_TryCloseCharacterTips()
  if not self.IsCharacterTipsOpened then
    return false
  end
  local CanceledContent = self.CurrentCharacterTipsContent or self:GetSelectedContent()
  self:_HideCharacterTips(false)
  if self.ChooseMode == "Character" and CanceledContent and self:IsSelectedContent(CanceledContent) then
    self:ClearSelectedContent()
  end
  if self.EditRootController and self.EditRootController.CancelPendingCharacterChoosePreview then
    self.EditRootController:CancelPendingCharacterChoosePreview()
  end
  self.EditRootController:RefreshImageClickMaskState()
  self:RefreshTitle()
  self:_RestoreChooseListFocusAfterTipsClosed()
  return true
end

function M:_HideCharacterTips(bKeepPreview)
  if not self.IsCharacterTipsOpened then
    return
  end
  self.IsCharacterTipsOpened = false
  if not bKeepPreview then
    self.CurrentCharacterTipsContent = nil
  end
  local HideSelectItem = self.SelectItem
  self:_RestoreSelectItemDisplay()
  if self.LastSelectedListContent == HideSelectItem then
    self.LastSelectedListContent = nil
  end
  self.SelectItem = nil
  if self.WBP_PersonalInfo_Edit_Tips then
    if self.WBP_PersonalInfo_Edit_Tips.PlayAnimation and self.WBP_PersonalInfo_Edit_Tips.Out then
      self.WBP_PersonalInfo_Edit_Tips:PlayAnimation(self.WBP_PersonalInfo_Edit_Tips.Out)
    end
    self.WBP_PersonalInfo_Edit_Tips:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:RefreshChoosePageClickMaskState(false)
  self.EditRootController:RefreshImageClickMaskState()
end

function M:OnCharacterTipsConfirmClicked(_TipsWidget, ModIndex, AppearanceIndex)
  if not self:_ConfirmCharacterTipsSelection(ModIndex, AppearanceIndex) then
    UIManager(self):ShowUITip("CommonToastMain", GText("Unknown_Error"))
    return
  end
  self:_HideCharacterTips(false)
  if self.EditRootController and self.EditRootController._RefreshChoosePageEquippedEntryState then
    self.EditRootController:_RefreshChoosePageEquippedEntryState()
  end
  if self.EditRootController and self.EditRootController._SyncFocusedCharacterHighlight then
    self.EditRootController:_SyncFocusedCharacterHighlight()
  end
  self:_RefreshChoosePageActionButtons()
  self:_RestoreChooseListFocusAfterTipsClosed()
end

function M:_RefreshChoosePageActionButtons()
  local bIsCharacterMode = self.ChooseMode == "Character"
  local bCanConfirm = bIsCharacterMode and self.EditRootController and self.EditRootController.CanConfirmCharacterChoosePage and self.EditRootController:CanConfirmCharacterChoosePage()
  local bIsSaving = self.EditRootController and self.EditRootController.IsSavingEdit and self.EditRootController:IsSavingEdit() or false
  if self.Btn_Confirm then
    self.Btn_Confirm:SetVisibility(bIsCharacterMode and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.Collapsed)
    if self.Btn_Confirm.Text_Button then
      self.Btn_Confirm.Text_Button:SetText(GText("UI_PersonalPage_ConfirmSelect"))
    end
    if self.Btn_Confirm.ForbidBtn then
      self.Btn_Confirm:ForbidBtn(not bCanConfirm or not not bIsSaving)
    end
  end
  if self.Btn_Cancel then
    self.Btn_Cancel:SetVisibility(bIsCharacterMode and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnCharacterTipsAppearancePlanChanged(_TipsWidget, AppearanceIndex)
  if not self.CurrentCharacterTipsContent then
    return
  end
  self:_PreviewCharacterContent(self.CurrentCharacterTipsContent, AppearanceIndex)
end

function M:_ConfirmCharacterTipsSelection(ModIndex, AppearanceIndex)
  local Content = self.CurrentCharacterTipsContent or self:GetSelectedContent()
  if not Content then
    return false
  end
  local FinalAppearanceIndex = AppearanceIndex or self:_GetCurrentTipsAppearancePlan() or 1
  local _ = ModIndex
  if self.EditRootController and self.EditRootController.CommitCharacterChoosePreview then
    return self.EditRootController:CommitCharacterChoosePreview(Content.Uuid, FinalAppearanceIndex)
  end
  return false
end

function M:_PreviewCharacterContent(Content, AppearanceIndex)
  if not (Content and self.EditRootController) or not self.EditRootController.PreviewCharacterChooseSelection then
    return
  end
  self.EditRootController:PreviewCharacterChooseSelection(Content.Uuid, AppearanceIndex or 1)
end

function M:_IsContentEquipped(Content)
  if not Content then
    return false
  end
  if self.ChooseMode == "Character" then
    return self:IsCharacterContentEquipped(Content)
  end
  if self.ChooseMode == "Weapon" then
    return self:IsWeaponContentEquipped(Content)
  end
  if self.ChooseMode == "Action" then
    return self:IsActionContentEquipped(Content)
  end
  return false
end

function M:_CanShowContentMinus(Content)
  if self.ChooseMode ~= "Character" or not Content then
    return false
  end
  return self:CanShowCharacterMinus(Content)
end

function M:_GetChooseEntryWidget(Content)
  if not Content then
    return nil
  end
  local ListView = self.TileView_Select_Role
  if ListView and ListView.GetIndexForItem then
    local ItemIndex = ListView:GetIndexForItem(Content)
    if nil ~= ItemIndex and ItemIndex >= 0 then
      local EntryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(ListView, ItemIndex)
      if self:_IsChooseEntryWidgetBoundToContent(EntryWidget, Content) then
        Content.UI = EntryWidget
        Content.Widget = EntryWidget
        Content.SelfWidget = EntryWidget
        return EntryWidget
      end
    end
  end
  if self:_IsChooseEntryWidgetBoundToContent(Content.UI, Content) then
    return Content.UI
  end
  Content.UI = nil
  if self:_IsChooseEntryWidgetBoundToContent(Content.Widget, Content) then
    return Content.Widget
  end
  Content.Widget = nil
  if self:_IsChooseEntryWidgetBoundToContent(Content.SelfWidget, Content) then
    return Content.SelfWidget
  end
  Content.SelfWidget = nil
  return nil
end

function M:_IsChooseEntryWidgetBoundToContent(EntryWidget, Content)
  return IsValid(EntryWidget) and EntryWidget.Content == Content
end

function M:_GetCharacterTipsDefaultPlans(Content)
  local Slot = self.EditRootController and self.EditRootController.GetSelectedCharacterSlot and self.EditRootController:GetSelectedCharacterSlot() or nil
  local SlotCharData = Slot and Slot.CharData or nil
  local AppearancePlan = 1
  local ModPlan = 1
  if SlotCharData and Content and SlotCharData.Uuid == Content.Uuid then
    local Appearance = Slot.Appearance or nil
    if Appearance and Appearance.CurrentPlanIndex and Appearance.CurrentPlanIndex > 0 then
      AppearancePlan = Appearance.CurrentPlanIndex
    end
  end
  return AppearancePlan, ModPlan
end

function M:_GetCurrentTipsAppearancePlan()
  if self.WBP_PersonalInfo_Edit_Tips and self.WBP_PersonalInfo_Edit_Tips.SelectAppearanceIndex then
    return self.WBP_PersonalInfo_Edit_Tips.SelectAppearanceIndex
  end
  return nil
end

function M:_OnCharacterTipsCloseByGamepad()
  self:_TryCloseCharacterTips()
end

function M:GetDesiredFocusTarget()
  if self.IsCharacterTipsOpened and self.WBP_PersonalInfo_Edit_Tips then
    return self.WBP_PersonalInfo_Edit_Tips
  end
  if self.TileView_Select_Role and #self.FilteredContents > 0 then
    return self.TileView_Select_Role
  end
  if self.EMListView_Filter and #self.Filters > 0 then
    return self.EMListView_Filter
  end
  return self
end

function M:FocusGamepadDefaultListItem()
  if self.IsCharacterTipsOpened and self.WBP_PersonalInfo_Edit_Tips then
    if self.WBP_PersonalInfo_Edit_Tips.FocuesFirstItem then
      self.WBP_PersonalInfo_Edit_Tips:FocuesFirstItem()
    else
      self.WBP_PersonalInfo_Edit_Tips:SetFocus()
    end
    return
  end
  local DefaultContent
  for _, Content in ipairs(self.FilteredContents or {}) do
    if self:_IsValidChooseContent(Content) then
      DefaultContent = Content
      break
    end
  end
  if DefaultContent then
    if self.TileView_Select_Role then
      self.TileView_Select_Role:BP_NavigateToItem(DefaultContent)
      self.TileView_Select_Role:SetFocus()
    end
    local EntryWidget = self:_GetChooseEntryWidget(DefaultContent)
    if EntryWidget and EntryWidget.SetFocus then
      EntryWidget:SetFocus()
      return
    end
    return
  end
  if self.TileView_Select_Role and #self.FilteredContents > 0 then
    self.TileView_Select_Role:SetFocus()
    return
  end
  if self.EMListView_Filter and #self.Filters > 0 then
    self.EMListView_Filter:SetFocus()
    return
  end
  self:SetFocus()
end

function M:OnSortListAddedToFocusPath()
  if self.RefreshChoosePageGamepadState then
    self:RefreshChoosePageGamepadState()
  elseif self.Common_Sort_List and self.Common_Sort_List.SetControllerKeyHidden then
    self.Common_Sort_List:SetControllerKeyHidden(not self:_IsChoosePageUsingGamepad())
  end
  if self.EMListView_Filter and UIUtils.HasAnyFocus(self.EMListView_Filter) then
    self.LastFocusList = self.EMListView_Filter
    return
  end
  self.LastFocusList = self.TileView_Select_Role
end

function M:OnSortListRemovedFromFocusPath()
  if self.RefreshChoosePageGamepadState then
    self:RefreshChoosePageGamepadState()
  end
end

function M:OnSortListWidgetBack()
  if self.LastFocusList and self.LastFocusList.SetFocus then
    return self.LastFocusList
  end
  if self.TileView_Select_Role then
    return self.TileView_Select_Role
  end
  return self.EMListView_Filter
end

function M:RefreshChoosePageClickMaskState(bVisible)
  local Visibility = bVisible and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.Collapsed
  self.Image_Click:SetVisibility(Visibility)
  if self.Image_Click_1 then
    self.Image_Click_1:SetVisibility(Visibility)
  end
end

function M:_GetSortParentWidget()
  return self.EditRootController.OwnerWidget
end

function M:_CloneArray(InArray)
  local OutArray = {}
  for _, Value in ipairs(InArray or {}) do
    OutArray[#OutArray + 1] = Value
  end
  return OutArray
end

function M:_RestoreSelectItemDisplay()
  if self.SelectItem and IsValid(self.SelectItem.UI) then
    self.SelectItem.UI:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  self:RefreshEntryVisual(self.SelectItem)
end

function M:_RestoreChooseListFocusAfterTipsClosed()
  if not self:_IsChoosePageUsingGamepad() then
    return
  end
  local FocusContent = self.LastSelectedListContent or self:GetSelectedContent()
  if not FocusContent then
    if self.ChooseMode == "Character" then
      if self.TileView_Select_Role then
        self.TileView_Select_Role:SetFocus()
        return
      end
      self:SetFocus()
      return
    end
    self:FocusGamepadDefaultListItem()
    return
  end
  if self.TileView_Select_Role then
    self.TileView_Select_Role:BP_SetSelectedItem(FocusContent)
    self.TileView_Select_Role:BP_NavigateToItem(FocusContent)
  end
  local EntryWidget = self:_GetChooseEntryWidget(FocusContent)
  if EntryWidget and EntryWidget.SetFocus then
    EntryWidget:SetFocus()
    return
  end
  if self.TileView_Select_Role then
    self.TileView_Select_Role:SetFocus()
    return
  end
  self:SetFocus()
end

function M:_IsChoosePageUsingGamepad()
  if self.CurInputDeviceType ~= nil then
    return self.CurInputDeviceType == ECommonInputType.Gamepad
  end
  local RootOwner = self.EditRootController and self.EditRootController.OwnerWidget or nil
  return nil ~= RootOwner and RootOwner.CurInputDeviceType == ECommonInputType.Gamepad
end

function M:_SetChooseEntrySelected(Content, bSelected)
  if not Content then
    return
  end
  Content.IsSelect = true == bSelected
  Content.IsSelected = true == bSelected
  local bHasValidEntry = false
  if IsValid(Content.Widget) then
    Content.Widget:SetSelected(true == bSelected)
    bHasValidEntry = true
  else
    Content.Widget = nil
  end
  if IsValid(Content.SelfWidget) and Content.SelfWidget ~= Content.Widget then
    Content.SelfWidget:SetSelected(true == bSelected)
    bHasValidEntry = true
  else
    Content.SelfWidget = Content.Widget
  end
  if IsValid(Content.UI) and Content.UI ~= Content.Widget and Content.UI ~= Content.SelfWidget then
    Content.UI:SetSelected(true == bSelected)
    bHasValidEntry = true
  elseif not IsValid(Content.UI) then
    Content.UI = Content.Widget or Content.SelfWidget
  end
  if not bHasValidEntry then
    Content.UI = nil
    Content.Widget = nil
    Content.SelfWidget = nil
  end
end

function M:_IsChoosePageGamepadInput()
  if self.CurInputDeviceType ~= nil then
    return self.CurInputDeviceType == ECommonInputType.Gamepad
  end
  local RootOwner = self.EditRootController and self.EditRootController.OwnerWidget or nil
  if RootOwner and RootOwner.CurInputDeviceType ~= nil then
    return RootOwner.CurInputDeviceType == ECommonInputType.Gamepad
  end
  return false
end

AssembleComponents(M)
return M
