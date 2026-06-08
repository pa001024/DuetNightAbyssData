require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local AppearanceUtils = require("BluePrints.UI.WBP.Appearance.AppearanceUtils")
local FSM = require("Blueprints.UI.FocusStateMachine")
local AppearanceRankModel = require("BluePrints.UI.WBP.Appearance.AppearanceRankModel")
local AppearanceShareModel = require("BluePrints.UI.WBP.Appearance.AppearanceShareModel")
local M = Class({
  "BluePrints.UI.WBP.Appearance.WBP_Appearance_MainWidget_Base_C"
})
M._components = {
  "BluePrints.UI.WBP.Appearance.Widget.AppearanceCharExpandListComponent",
  "BluePrints.UI.KeyInputComponent"
}
local FocusStates = {
  List = "List",
  AppearancePanel = "AppearancePanel",
  Plan = "Plan",
  SpecialBtns = "SpecialBtns"
}

function M:Construct()
  M.Super.Construct(self)
  self.AssociatedList = self.List_Avatar
  self.WidgetToHideWhenExpandList = {
    self.Panel_List,
    self.Panel_Selective,
    self.List_Appearance,
    self.Selective_Listing,
    self.Plan_Appearance,
    self.WidgetSwitcher_MP
  }
  self.Key_Entrance:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Menu"}
    },
    SkipRefreshInputType = true
  })
  self:AddDispatcher(EventID.OnCharAppearanceChanged, self, self.OnCharAppearanceChanged)
  self:AddDispatcher(EventID.OnCharAppearanSuitRenamed, self, self.OnCharAppearanSuitRenamed)
  rawset(self, "FSM", FSM:New(self, {
    StateNames = FocusStates,
    OnStateChanged = self.OnFocusChanged,
    CheckFunction = self.IsFocusStateValid
  }))
  self:InitNavigationRules()
end

function M:Destruct()
  self:RemoveCharListReddotListen()
  self:RemoveArchiveReddotListen()
end

function M:Init(Params)
  self.Parent = Params.Parent
  self.Type = CommonConst.ArmoryType.Char
  self.MainModel = self.Parent.MainModel
  self.ActorController = self.Parent.ActorController
  self.bFirstInit = true
  self:InitCharList()
  self:InitEntranceBtn()
  self:OnSelectedCharContentChanged()
end

function M:OnSelectedCharContentChanged()
  self:UpdateRightBottomInfo()
  self:InitCharAppearanceSuits()
  self:UpdateAppearancePlan()
  self.ActorController:ChangeCharModel(self.MainModel:GetSelectedChar())
  self.List_Avatar:BP_ScrollItemIntoView(self.MainModel:GetSelectedCharContent())
end

function M:InitCharAppearanceSuits()
  self.List_Appearance:Init(self.MainModel, {
    OnCloseCallback = function()
      self:InitCharAppearanceSuits()
      self.ActorController:ResetActorRotation()
      self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char, nil, CommonConst.ArmoryTag.Appearance)
    end,
    Parent = self.Parent,
    IsCharacterTrialMode = self.IsCharacterTrialMode,
    IsTargetUnowned = not self.MainModel:IsSelectedCharOwned(),
    OnAddedToFocusPath = function()
      self:OnAppearancePanelAddedToFocusPath()
    end
  })
end

