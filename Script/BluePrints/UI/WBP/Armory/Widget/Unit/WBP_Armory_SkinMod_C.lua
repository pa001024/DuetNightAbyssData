require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})

function M:Construct()
  self.TextNot:SetText(GText("UI_Mod_Not_Get"))
  self.TextWear:SetText(GText("UI_Accessory_Equipped"))
  self.WBP_Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    }
  })
  self:AddInputMethodChangedListen()
  self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.CurInputDeviceType = CurInputDevice
  self:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Gamepad then
    self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:Init(Params)
  self.Params = Params
  local Avatar = ArmoryUtils:GetAvatar()
  local HasMod = false
  local ModServerData
  for _, Mod in pairs(Avatar.Mods) do
    if Mod.ModId == Params.ModId then
      ModServerData = Mod
      HasMod = true
      break
    end
  end
  self.HasMod = HasMod
  if HasMod then
    if Params.ForbidModBtn then
      self.NormalAnim = self.Not
    else
      self.NormalAnim = self.Normal
    end
    self.NoHaveNode:SetVisibility(UIConst.VisibilityOp.Collapsed)
    local Target = Params.Target
    local IsEquiped = false
    for key, value in pairs(ModServerData.WeaponUuids or {}) do
      if value == Target.Uuid then
        IsEquiped = true
        break
      end
    end
    if IsEquiped then
      self.HaveNode:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
      self.HaveNode:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  else
    self.NormalAnim = self.Not
    self.NoHaveNode:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.HaveNode:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.NormalAnim)
  if Params.ForbidModBtn or not self.HasMod then
    self.Button_Mod:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Button_Mod:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  local Data = DataMgr.Mod[Params.ModId]
  if not Data then
    return
  end
  self:SetRarity(Data.Rarity)
  self.TextModName:SetText(GText(Data.Name))
  local ModId, Uuid
  if ModServerData then
    self.TextCostNum:SetText(ModServerData.CostMod)
    ModId = ModServerData.ModId
    Uuid = ModServerData.Uuid
  else
    self.TextCostNum:SetText(Data.Cost + Data.MaxLevel * Data.CostChange)
    ModId = Data.Id
  end
  self.Image_ModIcon:SetBrushResourceObject(LoadObject(Data.Icon))
  self.WBP_Com_TipsMenuAnchor:InitializeSetUp(nil, {
    Type = "Mod",
    ItemType = "Mod",
    UnitId = ModId,
    ItemId = ModId,
    Uuid = Uuid,
    IsShowDetails = true
  })
  self.WBP_Com_TipsMenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Remove(self, self.OnMenuOpenChanged)
  self.WBP_Com_TipsMenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self, self.OnMenuOpenChanged)
  self:StopAnimation(self.Normal)
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.IsMenuOpened = false
end

function M:SetRarity(Rarity)
  local VarName = "Qua_" .. (Rarity or "")
  if self[VarName] then
    local MI = self.Image_Qua:GetDynamicMaterial()
    if MI then
      MI:SetTextureParameterValue("MainTex", self[VarName])
    end
  end
end

function M:OnBtnClicked()
  AudioManager(self):PlayUISound(nil, "event:/ui/common/click_mid", nil, nil)
  self.WBP_Com_TipsMenuAnchor:OpenItemDetailsWidget()
end

function M:OnBtnModClicked()
  if self.Params and self.Params.OnModBtnClicked then
    if self.Params.IsPreviewMode then
      return
    end
    self.Params.OnModBtnClicked(self.Params.Owner)
  end
end

function M:OnMenuOpenChanged(bIsOpen)
  self.IsMenuOpened = bIsOpen
  if bIsOpen then
    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
  else
    self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:StopAnimation(self.Click)
    self:PlayAnimation(self.NormalAnim)
  end
end

function M:OnBtnHovered()
  if self.IsMenuOpened then
    return
  end
  if self.CurInputDeviceType == ECommonInputType.Touch then
    return
  else
    AudioManager(self):PlayUISound(nil, "event:/ui/common/hover_btn_large", nil, nil)
    self:StopAnimation(self.Unhover)
    self:PlayAnimation(self.Hover)
  end
end

function M:OnBtnUnhovered()
  if self.IsMenuOpened then
    return
  end
  if self.CurInputDeviceType == ECommonInputType.Touch then
    return
  end
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.Unhover)
end

function M:OnBtnReleased()
  if self.IsMenuOpened then
    return
  end
  self:StopAnimation(self.Press)
  self:PlayAnimation(self.NormalAnim)
end

function M:OnBtnPressed()
  if self.IsMenuOpened then
    return
  end
  self:StopAnimation(self.NormalAnim)
  self:PlayAnimation(self.Press)
end

return M
