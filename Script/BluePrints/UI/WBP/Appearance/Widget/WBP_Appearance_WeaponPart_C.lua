require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local AppearanceUtils = require("BluePrints.UI.WBP.Appearance.AppearanceUtils")
local FSM = require("Blueprints.UI.FocusStateMachine")
local M = Class({
  "BluePrints.UI.WBP.Appearance.WBP_Appearance_MainWidget_Base_C"
})
M._components = {
  "BluePrints.UI.WBP.Appearance.Widget.AppearanceWeaponExpandListComponent",
  "BluePrints.UI.KeyInputComponent"
}
local FocusStates = {
  List = "List",
  AppearancePanel = "AppearancePanel"
}

function M:Construct()
  M.Super.Construct(self)
  self.AssociatedList = self.List_Weapon
  self.WidgetToHideWhenExpandList = {
    self.Panel_List,
    self.Panel_Selective,
    self.List_Appearance,
    self.Selective_Listing,
    self.WidgetSwitcher_MP
  }
  rawset(self, "FSM", FSM:New(self, {
    StateNames = FocusStates,
    OnStateChanged = self.OnFocusChanged,
    CheckFunction = self.IsFocusStateValid
  }))
  self:InitNavigationRules()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  M.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
  if not self.IsInFocusPath then
    return
  end
  if not self:IsFocusStateValidAndHasFocus(self.FSM:Peak()) then
    self:GetDesiredFocusTarget():SetFocus()
  end
end

function M:Destruct()
  self:RemoveWeaponListReddotListen()
end

function M:Init(Params)
  self.Parent = Params.Parent
  self.Type = CommonConst.ArmoryType.Weapon
  self.Tag = Params.Tag
  self.MainModel = self.Parent.MainModel
  self.ActorController = self.Parent.ActorController
  self.MainModel:CreateWeaponContents(Params)
  local CurContent
  
  local function FindContent(WeaponType)
    local ContentToFind
    if Params[WeaponType .. "WeaponUuid"] then
      ContentToFind = self.MainModel:GetWeaponContentByUuid(Params[WeaponType .. "WeaponUuid"])
    end
    if nil == ContentToFind and Params[WeaponType .. "WeaponId"] then
      local Contents = self.MainModel:GetWeaponContentsByWeaponId(Params[WeaponType .. "WeaponId"])
      if Contents then
        local Uuid
        Uuid, ContentToFind = next(Contents)
      end
      if nil == ContentToFind then
        ContentToFind = self.MainModel:GetUnownedWeaponContentByWeaponId(Params[WeaponType .. "WeaponId"])
      end
    end
    return ContentToFind
  end
  
  CurContent = FindContent(self.Tag)
  if nil == CurContent then
    if self.Tag == AppearanceUtils.AppearanceMainTabNames.Melee then
      CurContent = self.MainModel:GetMeleeWeaponContents()[1]
    elseif self.Tag == AppearanceUtils.AppearanceMainTabNames.Ranged then
      CurContent = self.MainModel:GetRangedWeaponContents()[1]
    end
  end
  self.MainModel:SetSelectedWeaponContent(CurContent)
  self:InitWeaponList()
  self:OnSelectedWeaponContentChanged()
end

function M:OnSelectedWeaponContentChanged()
  self:UpdateRightBottomInfo()
  self:InitWeaponAppearanceSuits()
  self.ActorController:ChangeWeaponModel(self.MainModel:GetSelectedWeapon())
  self.ActorController:ResetActorRotation()
  self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Weapon, self.Tag, CommonConst.ArmoryTag.Appearance, "")
end

function M:InitWeaponAppearanceSuits()
  self.List_Appearance:Init(self.MainModel, {
    OnCloseCallback = function()
      self:InitWeaponAppearanceSuits()
      self.ActorController:ResetActorRotation()
      self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Weapon, self.Tag, CommonConst.ArmoryTag.Appearance, "")
    end,
    Parent = self.Parent,
    IsCharacterTrialMode = self.IsCharacterTrialMode,
    IsTargetUnowned = not self.MainModel:IsSelectedWeaponOwned(),
    OnAddedToFocusPath = function()
      self:OnAppearancePanelAddedToFocusPath()
    end
  })
end

