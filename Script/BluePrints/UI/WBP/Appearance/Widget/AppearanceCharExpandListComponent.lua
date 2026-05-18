local M = {}
M._components = {
  "BluePrints.UI.WBP.Appearance.Widget.AppearanceExpandListComponentBase"
}

function M:CreateFilterInfo()
  self:CreateCharFilterInfo()
end

function M:CreateCharFilterInfo()
  if self.CharFilterTags then
    return
  end
  self.CharFilterTags, self.CharFilterNames = UIUtils.GetAllElementTypes()
  self.CharFilterIcons = {}
  for key, Tag in pairs(self.CharFilterTags) do
    local IconName = "Armory_" .. Tag
    table.insert(self.CharFilterIcons, "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName)
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
  self.CharOrderByDisplayNames = self.Arr_OrderBy
  self.CharOrderByAttrNames = self.CommonOrderByAttrNames
end

AssembleComponents(M)
return M
