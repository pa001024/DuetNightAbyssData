require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

local function FormatPercentForDisplay(PercentVal)
  local Val = tonumber(PercentVal) or 0
  local OneDecimal = math.floor(Val * 10 + 1.0E-9) / 10
  if OneDecimal <= 0 then
    return "0", false
  end
  local IntPart = math.floor(OneDecimal + 1.0E-9)
  if math.abs(OneDecimal - IntPart) < 1.0E-9 then
    return tostring(IntPart), true
  end
  return string.format("%.1f", OneDecimal), true
end

function M:InitContent(Content)
  self.Content = Content
  self.Text_Effect:SetText(Content.Text_Effect or "")
  self.Text_Condition:SetText(Content.Text_Condition or "")
  if Content.IconPath and self.Image_Icon then
    local Texture = LoadObject(Content.IconPath)
    if Texture then
      self.Image_Icon:SetBrushFromTexture(Texture)
    end
  end
  local PercentVal = tonumber(Content.Percent) or 0
  self.Percent = PercentVal
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  self.IsInDungeon = GameState and GameState:IsInDungeon() or false
  self:RefreshPercentDisplay(PercentVal)
  if PercentVal >= 100 then
    self:PlayFinishIn()
  else
    self:PlayAnimation(self.Normal)
  end
  self:SetEmptyState(false)
end

function M:SetEmptyState(bEmpty, EmptyTextMapId)
  if self.WS_Type then
    self.WS_Type:SetActiveWidgetIndex(bEmpty and 1 or 0)
  end
  if bEmpty and self.Text_Empty and EmptyTextMapId then
    self.Text_Empty:SetText(GText(EmptyTextMapId))
  end
end

function M:RefreshPercentDisplay(PercentVal)
  local Text, ShowPlus = FormatPercentForDisplay(PercentVal)
  self.Text_Percent:SetText(Text)
  if ShowPlus and self.IsInDungeon then
    self.Text_Plus:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.IsShowPlus = true
  else
    self.Text_Plus:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.IsShowPlus = false
  end
end

function M:UpdatePercent(Percent)
  local NewVal = tonumber(Percent) or 0
  local OldVal = tonumber(self.Percent) or 0
  if NewVal > OldVal then
    self.Percent = NewVal
    self:RefreshPercentDisplay(NewVal)
    if NewVal >= 100 then
      self:PlayFinishIn()
      self.Text_Plus:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:PlayFinishIn()
  DebugPrint("WBP_Guild_Boss_TrialProgressItem_C: PlayFinishIn")
  AudioManager(self):PlayUISound(self, "event:/ui/common/association_boss_strategy_point_check", nil, nil)
  self:PlayAnimation(self.Finish_In)
end

function M:ChangeItemState(State)
  if State then
    self:PlayAnimation(self.Open)
  else
    self:PlayAnimation(self.Close)
  end
end

return M
