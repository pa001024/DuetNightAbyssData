require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Text_Btn:SetText(GText("UI_Consumable_Get_Confirm"))
  self.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    }
  })
  self.Button_Area.OnClicked:Add(self, self.OnBtnClicked)
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType())
  else
    self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
  end
  self.ShouldShow = false
end

function M:Destruct()
  self.Button_Area.OnClicked:Remove(self, self.OnBtnClicked)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
  self.ClickEventObj = nil
  self.ClickEventFunc = nil
  self.ClickEventParams = nil
end

function M:BindEventOnClicked(Obj, Func, ...)
  if not Obj or type(Func) ~= "function" then
    return
  end
  self.ClickEventObj = Obj
  self.ClickEventFunc = Func
  self.ClickEventParams = {
    ...
  }
end

function M:UnBindEventOnClicked(Obj, Func)
  if self.ClickEventObj ~= Obj or self.ClickEventFunc ~= Func then
    return
  end
  self.ClickEventObj = nil
  self.ClickEventFunc = nil
  self.ClickEventParams = nil
end

function M:OnBtnClicked()
  if self.ClickEventObj and self.ClickEventFunc then
    self.ClickEventFunc(self.ClickEventObj, table.unpack(self.ClickEventParams or {}))
  end
end

function M:PlayAnimationIn()
  if self.ShouldShow then
    return
  end
  self.ShouldShow = true
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  self:SetVisibility(UE4.ESlateVisibility.Visible)
  self:PlayAnimation(self.In)
end

function M:PlayAnimationOut()
  if not self.ShouldShow then
    return
  end
  self.ShouldShow = false
  self:PlayAnimation(self.Out)
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation ~= self.Out then
    return
  end
  if self.ShouldShow then
    self:SetVisibility(UE4.ESlateVisibility.Visible)
    self:PlayAnimation(self.In)
  else
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  local Visibility = CurInputDevice == ECommonInputType.Gamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  self.Key_GamePad:SetVisibility(Visibility)
end

return M
