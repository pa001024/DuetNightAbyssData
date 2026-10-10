require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local RecycleUtils = require("BluePrints.UI.WBP.Armory.PetRecycleUtils")
local EMCache = require("EMCache.EMCache")
local TimeUtils = require("Utils.TimeUtils")
local ipairs = _ENV.ipairs
local pairs = _ENV.pairs
local insert = table.insert
local CultivatedNoRemindCacheKey = "PetDecomposeCultivatedNoRemindTimeStamp"

local function RefreshPetItemBadges(Widget)
  local Content = Widget.Content
  Widget:SetItemSelect(Content.bSelectTag)
  Widget:SetItemMoney(Content.CurrencyId, Content.CurrencyNum)
  Widget:_SetItemConflictImpl(Content.bConflict, GText("UI_Pet_Decompose_Unavailable"))
  if Content.bConflict then
    Widget:CheckWidgetIsTop(Widget.ConflictWidget)
    Widget:CheckWidgetIsTop(Widget.InGearWidget)
  end
end

local function RefreshConfirmPetItem(Widget)
  local Content = Widget.Content
  Widget:SetCount(nil)
  if Content.PetEntry and #Content.PetEntry > 0 then
    Widget:SetLevel(nil)
    Widget:SetPetEntryId(Content.PetEntry)
  else
    Widget:SetPetEntryId(nil)
    Widget:SetLevel(Content.Level)
  end
end

local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})

function M:Initialize(Initializer)
  self.Parent = nil
  self.SelectedIds = {}
  self.ContentsById = {}
  self.ContentRefs = {}
  self.DetailContent = nil
  self.ItemDetailsWidget = nil
  self.TotalPetCount = 0
  self.Phase = "Idle"
  self.PendingLockId = nil
  self.PendingIds = nil
  self.PreviewRewards = nil
  self.bOwnsInputBlock = false
  self.bClosing = false
  self.bBackgroundPointerDown = false
  self.bHadDetailsOnBackgroundPointerDown = false
end

function M:Init(Parent)
  self.Parent = Parent
  self.bIsFocusable = true
  self.Tab:Init({
    TitleName = GText("UI_Pet_Decompose_Title"),
    OwnerPanel = self,
    Tabs = {},
    DynamicNode = {"Back", "BottomKey"},
    BottomKeyInfo = {},
    BackCallback = self.BeginExitDecomposeMode
  })
  self.ItemDetailsWidget = self:CreateWidgetNew("ItemDetailsMain")
  self.Selective_Listing:AttachTipsWidget(self.ItemDetailsWidget)
  self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Selective_Listing:BindEvents(self, {
    OnListItemClicked = self.OnPetClicked,
    OnListItemSelectionChanged = self.OnDetailSelectionChanged,
    FilterFunction = self.FilterContents,
    SortFuncion = self.SortContents
  })
  self.Selective_Listing:Init(self, {
    Filters = {
      {
        Tag = "Active",
        Text = "Pet_BattlePet",
        Icon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_MainPet.T_Armory_MainPet"
      },
      {
        Tag = "Inactive",
        Text = "Pet_ResourcePet",
        Icon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_MaterialPet.T_Armory_MaterialPet"
      }
    },
    FilterMod = "Single",
    OrderByDisplayNames = {
      "UI_LEVEL_SELECT",
      "UI_RARITY_NAME"
    },
    SortType = CommonConst.DESC,
    ItemContents = {}
  })
  self:InitSortLayer()
  self.Pet_Sell:Init(self)
  self:AddDispatcher(EventID.OnPropChangePets, self, self.RefreshInventory)
  self:AddDispatcher(EventID.OnNewPetObtained, self, self.RefreshInventory)
  self:AddDispatcher(EventID.OnPetDeleted, self, self.RefreshInventory)
  self:AddDispatcher(EventID.OnSwitchPet, self, self.RefreshInventory)
  self:AddDispatcher(EventID.OnPetLocked, self, self.OnPetLocked)
  self:RefreshInventory()
  self.Selective_Listing:PlayInAnim()
  self:RefreshBottomKeyInfo()
  self:SetFocus_Lua()
