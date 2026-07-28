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
  self.BtnArea.OnClicked:Add(self, self.OnBtnClicked)
end

function M:Destruct()
  self.BtnArea.OnClicked:Remove(self, self.OnBtnClicked)
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  if self.Normal then
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
  end
  if not Content then
    return
  end
  local EventId, DungeonId = Content.EventId, Content.DungeonId
  if IsValid(self.TextLevel) then
    self.TextLevel:SetText(Model.GetLevelNumber(DungeonId))
  end
  if IsValid(self.Boss) then
    local bBoss = 2 == Model.GetLevelType(DungeonId)
    self.Boss:SetVisibility(bBoss and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed)
  end
  self:RefreshStars(EventId, DungeonId)
  self:RefreshSlots(EventId, DungeonId)
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
        local LitVis = bLit and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed
        local EmptyVis = bLit and ESlateVisibility.Collapsed or ESlateVisibility.HitTestInvisible
        if IsValid(StarItem.Star) then
          StarItem.Star:SetVisibility(LitVis)
        end
        if IsValid(StarItem.StarEmpty) then
          StarItem.StarEmpty:SetVisibility(EmptyVis)
        end
      end
    end
  end
end

function M:RefreshSlots(EventId, DungeonId)
  local IsFinished = Model.IsLevelFinished(EventId, DungeonId)
  local SaveInfo = IsFinished and Model.GetLevelSaveInfo(EventId, DungeonId) or nil
  for _, Info in ipairs(SLOT_INFOS) do
    local Widget = self[Info.Widget]
    if IsValid(Widget) then
      local Val = SaveInfo and SaveInfo[Info.SaveKey] or nil
      Val = Model.GetCurrentCharacterValue(Info.Type, Val)
      SlotM.SetData(Widget, {
        SlotType = Info.Type,
        State = Model.GetSlotState(Info.Type, Val),
        IconPath = Model.GetSlotIconPath(Info.Type, Val),
        IsReadOnly = true
      })
    end
  end
end

function M:OnBtnClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_icon_btn_click", nil, nil)
  local Content = self.Content
  if Content and Content.Owner and IsValid(Content.Owner) then
    Content.Owner:OnClickLevel(Content.DungeonId)
  end
end

function M:SupportsKeyboardFocus()
  return true
end

function M:SetGamepadHover(bHover)
  if not self.Hover then
    return
  end
  if self:IsAnimationPlaying(self.Hover) then
    self:StopAnimation(self.Hover)
  end
  if bHover then
    self:PlayAnimation(self.Hover)
  else
    self:PlayAnimationReverse(self.Hover)
  end
end

function M:OnAddedToFocusPath(_)
  if UIUtils.IsGamepadInput() then
    self:SetGamepadHover(true)
    local Owner = self.Content and self.Content.Owner
    if Owner and IsValid(Owner) then
      Owner.GamepadFocusedItem = self
      if IsValid(Owner.ListLevel) then
        Owner.GamepadFocusedIndex = Owner.ListLevel:GetIndexForItem(self.Content)
      end
    end
  end
end

function M:OnRemovedFromFocusPath(_)
  self:SetGamepadHover(false)
  local Owner = self.Content and self.Content.Owner
  if Owner and IsValid(Owner) and Owner.GamepadFocusedItem == self then
    Owner.GamepadFocusedItem = nil
  end
end

function M:OnKeyDown(_, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if "Gamepad_FaceButton_Bottom" == InKeyName then
      self:OnBtnClicked()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

return M
