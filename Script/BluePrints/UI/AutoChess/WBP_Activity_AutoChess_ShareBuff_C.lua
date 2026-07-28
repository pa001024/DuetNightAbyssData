require("UnLua")
local UIUtils = require("Utils.UIUtils")
local Model = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local table_insert = table.insert
local table_sort = table.sort
local GText = _ENV.GText
local LIST_LEVEL_NAV_DIRECTIONS = {
  UE4.EUINavigation.Up,
  UE4.EUINavigation.Down,
  UE4.EUINavigation.Left,
  UE4.EUINavigation.Right
}
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Initialize()
  self.Super.Initialize(self)
  self.SelectedBuffList = {}
  self.InitialSelectedBuffList = {}
  self.bSkipConfirmSave = false
  self.bShowTitleTips = true
  self.ShareSquadIdx = nil
  self.LastSelectedItemIndex = nil
end

function M:OnLoaded(InitParams, ShareSquadIdx, OnSaveCallback)
  InitParams = InitParams or {}
  self.bSkipConfirmSave = InitParams and InitParams.bSkipConfirmSave or false
  self.bShowTitleTips = InitParams and InitParams.bShowTitleTips ~= false
  self.ShareSquadIdx = ShareSquadIdx
  self.OnSaveCallback = OnSaveCallback
  self:BindEvents()
  self:Init()
end

function M:Destruct()
  self:UnBindEvents()
  self.SelectedBuffList = {}
  self:ResetListLevelGamepadState()
end

function M:ResetListLevelGamepadState()
  self.bListLevelGamepadFocused = false
  self.ListLevelSelectedIndex = 0
  self.ListLevelAnalogDir = 0
end

function M:Init()
  self:InitSelectedBuffList()
  self:SnapshotInitialSelectedBuffs()
  self:RefreshBuffList()
  self:RefreshChosenBuffPanels()
  self:RefreshItemDetailPanel()
  self:InitWidgetTexts()
  self:PlayInAnim()
  self:ResetListLevelGamepadState()
  self:InitGamePad()
  self:RefreshOpInfoByInputDevice()
  self:FocusListBuff()
end

function M:InitSelectedBuffList()
  self.SelectedBuffList = {}
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.AutoChess then
    return
  end
  if self.ShareSquadIdx then
    local Squad = Avatar.AutoChess.SharedSquads and Avatar.AutoChess.SharedSquads[self.ShareSquadIdx]
    if Squad and Squad.Buffs then
      for _, Id in ipairs(Squad.Buffs) do
        if Model:IsFieldBuff(Id) then
          table_insert(self.SelectedBuffList, Id)
        end
      end
    end
  else
    local ChallengeBuffs = Avatar.AutoChess.ChallengeBuffs
    for ChallengeBuffId, _ in pairs(ChallengeBuffs) do
      table_insert(self.SelectedBuffList, ChallengeBuffId)
    end
  end
end

function M:SnapshotInitialSelectedBuffs()
  self.InitialSelectedBuffList = {}
  for _, Id in ipairs(self.SelectedBuffList) do
    table_insert(self.InitialSelectedBuffList, Id)
  end
end

function M:IsSelectedBuffChanged()
  local Initial = self.InitialSelectedBuffList or {}
  local Current = self.SelectedBuffList or {}
  if #Initial ~= #Current then
    return true
  end
  local Lookup = {}
  for _, Id in ipairs(Initial) do
    Lookup[Id] = true
  end
  for _, Id in ipairs(Current) do
    if not Lookup[Id] then
      return true
    end
  end
  return false
end

function M:InitWidgetTexts()
  local BuffPopUp = self:GetBuffPopUp()
  if not IsValid(BuffPopUp) then
    return
  end
  if BuffPopUp.TextTips then
    BuffPopUp.TextTips:SetText(GText("UI_AutoChess_ProfitImprove"))
  end
  if BuffPopUp.Button_Save and BuffPopUp.Button_Save.Text_Button then
    BuffPopUp.Button_Save.Text_Button:SetText(GText("UI_AutoChess_SaveButton"))
  end
  if BuffPopUp.TextNot then
    BuffPopUp.TextNot:SetText(GText("UI_AutoChess_BuffLock"))
  end
  if BuffPopUp.TitleTxet_Empty then
    BuffPopUp.TitleTxet_Empty:SetText(GText("UI_AutoChess_BuffEmpty"))
  end
  if BuffPopUp.TextLevel then
    BuffPopUp.TextLevel:SetText(GText("UI_AutoChess_DifficultyScore"))
  end
end

function M:GetBuffPopUp()
  return self.BuffPopUp
end

