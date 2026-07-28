require("UnLua")
local Model = require("BluePrints.UI.WBP.Activity.Widget.Weapon.WeaponVerifyUIModel")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

local function SetIconByPath(Img, IconPath)
  if not (IsValid(Img) and IconPath) or "" == IconPath then
    return
  end
  local Obj = LoadObject(IconPath)
  if not IsValid(Obj) and string.find(IconPath, "/Game/") and not string.find(IconPath, "'") then
    Obj = LoadObject("Texture2D'" .. IconPath .. "'")
  end
  if not IsValid(Obj) then
    return
  end
  local Mat = Img.GetDynamicMaterial and Img:GetDynamicMaterial() or nil
  if Mat then
    Mat:SetTextureParameterValue("MainTex", Obj)
    return
  end
  if Img.SetBrushResourceObject then
    Img:SetBrushResourceObject(Obj)
    return
  end
  if Img.SetBrushFromTexture then
    Img:SetBrushFromTexture(Obj)
  end
end

function M:OnListItemObjectSet(Content)
  if not Content then
    return
  end
  local Cfg = Model.GetAffixCfg(Content.AffixId)
  SetIconByPath(self.Image_IconBuff01, Cfg and Cfg.IconPath or nil)
end

return M