function M:OnTabChangeToOther()
  self:PlayOutAnim()
  if self.Tag == AppearanceUtils.AppearanceMainTabNames.Melee then
    self.ActorController:DestroyPlayerMeleeWeapon()
  else
    self.ActorController:DestroyPlayerRangedWeapon()
  end
end

function M:OnTabChangeToSelf()
  self:PlayInAnim()
  self.ActorController:ChangeWeaponModel(self.MainModel:GetSelectedWeapon())
  self.ActorController:ResetActorRotation()
  self.ActorController.bPlaySameMontage = true
  self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Weapon, self.Tag, CommonConst.ArmoryTag.Appearance, "")
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
  local Data = DataMgr.Weapon[self.MainModel:GetSelectedWeapon().WeaponId]
  if not Data then
    return
  end
  local MeleeIcons, UnorderedMeleeIcons, RangedIcons, UnorderedRangedIcons = UIUtils.GetAllWeaponTagIcons()
  local Tag2Icons
  if self.Tag == AppearanceUtils.AppearanceMainTabNames.Melee then
    Tag2Icons = UnorderedMeleeIcons
  else
    Tag2Icons = UnorderedRangedIcons
  end
  local Weapon = self.MainModel:GetSelectedWeapon()
  local Icon
  for key, value in pairs(Weapon:GetTags()) do
    if Tag2Icons[key] then
      Icon = Tag2Icons[key]
      break
    end
  end
  if Icon then
    self.Icon_Weapon:SetVisibility(UIConst.VisibilityOp.HitTestVisible)
    self.Icon_Weapon:SetBrushResourceObject(LoadObject(Icon))
  else
    self.Icon_Weapon:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  local WeaponName = Weapon:Data().WeaponName
  self.Text_Weapon:SetText(GText(WeaponName))
end

function M:OnListItemClicked(Content)
  if Content == self.MainModel:GetSelectedWeaponContent() then
    if UIUtils.IsGamepadInput() and self.IsInFocusPath then
      self.List_Appearance:SetFocus()
    end
    return
  end
  self.MainModel:SetSelectedWeaponContent(Content)
  self:OnSelectedWeaponContentChanged()
end

function M:OnListItemSelectionChanged(Content, IsSelected)
  if not IsSelected then
    return
  end
  if UIUtils.IsGamepadInput() then
    self:OnListItemClicked(Content)
  end
end

function M:InitWeaponList()
  self.List_Weapon:ClearListItems()
  local FuncName = "Get" .. self.Tag .. "WeaponContents"
  local AllWeaponContent = self.MainModel[FuncName](self.MainModel)
  for index, value in ipairs(AllWeaponContent) do
    function value.OnAddedToFocusPath(_self, Content)
      self:OnListItemAddedToFocusPath(Content)
    end
    
    self.List_Weapon:AddItem(value)
  end
  AppearanceUtils.UpdateWeaponListReddot(AllWeaponContent)
  self:AddWeaponListReddotListen()
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
  self:ClearAllKeyEvents()
  self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonRight, self.OnFaceButtonRightKeyDown)
end

function M:OnFaceButtonRightKeyDown()
  self.FSM:Pop()
  if self.FSM:Peak().Name ~= FocusStates.List then
    return UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), self:GetDesiredFocusTarget()), true
  end
end

function M:InitNavigationRules()
  self.List_Weapon:SetNavigationRuleCustom(EUINavigation.Right, {
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
        Content = self.MainModel:GetSelectedWeaponContent()
      end
      self.List_Weapon:BP_SetSelectedItem(Content)
      self.List_Weapon:BP_NavigateToItem(Content)
      if Content.Widget then
        return Content.Widget
      end
      return self.List_Weapon
    end
  })
end

function M:IsFocusStateValid(State)
  local StateName = State.Name
  if StateName == FocusStates.List then
    return self.List_Weapon:GetIndexForItem(State.Content) >= 0
  end
  return IsValid(State.Widget) and State.Widget:IsVisible()
end

function M:IsFocusStateValidAndHasFocus(State)
  local StateName = State.Name
  if StateName == FocusStates.List then
    return self.List_Weapon:GetIndexForItem(State.Content) >= 0 and self.List_Weapon:HasFocusedDescendants()
  end
  return IsValid(State.Widget) and UIUtils.HasAnyFocus(State.Widget)