function M:UpdateAppearancePlan()
  if self.IsPreviewMode then
    self.Plan_Appearance:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  self.Plan_Appearance:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Plan_Appearance:Init({
    Owner = self,
    OnEditBtnClicked = self.OnAppearanceNameEditBtnClicked,
    OnPlanChanged = self.OnSuitsItemClicked,
    OnBuildCommunityCode = self.BuildCurrentAppearanceCommunityCode,
    PlanNames = self.PlanNames,
    SelectedItemIndex = self.SelectedItemIndex,
    BtnStyle = 1,
    BtnListParams = {
      {
        Text = GText("UI_Armory_Share_Chat"),
        Func = self.OnCopyChatLinkClicked
      },
      {
        Text = GText("UI_Armory_Share_Community"),
        Func = self.OnCopyCommunityCodeClicked
      },
      {
        Text = GText("UI_AppearanceScore_Import"),
        Func = self.OnImportAppearanceCodeClicked
      },
      {
        Text = GText("UI_AppearanceScore_ChangePlan"),
        Func = self.OnAppearanceNameEditBtnClicked
      }
    },
    OnAddedToFocusPath = function()
      self:OnPlanAddedToFocusPath()
    end,
    OnGetBackReply = function()
      self.FSM:Pop()
      return UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), self:GetDesiredFocusTarget())
    end
  })
  if self.IsPreviewMode or not self.MainModel:IsSelectedCharOwned() then
    self.Plan_Appearance:SetVisibility(UIConst.VisibilityOp.Hidden)
  else
    self.Plan_Appearance:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:ResetAppearancePlanName()
  end
end

function M:BuildCurrentAppearancePlanShareInfo()
  local Char = self.MainModel:GetSelectedChar()
  local AppearanceIndex = self.MainModel:GetSelectedCharAppearanceIndex()
  local AppearanceSuit = Char and Char.AppearanceSuits and Char.AppearanceSuits[AppearanceIndex]
  if not Char or not AppearanceSuit then
    return nil
  end
  local CharData = DataMgr.Char[Char.CharId]
  local TargetName = CharData and GText(CharData.CharName) or ""
  local PlanNames = self:GetAppearancePlanNames()
  local PlanName = PlanNames[AppearanceIndex] or ""
  local AppearanceInfo = Char:DumpAppearanceSuit(GWorld:GetAvatar(), AppearanceIndex)
  if not AppearanceInfo then
    return nil
  end
  local Avatar = GWorld:GetAvatar()
  local SharerInfo = {
    Nickname = Avatar and Avatar.Nickname or "",
    Level = Avatar and Avatar.Level or 0,
    HeadIconId = Avatar and Avatar.HeadIconId or 0,
    HeadFrameId = Avatar and Avatar.HeadFrameId or 0,
    TitleBefore = Avatar and Avatar.TitleBefore or nil,
    TitleAfter = Avatar and Avatar.TitleAfter or nil,
    TitleFrame = Avatar and Avatar.TitleFrame or nil
  }
  return {
    Version = 1,
    ShareType = "CharAppearancePlan",
    TargetType = "Char",
    TargetId = Char.CharId,
    TargetName = TargetName,
    PlanIndex = AppearanceIndex,
    PlanName = PlanName,
    DisplayText = string.format("%s - %s", TargetName, PlanName),
    AppearanceInfo = AppearanceInfo,
    SharerInfo = SharerInfo
  }
end

function M:OnCopyChatLinkClicked()
  local AppearancePlanInfo = self:BuildCurrentAppearancePlanShareInfo()
  if not AppearancePlanInfo then
    return
  end
  AppearanceShareModel.CacheAppearancePlanInfoCopied(AppearancePlanInfo)
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Mod_Toast_CopyedSuit"))
end

function M:BuildCurrentAppearanceCommunityCode()
  local AppearancePlanInfo = self:BuildCurrentAppearancePlanShareInfo()
  if not AppearancePlanInfo then
    return ""
  end
  return AppearanceShareModel.GenerateAppearanceCommunityCode(AppearancePlanInfo)
end

function M:OnCopyCommunityCodeClicked()
  local CommunityCode = self:BuildCurrentAppearanceCommunityCode()
  if "" == CommunityCode then
    return
  end
  ULowEntryExtendedStandardLibrary.ClipboardSet(CommunityCode)
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Mod_Toast_CopyedSuit"))
end

