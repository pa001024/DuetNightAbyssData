require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  self.bIsFocusable = true
end

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
    if Mat.SetScalarParameterValue then
      Mat:SetScalarParameterValue("IconMapOpacity", 1)
    end
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
  self.Content = Content
  SetIconByPath(self.Icon_Talent, Content.IconPath)
  if IsValid(self.Text_Talent) then
    self.Text_Talent:SetText(Content.Name or "")
  end
  if IsValid(self.Text_TalentDesc) then
    self.Text_TalentDesc:SetText(Content.Desc or "")
  end
end

function M:OnAddedToFocusPath(_)
  if UIUtils.IsGamepadInput() then
    local Owner = self.Content and self.Content.Owner
    if Owner and IsValid(Owner) and IsValid(Owner.ListBuffDes) then
      Owner.GamepadFocusedIndex = Owner.ListBuffDes:GetIndexForItem(self.Content)
    end
  end
end

return M
