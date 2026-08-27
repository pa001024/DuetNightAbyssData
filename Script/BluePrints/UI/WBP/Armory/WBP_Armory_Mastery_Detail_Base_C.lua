local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local M = Class("BluePrints.UI.BP_UIState_C")
M._components = {
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent"
}

function M:ReceiveEnterState(StackAction)
  M.Super.ReceiveEnterState(self, StackAction)
  if self.IsInited then
    self.Armory_Mastery:ReceiveEnterState(StackAction)
    self.Armory_MasteryWindow:ReceiveEnterState(StackAction)
  end
end

function M:Construct()
  M.Super.Construct(self)
  self.Image_Click.OnMouseButtonDownEvent:Unbind()
  self.Image_Click.OnMouseButtonDownEvent:Bind(self, self.On_Image_Click_MouseButtonDown)
end

function M:InitUIInfo(Name, IsInUIMode, EventList, Params)
  M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Params)
  local CharUuid = Params.CharUuid
  local Target = Params.Target
  self.OnClosedObj = Params.OnClosedObj
  self.OnClosedCallback = Params.OnClosedCallback
  self.OnDestructCallback = Params.OnDestructCallback
  self.OnDestructObj = Params.OnDestructObj
  local Avatar = ArmoryUtils:GetAvatar()
  self.Target = Avatar.Chars[Params.Target.Uuid]
  Params.Target = self.Target
  self.ExtraMasteryWeaponTags = Params.WeaponTags or {}
  local ArmoryMain = UIManager(self):GetArmoryUIObj()
  if ArmoryMain and ArmoryMain.ActorController then
    self.ActorController = ArmoryMain.ActorController
    self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char, nil, ArmoryUtils.ArmorySubTabNames.WeaponMastery, "Detail")
  end
  self.Armory_Mastery.WS_State:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  Params.Parent = self
  self.Armory_Mastery:Init(Params)
  self.Armory_MasteryWindow:Init(Params)
  self.Armory_Mastery.MasteryBtns[3]:SetIsSelected(true)
  self:PlayInAnim()
  self.IsInited = true
end

function M:OnExtraMasteryClicked(WeaponTags)
  self.Armory_MasteryWindow:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Armory_MasteryWindow:RefreshMasteryItems(WeaponTags)
end

function M:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
  return self:OnPointerDown(MyGeometry, MouseEvent)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  return self:OnPointerUp(MyGeometry, MouseEvent)
end

function M:OnMouseMove(MyGeometry, MouseEvent)
  return self:OnPointerMove(MyGeometry, MouseEvent)
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
  return self:OnPointerUp(MyGeometry, InTouchEvent)
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
  return self:OnPointerMove(MyGeometry, InTouchEvent)
end

function M:OnMouseCaptureLost()
  self:OnPointerCaptureLost()
end

function M:OnBackgroundClicked()
  self:OnCloseBtnClicked()
end

function M:OnCloseBtnClicked()
  self:PlayOutAnim()
end

function M:PlayInAnim()
  self:StopAnimation(self.Out)
  self:PlayAnimation(self.In)
  self:StopAnimation(self.Detail_Out)
  self:UnbindAllFromAnimationFinished(self.Detail_In)
  self:BindToAnimationFinished(self.Detail_In, {
    self,
    self.OnInAnimationFinished
  })
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  self:PlayAnimation(self.Detail_In)
  self:SetVisibility(UIConst.VisibilityOp.Visible)
  AudioManager(self):PlayUISound(self, "event:/ui/common/skill_panel_expand", "MasteryPanel", nil)
end

function M:OnInAnimationFinished()
  self:BlockAllUIInput(false)
end

function M:PlayOutAnim()
  self:BlockAllUIInput(true)
  self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self:StopAnimation(self.In)
  self:StopAnimation(self.Detail_In)
  self:UnbindAllFromAnimationFinished(self.Detail_Out)
  self:BindToAnimationFinished(self.Detail_Out, {
    self,
    self.OnOutAnimationFinished
  })
  self:PlayAnimation(self.Detail_Out)
  if self.OnClosedCallback then
    self.OnClosedCallback(self.OnClosedObj)
  end
  AudioManager(self):SetEventSoundParam(self, "MasteryPanel", {ToEnd = 1})
end

function M:OnOutAnimationFinished()
  self:BlockAllUIInput(false)
  self:Close()
end

function M:Destruct()
  self:BlockAllUIInput(false)
  self.Image_Click.OnMouseButtonDownEvent:Unbind()
  self:UnbindAllFromAnimationFinished(self.Out)
  self:UnbindAllFromAnimationFinished(self.Detail_Out)
  self:UnbindAllFromAnimationFinished(self.Detail_In)
  if self.OnDestructCallback then
    self.OnDestructCallback(self.OnDestructObj)
  end
end

AssembleComponents(M)
return M
