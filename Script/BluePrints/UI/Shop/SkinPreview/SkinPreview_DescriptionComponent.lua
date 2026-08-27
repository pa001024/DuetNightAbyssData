local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local M = {}

local function SetElementIcon(self, IconPath)
  local ElementIcon = IconPath and LoadObject(IconPath)
  if not ElementIcon then
    return
  end
  self.Image_Element:SetBrushResourceObject(ElementIcon)
  self.Image_Element:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if self.BG_Icon then
    self.BG_Icon:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:ResetDescriptionVisibility()
  self.BackGround:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Tag_Quality:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Text_Char_None:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Image_Element:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if self.BG_Icon then
    self.BG_Icon:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.HorizontalBox_Color:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Tab_Change:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.WBP_Mounts:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Mod_Title_Line:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Mod_Content:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Group_Video:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.VideoPlayer:Stop()
end

function M:UpdateDescription(ItemData)
  self:ResetDescriptionVisibility()
  local itemType = ItemData.ItemType
  if "Skin" == itemType then
    self:UpdateCharSkinDescription(ItemData)
  elseif "Hair" == itemType then
    self:UpdateHairDescription(ItemData)
  elseif "WeaponSkin" == itemType then
    self:UpdateWeaponSkinDescription(ItemData)
  elseif "CharAccessory" == itemType then
    self:UpdateCharAccessoryDescription(ItemData)
  elseif "WeaponAccessory" == itemType then
    self:UpdateWeaponAccessoryDescription(ItemData)
  elseif "Resource" == itemType then
    if ItemData.ResourceSType == "GestureItem" then
      self:UpdateCharGestureDescription(ItemData)
    end
  elseif "Mount" == itemType then
    self:UpdateMountDescription(ItemData)
  end
end

