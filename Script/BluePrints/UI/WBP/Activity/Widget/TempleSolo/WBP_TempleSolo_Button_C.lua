require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Initialize(Initializer)
  self.IsHovered = false
end

function M:Construct()
  self.Text:SetText(GText("UI_TempleEvent_EntryLevel"))
  self.Controller:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    }
  })
end

function M:OnClicked()
  self:PlayAnimation(self.Click)
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
  self:PlayAnimation(self.Hover)
end

function M:OnMouseLeave(MouseEvent)
  self:PlayAnimation(self.UnHover)
end

return M
