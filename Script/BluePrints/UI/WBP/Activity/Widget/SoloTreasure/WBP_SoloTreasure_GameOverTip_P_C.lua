require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
  self.IsWin = (...)
  self:UnbindAllFromAnimationFinished(self.Victory_In)
  self:UnbindAllFromAnimationFinished(self.Defeat_In)
  self:UnbindAllFromAnimationFinished(self.Victory_Out)
  self:UnbindAllFromAnimationFinished(self.Defeat_Out)
  self:BindToAnimationFinished(self.Victory_In, {
    self,
    function()
      self:CloseUI()
    end
  })
  self:BindToAnimationFinished(self.Defeat_In, {
    self,
    function()
      self:CloseUI()
    end
  })
  self:BindToAnimationFinished(self.Victory_Out, {
    self,
    function()
      self:Close()
    end
  })
  self:BindToAnimationFinished(self.Defeat_Out, {
    self,
    function()
      self:Close()
    end
  })
  if self.IsWin then
    self.Panel_Victory:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Panel_Defeat:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_TitleNum:SetText(GText("UI_Extraction_TM_25"))
    self:PlayAnimation(self.Victory_In)
  else
    self.Panel_Victory:SetVisibility(ESlateVisibility.Collapsed)
    self.Panel_Defeat:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_TitleNum_1:SetText(GText("UI_Extraction_TM_26"))
    self:PlayAnimation(self.Defeat_In)
  end
end

function M:OnLoaded(...)
end

function M:CloseUI()
  if self.IsWin then
    self:PlayAnimation(self.Victory_Out)
  else
    self:PlayAnimation(self.Defeat_Out)
  end
end

return M