function M:UpdateCharSkinDescription(SkinInfo)
  local SkinData = DataMgr.Skin[SkinInfo.TypeId]
  if not SkinData then
    return
  end
  local CharInfo = DataMgr.Char[SkinData.CharId]
  if not CharInfo then
    return
  end
  self.Text_CharName:SetText(GText(CharInfo.CharName))
  self.Text_SkinName:SetText(GText(SkinData.SkinName))
  self.Text_Info:SetText(GText(SkinData.SkinDescribe))
  self.Tag_Quality:Init(SkinData.Rarity)
  self:UpdateSkinNameFontByRarity(SkinData.Rarity)
  self:HideZoomKey(false)
  self.HorizontalBox_Color:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  local ElementType = DataMgr.BattleChar[SkinData.CharId].Attribute
  if ElementType then
    local IconName = "Armory_" .. ElementType
    SetElementIcon(self, "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName)
  end
  if not self.Avatar:CheckCharEnough({
    [SkinData.CharId] = 1
  }) then
    self.Text_Char_None:SetText(GText("UI_SkinPreview_CharNotOwned"))
    self.Text_Char_None:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:UpdateHairDescription(SkinInfo)
  local HairData = DataMgr.Hair[SkinInfo.TypeId]
  if not HairData then
    return
  end
  self.Text_CharName:SetText(GText("UI_Hair_Name"))
  self.Text_SkinName:SetText(GText(HairData.Name))
  self.Text_Info:SetText(GText(HairData.HairDescribe))
  self.Tag_Quality:Init(HairData.Rarity)
  self:UpdateSkinNameFontByRarity(HairData.Rarity)
  self:HideZoomKey(false)
  SetElementIcon(self, "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_Hair.T_Tab_Fashion_Hair")
  if HairData.IsCommon ~= true then
    self.HorizontalBox_Color:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:UpdateCharAccessoryDescription(SkinInfo)
  local AccessoryData = DataMgr.CharAccessory[SkinInfo.TypeId]
  if not AccessoryData then
    return
  end
  self.Text_CharName:SetText(GText(UIConst.AccessoryTypeTextMap[AccessoryData.AccessoryType]))
  self.Text_SkinName:SetText(GText(AccessoryData.Name))
  self.Text_Info:SetText(GText(AccessoryData.Des))
  self.Tag_Quality:Init(AccessoryData.Rarity)
  self:UpdateSkinNameFontByRarity(AccessoryData.Rarity)
  self:HideZoomKey(false)
  SetElementIcon(self, ArmoryUtils:GetCharNoneAccessoryIconPaths()[AccessoryData.AccessoryType])
end

function M:UpdateCharGestureDescription(SkinInfo)
  local GestureData = DataMgr.Resource[SkinInfo.TypeId]
  if not GestureData or GestureData.ResourceSType ~= "GestureItem" then
    return
  end
  self.Text_CharName:SetText(GText("UI_Preview_GestureItem"))
  self.Text_SkinName:SetText(GText(GestureData.ResourceName))
  self.Text_Info:SetText(GText(GestureData.DetailDes))
  self.Tag_Quality:Init(GestureData.Rarity)
  self:UpdateSkinNameFontByRarity(GestureData.Rarity)
  self:HideZoomKey(false)
  SetElementIcon(self, "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Action.T_Tab_Action")
end

function M:UpdateWeaponSkinDescription(SkinInfo)
  local WeaponSkinData = DataMgr.WeaponSkin[SkinInfo.TypeId]
  if not WeaponSkinData then
    return
  end
  self.Text_SkinName:SetText(GText(WeaponSkinData.Name))
  self.Text_Info:SetText(GText(WeaponSkinData.Dec))
  self.Tag_Quality:Init(WeaponSkinData.Rarity)
  self:UpdateSkinNameFontByRarity(WeaponSkinData.Rarity)
  self:HideZoomKey(true)
  self.HorizontalBox_Color:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  local WeaponTypeInfo = DataMgr.WeaponTypeContrast[WeaponSkinData.ApplicationType]
  if not WeaponTypeInfo then
    return
  end
  self.Text_CharName:SetText(string.format(GText("UI_SkinPreview_WeaponType"), GText(WeaponTypeInfo.WeaponTagTextmap)))
  if WeaponTypeInfo.Icon then
    SetElementIcon(self, WeaponTypeInfo.Icon)
  end
end

function M:UpdateWeaponAccessoryDescription(SkinInfo)
  local WeaponAccessoryData = DataMgr.WeaponAccessory[SkinInfo.TypeId]
  if not WeaponAccessoryData then
    return
  end
  self.Text_CharName:SetText(GText(UIConst.AccessoryTypeTextMap[SkinInfo.ItemType]))
  self.Text_SkinName:SetText(GText(WeaponAccessoryData.Name))
  self.Text_Info:SetText(GText(WeaponAccessoryData.Des))
  self.Tag_Quality:Init(WeaponAccessoryData.Rarity)
  self:UpdateSkinNameFontByRarity(WeaponAccessoryData.Rarity)
  self:HideZoomKey(true)
  if WeaponAccessoryData.StanceFXType ~= "Accessory" then
    local ConfigData = {
      OwnerWidget = self,
      TextContent = GText("UI_Accessory_Stance_Tips"),
      OnMenuOpenChangedCallBack = self.OnModMenuStateChanged
    }
    self.Btn_CheckMod:Init(ConfigData)
    self.TextTitleMod:SetText(GText("UI_Accessory_Stance_Mod"))
    local Params = {
      Parant = self,
      Target = {Uuid = nil},
      Type = "Weapon",
      ForbidModBtn = true,
      ShowAlreadyHave = true,
      ModId = self:GetWeaponStanceFXModId(SkinInfo.TypeId),
      Owner = self,
      OnModBtnClicked = nil
    }
    self.WBP_Armory_SkinMod:Init(Params)
    local Params = {
      Path = WeaponAccessoryData.Video,
      SoundPath = WeaponAccessoryData.GetSoundPath
    }
    self:InitVideoInfo(Params)
    self.Group_Video:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Mod_Title_Line:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Mod_Content:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.BackGround:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Tab_Change:SetVisibility(UIConst.VisibilityOp.Visible)
  end
end

function M:UpdateMountDescription(ItemData)
  if not ItemData.TypeId then
    return
  end
  local MountData = DataMgr.Mount[ItemData.TypeId]
  if not MountData then
    return
  end
  self.Text_CharName:SetText(GText("UI_Mount"))
  self.Text_SkinName:SetText(GText(MountData.MountName))
  self.Text_Info:SetText(GText(MountData.MountDes))
  self.Tag_Quality:Init(MountData.MountRarity)
  self:UpdateSkinNameFontByRarity(MountData.MountRarity)
  SetElementIcon(self, "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Mounts.T_Tab_Mounts")
end

function M:GetWeaponStanceFXModId(WeaponAccessoryId)
  local WeaponAccessoryData = DataMgr.WeaponAccessory[WeaponAccessoryId]
  if not WeaponAccessoryData or not WeaponAccessoryData.StanceFXTag then
    return nil
  end
  local StanceFXTag = tonumber(WeaponAccessoryData.StanceFXTag)
  local ModApplicationType = DataMgr.WeaponAccessoryId2ModApplicationType and DataMgr.WeaponAccessoryId2ModApplicationType[WeaponAccessoryId]
  for ModId, ModData in pairs(DataMgr.Mod) do
    if (not ModApplicationType or ModData.ApplicationType == ModApplicationType) and ModData.ModActivateSkills then
      for _, Tag in pairs(ModData.ModActivateSkills) do
        if tonumber(Tag) == StanceFXTag then
          return ModId
        end
      end
    end
  end
end

function M:InitVideoInfo(Params)
  self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
  self.VideoPlayer:SetIsNeedAudio(true)
  Params = Params or {}
  if Params.MediaSource then
    self.VideoPlayer:SetUrlByMediaSource(Params.MediaSource)
  elseif Params.Url then
    self.VideoPlayer:SetUrl(Params.Url)
  elseif Params.Path then
    local MediaSource = LoadObject(Params.Path)
    if MediaSource then
      self.VideoPlayer:SetUrlByMediaSource(MediaSource)
    end
  end
  if Params.SoundPath then
    AudioManager(self):PlayUISound(self, "event:/ui/common/gacha_amb", "GachaAmb", nil)
    AudioManager(self):PlayUISound(self, Params.SoundPath, "SkinVideoSound", nil)
  end
  self.VideoPlayer:SetLooping(true)
  self.VideoPlayer:Play()
end

return M
