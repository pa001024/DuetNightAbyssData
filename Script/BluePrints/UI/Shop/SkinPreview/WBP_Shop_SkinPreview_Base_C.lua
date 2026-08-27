require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
M._components = {
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent",
  "BluePrints.UI.Shop.SkinPreview.SkinPreview_ActorComponent",
  "BluePrints.UI.Shop.SkinPreview.SkinPreview_DescriptionComponent",
  "BluePrints.UI.Shop.SkinPreview.SkinPreview_PurchaseComponent",
  "BluePrints.UI.WBP.Armory.ActorController.PreviewActorComponent"
}

function M:Construct()
  M.Super.Construct(self)
  self.KeyDownEvents = {}
  self.KeyUpEvents = {}
  self.RepeatKeyDownEvents = {}
  self.TabStyleName = "Text"
  self.UKey = "U"
  self.RKey = "R"
  self.EscapeKey = EKeys.Escape.KeyName
  self.LeftThumbstickKey = UIConst.GamePadKey.LeftThumb
  self.GamePadHideUIKey = UIConst.GamePadKey.FaceButtonLeft
  self.GamePadBackKey = UIConst.GamePadKey.FaceButtonRight
  self.GamePadConfirmKey = UIConst.GamePadKey.FaceButtonBottom
  self.GamePadOpenSuitKey = UIConst.GamePadKey.FaceButtonTop
  self.LeftShoulderKey = UIConst.GamePadKey.LeftShoulder
  self.RightShoulderKey = UIConst.GamePadKey.RightShoulder
  self.LeftTriggerKey = UIConst.GamePadKey.LeftTriggerThreshold
  self.RightTriggerKey = UIConst.GamePadKey.RightTriggerThreshold
  self.DPadLeftKey = UIConst.GamePadKey.DPadLeft
  self.DPadRightKey = UIConst.GamePadKey.DPadRight
  self.DPadUpKey = UIConst.GamePadKey.DPadUp
  self.MenuKey = UIConst.GamePadKey.SpecialRight
  self.ViewKey = UIConst.GamePadKey.SpecialLeft
  self.ZoomKey = "Mouse_Button"
  self.ReplayKey = "R"
  self.MainTabsStyle = {
    TitleName = GText("UI_Armory_Appearance"),
    LeftKey = "NotShow",
    RightKey = "NotShow",
    Tabs = {},
    DynamicNode = {
      "Back",
      "ResourceBar"
    },
    BottomKeyInfo = {},
    StyleName = "Text",
    OwnerPanel = self,
    LastFocusWidget = self,
    OnResourceBarAddedToFocusPath = function()
      self.Btn_Function:SetGamePadVisibility(ESlateVisibility.Collapsed)
      self.Key_GamePad_L:SetVisibility(ESlateVisibility.Collapsed)
      self.Key_GamePad_R:SetVisibility(ESlateVisibility.Collapsed)
    end,
    OnResourceBarRemovedFromFocusPath = function()
      if self.IsGamepadInput then
        self.Btn_Function:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_GamePad_L:SetVisibility((self.bFirst or self.ShopItemData.SinglePreview) and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
        self.Key_GamePad_R:SetVisibility((self.bLast or self.ShopItemData.SinglePreview) and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
      end
    end,
    BackCallback = self.OnBackKeyDown
  }
  local ConfigData = {
    ClickCallback = self.OnClickSuitPreviewDialog,
    OwnerWidget = self
  }
  self.Btn_Preview:Init(ConfigData)
  
  function self.Btn_Preview.SoundFunc()
    AudioManager(self):PlayUISound(self.Btn_Preview, "event:/ui/common/click_btn_small", nil, nil)
  end
  
  self:ResetPreviewCheckBox()
  self.CheckBox_Preview:RemoveEventOnCheckStateChanged(self)
  self.CheckBox_Preview:AddEventOnCheckStateChanged(self, self.OnSwitchSuitPreview)
  self.Btn_Function:BindEventOnClicked(self, self.PurChase)
  self.Btn_Function:TryOverrideSoundFunc(function()
  end)
  self.Btn_Selective = self.Btn_Dye.Btn_Click
  self.Text_Color = self.Btn_Dye.Text_Btn
  self.HorizontalBox_Color = self.Btn_Dye
  self.Btn_Selective.OnClicked:Add(self, self.OnClickDyeingPreview)
  self.Btn_L:BindEventOnClicked(self, self.OnClickPreviousSkin)
  self.Btn_R:BindEventOnClicked(self, self.OnClickNextSkin)
  self.Image_Click.OnMouseButtonDownEvent:Unbind()
  self.Image_Click.OnMouseButtonDownEvent:Bind(self, self.On_Image_Click_MouseButtonDown)
  self.Btn_Choose:UnBindEventOnClickedByObj(self)
  self.Btn_Choose:BindEventOnClicked(self, self.OnBtnChooseGiftClicked)
  self.Btn_Choose:BindForbidStateExecuteEvent(self, self.OnBtnChooseGiftClicked)
  self.Com_Hint:UnBindEventOnClickedByObj(self)
  self.Com_Hint:BindEventOnClicked(self, function()
    ShopUtils:OpenLockConditionPopup(self.ShopItemData)
  end)
  self.Text_Preview:SetText(GText("UI_SkinPreview_ShowSuit"))
  self.Text_Color:SetText(GText("UI_SkinPreview_Dye"))
  self.Btn_Function:SetText(GText("UI_SHOP_PURCHASE"))
  self.Text_Fenghua:SetText(GText("UI_AppearanceScore_Score"))
  self.Panel_Buy:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Btn_Preview:SetVisibility(ESlateVisibility.Collapsed)
  self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
  self.WBP_Com_Cost:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Num_Price:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.bForbiddenButton = false
  self.bSelfHidden = false
  self.BtnChooseGiftEnable = false
  self.BtnSkinLevelUp = false
  self.Tab_Change.Text_Alive:SetText(GText("UI_Armory_Meleeweapon"))
  self.Tab_Change.Text_Dying:SetText(GText("UI_Armory_Longrange"))
  self.IsGamepadInput = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  self.Btn_Discount_Light:SetVisibility(ESlateVisibility.Collapsed)
  self.WBP_Armory_SkinMod.WBP_Com_TipsMenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Remove(self, self.OnModMenuStateChanged)
  self.WBP_Armory_SkinMod.WBP_Com_TipsMenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self, self.OnModMenuStateChanged)
end

function M:Destruct()
  self:DestroyPreviewActor()
  self.CheckBox_Preview:RemoveEventOnCheckStateChanged(self)
  self.Btn_Function:UnBindEventOnClickedByObj(self)
  self.Btn_Selective.OnClicked:Clear()
  self.Image_Click.OnMouseButtonDownEvent:Unbind()
  M.Super.Destruct(self)
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self)
  self.ShopItemData, self.ParentWidget = ...
  self.bInGiftShop = self.ParentWidget and self.ParentWidget.ShopType == "GiftShop" or false
  if self.bInGiftShop then
    self.Btn_Function:SetText(GText("UI_SendGift_Send"))
  else
    self.Btn_Function:SetText(GText("UI_SHOP_PURCHASE"))
  end
  if not self.ShopItemData.SinglePreview then
    if self.ShopItemData.SkinList then
      self.SkinList = self.ShopItemData.SkinList
      self.Index2ShopSkin = {}
      self.ShopSkin2Index = {}
      self.SkinCount = #self.SkinList
      for Index, SkinId in ipairs(self.SkinList) do
        self.Index2ShopSkin[Index] = SkinId
        self.ShopSkin2Index[SkinId] = Index
      end
      self.ShopItemData.TypeId = self.Index2ShopSkin[1]
      self.ShopItemData.ItemId = self.Index2ShopSkin[1]
    else
      self.Index2ShopSkin, self.ShopSkin2Index, self.SkinCount = ShopUtils:GetShopSkinList()
    end
    if self.Index2ShopSkin == nil or self.ShopSkin2Index == nil or self.SkinCount == nil then
      self.ShopItemData.SinglePreview = true
      self.ShopItemData.HidePurchase = false
    end
  end
  self.HidePurchase = self.ShopItemData.HidePurchase or false
  self.Tab_Skin:Init(self.MainTabsStyle)
  if self.Tab_Skin.WBP_Com_Tab_ResourceBar then
    self.Tab_Skin.WBP_Com_Tab_ResourceBar:SetLastFocusWidget(self)
  end
  self.Tab_Change:Init({
    Parent = self,
    TabIdx = 1,
    OnTabClicked = self.OnTabChangeClicked
  })
  self:InitKeySetting()
  self:UpdateUI()
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "SkinPreviewIn", nil)
  self:StopAllAnimations()
  self:PlayAnimation(self.In)
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  self:SetFocus()
  self:InitLevelUpPreview(self.ShopItemData)
