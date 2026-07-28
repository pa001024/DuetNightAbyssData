require("UnLua")
local RacingOutsiderModel = require("BluePrints.UI.WBP.Activity.Widget.Racing.Outsider.RacingOutsiderModel")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self:InitView()
  self.IsForbidden = false
  self:AddInputMethodChangedListen()
  self:RefreshOpInfoByInputDevice()
end

function M:InitView()
  self:SetIcon()
  self:SetBetCount()
  self.Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Menu"}
    }
  })
end

function M:SetIcon()
  local IconResourceId = tonumber(DataMgr.RaceLotteryConstant.RaceLotteryCurrency.ConstantValue)
  local IconPath = DataMgr.Resource[IconResourceId].Icon
  local IconDice = LoadObject(IconPath)
  self.Icon_Currency.Img_Icon:SetBrushResourceObject(IconDice)
end

function M:SetBetCount()
  self.Text_Price:SetText(RacingOutsiderModel:GetNowBetCount())
  local CurDay = CommonUtils.GetRaceLotteryAlreadyOpenDays()
  local MaxInfo = DataMgr.RaceLotteryMaxStake[CurDay] or {}
  local MaxNum = MaxInfo.MaxStake or DataMgr.RaceLotteryMaxStake[1].MaxStake
  if RacingOutsiderModel:GetNowBetCount() == MaxNum then
    self:ForbidBtn(true)
  else
    self:ForbidBtn(false)
  end
end

function M:ForbidBtn(IsForbid)
  if IsForbid == self.IsForbidden then
    return
  end
  if self.IsForbidden == false and true == IsForbid then
    self.IsForbidden = true
    self:PlayButtonForbidAnim()
  elseif self.IsForbidden == true and false == IsForbid then
    self.IsForbidden = false
    self:PlayButtonUnForbidAnim()
  end
end

function M:PlayButtonForbidAnim()
  self:StopAllAnimations()
  self:DestroyAllAnmations()
  self:PlayAnimation(self.Forbidden)
end

function M:PlayButtonUnForbidAnim()
  if self.IsHovering then
    self:PlayAnimation(self.Hover)
  else
    self:PlayAnimation(self.Normal)
  end
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
  if self.IsForbidden then
    return
  end
  self.IsHovering = true
  self:StopAnimation(self.UnHover)
  self:PlayAnimation(self.Hover)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
  if self.IsForbidden then
    return
  end
  self.IsHovering = false
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.UnHover)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if self.IsForbidden then
    return
  end
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.Press)
  return UWidgetBlueprintLibrary.Unhandled()
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  if self.IsForbidden then
    return
  end
  self:PlayAnimation(self.Click)
  return UWidgetBlueprintLibrary.Unhandled()
end

function M:AddInputMethodChangedListen()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
  if UIUtils.IsGamepadInput() then
    self:InitGamepadView()
  elseif UIUtils.IsKeyboardInput() then
    self:InitKeyboardView()
  end
end

function M:InitGamepadView()
  self.Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:InitKeyboardView()
  self.Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

return M