function M:TryOpenAppearanceImportByShareText(ShareText)
  local AppearancePlanInfo = AppearanceShareModel.ParseAppearanceShareMsg(ShareText)
  if not AppearancePlanInfo then
    local CachedInfo = AppearanceShareModel.GetAppearancePlanInfoCopied()
    if not CachedInfo or CachedInfo.MsgCopyed ~= ShareText then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Dye_Input_Invaluable"))
      return false
    end
    AppearancePlanInfo = CachedInfo.AppearancePlanInfo
  end
  AppearanceShareModel.OpenAppearanceImport(self, AppearancePlanInfo, {
    Parent = self.Parent or self,
    CharUuid = self.MainModel and self.MainModel:GetSelectedChar() and self.MainModel:GetSelectedChar().Uuid or nil,
    AppearanceIndex = self.MainModel and self.MainModel:GetSelectedCharAppearanceIndex() or 1,
    SourceText = ShareText,
    OnCloseCallback = function()
      self:RefreshAfterAppearanceImport()
    end
  })
  return true
end

function M:OnImportAppearanceCodeClicked()
  local Params = {}
  Params.TextLenMax = 1024
  Params.MultilineType = 1
  Params.HintText = GText("UI_Dye_Input_Content")
  Params.UseGenaral = true
  
  function Params.RightCallbackFunction(_, Data, PopupUI)
    local ShareText = Data and Data.ComDialogInput and Data.ComDialogInput.Text or ""
    local IsOpened = self:TryOpenAppearanceImportByShareText(ShareText)
    if IsOpened and PopupUI and PopupUI.Close then
      PopupUI:Close()
    end
  end
  
  UIManager(self):ShowCommonPopupUI(100232, Params, self)
end

function M:OnTabChangeToOther()
  self:PlayOutAnim()
end

function M:UpdateMontage()
  self.ActorController:ResetActorRotation()
  self.ActorController.bPlaySameMontage = true
  self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char, nil, CommonConst.ArmoryTag.Appearance)
end

function M:OnTabChangeToSelf(JumpParams)
  self.FSM:Clear()
  self:PlayInAnim()
  if self.bFirstInit then
    self.bFirstInit = false
    self.ActorController:HidePlayerActor(self.ActorController.UIName, true)
    self:AddTimer(0.03, function()
      self.ActorController:HidePlayerActor(self.ActorController.UIName, false)
      self:UpdateMontage()
    end, false, 0, "FirstInitActor")
  else
    self:UpdateMontage()
  end
  self:OnFocusChanged()
end

function M:JumpLogic(JumpParams)
  if JumpParams and next(JumpParams) then
    self.List_Appearance:JumpLogic(JumpParams)
  end
end

function M:OnClose()
  self:PlayOutAnim()
end

function M:PlayInAnim()
  self:StopAnimation(self.Out)
  self:PlayAnimation(self.In)
end

function M:PlayOutAnim()
  self:StopAnimation(self.In)
  self:PlayAnimation(self.Out)
end

function M:UpdateRightBottomInfo()
  local Data = DataMgr.Char[self.MainModel:GetSelectedChar().CharId]
  if not Data then
    return
  end
  local Path = "/Game/UI/Texture/Dynamic/Image/Head/Mini/T_Normal_Mini_" .. Data.GUIPathVariable
  self.Icon_Avatar:SetBrushResourceObject(LoadObject(Path))
  self.Text_Avatar:SetText(GText(Data.CharName))
end

function M:GetAppearancePlanNames()
  local AppearanceNames = {}
  for index, value in ipairs(self.MainModel:GetSelectedChar().AppearanceSuits) do
    local Name = value.AppearanceName
    if not Name or "" == Name then
      Name = "UI_Squad_Appearance_TITLE" .. index
    end
    local AppearanceText = GText(Name)
    table.insert(AppearanceNames, AppearanceText)
  end
  return AppearanceNames
end

function M:ResetAppearancePlanName()
  local AppearanceNames = self:GetAppearancePlanNames()
  self.Plan_Appearance:UpdatePlanNames(AppearanceNames, self.MainModel:GetSelectedCharAppearanceIndex())
end

function M:OnSuitsItemClicked(Index)
  self.Parent:BlockAllUIInput(true)
  local Avatar = GWorld:GetAvatar()
  Avatar:SwitchCurrentCharAppearance(self.MainModel:GetSelectedChar().Uuid, Index)
end