end

function M:InitKeySetting()
  self.KeyDownEvents[self.EscapeKey] = self.OnBackKeyDown
  self.KeyDownEvents[self.UKey] = self.OnHideUIKeyDown
  self.KeyDownEvents[self.RKey] = self.OnRKeyDown
  self.KeyDownEvents[self.GamePadBackKey] = self.OnBackKeyDown
  self.RepeatKeyDownEvents[self.LeftTriggerKey] = self.OnCameraScrollBackwardKeyDown
  self.RepeatKeyDownEvents[self.RightTriggerKey] = self.OnCameraScrollForwardKeyDown
  self.KeyDownEvents[self.GamePadHideUIKey] = self.OnHideUIKeyDown
  self.KeyDownEvents[self.MenuKey] = self.OnMenuKeyDown
  self.KeyDownEvents[self.ViewKey] = self.OnClickDyeingPreview
  self.KeyDownEvents[self.LeftThumbstickKey] = self.OnLTKeyDown
  self.KeyDownEvents[self.GamePadConfirmKey] = self.OnConfirmKeyDown
  self.KeyDownEvents[self.DPadLeftKey] = self.OnClickPreviousSkin
  self.KeyDownEvents[self.DPadRightKey] = self.OnClickNextSkin
  self.KeyDownEvents[self.DPadUpKey] = self.OnClickDiscount
  self.KeyDownEvents[self.LeftShoulderKey] = function(self)
    if self.ShopItemData.ItemType ~= "WeaponAccessory" then
      return
    end
    self.Tab_Change:TriggerSwitch("Left")
    return UIUtils.Handled, true
  end
  self.KeyDownEvents[self.RightShoulderKey] = function(self)
    if self.ShopItemData.ItemType ~= "WeaponAccessory" then
      return
    end
    self.Tab_Change:TriggerSwitch("Right")
    return UIUtils.Handled, true
  end
  self.KeyUpEvents[self.MenuKey] = self.OnMenuKeyUp