function M:BindEvents()
  local BuffPopUp = self:GetBuffPopUp()
  if IsValid(BuffPopUp) then
    if IsValid(BuffPopUp.Btn_Close) then
      BuffPopUp.Btn_Close:Init("Close", self, self.OnClickReturn)
    end
    if BuffPopUp.List_Buff then
      if BuffPopUp.List_Buff.OnCreateEmptyContent then
        BuffPopUp.List_Buff.OnCreateEmptyContent:Unbind()
        BuffPopUp.List_Buff.OnCreateEmptyContent:Bind(self, self.OnCreateBuffListEmptyContent)
      end
      if BuffPopUp.List_Buff.BP_OnItemClicked then
        BuffPopUp.List_Buff.BP_OnItemClicked:Clear()
        BuffPopUp.List_Buff.BP_OnItemClicked:Add(self, self.OnBuffListItemClicked)
      end
    end
    if BuffPopUp.Button_Reset then
      BuffPopUp.Button_Reset:UnBindEventOnClickedByObj(self)
      BuffPopUp.Button_Reset:BindEventOnClicked(self, self.OnClickButtonReset)
    end
    if BuffPopUp.Button_Save then
      BuffPopUp.Button_Save:UnBindEventOnClickedByObj(self)
      BuffPopUp.Button_Save:BindEventOnClicked(self, self.OnClickButtonSave)
    end
  end
  self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  if self.GameInputModeSubsystem then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:UnBindEvents()
  local BuffPopUp = self:GetBuffPopUp()
  if IsValid(BuffPopUp) and BuffPopUp.List_Buff then
    if BuffPopUp.List_Buff.OnCreateEmptyContent then
      BuffPopUp.List_Buff.OnCreateEmptyContent:Unbind()
    end
    if BuffPopUp.List_Buff.BP_OnItemClicked then
      BuffPopUp.List_Buff.BP_OnItemClicked:Remove(self, self.OnBuffListItemClicked)
    end
  end
  if IsValid(BuffPopUp) then
    if BuffPopUp.Button_Reset then
      BuffPopUp.Button_Reset:UnBindEventOnClickedByObj(self)
    end
    if BuffPopUp.Button_Save then
      BuffPopUp.Button_Save:UnBindEventOnClickedByObj(self)
    end
  end
  if self.GameInputModeSubsystem then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    self.GameInputModeSubsystem = nil
  end
end

function M:ShowConfirmPopup(PopupId, Callback)
  UIManager(self):ShowCommonPopupUI(PopupId, {RightCallbackFunction = Callback}, self)
end

function M:OnClickButtonReset()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_click_confirm", nil, nil)
  self:ShowConfirmPopup(100401, function()
    self:ResetSelectedBuffs()
  end)
end

function M:ResetSelectedBuffs()
  self.SelectedBuffList = {}
  self.LastSelectedItemIndex = nil
  local BuffPopUp = self:GetBuffPopUp()
  if IsValid(BuffPopUp) and BuffPopUp.List_Buff then
    for Index = 0, BuffPopUp.List_Buff:GetNumItems() - 1 do
      local Content = BuffPopUp.List_Buff:GetItemAt(Index)
      if Content and Content.Widget then
        if Content.Widget.SetSelected then
          Content.Widget:SetSelected(false, true)
        end
        if Content.Widget.SetChoose then
          Content.Widget:SetChoose(false, true)
        end
      end
    end
  end
  self:RefreshAfterSelectionChange()
end

function M:GetFinalBuffList(Squad)
  local WeatherBuffs = {}
  if Squad and Squad.Buffs then
    for _, BuffId in ipairs(Squad.Buffs) do
      if Model:IsWeatherBuff(BuffId) then
        table_insert(WeatherBuffs, BuffId)
        break
      end
    end
  end
  local FinalBuffs = {}
  for _, BuffId in ipairs(WeatherBuffs) do
    table_insert(FinalBuffs, BuffId)
  end
  for _, BuffId in ipairs(self.SelectedBuffList) do
    table_insert(FinalBuffs, BuffId)
  end
  return FinalBuffs
end

function M:OnClickButtonSave()
  if not self:CanSave() then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_click_confirm", nil, nil)
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.AutoChess then
    return
  end
  if self.ShareSquadIdx then
    local Squad = Avatar.AutoChess.SharedSquads and Avatar.AutoChess.SharedSquads[self.ShareSquadIdx]
    if not Squad then
      return
    end
    local FinalBuffs = self:GetFinalBuffList(Squad)
    if self.bSkipConfirmSave then
      local function OnSaveSuccess(Ret)
        if ErrorCode:Check(Ret) then
          self:OnSaveBuffSuccess()
          
          if self.OnSaveCallback then
            self.OnSaveCallback()
          end
        end
      end
      
      Avatar:AutoChessSetSharedSquad(OnSaveSuccess, self.ShareSquadIdx, Squad.Squad, FinalBuffs, Squad.Equips)
    else
      self:ShowConfirmPopup(100404, function()
        Avatar:AutoChessSetSharedSquad(function(Ret)
          if ErrorCode:Check(Ret) then
            self:OnSaveBuffSuccess()
            if self.OnSaveCallback then
              self.OnSaveCallback()
            end
          end
        end, self.ShareSquadIdx, Squad.Squad, FinalBuffs, Squad.Equips)
      end)
    end
  elseif self.bSkipConfirmSave then
    local function OnSetBuffSuccess(Ret)
      if ErrorCode:Check(Ret) then
        self:OnSaveBuffSuccess()
      end
    end
    
    Avatar:AutoChessSetChallengeBuff(OnSetBuffSuccess, self.SelectedBuffList)
  else
    self:ShowConfirmPopup(100404, function()
      local function OnSetBuffSuccess(Ret)
        if ErrorCode:Check(Ret) then
          self:OnSaveBuffSuccess()
        end
      end
      
      Avatar:AutoChessSetChallengeBuff(OnSetBuffSuccess, self.SelectedBuffList)
    end)
  end
end

function M:OnSaveBuffSuccess()
  self:SnapshotInitialSelectedBuffs()
  self:CheckSaveButtonState()
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_SaveSuccessful"))
  EventManager:FireEvent(EventID.OnAutoChessChallengeBuffChanged)
end

function M:OnCreateBuffListEmptyContent()
  local Obj = NewObject(UIUtils.GetCommonItemContentClass())
  Obj.IsEmpty = true
  return Obj
end

