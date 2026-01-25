local WBP_Battle_Version_C = Class({
  "BluePrints.UI.BP_UIState_C"
})

function WBP_Battle_Version_C:Construct()
  self:InitVersionDisplay()
end

function WBP_Battle_Version_C:IsInternalBuild()
  if UE.URuntimeCommonFunctionLibrary.IsDistribution() then
    return false
  end
  if UE.URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
    return true
  end
  return true
end

function WBP_Battle_Version_C:InitVersionDisplay()
  if not self:IsInternalBuild() then
    self:SetVisibility(UE.ESlateVisibility.Collapsed)
    return
  end
  local versionText = UE.AHotUpdateGameMode.GetTotalVersionNumber()
  if "" == versionText then
    versionText = "编辑器状态，未获取到版本号"
  end
  if self.Text_Version then
    self.Text_Version:SetText(GText(versionText))
  end
  self:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
end

function WBP_Battle_Version_C:RefreshVersionInfo()
  self:InitVersionDisplay()
end

function WBP_Battle_Version_C:Show()
  self:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
end

function WBP_Battle_Version_C:Hide()
  self:SetVisibility(UE.ESlateVisibility.Collapsed)
end

return WBP_Battle_Version_C
