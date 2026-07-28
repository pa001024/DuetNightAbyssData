require("UnLua")
local Model = require("BluePrints.UI.WBP.Activity.Widget.Weapon.WeaponVerifyUIModel")
local UIUtils = require("Utils.UIUtils")
local PageJumpFunctionConfig = require("Utils.PageJumpFunctionConfig")
local HyperWeaponUtils = require("Utils.HyperWeaponUtils")
local SS = Model.SlotState
local LevelDetail = {}
LevelDetail.__index = LevelDetail

function LevelDetail.New(Owner)
  local self = setmetatable({}, {
    __index = function(t, k)
      local v = rawget(t, k)
      v = v or LevelDetail[k] or Owner[k]
      return v
    end
  })
  self.Owner = Owner
  self.DungeonId = nil
  self.CurEditSlotType = nil
  self.SlotWidgets = {
    {
      Name = "Character",
      Type = Model.SlotType.Char,
      SaveKey = "CharUuid"
    },
    {
      Name = "Melee",
      Type = Model.SlotType.Melee,
      SaveKey = "MeleeWeaponUuid"
    },
    {
      Name = "Range",
      Type = Model.SlotType.Ranged,
      SaveKey = "RangedWeaponUuid"
    },
    {
      Name = "Pet",
      Type = Model.SlotType.Pet,
      SaveKey = "PetUniqueId"
    },
    {
      Name = "Roulette",
      Type = Model.SlotType.Affix,
      SaveKey = "AffixId"
    }
  }
  self.SlotInfos = {
    [Model.SlotType.Char] = {
      Name = "Char",
      Slot = "Character",
      Text = "ArchiveTitle_Char",
      OccupiedTip = "UI_WeaponVerify_Des2",
      Toast = "Ul_WeaponVerify_NoCharSelected",
      Armory = "Character",
      Sound = "event:/ui/armory/click_select_role"
    },
    [Model.SlotType.Melee] = {
      Name = "Melee",
      Slot = "Melee",
      Text = "ArchiveTitle_Meele",
      OccupiedTip = "UI_WeaponVerify_Des3",
      Toast = "Ul_WeaponVerify_NoWeapon1Selected",
      MissingToast = "UI_WeaponVerify_NoWeapon1",
      Armory = "MeeleWeapon",
      Sound = "event:/ui/armory/click_select_weapon"
    },
    [Model.SlotType.Ranged] = {
      Name = "Ranged",
      Slot = "Range",
      Text = "ArchiveTitle_Ranged",
      OccupiedTip = "UI_WeaponVerify_Des3",
      Toast = "Ul_WeaponVerify_NoWeapon2Selected",
      MissingToast = "UI_WeaponVerify_NoWeapon2",
      Armory = "RangedWeapon",
      Sound = "event:/ui/armory/click_select_weapon"
    },
    [Model.SlotType.Pet] = {
      Name = "Pet",
      Slot = "Pet",
      Text = "UI_Pet",
      OccupiedTip = "UI_WeaponVerify_Des6",
      Armory = "Pet",
      Sound = "event:/ui/common/click_select_pet"
    },
    [Model.SlotType.Affix] = {
      Name = "Affix",
      Slot = "Roulette",
      Text = "UI_WeaponVerify_Entry",
      OccupiedTip = "UI_WeaponVerify_Des5",
      Toast = "Ul_WeaponVerify_NoEntrySelected",
      Sound = "event:/ui/common/special_content_01_click"
    }
  }
  self.SlotSelectList = {}
  self.StaticDisplayListStates = {}
  self.StaticDisplayListResizeBound = {}
  local Platform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
  self.bInMobile = "Mobile" == Platform
  self:BindDetailButtons()
  self:InitDetailWidget()
  return self
end

function LevelDetail:Destroy()
  self:UnbindDetailButtons()
  self.ItemDetailsWidget = nil
end

function LevelDetail:GetZOrder()
  return self.Owner:GetZOrder()
end

function LevelDetail:Open(DungeonId)
  self.DungeonId = DungeonId
  self.CurEditSlotType = nil
  self.Owner:ShowDetailPanel()
  self:InitGamepadWidget()
  self:RefreshDetail()
  self:HideSelectList()
  self:UpdateUIStyleInPlatform()
end

function LevelDetail:OnEscKey()
  if self.CurEditSlotType then
    self:HideSelectList()
    return
  end
  self.Owner:ShowSelectPanel()
end

function LevelDetail:InitDetailWidget()
  self.ListBuff.TextTitle:SetText(GText("UI_Entry"))
  self.TextArmory:SetText(GText("UI_Armory"))
  self.TextEidt:SetText(GText("UI_AutoChess_Edit"))
  self.TextTipsTitle01:SetText(GText("UI_WeaponVerify_GlobalBuff"))
  self.TextTipsTitle02:SetText(GText("UI_WeaponVerify_LevelBuff"))
  self.TextTipsTitle03:SetText(GText("UI_WeaponVerify_LevelTarget"))
  self.TextTipsTitle04:SetText(GText("UI_WeaponVerify_Lineup"))
  self.TextTips02:SetText(GText("UI_WeaponVerify_Des1"))
  self.Panel_Level = self.TextLevel:GetParent()
  self.ScrollBox = self.List_Equipment:GetParent()
  self.OrderByDisplayNames = {
    "UI_LEVEL_SELECT"
  }
  self.OrderByDisplayNamesOnPet = {
    "UI_LEVEL_SELECT",
    "UI_RARITY_NAME"
  }
  self.OrderByAttrNames = {
    "Level",
    "Rarity",
    "SortPriority",
    "UnitId"
  }
  self.ArrowBtnLWin = self.ArrowBtnL:GetParent()
  self.ArrowBtnRWin = self.ArrowBtnR:GetParent()
  if self.ArrowBtnLWin == self.Panel_Conten02 then
    self.ArrowBtnLWin = self.ArrowBtnL
  end
  if self.ArrowBtnRWin == self.Panel_Conten02 then
    self.ArrowBtnRWin = self.ArrowBtnR
  end
  self:InitFilterList()
  self:InitStaticDisplayLists()
  self:InitItemDetailWidget()
end

function LevelDetail:InitStaticDisplayLists()
  self:SetupStaticDisplayList(self.List_Equipment)
  self:SetupStaticDisplayList(self.List_Equipment_1)
  self:SetupStaticDisplayList(self.List_Equipment_2)
end

function LevelDetail:SetupStaticDisplayList(ListWidget)
  if not IsValid(ListWidget) then
    return
  end
  ListWidget.bIsFocusable = false
  ListWidget.IsFocusable = false
  if ListWidget.DisableScroll then
    ListWidget:DisableScroll(true)
  end
  if ListWidget.DisableDrag then
    ListWidget:DisableDrag(true)
  end
  if ListWidget.SetWheelScrollMultiplier then
    ListWidget:SetWheelScrollMultiplier(0)
  end
  if ListWidget.SetScrollBarVisibility then
    ListWidget:SetScrollBarVisibility(ESlateVisibility.Collapsed)
  end
  if ListWidget.SetConsumeMouseWheel and EConsumeMouseWheel then
    ListWidget:SetConsumeMouseWheel(EConsumeMouseWheel.Never)
  end
  if ListWidget.SetNavigationRuleBase then
    ListWidget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    ListWidget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    ListWidget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    ListWidget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  end
  if ListWidget.BP_OnEntryGenerated and not self.StaticDisplayListResizeBound[ListWidget] then
    ListWidget.BP_OnEntryGenerated:Add(self.Owner, function(Owner, Widget)
      Owner.Detail:OnStaticDisplayListEntryGenerated(ListWidget, Widget)
    end)
    self.StaticDisplayListResizeBound[ListWidget] = true
  end