function M:PlayInAnim()
  AudioManager(self):PlayUISound(self, "event:/ui/common/sub_bar_expand", "ShareBuffPanelSfx", nil)
  if self.In then
    self:PlayAnimation(self.In)
  end
  local BuffPopUp = self:GetBuffPopUp()
  if IsValid(BuffPopUp) and BuffPopUp.In then
    BuffPopUp:PlayAnimation(BuffPopUp.In)
  end
end

function M:PlayBuffPopUpChangeAnim()
  local BuffPopUp = self:GetBuffPopUp()
  if IsValid(BuffPopUp) and BuffPopUp.Change then
    BuffPopUp:PlayAnimation(BuffPopUp.Change)
  end
end

function M:OnClickReturn()
  if self.IsClosing then
    return
  end
  self.IsClosing = true
  AudioManager(self):SetEventSoundParam(self, "ShareBuffPanelSfx", {ToEnd = 1})
  if self.Out then
    self:BindToAnimationFinished(self.Out, {
      self,
      function()
        self:Close()
      end
    })
    self:PlayAnimation(self.Out)
  end
  local BuffPopUp = self:GetBuffPopUp()
  if IsValid(BuffPopUp) and BuffPopUp.Out then
    BuffPopUp:PlayAnimation(BuffPopUp.Out)
  end
end

function M:GetKeyName(InKeyEvent)
  return UE4.UFormulaFunctionLibrary.Key_GetFName(UE4.UKismetInputLibrary.GetKey(InKeyEvent))
end

function M:HandleGamepadPreviewKey(InKeyName)
  if not UIUtils.IsGamepadInput() then
    return false
  end
  if self.bListLevelGamepadFocused then
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
      self:ExitListLevelGamepadFocus()
    elseif InKeyName == UIConst.GamePadKey.RightThumb then
      self:RemoveFocusedListLevelBuff()
    elseif InKeyName == UIConst.GamePadKey.DPadUp or InKeyName == UIConst.GamePadKey.LeftStickUp then
      self:NavigateListLevelByOffset(-1)
    elseif InKeyName == UIConst.GamePadKey.DPadDown or InKeyName == UIConst.GamePadKey.LeftStickDown then
      self:NavigateListLevelByOffset(1)
    end
    return true
  end
  if InKeyName == UIConst.GamePadKey.LeftThumb then
    return self:HasAnyBuffSelected() and self:FocusListLevelFirstItem()
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:OnClickReturn()
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonTop then
    if self:HasAnyBuffSelected() then
      self:OnClickButtonReset()
      return true
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft and self:CanSave() then
    self:OnClickButtonSave()
    return true
  end
  return false
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if self:HandleGamepadPreviewKey(self:GetKeyName(InKeyEvent)) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return M.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKeyName = self:GetKeyName(InKeyEvent)
  if "Escape" == InKeyName or "Android_Back" == InKeyName then
    self:OnClickReturn()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if self:HandleGamepadPreviewKey(InKeyName) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return M.Super.OnKeyDown(self, MyGeometry, InKeyEvent)
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  if self:HandleListLevelAnalogInput(InAnalogInputEvent) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if self:HandleTitleTextScrollInput(InAnalogInputEvent) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:GetTitleTextScrollBox()
  local BuffPopUp = self:GetBuffPopUp()
  if not IsValid(BuffPopUp) or not IsValid(BuffPopUp.EMScrollBox_TitleText) then
    return nil
  end
  return BuffPopUp.EMScrollBox_TitleText
end

function M:IsTitleTextScrollable()
  local ScrollBox = self:GetTitleTextScrollBox()
  if not ScrollBox then
    return false
  end
  return UIUtils.CheckScrollBoxCanScroll(ScrollBox)
end

function M:HandleTitleTextScrollInput(InAnalogInputEvent)
  if self.bListLevelGamepadFocused or not UIUtils.IsGamepadInput() then
    return false
  end
  if self:GetKeyName(InAnalogInputEvent) ~= UIConst.GamePadKey.RightAnalogY then
    return false
  end
  local ScrollBox = self:GetTitleTextScrollBox()
  if not ScrollBox then
    return false
  end
  UIUtils.ScrollBoxByGamepad(ScrollBox, InAnalogInputEvent)
  return true
end

function M:HandleListLevelAnalogInput(InAnalogInputEvent)
  if not self.bListLevelGamepadFocused or not UIUtils.IsGamepadInput() then
    return false
  end
  local InKeyName = self:GetKeyName(InAnalogInputEvent)
  if InKeyName ~= UIConst.GamePadKey.LeftAnalogY then
    return false
  end
  local DeltaOffset = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  local Threshold = Const and Const.JoystickThreshold or 0.5
  local Direction = 0
  if DeltaOffset <= -Threshold then
    Direction = 1
  elseif DeltaOffset >= Threshold then
    Direction = -1
  end
  if 0 == Direction then
    self.ListLevelAnalogDir = 0
    return true
  end
  if self.ListLevelAnalogDir == Direction then
    return true
  end
  self.ListLevelAnalogDir = Direction
  self:NavigateListLevelByOffset(Direction)
  return true
end

