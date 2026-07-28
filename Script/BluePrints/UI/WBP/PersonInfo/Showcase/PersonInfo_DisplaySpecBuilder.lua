local DisplayTypes = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayTypes")
local M = {}

function M:BuildSceneSpec(View, Params)
  Params = Params or {}
  local Entities = Params.Entities or self:BuildDefaultEntities(View)
  return {
    SceneType = Params.SceneType or CommonConst.EPreviewSceneType.PreviewCommon,
    SceneLocation = Params.SceneLocation,
    FocusEntityId = Params.FocusEntityId,
    Entities = Entities
  }
end

function M:BuildDefaultEntities(View)
  local Entities = {}
  if not View then
    return Entities
  end
  local CharData = -1 ~= View.SelectCharIndex and View:GetCurrentShowcaseCharData() or nil
  if CharData then
    table.insert(Entities, self:BuildCharacterEntitySpec(View, CharData))
  end
  return Entities
end

function M:BuildCharacterEntitySpec(View, CharData)
  local AppearanceInfo
  if View and View.GetCurrentShowcaseAppearanceInfo then
    AppearanceInfo = View:GetCurrentShowcaseAppearanceInfo()
  end
  return {
    Id = self:_BuildCharacterEntityId(1),
    Type = DisplayTypes.EntityType.Char,
    Source = {
      CharData = CharData,
      Avatar = View and View:GetCurrentShowcaseAvatar() or nil
    },
    Transform = nil,
    Appearance = AppearanceInfo,
    Anim = nil,
    Visible = true
  }
end

function M:_BuildCharacterEntityId(SlotIndex)
  return "char_slot_" .. tostring(SlotIndex)
end

return M