end

function LevelDetail:ResetStaticDisplayListHeight(ListWidget, ItemCount)
  if not IsValid(ListWidget) then
    return
  end
  self.StaticDisplayListStates[ListWidget] = {
    ExpectedItemCount = ItemCount or 0,
    GeneratedItemCount = 0,
    TotalHeight = 0
  }
  if self.StaticDisplayListStates[ListWidget].ExpectedItemCount <= 0 then
    self:SetStaticDisplayListHeight(ListWidget, 1)
  end
end

function LevelDetail:SetStaticDisplayListHeight(ListWidget, Height)
  if not IsValid(ListWidget) or Height <= 0 then
    return
  end
  if ListWidget.SetHeightOverride then
    ListWidget:SetHeightOverride(Height)
    return
  end
  local Parent = ListWidget.GetParent and ListWidget:GetParent() or nil
  if IsValid(Parent) and Parent.SetHeightOverride then
    Parent:SetHeightOverride(Height)
    return
  end
  local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(ListWidget)
  if IsValid(CanvasSlot) then
    local Size = CanvasSlot:GetSize()
    CanvasSlot:SetSize(FVector2D(Size.X, Height))
    return
  end
  local Slot = ListWidget.Slot
  if Slot and Slot.GetSize and Slot.SetSize then
    local Size = Slot:GetSize()
    if Size and Size.X then
      Slot:SetSize(FVector2D(Size.X, Height))
    end
  end
end

function LevelDetail:OnStaticDisplayListEntryGenerated(ListWidget, Widget)
  if not IsValid(ListWidget) or not IsValid(Widget) then
    return
  end
  if Widget.ForceLayoutPrepass then
    Widget:ForceLayoutPrepass()
  end
  local State = self.StaticDisplayListStates and self.StaticDisplayListStates[ListWidget]
  if not State then
    return
  end
  State.GeneratedItemCount = (State.GeneratedItemCount or 0) + 1
  State.TotalHeight = (State.TotalHeight or 0) + Widget:GetDesiredSize().Y
  local ExpectedCount = State.ExpectedItemCount or 0
  if ExpectedCount <= 0 then
    return
  end
  if ExpectedCount <= State.GeneratedItemCount then
    local EntrySpacing = ListWidget.EntrySpacing or 0
    local Height = State.TotalHeight + math.max(ExpectedCount - 1, 0) * EntrySpacing
    self:SetStaticDisplayListHeight(ListWidget, Height)
  end
end