function M:RefreshBuffList()
  local BuffPopUp = self:GetBuffPopUp()
  if not IsValid(BuffPopUp) or not BuffPopUp.List_Buff then
    return
  end
  BuffPopUp.List_Buff:ClearListItems()
  BuffPopUp.List_Buff:SetVisibility(UIConst.VisibilityOp.Visible)
  local ChallengeBuffsSorted = {}
  for _, ChallengeBuff in pairs(DataMgr.ChallengeBuff) do
    if self:CheckBuffsDisplayConditions(ChallengeBuff) then
      table_insert(ChallengeBuffsSorted, ChallengeBuff)
    end
  end
  table_sort(ChallengeBuffsSorted, function(A, B)
    return (A.ChallengeBuffId or 0) < (B.ChallengeBuffId or 0)
  end)
  for _, ChallengeBuff in ipairs(ChallengeBuffsSorted) do
    if self.ShareSquadIdx and 3 ~= ChallengeBuff.BuffType then
    else
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.ChallengeBuff = ChallengeBuff
      Content.IsEmpty = false
      Content.Owner = self
      BuffPopUp.List_Buff:AddItem(Content)
    end
  end
  if BuffPopUp.List_Buff.RequestFillEmptyContent then
    BuffPopUp.List_Buff:RequestFillEmptyContent()
  end
  self.LastSelectedItemIndex = nil
end

function M:CheckBuffsDisplayConditions(ChallengeBuff)
  if not ChallengeBuff then
    return false
  end
  if not ChallengeBuff.DifficultyStar or ChallengeBuff.DifficultyStar <= 0 then
    return false
  end
  if ChallengeBuff.BuffType <= 1 then
    return false
  end
  if self.ShareSquadIdx and ChallengeBuff.BuffType <= 2 then
    return false
  end
  return true
end

function M:IsBuffSelected(ChallengeBuffId)
  for _, Id in ipairs(self.SelectedBuffList) do
    if Id == ChallengeBuffId then
      return true
    end
  end
  return false
end

function M:AddSelectedBuff(ChallengeBuffId)
  if not ChallengeBuffId or self:IsBuffSelected(ChallengeBuffId) then
    return
  end
  table_insert(self.SelectedBuffList, ChallengeBuffId)
  table_sort(self.SelectedBuffList)
end

function M:RemoveSelectedBuff(ChallengeBuffId)
  for Index, Id in ipairs(self.SelectedBuffList) do
    if Id == ChallengeBuffId then
      table.remove(self.SelectedBuffList, Index)
      return
    end
  end
end

function M:ToggleSelectedBuff(ChallengeBuffId)
  if self:IsBuffSelected(ChallengeBuffId) then
    self:RemoveSelectedBuff(ChallengeBuffId)
    return false
  end
  self:AddSelectedBuff(ChallengeBuffId)
  return true
end

function M:GetSelectedChallengeBuffs()
  local SelectedBuffs = {}
  for _, ChallengeBuffId in ipairs(self.SelectedBuffList) do
    local ChallengeBuff = DataMgr.ChallengeBuff[ChallengeBuffId]
    if not Model:IsWeatherBuff(ChallengeBuffId) then
      table_insert(SelectedBuffs, ChallengeBuff)
    end
  end
  return SelectedBuffs
end

function M:GetAutoChessRankDisplayNameByRankId(RankId)
  local RankInfo = DataMgr.AutoChessPoint and DataMgr.AutoChessPoint[RankId]
  if not RankInfo or not RankInfo.RankName then
    return ""
  end
  return GText(RankInfo.RankName)
end

function M:IsChallengeBuffLockedByRank(ChallengeBuff)
  if not ChallengeBuff then
    return false
  end
  local UnlockRankId = ChallengeBuff.UnlockRankId
  if not UnlockRankId or UnlockRankId <= 0 then
    return false
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.AutoChess then
    return true
  end
  local RankLevel = Avatar.AutoChess.RankLevel or 1
  return UnlockRankId > RankLevel
end

function M:GetChallengeBuffUnlockDescription(ChallengeBuff)
  if not ChallengeBuff then
    return ""
  end
  local RankDisplayName = self:GetAutoChessRankDisplayNameByRankId(ChallengeBuff.UnlockRankId)
  if "" == RankDisplayName then
    return ""
  end
  return string.format(GText("UI_AutoChess_BuffUnlockDes"), RankDisplayName)
end

function M:IsChallengeBuffUnlocked(ChallengeBuff)
  if not ChallengeBuff then
    return false
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.AutoChess then
    return false
  end
  if self:IsChallengeBuffLockedByRank(ChallengeBuff) then
    return false
  end
  return true
end

function M:HasAnyBuffSelected()
  return #self.SelectedBuffList > 0
end

function M:GetSelectedBuffCount()
  return #self.SelectedBuffList
end

function M:CanSave()
  return self:IsSelectedBuffChanged()
end

function M:RefreshTitleUIState()
  self:CheckResetButtonState()
  self:CheckSaveButtonState()
  self:CheckTitleTipsVisibility()
  self:RefreshActionButtonGamepadVisibility()
end

function M:CheckResetButtonState()
  local BuffPopUp = self:GetBuffPopUp()
  if not IsValid(BuffPopUp) then
    return
  end
  local bHasBuff = self:HasAnyBuffSelected()
  if BuffPopUp.Button_Reset and BuffPopUp.Button_Reset.ForbidBtn then
    BuffPopUp.Button_Reset:ForbidBtn(not bHasBuff)
  end
end

function M:CheckSaveButtonState()
  local BuffPopUp = self:GetBuffPopUp()
  if not IsValid(BuffPopUp) then
    return
  end
  if BuffPopUp.Button_Save and BuffPopUp.Button_Save.ForbidBtn then
    BuffPopUp.Button_Save:ForbidBtn(not self:CanSave())
  end
end