end

function M:InitSortLayer()
  local Listing = self.Selective_Listing
  local SortPanel = Listing.Panel_Sort
  local ListLayout = SortPanel:GetParent()
  if ListLayout == Listing.Panel_List then
    return
  end
  SortPanel:ForceLayoutPrepass()
  local SortHeight = SortPanel:GetDesiredSize().Y
  if SortHeight <= 0 then
    return
  end
  local ListSlot = ListLayout.Slot
  local Offsets = ListSlot:GetOffsets()
  local ListAnchors = ListSlot:GetAnchors()
  local Alignment = ListSlot:GetAlignment()
  SortPanel:RemoveFromParent()
  local SortSlot = Listing.Panel_List:AddChildToCanvas(SortPanel)
  local Anchors = FAnchors()
  Anchors.Minimum = FVector2D(ListAnchors.Minimum.X, ListAnchors.Maximum.Y)
  Anchors.Maximum = FVector2D(ListAnchors.Maximum.X, ListAnchors.Maximum.Y)
  SortSlot:SetAnchors(Anchors)
  SortSlot:SetAlignment(FVector2D(Alignment.X, 1))
  local SortOffsets = FMargin()
  SortOffsets.Left = Offsets.Left
  SortOffsets.Top = -Offsets.Bottom
  SortOffsets.Right = Offsets.Right
  SortOffsets.Bottom = SortHeight
  SortSlot:SetOffsets(SortOffsets)
  SortSlot:SetZOrder(ListSlot:GetZOrder() + 1)
  Offsets.Bottom = Offsets.Bottom + SortHeight
  ListSlot:SetOffsets(Offsets)
end

function M:IsBusy()
  return self.Phase ~= "Idle" or self.bClosing
end

function M:CanSubmit()
  return not self:IsBusy() and next(self.SelectedIds) ~= nil and nil ~= self.PreviewRewards
end

function M:SetPhase(Phase)
  self.Phase = Phase
  self.Pet_Sell:RefreshKeyCount()
  if self.ItemDetailsWidget then
    self.ItemDetailsWidget.Btn_Locked:ForbidBtn(self:IsBusy())
  end
end

function M:RefreshPetItemContent(Content, Avatar)
  Content.bConflict = RecycleUtils.GetUnavailableReason(Avatar, Content.UniqueId) ~= nil
  Content.bSelectTag = not Content.bConflict and self.SelectedIds[Content.UniqueId] == true
  Content.CurrencyId = nil
  Content.CurrencyNum = nil
  if Content.bSelectTag then
    local Rewards = RecycleUtils.GetPreviewRewards(Avatar, {
      Content.UniqueId
    })
    if Rewards and 1 == #Rewards then
      Content.CurrencyId = Rewards[1].StuffId
      Content.CurrencyNum = Rewards[1].Count
    end
  end
  local Widget = Content.SelfWidget
  if IsValid(Widget) and Widget.Content == Content then
    RefreshPetItemBadges(Widget)
  end
end

function M:RefreshInventory()
  if self.bClosing then
    return
  end
  local ListView = self.Selective_Listing.TileView_Select_Role
  local ScrollOffset = ListView:GetScrollOffset()
  local Avatar = GWorld:GetAvatar()
  local Removed = RecycleUtils.PruneSelection(Avatar, self.SelectedIds)
  self.Pet_Sell:MultiRemoveBagItemInList(Removed)
  local Contents = {}
  local ContentRefs = {}
  local DetailId = self.DetailContent and self.DetailContent.UniqueId
  self.ContentsById = {}
  for _, Pet in pairs(Avatar and Avatar.Pets or {}) do
    local Content = ArmoryUtils:NewPetItemContentWithEntry(Pet)
    Content.bAllUseAsyncLoadWidget = false
    Content.bInGear = Avatar.CurrentPet == Pet.UniqueId
    Content.AfterInitCallback = RefreshPetItemBadges
    self:RefreshPetItemContent(Content, Avatar)
    Content.IsSelect = DetailId == Pet.UniqueId
    Content.RedDotType = nil
    Content.HandleKeyDown = false
    Content.ItemDetailKeyDownEvent = {
      Obj = self,
      Callback = self.OnDetailsKeyDown
    }
    self.ContentsById[Pet.UniqueId] = Content
    insert(ContentRefs, Ref(Content))
    insert(Contents, Content)
  end
  self.TotalPetCount = #Contents
  self.Selective_Listing:SetItemContents(Contents)
  self:ShowDetails(self.ContentsById[DetailId])
  ListView:BP_CancelScrollIntoView()
  ListView:SetScrollOffset(ScrollOffset)
  self.ContentRefs = ContentRefs
  self:RefreshPreview()
