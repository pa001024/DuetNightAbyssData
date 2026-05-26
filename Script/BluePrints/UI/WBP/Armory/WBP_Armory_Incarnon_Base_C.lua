require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local HyperWeaponUtils = require("Utils.HyperWeaponUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:Construct()
  self.Text_Talent:SetText(GText("UI_Armory_HyperPassive"))
  self.Text_SmeltLimit:SetText(GText("UI_Armory_CurrentMaxForgeLevl"))
  self:AddDispatcher(EventID.OnHyperWeaponForgeLevelUp, self, self.OnHyperWeaponForgeLevelUp)
  self:AddDispatcher(EventID.OnHyperWeaponForgeQuestRewardGot, self, self.OnHyperWeaponForgeRewradChanged)
end

function M:Init(Params)
  self.Params = Params
  self.IsPreviewMode = Params.IsPreviewMode
  self.Parent = Params.Parent
  self.Target = Params.Target
  self.WeaponUuid = self.Target.Uuid
  self.WeaponId = self.Target.WeaponId
  self.Avatar = ArmoryUtils:GetAvatar()
  self.MaxForgeLevel = HyperWeaponUtils.GetMaxForgeLevel(self.WeaponId)
  self.MaxCardLevel = self.MaxForgeLevel
  self.HasGotWeapon = self.Avatar.Weapons[self.WeaponUuid] ~= nil
  self:InitWeaponForge()
  self:InitWeaponCardProgress()
  self:InitWeaponCardAndTalent()
  self:InitTalentProgress()
  self:RefreshAllReddot()
end

function M:OnHyperWeaponForgeLevelUp()
  self:InitWeaponForge()
  self:InitWeaponCardProgress()
  local CardWidget = self:GetCardLevelWidget(self.Avatar.WeaponForgeLevel)
  if CardWidget then
    CardWidget:InitAnimationState()
    for _, Widget in pairs(CardWidget.TalentsMap) do
      Widget:InitAnimationState()
    end
  end
end

function M:OnHyperWeaponForgeRewradChanged()
  self:RefreshAllReddot()
end

function M:InitWeaponForge()
  self.Text_Level_Now:SetText(self.Avatar.WeaponForgeLevel)
  self.Text_Level_Max:SetText(self.MaxForgeLevel)
  
  local function CallbackFunc()
    local DialogParent = self.FocusWidget and self or self.Parent
    local Params = {
      WeaponId = self.WeaponId,
      Parent = DialogParent,
      CallbackObj = self,
      CloseCallback = self.RefreshAll
    }
    UIManager(self):LoadUINew("ArmoryHyperWeaponTaskDialog", Params)
  end
  
  self.Btn_SmeltLevel:Init({
    CallbackObj = self,
    CallbackFunc = CallbackFunc,
    Text = "UI_Armory_ForgeLevel",
    GamepadKey = UIConst.GamePadImgKey.FaceButtonLeft
  })
  if self.IsPreviewMode then
    self.Btn_SmeltLevel:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Btn_SmeltLevel:SetReddotVisible(false)
  end
end

function M:InitWeaponCardProgress()
  local Percent1, Percent2 = 0, 0
  local ServerWeaponInfo = self.Avatar.Weapons[self.WeaponUuid]
  if ServerWeaponInfo then
    local CardLevel = ServerWeaponInfo.HyperCardLevel
    local CardLevel01 = math.clamp(CardLevel + 1, 0, self.MaxCardLevel)
    Percent1 = CardLevel01 / self.MaxCardLevel
    local CardLevel02 = math.clamp(CardLevel + 1, 0, self.MaxCardLevel + 1)
    Percent2 = CardLevel02 / (self.MaxCardLevel + 1)
  end
  self.Progress_Smlet:SetPercent(Percent1)
  local DynamicMaterial = self.Progress_Smlet_1:GetDynamicMaterial()
  DynamicMaterial:SetScalarParameterValue("Percent", Percent2)
  if CardLevel == self.MaxCardLevel then
    self:PlayAnimation(self.Level_Full)
  else
    self:PlayAnimation(self.Level_Normal)
  end
end

function M:GetCardLevelWidget(CardLevel)
  return self["Incarnon_Smlet_" .. CardLevel]
end

function M:InitWeaponCardAndTalent()
  local MaxTalentCount = HyperWeaponUtils.GetMaxForgeLevel(self.WeaponId)
  local SkipClickSound = true
  if self.Params.SkipClickSound ~= nil then
    SkipClickSound = self.Params.SkipClickSound
  end
  for CardLevel = 0, MaxTalentCount do
    local Widget = self:GetCardLevelWidget(CardLevel)
    if Widget then
      local Content = {}
      Content.Parent = self
      Content.CardLevel = CardLevel
      Content.WeaponId = self.WeaponId
      Content.WeaponUuid = self.WeaponUuid
      Content.IsPreviewMode = self.IsPreviewMode
      local CallbackObj = self.Params.CallbackObj
      if CallbackObj then
        Content.CallbackObj = CallbackObj
        Content.CardLevelCallback = self.Params.CardCallback
        Content.TalentPointCallback = self.Params.TalentCallback
      else
        Content.CallbackObj = self
        Content.CardLevelCallback = self.OnCardLevelClicked
        Content.TalentPointCallback = self.OnTalentPointClicked
      end
      Content.AddToFocusPathObj = self
      Content.LevelWidgetFocusPathCallback = self.OnLevelWidgetAddToFocusPath
      Content.TalentWidgetFocusPathCallback = self.OnTalentWidgetAddToFocusPath
      Content.SkipClickSound = SkipClickSound
      Widget:InitContent(Content)
    end
  end
end

function M:InitTalentProgress()
  local CurTalentCount = HyperWeaponUtils.GetHyperWeaponCurTalentCount(self.Avatar, self.WeaponUuid)
  local MaxTalentCount = HyperWeaponUtils.GetHyperWeaponMaxTalentCount(self.WeaponId)
  self.Num_Talent_Now:SetText(CurTalentCount)
  self.Num_Talent_Max:SetText(MaxTalentCount)
  self.Num_SmeltLimit:SetText(self.Avatar.WeaponForgeLevel)
  local Params = {
    WeaponUuid = self.WeaponUuid,
    WeaponId = self.WeaponId
  }
  self.Button_More:Init({
    ClickCallback = function()
      UIManager(self):ShowCommonPopupUI(100352, Params, self)
    end,
    SoundFunc = function()
      AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    end,
    SoundFuncReceiver = self,
    OwnerWidget = self
  })
end

function M:OnCardLevelClicked(Widget, CardLevel)
  if self.IsPreviewMode then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Toast_PreviewForgeLevel_CannotPreview"))
    return
  end
  local Params = {
    FocusCardLevel = CardLevel,
    Parent = self,
    Target = self.Target
  }
  self.Details = UIManager(self):LoadUINew("ArmoryIncarnonDetail", Params)
end

function M:OnTalentPointClicked(Widget, TalentId)
  if self.IsPreviewMode then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Toast_PreviewForgeLevel_CannotPreview"))
    return
  end
  local Params = {
    FocusTalentId = TalentId,
    Parent = self,
    Target = self.Target
  }
  self.Details = UIManager(self):LoadUINew("ArmoryIncarnonDetail", Params)
end

function M:CallCardClickEvent(CardLevel)
  local Widget = self:GetCardLevelWidget(CardLevel)
  if Widget then
    Widget.Btn_Aera:SetFocus()
    Widget:OnCardLevelButtonClicked()
  end
end

function M:CallTalentClickEvent(TalentId)
  local TalentInfo = DataMgr.HyperWeaponSkillTree[TalentId]
  local CardLevel = TalentInfo and TalentInfo.WeaponCardLevel
  if not CardLevel then
    return
  end
  local Widget = self:GetCardLevelWidget(CardLevel)
  if Widget then
    Widget:CallTalentClickEvent(TalentId)
  end
end

function M:RefreshAllReddot()
  if self.IsPreviewMode then
    return
  end
  if self.Parent and self.Parent.UpdateSubTabReddotCommon then
    self.Parent:UpdateSubTabReddotCommon(ArmoryUtils.ArmorySubTabNames.HyperGrade)
  end
  if not self.HasGotWeapon then
    self.Btn_SmeltLevel:SetReddotVisible(false)
    return
  end
  local HasAnyForgeRewards = HyperWeaponUtils.HasAnyForgeRewards(1, self.MaxForgeLevel)
  self.Btn_SmeltLevel:SetReddotVisible(HasAnyForgeRewards)
end

function M:PlayInAnim()
  if self.SkipAnimationIn then
    self.SkipAnimationIn = nil
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/armory/suyuan_points_show", nil, nil)
  self:RefreshAllReddot()
end

function M:PlayOutAnim()
  self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self:StopAllAnimations()
  self:FlushAnimations()
  self:PlayAnimation(self.Out)
  self.FocusWidget = nil
end

function M:OnDetailsPanelColsed(Params)
  self.SkipAnimationIn = Params.SkipAnimationIn
  local ArmoryMain = UIManager(self):GetArmoryUIObj()
  if ArmoryMain then
    ArmoryMain:SetVisibility(UIConst.VisibilityOp.Collapsed)
    ArmoryMain.Panel_SubUI:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:RefreshAll()
  self:RefreshAllReddot()
  self:RefreshProgressUI()
end

function M:RefreshProgressUI()
  self:InitWeaponForge()
  self:InitWeaponCardProgress()
  self:InitTalentProgress()
end

function M:SetFocusWidget(CardLevel, TalentId)
end

function M:OnLevelWidgetAddToFocusPath(LevelWidget)
end

function M:OnTalentWidgetAddToFocusPath(TalentWidget)
end

AssembleComponents(M)
return M