function M:CheckTitleTipsVisibility()
  local BuffPopUp = self:GetBuffPopUp()
  if not IsValid(BuffPopUp) then
    return
  end
  if BuffPopUp.Panel_Tip then
    BuffPopUp.Panel_Tip:SetVisibility(self.bShowTitleTips and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  local bHasBuff = self:HasAnyBuffSelected()
  if BuffPopUp.HorizontalBox_TitleTips then
    BuffPopUp.HorizontalBox_TitleTips:SetVisibility(self.bShowTitleTips and bHasBuff and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

function M:RefreshItemDetailPanel()
  self:RefreshBuffTitle()
  self:RefreshTitleScrollHintDelayed()
end

function M:RefreshChosenBuffPanels()
  self:RefreshTotalDifficultyStar()
  self:RefreshLevelList()
  self:RefreshTitleUIState()
end

function M:RefreshAfterSelectionChange()
  self:RefreshItemDetailPanel()
  self:RefreshChosenBuffPanels()
end

function M:RefreshTitleScrollHintDelayed()
  if not UIUtils.IsGamepadInput() then
    return
  end
  self:AddTimer(0.05, function()
    local BuffPopUp = self:GetBuffPopUp()
    if not IsValid(BuffPopUp) then
      return
    end
    self:SetGamepadWidgetVisibility(BuffPopUp.KeyTextDesc, not self.bListLevelGamepadFocused and self:IsTitleTextScrollable())
  end, false, 0, "RefreshTitleScrollHint")
end

function M:OnBuffListItemClicked(Item)
  if not Item or Item.IsEmpty or not Item.ChallengeBuff then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_icon_btn_click", nil, nil)
  self:PlayBuffPopUpChangeAnim()
  self:UpdateLastSelectedItemIndex(Item)
  self:RefreshBuffItemChoose(Item)
  self:RefreshAfterSelectionChange()
end

function M:UpdateLastSelectedItemIndex(Item)
  local Index = self:GetBuffItemIndex(Item)
  if nil == Index then
    return
  end
  local PreviousIndex = self.LastSelectedItemIndex
  if PreviousIndex == Index then
    return
  end
  self.LastSelectedItemIndex = Index
  if nil ~= PreviousIndex then
    self:RefreshBuffItemSelectVisualAtIndex(PreviousIndex, false)
  end
  self:RefreshBuffItemSelectVisualAtIndex(Index, true)
end

function M:IsBuffListItemSelected(Index)
  return nil ~= Index and self.LastSelectedItemIndex == Index
end

function M:GetBuffListItemContentAt(Index)
  if nil == Index then
    return nil
  end
  local BuffPopUp = self:GetBuffPopUp()
  if not IsValid(BuffPopUp) or not BuffPopUp.List_Buff then
    return nil
  end
  if Index < 0 or Index >= BuffPopUp.List_Buff:GetNumItems() then
    return nil
  end
  return BuffPopUp.List_Buff:GetItemAt(Index)
end

function M:RefreshBuffItemSelectVisualAtIndex(Index, bSelected)
  local Content = self:GetBuffListItemContentAt(Index)
  if Content and Content.Widget and Content.Widget.SetSelected then
    Content.Widget:SetSelected(bSelected)
  end
end

function M:RefreshBuffItemChoose(Item)
  if not Item or Item.IsEmpty or not Item.ChallengeBuff then
    return
  end
  local ChallengeBuff = Item.ChallengeBuff
  local ChallengeBuffId = ChallengeBuff.ChallengeBuffId
  if not ChallengeBuffId or not self:IsChallengeBuffUnlocked(ChallengeBuff) then
    return
  end
  local bChosen = self:ToggleSelectedBuff(ChallengeBuffId)
  if Item.Widget and Item.Widget.SetChoose then
    Item.Widget:SetChoose(bChosen)
  end
end

function M:GetChallengeBuffDisplayName(ChallengeBuff)
  if not ChallengeBuff or not ChallengeBuff.BuffName then
    return ""
  end
  return GText(ChallengeBuff.BuffName)
end

function M:UpdateBuffItemChooseVisualById(ChallengeBuffId, bChosen)
  local BuffPopUp = self:GetBuffPopUp()
  if not IsValid(BuffPopUp) or not BuffPopUp.List_Buff then
    return
  end
  local ChallengeBuff = DataMgr.ChallengeBuff and DataMgr.ChallengeBuff[ChallengeBuffId]
  if bChosen and ChallengeBuff and not self:IsChallengeBuffUnlocked(ChallengeBuff) then
    bChosen = false
  end
  for Index = 0, BuffPopUp.List_Buff:GetNumItems() - 1 do
    local Content = BuffPopUp.List_Buff:GetItemAt(Index)
    if Content and Content.ChallengeBuff and Content.ChallengeBuff.ChallengeBuffId == ChallengeBuffId then
      if Content.Widget and Content.Widget.SetChoose then
        Content.Widget:SetChoose(bChosen)
      end
      break
    end
  end
end

function M:OnLevelItemRemove(Content)
  if not Content or not Content.ChallengeBuffId then
    return
  end
  self:RemoveSelectedBuff(Content.ChallengeBuffId)
  self:UpdateBuffItemChooseVisualById(Content.ChallengeBuffId, false)
  self:RefreshChosenBuffPanels()
end

function M:CreateLevelListContent(ChallengeBuff)
  local LevelContent = NewObject(UIUtils.GetCommonItemContentClass())
  LevelContent.ChallengeBuffId = ChallengeBuff.ChallengeBuffId
  LevelContent.ChallengeBuff = ChallengeBuff
  LevelContent.BuffName = self:GetChallengeBuffDisplayName(ChallengeBuff)
  LevelContent.BuffDesc = ChallengeBuff.BuffDesc and GText(ChallengeBuff.BuffDesc) or ""
  LevelContent.DifficultyStar = ChallengeBuff.DifficultyStar or 0
  LevelContent.Owner = self
  return LevelContent
end

function M:RefreshLevelList()
  local BuffPopUp = self:GetBuffPopUp()
  if not IsValid(BuffPopUp) or not BuffPopUp.ListLevel then
    return
  end
  BuffPopUp.ListLevel:ClearListItems()
  if BuffPopUp.Ws_RightContent then
    BuffPopUp.Ws_RightContent:SetActiveWidgetIndex(self:HasAnyBuffSelected() and 0 or 1)
  end
  if not self:HasAnyBuffSelected() then
    if self.bListLevelGamepadFocused then
      self:ExitListLevelGamepadFocus()
    end
    return
  end
  for _, ChallengeBuff in ipairs(self:GetSelectedChallengeBuffs()) do
    BuffPopUp.ListLevel:AddItem(self:CreateLevelListContent(ChallengeBuff))
  end
  self:RefreshAllLevelItemWsBtnState()
end

function M:ForEachLevelItemWidget(Callback)
  local BuffPopUp = self:GetBuffPopUp()
  if not (IsValid(BuffPopUp) and BuffPopUp.ListLevel) or not self:HasAnyBuffSelected() then
    return
  end
  for Index = 0, self:GetSelectedBuffCount() - 1 do
    local Content = BuffPopUp.ListLevel:GetItemAt(Index)
    if Content and Content.Widget then
      Callback(Content.Widget, Content, Index)
    end
  end
end

function M:RefreshAllLevelItemWsBtnState()
  self:ForEachLevelItemWidget(function(Widget)
    if Widget.RefreshEntryGamepadState then
      Widget:RefreshEntryGamepadState()
    end
  end)
end

function M:SetTitleImageIcon(ImageWidget, IconPath)
  if not ImageWidget then
    return
  end
  if not IconPath or "" == IconPath then
    ImageWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  local IconObj = LoadObject(IconPath)
  if IconObj then
    ImageWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    ImageWidget:SetBrushResourceObject(IconObj)
  end
end

function M:RefreshBuffTitle()
  local BuffPopUp = self:GetBuffPopUp()
  if not IsValid(BuffPopUp) then
    return
  end
  local SelectedContent = self:GetBuffListItemContentAt(self.LastSelectedItemIndex)
  local ChallengeBuff = SelectedContent and SelectedContent.ChallengeBuff or nil
  if not ChallengeBuff then
    if BuffPopUp.Ws_Title then
      BuffPopUp.Ws_Title:SetActiveWidgetIndex(1)
    end
    return
  end
  if BuffPopUp.Ws_Title then
    BuffPopUp.Ws_Title:SetActiveWidgetIndex(0)
  end
  if BuffPopUp.TitleText_Name then
    BuffPopUp.TitleText_Name:SetText(self:GetChallengeBuffDisplayName(ChallengeBuff))
  end
  if BuffPopUp.TitleText_Des then
    if self:IsChallengeBuffLockedByRank(ChallengeBuff) then
      BuffPopUp.TitleText_Des:SetText(self:GetChallengeBuffUnlockDescription(ChallengeBuff))
    else
      BuffPopUp.TitleText_Des:SetText(ChallengeBuff.BuffDesc and GText(ChallengeBuff.BuffDesc) or "")
    end
  end
  if BuffPopUp.TitleImage_Icon then
    self:SetTitleImageIcon(BuffPopUp.TitleImage_Icon, ChallengeBuff.BuffIcon)
  end
  local bUnlocked = self:IsChallengeBuffUnlocked(ChallengeBuff)
  local TitleText_StarNum = BuffPopUp.TitleText_StarNum or BuffPopUp.TextStarNum_Selected
  if not bUnlocked then
    if BuffPopUp.Ws_StarState then
      BuffPopUp.Ws_StarState:SetActiveWidgetIndex(1)
    end
  elseif ChallengeBuff.DifficultyStar then
    if BuffPopUp.Ws_StarState then
      BuffPopUp.Ws_StarState:SetActiveWidgetIndex(0)
    end
    if TitleText_StarNum then
      TitleText_StarNum:SetText(tostring(ChallengeBuff.DifficultyStar))
    end
  elseif BuffPopUp.Ws_StarState then
    BuffPopUp.Ws_StarState:SetActiveWidgetIndex(1)
  end
end

function M:RefreshTotalDifficultyStar()
  local BuffPopUp = self:GetBuffPopUp()
  if not IsValid(BuffPopUp) or not BuffPopUp.TextStarNum_Total then
    return
  end
  local TotalStar = 0
  local ChallengeBuffs = DataMgr.ChallengeBuff
  for _, ChallengeBuffId in ipairs(self.SelectedBuffList) do
    local ChallengeBuff = ChallengeBuffs[ChallengeBuffId]
    if ChallengeBuff and ChallengeBuff.DifficultyStar then
      TotalStar = TotalStar + ChallengeBuff.DifficultyStar
    end
  end
  local StarBar = BuffPopUp.HB_Star_Bar
  local MaxStar = StarBar and StarBar.GetChildrenCount and StarBar:GetChildrenCount() or 0
  if StarBar and MaxStar > 0 and TotalStar <= MaxStar then
    if BuffPopUp.Ws_Star then
      BuffPopUp.Ws_Star:SetActiveWidgetIndex(1)
    end
    for Index = 0, MaxStar - 1 do
      local StarImage = StarBar:GetChildAt(Index)
      if StarImage then
        StarImage:SetVisibility(Index < TotalStar and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
      end
    end
  else
    if BuffPopUp.Ws_Star then
      BuffPopUp.Ws_Star:SetActiveWidgetIndex(0)
    end
    BuffPopUp.TextStarNum_Total:SetText("×" .. tostring(TotalStar))
  end
end

function M:InitGamePad()
  self:InitGamePadInfo()
  self:InitListBuffNavigation()
  self:InitListLevelNavigation()
end

function M:InitGamePadInfo()
  local BuffPopUp = self:GetBuffPopUp()
  if not IsValid(BuffPopUp) then
    return
  end
  local KeyConfigs = {
    {
      Widget = BuffPopUp.KeyTextDesc,
      Key = UIConst.GamePadImgKey.RightThumb,
      Desc = "UI_Controller_Slide"
    },
    {
      Widget = BuffPopUp.KeyTextDesc01,
      Key = UIConst.GamePadImgKey.RightThumb,
      Desc = "UI_CTL_Remove"
    },
    {
      Widget = BuffPopUp.KeyTextDesc02,
      Key = UIConst.GamePadImgKey.FaceButtonBottom,
      Desc = "UI_CTL_Add/Remove"
    },
    {
      Widget = BuffPopUp.KeyTextDesc03,
      Key = UIConst.GamePadImgKey.FaceButtonRight,
      Desc = "UI_BACK"
    }
  }
  for _, Config in ipairs(KeyConfigs) do
    if Config.Widget and Config.Widget.CreateCommonKey then
      Config.Widget:CreateCommonKey({
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = Config.Key
          }
        },
        Desc = GText(Config.Desc)
      })
    end
  end
  if BuffPopUp.WBP_Com_KeyImg_Title and BuffPopUp.WBP_Com_KeyImg_Title.CreateGamepadKey then
    BuffPopUp.WBP_Com_KeyImg_Title:CreateGamepadKey(UIConst.GamePadImgKey.LeftThumb)
  end
  if BuffPopUp.WBP_Com_Key_Reset and BuffPopUp.WBP_Com_Key_Reset.CreateGamepadKey then
    BuffPopUp.WBP_Com_Key_Reset:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonTop)
  end
  if BuffPopUp.Button_Save and BuffPopUp.Button_Save.SetGamePadImg then
    BuffPopUp.Button_Save:SetGamePadImg(UIConst.GamePadImgKey.FaceButtonLeft)
  end
