require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local UIUtils = require("Utils.UIUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})
M._components = {
  "BluePrints.UI.WBP.Armory.PC.WBP_Build_PanelAutoAssist_GamepadComp"
}
local TAB_CHAR = 1
local TAB_WEAPON = 2
local TARGET_CHAR = "Char"
local TARGET_WEAPON = "Weapon"
local OCCUPIED_WARNING_TEXT_KEYS = {
  [TAB_CHAR] = "Character_Not_avaliable",
  [TAB_WEAPON] = "Rule_Describe"
}

local function ContainsValue(Values, TargetValue)
  if type(Values) ~= "table" then
    return Values == TargetValue
  end
  for _, Value in pairs(Values) do
    if Value == TargetValue then
      return true
    end
  end
  return false
end

local function HideWeaponAssisterIcon(Entry)
  if IsValid(Entry) and Entry.SetWeaponPhantomIcon then
    Entry:SetWeaponPhantomIcon(nil)
  end
end

function M:Initialize(Initializer)
  rawset(self, "ListenEvent", {})
  rawset(self, "Owner", nil)
  rawset(self, "Avatar", nil)
  rawset(self, "CurrentTab", TAB_CHAR)
  rawset(self, "IsEdit", false)
  rawset(self, "bSaving", false)
  rawset(self, "bClosing", false)
  rawset(self, "bUpdatingSift", false)
  rawset(self, "SaveRequestSerial", 0)
  rawset(self, "ActualPriority", {
    Char = {},
    Weapon = {}
  })
  rawset(self, "DraftPriority", {
    Char = {},
    Weapon = {}
  })
  rawset(self, "AutoAssistInGearTargets", {
    Char = {},
    Weapon = {}
  })
  rawset(self, "SelectedFilters", {})
  rawset(self, "CurrentContents", {})
  rawset(self, "FocusedAutoAssistItemContent", nil)
  rawset(self, "FocusedWeaponTipContent", nil)
  rawset(self, "bAutoAssistToolFocus", false)
  rawset(self, "CurInputDeviceType", ECommonInputType.MouseAndKeyboard)
  rawset(self, "CurGamepadName", nil)
end

function M:Construct()
  if IsValid(self.Tips) then
    self.Tips:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Btn_Close.OnClicked:Add(self, self.OnBGClick)
  self.Btn_Edit:BindSingleEventOnClicked(self, self.EnterEditMode)
  self.Btn_Back:BindSingleEventOnClicked(self, self.HandleBack)
  self.Btn_Save:BindSingleEventOnClicked(self, self.SaveChanges)
  self.Btn_Description:BindSingleEventOnClicked(self, self.ShowDescription)
  self.SwitchCheckBox:AddEventOnCheckStateChanged(self, self.OnAutoAssistSwitchChanged)
  self.List_Item.BP_OnItemClicked:Add(self, self.OnListItemClicked)
  self.List_Item.OnCreateEmptyContent:Bind(self, self.CreateEmptyListContent)
  if IsValid(self.Out) then
    self:BindToAnimationFinished(self.Out, {
      self,
      self.OnOutAnimationFinished
    })
  end
end

function M:Destruct()
  self.SaveRequestSerial = self.SaveRequestSerial + 1
  self:CloseWeaponItemFocusTip()
  if IsValid(self.Btn_Close) then
    self.Btn_Close.OnClicked:Remove(self, self.OnBGClick)
  end
  if IsValid(self.Btn_Edit) then
    self.Btn_Edit:UnBindEventOnClicked(self, self.EnterEditMode)
  end
  if IsValid(self.Btn_Back) then
    self.Btn_Back:UnBindEventOnClicked(self, self.HandleBack)
  end
  if IsValid(self.Btn_Save) then
    self.Btn_Save:UnBindEventOnClicked(self, self.SaveChanges)
  end
  if IsValid(self.Btn_Description) then
    self.Btn_Description:UnBindEventOnClicked(self, self.ShowDescription)
  end
  if IsValid(self.SwitchCheckBox) then
    self.SwitchCheckBox:RemoveEventOnCheckStateChanged(self)
  end
  if IsValid(self.List_Item) then
    self.List_Item.BP_OnItemClicked:Remove(self, self.OnListItemClicked)
    self.List_Item.OnCreateEmptyContent:Unbind()
  end
  if IsValid(self.SubTab) then
    self.SubTab:BindEventOnTabSelected(nil, nil)
  end
  if IsValid(self.Sort) then
    self.Sort:BindEventOnSelectionsChanged(nil, nil)
    self.Sort:BindEventOnSortTypeChanged(nil, nil)
  end
  if IsValid(self.Sift) then
    self.Sift:BindEventOnSelectionsChanged(nil, nil)
    self.Sift:SetGetBackFocusWidget(nil)
  end
  if IsValid(self.Out) then
    self:UnbindFromAnimationFinished(self.Out, {
      self,
      self.OnOutAnimationFinished
    })
  end
  if self.ClearScriptRegister then
    self:ClearScriptRegister()
  end
  self.Owner = nil
  self.Avatar = nil
  self.FocusedAutoAssistItemContent = nil
end

function M:Init(Owner)
  self.Owner = Owner
  self.Avatar = GWorld:GetAvatar()
  if not self.Avatar then
    return
  end
  self:InitTexts()
  self:InitSortAndSift()
  self:CapturePriorityState()
  self:InitTabs()
  self.SwitchCheckBox:SetChecked(self.Avatar.bAutoPhantomForBigWorld == true, false)
  self.IsEdit = false
  self:ApplyModeView()
  self:RefreshList()
  self:InitAutoAssistGamepad()
  if IsValid(self.In) then
    self:PlayAnimation(self.In)
  end
end

function M:InitTexts()
  self.Text_Title:SetText(GText("Pre_Assistant"))
  self.Text_SwitchDesc:SetText(GText("UI_ArmourySquad_AutoSummon"))
  self.Btn_Edit:SetText(GText("Pre_Assistant_Set"))
  self.Btn_Back:SetText(GText("UI_BACK"))
  self.Btn_Save:SetText(GText("UI_RegionMap_Save"))
  if IsValid(self.Text_Warning) then
    self.Text_Warning:SetText(GText(OCCUPIED_WARNING_TEXT_KEYS[self.CurrentTab]))
  end
end

function M:InitTabs()
  local ConfigData = {
    Owner = self,
    PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self),
    LeftKey = "Q",
    RightKey = "E",
    LeftGamePadKey = "LeftShoulder",
    RightGamePadKey = "RightShoulder",
    Tabs = {
      {
        Text = GText("Assistant_Use"),
        Idx = TAB_CHAR
      },
      {
        Text = GText("Weapon_Use"),
        Idx = TAB_WEAPON
      }
    }
  }
  self.SubTab:Init(ConfigData)
  self.SubTab:BindEventOnTabSelected(self, self.OnTabSelected)
  self.SubTab:SelectTab(self.CurrentTab)
