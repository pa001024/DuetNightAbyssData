local Component = {}

local function IsGamepadInput(Owner)
  if Owner.CurInputDeviceType ~= nil then
    return Owner.CurInputDeviceType == ECommonInputType.Gamepad
  end
  local RootOwner = Owner.EditRootController and Owner.EditRootController.OwnerWidget or nil
  return nil ~= RootOwner and RootOwner.CurInputDeviceType == ECommonInputType.Gamepad
end

local function IsSortFocused(Owner)
  local SortWidget = Owner.Common_Sort_List
  return nil ~= SortWidget and (SortWidget.IsInFocusPath == true or true == SortWidget.IsListViewOpened or SortWidget.HasAnyFocus and SortWidget:HasAnyFocus())
end

local function RefreshSortControllerKeyState(Owner)
  if not Owner.Common_Sort_List or not Owner.Common_Sort_List.SetControllerKeyHidden then
    return
  end
  local bHide = Owner.IsCharacterTipsOpened == true or not IsGamepadInput(Owner) or IsSortFocused(Owner) or true == Owner.bItemDetailsFocused
  Owner.Common_Sort_List:SetControllerKeyHidden(bHide)
end

local function RefreshRootGamepadHintState(Owner)
  local RootViewPanel = Owner.EditRootController and Owner.EditRootController.RootViewPanel or nil
  if RootViewPanel and RootViewPanel.RefreshCustomEditGamepadPageState then
    RootViewPanel:RefreshCustomEditGamepadPageState()
  end
end

local function GetSelectedSlotIndexForChoose(Owner)
  local EditRootController = Owner and Owner.EditRootController or nil
  if not EditRootController then
    return 1
  end
  if Owner.ChooseMode == "Item" then
    local ItemSlotIndex = EditRootController.GetSelectedItemSlotIndex and EditRootController:GetSelectedItemSlotIndex() or nil
    return type(ItemSlotIndex) == "number" and ItemSlotIndex or 1
  end
  if Owner.ChooseMode == "Pet" then
    local PetSlotIndex = EditRootController.GetSelectedPetSlotIndex and EditRootController:GetSelectedPetSlotIndex() or nil
    return type(PetSlotIndex) == "number" and PetSlotIndex or 1
  end
  local CharacterSlotIndex = EditRootController.GetSelectedCharacterSlotIndex and EditRootController:GetSelectedCharacterSlotIndex() or nil
  return type(CharacterSlotIndex) == "number" and CharacterSlotIndex or 1
end

local function FindNextSelectableSlotContent(Owner, Offset)
  local EditRootController = Owner and Owner.EditRootController or nil
  local RootViewPanel = EditRootController and EditRootController.RootViewPanel or nil
  local CharacterSlotItemContents = RootViewPanel and RootViewPanel.CharacterSlotItemContents or nil
  if not CharacterSlotItemContents or #CharacterSlotItemContents <= 0 then
    return nil
  end
  local CurrentSlotIndex = GetSelectedSlotIndexForChoose(Owner)
  local SlotCount = #CharacterSlotItemContents
  local NextSlotIndex = CurrentSlotIndex
  for _ = 1, SlotCount do
    NextSlotIndex = NextSlotIndex + Offset
    if NextSlotIndex < 1 or SlotCount < NextSlotIndex then
      return nil
    end
    local Content = CharacterSlotItemContents[NextSlotIndex]
    if Content and Content.CanInteract == true then
      return Content
    end
  end
  return nil
end

local function SwitchSelectedCharacterSlot(Owner, Offset)
  local EditRootController = Owner and Owner.EditRootController or nil
  local RootViewPanel = EditRootController and EditRootController.RootViewPanel or nil
  if not RootViewPanel or not RootViewPanel.OnClickCharacterSlotItem then
    return false
  end
  local NextContent = FindNextSelectableSlotContent(Owner, Offset)
  if not NextContent then
    return false
  end
  RootViewPanel:OnClickCharacterSlotItem(NextContent)
  return true
end

