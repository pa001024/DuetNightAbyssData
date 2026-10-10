require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local TypeIconConfig = {
  Char = {Index = 0, WidgetName = "Img_Avatar"},
  Weapon = {Index = 1, WidgetName = "Img_Weapon"},
  Pet = {Index = 2, WidgetName = "Img_Pet"}
}

local function ApplyIcon(Image, IconTexture)
  if not Image or not IconTexture then
    return
  end
  local DynMat = Image:GetDynamicMaterial()
  if DynMat then
    DynMat:SetTextureParameterValue("IconMap", IconTexture)
  elseif Image.SetBrushFromTexture then
    Image:SetBrushFromTexture(IconTexture)
  end
end

function M:Init(Data)
  Data = Data or {}
  local Id = Data.Id
  local Level = Data.Level
  local Type = Data.Type or "Char"
  local IconPath
  if "Weapon" == Type then
    IconPath = Id and DataMgr.Weapon[Id] and DataMgr.Weapon[Id].Icon
  elseif "Pet" == Type then
    IconPath = Id and DataMgr.Pet[Id] and DataMgr.Pet[Id].Icon
  else
    IconPath = Id and DataMgr.Char[Id] and DataMgr.Char[Id].Icon
  end
  if self.Switch_Type then
    if IconPath then
      self.Switch_Type:SetActiveWidgetIndex(0)
      local IconConfig = TypeIconConfig[Type] or TypeIconConfig.Char
      if self.WS_Icon then
        self.WS_Icon:SetActiveWidgetIndex(IconConfig.Index)
      end
      ApplyIcon(self[IconConfig.WidgetName], LoadObject(IconPath))
    else
      if Id then
        DebugPrint("WBP_Com_Ranking_CharSlot: invalid " .. tostring(Type) .. " Id " .. tostring(Id))
      end
      self.Switch_Type:SetActiveWidgetIndex(1)
    end
  end
  if self.Text_Level then
    self.Text_Level:SetText(tostring(Level or ""))
  end
end

return M
