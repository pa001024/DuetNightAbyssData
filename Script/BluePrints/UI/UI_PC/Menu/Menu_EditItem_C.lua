require("UnLua")
local Menu_EditItem_C = Class({
  "Blueprints.UI.BP_UIState_C"
})

function Menu_EditItem_C:Initialize(Initializer)
  self.Super.Initialize(self)
end

function Menu_EditItem_C:OnLoaded(...)
end

function Menu_EditItem_C:Construct()
  self:InitButton()
end

function Menu_EditItem_C:OnMouseEnter(MyGeometry, MouseEvent)
  if self.CurBtnContent.Id then
    self.Owner.BtnIdx = self.CurBtnContent.Id - 1
  end
  self:StopAnimation(self.UnHover)
  self:PlayAnimation(self.Hover)
end

function Menu_EditItem_C:OnMouseLeave(MyGeometry, MouseEvent)
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.UnHover)
end

function Menu_EditItem_C:OnClicked()
  self.Owner:OnListBtnClicked(self.CurBtnContent)
end

function Menu_EditItem_C:OnListItemObjectSet(Content)
  self.CurBtnContent = Content
  self.CurBtnContent.SelfWidget = self
  self.Owner = Content.ParentWidget
  self.BtnName = Content.BtnName
  self.ReddotName = Content.ReddotName
  self.Text_Cell:SetText(GText(Content.BtnName))
  self.IsChangePortrait = Content.IsChangePortrait
  if Content.BtnClickFunction then
    self.Button_Area.OnClicked:Add(self, Content.BtnClickFunction)
    self.Button_Area:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  if self.ReddotName then
    ReddotManager.AddListener(self.ReddotName, self, self.OnReddotChange)
  end
end

function Menu_EditItem_C:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and InKeyName == UIConst.GamePadKey.FaceButtonRight then
    IsEventHandled = true
    self.Owner:OnClickEdit()
  end
  return IsEventHandled
end

function Menu_EditItem_C:SetStytle(Hover)
  if Hover then
    self:PlayAnimation(self.Hover)
  else
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.UnHover)
  end
end

function Menu_EditItem_C:RemoveContentClickListener()
  if self.CurBtnContent and self.CurBtnContent.BtnClickFunction then
    self.Button_Area.OnClicked:Remove(self, self.CurBtnContent.BtnClickFunction)
  end
end

function Menu_EditItem_C:CleanupListItem()
  if self.ReddotName then
    ReddotManager.RemoveListener(self.ReddotName, self)
    self.New:SetEnable(false)
  end
  self:RemoveContentClickListener()
  if self.CurBtnContent and self.CurBtnContent.SelfWidget == self then
    self.CurBtnContent.SelfWidget = nil
  end
  self.CurBtnContent = nil
  self.Owner = nil
  self.ReddotName = nil
end

function Menu_EditItem_C:BP_OnEntryReleased()
  self:CleanupListItem()
end

function Menu_EditItem_C:OnReddotChange(Count)
  self.New:SetEnable(Count > 0)
end

function Menu_EditItem_C:Destruct()
  self:CleanupListItem()
  self.Super.Destruct(self)
end

function Menu_EditItem_C:OnFocusReceived(MyGeometry, InFocusEvent)
  if not self.GameInputModeSubsystem or UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
  end
  return UIUtils.Handled
end

return Menu_EditItem_C
