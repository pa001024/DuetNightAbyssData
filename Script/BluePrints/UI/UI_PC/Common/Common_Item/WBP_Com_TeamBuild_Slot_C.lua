require("UnLua")
local TeamSelectComponent = require("BluePrints.UI.UI_PC.Common.TeamSelectComponent")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local DefaultSoundPath = "event:/ui/common/click_mid"

function M:Construct()
  self.Checked = false
  self.CurrentClickIsForbid = false
  self.IsForbidden = false
  self.IsEmpty = true
  self.WeaponType = "Melee"
  self.Icon_Item = self.Item and self.Item.Image_Bg or self.Image_Bg
  self.Icon_Empty = self.Item and self.Item.Image_Empty or self.Image_Empty
  self.Img_Quality = self.Item and self.Item.Image_Quality or self.Image_Quality
  self:BindButtonPerformances()
  if self.Img_Quality then
    self.Img_Quality:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:Destruct()
  self:UnBindButtonPerformances()
end

function M:Init(SlotName, LineupPage)
  self.SlotName = SlotName
  self.LineupPage = LineupPage
  self.IsForbidden = false
  self.CurrentClickIsForbid = false
  if self.Icon_Empty then
    self.Icon_Empty:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  self:SetEmptyIcon()
  self:SetIsChecked(false)
end

function M:Update(Content)
  if not Content then
    self:Clear()
    return
  end
  if not self:IsContentCompatible(Content) then
    self:Clear()
    return
  end
  self.Uuid = Content.Uuid
  if self.LineupPage and self.LineupPage.Uuid2SlotMap then
    local OldSlotInfo = self.LineupPage.Uuid2SlotMap[self.Uuid]
    if OldSlotInfo and OldSlotInfo.SlotName and OldSlotInfo.SlotName ~= self.SlotName then
      local OldSlotWidget = self.LineupPage.Slots and self.LineupPage.Slots[OldSlotInfo.SlotName]
      if OldSlotWidget and OldSlotWidget.Uuid == self.Uuid and OldSlotWidget.Clear then
        self.LineupPage.Uuid2SlotMap[self.Uuid] = nil
        OldSlotWidget:Clear()
      end
    end
    self.LineupPage.Uuid2SlotMap[self.Uuid] = {
      SlotName = self.SlotName
    }
  end
  if self.IsEmpty then
    self.IsEmpty = false
    if self.Icon_Empty then
      self.Icon_Empty:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
  self:SetSoundPath(Content.Type)
  self:SetRarity(Content.Rarity)
  local IconPath
  if self.SlotName == TeamSelectComponent.ESlotName.Char then
    IconPath = Content.GachaIcon or Content.Icon
  else
    IconPath = Content.Icon
  end
  self:SetIcon(IconPath)
  self:PlayRefreshAnim()
end

function M:IsContentCompatible(Content)
  if not Content then
    return false
  end
  local SlotType = TeamSelectComponent.SlotName2Type[self.SlotName]
  if not SlotType then
    return false
  end
  if Content.Type == "Weapon" then
    if "Weapon" == SlotType then
      return true
    end
    if SlotType == Content.Tag then
      return true
    end
  elseif Content.Type == SlotType then
    return true
  end
  return false
end

function M:SetSoundPath(Type)
  if "Char" == Type then
    self.SoundPath = "event:/ui/armory/click_select_role"
  elseif "Weapon" == Type then
    self.SoundPath = "event:/ui/armory/click_select_weapon"
  elseif "Pet" == Type then
    self.SoundPath = "event:/ui/common/click_select_pet"
  else
    self.SoundPath = DefaultSoundPath
  end
end

