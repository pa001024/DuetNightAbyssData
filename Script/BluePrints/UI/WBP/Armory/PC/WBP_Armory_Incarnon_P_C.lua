require("UnLua")
local HyperWeaponUtils = require("Utils.HyperWeaponUtils")
local M = Class("BluePrints.UI.WBP.Armory.WBP_Armory_Incarnon_Base_C")

function M:Construct()
  self.Super.Construct(self)
  self.Key_More:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonTop)
  self:AddInputMethodChangedListen()
  self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

function M:Init(Params)
  self.Super.Init(self, Params)
  self.CallbackObj = Params.CallbackObj
  self.LevelAddToFocusPathCallback = Params.OnLevelWidgetAddToFocusPath
  self.TalentAddToFocusPathCallback = Params.OnTalentWidgetAddToFocusPath
  self.ProcessLeftThumbstick = Params.ProcessLeftThumbstick
  self._OnAddedToFocusPath = Params.OnAddedToFocusPath
  self._OnRemovedFromFocusPath = Params.OnRemovedFromFocusPath
  self:InitCardNavigation()
  self:InitTalentNavigation()
end

function M:InitCardNavigation()
  for CardLevel = 0, self.MaxCardLevel do
    local CardWdiget = self:GetCardLevelWidget(CardLevel)
    local FocusWidget = CardWdiget.Btn_Aera
    FocusWidget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    if #CardWdiget.TalentsArray > 0 then
      local FirstTalentWidget = CardWdiget.TalentsArray[1]
      FocusWidget:SetNavigationRuleExplicit(EUINavigation.Right, FirstTalentWidget)
    else
      FocusWidget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    end
    if 0 == CardLevel then
      FocusWidget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    else
      local UpWidget = self:GetCardLevelWidget(CardLevel - 1)
      FocusWidget:SetNavigationRuleExplicit(EUINavigation.Up, UpWidget.Btn_Aera)
    end
    if CardLevel == self.MaxCardLevel then
      FocusWidget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    else
      local DownWidget = self:GetCardLevelWidget(CardLevel + 1)
      FocusWidget:SetNavigationRuleExplicit(EUINavigation.Down, DownWidget.Btn_Aera)
    end
  end
end

function M:InitTalentNavigation()
  for CardLevel = 0, self.MaxCardLevel do
    local CardWdiget = self:GetCardLevelWidget(CardLevel)
    local Talents = HyperWeaponUtils.GetTalents(self.WeaponId, CardLevel)
    local TalentCount = #Talents
    for i, TalentId in pairs(Talents) do
      local TalentWidget = CardWdiget.TalentsMap[TalentId]
      if 1 == i then
        TalentWidget:SetNavigationRuleExplicit(EUINavigation.Left, CardWdiget.Btn_Aera)
      else
        local LeftWdiget = CardWdiget.TalentsArray[i - 1]
        TalentWidget:SetNavigationRuleExplicit(EUINavigation.Left, LeftWdiget)
      end
      if i == TalentCount then
        TalentWidget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
      else
        local RightWdiget = CardWdiget.TalentsArray[i + 1]
        if RightWdiget then
          TalentWidget:SetNavigationRuleExplicit(EUINavigation.Right, RightWdiget)
        else
          TalentWidget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
        end
      end
      if 0 == CardLevel then
        TalentWidget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
      else
        local UpCardWidget = self:GetCardLevelWidget(CardLevel - 1)
        local UpTalentsCount = #UpCardWidget.TalentsArray
        local TargetIndex = 1 == UpTalentsCount and 1 or i
        local UpWidget = UpCardWidget.TalentsArray[TargetIndex]
        TalentWidget:SetNavigationRuleExplicit(EUINavigation.Up, UpWidget)
      end
      if CardLevel == self.MaxCardLevel then
        TalentWidget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
      else
        local DownCardWidget = self:GetCardLevelWidget(CardLevel + 1)
        local DownTalentsCount = #DownCardWidget.TalentsArray
        local TargetIndex = 1 == DownTalentsCount and 1 or i
        local DownWidget = DownCardWidget.TalentsArray[TargetIndex]
        TalentWidget:SetNavigationRuleExplicit(EUINavigation.Down, DownWidget)
      end
    end
  end
end

function M:OnParentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    self.Btn_SmeltLevel:OnBtnClicked()
    return UE4.UWidgetBlueprintLibrary.Handled(), true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
    self.Button_More:OnViewInfoClick()
    return UE4.UWidgetBlueprintLibrary.Handled(), true
  elseif InKeyName == UIConst.GamePadKey.LeftThumb and self.ProcessLeftThumbstick then
    self:FocusToFirstWidget()
    return UE4.UWidgetBlueprintLibrary.Handled(), true
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled(), false
end

function M:OnParentFaceButtonBottomKeyDown()
  self:FocusToFirstWidget()
  return UE4.UWidgetBlueprintLibrary.Handled(), true
end

function M:FocusToFirstWidget()
  local CardWidget = self:GetCardLevelWidget(0)
  local FocusWidget = CardWidget.Btn_Aera
  FocusWidget:SetFocus()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  M.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
  self.Btn_SmeltLevel:SetGamePadKeyVisible(self.IsGamepadInput)
  local TargetIndex = self.IsGamepadInput and 1 or 0
  self.WS_More:SetActiveWidgetIndex(TargetIndex)
  if self.IsInFocusPath and self.FocusWidget then
    self.FocusWidget:SetFocus()
  end
end

function M:SetFocusWidget(CardLevel, TalentId)
  local CardWidget = self:GetCardLevelWidget(CardLevel)
  if not CardWidget then
    return
  end
  if TalentId then
    self.FocusWidget = CardWidget.TalentsMap[TalentId]
  else
    self.FocusWidget = CardWidget.Btn_Aera
  end
  self.FocusWidget:SetFocus()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.FocusWidget then
    self.FocusWidget:SetFocus()
  else
    self:FocusToFirstWidget()
  end
  return UIUtils.Handled
end

function M:OnAddedToFocusPath()
  self.IsInFocusPath = true
  if self._OnAddedToFocusPath then
    self._OnAddedToFocusPath(self.Parent, self)
  end
end

function M:OnRemovedFromFocusPath()
  self.IsInFocusPath = false
  if self._OnRemovedFromFocusPath then
    self._OnRemovedFromFocusPath(self.Parent, self)
  end
end

function M:OnLevelWidgetAddToFocusPath(LevelWidgetBtn)
  self.FocusWidget = LevelWidgetBtn
  if self.CallbackObj and self.LevelAddToFocusPathCallback then
    self.LevelAddToFocusPathCallback(self.CallbackObj, LevelWidgetBtn)
  end
end

function M:OnTalentWidgetAddToFocusPath(TalentWidget)
  self.FocusWidget = TalentWidget
  if self.CallbackObj and self.TalentAddToFocusPathCallback then
    self.TalentAddToFocusPathCallback(self.CallbackObj, TalentWidget)
  end
end

return M