end

function M:InitSortAndSift()
  local SortParams = {
    OnGetBackReply = function(Parent)
      Parent:HandleBack()
      return UIUtils.Handled
    end
  }
  self.Sort:Init(self, {
    "UI_LEVEL_SELECT"
  }, CommonConst.DESC, SortParams)
  self.Sort:BindEventOnSelectionsChanged(self, self.OnSortChanged)
  self.Sort:BindEventOnSortTypeChanged(self, self.OnSortChanged)
  self.Sort:SetGamepadKey("LS")
  self.Sift:BindEventOnSelectionsChanged(self, self.OnSiftChanged)
  self.Sift:SetGetBackFocusWidget(function()
    self.bAutoAssistToolFocus = false
    return self.List_Item
  end)
  if self.Sift.SetGamepadKeyVisibility then
    self.Sift:SetGamepadKeyVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Sort.SetRightWidgetForNavigation and self.Sift.Button_FIiliter_List then
    self.Sort:SetRightWidgetForNavigation(self.Sift.Button_FIiliter_List)
    self.Sift.Button_FIiliter_List:SetNavigationRuleExplicit(EUINavigation.Left, self.Sort)
  end
end

function M:CapturePriorityState()
  self.ActualPriority = {
    Char = {},
    Weapon = {}
  }
  self.DraftPriority = {
    Char = {},
    Weapon = {}
  }
  for TargetId, Target in pairs(self.Avatar.Chars or {}) do
    if self:IsVisibleCharacter(Target) then
      local IsPriority = Target.IsWarLike == true
      self.ActualPriority.Char[TargetId] = IsPriority
      self.DraftPriority.Char[TargetId] = IsPriority
    end
  end
  for TargetId, Target in pairs(self.Avatar.Weapons or {}) do
    local IsPriority = Target.IsWarLike == true
    self.ActualPriority.Weapon[TargetId] = IsPriority
    self.DraftPriority.Weapon[TargetId] = IsPriority
  end
