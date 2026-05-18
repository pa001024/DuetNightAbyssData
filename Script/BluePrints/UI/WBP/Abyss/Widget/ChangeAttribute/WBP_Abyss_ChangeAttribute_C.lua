local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local FixedAttributes = {
  [1] = "Water",
  [2] = "Fire",
  [3] = "Wind",
  [4] = "Thunder",
  [5] = "Light",
  [6] = "Dark"
}
local NavCandidates = {
  Up = {
    [1] = {},
    [2] = {1},
    [3] = {2, 1},
    [4] = {5, 6},
    [5] = {6},
    [6] = {}
  },
  Down = {
    [1] = {2, 3},
    [2] = {3},
    [3] = {},
    [4] = {},
    [5] = {4},
    [6] = {5, 4}
  },
  Left = {
    [1] = {2},
    [2] = {},
    [3] = {2},
    [4] = {
      3,
      2,
      1
    },
    [5] = {
      2,
      1,
      3,
      4
    },
    [6] = {
      1,
      2,
      3
    }
  },
  Right = {
    [1] = {
      6,
      5,
      4
    },
    [2] = {
      5,
      6,
      4,
      3
    },
    [3] = {
      4,
      5,
      6
    },
    [4] = {5},
    [5] = {},
    [6] = {5}
  }
}

function M:Construct()
  self.Platform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
  self.Text_Title:SetText(GText("UI_Dungeon_Type_List"))
  local SelectGlows = {
    [1] = self.Select_Glow_L_1,
    [2] = self.Select_Glow_L,
    [3] = self.Select_Glow_L_2,
    [4] = self.Select_Glow_R_2,
    [5] = self.Select_Glow_R,
    [6] = self.Select_Glow_R_1
  }
  self.AttributeBtns = {
    [1] = self.Attribute_L_1,
    [2] = self.Attribute_L,
    [3] = self.Attribute_L_2,
    [4] = self.Attribute_R_2,
    [5] = self.Attribute_R,
    [6] = self.Attribute_R_1
  }
  self.AttrType2Index = {}
  for Index = 1, #self.AttributeBtns do
    local AttributeBtn = self.AttributeBtns[Index]
    if AttributeBtn then
      AttributeBtn:BindSelectGlow(SelectGlows[Index])
    end
    self.AttrType2Index[FixedAttributes[Index]] = Index
  end
  self.RecommendAttr = self.Reecommend
  self.Attributes = FixedAttributes
  self.AttributeIcons = {}
  self.AttributeEnabled = {}
  self.SelectedAttrId = -1
  self.BgSelectLeft = nil
  self:InitFixedAttributeButtons()
  self:RefreshBaseInfo()
  self:InitListenEvent()
  self:InitGamepadKeys()
  self:BindEvents()
end

function M:IsMobile()
  return self.Platform == CommonConst.CLIENT_DEVICE_TYPE.MOBILE
end

function M:Destruct()
  self:UnBindEvents()
end

function M:Init(BossInfo, Attributes, CurAttrIdx, ConfirmCallback, CloseCallback)
  if not BossInfo or not Attributes then
    GWorld.logger.error("WBP_Abyss_ChangeAttribute_C@Init: BossInfo or Attributes is nil!")
    self:Close()
    return
  end
  if not CurAttrIdx then
    self.Btn_Close:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Back:SetVisibility(ESlateVisibility.Collapsed)
  end
  self.SelectedAttrId = CurAttrIdx and -1 ~= CurAttrIdx and CurAttrIdx or -1
  self.ConfirmCallback = ConfirmCallback
  self.CloseCallback = CloseCallback
  self:SetBossInfo(BossInfo)
  self:SetAttrInfo(Attributes, self.SelectedAttrId)
  self:PlayInAnim()
  AudioManager(self):PlayUISound(self, "event:/ui/common/drama_property_change_page_in", nil, nil)
  self:SetFocus()
end

