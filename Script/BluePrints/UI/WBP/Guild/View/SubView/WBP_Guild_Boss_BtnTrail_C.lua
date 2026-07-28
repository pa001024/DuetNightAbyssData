require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClick)
  self.MenuAnchor.OnGetMenuContentEvent:Bind(self, self.OnGetMenuContent)
  self.MenuAnchor.OnMenuOpenChanged:Clear()
  self.MenuAnchor.OnMenuOpenChanged:Add(self, self.OnMenuOpenChanged)
  self._MenuWidget = nil
end

function M:Destruct()
  self.Btn_Click.OnClicked:Remove(self, self.OnBtnClick)
  self.MenuAnchor.OnGetMenuContentEvent:Unbind()
  self._MenuWidget = nil
end

function M:Init(Params)
  self.Owner = Params.Owner
  self:SetMenuData({
    Title = Params.Title,
    Desc = Params.Desc
  })
  local Progress = tonumber(Params.Progress) or 0
  local MaxProgress = tonumber(Params.MaxProgress) or 0
  local DisplayPercent = MaxProgress > 0 and math.min(100, Progress / MaxProgress * 100) or 0
  if 0 == DisplayPercent then
    self.Text_Percent:SetText("0")
  else
    self.Text_Percent:SetText(string.format("%.1f", DisplayPercent))
  end
  local Texture = LoadObject(Params.Icon)
  self.Image_Icon:SetBrushFromTexture(Texture)
  if MaxProgress > 0 and Progress >= MaxProgress then
    self.Icon_Finish:SetVisibility(UIConst.VisibilityOp.Visible)
  else
    self.Icon_Finish:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:PlayAnimation(self.Normal)
end

function M:SetMenuData(Data)
  self._MenuData = Data
end

function M:OnBtnClick()
  self.MenuAnchor:Open(true)
end

function M:OnGetMenuContent()
  if not IsValid(self._MenuWidget) then
    self._MenuWidget = UIManager(self):CreateWidget("/Game/UI/WBP/Guild/Widget/Boss/WBP_Guild_Boss_TrialTip.WBP_Guild_Boss_TrialTip")
  end
  if self._MenuWidget.Init then
    self._MenuWidget:Init(self._MenuData or {})
  end
  if self.IsGamepadView then
    self._MenuWidget.Panel_Controller:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self._MenuWidget.Panel_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  return self._MenuWidget
end

function M:OnMenuOpenChanged(IsOpen)
  if IsOpen then
    self.Owner.IsOpenTrailTip = true
    self.Owner:UpdateFocusState(3)
  else
    self.Owner.IsOpenTrailTip = false
    self.Owner:UpdateFocusState(2)
    self:SetFocus()
  end
end

function M:RefreshGamepadView()
  self.IsGamepadView = true
  if self._MenuWidget then
    self._MenuWidget.Panel_Controller:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:RefreshKeyboardView()
  self.IsGamepadView = false
  if self._MenuWidget then
    self._MenuWidget.Panel_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

return M
