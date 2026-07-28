require("UnLua")
local Model = require("BluePrints.UI.WBP.Activity.Widget.Weapon.WeaponVerifyUIModel")
local SlotM = require("BluePrints.UI.WBP.Activity.Widget.Weapon.WBP_Activity_Weapon_Slot_C")
local UIUtils = require("Utils.UIUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local SLOT_INFOS = {
  {
    Widget = "Character",
    Type = Model.SlotType.Char,
    SaveKey = "CharUuid"
  },
  {
    Widget = "Melee",
    Type = Model.SlotType.Melee,
    SaveKey = "MeleeWeaponUuid"
  },
  {
    Widget = "Range",
    Type = Model.SlotType.Ranged,
    SaveKey = "RangedWeaponUuid"
  },
  {
    Widget = "Pet",
    Type = Model.SlotType.Pet,
    SaveKey = "PetUniqueId"
  },
  {
    Widget = "Roulette",
    Type = Model.SlotType.Affix,
    SaveKey = "AffixId"
  }
}

function M:Construct()
  if IsValid(self.BtnRes) and IsValid(self.BtnRes.Button_Area) then
    self.BtnRes.bIsFocusable = false
    self.BtnRes.Button_Area.OnClicked:Add(self, self.OnBtnResClicked)
    self.BtnRes:SetText(GText("UI_WeaponVerify_Reset"))
    self.BtnRes:SetGamePadImg(UIConst.GamePadImgKey.FaceButtonBottom)
    self.BtnRes:SetGamepadIconVisibility(false)
  end
  if IsValid(self.TextEmpty) then
    self.TextEmpty:SetText(GText("UI_WeaponVerify_NoRecord"))
  end
  self:InitEffectListFocus()
end

function M:Destruct()
  if IsValid(self.BtnRes) and IsValid(self.BtnRes.Button_Area) then
    self.BtnRes.Button_Area.OnClicked:Remove(self, self.OnBtnResClicked)
  end
end

function M:SupportsKeyboardFocus()
  return true
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.bCanReset = false
  self.bHasGamepadFocus = false
  self:SetResetGamepadVisible(false)
  self:ResetGamepadHover()
  if not Content then
    return
  end
  local EventId, DungeonId = Content.EventId, Content.DungeonId
  local Cfg = Model.GetLevelCfg(DungeonId)
  local IsUnlocked = Cfg and Model.IsGroupUnlocked(EventId, Cfg.GroupId) or false
  if not IsUnlocked then
    if IsValid(self.Ws_Content) then
      self.Ws_Content:SetActiveWidgetIndex(1)
    end
    return
  end
  if IsValid(self.Ws_Content) then
    self.Ws_Content:SetActiveWidgetIndex(0)
  end
  if IsValid(self.TextLevel) then
    self.TextLevel:SetText(Model.GetLevelNumber(DungeonId))
  end
  if IsValid(self.Image_218) then
    local bBoss = 2 == Model.GetLevelType(DungeonId)
    self.Image_218:SetVisibility(bBoss and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed)
  end
  M.RefreshStars(self, EventId, DungeonId)
  local IsFinished = Model.IsLevelFinished(EventId, DungeonId)
  M.RefreshSlots(self, IsFinished, EventId, DungeonId)
  if IsValid(self.WidgetSwitcher_4) then
    self.WidgetSwitcher_4:SetActiveWidgetIndex(IsFinished and 0 or 1)
  end
  self.bCanReset = IsFinished
  self:SetResetGamepadVisible(false)
  local ShowEffects = Content.bShowEffects == true
  if IsValid(self.Line) then
    self.Line:SetVisibility(ShowEffects and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed)
  end
  if IsValid(self.List_Equipment_1) then
    self:InitEffectListFocus()
    self.List_Equipment_1:SetVisibility(ShowEffects and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed)
    if ShowEffects then
      M.RefreshEffectList(self, DungeonId)
    end
  end
end

function M:RefreshStars(EventId, DungeonId)
  local FinishStar = Model.GetLevelStar(EventId, DungeonId)
  local MaxStar = Model.GetMaxStar(DungeonId)
  for i = 1, 3 do
    local StarItem = self[string.format("Star%02d", i)]
    if IsValid(StarItem) then
      if i > MaxStar then
        StarItem:SetVisibility(ESlateVisibility.Collapsed)
      else
        StarItem:SetVisibility(ESlateVisibility.HitTestInvisible)
        local bLit = i <= FinishStar
        if IsValid(StarItem.Star) then
          StarItem.Star:SetVisibility(bLit and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed)
        end
        if IsValid(StarItem.StarEmpty) then
          StarItem.StarEmpty:SetVisibility(bLit and ESlateVisibility.Collapsed or ESlateVisibility.HitTestInvisible)
        end
      end
    end
  end
