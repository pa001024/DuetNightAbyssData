require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})

function M:Initialize(Initializer)
  self.OwnerWidget = nil
  self.ClickCallback = nil
end

function M:Construct()
  self.Text:SetText(GText("UI_Pet_Decompose_Title"))
  self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Controller:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "RS"}
    }
  })
  self.Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Click.OnClicked:Add(self, self.OnClicked)
  self.Btn_Click.OnHovered:Add(self, self.OnHovered)
  self.Btn_Click.OnUnhovered:Add(self, self.OnUnhovered)
  self.Btn_Click.OnPressed:Add(self, self.OnPressed)
  self.Btn_Click.OnReleased:Add(self, self.OnReleased)
  self:AddInputMethodChangedListen()
  self:OnUpdateUIStyleByInputTypeChange(UIUtils.UtilsGetCurrentInputType())
end

function M:Init(OwnerWidget, Callback)
  self.OwnerWidget = OwnerWidget
  self.ClickCallback = Callback
end

function M:OnClicked()
  self:PlayAnimation(self.Click)
  if self.ClickCallback then
    self.ClickCallback(self.OwnerWidget)
  end
end

function M:OnHovered()
  self:PlayAnimation(self.Hover)
end

function M:OnUnhovered()
  self:PlayAnimation(self.UnHover)
end

function M:OnPressed()
  self:PlayAnimation(self.Press)
end

function M:OnReleased()
  self:PlayAnimation(self.Normal)
end

function M:OnUpdateUIStyleByInputTypeChange(InputType)
  self.Controller:SetVisibility(InputType == ECommonInputType.Gamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:Destruct()
  self:RemoveInputMethodChangedListen()
  self.Btn_Click.OnClicked:Remove(self, self.OnClicked)
  self.Btn_Click.OnHovered:Remove(self, self.OnHovered)
  self.Btn_Click.OnUnhovered:Remove(self, self.OnUnhovered)
  self.Btn_Click.OnPressed:Remove(self, self.OnPressed)
  self.Btn_Click.OnReleased:Remove(self, self.OnReleased)
end

return M
