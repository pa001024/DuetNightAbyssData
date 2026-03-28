require("UnLua")
local SquadBuildComponent = require("BluePrints.UI.UI_PC.Common.SquadBuildComponent")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local DefaultSoundPath = "event:/ui/common/click_mid"

function M:Construct()
  self.Checked = false
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
  self.Minus.Btn_Minus.Button_Area.OnClicked:Add(self, self.OnMinusClicked)
  self.Panel_Text:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:Destruct()
  self:UnBindButtonPerformances()
end

function M:Init(SlotName, LineupPage)
  self.SlotName = SlotName
  self.LineupPage = LineupPage
  self.IsForbidden = false
  if self.Icon_Empty then
    self.Icon_Empty:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  self:SetEmptyIcon()
  self:SetIsChecked(false)
  if SlotName == SquadBuildComponent.ESlotName.Pet then
    self:PlayAnimation(self.Pet_Loop)
  else
    self:PlayAnimation(self.Pet_Off)
  end
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
  self.UnitId = Content.UnitId
  self.IsTryout = Content.IsTryout or false
  self.Type = Content.Type
  if self.LineupPage and self.LineupPage.Uuid2SlotMap then
    local OldSlotInfo = self.LineupPage.Uuid2SlotMap[self.Uuid]
    if OldSlotInfo and OldSlotInfo.SlotName ~= self.SlotName then
      local OldSlotWidget = self.LineupPage.Slots and self.LineupPage.Slots[OldSlotInfo.SlotName]
      if OldSlotWidget and OldSlotWidget.Uuid == self.Uuid and OldSlotWidget.Clear then
        self.LineupPage.Uuid2SlotMap[self.Uuid] = nil
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
    if self.WeaponSlot then
      self.WeaponSlot:SetForbidden(false)
    end
  end
  self:SetSoundPath(Content.Type)
  self:SetRarity(Content.Rarity)
  local IconPath
  if self.SlotName == SquadBuildComponent.ESlotName.Char then
    IconPath = Content.GachaIcon or Content.Icon
  else
    IconPath = Content.Icon
  end
  self:SetIcon(IconPath)
  self:PlayRefreshAnim()
  if Content.IsTryout and Content.Tag ~= "Pet" then
    self.Text_Trial:SetText(GText("UI_Wuyousheng_ArmoryTrial"))
    self.Text_Trial:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Panel_Trial:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Text_Trial:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Trial:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if Content.NeedShowModIndexInfo and Content.ModSuitIndex then
    self.Panel_Text:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    local SuitName = GText(string.format("Mod_SuitName_%s", Content.ModSuitIndex))
    self.Text_Name:SetText(SuitName)
  else
    self.Panel_Text:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Minus:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:IsContentCompatible(Content)
  if not Content then
    return false
  end
  local SlotType = SquadBuildComponent.SlotName2Type[self.SlotName]
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
  self.Panel_Trial:SetVisibility(UIConst.VisibilityOp.Collapsed)
  local IconDynaMaterial = self.Icon_Item:GetDynamicMaterial()
  if IconDynaMaterial then
    IconDynaMaterial:SetScalarParameterValue("IconMapOpacity", 0)
    IconDynaMaterial:SetScalarParameterValue("BGLightHeight", 1)
  end
  if not self.Select then
    self:PlayAnimation(self.Normal)
  end
end

function M:Clear()
  self.Panel_Text:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if self.Content == nil then
    return
  end
  self.IsEmpty = true
  if self.LineupPage and self.LineupPage.Uuid2SlotMap and self.Uuid then
    self.LineupPage.Uuid2SlotMap[self.Uuid] = nil
  end
  self.Uuid = nil
  self.WeaponType = "Melee"
  self.Content.bInGear = false
  self.Content.IsChosen = false
  self.Content.WeaponMiniPhantomIconCharId = nil
  if self.Content.SelfWidget then
    self.Content.SelfWidget:SetInGear(false)
    self.Content.SelfWidget:SetWeaponMiniPhantomIcon(nil)
  end
  self.Content = nil
  self:SetEmptyIcon()
  if self.Icon_Empty then
    self.Icon_Empty:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  if self.Img_Quality then
    self.Img_Quality:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  if self.WeaponSlot then
    if self.WeaponSlot.Uuid and self.LineupPage and self.LineupPage.UpdateSingleTeamIcon then
      self.LineupPage:UpdateSingleTeamIcon(self.WeaponSlot.Uuid, false, self.WeaponSlot.WeaponType)
    end
    self.WeaponSlot:Clear()
    self.WeaponSlot:SetForbidden(true)
  end
  self:PlayRemindAnim()
  self.Minus:SetVisibility(UIConst.VisibilityOp.Collapsed)
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
  if self.SlotName == SquadBuildComponent.ESlotName.PhantomWeapon1 or self.SlotName == SquadBuildComponent.ESlotName.PhantomWeapon2 then
    local PhantomSlotName = self.SlotName == SquadBuildComponent.ESlotName.PhantomWeapon1 and SquadBuildComponent.ESlotName.Phantom1 or SquadBuildComponent.ESlotName.Phantom2
    if self.LineupPage and self.LineupPage.Slots then
      local PhantomSlot = self.LineupPage.Slots[PhantomSlotName]
      if PhantomSlot and PhantomSlot.PlayFlashRedAnim then
        PhantomSlot:PlayFlashRedAnim()
      end
    end
  end
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
  if self.Item then
    self.Item:StopAllAnimations()
  end
  if self.Normal then
    self:PlayAnimation(self.Normal)
  end
  if self.Item and self.Item.Normal then
    self.Item:PlayAnimation(self.Item.Normal)
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
  self:StopAllAnimations()
  if self.Item then
    self.Item:StopAllAnimations()
  end
  if self.Click then
    self:PlayAnimation(self.Click)
  end
  if self.Item and self.Item.Click then
    self.Item:PlayAnimation(self.Item.Click)
  end