end

function M:FilterContents(Contents, FilterIndexes)
  local Filtered = {}
  local ShowActive, ShowInactive = 0 == #FilterIndexes, 0 == #FilterIndexes
  for _, Index in ipairs(FilterIndexes) do
    ShowActive = ShowActive or 1 == Index
    ShowInactive = ShowInactive or 2 == Index
  end
  for _, Content in ipairs(Contents) do
    if Content.IsResourcePet and ShowInactive or not Content.IsResourcePet and ShowActive then
      insert(Filtered, Content)
    end
  end
  return Filtered
end

function M:SortContents(Contents, SortIndex, SortType)
  local Keys = 2 == SortIndex and {
    "Rarity",
    "Level",
    "SortPriority",
    "UnitId"
  } or {
    "Level",
    "Rarity",
    "SortPriority",
    "UnitId"
  }
  ArmoryUtils:SortItemContents(Contents, Keys, SortType, nil, function(A, B)
    local IsActiveA, IsActiveB = not A.IsResourcePet, not B.IsResourcePet
    if IsActiveA ~= IsActiveB then
      return IsActiveA
    end
  end)
end

function M:ShowDetails(Content)
  if self.DetailContent then
    self.DetailContent.IsSelect = false
    if self.DetailContent.SelfWidget then
      self.DetailContent.SelfWidget:SetSelected(false)
    end
  end
  self.DetailContent = Content
  if not Content then
    self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  Content.IsSelect = true
  if Content.SelfWidget then
    Content.SelfWidget:SetSelected(true)
  end
  Content.IsLocked = 1 == Content.LockType
  Content.bWaitRPCRet = true
  Content.bHideGamePad = true
  
  function Content.LockedButtonClickCallBack()
    if IsValid(self) then
      self:OnDetailsLockClicked(Content.UniqueId)
    end
  end
  
  self.ItemDetailsWidget:RefreshItemInfo(Content, true, true)
  self.ItemDetailsWidget.Btn_Locked:ForbidBtn(self:IsBusy())
  self.ItemDetailsWidget.Panel_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.ItemDetailsWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:OnBackgroundPointerDown()
  self.bBackgroundPointerDown = true
  self.bHadDetailsOnBackgroundPointerDown = self.DetailContent ~= nil
end

function M:OnBackgroundClicked()
  local ShouldClose = self.bBackgroundPointerDown and self.bHadDetailsOnBackgroundPointerDown or not self.bBackgroundPointerDown and self.DetailContent ~= nil
  self.bBackgroundPointerDown = false
  self.bHadDetailsOnBackgroundPointerDown = false
  if not ShouldClose then
    return UIUtils.Handled
  end
  self:ShowDetails(nil)
  return UIUtils.Handled
end

function M:OnDetailSelectionChanged(Content, IsSelected)
  if self.bBackgroundPointerDown then
    return
  end
  if IsSelected and Content and Content.UniqueId then
    self:ShowDetails(Content)
  end
end

function M:OnPetClicked(Content)
  if not (Content and Content.UniqueId) or self:IsBusy() then
    return
  end
  self:ShowDetails(Content)
  local Avatar = GWorld:GetAvatar()
  local Reason = RecycleUtils.GetUnavailableReason(Avatar, Content.UniqueId)
  if Reason then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(Reason))
    return
  end
  if self.SelectedIds[Content.UniqueId] then
    self.Pet_Sell:RemoveBagItemInList(Content.UniqueId)
  else
    self.SelectedIds[Content.UniqueId] = true
    self:RefreshPetItemContent(Content, Avatar)
    self.Pet_Sell:AddBagItemToList(Avatar.Pets[Content.UniqueId])
  end
  self:RefreshPreview()