end

function M:RefreshSlots(IsFinished, EventId, DungeonId)
  local SaveInfo = IsFinished and Model.GetLevelSaveInfo(EventId, DungeonId) or nil
  for _, Info in ipairs(SLOT_INFOS) do
    local Widget = self[Info.Widget]
    if IsValid(Widget) then
      local Val = SaveInfo and SaveInfo[Info.SaveKey] or nil
      Val = Model.GetCurrentCharacterValue(Info.Type, Val)
      SlotM.SetData(Widget, {
        SlotType = Info.Type,
        State = Model.GetSlotState(Info.Type, Val),
        IconPath = Val and Model.GetSlotIconPath(Info.Type, Val) or nil,
        IsReadOnly = true
      })
    end
  end
end

function M:RefreshEffectList(DungeonId)
  if not IsValid(self.List_Equipment_1) then
    return
  end
  self.List_Equipment_1:ClearListItems()
  
  local function AddItems(BuffIds)
    for _, BuffId in ipairs(BuffIds) do
      local Desc = Model.GetBuffDesc(BuffId)
      if Desc then
        local C = NewObject(UIUtils.GetCommonItemContentClass())
        C.EffectText = Desc
        self.List_Equipment_1:AddItem(C)
      end
    end
  end
  
  AddItems(Model.GetLevelBuffIds(DungeonId))
end

function M:InitEffectListFocus()
  if not IsValid(self.List_Equipment_1) then
    return
  end
  self.List_Equipment_1.bIsFocusable = false
  self.List_Equipment_1.IsFocusable = false
  self.List_Equipment_1:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Equipment_1:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Equipment_1:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Equipment_1:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
end

function M:CanReset()
  return self.bCanReset == true and self.Content ~= nil and IsValid(self.Content.Owner) and IsValid(self.BtnRes) and (not IsValid(self.WidgetSwitcher_4) or 0 == self.WidgetSwitcher_4:GetActiveWidgetIndex())
end

function M:SetResetGamepadVisible(bVisible)
  if not IsValid(self.BtnRes) then
    return
  end
  local bShouldShow = true == bVisible and UIUtils.IsGamepadInput() and true == self.bHasGamepadFocus and self:CanReset()
  self.BtnRes:SetGamepadIconVisibility(bShouldShow)
end

function M:OnBtnResClicked()
  if not self:CanReset() then
    return
  end
  local Content = self.Content
  Content.Owner:RequestReset(Content.DungeonId)
end

function M:OnPreviewKeyDown(_, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == UIConst.GamePadKey.FaceButtonBottom or InKeyName == Const.GamepadFaceButtonDown) and self:CanReset() then
      self:OnBtnResClicked()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:SetGamepadHover(bHover)
  if not self.Hover then
    return
  end
  if bHover then
    if self.bGamepadHovering then
      return
    end
    self.bGamepadHovering = true
    if self:IsAnimationPlaying(self.Hover) then
      self:StopAnimation(self.Hover)
    end
    self:PlayAnimation(self.Hover)
  else
    if not self.bGamepadHovering then
      return
    end
    self.bGamepadHovering = false
    if self:IsAnimationPlaying(self.Hover) then
      self:StopAnimation(self.Hover)
    end
    self:PlayAnimationReverse(self.Hover)
  end
end

function M:ResetGamepadHover()
  self.bGamepadHovering = false
  if self.Hover then
    self:StopAnimation(self.Hover)
  end
  if IsValid(self.Img_Hover_GamePad) then
    self.Img_Hover_GamePad:SetRenderOpacity(0)
  end
end

function M:OnAddedToFocusPath(_)
  self.bHasGamepadFocus = UIUtils.IsGamepadInput()
  local Owner = self.Content and self.Content.Owner
  if Owner and IsValid(Owner) and IsValid(Owner.ListRoom) then
    Owner.GamepadFocusedItem = self
    Owner.GamepadFocusedIndex = Owner.ListRoom:GetIndexForItem(self.Content)
  end
  if UIUtils.IsGamepadInput() then
    self:SetGamepadHover(true)
    self:SetResetGamepadVisible(self:CanReset())
  else
    self:SetResetGamepadVisible(false)
  end
end

function M:OnRemovedFromFocusPath(_)
  self.bHasGamepadFocus = false
  self:SetResetGamepadVisible(false)
  self:SetGamepadHover(false)
  local Owner = self.Content and self.Content.Owner
  if Owner and IsValid(Owner) and Owner.GamepadFocusedItem == self then
    Owner.GamepadFocusedItem = nil
  end
end

return M