end

function M:OnLTKeyDown()
  if self.bSelfHidden then
    return
  end
  if self.IsWeaponModAccessory then
    self.WBP_Armory_SkinMod:OnBtnClicked()
  else
    self:OnBtnChooseGiftClicked()
  end
end

function M:OnBtnChooseGiftClicked()
  if self.BtnChooseGiftEnable then
    if self.Btn_Choose:IsBtnForbidden() then
      ShopUtils:OpenForbidGiftChooseTip()
    else
      ShopUtils:OpenChooseGiftTarget(self.ShopItemData.ItemId, self)
    end
  elseif self.BtnSkinLevelUp then
    if self.WBP_Armory_Skin_LevelUp_1.Btn_Area:HasAnyUserFocus() or self.WBP_Armory_Skin_LevelUp_2.Btn_Area:HasAnyUserFocus() or self.WBP_Armory_Skin_LevelUp_3.Btn_Area:HasAnyUserFocus() then
      return
    else
      self.WBP_Armory_Skin_LevelUp_1:SetFocus()
    end
  end
  return UIUtils.Handled, true
end

function M:OnClickSuitPreview()
  if self.ShopItemData.SuitRewardId == nil or 0 == #self.ShopItemData.SuitRewardId then
    return
  end
  if self.bBlockClickSuitPreview or self.bBlockClickChangeSkin then
    return
  end
  self.CheckBox_Preview:OnBtnClicked()
  return UIUtils.Handled, true
end

function M:OnSwitchSuitPreview(IsChecked)
  self.bBlockClickSuitPreview = true
  self.CheckBox_Preview.ButtonArea:SetVisibility(ESlateVisibility.HitTestInvisible)
  self:AddTimer(0.6, function(self)
    self.bBlockClickSuitPreview = false
    self.CheckBox_Preview.ButtonArea:SetVisibility(ESlateVisibility.Visible)
  end)
  self.SwitchSuitChecked = IsChecked
  if IsChecked then
    self:ApplySuitPreview(self.ShopItemData)
  else
    self:RevertToSingleItemPreview(self.ShopItemData)
  end
end

function M:OnBackKeyDown()
  if self.bSelfHidden then
    return self:OnHideUIKeyDown()
  else
    self:CloseSelf()
    return UIUtils.Handled, true
  end
end

function M:OnHideUIKeyDown()
  self.bSelfHidden = not self.bSelfHidden
  self:RestoreHideUIVisualState()
  if self.bSelfHidden then
    self:ApplyHideUIVisualState()
  end
  return UIUtils.Handled, true
end

function M:RestoreHideUIVisualState()
  self:SetRenderOpacity(1)
  self.Image_Click.Slot:SetZOrder(-1)
  if self._OriginVisibilityMap then
    for Widget, Visibility in pairs(self._OriginVisibilityMap) do
      if Widget and IsValid(Widget) then
        Widget:SetVisibility(Visibility)
      end
    end
  end
  self._OriginVisibilityMap = {}
end

function M:ApplyHideUIVisualState()
  self.Image_Click.Slot:SetZOrder(10)
  if self.IsWeaponModAccessory then
    self:SetRenderOpacity(1)
    self._OriginVisibilityMap = {}
    local Count = self.Root:GetChildrenCount()
    for i = 0, Count - 1 do
      local Child = self.Root:GetChildAt(i)
      if Child ~= self.Group_Video and Child ~= self.Image_Click then
        self._OriginVisibilityMap[Child] = Child:GetVisibility()
        Child:SetVisibility(ESlateVisibility.Hidden)
      end
    end
    return
  end
  self:SetRenderOpacity(0)
  self._OriginVisibilityMap = {}
