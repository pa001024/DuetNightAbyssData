require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local HyperWeaponUtils = require("Utils.HyperWeaponUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}
local AngleTable = {
  [0] = {5, -50},
  [1] = {-22, -22},
  [2] = {0, 0},
  [3] = {22, 22},
  [4] = {-5, 50}
}
local LengthTable = {
  [0] = {5, 75},
  [1] = {12, 12},
  [2] = {5, 5},
  [3] = {15, 15},
  [4] = {5, 75}
}
local SizeY = 96
local StateEnum = HyperWeaponUtils.ActiveState

function M:Construct()
  self.Btn_Aera.OnClicked:Add(self, self.OnButtonClicked)
  self.Btn_Aera.OnHovered:Add(self, self.OnButonHovered)
  self.Btn_Aera.OnUnhovered:Add(self, self.OnButonUnhovered)
  self.Btn_Aera.OnPressed:Add(self, self.OnButonPressed)
  self.Line_Incarnon_1:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Line_Incarnon_2:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:Destruct()
  self.Btn_Aera.OnClicked:Clear()
  self.Btn_Aera.OnHovered:Clear()
  self.Btn_Aera.OnUnhovered:Clear()
  self.Btn_Aera.OnPressed:Clear()
end

function M:InitContent(Content)
  self.Parent = Content.Parent
  self.WeaponId = Content.WeaponId
  self.WeaponUuid = Content.WeaponUuid
  self.CardLevel = Content.CardLevel
  self.TalentId = Content.TalentId
  self.TalentIndex = Content.TalentIndex
  self.CallbackObj = Content.CallbackObj
  self.ClickCallback = Content.ClickCallback
  self.IsMaxCardLevel = Content.CardLevel == Content.MaxCardLevel
  self.RootWidget = self.CallbackObj
  self.Avatar = ArmoryUtils:GetAvatar()
  self.IsPreviewMode = Content.IsPreviewMode
  self.SkipClickSound = Content.SkipClickSound
  self.AddToFocusPathObj = Content.AddToFocusPathObj
  self.AddToFocusPathCallback = Content.AddToFocusPathCallback
  self:InitIcon()
  self:InitTalentState()
  self:InitLineState()
  self:InitAnimationState()
  self:PlayNormalAnimation()
end

function M:InitIcon()
  local TalentInfo = DataMgr.HyperWeaponSkillTree[self.TalentId]
  local IconPath = TalentInfo and TalentInfo.SkillIcon
  if IconPath then
    local Texture = LoadObject(IconPath)
    local DynamicMaterial = self.Icon_Talent:GetDynamicMaterial()
    DynamicMaterial:SetTextureParameterValue("IconTex", Texture)
  end
end

function M:InitTalentState()
  self.TalentState = HyperWeaponUtils.GetTalentState(self.Avatar, self.WeaponUuid, self.TalentId, self.IsPreviewMode)
end

function M:InitAnimationState()
  self:InitTalentState()
  self.CurPlayingAnimation = nil
  if self.TalentState == StateEnum.Locked then
    self.CurPlayingAnimation = self.Locked
  elseif self.TalentState == StateEnum.UnlockedInactive then
    self.CurPlayingAnimation = self.UnAct
  elseif self.TalentState == StateEnum.UnlockedActivatable then
    self.CurPlayingAnimation = self.Act
  elseif self.TalentState == StateEnum.Activated then
    self.CurPlayingAnimation = self.UnLock
  end
  if not self.CurPlayingAnimation then
    return
  end
  self.StopProcess = true
  self:StopAllAnimations()
  self:PlayAnimation(self.CurPlayingAnimation)
  if self.CurPlayingAnimation == self.Act then
    self.IsAnimationActPlaying = true
  else
    self.IsAnimationActPlaying = false
  end
end

function M:OnAnimationFinished(AnimationName)
  if AnimationName == self.CurPlayingAnimation then
    self.StopProcess = false
  end
end

function M:PlayLineAnimation(Index, AniName)
  local WidgetName = "Line_Incarnon_" .. Index
  local LineWidget = self[WidgetName]
  if not LineWidget or not LineWidget[AniName] then
    return
  end
  LineWidget:StopAllAnimations()
  LineWidget:PlayAnimation(LineWidget[AniName])
end

function M:InitLineState()
  local LineWidget01 = self.Line_Incarnon_1
  local LineWidget02 = self.Line_Incarnon_2
  if 0 ~= self.CardLevel then
    LineWidget02:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if self.IsMaxCardLevel then
      LineWidget01:SetVisibility(UIConst.VisibilityOp.Collapsed)
      return
    end
  end
  
  local function SetLineAnimation(NextTalentId, NextIndex)
    local NextTalentState = HyperWeaponUtils.GetTalentState(self.Avatar, self.WeaponUuid, NextTalentId, self.IsPreviewMode)
    if NextTalentState == StateEnum.Activated and self.TalentState == StateEnum.Activated then
      LineWidget01:PlayAnimation(LineWidget01.UnLocked)
      if 0 == self.CardLevel and 2 == NextIndex then
        LineWidget02:PlayAnimation(LineWidget02.UnLocked)
      end
    else
      LineWidget01:PlayAnimation(LineWidget01.Locked)
      if 0 == self.CardLevel then
        LineWidget02:PlayAnimation(LineWidget02.Locked)
      end
    end
  end
  
  local NextLevelTalents = HyperWeaponUtils.GetTalents(self.WeaponId, self.CardLevel + 1)
  for Index, NextTalentId in pairs(NextLevelTalents) do
    local Info = DataMgr.HyperWeaponSkillTree[NextTalentId]
    for _, ConditionId in pairs(Info.UnlockCondition) do
      if ConditionId == self.TalentId then
        SetLineAnimation(NextTalentId, Index)
      end
    end
  end
  local AngleInfo = AngleTable[self.CardLevel]
  if 0 == self.CardLevel then
    LineWidget01:SetRenderTransformAngle(AngleInfo[1])
    LineWidget02:SetRenderTransformAngle(AngleInfo[2])
  else
    LineWidget01:SetRenderTransformAngle(AngleInfo[self.TalentIndex])
  end
  local LengthInfo = LengthTable[self.CardLevel]
  if 0 == self.CardLevel then
    local Size = LineWidget01.Slot:GetSize()
    Size.Y = SizeY + LengthInfo[1]
    LineWidget01.Slot:SetSize(Size)
    Size = LineWidget02.Slot:GetSize()
    Size.Y = SizeY + LengthInfo[2]
    LineWidget02.Slot:SetSize(Size)
  else
    LineWidget01:SetRenderTransformAngle(AngleInfo[self.TalentIndex])
    local Size = LineWidget01.Slot:GetSize()
    Size.Y = SizeY + LengthInfo[self.TalentIndex]
    LineWidget01.Slot:SetSize(Size)
  end
end

function M:UnlockTalent(FinishedObj, FinishedCallback)
  self:InitTalentState()
  if self.TalentState == StateEnum.Locked then
    return
  end
  local RootWidget = self.CallbackObj
  
  local function OnUnLockFinished()
    self:UnbindAllFromAnimationFinished(self.Unlock_In)
    self:InitAnimationState()
    if FinishedObj and FinishedCallback then
      FinishedCallback(FinishedObj)
    end
    if RootWidget then
      RootWidget:BlockAllUIInput(false)
    end
    self.StopProcess = false
  end
  
  self:BindToAnimationFinished(self.Unlock_In, {self, OnUnLockFinished})
  if RootWidget then
    RootWidget:BlockAllUIInput(true)
  end
  self.StopProcess = true
  self:StopAllAnimations()
  self:PlayAnimation(self.Unlock_In)
  AudioManager(self):PlayUISound(self, "event:/ui/common/skin_upgrade", nil, nil)
end

function M:IsStopProcessEvent()
  return self.StopProcess
end

function M:PlayActInAnimation()
  self:InitTalentState()
  if self.TalentState == StateEnum.UnlockedActivatable then
    if self.IsAnimationActPlaying then
      return
    end
    self.StopProcess = true
    self:StopAllAnimations()
    self.CurPlayingAnimation = self.Act_In
    self:PlayAnimation(self.Act_In)
    self.IsAnimationActPlaying = true
  end
end

function M:PlayNormalAnimation()
  self.StopProcess = false
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
end

function M:PlaySelectedAnimation()
  self.StopProcess = true
  self:StopAllAnimations()
  self:PlayAnimation(self.Click)
end

function M:OnButtonClicked()
  if self:IsStopProcessEvent() then
    return
  end
  if self.CallbackObj and self.ClickCallback and type(self.ClickCallback) == "function" then
    self.ClickCallback(self.CallbackObj, self, self.TalentId)
  end
  if not self.SkipClickSound then
    if self.TalentState == StateEnum.Locked then
      AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_disable", nil, nil)
    elseif self.TalentState == StateEnum.Activated then
      AudioManager(self):PlayUISound(self, "event:/ui/armory/suyuan_point_click_unlock", nil, nil)
    else
      AudioManager(self):PlayUISound(self, "event:/ui/armory/suyuan_point_click", nil, nil)
    end
  end
end

function M:OnButonHovered()
  if self:IsStopProcessEvent() then
    return
  end
  self:StopAnimation(self.UnHover)
  self:PlayAnimation(self.Hover)
end

function M:OnButonUnhovered()
  if self:IsStopProcessEvent() then
    return
  end
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.UnHover)
end

function M:OnButonPressed()
  if self:IsStopProcessEvent() then
    return
  end
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.Press)
end

function M:OnAddedToFocusPath()
  if self.AddToFocusPathObj then
    self.AddToFocusPathCallback(self.AddToFocusPathObj, self)
  end
end

AssembleComponents(M)
return M