function Component:Handle_ChoosePageGamepadKeyDown(InKeyName)
  if not IsGamepadInput(self) then
    return false
  end
  if self:ShouldHideChoosePageGamepadKeys() then
    if self.bItemDetailsFocused == true then
      if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
        return false
      end
      if InKeyName == UIConst.GamePadKey.FaceButtonRight or InKeyName == UIConst.GamePadKey.SpecialLeft then
        return true == self.ItemDetailsWidget:OnGamePadDown(InKeyName)
      end
      return true
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
      local BackFocusWidget = self.OnSortListWidgetBack and self:OnSortListWidgetBack() or self.LastFocusList
      if BackFocusWidget and BackFocusWidget.SetFocus then
        BackFocusWidget:SetFocus()
      end
    end
    return true
  end
  if InKeyName == UIConst.GamePadKey.SpecialLeft and self.ChooseMode == "Item" and self.ItemDetailsWidget and self.ItemDetailsWidget:GetVisibility() ~= UIConst.VisibilityOp.Collapsed and self.ItemDetailsWidget:TryGoToFirstItem() then
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    if self.EMListView_Filter and UIUtils.HasAnyFocus(self.EMListView_Filter) then
      local FilterContent = self.CurFilterItem or self.LastSelectedFilterContent or self.FilterContentObj_All
      if FilterContent then
        self:OnFilterListItemClicked(FilterContent)
        return true
      end
    end
    return false
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    if self.Common_Sort_List and self.Common_Sort_List.HasAnyFocus and self.Common_Sort_List:HasAnyFocus() then
      local BackFocusWidget = self.OnSortListWidgetBack and self:OnSortListWidgetBack() or self.LastFocusList
      if BackFocusWidget and BackFocusWidget.SetFocus then
        BackFocusWidget:SetFocus()
        return true
      end
    end
    if self.ChooseMode == "Character" and true == self.IsCharacterTipsOpened then
      return self:_TryCloseCharacterTips()
    end
    self:OnClickBack()
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonTop then
    local RootViewPanel = self.EditRootController and self.EditRootController.RootViewPanel or nil
    local ConfirmButton = RootViewPanel and RootViewPanel.GetActiveCommonConfirmButton and RootViewPanel:GetActiveCommonConfirmButton() or RootViewPanel and RootViewPanel.Btn_Save or nil
    if RootViewPanel and RootViewPanel.TriggerCommonButtonClick and RootViewPanel:TriggerCommonButtonClick(ConfirmButton) then
      return true
    end
    return false
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    if self.ChooseMode == "Character" and true == self.IsCharacterTipsOpened then
      local TipsWidget = self.WBP_PersonalInfo_Edit_Tips
      if TipsWidget then
        local ModIndex, AppearanceIndex
        if TipsWidget.GetPlan then
          AppearanceIndex, ModIndex = TipsWidget:GetPlan()
        else
          ModIndex = TipsWidget.SelectModIndex
          AppearanceIndex = TipsWidget.SelectAppearanceIndex
        end
        self:OnCharacterTipsConfirmClicked(TipsWidget, ModIndex, AppearanceIndex)
        return true
      end
      return false
    end
    local FocusedContent = self.LastSelectedListContent or self.LastSelectedContent
    if self:_ShouldShowChoosePageGamepadClearKey(FocusedContent) then
      if self.ChooseMode == "Character" then
        self:OnClickCharacterChosenMinus(FocusedContent)
        self:RefreshBottomKeyInfo()
        return true
      end
      if self.ChooseMode == "Pet" then
        self:OnClickPetChosenMinus(FocusedContent)
        self:RefreshBottomKeyInfo()
        return true
      end
      if self.ChooseMode == "Item" then
        self:OnClickItemChosenMinus(FocusedContent)
        self:RefreshBottomKeyInfo()
        return true
      end
    end
    return false
  end
  if InKeyName == UIConst.GamePadKey.LeftThumb then
    if self.Common_Sort_List and self.Common_Sort_List.SetFocus then
      if not self.EMListView_Filter or not UIUtils.HasAnyFocus(self.EMListView_Filter) then
        self.LastFocusList = self.TileView_Select_Role
      else
        self.LastFocusList = self.EMListView_Filter
      end
      self.Common_Sort_List:SetFocus()
      return true
    end
    return false
  end
  if InKeyName == UIConst.GamePadKey.LeftTriggerThreshold and self.ChooseMode == "Weapon" then
    self:OnMeleeSelect()
    return true
  end
  if InKeyName == UIConst.GamePadKey.RightTriggerThreshold and self.ChooseMode == "Weapon" then
    self:OnRangedSelect()
    return true
  end
  if InKeyName == UIConst.GamePadKey.LeftShoulder and (self.ChooseMode == "Character" or self.ChooseMode == "Weapon" or self.ChooseMode == "Action" or self.ChooseMode == "Item" or self.ChooseMode == "Pet") then
    return SwitchSelectedCharacterSlot(self, -1)
  end
  if InKeyName == UIConst.GamePadKey.RightShoulder and (self.ChooseMode == "Character" or self.ChooseMode == "Weapon" or self.ChooseMode == "Action" or self.ChooseMode == "Item" or self.ChooseMode == "Pet") then
    return SwitchSelectedCharacterSlot(self, 1)
  end
  return false
end

function Component:OnListItemSelectionChanged(Content, IsSelected)
  if not IsGamepadInput(self) then
    return
  end
  if not IsSelected or not self:_IsValidChooseContent(Content) then
    return
  end
  self.LastSelectedListContent = Content
  if self.ChooseMode == "Item" then
    self:OnItemContentFocused(Content)
  end
  self:RefreshBottomKeyInfo()
end

function Component:RefreshView()
  if not IsGamepadInput(self) then
    return
  end
  RefreshSortControllerKeyState(self)
end

function Component:RefreshChoosePageGamepadState()
  RefreshSortControllerKeyState(self)
  RefreshRootGamepadHintState(self)
  self:RefreshBottomKeyInfo()
end

function Component:ShouldHideChoosePageGamepadKeys()
  return IsGamepadInput(self) and (self.bItemDetailsFocused == true or IsSortFocused(self))
end

function Component:ShouldKeepCurrentGamepadFocus()
  if not IsGamepadInput(self) then
    return false
  end
  return self.bItemDetailsFocused == true or IsSortFocused(self)
end

function Component:OnSortListAddedToFocusPath()
  self.LastFocusList = self:GetDesiredFocusTarget()
  self:RefreshChoosePageGamepadState()
end

function Component:OnSortListRemovedFromFocusPath()
  self:RefreshChoosePageGamepadState()
end

function Component:BuildChoosePageGamepadBottomKeyInfo()
  if self:ShouldHideChoosePageGamepadKeys() then
    return {}
  end
  local BottomKeyInfo = {
    {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "A",
          ClickCallback = self.OnClickConfirmChoose,
          Owner = self
        }
      },
      Desc = GText("UI_PersonalPage_ConfirmSelect")
    },
    {
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
  }
  local FocusedContent = self.LastSelectedListContent or self.LastSelectedContent
  local bShowClear = self:_ShouldShowChoosePageGamepadClearKey(FocusedContent)
  if bShowClear then
    BottomKeyInfo[#BottomKeyInfo + 1] = {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "X",
          Owner = self
        }
      },
      Desc = GText("UI_WeaponStrength_Clear")
    }
  end
  return BottomKeyInfo
end

return Component