function M:OnAppearanceNameEditBtnClicked()
  local AppearanceNames = self:GetAppearancePlanNames()
  local Data = DataMgr.GlobalConstant.CharPlanNameMax or {ConstantValue = 14}
  self.NameEditDialog = UIManager(self):ShowCommonPopupUI(100176, {
    EditTextConfig = {
      Text = AppearanceNames[self.MainModel:GetSelectedCharAppearanceIndex()],
      IsMultiLine = false,
      Owner = self,
      TextLimit = Data.ConstantValue,
      bLimitSpaces = true,
      bNotAllowEmpty = true,
      Events = {
        OnTextChanged = function(self, Text)
          if Text == AppearanceNames[self.MainModel:GetSelectedCharAppearanceIndex()] then
            self.NameEditDialog:GetButtonBar().Btn_Yes:ForbidBtn(true)
          else
            self.NameEditDialog:GetButtonBar().Btn_Yes:ForbidBtn(false)
          end
        end
      },
      bNeedCheckStringSensitive = true,
      OnCheckStringSensitive = function(_, bSuccess, Name)
        if bSuccess then
          Name = Name or ""
          if "" ~= Name then
            local Avatar = GWorld:GetAvatar()
            Avatar:UpdateCharAppearanceSuitName(self.MainModel:GetSelectedChar().Uuid, self.MainModel:GetSelectedCharAppearanceIndex(), Name)
          else
          end
        end
      end
    }
  }, self)
end

function M:OnCharAppearanSuitRenamed(Ret, CharUuid, AppearanceIndex, NewName)
  if not ErrorCode:Check(Ret) then
    return
  end
  if CharUuid ~= self.MainModel:GetSelectedChar().Uuid then
    return
  end
  self:ResetAppearancePlanName()
end

function M:OnCharAppearanceChanged(Ret, CharUuid, AppearanceIndex)
  self.Parent:BlockAllUIInput(false)
  if not ErrorCode:Check(Ret) then
    return
  end
  local SelectedChar = self.MainModel and self.MainModel:GetSelectedChar() or nil
  if not SelectedChar then
    return
  end
  if CharUuid ~= SelectedChar.Uuid then
    return
  end
  if self.ActorController and self.ActorController.ArmoryPlayer then
    local AppearanceSuit = SelectedChar.DumpAppearanceSuit and SelectedChar:DumpAppearanceSuit(GWorld:GetAvatar(), AppearanceIndex) or nil
    if AppearanceSuit then
      self.ActorController:ChangeCharAppearance(AppearanceSuit)
      self.ActorController.DelayFrame = 30
      self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char, nil, CommonConst.ArmoryTag.Appearance)
    end
  end
  self:InitCharAppearanceSuits()
  self.List_Appearance:PlayInAnim()
end

function M:RefreshAfterAppearanceImport()
  local SelectedChar = self.MainModel and self.MainModel:GetSelectedChar() or nil
  if not SelectedChar then
    return
  end
  local AppearanceIndex = self.MainModel:GetSelectedCharAppearanceIndex()
  if self.ActorController and self.ActorController.ArmoryPlayer then
    local AppearanceSuit = SelectedChar.DumpAppearanceSuit and SelectedChar:DumpAppearanceSuit(GWorld:GetAvatar(), AppearanceIndex) or nil
    if AppearanceSuit then
      self.ActorController:ChangeCharAppearance(AppearanceSuit)
      self.ActorController.DelayFrame = 30
      self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char, nil, CommonConst.ArmoryTag.Appearance)
    end
  end
  self:InitCharAppearanceSuits()
end

function M:OnListItemClicked(Content)
  if Content == self.MainModel:GetSelectedCharContent() then
    if UIUtils.IsGamepadInput() and self.IsInFocusPath then
      self.List_Appearance:SetFocus()
    end
    return
  end
  self.MainModel:SetSelectedCharContent(Content)
  self:OnSelectedCharContentChanged()
  self:UpdateMontage()
end

function M:OnListItemSelectionChanged(Content, IsSelected)
  if not IsSelected then
    return
  end
  if UIUtils.IsGamepadInput() then
    self:OnListItemClicked(Content)
  end