function M:SetRarity(Rarity)
  if not Rarity or not self.Img_Quality then
    if self.Img_Quality then
      self.Img_Quality:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    return
  end
  self.Img_Quality:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  if self.Item then
    local RarityTexture = self.Item["Img_Quality_" .. Rarity]
    if RarityTexture then
      self.Img_Quality:SetBrushResourceObject(RarityTexture)
      return
    end
  end
  if self.Icon_Item then
    local IconDynaMaterial = self.Icon_Item:GetDynamicMaterial()
    if IconDynaMaterial then
      IconDynaMaterial:SetScalarParameterValue("Index", Rarity)
    end
  end
end

function M:SetIcon(IconPath)
  if not IconPath or not self.Icon_Item then
    self:SetEmptyIcon()
    return
  end
  local IconDynaMaterial = self.Icon_Item:GetDynamicMaterial()
  if IconDynaMaterial then
    IconDynaMaterial:SetTextureParameterValue("IconMap", LoadObject(IconPath))
    IconDynaMaterial:SetScalarParameterValue("IconMapOpacity", 1)
    IconDynaMaterial:SetScalarParameterValue("BGLightHeight", 0)
  end
end

function M:SetEmptyIcon()
  if not self.Icon_Item then
    return
  end
  local IconDynaMaterial = self.Icon_Item:GetDynamicMaterial()
  if IconDynaMaterial then
    IconDynaMaterial:SetScalarParameterValue("IconMapOpacity", 0)
    IconDynaMaterial:SetScalarParameterValue("BGLightHeight", 1)
  end
end

function M:Clear()
  if self.IsEmpty then
    return false
  end
  self.IsEmpty = true
  if self.LineupPage and self.LineupPage.Uuid2SlotMap and self.Uuid then
    self.LineupPage.Uuid2SlotMap[self.Uuid] = nil
  end
  self.Uuid = nil
  self.WeaponType = "Melee"
  self:SetEmptyIcon()
  if self.Icon_Empty then
    self.Icon_Empty:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  if self.Img_Quality then
    self.Img_Quality:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  self:PlayRemindAnim()
  return true
end

function M:SetIsChecked(IsChecked)
  if self.Checked == IsChecked then
    return
  end
  self.Checked = IsChecked
  if IsChecked then
    self:PlayButtonSelectAnim()
  else
    self:SwitchNormalAnimation()
    if self.IsForbidden then
      self:PlayButtonForbidAnim()
    end
  end
end

function M:SetForbidden(IsForbid)
  if self.IsForbidden == IsForbid then
    return
  end
  self.IsForbidden = IsForbid
  if IsForbid then
    self:PlayButtonForbidAnim()
  else
    self:PlayButtonUnForbidAnim()
  end
end

function M:OnClicked(bNotToList)
  if self.LineupPage and self.LineupPage.OnSlotClicked then
    self.LineupPage:OnSlotClicked(self.SlotName)
  end
end

function M:OnForbiddenClicked()
  UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, GText("Abyss_Sigil_ConditionsAreNot"))
end

function M:BindButtonPerformances()
  local Btn = self.Item and self.Item.Btn_Click or self.Btn_Click
  if not Btn then
    return
  end
  Btn.OnClicked:Add(self, self.OnBtnClicked)
  Btn.OnPressed:Add(self, self.OnBtnPressed)
  Btn.OnReleased:Add(self, self.OnBtnReleased)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
    Btn.OnHovered:Add(self, self.OnBtnHovered)
    Btn.OnUnhovered:Add(self, self.OnBtnUnhovered)
  end
end

function M:UnBindButtonPerformances()
  local Btn = self.Item and self.Item.Btn_Click or self.Btn_Click
  if not Btn then
    return
  end
  Btn.OnClicked:Clear()
  Btn.OnPressed:Clear()
  Btn.OnReleased:Clear()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
    Btn.OnHovered:Clear()
    Btn.OnUnhovered:Clear()
  end
end

function M:SwitchNormalAnimation()
  self:StopAllAnimations()
  if self.Normal then
    self:PlayAnimation(self.Normal)
  end
  if self.Item then
    self.Item:StopAllAnimations()
    if self.Item.Normal then
      self.Item:PlayAnimation(self.Item.Normal)
    end
  end
