require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  UIUtils.InitDefinitionTextWidget(self, self.Text_SuitDesc, "ExplanationId")
end

function M:InitUIInfo(DetailInfo)
  self:StopAllAnimations()
  self.IsActive = DetailInfo.IsActive
  local RomanNum = Const.RomanNum[DetailInfo.TextGroupLevel]
  self.Text_Lv:SetText(RomanNum)
  self.WS_IsActive:SetActiveWidgetIndex(self.IsActive)
  self.ExplanationId = DetailInfo.ExplanationId
  local DetailInfoWithLine = GText(DetailInfo.TextSuitDesc)
  if self.ExplanationId ~= nil and #self.ExplanationId > 0 and UIUtils.IsGamepadInput() then
    self.Btn_Click:SetForbidden(false)
  else
    self.Btn_Click:SetForbidden(true)
  end
  self.Text_SuitDesc:SetText(DetailInfoWithLine)
  local bPlayingAnim = false
  if DetailInfo.IsUnlockFeedback then
    self:PlayAnimation(self.Unlock_Feedback)
    bPlayingAnim = true
  elseif 0 == self.IsActive then
    local RichText = "<Warning>" .. DetailInfo.TextCurrentNum .. "</>" .. "/" .. DetailInfo.TextUnlockNum
    self.Text_SuitNum:SetText(RichText)
    self:PlayAnimation(self.Lock)
    bPlayingAnim = true
  elseif 1 == self.IsActive then
    local RichText = "<G>" .. DetailInfo.TextCurrentNum .. "</>" .. "/" .. DetailInfo.TextUnlockNum
    self.Text_SuitNum:SetText(RichText)
    self:PlayAnimation(self.Unlocked)
    bPlayingAnim = true
  elseif 2 == self.IsActive then
    local RichText = "<G>" .. DetailInfo.TextCurrentNum .. "</>" .. "/" .. DetailInfo.TextUnlockNum
    self.Text_SuitNum:SetText(RichText)
    AudioManager(self):PlayUISound(self, "event:/ui/roguelike/suit_pre_active", nil, nil)
    self:PlayAnimation(self.Pre_Unlock)
    bPlayingAnim = true
  end
  self.Parent = DetailInfo.Parent
  self.Btn_Click.OnClicked:Add(self, self.OnBtn_ClickClicked)
  self.Btn_Click.OnHovered:Add(self, self.OnBtn_ClickHover)
  if self.In and not bPlayingAnim then
    self:PlayAnimation(self.In)
  end
end

function M:OnBtn_ClickClicked()
  if not self.ExplanationId then
    return
  end
  if UIUtils.IsGamepadInput() then
    UIUtils.OnDefinitionLinkClicked(self, self.ExplanationId)
  end
end

function M:OnBtn_ClickHover()
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:AddDelayFrameFunc(function()
      self:SelectItem()
    end, 1)
    if self.Parent and type(self.Parent.OnHoverItemChange) == "function" then
      self.Parent:OnHoverItemChange(self)
    end
    if self.Parent and self.Parent.ScrollBox_Suit then
      self.Parent.ScrollBox_Suit:ScrollWidgetIntoView(self.CurrentHoverItem, true, UE4.EDescendantScrollDestination.Center)
    end
  end
end

function M:SelectItem()
  DebugPrint("检测到被选中")
  self.IsSelected = true
  if self.Parent then
    self.Parent.CurrentSelectSuitItem = self
  end
  if self.Parent and self.Parent.SelectSuitItem then
    self.Parent:SelectSuitItem(self)
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  if CurInputType == ECommonInputType.Gamepad then
    if self.DefinitionWidget and IsValid(self.DefinitionWidget) then
      self.DefinitionWidget:SetFocus()
    end
    if self.ExplanationId ~= nil and #self.ExplanationId > 0 then
      self.Btn_Click:SetForbidden(false)
    end
  else
    self.Btn_Click:SetForbidden(true)
  end
end

return M