end

function M:InitCharList()
  self.List_Avatar:ClearListItems()
  local AllCharContent = self.MainModel:GetAllCharContent()
  for index, value in ipairs(AllCharContent) do
    function value.OnAddedToFocusPath(_self, Content)
      self:OnListItemAddedToFocusPath(Content)
    end
    
    self.List_Avatar:AddItem(value)
  end
  AppearanceUtils.UpdateCharListReddot(AllCharContent)
  self:AddCharListReddotListen()
end

function M:InitEntranceBtn()
  if self.IsPreviewMode then
    self.Entrance_Archive:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Entrance_Ranking:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  self.Entrance_Archive:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Entrance_Ranking:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Entrance_Archive:Init({
    Owner = self,
    IconPath = "BP_Icon_Appearance",
    Text = GText("UI_AppearanceScore_AppIllustrated"),
    OnBtnClicked = self.OnArchiveBtnClicked,
    OnAddedToFocusPath = function()
      self:OnArchiveBtnAddedToFocusPath()
    end,
    OnRemovedFromFocusPath = function()
      self:OnArchiveBtnRemovedFromFocusPath()
    end
  })
  self.Entrance_Ranking:Init({
    Owner = self,
    IconPath = "BP_Icon_Ranking",
    Text = GText("UI_AppearanceScore_RankEntrance"),
    OnBtnClicked = self.OnRankingBtnClicked,
    OnAddedToFocusPath = function()
      self:OnRankingBtnAddedToFocusPath()
    end,
    OnRemovedFromFocusPath = function()
      self:OnRankingBtnRemovedFromFocusPath()
    end
  })
  self:AddArchiveReddotListen()
end

function M:OnArchiveBtnClicked()
  UIManager(self):LoadUINew("AppearanceArchiveMain")
end

function M:OnRankingBtnClicked()
  AppearanceRankModel:Open()
end

function M:OnParentKeyDown(MyGeometry, InKeyEvent)
  local Reply, IsHandled = self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
  if IsHandled then
    return Reply, IsHandled
  end
  return UIUtils.Unhandled
end

function M:OnParentKeyUp(MyGeometry, InKeyEvent)
  local Reply, IsHandled = self:ProcessOnKeyUp(MyGeometry, InKeyEvent)
  if IsHandled then
    return Reply, IsHandled
  end
  return UIUtils.Unhandled
end

function M:InitKeySetting()
  local StateName = self.FSM:Peak().Name
  self:ClearAllKeyEvents()
  if StateName == FocusStates.Plan then
    return
  end
  self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonRight, self.OnFaceButtonRightKeyDown)
  if StateName == FocusStates.SpecialBtns then
    return
  end
  self:AddKeyDownEvent(UIConst.GamePadKey.RightThumb, self.OnFocusToPlanKeyDown)
  self:AddKeyDownEvent(UIConst.GamePadKey.SpecialRight, self.OnGamePadSpecialRightKeyDown)
end

function M:OnFaceButtonRightKeyDown()
  if self.FSM:Peak().Name ~= FocusStates.List then
    self.FSM:Pop()
    return UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), self:GetDesiredFocusTarget()), true
  end
end

function M:OnFocusToPlanKeyDown()
  if self.Plan_Appearance:IsVisible() then
    return UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), self.Plan_Appearance), true
  end
end

function M:OnGamePadSpecialRightKeyDown()
  if self.Entrance_Archive:IsVisible() then
    return UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), self.Entrance_Archive), true
  end
  if self.Entrance_Ranking:IsVisible() then
    return UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), self.Entrance_Ranking), true
  end
end

function M:OnArchiveBtnAddedToFocusPath()
  self.FSM:Push({
    Name = FocusStates.SpecialBtns,
    Widget = self.Entrance_Archive
  })
  self.IsBtnPanelInFocusPath = true
  self:UpdatePanelKeyVisibility()
end

function M:OnArchiveBtnRemovedFromFocusPath()
  self.IsBtnPanelInFocusPath = false
  self:UpdatePanelKeyVisibility()
