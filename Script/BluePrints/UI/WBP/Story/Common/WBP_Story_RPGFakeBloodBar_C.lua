require("UnLua")
local BloodBarUtils = require("BluePrints.UI.BloodBar.BloodBarUtils")
local M = Class("BluePrints.UI.BP_UIState_C")

function M:OnLoaded(...)
  self.BossName, self.PlayerName = ...
  self:InitDisplayBossUI()
  self:AddTeammateUI()
  M.Super:OnLoaded(...)
end

function M:InitDisplayBossUI()
  self.IsBossInPart = false
  self.ShowES = false
  self.IsShowToughnessBar = false
  self.PhaseValues = {1}
  local SizeBoxSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.SizeBoxBar)
  self.BloodBarLenght = SizeBoxSlot:GetSize().X
  self.SizeBox_BossHP:ClearChildren()
  self.HpBar = BloodBarUtils.LoadSubWidget(self, self.SizeBox_BossHP, "HPBar", true, self.BloodBarLenght, 1)
  self.Boss_Part:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.SizeBox_Toughness:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self:SetPanelTipVisibility(UE4.ESlateVisibility.Collapsed)
  self.Num_Lv_BP_1:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Num_Lv_BP:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Name_Boss_Part:SetText(GText(self.BossName))
  self:SetDisplayBossHpPercent(1, false)
  self:PlayAnimation(self.Bar_In)
end

function M:SetDisplayBossHpPercent(Percent, bPlayDeduct)
  if not self.HpBar then
    return
  end
  if nil == bPlayDeduct then
    bPlayDeduct = true
  end
  Percent = math.clamp(Percent or 0, 0, 1)
  self.LastDisplayBossHpPercent = self.DisplayBossHpPercent or self.BossHpPercent or 1
  self.DisplayBossHpPercent = Percent
  self.BossHpPercent = Percent
  if self.HpBar.SetBarPercent then
    self.HpBar:SetBarPercent(Percent)
  end
  if bPlayDeduct and Percent < self.LastDisplayBossHpPercent and self.HpBar.PlayDeduct then
    self.HpBar:PlayDeduct(false)
  end
end

function M:AddTeammateUI()
  self.VB_Teammate_Phantom:ClearChildren()
  local TeammateUI = self:CreateWidgetNew("TeammateBloodBar")
  TeammateUI:InitRPGDisplayConfig(self.PlayerName)
  self.VB_Teammate_Phantom:AddChildToVerticalBox(TeammateUI)
  local VBSlot = UE4.UWidgetLayoutLibrary.SlotAsVerticalBoxSlot(TeammateUI)
  if VBSlot then
    local Margin = FMargin(0, 0, 0, 0)
    local Platform = CommonUtils:GetDeviceTypeByPlatformName(self)
    if "PC" == Platform then
      Margin.Top = 10
    end
    VBSlot:SetPadding(Margin)
  end
  self.VB_Teammate_Phantom:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:PlayAnimation(self.In)
end

function M:SetPanelTipVisibility(Option)
  if self.PanelTipVisibility == Option then
    return
  end
  self.PanelTipVisibility = Option
  self.PanelTip:SetVisibility(Option)
  if self.PanelTipText then
    self.PanelTipText:SetVisibility(Option)
  end
  if Option == UE4.ESlateVisibility.Collapsed then
    local Padding = self.HB_Buff_BP.Slot.Padding
    Padding.Top = self.Buff_BP_TopOffset_NoTips
    self.HB_Buff_BP.Slot:SetPadding(Padding)
    self.TakeDownTip:SetText(GText("UI_BOSSBATTLE_TAKEDOWN"))
  else
    local Padding = self.HB_Buff_BP.Slot.Padding
    Padding.Top = self.Buff_BP_TopOffset_HaveTips
    self.HB_Buff_BP.Slot:SetPadding(Padding)
    self.VX_percent_L:SetRenderTranslation(FVector2D(-self.ToughnessWeakLength * 1 + self.ToughnessWeakLength / 2, 0))
    self.VX_percent_R:SetRenderTranslation(FVector2D(self.ToughnessWeakLength * 1 + -self.ToughnessWeakLength / 2, 0))
  end
end

function M:UnLoadSelf()
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance and GameInstance:GetGameUIManager()
  UIManager:UnLoadUINew("FakeBloodBar")
end

return M
