require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:Initialize(Initializer)
  self.Target = nil
  self.MasteryBtns = {}
  self.OwnMasteryWeaponTags = {}
  self.ExtraMasteryWeaponTags = {}
  self.OnExtraMasteryClicked = nil
end

function M:Construct()
  self.MasteryBtns = {
    self.Btn_Mastery,
    self.Btn_Mastery_1,
    self.Btn_Mastery_2
  }
  self.Text_Type:SetText(GText("UI_Armory_ExcelWeponType"))
  self.Btn_Qa:Init({
    OwnerWidget = self,
    TextContent = GText("UI_Armory_ExcelWeponTipsText"),
    SoundFunc = function()
      AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    end,
    SoundFuncReceiver = self
  })
  self:UnbindAllFromAnimationFinished(self.Out)
  self:BindToAnimationFinished(self.Out, {
    self,
    self.OnOutAnimFinished
  })
  self:AddDispatcher(EventID.OnExcelWeaponExpandSwitched, self, self.OnExcelWeaponExpandSwitched)
end

function M:OnExcelWeaponExpandSwitched(ret, CharUuid, ExcelWeaponTags)
  if ret ~= ErrorCode.RET_SUCCESS then
    return
  end
  if CharUuid ~= self.Target.Uuid then
    return
  end
  if self.IsPreviewMode then
    return
  end
  self:ResetTarget()
  self:RefreshExtraMastery()
end

function M:RefreshOpInfoByInputDevice(InputType, GamepadName)
end

function M:Init(Params)
  self.Target = Params.Target
  self.Parent = Params.Parent
  self.IsPreviewMode = Params.IsPreviewMode or Params.IsTargetUnowned
  self:RefreshMasteryUI()
end

function M:ResetTarget()
  self.Target = GWorld:GetAvatar().Chars[self.Target.Uuid]
end

function M:RefreshMasteryUI()
  if not self.Target then
    return
  end
  self:RefreshOwnMastery()
  self:RefreshExtraMastery()
  self:RefreshExtraMasterRedDot()
end

function M:RefreshOwnMastery()
  local CharData = DataMgr.BattleChar[self.Target.CharId]
  if not CharData or not CharData.ExcelWeaponTags then
    return
  end
  self.OwnMasteryWeaponTags = {}
  for _, WeaponTag in ipairs(CharData.ExcelWeaponTags) do
    if DataMgr.WeaponTag[WeaponTag] then
      table.insert(self.OwnMasteryWeaponTags, WeaponTag)
    end
  end
  local FirstWeaponTag = self.OwnMasteryWeaponTags[1]
  if 1 == #self.OwnMasteryWeaponTags and "Almighty" == FirstWeaponTag then
    self.WS_State:SetActiveWidgetIndex(1)
    self.Btn_Mastery_All:SetWeaponTag(FirstWeaponTag)
    self.Btn_Mastery_All:SetIsExtra(false)
    self.Btn_Mastery_All:SetRedDot(nil)
    self.Btn_Mastery_All:SetIsActivated(true)
    local WeaponTagData = DataMgr.WeaponTag[FirstWeaponTag]
    if WeaponTagData and WeaponTagData.WeaponTagTextmap then
      self.Text_AllType:SetText(GText(WeaponTagData.WeaponTagTextmap))
    end
    return
  end
  self.WS_State:SetActiveWidgetIndex(0)
  for i, Btn in ipairs(self.MasteryBtns) do
    local WeaponTag = self.OwnMasteryWeaponTags[i]
    if WeaponTag then
      Btn:SetWeaponTag(WeaponTag)
      Btn:SetIsExtra(false)
      Btn:SetIsActivated(true)
      Btn:SetRedDot()
      Btn:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
      Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:RefreshExtraMastery()
  if not self.Target then
    return
  end
  self.ExtraMasteryWeaponTags = {}
  for key, value in pairs(self.Target.CurrentExcelWeaponExpand or {}) do
    table.insert(self.ExtraMasteryWeaponTags, key)
  end
  local j = 1
  for i = #self.OwnMasteryWeaponTags + 1, #self.MasteryBtns do
    local Btn = self.MasteryBtns[i]
    if Btn then
      Btn:SetIsExtra(true)
      if self.ExtraMasteryWeaponTags[j] then
        Btn:SetIsActivated(true)
        Btn:SetWeaponTag(self.ExtraMasteryWeaponTags[j])
      else
        Btn:SetIsActivated(false)
      end
      if self.IsPreviewMode then
        Btn:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      else
        Btn:SetVisibility(UIConst.VisibilityOp.Visible)
        Btn:BindEventOnClicked(self, function()
          self:OnBtnClickedExtra(i)
        end)
      end
    end
    j = j + 1
  end