end

function M:InitListBuffNavigation()
  local BuffPopUp = self:GetBuffPopUp()
  if not (IsValid(BuffPopUp) and BuffPopUp.List_Buff) or not BuffPopUp.List_Buff.SetNavigationRuleBase then
    return
  end
  for _, Direction in ipairs(LIST_LEVEL_NAV_DIRECTIONS) do
    BuffPopUp.List_Buff:SetNavigationRuleBase(Direction, UE4.EUINavigationRule.Stop)
  end
end

function M:InitListLevelNavigation()
  local BuffPopUp = self:GetBuffPopUp()
  if not (IsValid(BuffPopUp) and BuffPopUp.ListLevel) or not BuffPopUp.ListLevel.SetNavigationRuleBase then
    return
  end
  for _, Direction in ipairs(LIST_LEVEL_NAV_DIRECTIONS) do
    BuffPopUp.ListLevel:SetNavigationRuleBase(Direction, UE4.EUINavigationRule.Stop)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
  if UIUtils.IsKeyboardInput() then
    self:ResetListLevelGamepadState()
    self:ShowOrHideGamePad(false)
  elseif UIUtils.IsGamepadInput() then
    self:ShowOrHideGamePad(true)
  end
  self:RefreshAllLevelItemWsBtnState()
end