end

function M:IsVisibleCharacter(Target)
  if not Target then
    return false
  end
  local SwitchData = DataMgr.CharacterAttributeSwitch and DataMgr.CharacterAttributeSwitch[Target.CharId]
  if not SwitchData then
    return true
  end
  local ActiveCharId = self.Avatar.CharacterAttributeSwitch and self.Avatar.CharacterAttributeSwitch[SwitchData.CharGroupId]
  return not ActiveCharId or ActiveCharId == Target.CharId
end

function M:OnTabSelected(TabWidget)
  local NewTab = TabWidget and (TabWidget.Idx or TabWidget.TabId) or TAB_CHAR
  if NewTab ~= TAB_CHAR and NewTab ~= TAB_WEAPON then
    NewTab = TAB_CHAR
  end
  self.CurrentTab = NewTab
  self.SelectedFilters = {}
  self:ResetSiftForCurrentTab()
  self:RefreshList()
  self:RefreshAutoAssistGamepadHints()
  self:RequestFocusAutoAssistList()
end

function M:ResetSiftForCurrentTab()
  self.bUpdatingSift = true
  self.Sift.IsSelected = false
  self.Sift:ClearSiftSelection()
  self.Sift:SetItemDatas(self:BuildSiftItemDatas())
  self.bUpdatingSift = false
end

