local Component = {}

local function IsGamepadInput(Owner)
  if Owner.CurInputDeviceType ~= nil then
    return Owner.CurInputDeviceType == ECommonInputType.Gamepad
  end
  local RootOwner = Owner.EditRootController and Owner.EditRootController.OwnerWidget or nil
  return nil ~= RootOwner and RootOwner.CurInputDeviceType == ECommonInputType.Gamepad
end

local function RefreshSortControllerKeyState(Owner)
  if not Owner.Common_Sort_List or not Owner.Common_Sort_List.SetControllerKeyHidden then
    return
  end
  local SortWidget = Owner.Common_Sort_List
  local bSortFocused = SortWidget.IsInFocusPath == true or true == SortWidget.IsListViewOpened or SortWidget.HasAnyFocus and SortWidget:HasAnyFocus()
  local bHide = true == Owner.IsCharacterTipsOpened or not IsGamepadInput(Owner) or bSortFocused
  Owner.Common_Sort_List:SetControllerKeyHidden(bHide)
end

local function FindNextSelectableSlotContent(Owner, Offset)
  local EditRootController = Owner and Owner.EditRootController or nil
  local RootViewPanel = EditRootController and EditRootController.RootViewPanel or nil
  local CharacterSlotItemContents = RootViewPanel and RootViewPanel.CharacterSlotItemContents or nil
  if not CharacterSlotItemContents or #CharacterSlotItemContents <= 0 then
    return nil
  end
  local CurrentSlotIndex = EditRootController.GetSelectedCharacterSlotIndex and EditRootController:GetSelectedCharacterSlotIndex() or 1
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
    if self.ChooseMode == "Character" and self.IsCharacterTipsOpened == true then
      return self:_TryCloseCharacterTips()
    end
    self:OnClickBack()
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonTop then
    local RootViewPanel = self.EditRootController and self.EditRootController.RootViewPanel or nil
    if RootViewPanel and RootViewPanel.TriggerCommonButtonClick and RootViewPanel:TriggerCommonButtonClick(RootViewPanel.Btn_Save) then
      return true
    end
    return false
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    if self.ChooseMode == "Character" and self.IsCharacterTipsOpened == true then
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
    if self.ChooseMode == "Character" and FocusedContent and true == FocusedContent.IsChosen then
      self:OnClickCharacterChosenMinus(FocusedContent)
      self:RefreshBottomKeyInfo()
      return true
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
  if InKeyName == UIConst.GamePadKey.LeftShoulder and (self.ChooseMode == "Character" or self.ChooseMode == "Weapon" or self.ChooseMode == "Action") then
    return SwitchSelectedCharacterSlot(self, -1)
  end
  if InKeyName == UIConst.GamePadKey.RightShoulder and (self.ChooseMode == "Character" or self.ChooseMode == "Weapon" or self.ChooseMode == "Action") then
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
  self:RefreshBottomKeyInfo()
end

function Component:ShouldKeepCurrentGamepadFocus()
  if not IsGamepadInput(self) then
    return false
  end
  if not self.Common_Sort_List then
    return false
  end
  return self.Common_Sort_List.IsInFocusPath == true or true == self.Common_Sort_List.IsListViewOpened or self.Common_Sort_List.HasAnyFocus and self.Common_Sort_List:HasAnyFocus()
end

function Component:OnSortListAddedToFocusPath()
  self.LastFocusList = self:GetDesiredFocusTarget()
  self.Common_Sort_List:SetControllerKeyHidden(true)
  self:RefreshBottomKeyInfo()
end

function Component:OnSortListRemovedFromFocusPath()
  local bShouldHide = self.IsCharacterTipsOpened == true or not IsGamepadInput(self)
  self.Common_Sort_List:SetControllerKeyHidden(bShouldHide)
  self:RefreshBottomKeyInfo()
end

function Component:BuildChoosePageGamepadBottomKeyInfo()
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
  if self.ChooseMode == "Character" and FocusedContent and FocusedContent.IsChosen == true and true ~= self.IsCharacterTipsOpened then
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