end

function M:OnBtnClicked(bNotPlaySound, bNotToList)
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
  self:StopAllAnimations()
  if self.Item then
    self.Item:StopAllAnimations()
  end
  if self.Press then
    self:PlayAnimation(self.Press)
  end
  if self.Item and self.Item.Press then
    self.Item:PlayAnimation(self.Item.Press)
  end
end

function M:OnBtnPressed()
  if self.Checked == true then
    return
  end
  self.IsPressing = true
  self:PlayButtonPressAnim()
end

function M:PlayButtonHoverAnim()
  self:StopAllAnimations()
  if self.Item then
    self.Item:StopAllAnimations()
  end
  if self.Hover then
    self:PlayAnimation(self.Hover)
  end
  if self.Item and self.Item.Hover then
    self.Item:PlayAnimation(self.Item.Hover)
  end
end

function M:OnBtnHovered()
  if self.LineupPage.IsUseGamePad then
    self.LineupPage.FocusWidget = self
    if self.LineupPage.UpdateGamepadKeyInfoByHasItem then
      DebugPrint("self.IsEmpty: " .. tostring(self.IsEmpty), self.Type)
      self.LineupPage:UpdateGamepadKeyInfoByHasItem(not self.IsEmpty)
    end
  end
  if self.Checked == true then
    return
  end
  self.IsHovering = true
  self:PlayButtonHoverAnim()
end

function M:PlayButtonReleaseButHoverAnim()
  self:StopAllAnimations()
  if self.Item then
    self.Item:StopAllAnimations()
  end
  self:PlayButtonHoverAnim()
end

function M:PlayButtonReleaseAndUnHoverAnim()
  self:StopAllAnimations()
  if self.Item then
    self.Item:StopAllAnimations()
  end
  self:SwitchNormalAnimation()
end

function M:OnBtnReleased()
  self.IsPressing = false
  if self.Checked == true then
    return
  end
  if not self.IsHovering then
    self:PlayButtonReleaseAndUnHoverAnim()
  else
    self:PlayButtonReleaseButHoverAnim()
  end
end

function M:PlayButtonUnHoverAnim()
  self:StopAllAnimations()
  if self.Item then
    self.Item:StopAllAnimations()
  end
  self:SwitchNormalAnimation()
end

function M:OnBtnUnhovered()
  self.IsHovering = false
  if self.Checked == true then
    return
  end
  if not self.IsPressing then
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
  if self.Item and self.Item.Forbidden then
    self.Item:PlayAnimation(self.Item.Forbidden)
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
  self:StopAllAnimations()
  if self.Item then
    self.Item:StopAllAnimations()
  end
  if self.Select then
    self:PlayAnimation(self.Select)
  end
  if self.Item and self.Item.Select then
    self.Item:PlayAnimation(self.Item.Select)
  end
end

function M:PlayRemindAnim()
  if self.Remind then
    self:PlayAnimation(self.Remind)
  end
  if self.Item and self.Item.Remind then
    self.Item:PlayAnimation(self.Item.Remind)
  end
end

function M:PlayRefreshAnim()
  self:StopAllAnimations()
  if self.Item then
    self.Item:StopAllAnimations()
  end
  if self.Refresh then
    self:PlayAnimation(self.Refresh)
  end
  if self.Item and self.Item.Refresh then
    self.Item:PlayAnimation(self.Item.Refresh)
  end
end

function M:PlayFlashRedAnim()
  self:StopAllAnimations()
  if self.Item then
    self.Item:StopAllAnimations()
  end
  if self.FlashRed then
    self:PlayAnimation(self.FlashRed)
  end
  if self.Item and self.Item.FlashRed then
    self.Item:PlayAnimation(self.Item.FlashRed)
  end
end

function M:OnMinusClicked()
  if not self.LineupPage or self.IsEmpty then
    return
  end
  local CurContent = self.Content
  if not CurContent then
    return
  end
  local Type = SquadBuildComponent.SlotName2Type[self.SlotName]
  if not Type then
    return
  end
  if "Weapon" == Type then
    if CurContent and CurContent.Tag then
      Type = CurContent.Tag
    else
      Type = self.WeaponType or "Melee"
    end
  end
  self.LineupPage:ClearSlot(self.SlotName)
  self.LineupPage:SetContentIsChosen(CurContent, false)
  self.LineupPage:UpdateCurrentUuid(Type, nil)
  if "Char" == Type then
    self.LineupPage:UpdateCharConflict()
  end
  if self.LineupPage.OnLeftItemContentChanged then
    self.LineupPage:OnLeftItemContentChanged()
  end
  if self.LineupPage.IsUseGamePad and self.LineupPage.UpdateGamepadKeyInfoByHasItem then
    self.LineupPage:UpdateGamepadKeyInfoByHasItem(not self.IsEmpty)
  end
end

function M:SetLockState(IsLock)
  if IsLock then
    self.WS_Type:SetActiveWidgetIndex(1)
  else
    self.WS_Type:SetActiveWidgetIndex(0)
  end
end

return M