end

function M:PlayButtonClickSound()
  if self.IsEmpty then
    AudioManager(self):PlayUISound(self, DefaultSoundPath, nil, nil)
  else
    AudioManager(self):PlayUISound(self, self.SoundPath or DefaultSoundPath, nil, nil)
  end
end

function M:PlayButtonClickAnimation()
  if self.Item then
    self.Item:StopAllAnimations()
    if self.Item.Click then
      self.Item:PlayAnimation(self.Item.Click)
    end
  end
end

function M:OnBtnClicked(bNotPlaySound, bNotToList)
  if self.CurrentClickIsForbid ~= self.IsForbidden then
    return
  end
  if self.IsForbidden == true then
    self:OnForbiddenClicked()
  else
    if self.Checked == false then
      if not bNotPlaySound then
        self:PlayButtonClickSound()
      end
      self:PlayButtonClickAnimation()
    end
    self:OnClicked(bNotToList)
  end
end

function M:PlayButtonPressAnim()
  if self.Item then
    self.Item:StopAllAnimations()
    if self.Item.Press then
      self.Item:PlayAnimation(self.Item.Press)
    end
  end
end

function M:OnBtnPressed()
  if self.Checked == true then
    return
  end
  if true == self.IsForbidden then
    self.CurrentClickIsForbid = true
    return
  end
  self.CurrentClickIsForbid = false
  self.IsPressing = true
  self:PlayButtonPressAnim()
end

function M:PlayButtonHoverAnim()
  if self.Item then
    self.Item:StopAllAnimations()
    if self.Item.Hover then
      self.Item:PlayAnimation(self.Item.Hover)
    end
  end
end

function M:OnBtnHovered()
  if self.Checked == true then
    return
  end
  if true == self.IsForbidden then
    return
  end
  self.IsHovering = true
  self:PlayButtonHoverAnim()
end

function M:PlayButtonReleaseButHoverAnim()
  self:StopAllAnimations()
  self:PlayButtonHoverAnim()
end

function M:PlayButtonReleaseAndUnHoverAnim()
  self:StopAllAnimations()
  self:SwitchNormalAnimation()
end

function M:OnBtnReleased()
  self.IsPressing = false
  if self.Checked == true then
    return
  end
  if true ~= self.IsForbidden and not self.IsHovering then
    self:PlayButtonReleaseAndUnHoverAnim()
  elseif true ~= self.IsForbidden then
    self:PlayButtonReleaseButHoverAnim()
  end
end

function M:PlayButtonUnHoverAnim()
  self:StopAllAnimations()
  self:SwitchNormalAnimation()
end

function M:OnBtnUnhovered()
  self.IsHovering = false
  if self.Checked == true then
    return
  end
  if true ~= self.IsForbidden and not self.IsPressing then
    self:PlayButtonUnHoverAnim()
  end
end

function M:PlayButtonForbidAnim()
  self:StopAllAnimations()
  if self.Item then
    self.Item:StopAllAnimations()
  end
  if self.Forbidden then
    self:PlayAnimation(self.Forbidden)
  end
end

function M:PlayButtonUnForbidAnim()
  self:StopAllAnimations()
  if self.Item then
    self.Item:StopAllAnimations()
  end
  if self.IsHovering then
    self:PlayButtonHoverAnim()
  else
    self:SwitchNormalAnimation()
  end
end

function M:PlayButtonSelectAnim()
  if self.Item then
    self.Item:StopAllAnimations()
    if self.Item.Select then
      self.Item:PlayAnimation(self.Item.Select)
    end
  end
end

function M:PlayRemindAnim()
  if self.Remind then
    self:PlayAnimation(self.Remind)
  end
end

function M:PlayRefreshAnim()
  if self.Item then
    self.Item:StopAllAnimations()
    if self.Item.Refresh then
      self.Item:PlayAnimation(self.Item.Refresh)
    end
  end
end

return M
