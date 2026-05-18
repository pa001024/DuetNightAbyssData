local M = {}
M._components = {
  "BluePrints.UI.WBP.Appearance.Widget.AppearanceExpandListComponentBase"
}

function M:CreateFilterInfo()
  self:CreateWeaponFilterInfo()
end

function M:CreateWeaponFilterInfo()
  self.MeleeFilterTags, self.MeleeFilterNames, self.RangedFilterTags, self.RangedFilterNames = UIUtils.GetAllWeaponTags()
  self.MeleeFilterIcons, self.Melee2Icon, self.RangedFilterIcons, self.Ranged2Icon = UIUtils.GetAllWeaponTagIcons()
end

function M:CreateWeaponFilterTags()
  if not self.ComparedWeaponName or not self[self.ComparedWeaponName] then
    return
  end
  
  local function _concat(FromTable, ToTable)
    table.move(FromTable, 1, #FromTable, #ToTable + 1, ToTable)
  end
  
  self.WeaponFilterTags = {}
  self.WeaponFilterNames = {}
  self.WeaponFilterIcons = {}
  if self.bFromArchive then
    if self[self.ComparedWeaponName]:HasTag(CommonConst.WeaponType.MeleeWeapon) then
      _concat(self.MeleeFilterTags, self.WeaponFilterTags)
      _concat(self.MeleeFilterNames, self.WeaponFilterNames)
      _concat(self.MeleeFilterIcons, self.WeaponFilterIcons)
    else
      _concat(self.RangedFilterTags, self.WeaponFilterTags)
      _concat(self.RangedFilterNames, self.WeaponFilterNames)
      _concat(self.RangedFilterIcons, self.WeaponFilterIcons)
    end
  else
    _concat(self.MeleeFilterTags, self.WeaponFilterTags)
    _concat(self.RangedFilterTags, self.WeaponFilterTags)
    _concat(self.MeleeFilterNames, self.WeaponFilterNames)
    _concat(self.RangedFilterNames, self.WeaponFilterNames)
    _concat(self.MeleeFilterIcons, self.WeaponFilterIcons)
    _concat(self.RangedFilterIcons, self.WeaponFilterIcons)
  end
end

function M:Init()
  self.Arr_OrderBy = {
    "UI_LEVEL_SELECT"
  }
  self.CommonOrderByAttrNames = {
    "Level",
    "SortPriority",
    "UnitId"
  }
  self.MeleeOrderByDisplayNames = self.Arr_OrderBy
  self.RangedOrderByDisplayNames = self.Arr_OrderBy
  self.WeaponOrderByDisplayNames = self.Arr_OrderBy
  self.MeleeOrderByAttrNames = self.CommonOrderByAttrNames
  self.RangedOrderByAttrNames = self.CommonOrderByAttrNames
  self.WeaponOrderByAttrNames = self.CommonOrderByAttrNames
end

AssembleComponents(M)
return M