end

function M:OnSelectedPetRemoved(UniqueId)
  self.SelectedIds[UniqueId] = nil
  local Content = self.ContentsById[UniqueId]
  if Content then
    self:RefreshPetItemContent(Content, GWorld:GetAvatar())
  end
  self:RefreshPreview()
end

function M:RefreshPreview()
  self.PreviewRewards = RecycleUtils.GetPreviewRewards(GWorld:GetAvatar(), RecycleUtils.GetSelectedIds(self.SelectedIds))
  self.Pet_Sell:RefreshRewardInfo()
  self.Pet_Sell:RefreshKeyCount()
end

function M:CancelOperation()
  if self.bClosing then
    return
  end
  local WasLockOperation = self.PendingLockId ~= nil
  self.PendingIds = nil
  self.PendingLockId = nil
  self:SetInputBlocked(false)
  self:SetPhase("Idle")
  self:RefreshInventory()
  if WasLockOperation and self.DetailContent then
    self.ItemDetailsWidget:SetFocus()
  else
    self.Pet_Sell:SetFocus_Lua()
  end
end

function M:SetInputBlocked(Blocked)
  if self.bOwnsInputBlock == Blocked then
    return
  end
  self.bOwnsInputBlock = Blocked
  if IsValid(self.Parent) then
    self.Parent:BlockAllUIInput(Blocked)
  end
end

function M:OnDetailsLockClicked(UniqueId)
  if self:IsBusy() then
    return
  end
  local Avatar = GWorld:GetAvatar()
  local Pet = Avatar and Avatar.Pets[UniqueId]
  if not Pet then
    return
  end
  if Pet.IsLock then
    self:TryUnlockPet(UniqueId)
  else
    self.PendingLockId = UniqueId
    self:SetPhase("LockRequest")
    self:SetInputBlocked(true)
    Avatar:LockPet(UniqueId)
  end
end

function M:TryUnlockPet(UniqueId)
  if self:IsBusy() then
    return
  end
  self.PendingLockId = UniqueId
  self:SetPhase("UnlockConfirm")
  
  local function Cancel()
    if IsValid(self) then
      self:CancelOperation()
    end
  end
  
  UIManager(self):ShowCommonPopupUI(RecycleUtils.PopupIds.Unlock, {
    LeftCallbackFunction = Cancel,
    CloseBtnCallbackFunction = Cancel,
    RightCallbackFunction = function()
      if not IsValid(self) or self.bClosing or self.Phase ~= "UnlockConfirm" then
        return
      end
      self:SetPhase("UnlockPassword")
      SecondaryPasswordController:RequestSecPasswordValidation({
        OnCancel = Cancel,
        OnSuccess = function(Password)
          if not IsValid(self) or self.bClosing or self.Phase ~= "UnlockPassword" then
            return
          end
          local Avatar = GWorld:GetAvatar()
          local Pet = Avatar and Avatar.Pets[UniqueId]
          if not Pet or not Pet.IsLock then
            Cancel()
            return
          end
          self:SetPhase("UnlockRequest")
          self:SetInputBlocked(true)
          Avatar:UnLockPet(UniqueId, Password)
        end
      })
    end
  }, self.Parent)
end

function M:OnPetLocked(ErrCode, UniqueId, IsLocked)
  if self.PendingLockId == UniqueId and (self.Phase == "LockRequest" and IsLocked or self.Phase == "UnlockRequest" and not IsLocked) then
    self:CancelOperation()
  else
    self:RefreshInventory()
  end
end

