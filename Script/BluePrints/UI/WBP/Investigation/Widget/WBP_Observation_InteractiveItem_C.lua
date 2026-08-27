require("UnLua")
local IconPath = "MaterialInstanceConstant'/Game/UI/WBP/Common/VX/Battle/MI_Battle_ObserverIcon.MI_Battle_ObserverIcon'"
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
    self.Key:SetVisibility(ESlateVisibility.Hidden)
  else
    self.Key:SetVisibility(ESlateVisibility.Collapsed)
  end
  self.Text_Interactive:SetText(GText("UI_MECHANISM_104"))
  self:BindButtonPerformances()
end

function M:InitIcon(Path)
  local Path = Path or IconPath
  rawset(self, "LoadResourceID", nil)
  self.Img_Item:SetVisibility(ESlateVisibility.Collapsed)
  local Handle = UE.UResourceLibrary.LoadObjectAsyncWithId(self, Path, {
    self,
    M.OnIconLoadFinish
  })
  if Handle then
    rawset(self, "LoadResourceID", Handle.ResourceID)
  end
end

function M:OnIconLoadFinish(Object, ResourceID)
  if not IsValid(self) or nil ~= ResourceID and rawget(self, "LoadResourceID") ~= ResourceID then
    return
  end
  if not IsValid(Object) then
    self.Img_Icon:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  self.Img_Icon:SetBrushResourceObject(Object)
  self.Img_Icon:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function M:BindEventOnClicked(Obj, Func)
  self.BindObj = Obj
  self.BindFunc = Func
end

function M:Destruct()
  self:UnBindButtonPerformances()
end

function M:OnClicked()
  if self.BindFunc then
    self.BindFunc(self.BindObj)
  end
end

function M:BindButtonPerformances()
  self.Button_Area.OnClicked:Add(self, self.OnBtnClicked)
  self.Button_Area.OnPressed:Add(self, self.OnBtnPressed)
  self.Button_Area.OnReleased:Add(self, self.OnBtnReleased)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
    self.Button_Area.OnHovered:Add(self, self.OnBtnHovered)
    self.Button_Area.OnUnhovered:Add(self, self.OnBtnUnhovered)
  end
end

function M:UnBindButtonPerformances()
  self.Button_Area.OnClicked:Clear()
  self.Button_Area.OnPressed:Clear()
  self.Button_Area.OnReleased:Clear()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
    self.Button_Area.OnHovered:Clear()
    self.Button_Area.OnUnhovered:Clear()
  end
end

function M:PlayInAnimation()
  self:StopAllAnimations()
  self:PlayAnimation(self.In)
end

function M:PlayOutAnimation()
  self:StopAllAnimations()
  self:PlayAnimation(self.Out)
end

function M:SwitchNormalAnimation()
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
end

function M:PlayButtonClickSound()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_add", nil, nil)
end

function M:PlayButtonClickAnimation()
  self:StopAllAnimations()
  self:PlayAnimation(self.Click)
end

function M:OnBtnClicked()
  self:PlayButtonClickAnimation()
  self:OnClicked()
end

function M:PlayButtonPressAnim()
  self:StopAllAnimations()
  self:PlayAnimation(self.Press)
end

function M:OnBtnPressed()
  self:PlayButtonClickSound()
  self.IsPressing = true
  self:PlayButtonPressAnim()
end

function M:PlayButtonHoverAnim()
  self:StopAllAnimations()
  self:PlayAnimation(self.Hover)
end

function M:OnBtnHovered()
  self.IsHovering = true
  self:PlayButtonHoverAnim()
end

function M:SetBtnHovered(IsHovered)
  if IsHovered then
    self:OnBtnHovered()
  else
    self:OnBtnUnhovered()
  end
end

function M:PlayButtonReleaseButHoverAnim()
  self:StopAllAnimations()
  self:PlayButtonHoverAnim()
end

function M:PlayButtonReleaseAndUnHoverAnim()
  self:StopAllAnimations()
  self:SwitchNormalAnimation()
end

function M:OnBtnReleased()
  self.IsPressing = false
  if not self.IsHovering then
    self:PlayButtonReleaseAndUnHoverAnim()
  else
    self:PlayButtonReleaseButHoverAnim()
  end
end

function M:PlayButtonUnHoverAnim()
  self:StopAllAnimations()
  self:SwitchNormalAnimation()
end

function M:OnBtnUnhovered()
  self.IsHovering = false
  if not self.IsPressing then
    self:PlayButtonUnHoverAnim()
  end
end

return M
