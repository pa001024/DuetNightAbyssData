require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
M.DisplayState = {
  Forbidden = 1,
  Zero = 2,
  Normal = 3
}

function M:Initialize(Initializer)
  self.OwnerPanel = nil
  self.CurrentDisplayState = nil
  self.LastWeaponSp = 0
  self.LastMaxWeaponSp = 0
  self.LastSegmentsNumber = 0
  self.LastSecondaryCount = 0
  self.bInFullState = false
end

function M:Init(OwnerPanel)
  self.OwnerPanel = OwnerPanel
end

function M:Refresh(CurrentWeaponSp, MaxWeaponSp, CurrentSecondaryCount, HasSecondaryResource, CurrentWeapon)
  CurrentWeaponSp = CurrentWeaponSp or 0
  MaxWeaponSp = MaxWeaponSp or 0
  CurrentSecondaryCount = CurrentSecondaryCount or 0
  HasSecondaryResource = HasSecondaryResource or false
  local IsTalentActive = self:CalcTalentActive(CurrentWeapon)
  self:UpdateNumberDisplay(CurrentWeaponSp, CurrentSecondaryCount, HasSecondaryResource)
  self:UpdateProgressBar(CurrentWeaponSp, MaxWeaponSp)
  self:HandleStateAndAnim(CurrentWeaponSp, MaxWeaponSp, CurrentSecondaryCount, HasSecondaryResource, IsTalentActive)
  self.LastWeaponSp = CurrentWeaponSp
  self.LastMaxWeaponSp = MaxWeaponSp
  self.LastSecondaryCount = CurrentSecondaryCount
end

function M:UpdateNumberDisplay(CurrentWeaponSp, CurrentSecondaryCount, HasSecondaryResource)
  self.TextNumOne:SetText(tostring(math.floor(CurrentWeaponSp)))
  if HasSecondaryResource then
    self.LevelTwo:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.TextNumTwo:SetText(tostring(math.floor(CurrentSecondaryCount)))
  else
    self.LevelTwo:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:UpdateProgressBar(CurrentWeaponSp, MaxWeaponSp)
  if MaxWeaponSp <= 0 then
    return
  end
  local SegmentsNumber = math.max(1, math.ceil(MaxWeaponSp / 20))
  local Percent = math.min(math.max(CurrentWeaponSp / MaxWeaponSp, 0), 1)
  local bSegmentsChanged = self.LastSegmentsNumber ~= SegmentsNumber
  if not self.MatFill or not IsValid(self.MatFill) then
    self.MatFill = self.Filled:GetDynamicMaterial()
  end
  if self.MatFill then
    if bSegmentsChanged then
      self.MatFill:SetScalarParameterValue("SegmentsNumber", SegmentsNumber)
    end
    self.MatFill:SetScalarParameterValue("percent", Percent)
  end
  if not self.MatFillGlow or not IsValid(self.MatFillGlow) then
    self.MatFillGlow = self.Filled_Glow:GetDynamicMaterial()
  end
  if self.MatFillGlow then
    if bSegmentsChanged then
      self.MatFillGlow:SetScalarParameterValue("SegmentsNumber", SegmentsNumber)
    end
    self.MatFillGlow:SetScalarParameterValue("percent", Percent)
  end
  self.LastSegmentsNumber = SegmentsNumber
end

function M:CalcTalentActive(CurrentWeapon)
  if not IsValid(CurrentWeapon) then
    return false
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local PlayerCharcter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local CharId = PlayerCharcter and PlayerCharcter.CurrentRoleId
  if not CharId or -1 == CharId then
    return false
  end
  local CharBattleInfo = DataMgr.BattleChar[CharId]
  local ExcelWeaponTags = CharBattleInfo and CharBattleInfo.ExcelWeaponTags
  local WeaponBattleInfo = DataMgr.BattleWeapon[CurrentWeapon.WeaponId]
  local WeaponTags = WeaponBattleInfo and WeaponBattleInfo.WeaponTag
  if not ExcelWeaponTags or not WeaponTags then
    return false
  end
  for _, WeaponTag in pairs(WeaponTags) do
    if CommonUtils.HasValue(ExcelWeaponTags, WeaponTag) then
      return true
    end
  end
  return false
end

function M:HandleStateAndAnim(CurrentWeaponSp, MaxWeaponSp, CurrentSecondaryCount, HasSecondaryResource, IsTalentActive)
  local NewState = self:CalcDisplayState(CurrentWeaponSp, CurrentSecondaryCount, HasSecondaryResource, IsTalentActive)
  if self.CurrentDisplayState ~= NewState then
    self.CurrentDisplayState = NewState
    if NewState == self.DisplayState.Forbidden then
      self:PlayAnimationForward(self.Forbbiden)
    elseif NewState == self.DisplayState.Zero then
      self:PlayAnimationForward(self.Zero)
    elseif NewState == self.DisplayState.Normal then
      self:PlayAnimationForward(self.Normal)
    end
  end
  self:HandleFullState(CurrentWeaponSp, MaxWeaponSp)
  if CurrentWeaponSp > self.LastWeaponSp and CurrentWeaponSp < MaxWeaponSp then
    self:PlayAnimationForward(self.Prigress_Add)
  end
  if HasSecondaryResource and CurrentSecondaryCount > self.LastSecondaryCount and not self:IsAnimationPlaying(self.Progress_Num_Add) then
    self:PlayAnimationForward(self.Progress_Num_Add)
  end
end

function M:CalcDisplayState(CurrentWeaponSp, CurrentSecondaryCount, HasSecondaryResource, IsTalentActive)
  if not IsTalentActive then
    return self.DisplayState.Forbidden
  end
  if not HasSecondaryResource or CurrentSecondaryCount <= 0 then
    return self.DisplayState.Zero
  end
  return self.DisplayState.Normal
end

function M:HandleFullState(CurrentWeaponSp, MaxWeaponSp)
  if MaxWeaponSp <= 0 then
    if self.bInFullState then
      self:StopFullAnims()
      self.bInFullState = false
    end
    return
  end
  local IsFull = MaxWeaponSp <= CurrentWeaponSp
  if IsFull and not self.bInFullState then
    self.bInFullState = true
    self:PlayAnimationForward(self.Progress_Full_In)
    self:BindToAnimationFinished(self.Progress_Full_In, {
      self,
      self.OnFullInFinished
    })
  elseif not IsFull and self.bInFullState then
    self.bInFullState = false
    self:StopFullAnims()
    self:PlayAnimationForward(self.Progress_Normal)
  elseif IsFull and self.bInFullState and not self:IsAnimationPlaying(self.Progress_Full_Loop) and not self:IsAnimationPlaying(self.Progress_Full_In) then
    self:PlayAnimation(self.Progress_Full_Loop)
  end
end

function M:OnFullInFinished()
  if self.bInFullState then
    self:PlayAnimation(self.Progress_Full_Loop)
  end
end

function M:StopFullAnims()
  if self:IsAnimationPlaying(self.Progress_Full_In) then
    self:StopAnimation(self.Progress_Full_In)
  end
  if self:IsAnimationPlaying(self.Progress_Full_Loop) then
    self:StopAnimation(self.Progress_Full_Loop)
  end
end

return M
