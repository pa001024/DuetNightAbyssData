require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Panel_Select:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:Init(ItemData, ChooseCallback, ParentWidget)
  self.ChooseCallback = ChooseCallback
  self.ParentWidget = ParentWidget
  self.Content = ItemData
  self.ChooseDataInfo = {
    ChooseId = ItemData.StuffId,
    ChooseWidget = self
  }
  self:InitCommonView(ItemData)
end

function M:InitCommonView(ItemData)
  self.Text_Name:SetText(ItemData.StuffName)
  if ItemData.AttrIcon then
    self.Icon_Element:SetBrushResourceObject(LoadObject(ItemData.AttrIcon))
    self.Icon_Element:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Icon_Element:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  local ImgMat = self.Img_Avatar:GetDynamicMaterial()
  ImgMat:SetTextureParameterValue("MainTex", LoadObject(ItemData.StuffIcon))
  self.Btn_Check:BindEventOnClicked(self, self.OnBtnCheckClicked)
  self.Button_Area.OnClicked:Add(self, self.OnBtnChooseClicked)
  self.Btn_Check.AudioEventPath = "event:/ui/common/click_btn_small"
end

function M:SetSelected(IsSelected)
  if self.IsSelected == IsSelected then
    return
  end
  self.IsSelected = IsSelected
  self:StopAnimation(self.Hover)
  self:StopAnimation(self.UnHover)
  if IsSelected then
    self:PlayAnimation(self.Click)
  else
    self:PlayAnimation(self.Normal)
  end
end

function M:OnBtnCheckClicked()
  UIManager(self):LoadUINew("ArmoryDetail", {
    PreviewCharIds = {
      self.Content.StuffId
    },
    bFromOptRewardPreview = true,
    bHideSquadBuildBtn = true,
    EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
    bHideBoxBtn = true,
    bNoEndCamera = true,
    bHideCharAppearance = true,
    bHideWeaponAppearance = true
  })
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
  self:OnBtnChooseHovered()
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
  self:OnBtnChooseUnHovered()
end

function M:OnBtnChooseClicked()
  if UIUtils.IsGamepadInput() and self.IsSelected then
    return true
  end
  local bNewSelectState = not self.IsSelected
  local CallbackData = bNewSelectState and self.ChooseDataInfo or nil
  self.ChooseCallback(self.ParentWidget, bNewSelectState, CallbackData)
  AudioManager(self):PlayItemSound(self, self.ChooseDataInfo.ChooseId, "Click", "Char")
  return true
end

function M:OnBtnChooseHovered()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == CommonConst.CLIENT_DEVICE_TYPE.MOBILE or self.IsSelected then
    return
  end
  if not self.IsInHovered then
    self:StopAnimation(self.UnHover)
    self:PlayAnimation(self.Hover)
  end
  self.IsInHovered = true
end

function M:OnBtnChooseUnHovered()
  local bIsHovered = self.IsInHovered
  self.IsInHovered = false
  if CommonUtils.GetDeviceTypeByPlatformName(self) == CommonConst.CLIENT_DEVICE_TYPE.MOBILE or self.IsSelected then
    return
  end
  if bIsHovered then
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.UnHover)
  end
end

function M:OnAddedToFocusPath(InFocusEvent)
  if UIUtils.IsGamepadInput() then
    if not self.IsSelected then
      self:OnBtnChooseClicked()
    end
    self.ParentWidget:ScrollToTargetItem(self)
    self.ParentWidget:RefreshGamepadShortcutVisible(self)
  end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  if UIUtils.IsGamepadInput() then
    self:OnBtnChooseUnHovered()
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  return true
end

function M:CheckIsInHovered()
  return self.IsInHovered
end

function M:CanCheckDetails()
  return true
end

function M:PlayAnimationIn()
  self:SetVisibility(UE4.ESlateVisibility.Visible)
  self:PlayAnimation(self.In)
end

return M
