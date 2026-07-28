require("UnLua")
local Model = require("BluePrints.UI.WBP.Activity.Widget.Weapon.WeaponVerifyUIModel")
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")
local OLD_SLOT_NAMES = {
  "Character",
  "Melee",
  "Range",
  "Pet",
  "Roulette"
}
local NEW_SLOT_NAMES = {
  "Character_1",
  "Melee_1",
  "Range_1",
  "Pet_1",
  "Roulette_1"
}
local SLOT_TYPES = {
  Model.SlotType.Char,
  Model.SlotType.Melee,
  Model.SlotType.Ranged,
  Model.SlotType.Pet,
  Model.SlotType.Affix
}

function M:InitContent(Params, PopupData, Owner)
  M.Super.InitContent(self, Params, PopupData, Owner)
  self.Params = Params
  self:RefreshContent()
end

function M:OnDestroyed()
  M.Super.OnDestroyed(self)
end

function M:RefreshContent()
  local P = self.Params
  local OldDungeonId = P.DungeonId
  local NewDungeonId = P.DungeonId
  local IsLock = not P.HideDialogTip
  self.TextBlock_40:SetText(P.ShortText or "")
  self.TextLevel:SetText(GText(IsLock and "UI_WeaponVerify_BeforeUnlock" or "UI_WeaponVerify_OldRecord"))
  self.TextLevel_1:SetText(GText(IsLock and "UI_WeaponVerify_AfterUnlock" or "UI_WeaponVerify_NewRecord"))
  local OldSquad = P.OldSquad or {}
  self:FillSlots(OLD_SLOT_NAMES, OldSquad, true)
  self:FillStars("Star%02d", OldSquad.FinishStar or 0, OldDungeonId)
  local NewSquad = P.NewSquad or {}
  self:FillSlots(NEW_SLOT_NAMES, NewSquad, false)
  self:FillStars("Star%02d_1", NewSquad.FinishStar or 0, NewDungeonId)
  if P.HideDialogTip then
    self.Owner:HideDialogTip(1)
  end
end

function M:FillSlots(Names, Squad, IsReadOnly)
  local Values = {
    [Model.SlotType.Char] = Squad.CharUuid,
    [Model.SlotType.Melee] = Squad.MeleeWeaponUuid,
    [Model.SlotType.Ranged] = Squad.RangedWeaponUuid,
    [Model.SlotType.Pet] = Squad.PetUniqueId,
    [Model.SlotType.Affix] = Squad.AffixId
  }
  for i, Name in ipairs(Names) do
    local SlotWidget = self[Name]
    local ST = SLOT_TYPES[i]
    local Val = Model.GetCurrentCharacterValue(ST, Values[ST])
    if IsValid(SlotWidget) then
      SlotWidget:SetData({
        SlotType = ST,
        State = Model.GetSlotState(ST, Val),
        IconPath = Model.GetSlotIconPath(ST, Val),
        IsReadOnly = IsReadOnly
      })
    end
  end
end

function M:FillStars(FmtStr, FinishStar, DungeonId)
  local MaxStar = Model.GetMaxStar(DungeonId)
  for i = 1, 3 do
    local StarWidget = self[string.format(FmtStr, i)]
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

return M