function M:InitFixedAttributeButtons()
  for Index = 1, #self.AttributeBtns do
    local AttributeBtn = self.AttributeBtns[Index]
    local Attribute = FixedAttributes[Index]
    local AttrData = DataMgr.Attribute[Attribute]
    local IconObj
    if AttrData and AttrData.Icon then
      IconObj = LoadObject(AttrData.Icon)
    end
    self.AttributeIcons[Index] = IconObj
    if AttributeBtn then
      AttributeBtn:SetAttribute(Attribute, IconObj)
    end
  end
end

function M:InitListenEvent()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshBaseInfo()
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:BindEvents()
  self.Confirm_Btn:BindEventOnClicked(self, self.OnConfirmBtnClicked)
  self.Btn_Close:Init("Close", self, self.OnCloseBtnClicked)
  self:BindToAnimationFinished(self.Out, {
    self,
    self.OnOutAnimationFinished
  })
end

function M:UnBindEvents()
  self:UnbindFromAnimationFinished(self.Out, {
    self,
    self.OnOutAnimationFinished
  })
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:SetBossInfo(BossInfo)
  local BossIcon = BossInfo.BossIcon
  if BossIcon then
    local IconDynaMaterial = self.Head_Boss:GetDynamicMaterial()
    if IconDynaMaterial then
      IconDynaMaterial:SetTextureParameterValue("MainTex", BossIcon)
    end
    IconDynaMaterial = self.BG_Boss_L:GetDynamicMaterial()
    if IconDynaMaterial then
      IconDynaMaterial:SetTextureParameterValue("MainTex", BossIcon)
    end
    IconDynaMaterial = self.BG_Boss_R:GetDynamicMaterial()
    if IconDynaMaterial then
      IconDynaMaterial:SetTextureParameterValue("MainTex", BossIcon)
    end
  else
    GWorld.logger.error("WBP_Abyss_ChangeAttribute_C@SetBossInfo: BossIcon is nil!")
  end
end

function M:SetAttrInfo(Attributes, InitialAttrIdx)
  if not Attributes then
    GWorld.logger.error("WBP_Abyss_ChangeAttribute_C@SetAttrInfo: Attributes is nil !")
    return
  elseif #Attributes <= 0 or #Attributes > 6 then
    GWorld.logger.error("WBP_Abyss_ChangeAttribute_C@SetAttrInfo: #Attributes is invalid !")
    return
  end
  local InternalIdx = {}
  local EnabledAttributeMap = {}
  for i, Attribute in ipairs(Attributes) do
    local AttrData = DataMgr.Attribute[Attribute]
    local MonsterAttr = AttrData.CounterType
    EnabledAttributeMap[MonsterAttr] = true
    table.insert(InternalIdx, self.AttrType2Index[MonsterAttr])
  end
  local InitialAttrIdx = InitialAttrIdx and InternalIdx[InitialAttrIdx]
  local FirstEnabledAttrIdx = -1
  self.AttributeEnabled = {}
  for Index = 1, #self.AttributeBtns do
    local AttributeBtn = self.AttributeBtns[Index]
    local Attribute = FixedAttributes[Index]
    local IsEnabled = true == EnabledAttributeMap[Attribute]
    self.AttributeEnabled[Index] = IsEnabled
    if IsEnabled and -1 == FirstEnabledAttrIdx then
      FirstEnabledAttrIdx = Index
    end
    if AttributeBtn then
      AttributeBtn:Init(Index, self, IsEnabled)
    end
  end
  self:RefreshAttributeBtnNavigation()
  if nil ~= InitialAttrIdx and -1 ~= InitialAttrIdx then
    self.SelectedAttrId = InitialAttrIdx
  else
    self.SelectedAttrId = FirstEnabledAttrIdx
  end
  if -1 ~= self.SelectedAttrId then
    self:AttrSelectionChanged(self.SelectedAttrId, true)
  end
end

