require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local HyperWeaponUtils = require("Utils.HyperWeaponUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}
local StateEnum = HyperWeaponUtils.ActiveState

function M:InitContent(Content)
  self.Parent = Content.Parent
  self.CallbackObj = Content.CallbackObj
  self.CardLevelCallback = Content.CardLevelCallback
  self.TalentPointCallback = Content.TalentPointCallback
  self.CardLevel = Content.CardLevel or 0
  self.WeaponId = Content.WeaponId
  self.WeaponUuid = Content.WeaponUuid
  self.MaxCardLevel = HyperWeaponUtils.GetMaxForgeLevel(self.WeaponId)
  self.RootWidget = self.CallbackObj
  self.Avatar = ArmoryUtils:GetAvatar()
  self.IsPreviewMode = Content.IsPreviewMode
  self.AddToFocusPathObj = Content.AddToFocusPathObj
  self.TalentWidgetFocusPathCallback = Content.TalentWidgetFocusPathCallback
  self.Btn_Aera:InitContent({
    CallbackObj = self,
    ClickedCallback = self.OnCardLevelButtonClicked,
    HoverCallback = self.OnButonHovered,
    UnHoverCallback = self.OnButonUnhovered,
    PressCallback = self.OnButonPressed,
    AddToFocusPathObj = Content.AddToFocusPathObj,
    AddToFocusPathCallback = Content.LevelWidgetFocusPathCallback
  })
  self:InitCardLevel()
  self:InitCardState()
  self:InitTalentWidgets()
  self:InitAnimationState()
  self:PlayNormalAnimation()
end

function M:InitCardLevel()
  self.Text_Level:SetText(self.CardLevel)
end

function M:InitCardState()
  self.CardState = HyperWeaponUtils.GetCardState(self.Avatar, self.WeaponUuid, self.CardLevel, self.IsPreviewMode)
end

function M:InitTalentWidgets()
  local TalentContents = {}
  for TalentId, Info in pairs(DataMgr.HyperWeaponSkillTree) do
    if Info.WeaponId == self.WeaponId and Info.WeaponCardLevel == self.CardLevel then
      local Content = {}
      Content.Parent = self
      Content.IsPreviewMode = self.IsPreviewMode
      Content.WeaponUuid = self.WeaponUuid
      Content.TalentId = TalentId
      Content.CallbackObj = self.CallbackObj
      Content.ClickCallback = self.TalentPointCallback
      Content.CardLevel = self.CardLevel
      Content.MaxCardLevel = self.MaxCardLevel
      Content.AddToFocusPathObj = self.AddToFocusPathObj
      Content.AddToFocusPathCallback = self.TalentWidgetFocusPathCallback
      table.insert(TalentContents, Content)
    end
  end
  table.sort(TalentContents, function(ContentA, ContentB)
    return ContentA.TalentId < ContentB.TalentId
  end)
  self.TalentsMap = {}
  self.TalentsArray = {}
  local Panel = self.WB_Talent
  local WidgetCount = 0
  local Widget = Panel:GetChildAt(0)
  local WidgetClass = UGameplayStatics.GetObjectClass(Widget)
  for Index, Content in ipairs(TalentContents) do
    Widget = Panel:GetChildAt(WidgetCount)
    if not Widget then
      Widget = UIManager(self):CreateWidget(WidgetClass)
      Panel:AddChild(Widget)
    end
    Widget:SetVisibility(UIConst.VisibilityOp.Visible)
    Content.TalentIndex = Index
    Widget:InitContent(Content)
    self.TalentsMap[Content.TalentId] = Widget
    table.insert(self.TalentsArray, Widget)
    WidgetCount = WidgetCount + 1
  end
  local Start, End = WidgetCount, Panel:GetChildrenCount() - 1
  for i = Start, End do
    local Widget = Panel:GetChildAt(i)
    Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:InitAnimationState()
  self:InitCardState()
  local AniName
  if self.CardState == StateEnum.Locked then
    AniName = self.Locked
  elseif self.CardState == StateEnum.UnlockedInactive then
    AniName = self.UnAct
  elseif self.CardState == StateEnum.UnlockedActivatable then
    AniName = self.Actived
  elseif self.CardState == StateEnum.Activated then
    AniName = self.UnLocked
  end
  if AniName then
    self:PlayAnimation(AniName)
  end
end

function M:UnlockCardLevel(FinishedObj, FinishedCallback)
  self:InitCardState()
  if self.CardState == StateEnum.Locked then
    return
  end
  local RootWidget = self.CallbackObj
  
  local function OnUnLockFinished()
    self:UnbindAllFromAnimationFinished(self.Unlock_In)
    if RootWidget then
      RootWidget:BlockAllUIInput(false)
    end
    self:InitAnimationState()
    if FinishedObj and FinishedCallback then
      FinishedCallback(FinishedObj)
    end
  end
  
  self:BindToAnimationFinished(self.Unlock_In, {self, OnUnLockFinished})
  if RootWidget then
    RootWidget:BlockAllUIInput(true)
  end
  self:PlayAnimation(self.Unlock_In)
  AudioManager(self):PlayUISound(self, "event:/ui/common/skin_upgrade", nil, nil)
end

function M:ActiveCardLevel()
  self:InitCardState()
  if self.CardState == StateEnum.Activated then
    return
  end
  
  local function OnActiveFinished()
    self:PlayNormalAnimation()
    self:UnbindAllFromAnimationFinished(self.Act_In)
    self:BlockAllUIInput(false)
  end
  
  self:InitAnimationState()
  self:BindToAnimationFinished(self.Act_In, {self, OnActiveFinished})
  self:BlockAllUIInput(true)
  self:PlayAnimation(self.Act_In)
  AudioManager(self):PlayUISound(self, "event:/ui/common/skin_upgrade", nil, nil)
end

function M:CallTalentClickEvent(TalentId)
  local Widget = self.TalentsMap[TalentId]
  if Widget then
    Widget:SetFocus()
    Widget:OnButtonClicked()
  end
end

function M:IsStopProcessEvent()
  return self.StopProcess
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

function M:OnCardLevelButtonClicked()
  if self:IsStopProcessEvent() then
    return
  end
  if self.CallbackObj and self.CardLevelCallback and type(self.CardLevelCallback) == "function" then
    self.CardLevelCallback(self.CallbackObj, self, self.CardLevel)
  end
  self:PlayAnimation(self.Click)
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

AssembleComponents(M)
return M
