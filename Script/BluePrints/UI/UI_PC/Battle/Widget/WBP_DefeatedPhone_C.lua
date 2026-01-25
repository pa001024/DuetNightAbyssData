require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
M._components = {
  "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent"
}

function M:Construct()
  self.Btn_Execute.OnClicked:Add(self, self.OnClick)
end

function M:Tick(MyGeometry, InDeltaTime)
  self:RefreshPhoneExecuteBan()
end

function M:RefreshPhoneExecuteBan()
  if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
    return
  end
  if not self.Player or not self.DefeatedUI then
    return
  end
  if self.Player:DoCheckUseSkill(self.Player:GetSkillByType(UE.ESkillType.Condemn)) and self.DefeatedUI.bCanExecute and self.DefeatedUI.DefeatedCharacter and self.DefeatedUI.DefeatedCharacter.PenalizeInteractiveComponent and self.DefeatedUI.DefeatedCharacter.PenalizeInteractiveComponent:IsCanInteractive(self.Player) then
    if self.IsPlayBan then
      self:ShowBan(false)
    end
    self.IsPlayBan = false
  else
    if not self.IsPlayBan then
      self:ShowBan(true)
    end
    self.IsPlayBan = true
  end
end

function M:Show()
  if self.IsShow then
    return
  end
  self.IsShow = true
  self.Player = UGameplayStatics.GetPlayerCharacter(self, 0)
  self.IsPlayBan = false
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance:GetGameUIManager()
  self.DefeatedUI = UIManager:GetUIObj("DefeatedInteract")
  self:StopAllAnimations()
  self:SetVisibility(ESlateVisibility.Visible)
  self:PlayAnimation(self.In)
  local BattleMainUI = UIManager:GetUIObj("BattleMain")
  if BattleMainUI and BattleMainUI.Char_Skill then
    BattleMainUI.Char_Skill.Switch_Type:SetActiveWidgetIndex(0)
  end
end

function M:Hide()
  if self.IsShow == false then
    return
  end
  self.IsShow = false
  self.IsPlayBan = false
  self:StopAllAnimations()
  self:ShowBan(false)
  self:PlayAnimation(self.Out)
end

function M:ShowBan(IsShow)
  if IsShow then
    self.Image_Ban:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Image_Icon:SetOpacity(0.5)
    if self.DefeatedUI.MarkPlayLoop then
      self:StopAnimation(self.Loop)
    end
  else
    self.Image_Ban:SetVisibility(ESlateVisibility.Collapsed)
    self.Image_Icon:SetOpacity(1)
    if self.DefeatedUI.MarkPlayLoop then
      self:PlayAnimation(self.Loop, 0, 0, 0, 1, true)
    end
  end
end

function M:OnAnimationFinished(Animation)
  if Animation == self.Out then
    self:SetVisibility(ESlateVisibility.Collapsed)
  elseif Animation == self.In then
  end
end

function M:OnClick()
  local DefeatedUI = UIManager(self):GetUIObj("DefeatedInteract")
  if not DefeatedUI then
    return
  end
  if self.IsPlayBan then
    return
  end
  DefeatedUI:OnClick()
end

AssembleComponents(M)
return M