function M:GetFirstEnabledAttrIdx(Candidates)
  if not Candidates then
    return nil
  end
  for _, AttrIdx in ipairs(Candidates) do
    if self.AttributeEnabled[AttrIdx] then
      return AttrIdx
    end
  end
  return nil
end

function M:SetNavigationRuleToAttrBtn(Button, Direction, TargetAttrIdx)
  if not Button then
    return
  end
  if TargetAttrIdx and self.AttributeBtns[TargetAttrIdx] then
    Button:SetNavigationRuleExplicit(Direction, self.AttributeBtns[TargetAttrIdx])
  else
    Button:SetNavigationRuleBase(Direction, EUINavigationRule.Stop)
  end
end

function M:RefreshAttributeBtnNavigation()
  for AttrIdx, Button in ipairs(self.AttributeBtns) do
    if Button then
      self:SetNavigationRuleToAttrBtn(Button, EUINavigation.Up, nil)
      self:SetNavigationRuleToAttrBtn(Button, EUINavigation.Down, nil)
      self:SetNavigationRuleToAttrBtn(Button, EUINavigation.Left, nil)
      self:SetNavigationRuleToAttrBtn(Button, EUINavigation.Right, nil)
      if self.AttributeEnabled[AttrIdx] then
        local UpIdx = self:GetFirstEnabledAttrIdx(NavCandidates.Up[AttrIdx])
        local DownIdx = self:GetFirstEnabledAttrIdx(NavCandidates.Down[AttrIdx])
        local LeftIdx = self:GetFirstEnabledAttrIdx(NavCandidates.Left[AttrIdx])
        local RightIdx = self:GetFirstEnabledAttrIdx(NavCandidates.Right[AttrIdx])
        self:SetNavigationRuleToAttrBtn(Button, EUINavigation.Up, UpIdx)
        self:SetNavigationRuleToAttrBtn(Button, EUINavigation.Down, DownIdx)
        self:SetNavigationRuleToAttrBtn(Button, EUINavigation.Left, LeftIdx)
        self:SetNavigationRuleToAttrBtn(Button, EUINavigation.Right, RightIdx)
      end
    end
  end
end

function M:AttrSelectionChanged(AttrIdx, bIniting)
  if nil == AttrIdx or -1 == AttrIdx then
    return
  end
  if not self.AttributeEnabled[AttrIdx] then
    return
  end
  local CurrentBtn = self.AttributeBtns[AttrIdx]
  if CurrentBtn then
    CurrentBtn:SetIsChecked(true, false, bIniting)
  end
  for Index = 1, #self.AttributeBtns do
    local AttributeBtn = self.AttributeBtns[Index]
    if AttributeBtn and AttrIdx ~= Index then
      AttributeBtn:SetIsChecked(false, false, bIniting)
    end
  end
  self.SelectedAttrId = AttrIdx
  local AttrIcon = self.AttributeIcons[AttrIdx]
  if IsValid(AttrIcon) then
    self.Attribute:SetBrushResourceObject(AttrIcon)
  end
  self:PlayBgChangeAnim(AttrIdx, bIniting)
  self:RefreshRecommendAttribute()
end

function M:PlayBgChangeAnim(AttrIdx, bIniting)
  local IsSelectLeft = AttrIdx <= #self.AttributeBtns / 2
  local PrevIsSelectLeft = self.BgSelectLeft
  if IsSelectLeft then
    local SelectAnim = bIniting and self.Bg_SelctGlow_L.Select_In or self.Bg_SelctGlow_L.Select
    if not PrevIsSelectLeft or bIniting then
      self.Bg_SelctGlow_L:StopAnimation(self.Bg_SelctGlow_L.Unselect)
      self.Bg_SelctGlow_L:PlayAnimation(SelectAnim)
      self.Bg_SelctGlow_R:StopAnimation(self.Bg_SelctGlow_R.Select)
      self.Bg_SelctGlow_R:StopAnimation(self.Bg_SelctGlow_R.Select_In)
      self.Bg_SelctGlow_R:PlayAnimation(self.Bg_SelctGlow_R.Unselect)
    end
  else
    local SelectAnim = bIniting and self.Bg_SelctGlow_R.Select_In or self.Bg_SelctGlow_R.Select
    if PrevIsSelectLeft or bIniting then
      self.Bg_SelctGlow_R:StopAnimation(self.Bg_SelctGlow_R.Unselect)
      self.Bg_SelctGlow_R:PlayAnimation(SelectAnim)
      self.Bg_SelctGlow_L:StopAnimation(self.Bg_SelctGlow_L.Select)
      self.Bg_SelctGlow_L:StopAnimation(self.Bg_SelctGlow_L.Select_In)
      self.Bg_SelctGlow_L:PlayAnimation(self.Bg_SelctGlow_L.Unselect)
    end
  end
  self.BgSelectLeft = IsSelectLeft
  self:PlayAnimation(self.Change)
