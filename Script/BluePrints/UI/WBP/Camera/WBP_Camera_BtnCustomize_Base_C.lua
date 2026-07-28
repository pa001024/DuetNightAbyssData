require("UnLua")
local Utils = require("BluePrints.UI.WBP.Camera.CameraCustomizeUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  Utils.BindClick(self.Btn_Click, self, self.OnBtnClicked)
  if self.Btn_Click and self.Btn_Click.OnHovered then
    self.Btn_Click.OnHovered:Add(self, self.OnBtnHovered)
  end
  if self.Btn_Click and self.Btn_Click.OnUnhovered then
    self.Btn_Click.OnUnhovered:Add(self, self.OnBtnUnhovered)
  end
  if self.Btn_Click and self.Btn_Click.OnPressed then
    self.Btn_Click.OnPressed:Add(self, self.OnBtnPressed)
  end
  if self.Btn_Click and self.Btn_Click.OnReleased then
    self.Btn_Click.OnReleased:Add(self, self.OnBtnReleased)
  end
end

function M:Init(Config, Owner)
  self.Config = Config or {}
  self.OwnerPanel = Owner
  Utils.SetText(self.Text_Button, self.Config.Text or "自定义")
  self:RefreshInputStyle(false)
  self:RefreshNewState(false)
end

function M:RefreshNewState(bVisible)
  Utils.SetNew(self.New, true == bVisible)
end

function M:RefreshInputStyle(bUseGamePad)
  if self.WS_Type and self.WS_Type.SetActiveWidgetIndex then
    self.WS_Type:SetActiveWidgetIndex(bUseGamePad and 1 or 0)
  end
  if self.Key and self.Key.CreateCommonKey then
    self.Key:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Text",
          Text = self.Config and self.Config.PCKey or "T"
        }
      },
      bDisableResetWhenChangeDevice = true
    })
  end
  if self.Key_Controller and self.Key_Controller.CreateCommonKey then
    self.Key_Controller:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = self.Config and self.Config.GamePadKey or "Menu"
        }
      },
      bDisableResetWhenChangeDevice = true
    })
  end
end

function M:OnBtnClicked()
  if self.Click then
    self:PlayAnimation(self.Click)
  end
  if self.OwnerPanel and self.OwnerPanel.OnCustomizeClicked then
    self.OwnerPanel:OnCustomizeClicked()
  end
end

function M:OnBtnHovered()
  if self.Hover then
    self:PlayAnimation(self.Hover)
  end
end

function M:OnBtnUnhovered()
  if self.UnHover then
    self:PlayAnimation(self.UnHover)
  end
end

function M:OnBtnPressed()
  if self.Press then
    self:PlayAnimation(self.Press)
  end
end

function M:OnBtnReleased()
  if self.Normal then
    self:PlayAnimation(self.Normal)
  end
end

return M