end

function M:HideUIExceptVideo()
  self:SetRenderOpacity(1)
  self.Image_Click.Slot:SetZOrder(self.bSelfHidden and 10 or -1)
  local Count = self.Root:GetChildrenCount()
  for i = 0, Count - 1 do
    local Child = self.Root:GetChildAt(i)
    if Child ~= self.Group_Video and Child ~= self.Image_Click then
      if self.bSelfHidden then
        if self._OriginVisibilityMap[Child] == nil then
          self._OriginVisibilityMap[Child] = Child:GetVisibility()
        end
        Child:SetVisibility(ESlateVisibility.Hidden)
      elseif self._OriginVisibilityMap[Child] ~= nil then
        Child:SetVisibility(self._OriginVisibilityMap[Child])
      end
    end
  end
end

function M:OnMenuKeyDown()
  if self.bSelfHidden then
    return
  end
  if self.ShopItemData.SuitRewardId ~= nil and 0 ~= #self.ShopItemData.SuitRewardId then
    self:OnClickSuitPreviewDialog()
  elseif self.ShopItemData.ItemType == "WeaponAccessory" and self.ShopItemData.TypeId and 0 ~= self.ShopItemData.TypeId then
    local WeaponAccessoryData = DataMgr.WeaponAccessory[self.ShopItemData.TypeId]
    if WeaponAccessoryData and WeaponAccessoryData.StanceFXType ~= "Accessory" and self.Btn_CheckMod then
      self.Btn_CheckMod:OnViewInfoHover()
    end
  end
end

function M:OnMenuKeyUp()
  if self.ShopItemData.ItemType == "WeaponAccessory" and self.ShopItemData.TypeId and 0 ~= self.ShopItemData.TypeId then
    local WeaponAccessoryData = DataMgr.WeaponAccessory[self.ShopItemData.TypeId]
    if WeaponAccessoryData and WeaponAccessoryData.StanceFXType ~= "Accessory" and self.Btn_CheckMod then
      self.Btn_CheckMod:OnViewInfoUnHover()
    end
  end
end

function M:OnModMenuStateChanged(bIsOpen)
end

function M:OnClickSuitPreviewDialog()
  if self.ShopItemData.SuitRewardId == nil or 0 == #self.ShopItemData.SuitRewardId then
    return
  end
  local Rewards = DataMgr.Reward[self.ShopItemData.SuitRewardId[1]]
  if Rewards then
    local Params = {
      ItemId = Rewards.Id,
      ItemType = Rewards.Type
    }
    UIManager(self):ShowCommonPopupUI(100240, Params, self)
  end
  return UIUtils.Handled, true
end

function M:OnRKeyDown()
  if self.ShopItemData.ItemType ~= "Resource" and self.ShopItemData.ItemType ~= "Mount" then
    return
  end
  if self.ShopItemData.ResourceSType == "GestureItem" then
    self:OnReplayGesture()
  elseif self.ShopItemData.ItemType == "Mount" then
    self:OnRideMount()
  end
  return UIUtils.Handled, true
end

function M:OnReplayGesture()
  if self.ShopItemData.ItemType ~= "Resource" then
    return
  end
  if self.ReplayGesture then
    self:ReplayGesture(self.ShopItemData.TypeId)
  end
end

function M:OnRideMount()
  if self.ShopItemData.ItemType ~= "Mount" then
    return
  end
  if self.RiderMount then
    self:RiderMount(self.ShopItemData.TypeId)
  end
end

