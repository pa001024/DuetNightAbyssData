require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Aera.OnClicked:Add(self, self.OnButtonClicked)
  self.Btn_Aera.OnHovered:Add(self, self.OnButonHovered)
  self.Btn_Aera.OnUnhovered:Add(self, self.OnButonUnhovered)
  self.Btn_Aera.OnPressed:Add(self, self.OnButonPressed)
end

function M:Destruct()
  self.Btn_Aera.OnClicked:Clear()
  self.Btn_Aera.OnHovered:Clear()
  self.Btn_Aera.OnUnhovered:Clear()
  self.Btn_Aera.OnPressed:Clear()
end

function M:InitContent(Content)
  self.CallbackObj = Content.CallbackObj
  self.ClickedCallback = Content.ClickedCallback
  self.HoverCallback = Content.HoverCallback
  self.UnHoverCallback = Content.UnHoverCallback
  self.PressCallback = Content.PressCallback
  self.Parent = self.CallbackObj
  self.AddToFocusPathObj = Content.AddToFocusPathObj
  self.AddToFocusPathCallback = Content.AddToFocusPathCallback
end

function M:OnButtonClicked()
  if self.ClickedCallback then
    self.ClickedCallback(self.CallbackObj)
  end
end

function M:OnButonHovered()
  if self.HoverCallback then
    self.HoverCallback(self.CallbackObj)
  end
end

function M:OnButonUnhovered()
  if self.UnHoverCallback then
    self.UnHoverCallback(self.CallbackObj)
  end
end

function M:OnButonPressed()
  if self.PressCallback then
    self.PressCallback(self.CallbackObj)
  end
end

function M:OnAddedToFocusPath()
  if self.AddToFocusPathObj then
    self.AddToFocusPathCallback(self.AddToFocusPathObj, self)
  end
end

return M