end

function M:OnRankingBtnAddedToFocusPath()
  self.FSM:Push({
    Name = FocusStates.SpecialBtns,
    Widget = self.Entrance_Ranking
  })
  self.IsBtnPanelInFocusPath = true
  self:UpdatePanelKeyVisibility()
end

function M:OnRankingBtnRemovedFromFocusPath()
  self.IsBtnPanelInFocusPath = false
  self:UpdatePanelKeyVisibility()
end

function M:UpdatePanelKeyVisibility()
  if UIUtils.IsGamepadInput() then
    self.Panel_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Panel_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  local StateName = self.FSM:Peak().Name
  if StateName == FocusStates.Plan or self.IsBtnPanelInFocusPath then
    self.Key_Entrance:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  if UIUtils.IsGamepadInput() then
    self.Key_Entrance:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.Key_Entrance:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:InitNavigationRules()
  self.List_Avatar:SetNavigationRuleCustom(EUINavigation.Right, {
    self,
    function(_self)
      return self.List_Appearance
    end
  })
  self.List_Appearance:SetNavigationRuleCustom(EUINavigation.Left, {
    self,
    function(_self)
      self.FSM:Pop()
      self.List_Appearance:ClearFocusState()
      local State = self.FSM:Peak()
      local Content
      if State.Name == FocusStates.List then
        Content = State.Content
      else
        Content = self.MainModel:GetSelectedCharContent()
      end
      self.List_Avatar:BP_SetSelectedItem(Content)
      self.List_Avatar:BP_NavigateToItem(Content)
      if Content.Widget then
        return Content.Widget
      end
      return self.List_Avatar
    end
  })
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  M.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
  self:UpdatePanelKeyVisibility()
  if not self.IsInFocusPath then
    return
  end
  if not self:IsFocusStateValidAndHasFocus(self.FSM:Peak()) then
    self:GetDesiredFocusTarget():SetFocus()
  end
end

function M:IsFocusStateValid(State)
  local StateName = State.Name
  if StateName == FocusStates.List then
    return self.List_Avatar:GetIndexForItem(State.Content) >= 0
  end
  return IsValid(State.Widget) and State.Widget:IsVisible()
end

function M:IsFocusStateValidAndHasFocus(State)
  local StateName = State.Name
  if StateName == FocusStates.List then
    return self.List_Avatar:GetIndexForItem(State.Content) >= 0 and self.List_Avatar:HasFocusedDescendants()
  end
  return IsValid(State.Widget) and UIUtils.HasAnyFocus(State.Widget)
end

function M:OnFocusChanged(NewState, OldState, Operation)
  self:InitKeySetting()
  self:UpdatePanelKeyVisibility()
  local BottomKeyInfo = self:CopyParentBottomKeyInfo()
  self:UpdateBottomKeyInfo(BottomKeyInfo)
end

function M:GetDesiredFocusTarget()
  local State = self.FSM:Peak()
  local StateName = State.Name
  if StateName == FocusStates.List and self.List_Avatar:GetIndexForItem(State.Content) >= 0 then
    self.List_Avatar:BP_SetSelectedItem(State.Content)
    self.List_Avatar:BP_NavigateToItem(State.Content)
    return self.List_Avatar
  end
  if State.Widget then
    return State.Widget
  end
  local Content = self.MainModel:GetSelectedCharContent()
  self.List_Avatar:BP_SetSelectedItem(Content)
  self.List_Avatar:BP_NavigateToItem(Content)
  if Content.Widget then
    return Content.Widget
  end
  return self.List_Avatar
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.IsGamepadInput() then
    local DesiredFocusTarget = self:GetDesiredFocusTarget()
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), DesiredFocusTarget)
  end
  return UIUtils.Handled
end

function M:OnListItemAddedToFocusPath(Content)
  if self.IsListExpanded then
    return
  end
  if self.FSM:Peak().Name ~= FocusStates.List then
    self.FSM:Clear()
  end
  self.FSM:Push({
    Name = FocusStates.List,
    Content = Content,
    Widget = self.List_Avatar
  })