function M:TryConfirmDecompose()
  if not self:CanSubmit() then
    return
  end
  self:RefreshInventory()
  if not self:CanSubmit() then
    return
  end
  self.PendingIds = RecycleUtils.GetSelectedIds(self.SelectedIds)
  local Avatar = GWorld:GetAvatar()
  local StuffInfoList = {}
  for _, UniqueId in ipairs(self.PendingIds) do
    local Content = self.ContentsById[UniqueId]
    local Pet = Avatar and Avatar.Pets[UniqueId]
    insert(StuffInfoList, {
      StuffId = Content.UnitId,
      StuffType = "Pet",
      Uuid = UniqueId,
      StuffIcon = Content.Icon,
      StuffName = Content.UnitName,
      Rarity = Content.Rarity,
      Level = Content.Level or Pet and Pet.Level,
      BreakNum = Content.BreakNum or 0,
      IsPremium = Content.IsPremium,
      PetEntry = Content.PetEntry,
      AfterInitCallback = RefreshConfirmPetItem
    })
  end
  self:SetPhase("Confirm")
  
  local function Cancel()
    if IsValid(self) then
      self:CancelOperation()
    end
  end
  
  UIManager(self):ShowCommonPopupUI(RecycleUtils.PopupIds.Confirm, {
    Title = GText("UI_Pet_Decompose_Title"),
    LeftText = GText("UI_Pet_ToDecompose"),
    RightText = GText("UI_Pet_DecomposeResultResource"),
    StuffInfoList = StuffInfoList,
    RewardList = self.PreviewRewards,
    bHideDialogItem = true,
    LeftCallbackFunction = Cancel,
    CloseBtnCallbackFunction = Cancel,
    RightCallbackFunction = function()
      if IsValid(self) and not self.bClosing and self.Phase == "Confirm" then
        self:ConfirmCultivatedPets()
      end
    end
  }, self.Parent)
end

function M:ConfirmCultivatedPets()
  local Avatar = GWorld:GetAvatar()
  local Cultivated = false
  for _, UniqueId in ipairs(self.PendingIds) do
    local Pet = Avatar and Avatar.Pets[UniqueId]
    if not Pet then
      self:CancelOperation()
      return
    end
    Cultivated = Cultivated or RecycleUtils.IsCultivated(Pet, DataMgr.Pet[Pet.PetId], DataMgr.PetEntry)
  end
  self:SetPhase("Cultivated")
  if not Cultivated then
    self:ValidateDecomposePassword()
    return
  end
  local LastConfirmTime = EMCache:Get(CultivatedNoRemindCacheKey, true)
  if LastConfirmTime and LastConfirmTime >= TimeUtils.TimestampLastClock(0) then
    self:ValidateDecomposePassword()
    return
  end
  
  local function Cancel()
    if IsValid(self) then
      self:CancelOperation()
    end
  end
  
  UIManager(self):ShowCommonPopupUI(RecycleUtils.PopupIds.Cultivated, {
    ShortText = GText("UI_Pet_Decompose_CultivatedConfirm"),
    LeftCallbackFunction = Cancel,
    CloseBtnCallbackFunction = Cancel,
    RightCallbackFunction = function(_, Data)
      if IsValid(self) and not self.bClosing and self.Phase == "Cultivated" then
        if Data and Data.SelectHint and Data.SelectHint.IsSelected then
          EMCache:Set(CultivatedNoRemindCacheKey, TimeUtils.NowTime(), true)
        end
        self:ValidateDecomposePassword()
      end
    end
  }, self.Parent)
end

function M:ValidateDecomposePassword()
  self:SetPhase("Password")
  SecondaryPasswordController:RequestSecPasswordValidation({
    OnCancel = function()
      if IsValid(self) then
        self:CancelOperation()
      end
    end,
    OnSuccess = function(Password)
      if IsValid(self) and not self.bClosing and self.Phase == "Password" then
        self:SubmitDecompose(Password)
      end
    end
  })
end

