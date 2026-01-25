require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self:InitBtnEvent()
  EventManager:AddEvent(EventID.MountsItemOnClick, self, self.MountsItemOnClick)
end

function M:Destruct()
  EventManager:RemoveEvent(EventID.MountsItemOnClick, self)
end

function M:MountsItemOnClick(SelectMountId)
  if self.IsSelect and self.MountId ~= SelectMountId then
    self.IsSelect = false
    self:PlayBtnAnimation("Normal")
  end
end

function M:OnListItemObjectSet(Content)
  if Content.IsEmpty then
    self.Switch_Type:SetActiveWidgetIndex(2)
  elseif Content.HasMount then
    self.Switch_Type:SetActiveWidgetIndex(0)
  else
    self.Switch_Type:SetActiveWidgetIndex(1)
  end
  self.MountId = Content.MountId
  self.MountConfig = self.MountId and DataMgr.Mount[self.MountId]
  self.MountsMain = Content.MountsMain
  self.ItemIndex = Content.ItemIndex
  self.HasMount = Content.HasMount
  self.IsEmpty = Content.IsEmpty
  self.IsSelect = self.MountsMain:GetDisplayMountId() == self.MountId
  if self.IsSelect then
    self:PlayBtnAnimation("Click")
  else
    self:PlayAnimation(self.In)
  end
  self:InitMountItemUIDisplay()
end

function M:InitMountItemUIDisplay()
  if not self.MountConfig then
    return
  end
  self.Text_Name_Normal:SetText(GText(self.MountConfig.MountName))
  self.Text_Name_None:SetText(GText(self.MountConfig.MountName))
  local Obj = LoadObject(self.MountConfig.MountIcon)
  if Obj then
    self.Image_Icon_Normal:SetBrushResourceObject(Obj)
    self.Image_Icon_None:SetBrushResourceObject(Obj)
  end
end

function M:InitBtnEvent()
  self.Btn_Item.OnClicked:Clear()
  self.Btn_Item.OnHovered:Clear()
  self.Btn_Item.OnUnhovered:Clear()
  self.Btn_Item.OnPressed:Clear()
  self.Btn_Item.OnReleased:Clear()
  self.Btn_Item.OnClicked:Add(self, self.OnMountsItemBtn_OnClicked)
  self.Btn_Item.OnHovered:Add(self, self.OnMountsItemBtn_OnHovered)
  self.Btn_Item.OnUnhovered:Add(self, self.OnMountsItemBtn_OnUnhovered)
  self.Btn_Item.OnPressed:Add(self, self.OnMountsItemBtn_OnPressed)
end

function M:PlayBtnAnimation(BtnState)
  if self.HasMount then
    self:PlayAnimation(self[BtnState])
  else
    self:PlayAnimation(self["Forbidden_" .. BtnState])
  end
end

function M:OnMountsItemBtn_OnClicked()
  if self.IsSelect then
    return
  end
  self.IsSelect = true
  self:PlayBtnAnimation("Click")
  EventManager:FireEvent(EventID.MountsItemOnClick, self.MountId)
end

function M:OnMountsItemBtn_OnHovered()
  self.IsHovered = true
  if self.IsSelect then
    return
  end
  self:PlayBtnAnimation("Hover")
end

function M:OnMountsItemBtn_OnUnhovered()
  self.IsHovered = false
  if self.IsSelect then
    return
  end
  self:PlayBtnAnimation("UnHover")
end

function M:OnMountsItemBtn_OnPressed()
  if self.IsSelect then
    return
  end
  self:PlayBtnAnimation("Press")
end

function M:OnAnimationFinished(Animation)
  if Animation == self.Forbidden_UnHover or Animation == self.UnHover then
    self:PlayBtnAnimation("Normal")
  elseif Animation == self.In then
    self:PlayBtnAnimation("Normal")
  end
end

return M