function M:BuildSiftItemDatas()
  local Tags = {}
  local Names = {}
  local Title = "UI_Armory_Char"
  if self.CurrentTab == TAB_CHAR then
    Tags, Names = UIUtils.GetAllElementTypes()
  else
    Title = "UI_SHOP_SUBTAB_NAME_WEAPON"
    local MeleeTags, MeleeNames, RangedTags, RangedNames = UIUtils.GetAllWeaponTags()
    local AddedTags = {}
    
    local function Append(SourceTags, SourceNames)
      for Index, Tag in ipairs(SourceTags or {}) do
        if not AddedTags[Tag] then
          AddedTags[Tag] = true
          Tags[#Tags + 1] = Tag
          Names[#Names + 1] = SourceNames and SourceNames[Index] or Tag
        end
      end
    end
    
    Append(MeleeTags, MeleeNames)
    Append(RangedTags, RangedNames)
  end
  return {
    {
      Id = 1,
      Title = Title,
      HasSelectAll = true,
      SelectionDatas = Tags or {},
      SelectionText = Names or {},
      SelectionValueMode = "Value"
    }
  }
end

function M:OnSortChanged()
  if self.IsEdit then
    self:RefreshList()
  end
end

function M:OnSiftChanged(SelectedItems)
  if self.bUpdatingSift then
    return
  end
  self.SelectedFilters = {}
  local SelectedValues = SelectedItems and SelectedItems[1] or {}
  for _, Value in pairs(SelectedValues) do
    self.SelectedFilters[Value] = true
  end
  if self.IsEdit then
    self:RefreshList()
  end
end

function M:GetCurrentTargetType()
  return self.CurrentTab == TAB_WEAPON and TARGET_WEAPON or TARGET_CHAR
end

function M:IsMainControlledTarget(TargetType, TargetId)
  if not self.Avatar then
    return false
  end
  if TargetType == TARGET_CHAR then
    return TargetId == self.Avatar.CurrentChar
  end
  return TargetId == self.Avatar.MeleeWeapon or TargetId == self.Avatar.RangedWeapon
end

function M:AreAllSavedTargetsMainControlled(TargetType)
  local SelectedTargets = self.ActualPriority[TargetType] or {}
  local HasSelectedTarget = false
  for TargetId, IsSelected in pairs(SelectedTargets) do
    if true == IsSelected then
      HasSelectedTarget = true
      if not self:IsMainControlledTarget(TargetType, TargetId) then
        return false
      end
    end
  end
  return HasSelectedTarget
end

function M:RefreshOccupiedWarning()
  if not IsValid(self.Panel_Warning) then
    return
  end
  if IsValid(self.Text_Warning) then
    self.Text_Warning:SetText(GText(OCCUPIED_WARNING_TEXT_KEYS[self.CurrentTab]))
  end
  local bShowWarning = not self.IsEdit and IsValid(self.SwitchCheckBox) and self.SwitchCheckBox:GetChecked() == true and self:AreAllSavedTargetsMainControlled(self:GetCurrentTargetType())
  self.Panel_Warning:SetVisibility(bShowWarning and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:SetItemAutoAssistSummonState(Content, bWillSummon)
  local BonusType = bWillSummon and 1 or 0
  local BonusText = bWillSummon and GText("Assistant_On") or nil
  Content.BonusType = BonusType
  Content.ExtraBonusText = BonusText
  local Entry = Content.SelfWidget or Content.Widget
  if IsValid(Entry) and Entry.SetBonus then
    Entry.BonusType = BonusType
    Entry.ExtraBonusText = BonusText
    Entry:SetBonus(BonusType, BonusText)
  end
end

function M:PassesCurrentFilter(TargetType, Target)
  if not next(self.SelectedFilters) then
    return true
  end
  if TargetType == TARGET_CHAR then
    local BattleData = DataMgr.BattleChar[Target.CharId]
    return BattleData and self.SelectedFilters[BattleData.Attribute] == true
  end
  local BattleData = DataMgr.BattleWeapon[Target.WeaponId]
  local WeaponTags = BattleData and BattleData.WeaponTag
  for FilterTag in pairs(self.SelectedFilters) do
    if ContainsValue(WeaponTags, FilterTag) then
      return true
    end
  end
  return false
end

function M:CreateTargetContent(TargetType, TargetId, Target)
  local Tag = CommonConst.ArmoryTag.Char
  if TargetType == TARGET_WEAPON then
    Tag = self.Owner:GetWeaponTypeById(Target.WeaponId) or CommonConst.ArmoryTag.Melee
  end
  local Content = self.Owner:NewItemContent(Target, TargetType, Tag)
  if TargetType == TARGET_WEAPON then
    Content.AttrIcon = nil
    Content.AfterInitCallback = HideWeaponAssisterIcon
  end
  Content.Uuid = TargetId
  Content.TargetType = TargetType
  Content.TargetId = TargetId
  Content.TargetObject = Target
  Content.ItemType = TargetType
  Content.ParentWidget = self
  Content.bDisableCommonClick = true
  Content.bSelectTag = self.IsEdit and true == self.DraftPriority[TargetType][TargetId]
  Content.bInGear = self:IsMainControlledTarget(TargetType, TargetId)
  self:SetItemAutoAssistSummonState(Content, self:IsTargetInGear(TargetType, TargetId))
  Content.UIName = self.Owner.WidgetName or "SquadMainUINew"
  Content.IsShowDetails = false
  Content.OnAddedToFocusPathEvent = {
    Obj = self,
    Callback = self.OnAutoAssistItemFocused,
    Params = Content
  }
  Content.OnRemovedFromFocusPathEvent = {
    Obj = self,
    Callback = self.OnAutoAssistItemFocusRemoved,
    Params = Content
  }
  return Content
end

function M:CreateEmptyListContent()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.IsAutoAssistEmpty = true
  Content.NotInteractive = true
  Content.bDisableCommonClick = true
  Content.IsShowDetails = false
  return Content
end

local function BuildWeaponDetailsContent(Content)
  return {
    Type = Content.Type,
    ItemType = Content.ItemType,
    ItemId = Content.UnitId or Content.ItemId or Content.Id,
    Uuid = Content.Uuid,
    IsShowDetails = true,
    bNotFocus = true,
    bIsHoverState = false,
    UIName = Content.UIName,
    bNotShowAccess = Content.bNotShowAccess,
    bCustomStype = Content.bCustomStype,
    bHideGamePad = true,
    JumpReturnCallBack = Content.JumpReturnCallBack
  }
end

function M:OpenWeaponItemDetails(Content)
  if not (self.CurrentTab == TAB_WEAPON and Content and Content.TargetType == TARGET_WEAPON and IsValid(self.Tips)) or not self.Tips.RefreshItemInfo then
    return
  end
  if self.FocusedWeaponTipContent == Content then
    return
  end
  rawset(self, "FocusedWeaponTipContent", Content)
  self.Tips:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Tips:RefreshItemInfo(BuildWeaponDetailsContent(Content), true)
  if IsValid(self.Tips.Panel_Controller) then
    self.Tips.Panel_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if IsValid(self.Tips.In) then
    self.Tips:PlayAnimation(self.Tips.In)
  end
end

function M:GetFocusedAutoAssistItem()
  if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
    return
  end
  local Content = self.FocusedAutoAssistItemContent
  if not Content or self.List_Item:GetNumItems() <= 0 then
    return
  end
  return Content
end

function M:OnAutoAssistItemFocused(Content)
  if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
    return
  end
  rawset(self, "FocusedAutoAssistItemContent", Content)
  self:RefreshAutoAssistGamepadHints()
  if Content and Content.TargetType == TARGET_WEAPON and self.FocusedWeaponTipContent ~= Content then
    self:OpenWeaponItemDetails(Content)
  end
end

function M:OnAutoAssistItemFocusRemoved(Content)
  if self.FocusedAutoAssistItemContent == Content then
    rawset(self, "FocusedAutoAssistItemContent", nil)
  end
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    self:CloseWeaponItemFocusTip(Content)
    self:RefreshAutoAssistGamepadHints()
  end
end

function M:CloseWeaponItemFocusTip(Content)
  local FocusedContent = self.FocusedWeaponTipContent
  if Content and Content ~= FocusedContent then
    return
  end
  rawset(self, "FocusedWeaponTipContent", nil)
  if IsValid(self.Tips) then
    self.Tips:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:IsTargetInGear(TargetType, TargetId)
  local TargetMap = self.AutoAssistInGearTargets[TargetType]
  return TargetMap and true == TargetMap[TargetId]
end

function M:RefreshAutoAssistInGearTargets()
  self.AutoAssistInGearTargets = {
    Char = {},
    Weapon = {}
  }
  if not (self.Avatar and IsValid(self.SwitchCheckBox)) or self.SwitchCheckBox:GetChecked() ~= true then
    return
  end
  local UpdateInfo = self.Avatar:GetFirstTwoPhantomAndWeapon(true)
  if not UpdateInfo then
    return
  end
  if UpdateInfo.Phantom1 then
    self.AutoAssistInGearTargets.Char[UpdateInfo.Phantom1] = true
  end
  if UpdateInfo.Phantom2 then
    self.AutoAssistInGearTargets.Char[UpdateInfo.Phantom2] = true
  end
  if UpdateInfo.PhantomWeapon1 then
    self.AutoAssistInGearTargets.Weapon[UpdateInfo.PhantomWeapon1] = true
  end
  if UpdateInfo.PhantomWeapon2 then
    self.AutoAssistInGearTargets.Weapon[UpdateInfo.PhantomWeapon2] = true
  end
end

function M:RefreshCurrentItemStatus()
  self:RefreshAutoAssistInGearTargets()
  for _, Content in ipairs(self.CurrentContents or {}) do
    ArmoryUtils:SetItemInGear(Content, self:IsMainControlledTarget(Content.TargetType, Content.TargetId))
    self:SetItemAutoAssistSummonState(Content, self:IsTargetInGear(Content.TargetType, Content.TargetId))
  end
end

function M:SortTargetContents(Contents, TargetType, SortType)
  table.sort(Contents, function(Left, Right)
    if TargetType == TARGET_WEAPON then
      local LeftIsAutoAssist = self:IsTargetInGear(TARGET_WEAPON, Left.TargetId)
      local RightIsAutoAssist = self:IsTargetInGear(TARGET_WEAPON, Right.TargetId)
      if LeftIsAutoAssist ~= RightIsAutoAssist then
        return LeftIsAutoAssist
      end
    end
    local LeftPriority = self.DraftPriority[TargetType][Left.TargetId] == true
    local RightPriority = self.DraftPriority[TargetType][Right.TargetId] == true
    if LeftPriority ~= RightPriority then
      return LeftPriority
    end
    local IsDesc = SortType == CommonConst.DESC
    
    local function CompareValue(LeftValue, RightValue)
      if LeftValue == RightValue then
        return nil
      end
      if IsDesc then
        return RightValue < LeftValue
      end
      return LeftValue < RightValue
    end
    
    local Result = CompareValue(tonumber(Left.Level) or 0, tonumber(Right.Level) or 0)
    if nil ~= Result then
      return Result
    end
    Result = CompareValue(tonumber(Left.Rarity) or 0, tonumber(Right.Rarity) or 0)
    if nil ~= Result then
      return Result
    end
    Result = CompareValue(tonumber(Left.UnitId) or 0, tonumber(Right.UnitId) or 0)
    if nil ~= Result then
      return Result
    end
    return CompareValue(tostring(Left.TargetId), tostring(Right.TargetId)) or false
  end)
end

function M:BuildCurrentContents()
  local TargetType = self:GetCurrentTargetType()
  local TargetMap = TargetType == TARGET_CHAR and self.Avatar.Chars or self.Avatar.Weapons
  local Contents = {}
  for TargetId, Target in pairs(TargetMap or {}) do
    local IsVisible = TargetType ~= TARGET_CHAR or self:IsVisibleCharacter(Target)
    local IsPriority = Target.IsWarLike == true
    if IsVisible and (self.IsEdit or IsPriority) and self:PassesCurrentFilter(TargetType, Target) then
      Contents[#Contents + 1] = self:CreateTargetContent(TargetType, TargetId, Target)
    end
  end
  local SortType = CommonConst.DESC
  if self.IsEdit then
    local _, CurrentSortType = self.Sort:GetSortInfos()
    SortType = CurrentSortType or CommonConst.DESC
  end
  self:SortTargetContents(Contents, TargetType, SortType)
  return Contents
end

function M:RefreshList()
  self:CloseWeaponItemFocusTip()
  rawset(self, "FocusedAutoAssistItemContent", nil)
  self.List_Item:ClearListItems()
  self:RefreshAutoAssistInGearTargets()
  self.CurrentContents = self:BuildCurrentContents()
  for _, Content in ipairs(self.CurrentContents) do
    self.List_Item:AddItem(Content)
  end
  local HasContent = #self.CurrentContents > 0
  self.WS_List:SetActiveWidgetIndex(HasContent and 0 or 1)
  if HasContent then
    self.List_Item:RequestFillEmptyContent()
  end
  local EmptyTextKey = self.CurrentTab == TAB_CHAR and "Pre_Assistant_Havenot" or "Pre_Weapon_Havenot"
  self.Text_Empty:SetText(GText(EmptyTextKey))
  self:RefreshOccupiedWarning()
  self:RefreshAutoAssistGamepadHints()
  self:PlayAnimation(self.Change)
end

function M:OnListItemClicked(Content)
  if not (not self.bSaving and Content) or Content.IsAutoAssistEmpty then
    return
  end
  if Content.TargetType == TARGET_WEAPON then
    self:OpenWeaponItemDetails(Content)
  end
  if not self.IsEdit then
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
      self:EnterEditMode()
    end
    return
  end
  local TargetDraft = self.DraftPriority[Content.TargetType]
  TargetDraft[Content.TargetId] = TargetDraft[Content.TargetId] ~= true
  Content.bSelectTag = TargetDraft[Content.TargetId]
  ArmoryUtils:SetItemSelectTag(Content, Content.bSelectTag)
  if Content.TargetType == TARGET_WEAPON then
    HideWeaponAssisterIcon(Content.SelfWidget)
  end
  self:UpdateSaveButtonState()
end

function M:EnterEditMode()
  if self.IsEdit or self.bSaving then
    return
  end
  self:CapturePriorityState()
  self.IsEdit = true
  self.SelectedFilters = {}
  self:ResetSiftForCurrentTab()
  self:ApplyModeView()
  self:RefreshList()
  self:RequestFocusAutoAssistList()
end

function M:ExitEditMode()
  self:CapturePriorityState()
  self.IsEdit = false
  self.SelectedFilters = {}
  self.bAutoAssistToolFocus = false
  self:ResetSiftForCurrentTab()
  self:ApplyModeView()
  self:RefreshList()
  self:RequestFocusAutoAssistList()
end

function M:ApplyModeView()
  self.WS_Bottom:SetActiveWidgetIndex(self.IsEdit and 1 or 0)
  self.WS_Btn:SetActiveWidgetIndex(self.IsEdit and 1 or 0)
  self:UpdateSaveButtonState()
  self:RefreshAutoAssistGamepadHints()
end

function M:HasPriorityChanges()
  for _, TargetType in ipairs({TARGET_CHAR, TARGET_WEAPON}) do
    for TargetId, IsPriority in pairs(self.DraftPriority[TargetType]) do
      if true == IsPriority ~= (true == self.ActualPriority[TargetType][TargetId]) then
        return true
      end
    end
  end
  return false
end

function M:UpdateSaveButtonState()
  if IsValid(self.Btn_Save) then
    self.Btn_Save:ForbidBtn(self.bSaving or not self:HasPriorityChanges())
  end
end

function M:BuildPriorityChanges()
  local Changes = {}
  for _, TargetType in ipairs({TARGET_CHAR, TARGET_WEAPON}) do
    for TargetId, IsPriority in pairs(self.DraftPriority[TargetType]) do
      local NewValue = true == IsPriority
      if NewValue ~= (true == self.ActualPriority[TargetType][TargetId]) then
        Changes[#Changes + 1] = {
          TargetType = TargetType,
          TargetId = TargetId,
          IsWarLike = NewValue
        }
      end
    end
  end
  return Changes
end

function M:SaveChanges()
  if not self.IsEdit or self.bSaving then
    return
  end
  local Changes = self:BuildPriorityChanges()
  if 0 == #Changes then
    return
  end
  self.bSaving = true
  self.SaveRequestSerial = self.SaveRequestSerial + 1
  local RequestSerial = self.SaveRequestSerial
  self:UpdateSaveButtonState()
  self:SaveNextPriorityChange(Changes, 1, RequestSerial)
end

function M:SaveNextPriorityChange(Changes, Index, RequestSerial)
  if RequestSerial ~= self.SaveRequestSerial or not IsValid(self) then
    return
  end
  if Index > #Changes then
    self.bSaving = false
    self:ExitEditMode()
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_SaveSuccessful"))
    return
  end
  local Change = Changes[Index]
  self.Avatar:SwitchArmoryTargetWarLike(function(Ret)
    if RequestSerial ~= self.SaveRequestSerial or not IsValid(self) then
      return
    end
    if not ErrorCode:Check(Ret) then
      self.bSaving = false
      self:UpdateSaveButtonState()
      return
    end
    local TargetMap = self.Avatar[Change.TargetType .. "s"]
    local Target = TargetMap and TargetMap[Change.TargetId]
    if Target then
      Target.IsWarLike = Change.IsWarLike
    end
    self.ActualPriority[Change.TargetType][Change.TargetId] = Change.IsWarLike
    self:SaveNextPriorityChange(Changes, Index + 1, RequestSerial)
  end, Change.TargetType, Change.TargetId, Change.IsWarLike)
end

function M:OnAutoAssistSwitchChanged(IsChecked)
  if not self.Avatar then
    return
  end
  self.Avatar:SwitchbAutoPhantomForBigWorld(IsChecked)
  if self.CurrentTab == TAB_WEAPON then
    self:RefreshList()
    self:RequestFocusAutoAssistList()
  else
    self:RefreshCurrentItemStatus()
  end
  self:RefreshOccupiedWarning()
  if IsValid(self.Owner) and self.Owner.UpdateAutoAssistEntry then
    self.Owner:UpdateAutoAssistEntry(IsChecked)
  end
end

function M:ShowDescription()
  UIManager(self):ShowCommonPopupUI(100192, {
    Title = GText("UI_ArmourySquad_AutoSummon"),
    LongText = GText("XieZhan_Rule"),
    AutoFocus = true,
    ShowBKeyClose = true
  }, self)
end

function M:HandleBack()
  if self.bSaving then
    return true
  end
  if self.IsEdit then
    self:ExitEditMode()
    return true
  end
  self:RequestClose()
  return true
end

function M:OnBGClick()
  self:RequestClose()
  return UIUtils.Handled
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if not UE4.UKismetInputLibrary.PointerEvent_IsMouseButtonDown(MouseEvent, UE4.EKeys.LeftMouseButton) then
    return UIUtils.Unhandled
  end
  return UIUtils.Handled
end

function M:HandleAutoAssistPC(InKeyName)
  if "Escape" == InKeyName then
    return self:HandleBack()
  end
  return self.SubTab:Handle_KeyEventOnPC(InKeyName)
end

function M:RequestClose()
  if self.bClosing or self.bSaving then
    return
  end
  self.bClosing = true
  if IsValid(self.Out) then
    self:PlayAnimation(self.Out)
  else
    self:OnOutAnimationFinished()
  end
end

function M:OnOutAnimationFinished()
  local Owner = self.Owner
  local IsEnabled = self.SwitchCheckBox:GetChecked()
  self:RemoveFromParent()
  if IsValid(Owner) and Owner.OnAutoAssistPanelClosed then
    Owner:OnAutoAssistPanelClosed(self, IsEnabled)
  end
end

function M:BP_GetDesiredFocusTarget()
  if self.IsEdit and self.bAutoAssistToolFocus then
    return self.Sort
  end
  if self.List_Item:GetNumItems() > 0 then
    return self.List_Item
  end
  return self
end

AssembleComponents(M)
return M