function M:SubmitDecompose(Password)
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not self.PreviewRewards then
    self:CancelOperation()
    return
  end
  for _, UniqueId in ipairs(self.PendingIds) do
    local Reason = RecycleUtils.GetUnavailableReason(Avatar, UniqueId)
    if Reason then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(Reason))
      self:CancelOperation()
      return
    end
  end
  self:SetPhase("Request")
  self:SetInputBlocked(true)
  Avatar:DecomposePets(self.PendingIds, Password, function(ErrCode, DecomposeResult)
    if not IsValid(self) or self.bClosing then
      return
    end
    self:SetInputBlocked(false)
    if not ErrorCode:Check(ErrCode) then
      self:CancelOperation()
      return
    end
    local ActualRewards = RecycleUtils.GetActualRewards(DecomposeResult)
    if not ActualRewards then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Pet_Decompose_ResultUnavailable"))
      self:CancelOperation()
      return
    end
    self:SetPhase("Reward")
    UIManager(self):LoadUINew("GetItemPage", nil, nil, nil, ActualRewards, function()
      if IsValid(self) then
        self:FinishClose()
      end
    end, self.Parent, true)
  end)
end

function M:SetFocus_Lua()
  if self.bBackgroundPointerDown then
    return
  end
  local Listing = self.Selective_Listing
  if self.DetailContent and self.ItemDetailsWidget:IsVisible() then
    Listing.TileView_Select_Role:BP_CancelScrollIntoView()
    self.ItemDetailsWidget:SetFocus()
  elseif #Listing.FilteredContents > 0 then
    Listing:SetFocusToList()
  else
    Listing.EMListView_Filter:SetFocus()
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  self:SetFocus_Lua()
  return UIUtils.Handled
end

function M:RefreshBottomKeyInfo()
  if self.Tab.UpdateBottomKeyInfo then
    self.Tab:UpdateBottomKeyInfo({
      {
        KeyInfoList = {
          {Type = "Text", Text = "Esc"}
        },
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK")
      }
    })
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(UE4.UKismetInputLibrary.GetKey(InKeyEvent))
  if "Escape" == KeyName or KeyName == UIConst.GamePadKey.FaceButtonRight then
    self:BeginExitDecomposeMode()
  elseif KeyName == UIConst.GamePadKey.FaceButtonTop then
    self.Pet_Sell:TryToResolveStuff()
  elseif KeyName == UIConst.GamePadKey.SpecialRight then
    self.Pet_Sell:ClickToOpenStuffList()
  elseif KeyName == UIConst.GamePadKey.LeftThumb then
    if not self:IsBusy() then
      self.Selective_Listing.Common_Sort_List:OnSortTypeButtonClicked()
    end
  elseif KeyName == UIConst.GamePadKey.RightThumb then
    if not self:IsBusy() and self.Pet_Sell.ItemBox:GetChildrenCount() > 0 then
      self.Pet_Sell.ItemBox:GetChildAt(0):SetFocus()
    end
  elseif KeyName == UIConst.GamePadKey.FaceButtonLeft and self.Pet_Sell.bIsOpenList then
    local Content = self.Pet_Sell.List_Item:BP_GetSelectedItem()
    if Content then
      self.Pet_Sell:OnPetMinusClicked(Content)
    end
  else
    return UIUtils.UnHandled
  end
  return UIUtils.Handled
end

function M:OnDetailsKeyDown(MyGeometry, InKeyEvent)
  local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(UE4.UKismetInputLibrary.GetKey(InKeyEvent))
  if self.ItemDetailsWidget and KeyName == self.ItemDetailsWidget.LockPadKey then
    if not self:IsBusy() and self.DetailContent then
      self.ItemDetailsWidget:OnGamePadDown(KeyName)
    end
    return UIUtils.Handled, true
  end
  local Reply = self:OnKeyDown(MyGeometry, InKeyEvent)
  return Reply, Reply == UIUtils.Handled
end

function M:BeginExitDecomposeMode()
  if self:IsBusy() then
    return
  end
  self.bClosing = true
  self:RemoveAllDispatcher()
  self.Selective_Listing:PlayOutAnim()
  self.Pet_Sell:PlayOutAnim()
end

function M:FinishClose()
  if IsValid(self.Parent) then
    self.Parent:ClosePetRecycle()
  end
end

function M:Destruct()
  self.bClosing = true
  self:SetInputBlocked(false)
  self:ClearScriptRegister()
  self.ContentRefs = nil
  self.ContentsById = {}
  self.DetailContent = nil
  self.PendingLockId = nil
end

return M
