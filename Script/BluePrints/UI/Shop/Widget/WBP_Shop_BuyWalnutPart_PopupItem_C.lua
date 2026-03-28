require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
end

function M:InitModItem(ModId, Level, Count, bMaxLevel)
  local ModData = DataMgr.Mod[ModId]
  assert(ModData, "未找到对应的Mod数据：" .. ModId)
  local Material = self.Image_Qua:GetDynamicMaterial()
  local Rarity = ModData.Rarity
  local Path = "Texture2D'/Game/UI/Texture/Static/Image/Common/Item/T_Item_Hover_" .. Rarity .. ".T_Item_Hover_" .. Rarity .. "'"
  local RarityMaterial = LoadObject(Path)
  assert(RarityMaterial, "稀有度未找到对应材质:" .. Path)
  if Material then
    Material:SetTextureParameterValue("MainTex", RarityMaterial)
  end
  local Icon = LoadObject(ModData.Icon)
  assert(Icon, "未找到对应的ModIcon" .. ModId)
  self.Image_ModIcon:SetBrushFromTexture(Icon)
  self.Text_Level01:SetText("+" .. Level)
  self.Text_Level02:SetText("+" .. Level)
  if bMaxLevel then
    self.WS_Level:SetActiveWidgetIndex(1)
  else
    self.WS_Level:SetActiveWidgetIndex(0)
  end
  self.Text_PriceMoneyNum:SetText("×" .. Count)
end

return M