end

function M:RefreshRecommendAttribute()
  local SelectedAttribute = self.Attributes[self.SelectedAttrId]
  local CounterAttribute = SelectedAttribute and DataMgr.CounterType2Attribute[SelectedAttribute]
  self.RecommendAttr:SetAttrByAttrId(CounterAttribute)
end

function M:OnForbiddenAttrClicked()
  UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Abyss_ChangeAttribute_AttrForbidden"))
end

function M:InitGamepadKeys()
  if self:IsMobile() then
    return
  end
  self.Key_Back:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "B"}
    },
    Desc = GText("UI_Tips_Close")
  })
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if self:IsMobile() then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    self.UsingGamepad = false
    self.WBox_Controller:SetVisibility(ESlateVisibility.Collapsed)
  else
    self.UsingGamepad = true
    self.WBox_Controller:SetVisibility(ESlateVisibility.HitTestInvisible)
    self:SetFocusTarget()
  end
  self.Confirm_Btn:SwitchUIType(self.UsingGamepad)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  self:SetFocusTarget()
  return UIUtils.Handled
end

function M:SetFocusTarget()
  if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
    return
  end
  local CurrentBtn = self.AttributeBtns[self.SelectedAttrId]
  if self.UsingGamepad and nil ~= CurrentBtn then
    CurrentBtn:SetFocus()
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = true
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if "Gamepad_FaceButton_Left" == InKeyName then
      if not self.Confirm_Btn.IsHovering then
        self.Confirm_Btn:OnBtnHovered()
      end
    else
      IsHandled = false
    end
  elseif "Escape" == InKeyName then
    if self.Btn_Close:IsVisible() then
      self:OnCloseBtnClicked()
    end
  else
    IsHandled = false
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = true
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if "Gamepad_FaceButton_Left" == InKeyName then
      if self.Confirm_Btn.IsHovering then
        self.Confirm_Btn:OnBtnUnhovered()
        self.Confirm_Btn:OnBtnClicked()
      end
    elseif "Gamepad_FaceButton_Right" == InKeyName then
      if self.Key_Back:IsVisible() then
        self:OnCloseBtnClicked()
      end
    else
      IsHandled = false
    end
  else
    IsHandled = false
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnConfirmBtnClicked()
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  self.bConfirmed = true
  self:PlayOutAnim()
end

function M:OnCloseBtnClicked()
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  self.bConfirmed = false
  self:PlayOutAnim()
end

function M:PlayOutAnim()
  self:PlayAnimation(self.Out)
end

function M:OnOutAnimationFinished()
  if self.bConfirmed == true then
    local CurrentAttribute = self.Attributes[self.SelectedAttrId]
    if self.ConfirmCallback then
      self.ConfirmCallback(CurrentAttribute)
    end
  end
  self:Close()
end

function M:PlayInAnim()
  self:PlayAnimation(self.In)
end

function M:Close()
  if self.CloseCallback then
    local CurrentAttribute = self.Attributes[self.SelectedAttrId]
    self.CloseCallback(CurrentAttribute)
  end
  self:RemoveFromParent()
end

return M