end

function M:OnAppearancePanelAddedToFocusPath()
  self.FSM:Push({
    Name = FocusStates.AppearancePanel,
    Widget = self.List_Appearance
  })
end

function M:OnPlanAddedToFocusPath()
  self.FSM:Push({
    Name = FocusStates.Plan,
    Widget = self.Plan_Appearance
  })
end

function M:OnAddedToFocusPath()
  self.IsInFocusPath = true
end

function M:OnRemovedFromFocusPath()
  self.IsInFocusPath = false
end

function M:AddCharListReddotListen()
  if self.IsPreviewMode then
    return
  end
  self:RemoveCharListReddotListen()
  self.CharListReddotNodeNames = {}
  self.NodeName2CharId = {}
  
  local function ListenerFunc(Obj, Count, ReddotType, NodeName)
    self:OnCharListReddotChanged(NodeName)
  end
  
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.CommonChars then
    return
  end
  for _, CommonChar in pairs(Avatar.CommonChars) do
    local CharId = CommonChar.CharId
    local SkinNodeName = CommonConst.DataType.Char .. CommonConst.DataType.Skin .. CharId
    if ReddotManager.GetTreeNode(SkinNodeName) then
      ReddotManager.AddListener(SkinNodeName, self, ListenerFunc, nil, true)
      self.CharListReddotNodeNames[SkinNodeName] = 1
      self.NodeName2CharId[SkinNodeName] = CharId
    end
    local HairNodeName = CommonConst.DataType.Char .. CommonConst.DataType.Hair .. CharId
    if ReddotManager.GetTreeNode(HairNodeName) then
      ReddotManager.AddListener(HairNodeName, self, ListenerFunc, nil, true)
      self.CharListReddotNodeNames[HairNodeName] = 1
      self.NodeName2CharId[HairNodeName] = CharId
    end
    local LevelUpNodeName = CommonConst.DataType.Char .. CommonConst.DataType.Skin .. "LevelUp" .. CharId
    if ReddotManager.GetTreeNode(LevelUpNodeName) then
      ReddotManager.AddListener(LevelUpNodeName, self, ListenerFunc, nil, true)
      self.CharListReddotNodeNames[LevelUpNodeName] = 1
      self.NodeName2CharId[LevelUpNodeName] = CharId
    end
  end
end

function M:RemoveCharListReddotListen()
  if not self.CharListReddotNodeNames then
    return
  end
  for NodeName, _ in pairs(self.CharListReddotNodeNames) do
    ReddotManager.RemoveListener(NodeName, self)
  end
  self.CharListReddotNodeNames = nil
  self.NodeName2CharId = nil
end

function M:OnCharListReddotChanged(NodeName)
  local CharId = self.NodeName2CharId and self.NodeName2CharId[NodeName]
  if not CharId then
    return
  end
  local Content = self.MainModel.CharId2Content and self.MainModel.CharId2Content[CharId]
  if Content then
    AppearanceUtils.UpdateSingleCharReddot(Content)
  end
end

function M:AddArchiveReddotListen()
  if self.IsPreviewMode then
    return
  end
  self:RemoveArchiveReddotListen()
  local NodeName = "AppearanceEntrance"
  if not ReddotManager.GetTreeNode(NodeName) then
    return
  end
  self.ArchiveReddotNodeName = NodeName
  ReddotManager.AddListener(NodeName, self, function()
    self:UpdateArchiveReddot()
  end, nil, true)
  self:UpdateArchiveReddot()
end

function M:RemoveArchiveReddotListen()
  if not self.ArchiveReddotNodeName then
    return
  end
  ReddotManager.RemoveListener(self.ArchiveReddotNodeName, self)
  self.ArchiveReddotNodeName = nil
end

function M:UpdateArchiveReddot()
  local Node = ReddotManager.GetTreeNode("AppearanceEntrance")
  local bVisible = Node and Node.Count > 0 or false
  self.Entrance_Archive:SetReddotVisible(bVisible)
end

AssembleComponents(M)
return M