end

function M:OnFocusChanged(NewState, OldState, Operation)
  self:InitKeySetting()
  local BottomKeyInfo = self:CopyParentBottomKeyInfo()
  self:UpdateBottomKeyInfo(BottomKeyInfo)
end

function M:GetDesiredFocusTarget()
  local State = self.FSM:Peak()
  local StateName = State.Name
  if StateName == FocusStates.List and self.List_Weapon:GetIndexForItem(State.Content) >= 0 then
    self.List_Weapon:BP_SetSelectedItem(State.Content)
    self.List_Weapon:BP_NavigateToItem(State.Content)
    return self.List_Weapon
  end
  if State.Widget then
    return State.Widget
  end
  local Content = self.MainModel:GetSelectedWeaponContent()
  self.List_Weapon:BP_SetSelectedItem(Content)
  self.List_Weapon:BP_NavigateToItem(Content)
  if Content.Widget then
    return Content.Widget
  end
  return self.List_Weapon
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.IsGamepadInput() then
    local DesiredFocusTarget = self:GetDesiredFocusTarget()
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), DesiredFocusTarget)
  end
  return UIUtils.Handled
end

function M:OnListItemAddedToFocusPath(Content)
  if self.FSM:Peak().Name ~= FocusStates.List then
    self.FSM:Clear()
  end
  self.FSM:Push({
    Name = FocusStates.List,
    Content = Content,
    Widget = self.List_Weapon
  })
end

function M:OnAppearancePanelAddedToFocusPath()
  self.FSM:Push({
    Name = FocusStates.AppearancePanel,
    Widget = self.List_Appearance
  })
end

function M:OnAddedToFocusPath()
  self.IsInFocusPath = true
end

function M:OnRemovedFromFocusPath()
  self.IsInFocusPath = false
end

function M:AddWeaponListReddotListen()
  if self.IsPreviewMode then
    return
  end
  self:RemoveWeaponListReddotListen()
  self.WeaponListReddotNodeNames = {}
  self.NodeName2WeaponIds = {}
  
  local function ListenerFunc(Obj, Count, ReddotType, NodeName)
    self:OnWeaponListReddotChanged(NodeName)
  end
  
  local FuncName = "Get" .. self.Tag .. "WeaponContents"
  local AllWeaponContent = self.MainModel[FuncName](self.MainModel)
  for _, Content in ipairs(AllWeaponContent) do
    local Data = DataMgr.Weapon[Content.UnitId]
    if Data and Data.SkinApplicationType then
      for _, AppType in ipairs(Data.SkinApplicationType) do
        local NodeName = CommonConst.DataType.WeaponSkin .. (AppType or "")
        if not self.NodeName2WeaponIds[NodeName] then
          self.NodeName2WeaponIds[NodeName] = {}
        end
        table.insert(self.NodeName2WeaponIds[NodeName], Content.UnitId)
      end
    end
  end
  for NodeName, _ in pairs(self.NodeName2WeaponIds) do
    if ReddotManager.GetTreeNode(NodeName) then
      ReddotManager.AddListener(NodeName, self, ListenerFunc, nil, true)
      self.WeaponListReddotNodeNames[NodeName] = 1
    end
  end
end

function M:RemoveWeaponListReddotListen()
  if not self.WeaponListReddotNodeNames then
    return
  end
  for NodeName, _ in pairs(self.WeaponListReddotNodeNames) do
    ReddotManager.RemoveListener(NodeName, self)
  end
  self.WeaponListReddotNodeNames = nil
  self.NodeName2WeaponIds = nil
end

function M:OnWeaponListReddotChanged(NodeName)
  local WeaponIds = self.NodeName2WeaponIds and self.NodeName2WeaponIds[NodeName]
  if not WeaponIds then
    return
  end
  local FuncName = "Get" .. self.Tag .. "WeaponContentsByWeaponId"
  for _, WeaponId in ipairs(WeaponIds) do
    local Contents = self.MainModel[FuncName](self.MainModel, WeaponId)
    if Contents then
      for _, Content in pairs(Contents) do
        AppearanceUtils.UpdateSingleWeaponReddot(Content)
      end
    end
  end
end

AssembleComponents(M)
return M