function M:OnClickDyeingPreview()
  if self.bBlockClickSuitPreview or self.bBlockClickChangeSkin then
    return
  end
  if self.ShopItemData.ItemType == "Hair" then
    local HairData = self.ShopItemData.TypeId and DataMgr.Hair[self.ShopItemData.TypeId]
    if not HairData or HairData.IsCommon == true then
      return
    end
  end
  if self.ShopItemData.ItemType ~= "Skin" and self.ShopItemData.ItemType ~= "WeaponSkin" and self.ShopItemData.ItemType ~= "Hair" then
    return
  end
  if self.SwitchSuitChecked then
    self.CheckBox_Preview:OnBtnClicked()
  end
  local SkinType
  if self.ShopItemData.ItemType == "Hair" then
    SkinType = CommonConst.DataType.Hair
  elseif self.ShopItemData.ItemType == "Skin" or self.ShopItemData.ItemType == "WeaponSkin" then
    SkinType = CommonConst.DataType.Skin
  end
  AudioManager(self):PlayUISound(self.Btn_Selective, "event:/ui/common/click_btn_small", nil, nil)
  local Params = {
    Target = self.Params.Target,
    Type = self.Params.Type,
    SkinId = self.Params.SkinId,
    HairId = self.Params.HairId,
    IsPreviewMode = self.IsPreviewMode,
    Parent = self,
    OpenPreviewDyeFromShopItem = true,
    SkinType = SkinType,
    OnCloseCallback = function()
      local Avatar = ArmoryUtils:GetAvatar()
      if self.Params.Type == CommonConst.ArmoryType.Char then
        self.Params.Target = Avatar.Chars[self.Params.Target.Uuid] or self.Params.Target
      elseif self.Params.Type == CommonConst.ArmoryType.Weapon then
        self:ResetWeaponCamera()
        self.Params.Target = Avatar.Weapons[self.Params.Target.Uuid] or self.Params.Target
      end
    end
  }
  if Params.Target and 1 == Params.Target.Uuid then
    Params.Target.Uuid = Params.SkinId
    local RealAvatar = ArmoryUtils:GetAvatar()
    if RealAvatar and self.Type == CommonConst.ArmoryType.Char and RealAvatar.Chars then
      for CharUuid, RealChar in pairs(RealAvatar.Chars) do
        if RealChar.CharId == Params.Target.CharId then
          Params.Target = RealChar
          Params.bRealCharOrWeapon = true
          break
        end
      end
    elseif self.Type == CommonConst.ArmoryType.Weapon and RealAvatar.Weapons then
      for WeaponUuid, RealWeapon in pairs(RealAvatar.Weapons) do
        if RealWeapon.WeaponId == Params.Target.WeaponId then
          Params.Target = RealWeapon
          Params.bRealCharOrWeapon = true
          break
        end
      end
    end
  elseif Params.Target and 1 ~= Params.Target.Uuid then
    Params.bRealCharOrWeapon = true
  end
  Params.IsPreviewMode = true
  local UIConfig = DataMgr.SystemUI.ArmoryDye
  if self.Parent then
    UIManager(self):LoadUI(UIConst.LoadInConfig, UIConfig.UIName, self.Parent:GetZOrder(), Params)
  else
    UIManager(self):LoadUI(UIConst.LoadInConfig, UIConfig.UIName, 100, Params)
  end
  return UIUtils.Handled, true
end

function M:OnTabChangeClicked(TabIdx)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if self.SwitchSuitChecked then
    self.CheckBox_Preview:OnBtnClicked()
  elseif self.SwitchWeaponAccessoryPreview then
    self:SwitchWeaponAccessoryPreview(TabIdx)
  end
end

function M:ResetPreviewCheckBox()
  local Checked = self.CheckBox_Preview:GetChecked()
  self.CheckBox_Preview.IsChecked = false
  self.CheckBox_Preview.ButtonArea:SetVisibility(ESlateVisibility.Visible)
  self.SwitchSuitChecked = false
  if Checked then
    self.CheckBox_Preview:PlayAnimation(self.CheckBox_Preview.Close_Normal)
  end
end

function M:OnClickPreviousSkin()
  if self.bFirst or self.bBlockClickChangeSkin or self.bBlockClickSuitPreview or self.ShopItemData.SinglePreview then
    return
  end
  self:ResetPreviewCheckBox()
  self.LastItemType = self.ShopItemData.ItemType
  self:SwitchToSkin(self.Index - 1)
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_addMulti", nil, nil)
  return UIUtils.Handled, true
end

function M:OnClickNextSkin()
  if self.bLast or self.bBlockClickChangeSkin or self.bBlockClickSuitPreview or self.ShopItemData.SinglePreview then
    return
  end
  self:ResetPreviewCheckBox()
  self.LastItemType = self.ShopItemData.ItemType
  self:SwitchToSkin(self.Index + 1)
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_addMulti", nil, nil)
  return UIUtils.Handled, true
end

function M:SwitchToSkin(targetIndex)
  local SkinInfo = self:GetSkinInfo(targetIndex)
  if not SkinInfo then
    return
  end
  local bReapplyHideUI = self.bSelfHidden
  if bReapplyHideUI then
    self:RestoreHideUIVisualState()
  end
  self.ShopItemData = SkinInfo
  if self.ShopItemData.ItemType == "WeaponAccessory" or self.ShopItemData.ItemType == "CharAccessory" then
    AudioManager(self):PlayItemSound(self, self.ShopItemData.TypeId, "Equip", self.ShopItemData.ItemType)
  end
  self:UpdateUI()
  if bReapplyHideUI then
    self:ApplyHideUIVisualState()
  end
  self:PlayAnimation(self.Change)
  self:BlockAllUIInput(true, "SP_DisplayOnly")
