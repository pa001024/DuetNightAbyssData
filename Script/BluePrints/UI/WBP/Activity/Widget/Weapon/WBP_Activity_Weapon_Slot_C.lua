require("UnLua")
local Model = require("BluePrints.UI.WBP.Activity.Widget.Weapon.WeaponVerifyUIModel")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
M.SlotState = Model.SlotState
local HEAD_FILLED = {
  [Model.SlotType.Char] = 0,
  [Model.SlotType.Melee] = 1,
  [Model.SlotType.Ranged] = 1,
  [Model.SlotType.Pet] = 0,
  [Model.SlotType.Affix] = 2
}
local HEAD_EMPTY = {
  [Model.SlotType.Char] = 3,
  [Model.SlotType.Melee] = 4,
  [Model.SlotType.Ranged] = 5,
  [Model.SlotType.Pet] = 6,
  [Model.SlotType.Affix] = 7
}
local ICON_WIDGET = {
  [Model.SlotType.Char] = "Img_Avatar",
  [Model.SlotType.Melee] = "Img_Weapon",
  [Model.SlotType.Ranged] = "Img_Weapon",
  [Model.SlotType.Pet] = "Img_Avatar",
  [Model.SlotType.Affix] = "Image_Buff"
}

local function SetIconByPath(Img, IconPath, SlotType)
  if not (IsValid(Img) and IconPath) or "" == IconPath then
    return false
  end
  local Obj = LoadObject(IconPath)
  if not IsValid(Obj) and string.find(IconPath, "/Game/") and not string.find(IconPath, "'") then
    Obj = LoadObject("Texture2D'" .. IconPath .. "'")
  end
  if not IsValid(Obj) then
    return false
  end
  local Mat = Img.GetDynamicMaterial and Img:GetDynamicMaterial() or nil
  if Mat then
    local IsAffix = SlotType == Model.SlotType.Affix
    Mat:SetTextureParameterValue(IsAffix and "MainTex" or "IconMap", Obj)
    return true
  end
  if Img.SetBrushResourceObject then
    Img:SetBrushResourceObject(Obj)
    return true
  end
  if Img.SetBrushFromTexture then
    Img:SetBrushFromTexture(Obj)
    return true
  end
  return false
end

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
  self.Btn_Click.OnHovered:Add(self, self.OnBtnHovered)
  self.Btn_Click.OnUnhovered:Add(self, self.OnBtnUnhovered)
  self.Btn_Click.OnPressed:Add(self, self.OnBtnPressed)
end

function M:Destruct()
  self.Btn_Click.OnClicked:Remove(self, self.OnBtnClicked)
  self.Btn_Click.OnHovered:Remove(self, self.OnBtnHovered)
  self.Btn_Click.OnUnhovered:Remove(self, self.OnBtnUnhovered)
  self.Btn_Click.OnPressed:Remove(self, self.OnBtnPressed)
end

function M:SetData(Data)
  self.Data = Data
  M.RefreshDisplay(self)
end

function M:RefreshDisplay()
  local Data = self.Data
  if not Data then
    return
  end
  local SS = M.SlotState
  local State = Data.State or SS.Empty
  local IsEmpty = State == SS.Empty or State == SS.Missing
  if IsValid(self.BG) then
    self.BG:SetVisibility(IsEmpty and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  if IsValid(self.BG_1) then
    self.BG_1:SetVisibility(IsEmpty and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.HitTestInvisible)
  end
  if IsValid(self.Switch_Type) then
    self.Switch_Type:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if IsValid(self.WidgetSwitcher_Head) then
    local HeadIdx = IsEmpty and (HEAD_EMPTY[Data.SlotType] or 3) or HEAD_FILLED[Data.SlotType] or 0
    self.WidgetSwitcher_Head:SetActiveWidgetIndex(HeadIdx)
  end
  if not IsEmpty then
    local IconWidget = self[ICON_WIDGET[Data.SlotType]]
    SetIconByPath(IconWidget, Data.IconPath, Data.SlotType)
  end
  local IsMissing = State == SS.Missing
  self.IsMissing = IsMissing
  if IsValid(self.Waring_Group) then
    self.Waring_Group:SetVisibility(IsMissing and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  self:StopAllAnimations()
  if IsMissing and self.EmptyRed then
    self:PlayAnimation(self.EmptyRed)
  elseif self.Normal then
    self:PlayAnimation(self.Normal)
  end
end

function M:OnBtnClicked()
  local Data = self.Data
  if Data and Data.Owner and Data.OnClick then
    Data.OnClick(Data.Owner, Data.SlotType)
  end
end

function M:OnBtnHovered()
  if self.Data and self.Data.IsReadOnly then
    return
  end
  if self.IsMissing then
    return
  end
  self:StopAllAnimations()
  if self.Hover then
    self:PlayAnimation(self.Hover)
  end
end

function M:OnBtnUnhovered()
  if self.Data and self.Data.IsReadOnly then
    return
  end
  if self.IsMissing then
    return
  end
  self:StopAllAnimations()
  if self.Unhover then
    self:PlayAnimation(self.Unhover)
  elseif self.Normal then
    self:PlayAnimation(self.Normal)
  end
end

function M:OnBtnPressed()
  if self.Data and self.Data.IsReadOnly then
    return
  end
  if self.IsMissing then
    return
  end
  self:StopAllAnimations()
  if self.Press then
    self:PlayAnimation(self.Press)
  end
end

function M:Play_Hover()
  self.Data.IsReadOnly = true
  self:StopAllAnimations()
  self:PlayAnimation(self.Click)
end

function M:Play_Unhover()
  self.Data.IsReadOnly = false
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
end

return M