function M:GetDesiredFocusTarget()
  local BuffPopUp = self:GetBuffPopUp()
  if not IsValid(BuffPopUp) then
    return nil
  end
  return BuffPopUp.List_Buff
end

function M:SetFocus_Lua()
  self:FocusListBuff()
end

function M:FocusListBuff()
  local BuffPopUp = self:GetBuffPopUp()
  if not (IsValid(BuffPopUp) and BuffPopUp.List_Buff) or 0 == BuffPopUp.List_Buff:GetNumItems() then
    return
  end
  BuffPopUp.List_Buff:SetFocus()
end

function M:GetBuffItemIndex(Content)
  if not Content then
    return nil
  end
  local BuffPopUp = self:GetBuffPopUp()
  if not IsValid(BuffPopUp) or not BuffPopUp.List_Buff then
    return nil
  end
  for Index = 0, BuffPopUp.List_Buff:GetNumItems() - 1 do
    if BuffPopUp.List_Buff:GetItemAt(Index) == Content then
      return Index
    end
  end
  return nil
end

function M:OnShow(ShowTag)
  M.Super.OnShow(self, ShowTag)
  if not UIUtils.IsGamepadInput() then
    return
  end
  if self.bListLevelGamepadFocused then
    return
  end
  self:FocusListBuff()
end

function M:GetListLevelSelectedContent()
  local BuffPopUp = self:GetBuffPopUp()
  if not (IsValid(BuffPopUp) and BuffPopUp.ListLevel) or not self:HasAnyBuffSelected() then
    return nil
  end
  return BuffPopUp.ListLevel:GetItemAt(self:GetListLevelSelectedIndex())
end

function M:RemoveFocusedListLevelBuff()
  if not self.bListLevelGamepadFocused then
    return false
  end
  local Content = self:GetListLevelSelectedContent()
  if not Content or not Content.ChallengeBuffId then
    return false
  end
  local RemovedIndex = self:GetListLevelSelectedIndex()
  self:OnLevelItemRemove(Content)
  if self.bListLevelGamepadFocused and self:HasAnyBuffSelected() then
    self:SelectListLevelIndex(math.min(RemovedIndex, self:GetSelectedBuffCount() - 1))
  end
  return true
