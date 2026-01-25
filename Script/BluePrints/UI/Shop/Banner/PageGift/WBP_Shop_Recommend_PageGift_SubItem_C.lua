require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnItemClick)
  self.Btn_Click.OnHovered:Add(self, self.OnItemHovered)
  self.Btn_Click.OnUnhovered:Add(self, self.OnItemUnhovered)
  self.Btn_Click.OnPressed:Add(self, self.OnItemOnPressed)
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Content.SelfWidget = self
  self.Parent = Content.Parent
  self.TabId = Content.TabId
  self.bShowNew = Content.bShowNew
  self.Text_PoolTitle:SetText(GText(Content.TabName))
  local IconDynaMaterial = self.Image_Pool:GetDynamicMaterial()
  if IconDynaMaterial then
    local Icon = LoadObject(Content.Icon)
    IconDynaMaterial:SetTextureParameterValue("IconMap", Icon)
  end
  self:_UpdateIndicatorVisibility()
  self:BindClickEvent(Content.ClickEvent)
  if Content.bSelected then
    self:OnItemClick(true, true)
  end
end

function M:BindClickEvent(ClickEvent)
  self.ClickObj = ClickEvent.Obj
  self.ClickCallback = ClickEvent.Callback
end

function M:OnItemClick(bNotPlayMusic, bIsAutoSelect)
  if self.bSelected then
    return
  end
  if not self.ClickCallback then
    return
  end
  self.bSelected = true
  self:PlayAnimation(self.Click)
  self.ClickCallback(self.ClickObj, self.TabId, self.Content, not bNotPlayMusic, bIsAutoSelect)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and InKeyName == UIConst.GamePadKey.DPadLeft then
    self.Parent:OnGamePadDown(InKeyName)
  else
  end
end

return M