function LevelDetail:InitFilterList()
  self.CharFilterTags, self.CharFilterNames = UIUtils.GetAllElementTypes()
  self.CharFilterIcons = {}
  for _, Tag in ipairs(self.CharFilterTags) do
    local IconName = "Armory_" .. Tag
    table.insert(self.CharFilterIcons, "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName)
  end
  self.MeleeFilterTags, self.MeleeFilterNames, self.RangedFilterTags, self.RangedFilterNames = UIUtils.GetAllWeaponTags()
  self.MeleeFilterIcons = {}
  for _, Tag in ipairs(self.MeleeFilterTags) do
    local Data = DataMgr.WeaponTag[Tag]
    table.insert(self.MeleeFilterIcons, Data and Data.Icon)
  end
  self.RangedFilterIcons = {}
  for _, Tag in ipairs(self.RangedFilterTags) do
    local Data = DataMgr.WeaponTag[Tag]
    table.insert(self.RangedFilterIcons, Data and Data.Icon)
  end
end

function LevelDetail:GetListSlotName(SlotType)
  local Slot = self.SlotInfos[SlotType]
  return Slot and Slot.Name
end

function LevelDetail:CreateFilters(InTags, InTexts, InIcons)
  local Filters = {}
  for i, _ in ipairs(InTags or {}) do
    table.insert(Filters, {
      Tag = InTags[i],
      Text = InTexts and InTexts[i],
      Icon = InIcons and InIcons[i]
    })
  end
  return Filters
end

function LevelDetail:ApplyBuildListCompatibility()
  local ListBuild = self.List_Build
  if not IsValid(ListBuild) then
    return
  end
  ListBuild._SetTitle = ListBuild._SetTitle or ListBuild.SetTitle
  ListBuild.Weapon_Recommend = ListBuild.Text_Pet
  
  function ListBuild.SetTitle(ListWidget, Title)
    if self.CurEditSlotType == Model.SlotType.Pet then
      Title = GText("Ul_WeaponVerify_PetTitle")
    else
      Title = nil
    end
    ListWidget:_SetTitle(Title)
  end
  
  function ListBuild.SetSubTitle()
  end
end

function LevelDetail:GetBuildListView()
  local ListBuild = self.List_Build
  if not IsValid(ListBuild) then
    return nil
  end
  return ListBuild.List_Select or ListBuild.TileView_Select_Role
end

function LevelDetail:FocusDefaultTarget()
  if self.CurEditSlotType and self.CurEditSlotType ~= Model.SlotType.Affix and IsValid(self.List_Build) and self.List_Build.SetFocusToList then
    self.List_Build:SetFocusToList()
    return
  end
  local FocusWidget = self:BP_GetDesiredFocusTarget()
  if IsValid(FocusWidget) then
    FocusWidget:SetFocus()
  end
end

function LevelDetail:RequestRestoreDefaultFocus(ExpectedSlotType)
  self.Owner:AddTimer(0.01, function()
    if nil ~= ExpectedSlotType and self.CurEditSlotType ~= ExpectedSlotType then
      return
    end
    self:FocusDefaultTarget()
  end, false, 0, "RestoreActivityWeaponDefaultFocus", true)
end

function LevelDetail:FocusListFirstItem(ListView)
  if not IsValid(ListView) then
    return
  end
  ListView:SetFocus()
  local FirstItem
  if ListView.GetItemAt then
    FirstItem = ListView:GetItemAt(0)
  end
  if FirstItem then
    if ListView.BP_CancelScrollIntoView then
      ListView:BP_CancelScrollIntoView()
    end
    if ListView.BP_SetSelectedItem then
      ListView:BP_SetSelectedItem(FirstItem)
    end
    if ListView.BP_ScrollItemIntoView then
      ListView:BP_ScrollItemIntoView(FirstItem)
    end
    if ListView.BP_NavigateToItem then
      ListView:BP_NavigateToItem(FirstItem)
      return
    end
  end
  if ListView.NavigateToIndex then
    ListView:NavigateToIndex(0)
  end
end

function LevelDetail:ResetListScrollToStart(ListView)
  if not IsValid(ListView) then
    return
  end
  if ListView.BP_CancelScrollIntoView then
    ListView:BP_CancelScrollIntoView()
  end
  if ListView.ScrollToTop then
    ListView:ScrollToTop()
    return
  end
  if ListView.ScrollToStart then
    ListView:ScrollToStart()
    return
  end
  if ListView.SetScrollOffset then
    ListView:SetScrollOffset(0)
    return
  end
  if ListView.NavigateToIndex and ListView.GetNumItems and ListView:GetNumItems() > 0 then
    ListView:NavigateToIndex(0)
  end
end

function LevelDetail:RequestResetSelectListScroll(ExpectedSlotType, ListView)
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    return
  end
  self.Owner:AddTimer(0.01, function()
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
      return
    end
    if nil ~= ExpectedSlotType and self.CurEditSlotType ~= ExpectedSlotType then
      return
    end
    self:ResetListScrollToStart(ListView)
  end, false, 0, "ResetActivityWeaponSelectListScroll", true)
end

function LevelDetail:RequestFocusFirstSelectItem(ExpectedSlotType, ListView)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  self.Owner:AddTimer(0.03, function()
    if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
      return
    end
    if nil ~= ExpectedSlotType and self.CurEditSlotType ~= ExpectedSlotType then
      return
    end
    self:FocusListFirstItem(ListView)
  end, false, 0, "FocusActivityWeaponFirstSelectItem", true)
end

function LevelDetail:MarkRestoreFocusOnReturn()
  self.bNeedRestoreFocusOnReturn = true
end

function LevelDetail:InitItemDetailWidget()
  self.List_Build = self.WBP_Activity_Weapon_Listing or self.Weapon_Listing
  self.List_Build.HB_Main:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self:ApplyBuildListCompatibility()
  self.ItemDetailsWidget = UIManager(self):_CreateWidgetNew("ItemDetailsMain")
  self.List_Build:AttachTipsWidget(self.ItemDetailsWidget)
  self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.ItemDetailsWidget.Key_Confirm:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.ItemDetailsWidget.Key_Back:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.ItemDetailsWidget.bIsFocusable = false
  self.bItemDetailsShowed = false
  self.ItemDetailsContent = nil
end

function LevelDetail:InitGamepadWidget()
  if self.bInMobile then
    return
  end
  self.Character:SetFocus()
  if not self.bInitGamepadWidget then
    self.BtnGo:SetGamePadImg("X")
    self.BtnRes:SetGamePadImg("LS")
    self.KeyImgTips:CreateGamepadKey("View")
    self.WBP_Com_KeyImg_BtnGrowth:CreateGamepadKey("RS")
    self.WBP_Com_KeyImg_BtnEdit:CreateGamepadKey("Down")
    self.WBP_Com_KeyImg_SlotRight:CreateGamepadKey("RT")
    self.WBP_Com_KeyImg_SlotLeft:CreateGamepadKey("LT")
    self.WBP_Com_KeyImg_ArrowBtnL:CreateGamepadKey("LB")
    self.WBP_Com_KeyImg_ArrowBtnR:CreateGamepadKey("RB")
    self.bInitGamepadWidget = true
    self.Character:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self.Roulette:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    for _, Slot in ipairs(self.SlotWidgets) do
      local SlotWidget = self[Slot.Name]
      if SlotWidget then
        SlotWidget.bIsFocusable = true
        SlotWidget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
        SlotWidget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
      end
    end
  end
end

function LevelDetail:MakeSquadInfo(LevelInfo)
  LevelInfo = LevelInfo or {}
  return {
    CharUuid = LevelInfo.CharUuid,
    MeleeWeaponUuid = LevelInfo.MeleeWeaponUuid,
    RangedWeaponUuid = LevelInfo.RangedWeaponUuid,
    PetUniqueId = LevelInfo.PetUniqueId or 0,
    AffixId = LevelInfo.AffixId or 0,
    FinishStar = LevelInfo.FinishStar or 0
  }
end

function LevelDetail:HandleTmpDungeonResult(bExchange)
  local EventId = self.EventId
  local DungeonId = self.PendingTmpResultDungeonId
  if not EventId or not DungeonId then
    return
  end
  if self.bEnsuringTmpDungeonResult then
    return
  end
  self.bEnsuringTmpDungeonResult = true
  Model.EnsureDungeonResult(EventId, DungeonId, bExchange, function(ErrCode)
    self.bEnsuringTmpDungeonResult = false
    self.PendingTmpResultDungeonId = nil
    if 0 ~= ErrCode then
      UIManager(self):ShowError(ErrCode, 1.0, "CommonToastMain")
      return
    end
    Model.RefreshStarRewardReddot(EventId)
    if self.DungeonId == DungeonId then
      self:RefreshDetail()
      self:RequestRestoreDefaultFocus(self.CurEditSlotType)
    end
    self.Owner:OnDungeonReset()
  end)
end

function LevelDetail:TryShowTmpDungeonResultPopup()
  local EventId = self.EventId
  local DungeonId = self.DungeonId
  if not (EventId and DungeonId) or self.PendingTmpResultDungeonId == DungeonId then
    return
  end
  local OldInfo = Model.GetLevelSaveInfo(EventId, DungeonId)
  local TmpInfo = Model.GetTmpLevelInfo(EventId, DungeonId)
  local OldFinishStar = OldInfo and OldInfo.FinishStar or 0
  local TmpFinishStar = TmpInfo and TmpInfo.FinishStar or 0
  if OldFinishStar < 1 or TmpFinishStar < 1 then
    return
  end
  local Props = {
    "AffixId",
    "PetUniqueId",
    "MeleeWeaponUuid",
    "RangedWeaponUuid",
    "CharUuid"
  }
  for Index, Prop in ipairs(Props) do
    if OldInfo[Prop] ~= TmpInfo[Prop] and "CharUuid" == Prop then
      local Avatar = Model.GetAvatar()
      if Avatar then
        local Char1 = Avatar.Chars[OldInfo[Prop]]
        local Char2 = Avatar.Chars[TmpInfo[Prop]]
        local AvatarUtils = require("BluePrints.Client.AvatarUtils")
        if Char1 and Char2 and AvatarUtils:IsCharacterAttributeSwitchSameGroup(Char1.CharId, Char2.CharId) then
          return
        end
      end
    end
  end
  self.PendingTmpResultDungeonId = DungeonId
  local bHandled = false
  
  local function EnsureTmpResult(bExchange)
    if bHandled then
      return
    end
    bHandled = true
    self:HandleTmpDungeonResult(bExchange)
  end
  
  self:ShowRefreshConfirmPopup({
    EventId = EventId,
    DungeonId = DungeonId,
    HideDialogTip = true,
    OldSquad = self:MakeSquadInfo(OldInfo),
    NewSquad = self:MakeSquadInfo(TmpInfo),
    ShortText = GText("UI_WeaponVerify_Des7"),
    OnConfirm = function()
      EnsureTmpResult(true)
    end,
    OnCancel = function()
      EnsureTmpResult(false)
    end,
    OnCloseCallbackObj = self,
    OnCloseCallbackFunction = function()
      EnsureTmpResult(false)
    end
  })
end

function LevelDetail:RefreshDetail()
  local DungeonId = self.DungeonId
  if not DungeonId then
    return
  end
  local IndexText = Model.GetLevelNumber(DungeonId)
  local LevelName = Model.GetLevelName(DungeonId)
  self.TextTitle:SetText(LevelName)
  self.TextLevel:SetText(LevelName)
  self.TextLevelIndex:SetText(IndexText)
  local bBoss = 2 == Model.GetLevelType(DungeonId)
  self.TextInformation:SetText(bBoss and GText("UI_WeaponVerify_LevelType2") or GText("UI_WeaponVerify_LevelType1"))
  local Lv = Model.GetRecommendLevel(DungeonId)
  self.TextRecommend:SetText(string.format(GText("UI_Recommend_Level"), Lv))
  Model.InitEditSelect(self.EventId, self.DungeonId)
  self:RefreshDetailStars()
  self:RefreshSlots()
  self:RefreshBuffLists(DungeonId)
  self:RefreshStarGoals(DungeonId)
  if self.ScrollBox.SetScrollOffset then
    self.ScrollBox:SetScrollOffset(0)
  end
  self:RefreshArrowBtns()
  self.Panel_List:SetVisibility(ESlateVisibility.Collapsed)
  self.Panel_Buff:SetVisibility(ESlateVisibility.Collapsed)
  self:TryShowTmpDungeonResultPopup()
end

function LevelDetail:RefreshDetailStars()
  local DungeonId = self.DungeonId
  local FinishStar = Model.GetLevelStar(self.EventId, DungeonId)
  local MaxStar = Model.GetMaxStar(DungeonId)
  local StarNames = {
    "Star01",
    "Star02",
    "Star03"
  }
  for i = 1, 3 do
    local StarWidget = self[StarNames[i]]
    if IsValid(StarWidget) then
      if i > MaxStar then
        StarWidget:SetVisibility(ESlateVisibility.Collapsed)
      else
        local IsReached = i <= FinishStar
        StarWidget:SetVisibility(ESlateVisibility.HitTestInvisible)
        StarWidget.Star:SetVisibility(IsReached and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed)
        StarWidget.StarEmpty:SetVisibility(IsReached and ESlateVisibility.Collapsed or ESlateVisibility.HitTestInvisible)
      end
    end
  end
end

function LevelDetail:RefreshSlots()
  local EventId = self.EventId
  local DungeonId = self.DungeonId
  local Sel = Model.GetEditSelect()
  local IsFinished = Model.IsLevelFinished(EventId, DungeonId)
  local IsSelectAll = true
  self.MissingWeaponType = nil
  for _, Info in ipairs(self.SlotWidgets) do
    local SlotWidget = self[Info.Name]
    if IsValid(SlotWidget) then
      local Val = Model.GetEditSelectValue(Info.Type)
      local State = Model.GetSlotState(Info.Type, Val)
      if State ~= SS.Filled and Info.Type ~= Model.SlotType.Pet then
        IsSelectAll = false
      end
      if State == SS.Missing and not self.MissingWeaponType and Info.Type ~= Model.SlotType.Pet then
        self.MissingWeaponType = Info.Type
      end
      SlotWidget:SetData({
        SlotType = Info.Type,
        State = State,
        IconPath = Model.GetSlotIconPath(Info.Type, Val),
        Owner = self,
        OnClick = self.OnClickSlot,
        IsReadOnly = false
      })
    end
  end
  self.BtnEdit:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.BtnRes:SetVisibility(IsFinished and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
  self.BtnGo:ForbidBtn(not IsSelectAll)
  self:UpdateUIStyleInPlatform()
end

function LevelDetail:RefreshBuffLists(DungeonId)
  local GlobalIds = Model.GetGlobalBuffIds(DungeonId)
  local LevelIds = Model.GetLevelBuffIds(DungeonId)
  
  local function FillList(ListWidget, BuffIds)
    if not ListWidget then
      return
    end
    self:ResetStaticDisplayListHeight(ListWidget, #BuffIds)
    ListWidget:ClearListItems()
    for _, BuffId in ipairs(BuffIds) do
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.BuffId = BuffId
      Content.EffectText = Model.GetBuffDesc(BuffId)
      ListWidget:AddItem(Content)
    end
  end
  
  FillList(self.List_Equipment_1, GlobalIds)
  FillList(self.List_Equipment_2, LevelIds)
end

function LevelDetail:RefreshStarGoals(DungeonId)
  if not IsValid(self.List_Equipment) then
    return
  end
  self.List_Equipment:ClearListItems()
  local StarTimes = Model.GetStarTimes(DungeonId)
  self:ResetStaticDisplayListHeight(self.List_Equipment, #StarTimes)
  for i, Cond in ipairs(StarTimes) do
    local CondText
    if -1 == Cond then
      CondText = GText("WeaponVerify_Target_FinishLevel")
    else
      CondText = string.format(GText("WeaponVerify_Target_LevelLimitTime"), Cond)
    end
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.StarIndex = i
    Content.CondText = CondText
    Content.IsReached = i <= Model.GetLevelStar(self.EventId, DungeonId)
    self.List_Equipment:AddItem(Content)
  end
end

function LevelDetail:RefreshArrowBtns()
  local Prev = self:GetAdjacentDungeon(self.DungeonId, -1)
  local Next = self:GetAdjacentDungeon(self.DungeonId, 1)
  self.ArrowBtnL:ForbidBtn(not Prev)
  self.ArrowBtnR:ForbidBtn(not Next)
  if not self.bInMobile then
    self.WBP_Com_KeyImg_ArrowBtnL:SetForbidKey(not Prev)
    self.WBP_Com_KeyImg_ArrowBtnR:SetForbidKey(not Next)
  end
end

function LevelDetail:OnClickSlot(SlotType)
  if self.CurEditSlotType == SlotType then
    return
  end
  local Val = Model.GetEditSelectValue(SlotType)
  if not Val or 0 == Val then
    AudioManager(self.Owner):PlayUISound(self.Owner, "event:/ui/common/click_mid", nil, nil)
  else
    local SlotInfo = self.SlotInfos[SlotType]
    if SlotInfo.Sound then
      AudioManager(self.Owner):PlayUISound(self.Owner, SlotInfo.Sound, nil, nil)
    end
  end
  self:ShowSelectList(SlotType)
end

function LevelDetail:ShowSelectList(SlotType)
  AudioManager(self.Owner):PlayUISound(self.Owner, "event:/ui/common/sub_panel_expand", "WeaponVerifySelectList", nil)
  self.CurEditSlotType = SlotType
  self.Panel_Level:SetVisibility(ESlateVisibility.Collapsed)
  self.ArrowBtnLWin:SetVisibility(ESlateVisibility.Collapsed)
  self.ArrowBtnRWin:SetVisibility(ESlateVisibility.Collapsed)
  self.BtnReward:SetVisibility(ESlateVisibility.Collapsed)
  self:RefreshCurrentSelectList()
  self:RefreshSlots()
end

function LevelDetail:RefreshCurrentSelectList()
  local SlotType = self.CurEditSlotType
  if not SlotType then
    return
  end
  self:ShowItemDetails(false)
  if SlotType == Model.SlotType.Affix then
    self.Panel_List:SetVisibility(ESlateVisibility.Collapsed)
    self.Panel_Buff:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Owner:PlayBuffIn()
    self.ListBuff:Init(self, {
      EventId = self.EventId,
      DungeonId = self.DungeonId,
      SlotType = SlotType,
      ItemContents = Model.GetSelectableItems(self.EventId, self.DungeonId, SlotType),
      OnSelect = self.OnSelectBuff
    })
    self:RequestResetSelectListScroll(SlotType, self.ListBuff.ListRoom)
    self:RequestFocusFirstSelectItem(SlotType, self.ListBuff.ListRoom)
    return
  end
  self.Panel_List:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Owner:PlayListIn()
  self.Panel_Buff:SetVisibility(ESlateVisibility.Collapsed)
  local SlotName = self:GetListSlotName(SlotType)
  local Filters
  if SlotName and self[SlotName .. "FilterTags"] then
    Filters = self:CreateFilters(self[SlotName .. "FilterTags"], self[SlotName .. "FilterNames"], self[SlotName .. "FilterIcons"])
  end
  self.List_Build:BindEvents(self, {
    OnListItemClicked = self.OnSelectItem,
    OnEntryInitialized = self.OnSelectEntryInitialized,
    SortFuncion = self.SortItemContents,
    FilterFunction = self.FilterItemContents
  })
  self.List_Build:Init(self, {
    Filters = Filters,
    SlotType = SlotType,
    SlotName = SlotName,
    EventId = self.EventId,
    DungeonId = self.DungeonId,
    ItemContents = Model.GetSelectableItems(self.EventId, self.DungeonId, SlotType),
    OrderByDisplayNames = SlotType == Model.SlotType.Pet and self.OrderByDisplayNamesOnPet or self.OrderByDisplayNames,
    SortType = nil
  })
  local BuildListView = self:GetBuildListView()
  self:RequestResetSelectListScroll(SlotType, BuildListView)
  self:RequestFocusFirstSelectItem(SlotType, BuildListView)
end

function LevelDetail:SortItemContents(InOutContentArray, SortByIdx, SortType)
  local SlotType = self.CurEditSlotType
  local OrderByAttrNames = {
    "SortLevel",
    "Rarity",
    "SortId"
  }
  local SortByAttrNames = {
    OrderByAttrNames[SortByIdx] or OrderByAttrNames[1]
  }
  for Index, AttrName in ipairs(OrderByAttrNames) do
    if Index ~= SortByIdx then
      table.insert(SortByAttrNames, AttrName)
    end
  end
  table.sort(InOutContentArray, function(a, b)
    if SlotType ~= Model.SlotType.Pet and a.SortOwned ~= b.SortOwned then
      return (a.SortOwned or 0) > (b.SortOwned or 0)
    end
    local ASelected = a.SortSelected or 0
    local BSelected = b.SortSelected or 0
    if ASelected ~= BSelected then
      return ASelected > BSelected
    end
    local AUnlocked = a.SortUnlocked or 0
    local BUnlocked = b.SortUnlocked or 0
    if AUnlocked ~= BUnlocked then
      return AUnlocked > BUnlocked
    end
    for _, AttrName in ipairs(SortByAttrNames) do
      local AValue = a[AttrName] or 0
      local BValue = b[AttrName] or 0
      if AValue ~= BValue then
        if SortType == CommonConst.ASC then
          return AValue < BValue
        end
        return AValue > BValue
      end
    end
    return false
  end)
end

function LevelDetail:OnSelectEntryInitialized(Content, EntryUI)
  if not Content or not EntryUI then
    return
  end
  Content.SelfWidget = EntryUI
  self:RefreshSelectEntryState(Content, EntryUI)
end

function LevelDetail:RefreshSelectEntryState(Content, EntryUI)
  EntryUI:SetItemComItemOccupied(Content.bOccupied)
  EntryUI:SetItemSelect(Content.bSelectTag)
  EntryUI:SetSelected(Content.bSelectTag)
end

function LevelDetail:FilterItemContents(InContentArray, FilterIdxes)
  local SlotType = self.CurEditSlotType
  local SlotName = self:GetListSlotName(SlotType)
  if not SlotName then
    return InContentArray
  end
  local FilterTags = self[SlotName .. "FilterTags"]
  if not (FilterTags and FilterIdxes) or #FilterIdxes <= 0 then
    return InContentArray
  end
  local ST = Model.SlotType
  local FilteredItems = {}
  local FilterFunc
  if SlotType == ST.Char then
    function FilterFunc(FilterTag, Content)
      local Data = DataMgr.BattleChar and DataMgr.BattleChar[Content.UnitId]
      
      return Data and FilterTag == Data.Attribute
    end
  elseif SlotType == ST.Melee or SlotType == ST.Ranged then
    function FilterFunc(FilterTag, Content)
      local Data = DataMgr.BattleWeapon and DataMgr.BattleWeapon[Content.UnitId]
      
      for _, Tag in pairs(Data and Data.WeaponTag or {}) do
        if Tag == FilterTag then
          return true
        end
      end
      return false
    end
  elseif SlotType == ST.Pet then
    function FilterFunc()
      return true
    end
  end
  if FilterFunc then
    for _, Content in ipairs(InContentArray or {}) do
      for _, Idx in ipairs(FilterIdxes) do
        if FilterFunc(FilterTags[Idx], Content) then
          table.insert(FilteredItems, Content)
          break
        end
      end
    end
  end
  return FilteredItems
end

function LevelDetail:ShowItemDetails(bShow, Content, bPlayOut)
  if bShow then
    if self.ItemDetailsContent ~= Content then
      self.ItemDetailsWidget:RefreshItemInfo(Content, true)
    end
    self.ItemDetailsWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.ItemDetailsWidget:StopAnimation(self.ItemDetailsWidget.Out)
    self.ItemDetailsWidget:PlayAnimation(self.ItemDetailsWidget.In)
    self.bItemDetailsShowed = true
  elseif self.ItemDetailsWidget then
    self.ItemDetailsWidget:SetVisibility(ESlateVisibility.Collapsed)
    if bPlayOut then
      self.ItemDetailsWidget:StopAnimation(self.ItemDetailsWidget.In)
      self.ItemDetailsWidget:PlayAnimation(self.ItemDetailsWidget.Out)
    end
    self.bItemDetailsShowed = false
  end
  self.ItemDetailsContent = Content
end

function LevelDetail:GetContentSelectValue(Content)
  return Content.UniqueId or Content.UnitId
end

function LevelDetail:SyncSelectContentState(Content, SlotType, SelectedValue)
  if not Content then
    return
  end
  local Value = self:GetContentSelectValue(Content)
  Content.bSelectTag = nil ~= Value and 0 ~= Value and Value == SelectedValue
  Content.bOccupied = nil ~= Model.GetLockedDungeonBySlot(self.EventId, SlotType, Value, self.DungeonId)
  Content.SortSelected = Content.bSelectTag and 1 or 0
  Content.SortUnlocked = Content.bOccupied and 0 or 1
end

function LevelDetail:RefreshSelectContentWidget(Content)
  local EntryUI = Content and Content.SelfWidget
  if not IsValid(EntryUI) then
    return
  end
  self:RefreshSelectEntryState(Content, EntryUI)
end

function LevelDetail:RefreshCurrentSelectState()
  local SlotType = self.CurEditSlotType
  if not SlotType then
    return
  end
  local SelectedValue = Model.GetEditSelectValue(SlotType)
  local ST = Model.SlotType
  if SlotType == ST.Affix then
    return
  end
  local ItemContents = self.List_Build.AllItemContents or self.List_Build.FilteredContents or {}
  for _, Content in ipairs(ItemContents) do
    self:SyncSelectContentState(Content, SlotType, SelectedValue)
    self:RefreshSelectContentWidget(Content)
  end
end

function LevelDetail:ApplySlotSelection(SlotType, Content)
  self.SlotSelectList[SlotType] = Content
  Model.SetSlotSelection(self.EventId, self.DungeonId, SlotType, Content)
  self:RefreshCurrentSelectState()
  self:RefreshSlots()
end

function LevelDetail:GetHyperWeaponConflictSlotType(SlotType)
  local ST = Model.SlotType
  if SlotType == ST.Melee then
    return ST.Ranged
  end
  if SlotType == ST.Ranged then
    return ST.Melee
  end
  return nil
end

function LevelDetail:IsHyperWeaponContent(Content)
  return Content and Content.UnitId and HyperWeaponUtils.IsHyperWeapon(Content.UnitId)
end

function LevelDetail:HandleHyperWeaponSelection(SlotType, Content)
  if not self:IsHyperWeaponContent(Content) then
    return
  end
  local ConflictSlotType = self:GetHyperWeaponConflictSlotType(SlotType)
  if not ConflictSlotType then
    return
  end
  local ConflictValue = Model.GetEditSelectValue(ConflictSlotType)
  if not ConflictValue then
    return
  end
  local Avatar = Model.GetAvatar()
  local ConflictWeapon = Avatar and Avatar.Weapons and Avatar.Weapons[ConflictValue]
  if not ConflictWeapon or not HyperWeaponUtils.IsHyperWeapon(ConflictWeapon.WeaponId) then
    return
  end
  self.SlotSelectList[ConflictSlotType] = nil
  Model.SetEditSelect(ConflictSlotType, nil)
  UIManager(self):ShowUITip("CommonToastMain", GText("UI_HyperWeapon_CannotEquipAtSameTime"))
end

function LevelDetail:GetSlotDisplayName(SlotType)
  local Slot = self.SlotInfos[SlotType]
  if Slot then
    return GText(Slot.Text)
  end
  return ""
end

function LevelDetail:HandleLockedSelection(SlotType, Content)
  local Value = self:GetContentSelectValue(Content)
  local LockedDungeon = Content and Model.GetLockedDungeonBySlot(self.EventId, SlotType, Value, self.DungeonId)
  if not LockedDungeon then
    return false
  end
  local OldInfo = Model.GetLevelSaveInfo(self.EventId, LockedDungeon) or {}
  local LevelName = Model.GetLevelName(LockedDungeon)
  local SlotInfo = self.SlotInfos[SlotType]
  local SlotName = SlotInfo and GText(SlotInfo.Text)
  local OccupiedTip = SlotInfo and GText(SlotInfo.OccupiedTip)
  
  local function ConfirmResetLockedDungeon()
    Model.ResetDungeon(self.EventId, LockedDungeon, function(ErrCode)
      if 0 ~= ErrCode then
        UIManager(self):ShowError(ErrCode, 1.0, "CommonToastMain")
        return
      end
      local LevelName = Model.GetLevelName(LockedDungeon)
      UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_WeaponVerify_ResetFinish"), LevelName), 1.5)
      self:ApplySlotSelection(SlotType, Content)
      if IsValid(self.Owner) and self.Owner.OnDungeonReset then
        local bInDetail = self.Owner.bInDetail
        self.Owner.bInDetail = false
        self.Owner:OnDungeonReset()
        self.Owner.bInDetail = bInDetail
      end
    end)
  end
  
  self:ShowRefreshConfirmPopup({
    EventId = self.EventId,
    DungeonId = LockedDungeon,
    OldSquad = {
      CharUuid = OldInfo.CharUuid,
      MeleeWeaponUuid = OldInfo.MeleeWeaponUuid,
      RangedWeaponUuid = OldInfo.RangedWeaponUuid,
      PetUniqueId = OldInfo.PetUniqueId or 0,
      AffixId = OldInfo.AffixId or 0,
      FinishStar = OldInfo.FinishStar or 0
    },
    NewSquad = {FinishStar = 0},
    ShortText = string.format(OccupiedTip, LevelName),
    OnConfirm = ConfirmResetLockedDungeon
  }, Content)
  return true
end

function LevelDetail:FocusSelectItem(Content)
  self:RequestRestoreDefaultFocus(self.CurEditSlotType)
end

function LevelDetail:ReceiveEnterStateSelf(StackAction)
  if 1 ~= StackAction then
    return
  end
  if self.bNeedRestoreFocusOnReturn then
    self.bNeedRestoreFocusOnReturn = false
    self:RefreshCurrentSelectList()
    self:RequestRestoreDefaultFocus(self.CurEditSlotType)
  end
end

function LevelDetail:ShowDetailPopup(PopupId, Params, RestoreContent)
  Params = Params or {}
  local OriginCloseObj = Params.OnCloseCallbackObj
  local OriginCloseFunc = Params.OnCloseCallbackFunction
  Params.OnCloseCallbackObj = self
  
  function Params.OnCloseCallbackFunction(_, Data, PopupWidget)
    if OriginCloseFunc then
      OriginCloseFunc(OriginCloseObj or self, Data, PopupWidget)
    end
    self:FocusSelectItem(RestoreContent)
  end
  
  UIManager(self):ShowCommonPopupUI(PopupId, Params, self)
end

function LevelDetail:ShowCommonConfirmPopup(PopupId, ShortText, OnConfirm, RestoreContent)
  self:ShowDetailPopup(PopupId, {ShortText = ShortText, RightCallbackFunction = OnConfirm}, RestoreContent)
end

function LevelDetail:ShowRefreshConfirmPopup(Params, RestoreContent)
  Params = Params or {}
  Params.RightCallbackFunction = Params.RightCallbackFunction or Params.OnConfirm
  Params.LeftCallbackFunction = Params.LeftCallbackFunction or Params.OnCancel
  self:ShowDetailPopup(100410, Params, RestoreContent)
end

function LevelDetail:ShowJumpConfirmPopup(ShortText, OnConfirm, RestoreContent)
  self:ShowCommonConfirmPopup(100408, ShortText, OnConfirm, RestoreContent)
end

function LevelDetail:HandleUnownedSelection(SlotType, Content)
  if not Content or 0 ~= Content.SortOwned then
    return false
  end
  self:ShowJumpConfirmPopup(GText("UI_WeaponVerify_ToArmory"), function()
    local Slot = self.SlotInfos[SlotType]
    if Slot and Slot.Armory then
      self:MarkRestoreFocusOnReturn()
      PageJumpFunctionConfig.JumpToArmory(Slot.Armory, "Info", Content.UnitId)
    end
  end, Content)
  return true
end

function LevelDetail:OnSelectBuff(AffixId, Content)
  if not AffixId then
    return
  end
  AudioManager(self.Owner):PlayUISound(self.Owner, "event:/ui/common/special_content_01_click", nil, nil)
  Content = Content or {AffixId = AffixId}
  if self:HandleLockedSelection(Model.SlotType.Affix, Content) then
    return
  end
  self:ApplySlotSelection(Model.SlotType.Affix, Content)
end

function LevelDetail:OnSelectItem(Content)
  if not Content then
    return
  end
  local SlotType = self.CurEditSlotType
  if IsValid(self.List_Build) and self.List_Build.Params and self.List_Build.Params.SlotType then
    SlotType = self.List_Build.Params.SlotType
  end
  if not SlotType then
    return
  end
  if self:HandleUnownedSelection(SlotType, Content) then
    return
  end
  if self:HandleLockedSelection(SlotType, Content) then
    return
  end
  if not self:GetContentSelectValue(Content) then
    return
  end
  self:ShowItemDetails(SlotType ~= Model.SlotType.Char, Content, true)
  self:HandleHyperWeaponSelection(SlotType, Content)
  self:ApplySlotSelection(SlotType, Content)
end

function LevelDetail:HideSelectList()
  local PrevSlotType = self.CurEditSlotType
  self.CurEditSlotType = nil
  local CurEditSlotUI = self.CurEditSlotUI
  self:ShowItemDetails(false)
  self:UpdateUIStyleInPlatform()
  if CurEditSlotUI then
    CurEditSlotUI:SetFocus()
  end
  self:RefreshArrowBtns()
  self.ArrowBtnLWin:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.ArrowBtnRWin:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  if PrevSlotType then
    AudioManager(self.Owner):SetEventSoundParam(self.Owner, "WeaponVerifySelectList", {ToEnd = 1})
    if PrevSlotType == Model.SlotType.Affix then
      self.Owner:PlayBuffOut()
    else
      self.Owner:PlayListOut()
    end
  else
    self.Panel_List:SetVisibility(ESlateVisibility.Collapsed)
    self.Panel_Buff:SetVisibility(ESlateVisibility.Collapsed)
  end
  self.Panel_Level:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.BtnReward:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function LevelDetail:IsPointerUnderWidget(Widget, ScreenPosition)
  if not (IsValid(Widget) and Widget:IsVisible()) or not ScreenPosition then
    return false
  end
  return UE4.USlateBlueprintLibrary.IsUnderLocation(Widget:GetCachedGeometry(), ScreenPosition)
end

function LevelDetail:IsPointerInSelectList(ScreenPosition)
  if self.CurEditSlotType == Model.SlotType.Affix then
    return self:IsPointerUnderWidget(self.ListBuff, ScreenPosition)
  end
  return self:IsPointerUnderWidget(self.List_Build.HB_Main, ScreenPosition)
end

function LevelDetail:OnPreviewMouseButtonDown(MouseEvent)
  if not self.CurEditSlotType then
    return false
  end
  local ScreenPosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)
  if self:IsPointerInSelectList(ScreenPosition) then
    return false
  end
  self:HideSelectList()
  return true
end

function LevelDetail:OnPreviewGamePadDown(InKeyName)
  if not self.CurEditSlotType and InKeyName == Const.GamepadDPadDown then
    self:OnBtnEditClicked()
    return true
  end
  return false
end

function LevelDetail:OnBtnEditClicked()
  AudioManager(self.Owner):PlayUISound(self.Owner, "event:/ui/activity/auto_chess_normal_btn_click", nil, nil)
  self:ShowSelectList(Model.SlotType.Char)
end

function LevelDetail:OnBtnGoClicked()
  local EventId = self.EventId
  local DungeonId = self.DungeonId
  if not DungeonId then
    return
  end
  AudioManager(self.Owner):PlayUISound(self.Owner, "event:/ui/activity/sdc_click_confirm", nil, nil)
  if self.BtnGo:IsBtnForbidden() then
    local Ok, MissingSlot = Model.CheckSquadComplete()
    MissingSlot = MissingSlot or self.MissingWeaponType
    local Slot = self.SlotInfos[MissingSlot]
    local Toast = Ok and Slot.MissingToast or Slot.Toast
    UIManager(self):ShowUITip("CommonToastMain", GText(Toast) or "", 1.5)
    return
  end
  self:DoEnterDungeon()
end

function LevelDetail:DoEnterDungeon()
  local EventId = self.EventId
  local DungeonId = self.DungeonId
  local Sel = Model.GetEditSelect()
  local IsSquadChanged = Model.IsSquadChanged(EventId, DungeonId, Sel)
  if IsSquadChanged then
    Model.SetSquad(EventId, DungeonId, Sel.CharUuid, Sel.MeleeWeaponUuid, Sel.RangedWeaponUuid, Sel.PetUniqueId, Sel.AffixId, function(ErrCode)
      if 0 ~= ErrCode then
        UIManager(self):ShowError(ErrCode, 1.0, "CommonToastMain")
        return
      end
      self:EnterDungeon(EventId, DungeonId)
    end)
  else
    self:EnterDungeon(EventId, DungeonId)
  end
end

function LevelDetail:EnterDungeon(EventId, DungeonId)
  local Avatar = Model.GetAvatar()
  if Avatar then
    local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
    local EventTabId = ActivityMain and ActivityMain.CurTabId
    if not EventTabId then
      for _, TabConfig in pairs(DataMgr.EventTab or {}) do
        local TabEventIds = TabConfig.EventId
        if type(TabEventIds) ~= "table" then
          TabEventIds = {TabEventIds}
        end
        for _, TabEventId in ipairs(TabEventIds) do
          if TabEventId == EventId then
            EventTabId = TabConfig.EventTabId
            break
          end
        end
        if EventTabId then
          break
        end
      end
    end
    local ExitDungeonData = {
      Type = "WeaponVerify",
      CurTabIndex = EventTabId,
      CurSelectIndex = DungeonId
    }
    GWorld.GameInstance:SetExitDungeonData(ExitDungeonData)
    Avatar:EnterEventDungeon(nil, DungeonId, nil, EventId)
  end
  self:HideSelectList()
end

function LevelDetail:OnBtnResClicked()
  AudioManager(self.Owner):PlayUISound(self.Owner, "event:/ui/activity/sdc_click_confirm", nil, nil)
  self:ShowCommonConfirmPopup(100409, GText("UI_WeaponVerify_Reset_tips1"), function()
    local EventId = self.EventId
    local DungeonId = self.DungeonId
    if not DungeonId then
      return
    end
    Model.ResetDungeon(EventId, DungeonId, function(ErrCode)
      if 0 ~= ErrCode then
        UIManager(self):ShowError(ErrCode, 1.0, "CommonToastMain")
        return
      end
      local LevelName = Model.GetLevelName(DungeonId)
      UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_WeaponVerify_ResetFinish"), LevelName), 1.5)
      self:RefreshDetail()
      if IsValid(self.Owner) and self.Owner.OnDungeonReset then
        self.Owner:OnDungeonReset()
      end
    end)
  end)
end

function LevelDetail:OnBtnCheckClicked()
  local DungeonInfo = Model.GetMonsterDungeonInfo(self.DungeonId)
  if not (DungeonInfo and DungeonInfo.DungeonMonsters) or #DungeonInfo.DungeonMonsters <= 0 then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_WeaponVerify_NoRecord"), 1.5)
    return
  end
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self.Owner)
  local UIManger = GameInstance and GameInstance:GetGameUIManager()
  if UIManger then
    self:MarkRestoreFocusOnReturn()
    local ZOrder = self.Owner:GetZOrder()
    local MonsterInfoPanel = UIManger:LoadUI(UIConst.LoadInConfig, "MonsterDetailInfo", ZOrder)
    MonsterInfoPanel:InitPanel(nil, DungeonInfo)
    MonsterInfoPanel.Parent = self
  end
end

function LevelDetail:OnBtnGrowthClicked()
  AudioManager(self.Owner):PlayUISound(self.Owner, "event:/ui/activity/auto_chess_normal_btn_click", nil, nil)
  self:ShowJumpConfirmPopup(GText("UI_WeaponVerify_ToArmory2"), function()
    self:MarkRestoreFocusOnReturn()
    PageJumpUtils:JumpToTargetPageByJumpId(4)
  end)
end

function LevelDetail:OnArrowBtnLClicked()
  local PrevId = self:GetAdjacentDungeon(self.DungeonId, -1)
  if PrevId then
    self.DungeonId = PrevId
    self.Owner:PlayChangeAnim(-1)
    self.Owner:SyncGroupByDungeon(PrevId)
    self:HideSelectList()
    self.IsWaitRefreshDetail = true
    AudioManager(self.Owner):PlayUISound(self.Owner, "event:/ui/activity/wuqijiaoyan_level_info_in", nil, nil)
    AudioManager(self.Owner):PlayUISound(self.Owner, "event:/ui/common/click_btn_small_crystal", nil, nil)
  end
end

function LevelDetail:OnArrowBtnRClicked()
  local NextId = self:GetAdjacentDungeon(self.DungeonId, 1)
  if NextId then
    self.DungeonId = NextId
    self.Owner:PlayChangeAnim(1)
    self.Owner:SyncGroupByDungeon(NextId)
    self:HideSelectList()
    self.IsWaitRefreshDetail = true
    AudioManager(self.Owner):PlayUISound(self.Owner, "event:/ui/activity/wuqijiaoyan_level_info_in", nil, nil)
    AudioManager(self.Owner):PlayUISound(self.Owner, "event:/ui/common/click_btn_small_crystal", nil, nil)
  end
end

function LevelDetail:BindDetailButtons()
  self.ArrowBtnL:BindEventOnClicked(self, self.OnArrowBtnLClicked)
  self.ArrowBtnR:BindEventOnClicked(self, self.OnArrowBtnRClicked)
  if IsValid(self.BtnEdit) then
    self.BtnEdit:BindEventOnClicked(self, self.OnBtnEditClicked)
  end
  if IsValid(self.BtnGrowth) then
    self.BtnGrowth:BindEventOnClicked(self, self.OnBtnGrowthClicked)
  end
  self.BtnCheck:BindEventOnClicked(self, self.OnBtnCheckClicked)
  self.BtnRes:SetText(GText("UI_WeaponVerify_Reset"))
  self.BtnRes:BindEventOnClicked(self, self.OnBtnResClicked)
  self.BtnGo:SetText(GText("UI_EnterLevel"))
  self.BtnGo:BindEventOnClicked(self, self.OnBtnGoClicked)
  self.BtnGo:BindForbidStateExecuteEvent(self, self.OnBtnGoClicked)
end

function LevelDetail:UnbindDetailButtons()
  for _, Name in ipairs({
    "ArrowBtnL",
    "ArrowBtnR",
    "BtnEdit",
    "BtnGrowth",
    "BtnCheck",
    "BtnRes",
    "BtnGo"
  }) do
    local Btn = self[Name]
    if IsValid(Btn) and Btn.UnBindEventOnClickedByObj then
      Btn:UnBindEventOnClickedByObj(self)
    end
  end
end

function LevelDetail:OnGamePadDown(InKeyName)
  local IsEventHandled = false
  if InKeyName == Const.GamepadFaceButtonRight then
    self:OnEscKey()
    self:UpdateUIStyleInPlatform()
    IsEventHandled = true
  elseif self.CurEditSlotType then
    if InKeyName == Const.GamepadLeftTrigger then
      if self.CurEditSlotType and self.CurEditSlotType ~= Model.SlotType.Char then
        self:ShowSelectList(self.CurEditSlotType - 1)
      end
      IsEventHandled = true
    elseif InKeyName == Const.GamepadRightTrigger then
      if self.CurEditSlotType and self.CurEditSlotType ~= Model.SlotType.Affix then
        self:ShowSelectList(self.CurEditSlotType + 1)
      end
      IsEventHandled = true
    elseif InKeyName == Const.GamepadLeftThumbstick then
      self.List_Build.Common_Sort_List:ListOpenBtnClicked(true)
      IsEventHandled = true
    end
  elseif InKeyName == Const.GamepadSpecialLeft then
    self:OnBtnCheckClicked()
    IsEventHandled = true
  elseif InKeyName == Const.GamepadLeftShoulder then
    if not self.ArrowBtnL.IsForbidden then
      self:OnArrowBtnLClicked()
      IsEventHandled = true
    end
  elseif InKeyName == Const.GamepadRightShoulder then
    if not self.ArrowBtnR.IsForbidden then
      self:OnArrowBtnRClicked()
      IsEventHandled = true
    end
  elseif InKeyName == Const.GamepadRightThumbstick then
    self:OnBtnGrowthClicked()
    IsEventHandled = true
  elseif InKeyName == Const.GamepadLeftThumbstick then
    if self.BtnRes:IsVisible() then
      self:OnBtnResClicked()
      IsEventHandled = true
    end
  elseif InKeyName == Const.GamepadFaceButtonLeft then
    self:OnBtnGoClicked()
    IsEventHandled = true
  end
  return IsEventHandled
end

function LevelDetail:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  self:UpdateUIStyleInPlatform()
end

function LevelDetail:SetFocus()
  local FocusWidget = self:BP_GetDesiredFocusTarget()
  if IsValid(FocusWidget) then
    FocusWidget:SetFocus()
  end
end

function LevelDetail:BP_GetDesiredFocusTarget()
  if self.CurEditSlotType == nil then
    return self.Character
  end
  if self.CurEditSlotType == Model.SlotType.Affix then
    return self.ListBuff.ListRoom
  end
  return self:GetBuildListView()
end

function LevelDetail:UpdateUIStyleInPlatform()
  if self.bInMobile then
    return
  end
  local IsGamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  if IsGamepad and self.Owner.bInDetail and UIUtils.HasAnyFocus(self.Owner) then
    self:FocusDefaultTarget()
  end
  self.BtnGo:SetGamepadIconVisibility(IsGamepad and not self.CurEditSlotType)
  self.BtnRes:SetGamepadIconVisibility(IsGamepad and not self.CurEditSlotType)
  local NoEditVisibility = not (not IsGamepad or self.CurEditSlotType) and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed
  self.KeyImgTips:SetVisibility(NoEditVisibility)
  self.WBP_Com_KeyImg_BtnGrowth:SetVisibility(NoEditVisibility)
  self.WBP_Com_KeyImg_BtnEdit:SetVisibility(NoEditVisibility)
  self.WBP_Com_KeyImg_ArrowBtnL:SetVisibility(NoEditVisibility)
  self.WBP_Com_KeyImg_ArrowBtnR:SetVisibility(NoEditVisibility)
  self.WBP_Com_KeyImg_ArrowBtnL:SetForbidKey(self.ArrowBtnL.IsForbidden, true)
  self.WBP_Com_KeyImg_ArrowBtnR:SetForbidKey(self.ArrowBtnR.IsForbidden, true)
  local IsInEditSlot = IsGamepad and self.CurEditSlotType
  local SlotVisibility = IsInEditSlot and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed
  local IsForbidSlotL = IsInEditSlot and self.CurEditSlotType == Model.SlotType.Char
  local IsForbidSlotR = IsInEditSlot and self.CurEditSlotType == Model.SlotType.Affix
  self.WBP_Com_KeyImg_SlotLeft:SetVisibility(SlotVisibility)
  self.WBP_Com_KeyImg_SlotRight:SetVisibility(SlotVisibility)
  self.WBP_Com_KeyImg_SlotLeft:SetForbidKey(IsForbidSlotL, true)
  self.WBP_Com_KeyImg_SlotRight:SetForbidKey(IsForbidSlotR, true)
  if IsGamepad then
    local Text = self.CurEditSlotType and "UI_CONFIRM_SELECTION" or "UI_CTL_Adjust"
    self.WBP_Com_Tab_P:UpdateBottomKeyInfo({
      {
        GamePadInfoList = {
          {
            Type = "Text",
            Text = "A",
            Owner = self
          }
        },
        Desc = GText(Text)
      },
      {
        GamePadInfoList = {
          {
            Type = "Text",
            Text = "B",
            ClickCallback = self.OnEscKey,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    })
  else
    self.WBP_Com_Tab_P:UpdateBottomKeyInfo({
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnEscKey,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    })
  end
  self:UpdateSlotUIStyleInPlatform()
end

function LevelDetail:UpdateSlotUIStyleInPlatform()
  local IsGamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  if self.CurEditSlotType then
    local SlotInfo = self.SlotInfos[self.CurEditSlotType]
    local CurEditSlotUI = SlotInfo and self[SlotInfo.Slot]
    if self.CurEditSlotUI and self.CurEditSlotUI ~= CurEditSlotUI then
      self.CurEditSlotUI:Play_Unhover()
      self.CurEditSlotUI = nil
    end
    self.CurEditSlotUI = self.CurEditSlotUI or CurEditSlotUI
    if self.CurEditSlotUI then
      self.CurEditSlotUI:Play_Hover()
    end
  elseif self.CurEditSlotUI then
    self.CurEditSlotUI:Play_Unhover()
    self.CurEditSlotUI = nil
  end
end

function LevelDetail:Change_Info()
  if self.IsWaitRefreshDetail then
    self.IsWaitRefreshDetail = nil
    self:RefreshDetail()
  end
end

return LevelDetail