end

function M:GetListLevelSelectedIndex()
  return self.ListLevelSelectedIndex or 0
end

function M:SelectListLevelIndex(Index)
  local BuffPopUp = self:GetBuffPopUp()
  if not (IsValid(BuffPopUp) and BuffPopUp.ListLevel) or not self:HasAnyBuffSelected() then
    return false
  end
  local NumItems = self:GetSelectedBuffCount()
  if Index < 0 or Index >= NumItems then
    return false
  end
  self.ListLevelSelectedIndex = Index
  local ListLevel = BuffPopUp.ListLevel
  if ListLevel.SetSelectedIndex then
    ListLevel:SetSelectedIndex(Index)
  end
  ListLevel:NavigateToIndex(Index)
  ListLevel:SetFocus()
  self:RefreshAllLevelItemWsBtnState()
  return true
end

function M:NavigateListLevelByOffset(Offset)
  if not self:HasAnyBuffSelected() then
    return
  end
  local NewIndex = self:GetListLevelSelectedIndex() + Offset
  if NewIndex < 0 or NewIndex >= self:GetSelectedBuffCount() then
    return
  end
  self:SelectListLevelIndex(NewIndex)
end

function M:FocusListLevelFirstItem(bEnterMode)
  if nil == bEnterMode then
    bEnterMode = true
  end
  local BuffPopUp = self:GetBuffPopUp()
  if not (IsValid(BuffPopUp) and BuffPopUp.ListLevel) or not self:HasAnyBuffSelected() then
    return false
  end
  if bEnterMode then
    self.bListLevelGamepadFocused = true
  end
  self.ListLevelAnalogDir = 0
  self:SelectListLevelIndex(0)
  self:RefreshListLevelGamepadUI()
  return true
end

function M:ExitListLevelGamepadFocus()
  if not self.bListLevelGamepadFocused then
    return
  end
  self.bListLevelGamepadFocused = false
  self.ListLevelSelectedIndex = 0
  self.ListLevelAnalogDir = 0
  self:RefreshListLevelGamepadUI()
  self:FocusListBuff()
end

function M:RefreshListLevelGamepadUI()
  self:RefreshGamepadKeyHintVisibility()
  self:RefreshAllLevelItemWsBtnState()
end

function M:SetGamepadWidgetVisibility(Widget, bShow)
  if Widget then
    Widget:SetVisibility(bShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

function M:SetButtonGamepadIconVisibility(Button, bShow)
  if not IsValid(Button) then
    return
  end
  if bShow and Button.RefreshGamepadKeyVisibility then
    Button:RefreshGamepadKeyVisibility()
  elseif Button.SetGamePadVisibility then
    Button:SetGamePadVisibility(bShow and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.Collapsed)
  elseif Button.Key_GamePad then
    self:SetGamepadWidgetVisibility(Button.Key_GamePad, bShow)
  end
end

function M:RefreshActionButtonGamepadVisibility()
  local BuffPopUp = self:GetBuffPopUp()
  if not IsValid(BuffPopUp) then
    return
  end
  local bShowActionKeys = UIUtils.IsGamepadInput() and not self.bListLevelGamepadFocused
  if BuffPopUp.WBP_Com_Key_Reset then
    self:SetGamepadWidgetVisibility(BuffPopUp.WBP_Com_Key_Reset, bShowActionKeys and self:HasAnyBuffSelected())
  end
  if BuffPopUp.Button_Reset then
    self:SetButtonGamepadIconVisibility(BuffPopUp.Button_Reset, bShowActionKeys)
  end
  if BuffPopUp.Button_Save then
    self:SetButtonGamepadIconVisibility(BuffPopUp.Button_Save, bShowActionKeys and self:CanSave())
  end
end

function M:RefreshGamepadKeyHintVisibility()
  local BuffPopUp = self:GetBuffPopUp()
  if not IsValid(BuffPopUp) then
    return
  end
  local bListLevelFocused = self.bListLevelGamepadFocused
  self:SetGamepadWidgetVisibility(BuffPopUp.KeyTextDesc, not bListLevelFocused and self:IsTitleTextScrollable())
  self:SetGamepadWidgetVisibility(BuffPopUp.KeyTextDesc01, bListLevelFocused)
  self:SetGamepadWidgetVisibility(BuffPopUp.KeyTextDesc02, not bListLevelFocused)
  self:RefreshActionButtonGamepadVisibility()
end

function M:ShowOrHideGamePad(bShow)
  local BuffPopUp = self:GetBuffPopUp()
  if not IsValid(BuffPopUp) then
    return
  end
  self:SetGamepadWidgetVisibility(BuffPopUp.Panel_Key, bShow)
  self:SetGamepadWidgetVisibility(BuffPopUp.WBP_Com_KeyImg_Title, bShow)
  self:SetGamepadWidgetVisibility(BuffPopUp.KeyTextDesc03, bShow)
  if bShow then
    self:RefreshGamepadKeyHintVisibility()
  else
    self:SetGamepadWidgetVisibility(BuffPopUp.KeyTextDesc, false)
    self:SetGamepadWidgetVisibility(BuffPopUp.KeyTextDesc01, false)
    self:SetGamepadWidgetVisibility(BuffPopUp.KeyTextDesc02, false)
    self:SetGamepadWidgetVisibility(BuffPopUp.WBP_Com_Key_Reset, false)
    self:SetButtonGamepadIconVisibility(BuffPopUp.Button_Reset, false)
    self:SetButtonGamepadIconVisibility(BuffPopUp.Button_Save, false)
  end
end

return M