end

function M:UpdateUI()
  self.Btn_Selective.OnClicked:Clear()
  self:UpdatePreviewActor(self.ShopItemData, FVector(40, 35, 0))
  self:UpdateDescription(self.ShopItemData)
  local Avatar = GWorld:GetAvatar()
  self.Num_Fenghua:SetText(Avatar:GetAppearanceScore(self.ShopItemData.ItemType, self.ShopItemData.TypeId) or "")
  self.bBlockClickChangeSkin = true
  self.Btn_L.Btn:SetVisibility(ESlateVisibility.HitTestInvisible)
  self.Btn_R.Btn:SetVisibility(ESlateVisibility.HitTestInvisible)
  self:AddTimer(0.6, function(self)
    self.bBlockClickChangeSkin = false
    self.Btn_L.Btn:SetVisibility(ESlateVisibility.Visible)
    self.Btn_R.Btn:SetVisibility(ESlateVisibility.Visible)
  end)
  if not self.HidePurchase then
    if self.ShopItemData.PriceType == CommonConst.Coins.Coin1 then
      self.MainTabsStyle.OverridenTopResouces = {
        CommonConst.Coins.Coin4,
        CommonConst.Coins.Coin1
      }
    else
      self.MainTabsStyle.OverridenTopResouces = {
        self.ShopItemData.PriceType
      }
    end
    self.Tab_Skin:OverrideTopResource(self.MainTabsStyle.OverridenTopResouces, true)
  end
  if self.ShopItemData.SuitRewardId then
    self.Panel_Preview:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_Preview:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Preview:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.CheckBox_Preview:SetVisibility(ESlateVisibility.Visible)
  else
    self.Panel_Preview:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_Preview:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Preview:SetVisibility(ESlateVisibility.Collapsed)
    self.CheckBox_Preview:SetVisibility(ESlateVisibility.Collapsed)
  end
  if not self.ShopItemData.SinglePreview then
    self.Index, self.bFirst, self.bLast = self:GetSkinIndex(self.ShopItemData.ItemId)
    self.Btn_L:SetVisibility(self.bFirst and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
    self.Btn_R:SetVisibility(self.bLast and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
  else
    self.Btn_L:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_R:SetVisibility(ESlateVisibility.Collapsed)
  end
  self.bCanOpenDiscount = false
  if not self.HidePurchase then
    local TrackInfo = {}
    TrackInfo.product_id = self.ShopItemData.ItemId
    TrackInfo.shop_id = self.ShopItemData.SubTabId
    HeroUSDKSubsystem(self):UploadTrackLog_Lua("shop_previewpage", TrackInfo)
    self.IsLockState = ShopUtils:CheckShopItemCondition(self.ShopItemData)
    if self.IsLockState then
      self:UpdateLockCondition()
    else
      self:UpdateDiscount()
      self:UpdatePrice()
      self:UpdateButtonBuy()
      self:RemoveTimer("UpdatePriceTimer")
      local CutoffInfo = ShopUtils:GetShopItemCutoffData(self.ShopItemData.ItemId)
      if CutoffInfo and CutoffInfo.CutoffEndTime then
        local NowTime = TimeUtils and TimeUtils.NowTime() or 0
        local RemainTime = CutoffInfo.CutoffEndTime - NowTime
        if RemainTime > 0 then
          self:AddTimer(RemainTime, function()
            if not self or not IsValid(self) then
              return
            end
            self:UpdateDiscount()
            self:UpdatePrice()
            self:UpdateButtonBuy()
          end, false, 0, "UpdatePriceTimer")
        end
      end
    end
  else
    self.WidgetSwitcher_BtnState:SetVisibility(ESlateVisibility.Collapsed)
    self.Panel_Buy:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Discount_Light:SetVisibility(ESlateVisibility.Collapsed)
    self.bForbiddenButton = true
  end
  self:UpdateReplayTips()
  self:InitLevelUpPreview(self.ShopItemData)
end

function M:UpdateReplayTips()
end

function M:GetOverrideTopResource()
  if self.ShopItemData.PriceType == CommonConst.Coins.Coin1 then
    return {
      CommonConst.Coins.Coin4,
      CommonConst.Coins.Coin1
    }
  else
    return {
      self.ShopItemData.PriceType
    }
  end
end

function M:OnConfirmKeyDown()
  if self.bSelfHidden then
    return
  end
  if self.IsLockState then
    if self.ConditionDisplay then
      return
    end
    ShopUtils:OpenLockConditionPopup(self.ShopItemData)
  else
    self:PurChase()
  end
end

function M:CloseSelf()
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  self:StopAnimation(self.In)
  self:PlayAnimation(self.Out)
  AudioManager(self):SetEventSoundParam(self, "SkinPreviewIn", {ToEnd = 1})
  self:ClosePreview()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local KeyDownEvent = self.KeyDownEvents[InKeyName]
  if self.InSelectDiscountMode then
    return UIUtils.Handled
  end
  if KeyDownEvent then
    local Reply, IsHandled = KeyDownEvent(self)
    if IsHandled then
      return Reply
    end
  elseif not self.bSelfHidden then
    self.Tab_Skin:Handle_KeyEventOnGamePad(InKeyName)
  end
  return UIUtils.Handled
end

function M:OnRepeatKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local RepeatKeyDownEvent = self.RepeatKeyDownEvents[InKeyName]
  if RepeatKeyDownEvent then
    local Reply, IsHandled = RepeatKeyDownEvent(self)
    if IsHandled then
      return Reply
    end
  end
  return UIUtils.Unhandled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local KeyUpEvent = self.KeyUpEvents[InKeyName]
  if KeyUpEvent then
    local Reply, IsHandled = KeyUpEvent(self)
    if IsHandled then
      return Reply
    end
  end
  return UIUtils.Handled
end

function M:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
  return self:OnPointerDown(MyGeometry, MouseEvent)
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
  return self:OnMouseWheelScroll(MyGeometry, MouseEvent)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  return self:OnPointerUp(MyGeometry, MouseEvent)
end

function M:OnMouseMove(MyGeometry, MouseEvent)
  return self:OnPointerMove(MyGeometry, MouseEvent)
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
  return self:OnPointerUp(MyGeometry, InTouchEvent)
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
  return self:OnPointerMove(MyGeometry, InTouchEvent)
end

function M:OnCameraScrollBackwardKeyDown()
  self:ScrollCamera(1)
end

function M:OnCameraScrollForwardKeyDown()
  self:ScrollCamera(-1)
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self.InSelectDiscountMode then
    return UIUtils.Unhandled
  end
  if "Gamepad_RightX" == InKeyName then
    if self.ActorController then
      if self.EnableDrag == false then
        return UIUtils.Unhandled
      end
      local DeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
      self.ActorController:OnDragViewActor({X = DeltaX})
    end
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:OnMouseCaptureLost()
  self:OnPointerCaptureLost()
end

function M:OnBackgroundClicked()
  if self.bSelfHidden then
    self:OnHideUIKeyDown()
  end
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Out then
    self:CloseMVPSequence()
    M.Super.Close(self)
    if not self.HidePurchase or not self.ShopItemData.SinglePreview then
      self:RefreshShopUI()
    end
  elseif InAnimation == self.In or InAnimation == self.Change then
    self:BlockAllUIInput(false)
  end
end

function M:RefreshShopUI()
  local Shop = UIManager(self):GetLastJumpPage()
  if Shop then
    if Shop.RefreshSubTabData then
      Shop:RefreshSubTabData(Shop.CurSubTabMap, true, true)
    elseif Shop.UpdateShopDetail then
      Shop:UpdateShopDetail(Shop.CurSubTabMap)
    end
    return
  end
  local ShopMain = UIManager(GWorld.GameInstance):GetUIObj("ShopMain")
  if ShopMain then
    ShopMain.NotNeedPlayEntryAnimation = true
    ShopMain:RefreshSubTabData(ShopMain.CurSubTabMap, true, true)
  end
  local CommonShopActivity = UIManager(GWorld.GameInstance):GetUIObj("ShopActivity")
  if CommonShopActivity then
    CommonShopActivity:RefreshSubTabData(CommonShopActivity.CurSubTabMap, true, true)
  end
  local ActivityShop = UIManager(GWorld.GameInstance):GetUIObj("ActivityShop")
  if ActivityShop then
    ActivityShop:UpdateShopDetail(ActivityShop.CurSubTabMap)
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  M.Super.OnUpdateUIStyleByInputTypeChange(self, CurInputDevice, CurGamepadName)
end

function M:GetSkinIndex(ShopItemId)
  local Index = self.ShopSkin2Index[ShopItemId]
  local bFirst = 1 == Index
  local bLast = Index == self.SkinCount
  return Index, bFirst, bLast
end

function M:GetSkinInfo(Index)
  if self.SkinList then
    local SkinTypeId = self.SkinList[Index]
    local SkinItemData = {}
    SkinItemData.ItemType = self.ShopItemData.ItemType
    SkinItemData.TypeId = SkinTypeId
    SkinItemData.ItemId = SkinTypeId
    return SkinItemData
  end
  local ShopItemId = self.Index2ShopSkin[Index]
  local ShopItemData
  if ShopItemId and DataMgr.ShopItem[ShopItemId] then
    ShopItemData = setmetatable({}, {
      __index = DataMgr.ShopItem[ShopItemId]
    })
  end
  return ShopItemData
end

function M:HideZoomKey(IsHidden)
end

function M:HideReplayKey(IsHidden)
end

function M:UpdateSkinNameFontByRarity(Rarity)
  local rarityFontMap = {
    [6] = self.Font_Red,
    [5] = self.Font_Gold,
    [4] = self.Font_Purple,
    [3] = self.Font_Blue
  }
  local fontToSet = rarityFontMap[Rarity]
  if fontToSet then
    self.Text_SkinName:SetFont(fontToSet)
  end
end

function M:GetCutoffInfo(ItemId)
  if not ItemId then
    return nil
  end
  for _, CutoffData in pairs(DataMgr.Cutoff or {}) do
    if CutoffData.ItemId and CutoffData.ItemId == ItemId then
      return CommonUtils.DeepCopy(CutoffData)
    end
  end
  return nil
end

function M:InitLevelUpPreview(ItemData)
  if ItemData.ItemType == "Skin" or ItemData.ItemType == "WeaponSkin" then
    local IsDisplay
    if ItemData.ItemType == "Skin" then
      IsDisplay = DataMgr.SkinUpgrade and DataMgr.SkinUpgrade[ItemData.TypeId]
    elseif ItemData.ItemType == "WeaponSkin" then
      IsDisplay = DataMgr.WeaponSkinUpgrade and DataMgr.WeaponSkinUpgrade[ItemData.TypeId]
    end
    if not IsDisplay then
      self.Panel_LevelUp:SetVisibility(UIConst.VisibilityOp.Collapsed)
      return
    end
    self.Panel_LevelUp:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.BtnSkinLevelUp = true
    local MaxLevel = self.WB_LevelUp:GetChildrenCount()
    for Index = 1, MaxLevel do
      local LevelUpWidget = self["WBP_Armory_Skin_LevelUp_" .. Index]
      if LevelUpWidget then
        local Params = {
          Level = Index,
          IsLocked = false,
          IsShowReddot = false,
          Obj = self,
          ClickedCallback = self.OnLevelUpWidgetClicked
        }
        LevelUpWidget:InitContent(Params)
      end
    end
    self.SelectedSkinLevel = 1
    self["WBP_Armory_Skin_LevelUp_" .. self.SelectedSkinLevel]:PlaySelectedAnimation()
  else
    self.Panel_LevelUp:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnLevelUpWidgetClicked(Level)
  if Level == self.SelectedSkinLevel then
    return
  end
  local LastLevelUpWidget = self["WBP_Armory_Skin_LevelUp_" .. self.SelectedSkinLevel]
  if LastLevelUpWidget then
    LastLevelUpWidget:PlayNormalAnimation()
  end
  if self.CheckBox_Preview and self.CheckBox_Preview:IsVisible() then
    self:ResetPreviewCheckBox()
  end
  self.SelectedSkinLevel = Level
  local CurLevelUpWidget = self["WBP_Armory_Skin_LevelUp_" .. self.SelectedSkinLevel]
  if CurLevelUpWidget then
    CurLevelUpWidget:PlaySelectedAnimation()
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  local SkinId = self.ShopItemData.TypeId
  self.ShopItemData.SkinLevel = Level
  local SkinLevelUpData
  if self.ShopItemData.ItemType == "Skin" then
    SkinLevelUpData = DataMgr.SkinUpgrade[SkinId][Level]
  elseif self.ShopItemData.ItemType == "WeaponSkin" then
    SkinLevelUpData = DataMgr.WeaponSkinUpgrade[SkinId][Level]
  end
  if SkinLevelUpData then
    self.Panel_Buy:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Text_Undiscounted_Price:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WBP_Com_Cost:InitContent({
      CostText = GText("UI_Skin_Upgrade_Cost"),
      ResourceId = SkinLevelUpData.UnlockCurrency,
      Numerator = SkinLevelUpData.UnlockAmount
    })
    self.WBP_Com_Cost:SetGamePadIconVisible(false)
    self.Btn_Function:ForbidBtn(true)
    if self.HidePurchase then
      self.WidgetSwitcher_BtnState:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(2)
      self.Text_Lock:SetText(GText("UI_Skin_Upgrade_Locked"))
    end
  elseif not self.HidePurchase then
    self.Panel_Buy:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:UpdateDiscount()
    self:UpdatePrice()
    self:UpdateButtonBuy()
  else
    self.Panel_Buy:SetVisibility(ESlateVisibility.Collapsed)
    self.WidgetSwitcher_BtnState:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.UpdateSkinLevelPreview then
    self:UpdateSkinLevelPreview(Level)
  elseif self.UpdatePreviewActor then
    self:UpdatePreviewActor(self.ShopItemData, FVector(40, 35, 0))
  end
end

AssembleComponents(M)
return M