end

function M:ReceiveEnterState()
  self:RefreshExtraMasterRedDot()
end

function M:RefreshExtraMasterRedDot()
  if self.IsPreviewMode then
    return
  end
  local RedDotType
  local Cache = EMCache:Get("IsMasteryBtnClicked" .. self.Target.CharId, true)
  if not Cache then
    RedDotType = UIConst.RedDotType.NewRedDot
  end
  local Data = DataMgr.BattleChar[self.Target.CharId]
  local ExcelWeaponTagsExpand = Data and Data.ExcelWeaponTagsExpand or {}
  for _, WeaponTag in pairs(ExcelWeaponTagsExpand) do
    local IsEnough = not self.Target.UnlockedExcelWeaponExpand[WeaponTag] and ArmoryUtils:IsExcelWeaponUnlockResourceEnough(WeaponTag)
    if IsEnough then
      RedDotType = UIConst.RedDotType.CommonRedDot
      break
    end
  end
  local j = 1
  for i = #self.OwnMasteryWeaponTags + 1, #self.MasteryBtns do
    local Btn = self.MasteryBtns[i]
    if Btn then
      Btn:SetRedDot(RedDotType)
    end
    j = j + 1
  end
end

function M:SetRedDotRead()
  local Cache = EMCache:Get("IsMasteryBtnClicked" .. self.Target.CharId, true)
  if not Cache then
    EMCache:Set("IsMasteryBtnClicked" .. self.Target.CharId, true, true)
    for i = #self.OwnMasteryWeaponTags + 1, #self.MasteryBtns do
      local Btn = self.MasteryBtns[i]
      if Btn then
        Btn:SetRedDot()
      end
    end
  end
end

function M:OnBtnClickedExtra(Index)
  self:SetRedDotRead()
  local OnClose, OnDestruct = ArmoryUtils:GetArmoryMainInAnimFromSecondaryPage()
  local UIConfig = DataMgr.SystemUI.WeaponMastery
  UIManager(self):LoadUI(UIConst.LoadInConfig, UIConfig.UIName, self.Parent:GetZOrder(), {
    CharUuid = self.Target.Uuid,
    Target = self.Target,
    SelectedItemIndex = Index,
    OutAnimStyle = 2,
    OnClosedObj = self,
    OnClosedCallback = function()
      OnClose()
      self:ResetTarget()
      self:RefreshExtraMasterRedDot()
    end,
    OnDestructObj = self,
    OnDestructCallback = function()
      OnDestruct()
    end,
    IsPreviewMode = self.IsPreviewMode
  })
end

function M:IsWeaponMasteryActivated(WeaponTag)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local MasteryData = Avatar.CharWeaponMastery and Avatar.CharWeaponMastery[self.Target.CharId]
  if not MasteryData then
    return false
  end
  return true == MasteryData[WeaponTag]
end

function M:PlayInAnim()
  self.IsShowed = true
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:StopAnimation(self.Out)
  self:PlayAnimationForward(self.In)
end

function M:PlayOutAnim()
  self.IsShowed = false
  self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self:StopAnimation(self.In)
  self:PlayAnimationForward(self.Out)
end

function M:OnOutAnimFinished()
  if not self.IsShowed then
    self:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnParentKeyDown(MyGeometry, InKeyEvent)
  return self:OnKeyDown(MyGeometry, InKeyEvent)
end

function M:OnParentKeyUp(MyGeometry, InKeyEvent)
  return self:OnKeyUp(MyGeometry, InKeyEvent)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.RightThumb then
    self.Btn_Qa:OnViewInfoHover()
    return UIUtils.Handled, true
  end
  return UIUtils.Unhandled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.RightThumb then
    self.Btn_Qa:OnViewInfoUnHover()
    return UIUtils.Handled, true
  end
  return UIUtils.Unhandled
end

function M:Destruct()
end

AssembleComponents(M)
return M
