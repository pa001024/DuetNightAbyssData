require("UnLua")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local EnumPlayerSignRewardState = ActivityUtils.EnumPlayerSignRewardState
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:UnbindCurrentEnterAnimation()
  if self.CurrentEnterAnimation then
    self:UnbindAllFromAnimationFinished(self.CurrentEnterAnimation)
    self.CurrentEnterAnimation = nil
  end
end

function M:InitOwner(ParentWidget)
  self.ParentWidget = ParentWidget
  self.bBlockSwitchDuringIn = false
  self.CurrentEnterAnimation = nil
  if self.Btn_Detail then
    self.Btn_Detail.OnClicked:Clear()
    self.Btn_Detail.OnClicked:Add(self, self.OnClickDetail)
  end
end

function M:OnInAnimationFinished()
  self:UnbindCurrentEnterAnimation()
  self.bBlockSwitchDuringIn = false
end

function M:CanSwitchBigReward()
  return self.bBlockSwitchDuringIn ~= true
end

function M:GetCurrentEnterAnimation()
  local DisplayInfo = self.Info or self.PendingInfo
  if DisplayInfo and DisplayInfo.RewardState == EnumPlayerSignRewardState.Completed and self.In_Get then
    return self.In_Get
  end
  return self.In
end

function M:WBP_Activity_14DaySign_SubTitleItem_In()
  local EnterAnimation = self:GetCurrentEnterAnimation()
  self:StopAllAnimations()
  self:UnbindCurrentEnterAnimation()
  self.bBlockSwitchDuringIn = nil ~= EnterAnimation
  if not EnterAnimation then
    return
  end
  self.CurrentEnterAnimation = EnterAnimation
  self:BindToAnimationFinished(EnterAnimation, {
    self,
    self.OnInAnimationFinished
  })
  self:PlayAnimation(EnterAnimation)
end

function M:RefreshInputStyle(IsUseGamePad)
  if self.WS_DetailImg and self.WS_DetailImg.SetActiveWidgetIndex then
    if IsUseGamePad and self.ImageDetail_Controller then
      self.WS_DetailImg:SetActiveWidgetIndex(1)
    else
      self.WS_DetailImg:SetActiveWidgetIndex(0)
    end
  end
end

function M:BuildDisplayInfo(Info)
  if not Info then
    return
  end
  local RewardType = Info.RewardType
  local DetailId = Info.DetailId
  if "Character" == RewardType then
    local CharInfo = DataMgr.Char[DetailId]
    Info.DisplayName = CharInfo and GText(CharInfo.CharName) or ""
  elseif "Weapon" == RewardType then
    local WeaponInfo = DataMgr.Weapon[DetailId]
    Info.DisplayName = WeaponInfo and GText(WeaponInfo.WeaponName) or ""
  elseif "Resource" == RewardType then
    local ResourceInfo = DataMgr.Resource and DataMgr.Resource[DetailId]
    if ResourceInfo then
      Info.DisplayName = GText(ResourceInfo.ResourceName or ResourceInfo.Name or "")
      if not Info.RewardBigIcon then
        Info.RewardBigIcon = ResourceInfo.RewardBigIcon or ResourceInfo.Icon or ResourceInfo.ResourceIcon
      end
    else
      Info.DisplayName = ""
    end
  else
    Info.DisplayName = ""
  end
end

function M:ApplyInfoToText(Info)
  if not Info then
    return
  end
  self.Info = Info
  local IsCompleted = Info.RewardState == EnumPlayerSignRewardState.Completed
  local CanPreview = Info.RewardType == "Character" or Info.RewardType == "Weapon"
  if self.Text_CharName then
    self.Text_CharName:SetText(Info.DisplayName or "")
  end
  if self.Text_Day then
    self.Text_Day:SetText("Day")
    self.Text_Day:SetVisibility(IsCompleted and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.HitTestInvisible)
  end
  if self.Text_Reward then
    self.Text_Reward:SetText(GText("UI_GameEvent_LoginRewardToClaim"))
    self.Text_Reward:SetVisibility(IsCompleted and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.HitTestInvisible)
  end
  if self.Image_BG then
    self.Image_BG:SetRenderOpacity(IsCompleted and 0.5 or 1.0)
  end
  if self.Text_Num then
    self.Text_Num:SetText(tostring(Info.Day or 1))
  end
  if self.Text_Get then
    self.Text_Get:SetText(GText("UI_GameEvent_HasClaimed"))
  end
  if self.Group_DetailBtn then
    self.Group_DetailBtn:SetVisibility(CanPreview and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  if self.Btn_Detail then
    self.Btn_Detail:SetVisibility(CanPreview and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.Collapsed)
  end
  if self.WS_Num and self.WS_Num.SetActiveWidgetIndex then
    if IsCompleted and self.Text_Get then
      self.WS_Num:SetActiveWidgetIndex(1)
    elseif self.Text_Num then
      self.WS_Num:SetActiveWidgetIndex(0)
    end
  end
end

function M:RefreshWithData(Info, Direction, IsUseGamePad)
  self.PendingInfo = Info
  self:RefreshInputStyle(IsUseGamePad)
  self:StopAllAnimations()
  if "Left" == Direction and self.Change_L then
    self:PlayAnimation(self.Change_L)
    AudioManager(self):PlayUISound(self, "event:/ui/activity/manyouxunli_gift_info_change", nil, nil)
  elseif "Right" == Direction and self.Change_R then
    self:PlayAnimation(self.Change_R)
    AudioManager(self):PlayUISound(self, "event:/ui/activity/manyouxunli_gift_info_change", nil, nil)
  else
    self:ApplyInfoToText(Info)
  end
end

function M:Text_Change()
  self:ApplyInfoToText(self.PendingInfo)
end

function M:OnClickDetail()
  self:OpenPreview()
end

function M:CanOpenPreview()
  if not self.Info then
    return false
  end
  return self.Info.RewardType == "Character" or self.Info.RewardType == "Weapon"
end

function M:TryOpenCharacterPreview(CharId)
  if not CharId then
    return
  end
  UIManager(self):LoadUINew("ArmoryDetail", {
    PreviewCharIds = {CharId},
    bHideCharAppearance = true,
    bHideWeaponAppearance = true,
    EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon
  })
end

function M:TryOpenWeaponPreview(WeaponId)
  if not WeaponId then
    return
  end
  UIManager(self):LoadUINew("ArmoryDetail", {
    PreviewWeaponIds = {WeaponId},
    bHideCharAppearance = true,
    bHideWeaponAppearance = true,
    bHideBoxBtn = true,
    bNoEndCamera = true,
    EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon
  })
end

function M:OpenPreview()
  if not self:CanOpenPreview() then
    return
  end
  if self.Info.RewardType == "Character" then
    self:TryOpenCharacterPreview(self.Info.DetailId)
  elseif self.Info.RewardType == "Weapon" then
    self:TryOpenWeaponPreview(self.Info.DetailId)
  end
end

return M
